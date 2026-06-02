#!/usr/bin/env bash
set -e

# 我自己的 skills（全局安装）
npx skills add zhuddan/skills -g

# 第三方
npx skills add https://github.com/anthropics/skills --skill skill-creator -g

npx skills add https://github.com/vercel-labs/skills --skill find-skills -g

npx skills add https://github.com/anthropics/skills --skill frontend-design -g

npx skills add https://github.com/vercel-labs/agent-skills --skill vercel-react-best-practices -g

npx skills add https://github.com/planetscale/database-skills --skill mysql -g

npx skills add https://github.com/mindrally/skills --skill typeorm -g

npx skills add https://github.com/github/awesome-copilot --skill git-commit -g

npx skills add https://github.com/artwist-polyakov/polyakov-claude-skills --skill ssh-remote-connection -g

skills add https://github.com/shadcn/ui --skill shadcn -g
