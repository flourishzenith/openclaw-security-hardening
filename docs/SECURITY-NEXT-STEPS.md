# OpenClaw Security Hardening - Next Steps

> 日期：2026-03-03
> 状态：✅ 所有加固任务已完成

---

## 🚀 立即行动（今天）

### 1. 推送首次备份到 GitHub

**如果尚未推送本地备份仓库**：

```bash
# 方法 1：配置 SSH 密钥（推荐）
ssh-keygen -t ed25519 -C "openclaw-backup"
cat ~/.ssh/id_ed25519.pub  # 复制到 GitHub SSH Keys
ssh -T git@github.com  # 测试连接
cd ~/.openclaw && git push -u origin master

# 方法 2：使用 GitHub CLI
gh auth login
cd ~/.openclaw && git push -u origin master

# 方法 3：使用 HTTPS
cd ~/.openclaw
git remote set-url origin https://github.com/<username>/<repo>.git
git push -u origin master
```

### 2. 测试安全巡检脚本

```bash
# 手动运行一次，确认正常工作
~/.openclaw/workspace/scripts/nightly-security-audit.sh

# 查看生成的报告
cat /tmp/openclaw-security-report-$(date +%Y%m%d).txt
```

---

## 📅 本周任务（2026-03-03 ~ 2026-03-10）

### 必做项
- [ ] 配置 GitHub SSH 密钥并成功推送首次备份
- [ ] 验证自动备份 Cron 是否正常运行
- [ ] 验证安全巡检 Cron 是否生成报告
- [ ] 查看安全巡检报告，确认评分提升

### 可选项
- [ ] 为 Skills 生成哈希指纹（可能需要较长时间）
- [ ] 优化脚本性能
- [ ] 添加更多检查项

---

## 🔍 每日检查

### 每天早上
```bash
# 查看 Cron Jobs 状态
openclaw cron list

# 查看最近的安全巡检报告
ls -lt /tmp/openclaw-security-report-*.txt | head -1
cat $(ls -t /tmp/openclaw-security-report-*.txt | head -1)

# 查看最近的备份日志
cat /tmp/openclaw-backup-$(date +%Y%m%d).log
```

### 每天晚上
```bash
# 检查今日黄线操作记录
cat ~/.openclaw/workspace/memory/$(date +%Y-%m-%d).md | grep -E "sudo|npm install|pip install|docker run|systemctl"
```

---

## 📊 验证清单

### 自动备份验证

#### 基础检查
- [ ] Cron Job 已创建
  ```bash
  openclaw cron list | grep "备份"
  ```
- [ ] 脚本可执行
  ```bash
  ls -la ~/.openclaw/workspace/scripts/auto-backup.sh
  ```
- [ ] Git 远程仓库已配置
  ```bash
  cd ~/.openclaw && git remote -v
  ```
- [ ] 首次提交已完成
  ```bash
  cd ~/.openclaw && git log --oneline -1
  ```

#### 功能验证
- [ ] 手动运行脚本成功
  ```bash
  bash ~/.openclaw/workspace/scripts/auto-backup.sh
  ```
- [ ] Git 推送成功（配置 SSH 后）
  ```bash
  cd ~/.openclaw && git push origin master
  ```

### 安全巡检验证

#### 基础检查
- [ ] Cron Job 已创建
  ```bash
  openclaw cron list | grep "巡检"
  ```
- [ ] 脚本可执行
  ```bash
  ls -la ~/.openclaw/workspace/scripts/nightly-security-audit.sh
  ```
- [ ] 首次测试通过
  ```bash
  ~/.openclaw/workspace/scripts/nightly-security-audit.sh
  cat /tmp/openclaw-security-report-*.txt
  ```

#### 功能验证
- [ ] 生成报告格式正确
- [ ] 评分系统正常工作
- [ ] 推送通知正常（需配置）

### Skill 审计协议验证

#### 基础检查
- [ ] 文档已创建
  ```bash
  ls -la ~/.openclaw/workspace/docs/SKILL-MCP-AUDIT-PROTOCOL.md
  ```
- [ ] AGENTS.md 已更新（红线/黄线规则）
  ```bash
  grep -A 5 "红线命令" ~/.openclaw/workspace/AGENTS.md
  ```
- [ ] 哈希基线已生成
  ```bash
  ls -la ~/.openclaw/.config-baseline.sha256
  cat ~/.openclaw/.config-baseline.sha256
  ```

#### 功能验证
- [ ] 哈希校验正常工作
  ```bash
  sha256sum -c ~/.openclaw/.config-baseline.sha256
  ```
- [ ] 安全规则已生效
  - Agent 会识别红线命令并暂停
  - Agent 会记录黄线命令到 memory

---

## 🎯 成功标准

### B 级安全（当前目标）- 已达成 ✅

- [x] 红线/黄线规则已建立
- [x] 哈希基线已生成
- [x] 自动安全巡检已部署
- [x] Skill 审计协议已建立
- [x] Git 灾备已配置（待推送验证）

