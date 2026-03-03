# OpenClaw Security Hardening

> OpenClaw AI 助手系统安全加固实践项目

## 📊 项目概述

本项目是基于慢雾安全团队《OpenClaw 极简安全实践指南 v2.7》的完整实施案例，展示了如何从 **C 级（需要改进）** 提升到 **B 级（良好）** 的安全等级。

## ✨ 特性

- 🛡️ **完整的安全规则体系** - 红线/黄线命令分类
- 🔐 **配置完整性校验** - SHA256 哈希基线
- 👁️ **自动安全巡检** - 13项核心指标
- 📋 **Skill/MCP 审计协议** - 6步审计流程
- 💾 **Git 灾备备份** - 自动备份到 GitHub

## 🚀 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/flourishzenith/openclaw-security-hardening.git
cd openclaw-security-hardening
```

### 2. 配置环境

```bash
# 复制脚本到 OpenClaw 目录
cp scripts/*.sh ~/.openclaw/workspace/scripts/
chmod +x ~/.openclaw/workspace/scripts/*.sh

# 复制文档
cp docs/*.md ~/.openclaw/workspace/docs/
```

### 3. 生成哈希基线

```bash
sha256sum ~/.openclaw/openclaw.json > ~/.openclaw/.config-baseline.sha256
sha256sum ~/.openclaw/devices/paired.json >> ~/.openclaw/.config-baseline.sha256
```

### 4. 配置 Cron Jobs

```bash
# 安全巡检（每天 03:00）
openclaw cron add \
  --name "OpenClaw 每日安全巡检" \
  --cron "0 3 * * *" \
  --tz "Asia/Hong_Kong" \
  --session isolated \
  --message "Execute bash ~/.openclaw/workspace/scripts/nightly-security-audit.sh"

# 自动备份（每天 02:00）
openclaw cron add \
  --name "OpenClaw 每日自动备份" \
  --cron "0 2 * * *" \
  --tz "Asia/Hong_Kong" \
  --session isolated \
  --message "Execute bash ~/.openclaw/workspace/scripts/auto-backup.sh"
```

## 📁 项目结构

```
openclaw-security-hardening/
├── README.md                          # 项目说明
├── LICENSE                            # MIT 许可证
├── CONTRIBUTING.md                    # 贡献指南
├── .gitignore                         # Git 忽略规则
├── scripts/
│   ├── nightly-security-audit.sh      # 安全巡检脚本
│   └── auto-backup.sh                  # 自动备份脚本
└── docs/
    ├── SKILL-MCP-AUDIT-PROTOCOL.md     # Skill 审计协议
    └── SECURITY-HARDENING-COMPLETE.md  # 完成报告
```

## 📊 实施成果

| 任务 | 状态 | 完成时间 |
|------|------|----------|
| 安全规则制定 | ✅ | 2026-03-03 |
| 哈希基线生成 | ✅ | 2026-03-03 |
| 自动安全巡检 | ✅ | 2026-03-03 |
| 审计协议建立 | ✅ | 2026-03-03 |
| 灾备系统配置 | ✅ | 2026-03-03 |

## 🛡️ 安全规则

### 🔴 红线命令（必须确认）

- 破坏性操作：`rm -rf /`、`mkfs`、`dd if=`
- 认证篡改：修改 `openclaw.json`、`paired.json`
- 外发数据：`curl` 携带 token、反弹 shell
- 代码注入：`base64 -d | bash`、`eval "$(curl ...)`

### 🟡 黄线命令（记录执行）

- `sudo` 任何操作
- `npm install -g`、`pip install`
- `systemctl restart/start/stop`
- `openclaw cron add/edit/rm`

## 📚 文档

- [完整实施报告](docs/SECURITY-HARDENING-COMPLETE.md)
- [Skill 审计协议](docs/SKILL-MCP-AUDIT-PROTOCOL.md)
- [贡献指南](CONTRIBUTING.md)

## 🎯 安全等级

| 阶段 | 等级 | 说明 |
|------|------|------|
| 加固前 | ⚠️ C 级 | 缺少系统性安全框架 |
| 加固后 | ✅ B 级 | 完整的安全防护体系 |

## 🔗 参考资源

- [OpenClaw Security Practice Guide](https://github.com/slowmist/openclaw-security-practice-guide)
- [慢雾科技](https://slowmist.com)
- [@evilcos (余弦)](https://x.com/evilcos)

## 📝 许可证

MIT License - 详见 [LICENSE](LICENSE)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

**项目状态**：✅ 完成
**最后更新**：2026-03-03
