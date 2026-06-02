---
name: rw-api
description: Generate API request code for the retentio-webapp project based on API documentation. Use this skill when the user asks things like "create APIs from the documentation", "create APIs for a module", or "参考 docs/api_zh.md 创建接口". Extract endpoints from a section of docs/api_zh.md and generate both src/api/<resource>.ts (request functions) and src/modules/<resource>/<resource>.schema.ts (types/DTOs).
---

# rw-api: Generate API Code from API Documentation

Convert the APIs from a specific section of `docs/api_zh.md` into two files:

1. `src/modules/<resource>/<resource>.schema.ts` — Type definitions (entities, request DTOs, response DTOs)
2. `src/api/<resource>.ts` — Request functions that import types from the schema file

## Workflow

1. **Determine the scope**: The user will specify a section from the documentation (for example, "## 4. 标签"). Read that section and identify all endpoints (method, path, request body, response). If the user explicitly excludes certain endpoints (for example, "do not create deck-related APIs"), skip them.

2. **Follow existing conventions**: Before implementing anything, read `src/api/decks.ts` and `src/modules/decks/decks.schema.ts`, and strictly follow their style and patterns.

3. **Create the schema file**: `src/modules/<resource>/<resource>.schema.ts`
   - Define entities using `export interface`, with Chinese JSDoc comments for every field.
   - Define request payloads using `export interface XxxDTO`; optional fields should use `?`.
   - Wrap all responses with the global type `BaseApiResult<Data, Meta>`:
     `export type XxxResponseDTO = BaseApiResult<{ ... }>`
     `BaseApiResult` and `Meta` are global types and should not be imported.
   - Only import and use `zod` when validation rules from the documentation require it (for example, form validation). Do not use `zod` for pure type definitions.

4. **Create the API file**: `src/api/<resource>.ts`
   - `import { request } from '@/utils/request'`
   - `import type { ... } from '@/modules/<resource>/<resource>.schema'` — **only import the types that are actually used**.
   - Export each API as a named function with a Chinese JSDoc description.
   - GET: `request<ResponseDTO>('/api/...')` without specifying a method.
   - POST/PATCH: provide `method` and `body: JSON.stringify(data)`.
   - PUT/DELETE (without a request body): provide only `method`.
   - Use template strings for path parameters:
     `` `/api/decks/${deckId}/tags/${tagId}` ``

5. **Validate**: Run `pnpm eslint <file>` on both files (the project uses pnpm; do not use npm or yarn). Fix all warnings and errors, especially unused imports.

## Naming Conventions

- Function names should follow the action:
  `getAllTags` / `getTag` / `createTag` / `updateTag` / `deleteTag`
  Association-related functions should use:
  `associateXToY` / `removeXFromY` / `getYTags`
- Response type names:
  - Single item: `XxxResponseDTO`
  - List: `XxxListResponseDTO`
  - Delete: `DeleteXxxResponseDTO`

## Reference Examples

API file (following the style of `src/api/decks.ts`):

```ts
import { request } from '@/utils/request'
import type { CreateOrUpdateDeckDTO, DeckResponseDTO } from '@/modules/decks/decks.schema'

/**
 * 获取单个卡组
 */
export function getDeck(deckId: string) {
  return request<DeckResponseDTO>(`/api/decks/${deckId}`)
}

/**
 * 创建卡组
 */
export function createDeck(data: CreateOrUpdateDeckDTO) {
  return request<CreateOrUpdateDeckResponseDTO>('/api/decks', {
    method: 'POST',
    body: JSON.stringify(data),
  })
}
````

Schema file (following the style of `src/modules/decks/decks.schema.ts`):

```ts
/**
 * 标签
 */
export interface Tag {
  /** 标签ID */
  id: string
  /** 标签名称 */
  name: string
}

/** 创建标签请求 DTO */
export interface CreateTagDTO {
  name: string
  description?: string
}

/** 单个标签响应 DTO */
export type TagResponseDTO = BaseApiResult<{ tag: Tag }>
```

## Notes

* Do not process endpoints that the user explicitly excludes.
* Do not modify unrelated code or interact with the git working tree.
* Only create or modify these two file types. Do not perform any unnecessary work.

