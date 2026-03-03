# 贡献指南

感谢您对 OpenClaw 安全加固项目的关注！

## 如何贡献

### 报告问题
如果您发现了 bug 或有安全建议，请：
1. 创建 Issue 描述问题
2. 提供复现步骤
3. 附上相关日志（脱敏）

### 提交改进
1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

### 安全准则
- **不要**提交任何敏感信息（token、密钥、密码）
- **不要**提交个人路径、IP 地址、用户名
- **要**使用占位符替换敏感信息
- **要**测试脚本在通用环境下的可用性

## 代码规范

### Shell 脚本
- 使用 `set -euo pipefail`
- 添加详细的注释
- 使用有意义的变量名
- 错误处理要完善

### 文档
- 使用 Markdown 格式
- 保持简洁明了
- 提供示例代码
- 及时更新

## 安全优先

在提交任何更改前，请确保：
1. 不引入新的安全风险
2. 不暴露敏感信息
3. 通过安全扫描
4. 保持向后兼容

## 许可证

所有贡献都将采用 MIT 许可证。
