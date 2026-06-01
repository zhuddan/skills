#!/usr/bin/env bash
set -e

# 我自己的 skills（全局安装）
npx skills add zhuddan/skills -g

# 第三方 skills（保持引用，重跑此脚本即可跟上游更新）
add https://github.com/vercel-labs/skills --skill find-skills -g
