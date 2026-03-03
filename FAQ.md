# 常见问题

## 一般问题

### Q: 这个项目适合谁使用？

A: 适合所有使用 OpenClaw AI 助手的用户，特别是关心系统安全的开发者。

### Q: 需要什么基础？

A: 需要基本的 Shell 脚本知识和 Git 操作经验。

### Q: 安装需要多长时间？

A: 大约 30 分钟可以完成所有配置。

## 安装和配置

### Q: 如何修改 Cron Job 时间？

A: 使用 `openclaw cron add` 命令重新添加，或使用 `openclaw cron update` 更新现有任务。

### Q: SSH 密钥如何配置？

A: 参考 [GitHub SSH 密钥文档](https://docs.github.com/zh/authentication/connecting-to-github-with-ssh)

### Q: 如何验证备份是否成功？

A: 检查 `/tmp/openclaw-backup-<date>.log` 日志文件。

## 安全问题

### Q: 红线和黄线命令有什么区别？

A: 红线命令**必须**先向人类确认，黄线命令可以执行但**必须记录**。

### Q: 如何处理 Skill 审计发现的问题？

A: 根据问题严重性，可以选择拒绝安装、联系作者修复或自行审查后使用。

### Q: 哈希基线如何更新？

A: 当配置文件合法变更后，重新运行：
```bash
sha256sum ~/.openclaw/openclaw.json > ~/.openclaw/.config-baseline.sha256
```

## 故障排除

### Q: Cron Job 未运行？

A: 检查步骤：
1. `openclaw cron list` - 查看任务状态
2. `openclaw cron runs <id>` - 查看运行历史
3. 检查脚本权限：`ls -la ~/.openclaw/workspace/scripts/`

### Q: Git 推送失败？

A: 常见原因：
- SSH 密钥未配置
- 网络连接问题
- GitHub 权限问题

解决方法：
```bash
# 测试 SSH 连接
ssh -T git@github.com

# 查看详细错误
GIT_SSH_COMMAND="ssh -v" git push origin master
```

### Q: 脚本执行失败？

A: 手动运行查看错误：
```bash
bash -x ~/.openclaw/workspace/scripts/nightly-security-audit.sh
```

## 高级问题

### Q: 可以自定义检查项吗？

A: 可以，编辑 `nightly-security-audit.sh` 脚本添加或删除检查项。

### Q: 如何备份到其他 Git 平台？

A: 修改 `auto-backup.sh` 中的 `GITHUB_REPO` 变量。

### Q: 如何还原备份？

A: 参考项目 README 中的恢复流程章节。

## 社区

### Q: 如何报告问题？

A: 在 GitHub Issues 中提交，请提供：
- 问题描述
- 复现步骤
- 相关日志（脱敏）
- 环境信息

### Q: 如何贡献？

A: 参考 [CONTRIBUTING.md](CONTRIBUTING.md)

---

如果你有其他问题，欢迎在 [GitHub Discussions](https://github.com/flourishzenith/openclaw-security-hardening/discussions) 中提问。
