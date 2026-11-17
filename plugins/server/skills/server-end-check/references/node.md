# Node: end checks

Read by `server-end-check`. Add these rows to that skill's report.

## Missing migration

| Tool | Command (model changed but no migration) |
| --- | --- |
| Prisma | `npx --no-install prisma migrate diff --from-migrations prisma/migrations --to-schema prisma/schema.prisma --exit-code` → 2 means fail. Also `npx --no-install prisma validate` |
| Drizzle | `npx --no-install drizzle-kit generate`, then a new file in `git status --porcelain <out folder>` means fail (do not delete the generated file; report it). Also `npx --no-install drizzle-kit check` |
| TypeORM | `npx --no-install typeorm migration:generate <temp path> -d <DataSource>` creating a file means fail (delete the temp file afterwards) |
| Atlas | `atlas migrate validate`, `atlas migrate lint --dev-url <dev> --latest <number of new files>` |

## Apply from scratch (only after approval)

- Prisma: `npx --no-install prisma migrate reset`
- Others: the project's reset script, or drop and re-create the development database and apply all migrations.

## Environment variables read in code

Patterns on added lines: `process.env.`, `import.meta.env.`, the project's config schema (for example `@nestjs/config` keys).

## Rows to fill

Fill the matching rows of the main table (do not add a second row):

```markdown
| Missing migration | … | `prisma migrate diff … --exit-code` 0 |
```
