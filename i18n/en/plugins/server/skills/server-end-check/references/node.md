> Translation. Source: [plugins/server/skills/server-end-check/references/node.md](../../../../../../../plugins/server/skills/server-end-check/references/node.md). Update this file when the source changes. Claude does not read this file.

# Node: end check

Read by `server-end-check`.

## Missing migrations

| Tool | Command (fail if the model changed but there is no migration) |
| --- | --- |
| Prisma | `npx --no-install prisma migrate diff --from-migrations prisma/migrations --to-schema prisma/schema.prisma --exit-code` → fail if 2 |
| Drizzle | `npx --no-install drizzle-kit generate`, then fail if `git status --porcelain <output folder>` shows new files (do not delete the generated files; report them) |
| TypeORM | Fail if `npx --no-install typeorm migration:generate <temp path> -d <DataSource>` creates a file (delete the temp file) |
| Atlas | `atlas migrate validate` |

## Config key patterns

`process.env.`, `import.meta.env.`, the project's config schema (e.g. `@nestjs/config`).
