#!/bin/bash
# OpenClaw 自动安全巡检脚本（脱敏版本）
# 覆盖 13 项核心检查指标

set -euo pipefail

LOG_FILE="/tmp/openclaw-security-audit-$(date +%Y%m%d).log"
REPORT_FILE="/tmp/openclaw-security-report-$(date +%Y%m%d).txt"
OPENCLAW_DIR="$HOME/.openclaw"
WORKSPACE_DIR="$OPENCLAW_DIR/workspace"

echo "=================================================="
echo "🔒 OpenClaw 安全巡检"
echo "⏰ 时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=================================================="
echo ""

# 初始化报告
{
    echo "# 🔒 OpenClaw 安全巡检报告"
    echo ""
    echo "**检查时间**: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    echo "---"
    echo ""
} > "$REPORT_FILE"

# 辅助函数：添加报告
add_report() {
    echo -e "$1" >> "$REPORT_FILE"
    echo "$1"
}

# 1. OpenClaw 安全审计
echo "## 1️⃣ OpenClaw 安全审计"
add_report "## 1️⃣ OpenClaw 安全审计"

if [ -f "$OPENCLAW_DIR/openclaw.json" ]; then
    PERMS=$(stat -c "%a" "$OPENCLAW_DIR/openclaw.json" 2>/dev/null || stat -f "%A" "$OPENCLAW_DIR/openclaw.json")
    if [ "$PERMS" = "600" ]; then
        add_report "✅ **openclaw.json**: $PERMS (合规)"
    else
        add_report "⚠️ **openclaw.json**: $PERMS (应为 600)"
    fi
fi

if [ -f "$OPENCLAW_DIR/devices/paired.json" ]; then
    PERMS=$(stat -c "%a" "$OPENCLAW_DIR/devices/paired.json" 2>/dev/null || stat -f "%A" "$OPENCLAW_DIR/devices/paired.json")
    if [ "$PERMS" = "600" ]; then
        add_report "✅ **paired.json**: $PERMS (合规)"
    else
        add_report "⚠️ **paired.json**: $PERMS (应为 600)"
    fi
fi

add_report ""
echo ""

# 2. 进程与网络审计
echo "## 2️⃣ 进程与网络审计"
add_report "## 2️⃣ 进程与网络审计"

add_report "### 可疑进程检查"
if pgrep -f "nc -l\|ncat -l\|socat" > /dev/null; then
    add_report "⚠️ 发现监听进程"
else
    add_report "✅ 未发现可疑监听进程"
fi

add_report "### 反弹 shell 检查"
if pgrep -f "bash -i.*tcp\|/dev/tcp" > /dev/null; then
    add_report "🚨 发现反弹 shell"
else
    add_report "✅ 未发现反弹 shell"
fi

add_report ""
echo ""

# 3. 敏感目录变更
echo "## 3️⃣ 敏感目录变更"
add_report "## 3️⃣ 敏感目录变更"

SENSITIVE_DIRS=(
    "$OPENCLAW_DIR/devices"
    "$OPENCLAW_DIR/credentials"
    "$OPENCLAW_DIR/cron"
    "$OPENCLAW_DIR/gateways"
)

for dir in "${SENSITIVE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        RECENT=$(find "$dir" -type f -mtime -1 2>/dev/null | wc -l)
        if [ "$RECENT" -gt 0 ]; then
            add_report "⚠️ $(basename $dir): 过去 24 小时内有 $RECENT 个文件变更"
        else
            add_report "✅ $(basename $dir): 无最近变更"
        fi
    fi
done

add_report ""
echo ""

# 7. 关键文件完整性
echo "## 7️⃣ 关键文件完整性"
add_report "## 7️⃣ 关键文件完整性"

if [ -f "$OPENCLAW_DIR/.config-baseline.sha256" ]; then
    add_report "### 哈希基线校验"
    if sha256sum -c "$OPENCLAW_DIR/.config-baseline.sha256" 2>/dev/null; then
        add_report "✅ 所有关键文件完整性验证通过"
    else
        add_report "🚨 检测到文件被篡改！"
    fi
else
    add_report "⚠️ 未找到哈希基线文件"
fi

add_report ""
echo ""

# 11. 明文私钥/凭证泄露扫描
echo "## 1️⃣1️⃣ 明文私钥/凭证泄露扫描"
add_report "## 1️⃣1️⃣ 明文私钥/凭证泄露扫描"

add_report "### 扫描 workspace 目录"
SECRET_COUNT=0

if grep -r "BEGIN.*PRIVATE KEY\|sk-\|pk-\|ghp_\|gho_\|ghu_\|github_pat_" "$WORKSPACE_DIR" 2>/dev/null | head -5; then
    add_report "🚨 发现疑似私钥/凭证"
    SECRET_COUNT=$((SECRET_COUNT + 1))
else
    add_report "✅ 未发现明文私钥"
fi

add_report ""
echo ""

# 12. Skill/MCP 完整性
echo "## 1️⃣2️⃣ Skill/MCP 完整性"
add_report "## 1️⃣2️⃣ Skill/MCP 完整性"

if [ -d "$WORKSPACE_DIR/skills" ]; then
    SKILL_COUNT=$(find "$WORKSPACE_DIR/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
    add_report "### 本地 Skills: $SKILL_COUNT 个"

    FINGERPRINT_COUNT=0
    for skill in "$WORKSPACE_DIR/skills"/*; do
        if [ -f "$skill/*.sha256" ] 2>/dev/null; then
            FINGERPRINT_COUNT=$((FINGERPRINT_COUNT + 1))
        fi
    done

    add_report "### 哈希指纹: $FINGERPRINT_COUNT/$SKILL_COUNT"
fi

add_report ""
echo ""

# 13. Git 灾备检查
echo "## 1️⃣3️⃣ Git 灾备检查"
add_report "## 1️⃣3️⃣ Git 灾备检查"

if [ -d "$OPENCLAW_DIR/.git" ]; then
    add_report "### Git 状态"
    cd "$OPENCLAW_DIR" || exit 1

    if git remote -v | grep -q origin; then
        add_report "✅ 已配置 Git 远程仓库"
    else
        add_report "⚠️ 未配置 Git 远程仓库"
    fi
else
    add_report "❌ 未初始化 Git 仓库"
fi

add_report ""
echo ""

# 总结
echo "=================================================="
echo "✅ 安全巡检完成"
echo "=================================================="
echo ""
echo "📄 报告已保存到: $REPORT_FILE"
echo ""

# 保存日志
cat "$REPORT_FILE" | tee -a "$LOG_FILE"

echo "✅ 巡检完成！"
