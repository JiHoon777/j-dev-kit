---
name: server-start-check
description: Pre-work check for backend and Supabase projects. Called by the start mode of the workflow plugin's task skill. Detects server code, Supabase usage, and the migration owner, and returns what to follow during implementation and what to put in the plan.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> Translation. Source: [plugins/server/skills/server-start-check/SKILL.md](../../../../../../plugins/server/skills/server-start-check/SKILL.md). Update this file when the source changes. Claude does not read this file.

# Server start check

Called by `/task start`. Does not edit anything. Returns only what fits this item. Report in the project's language.

## 0. Applicability and detection

If CLAUDE.md has a `stack:` line without server, "Not applicable". If none of the following exist, also "Not applicable".

- **Server code:** a Node HTTP server dependency in package.json (express, fastify, hono, koa, @nestjs/core, etc.) or a server entry point (routes, handlers)
- **Supabase:** `supabase/config.toml`, or an `@supabase/` package in package.json

In a monorepo, decide which service this item touches. If unclear, put it under questions.

### Migration owner

Pick a single tool for schema changes. Use the first that matches.

1. Both a Node migration tool (the config file or migration folder of prisma, drizzle-kit, knex, etc.) and `supabase/migrations/` exist → put "Which one is the source of truth?" under questions. Until answered, the server tool.
2. A Node migration tool exists → that tool (even if the DB is Supabase).
3. A `supabase/` folder exists → Supabase CLI.
4. None → no migrations.

## 1. Follow

Return only what applies to this item.

- Multiple writes in one transaction. Idempotency keys for create requests that can be retried (payments, orders).
- Schema changes only through the owning tool's migration files. Do not change the DB by hand.
- Do not leave passwords, tokens, keys, or connection strings in logs or error responses.
- Do not run commands that change the real (remote) database or a deployment environment (`supabase db push`, `--linked` changes, and so on). If needed, tell the user.

## 2. Put in the plan / ask

- If the item changes the schema: create a migration with the owning tool's generate command, regenerate types if needed.
- If the item changes the API request or response format: whether the consumers of that API (frontend, other services) also change.
- If there are two migration owners or the monorepo service is unclear, put it under questions.

## Return format

```markdown
### server start check
Detected: Node · NestJS, Supabase. Migration owner: prisma

#### Follow
- …

#### Put in the plan
- …

#### Ask
- …
```

Leave out sections that have no content.
