# CLAUDE.md

## Communication

- Always reply to me in Chinese (始终使用中文回答我).

---

# Base Rules

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

> Note: This rule applies when the requirement is ambiguous. When I give clear instructions, the "Execution Style" section below takes precedence — act directly, don't ask first.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.


# Project Collaboration Rules

## Execution Style
- When I provide a code snippet, an explicit path, or clear intent: implement it
  directly. Don't ask clarifying questions, don't present option menus, and don't
  do broad exploration. In this case, this overrides "present multiple
  interpretations" from Rule 1 above.
- Only when the requirement itself is ambiguous (no goal, no constraints) does
  Rule 1 apply: confirm assumptions before acting.
- When you need to read files, read only the directly relevant ones, then make the change.
- Don't give me 4 options to choose from — unless I explicitly ask for a comparison,
  move forward autonomously.

## Debugging & Bug Fixes
- Diagnose the root cause and explain it before changing any code.
- Don't patch symptoms (e.g., randomly adding a semicolon, or editing tests to make
  them pass).
- On errors, check config-level causes first (e.g., ESLint circular dependency,
  stale .next cache, Turbopack OOM, missing SWC binary) before applying surface fixes.

## TypeScript / Types
- No `any` in source; use explicit types.
- Prefer types exported by libraries (e.g., next-themes' UseThemeProps) instead of
  defining your own interface.
- Prop types must match the component's actual interface (watch for things like
  label vs title).

## UI Layout
- Prefer pure grid/flex layouts; don't add unnecessary wrapper divs (no space-y-2
  wrapper around grid items).
- Use HeroUI v3 API patterns for components (Modal/Select/Tabs).

## Git
- Use conventional commit format for commits.
- Trust you to analyze the diff and write the commit message autonomously, without
  asking me each time.
