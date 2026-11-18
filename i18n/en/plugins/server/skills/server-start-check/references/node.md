> Translation. Source: [plugins/server/skills/server-start-check/references/node.md](../../../../../../../plugins/server/skills/server-start-check/references/node.md). Update this file when the source changes. Claude does not read this file.

# Node (Express, NestJS, Fastify, Hono, Koa): start check

Read by `server-start-check`.

## Follow

- Validate request bodies at the route boundary with the project's schema library (zod, class-validator, etc.).
- NestJS: authorization with guards, `whitelist: true` on `ValidationPipe` (or the project's equivalent setting).

## Creating migrations (when the server tool is the owner)

| Tool | Command |
| --- | --- |
| Prisma | `npx --no-install prisma migrate dev --name <name>` |
| Drizzle | `npx --no-install drizzle-kit generate` |
| TypeORM | `npx --no-install typeorm migration:generate <path> -d <DataSource>` |
| Atlas | `atlas migrate diff <name>` |
