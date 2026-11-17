# Node (Express, NestJS, Fastify, Hono, Koa): start checks

Read by `server-start-check`. Add these rows and baseline lines to that skill's report.

## 1. Install and runtime

- Install without changing the lockfile: `pnpm install --frozen-lockfile` / `npm ci` / `yarn install --immutable` (yarn 2+) or `--frozen-lockfile` (yarn 1) / `bun install --frozen-lockfile`. Failure → **stop**.
- Compare `.nvmrc`, `.node-version`, or `engines.node` with `node -v`. Mismatch → fail.

## 2. LSP

Check that the `typescript-lsp` plugin is enabled and `typescript-language-server` is on PATH. If not, it is not a failure; return it as a question (the user installs it: `npm i -g typescript-language-server typescript`).

## 3. Migration status

Detect the tool and run its command. Unapplied migrations → fail (return a question about applying them). Diverged history → **stop**.

| Detected | Tool | Applied status | Model vs migrations (missing migration) |
| --- | --- | --- | --- |
| `prisma/schema.prisma` | Prisma | `npx --no-install prisma migrate status` (exit 1 when unapplied or diverged) | `npx --no-install prisma migrate diff --from-migrations prisma/migrations --to-schema prisma/schema.prisma --exit-code` (exit 2 on a difference). Prisma 7 uses the datasource in `prisma.config.ts` |
| `drizzle.config.*` | Drizzle | No status command. Compare the `drizzle.__drizzle_migrations` table with the migrations folder | `npx --no-install drizzle-kit check` (history conflicts only). Missing migrations are detected at the end check, not here |
| `typeorm` dependency + DataSource file | TypeORM | `npx --no-install typeorm migration:show -d <DataSource>` (`[ ]` = not applied) | Detected at the end check (`migration:generate` exits 1 when nothing changed) |
| `atlas.hcl` | Atlas | `atlas migrate status --url <url> --dir <dir>` | `atlas migrate validate` |

## 4. Baseline

Use the verification command from the project's CLAUDE.md. Otherwise, from package.json: `lint`, `typecheck` (or `tsc --noEmit`), `test` (not in watch mode). Record command, exit code, failure count, and failing names (first 10 if many).

## 5. Rules during implementation (to return)

- Validate request bodies with the project's schema library (zod, class-validator, …) at the route boundary.
- With NestJS, use guards for authorization and DTOs with `whitelist: true` (or the project's equivalent) so unknown fields are dropped.

## Rows to add

```markdown
| Install | … | pnpm install --frozen-lockfile |
| Node version | … | … |
| LSP | … | typescript-lsp enabled |
| Migration status | … | `prisma migrate status` exit 0 |
```
