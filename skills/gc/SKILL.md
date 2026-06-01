---
name: gc
description: '分析待提交文件，按逻辑拆分多次提交，输出最简化 commit msg。基于 Conventional Commits 规范，自动分组文件生成多条单行 commit message，不主动执行 git add/commit，必须等用户确认。'
license: MIT
---

# Git Commit 拆分助手 (gc)

## 概述

本技能是 `/git-commit` 的包装器。先调用 git-commit 完成 diff 分析和 commit message 生成，再叠加 gc 独有的限制条件。

## 执行流程

### 1. 调用 git-commit 技能

先通过 Skill 工具调用 `git-commit`，获取其 diff 分析结果和 commit message 生成逻辑。

### 2. 叠加 gc 独有限制

在 git-commit 的结果基础上，应用以下约束：

**拆分多次提交：**
- 分析所有变更文件，按逻辑关联性拆分为多组，每组对应一次独立提交
- 同一功能/模块的文件 → 合并为一组
- 不同模块的独立变更 → 拆分为不同组
- 纯文档变更与代码变更 → 拆分为独立提交
- 配置文件变更（package.json、tsconfig 等）→ 单独一组
- 测试文件与其对应的源文件 → 合并为一组
- 多个不相关的 bug 修复 → 每个 bug 独立一组

**仅单行 commit message：**
- 只保留 `<type>[scope]: <description>` 格式
- **禁止** body 和 footer（不输出 `[optional body] [optional footer(s)]`）
- 描述使用中文、祈使语气、≤72 字符

**不主动提交：**
- **禁止**自动执行 `git add`
- **禁止**自动执行 `git commit`
- 必须等用户明确确认后才能执行

**安全规则（同 git-commit）：**
- 不修改 git config
- 不执行破坏性命令（`--force`、hard reset）
- 不跳过 hooks（`--no-verify`）除非用户明确要求
- 不 force push 到 main/master
- 不提交敏感文件（.env、credentials.json、private keys）

### 3. 输出格式

以分组形式展示拆分结果，等待用户确认：

```
## 📋 提交计划

### Commit 1
- type: feat
- scope: auth
- description: 新增手机号验证码登录
- files:
  - src/auth/phoneLogin.ts
  - src/auth/phoneLogin.test.ts

### Commit 2
- type: docs
- scope: api
- description: 更新登录接口文档
- files:
  - docs/api/auth.md
```

输出后询问用户是否执行，**仅在用户明确确认后才逐组执行 `git add` + `git commit`**。
