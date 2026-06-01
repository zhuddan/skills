# skills

个人 skill 集合，遵循 [agentskills.io](https://agentskills.io) 标准。

## 安装

### 一键同步（推荐，新设备用）

无需 clone，直接远程拉取 `install.sh` 执行，会装上「我自己的 + 第三方」全部 skill：

```bash
curl -fsSL https://raw.githubusercontent.com/zhuddan/skills/main/install.sh | bash
```

本地已 clone 时也可以：

```bash
pnpm run setup
```

### 单独安装

```bash
# 安装所有 skill
npx skills add zhuddan/skills

# 只安装某一个
npx skills add zhuddan/skills --skill hello

# 全局安装
npx skills add zhuddan/skills -g
```

## Skills 列表

| skill | 说明 |
|-------|------|
| test  | 测试 skill 是否加载成功 |
| hello | 打招呼，返回"你好" |
