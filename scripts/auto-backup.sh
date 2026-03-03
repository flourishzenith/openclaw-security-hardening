#!/bin/bash
# OpenClaw 自动备份脚本（脱敏版本）

set -euo pipefail

BACKUP_DIR="$HOME/.openclaw"
LOG_FILE="/tmp/openclaw-backup-$(date +%Y%m%d).log"
GITHUB_REPO="<YOUR_GITHUB_REPO>"  # 替换为你的仓库

echo "=================================================="
echo "💾 OpenClaw 自动备份"
echo "⏰ 时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=================================================="
echo ""

# 进入备份目录
cd "$BACKUP_DIR" || exit 1

# 1. 检查是否有变更
echo "🔍 检查文件变更..."
if git diff --quiet && git diff --cached --quiet; then
    echo "✅ 无变更，无需备份"
    exit 0
fi

echo "📝 发现变更，准备备份..."

# 2. 添加所有已跟踪文件的变更
echo "📦 添加文件..."
git add -u

# 3. 添加新文件（根据 .gitignore 过滤）
git add .

# 4. 创建提交
echo "💾 创建备份提交..."
COMMIT_MSG="Auto-backup: $(date '+%Y-%m-%d %H:%M:%S')

Changes:
$(git diff --stat HEAD)"

git commit -m "$COMMIT_MSG"

# 5. 推送到 GitHub
echo "🚀 推送到 GitHub..."

if [ "$GITHUB_REPO" != "<YOUR_GITHUB_REPO>" ]; then
    if git push origin master 2>&1 | tee -a "$LOG_FILE"; then
        echo "✅ 备份成功推送到 GitHub"
    else
        echo "⚠️ 推送失败，可能需要配置 SSH 密钥"
        echo "本地备份已完成，但未推送到远程"
    fi
else
    echo "⚠️ 请先设置 GITHUB_REPO 变量"
    echo "本地备份已完成"
fi

echo ""
echo "=================================================="
echo "✅ 备份完成"
echo "=================================================="
echo ""
echo "📊 备份统计:"
git log -1 --stat
