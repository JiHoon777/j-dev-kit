> 번역본입니다. 원문은 [plugins/server/skills/server-start-check/references/node.md](../../../../../../../plugins/server/skills/server-start-check/references/node.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# Node (Express, NestJS, Fastify, Hono, Koa): 시작 점검

`server-start-check`가 읽는다. 아래 행과 기준선 줄을 그 스킬의 보고에 더한다.

## 1. 설치와 런타임

- lockfile 을 바꾸지 않고 설치한다: `pnpm install --frozen-lockfile` / `npm ci` / `yarn install --immutable` (yarn 2+) 또는 `--frozen-lockfile` (yarn 1) / `bun install --frozen-lockfile`. 실패 → **중단**.
- `.nvmrc`, `.node-version`, `engines.node`를 `node -v`와 비교한다. 맞지 않음 → 실패. 셋 다 없음 → 건너뜀("Node 버전 고정 없음").

## 2. LSP

`typescript-lsp` 플러그인이 켜져 있고 `typescript-language-server`가 PATH 에 있는지 확인한다. 아니면 실패가 아니라 질문으로 돌려준다(설치는 사용자가 한다: `npm i -g typescript-language-server typescript`).

## 3. 마이그레이션 상태

도구를 판별하고 그 명령을 돌린다. 적용 안 된 마이그레이션 → 실패(적용할지 질문으로 돌려준다). 갈라진 이력 → **중단**.

| 판별 근거 | 도구 | 적용 상태 | 모델 대 마이그레이션 (빠진 마이그레이션) |
| --- | --- | --- | --- |
| `prisma/schema.prisma` | Prisma | `npx --no-install prisma migrate status` (적용 안 됐거나 갈라졌으면 exit 1) | `npx --no-install prisma migrate diff --from-migrations prisma/migrations --to-schema prisma/schema.prisma --exit-code` (차이가 있으면 exit 2). Prisma 7은 `prisma.config.ts`의 datasource 를 쓴다 |
| `drizzle.config.*` | Drizzle | 상태 명령이 없다. `drizzle.__drizzle_migrations` 테이블과 마이그레이션 폴더를 비교한다 | `npx --no-install drizzle-kit check` (이력 충돌만). 빠진 마이그레이션은 여기가 아니라 종료 점검에서 찾는다 |
| `typeorm` 의존성 + DataSource 파일 | TypeORM | `npx --no-install typeorm migration:show -d <DataSource>` (`[ ]` = 적용 안 됨) | 종료 점검에서 찾는다 (바뀐 게 없으면 `migration:generate`가 exit 1) |
| `atlas.hcl` | Atlas | `atlas migrate status --url <url> --dir <디렉터리>` | `atlas migrate validate` |

## 4. 기준선

프로젝트 CLAUDE.md 의 검증 명령을 쓴다. 없으면 package.json 에서: `lint`, `typecheck`(또는 `tsc --noEmit`), `test`(watch 모드 말고). 명령, exit code, 실패 개수, 실패한 이름(많으면 처음 10개)을 기록한다.

## 5. 구현 중 지킬 것 (돌려줄 것)

- 요청 본문은 라우트 경계에서 프로젝트의 스키마 라이브러리(zod, class-validator, …)로 검증한다.
- NestJS 라면 인가에 guard 를 쓰고, DTO 에 `whitelist: true`(또는 프로젝트의 같은 설정)를 둬서 모르는 필드를 버린다.

## 더할 행

```markdown
| Install | … | pnpm install --frozen-lockfile |
| Node version | … | … |
| LSP | … | typescript-lsp enabled |
| Migration status | … | `prisma migrate status` exit 0 |
```