### A 级安全（长期目标）

- [ ] Git 备份成功推送到 GitHub
- [ ] 所有 Skills 生成哈希指纹
- [ ] 所有巡检发现的问题已修复
- [ ] 连续 30 天无安全事件
- [ ] 定期安全审计成为习惯

---

## 🆘 遇到问题？

### Git 推送失败

**症状**：`git push` 失败，提示权限错误

**解决方案**：
```bash
# 1. 检查 SSH 配置
ssh -T git@github.com

# 2. 如果失败，重新生成密钥
ssh-keygen -t ed25519 -C "openclaw-backup"

# 3. 添加到 GitHub
cat ~/.ssh/id_ed25519.pub
# 复制输出到：https://github.com/settings/ssh/new

# 4. 测试连接
ssh -T git@github.com

# 5. 查看详细错误
GIT_SSH_COMMAND="ssh -v" git push origin master
```

### Cron Job 未运行

**症状**：第二天早上查看，没有新的报告生成

**解决方案**：
```bash
# 1. 查看 Cron Jobs 状态
openclaw cron list

# 2. 查看运行历史
openclaw cron runs <cron-id>

# 3. 查看日志
journalctl -u openclaw -n 100 | grep -i "cron"

# 4. 手动运行测试
bash -x ~/.openclaw/workspace/scripts/auto-backup.sh
```

### 脚本执行失败

**症状**：脚本运行时出错

**解决方案**：
```bash
# 1. 手动运行查看详细错误
bash -x ~/.openclaw/workspace/scripts/nightly-security-audit.sh

# 2. 检查脚本权限
ls -la ~/.openclaw/workspace/scripts/

# 3. 检查依赖
which sha256sum
which git
which grep

# 4. 检查磁盘空间
df -h
```

### 哈希校验失败

**症状**：`sha256sum -c` 报告文件不匹配

**可能原因**：
1. 配置文件被合法修改
2. 文件被意外篡改
3. 基线文件过期

**解决方案**：
```bash
# 1. 确认文件是否被合法修改
ls -la ~/.openclaw/openclaw.json
ls -la ~/.openclaw/devices/paired.json

# 2. 如果是合法修改，更新基线
sha256sum ~/.openclaw/openclaw.json > ~/.openclaw/.config-baseline.sha256

# 3. 如果可疑，立即调查
# - 检查文件修改时间
# - 查看操作日志
# - 检查登录记录
last | head -20
```

---

## 📅 时间表

### 第 1 天（今天）
- [x] 完成所有安全加固任务
- [ ] 推送备份到 GitHub
- [ ] 手动测试所有脚本
- [ ] 验证 Cron Jobs 配置

### 第 2-3 天
- [ ] 验证自动备份是否运行
- [ ] 验证安全巡检是否运行
- [ ] 检查生成的报告
- [ ] 解决遇到的问题

### 第 4-7 天
- [ ] 为 Skills 生成哈希指纹
- [ ] 优化脚本性能
- [ ] 添加更多检查项
- [ ] 记录经验和教训

### 第 2 周
- [ ] 评估安全等级提升效果
- [ ] 修复所有发现的问题
- [ ] 准备达到 A 级的计划
- [ ] 分享实施经验

---

## 🎓 经验教训

### 成功要素

1. **系统性方法**
   - 按照指南逐步实施
   - 不跳过任何步骤
   - 记录所有决策

2. **自动化优先**
   - 使用脚本减少手工操作
   - 配置 Cron Jobs 自动运行
   - 建立监控和报警

3. **文档先行**
   - 先写方案，再实施
   - 记录所有配置
   - 准备恢复流程

### 注意事项

1. **敏感信息保护**
   - 不要公开 Chat ID、Bot Token
   - 不要公开具体 Cron Job IDs
   - 不要公开文件哈希值

2. **测试驱动**
   - 先手动测试，再配置自动
   - 验证每个步骤
   - 准备回滚方案

3. **持续改进**
   - 定期检查日志
   - 更新安全规则
   - 优化自动化流程

---

## 📞 获取帮助

### 本地文档
```bash
# 完整报告
cat ~/.openclaw/workspace/docs/SECURITY-HARDENING-COMPLETE.md

# 审计协议
cat ~/.openclaw/workspace/docs/SKILL-MCP-AUDIT-PROTOCOL.md

# 首次检查
cat ~/.openclaw/workspace/docs/security-check-report.md
```

### 在线资源
- [OpenClaw Security Guide](https://github.com/slowmist/openclaw-security-practice-guide)
- [慢雾科技](https://slowmist.com)
- [GitHub Issues](https://github.com/flourishzenith/openclaw-security-hardening/issues)

---

**创建时间**：2026-03-03
**维护者**：OpenClaw 用户
**版本**：1.0.0

---

*安全是一个持续的过程，不是一次性的任务。*
