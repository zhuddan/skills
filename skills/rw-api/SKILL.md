---
name: rw-api
description: 为 retentio-webapp 项目根据 API 文档生成接口请求代码。当用户要求"根据文档创建 API""为某模块创建 api""参考 docs/api_zh.md 创建接口"时使用。从 docs/api_zh.md 的某个章节提取接口，生成 src/api/<resource>.ts（请求函数）与 src/modules/<resource>/<resource>.schema.ts（类型/DTO）。
---

# rw-api：从 API 文档生成接口代码

将 `docs/api_zh.md` 中某一章节的接口，转换为两份代码：

1. `src/modules/<resource>/<resource>.schema.ts` — 类型定义（实体、请求 DTO、响应 DTO）
2. `src/api/<resource>.ts` — 请求函数，从 schema 导入类型

## 流程

1. **确认范围**：用户会指明文档中的章节（如 "## 4. 标签"）。读取该章节，列出所有接口（方法 + 路径 + 请求体 + 响应）。若用户说明某些接口不处理（如"不需要创建卡组"），跳过它们。

2. **参考现有约定**：动手前阅读 `src/api/decks.ts` 与 `src/modules/decks/decks.schema.ts`，严格沿用其风格。

3. **写 schema 文件**：`src/modules/<resource>/<resource>.schema.ts`
   - 实体接口用 `export interface`，每个字段带中文 JSDoc。
   - 请求体用 `export interface XxxDTO`，可选字段用 `?`。
   - 响应统一用全局类型 `BaseApiResult<Data, Meta>` 包裹：`export type XxxResponseDTO = BaseApiResult<{ ... }>`。`BaseApiResult` 与 `Meta` 是全局类型，无需 import。
   - 仅当文档校验规则需要（如表单校验）才引入 `zod`；纯类型定义不要引入 zod。

4. **写 api 文件**：`src/api/<resource>.ts`
   - `import { request } from '@/utils/request'`
   - `import type { ... } from '@/modules/<resource>/<resource>.schema'` —— **只导入实际用到的类型**。
   - 每个函数一个具名导出，带中文 JSDoc 说明。
   - GET：`request<ResponseDTO>('/api/...')`，不传 method。
   - POST/PATCH：传 `method` 与 `body: JSON.stringify(data)`。
   - PUT/DELETE（无请求体）：只传 `method`。
   - 路径参数用模板字符串：`` `/api/decks/${deckId}/tags/${tagId}` ``。

5. **验证**：对两个文件运行 `pnpm eslint <file>`（项目用 pnpm，禁止 npm/yarn），修掉所有告警——尤其是"已声明但未使用"的多余 import。

## 命名约定

- 函数名按动作：`getAllTags` / `getTag` / `createTag` / `updateTag` / `deleteTag`；关联类用 `associateXToY` / `removeXFromY` / `getYTags`。
- 响应类型名：单条 `XxxResponseDTO`，列表 `XxxListResponseDTO`，删除 `DeleteXxxResponseDTO`。

## 参考样例

api 文件（`src/api/decks.ts` 风格）：

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
```

schema 文件（`src/modules/decks/decks.schema.ts` 风格）：

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

## 注意

- 不处理用户明确排除的接口。
- 不改动无关代码，不管 git 工作区。
- 只创建/修改这两类文件，不做多余的事。
