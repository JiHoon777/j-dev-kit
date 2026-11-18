---
name: server-start-check
description: Pre-work check for backend and Supabase projects. Called by the start mode of the workflow plugin's task skill. Detects the language (Node, Python, Go, Java/Kotlin), Supabase usage, and the migration owner, and returns what to follow during implementation and what to put in the plan. Language- and Supabase-specific content is in references.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> Translation. Source: [plugins/server/skills/server-start-check/SKILL.md](../../../../../../plugins/server/skills/server-start-check/SKILL.md). Update this file when the source changes. Claude does not read this file.

# Server start check

Called by `/task start`. Does not edit anything. Returns only what fits this item. Report in the project's language.

## 0. Applicability and detection

If CLAUDE.md has a `stack:` line without server, "Not applicable". Otherwise read every matching reference to the end with the Read tool. If none match, "Not applicable".

| Detection evidence | reference |
| --- | --- |
| `express`, `@nestjs/core`, `fastify`, `hono`, `koa` in package.json | `${CLAUDE_SKILL_DIR}/references/node.md` |
| `fastapi`, `django`, `flask` in `pyproject.toml` or `requirements*.txt` | `${CLAUDE_SKILL_DIR}/references/python.md` |
| `go.mod` | `${CLAUDE_SKILL_DIR}/references/go.md` |
| `spring-boot` in `pom.xml` or `build.gradle*` | `${CLAUDE_SKILL_DIR}/references/jvm.md` |
| `supabase/config.toml`, or an `@supabase/` package in package.json | `${CLAUDE_SKILL_DIR}/references/supabase.md` |

In a monorepo, decide which service this item touches. If unclear, put it under questions.

### Migration owner

Pick a single tool for schema changes. Use the first that matches.

1. Both a server migration tool (`prisma/schema.prisma`, `drizzle.config.*`, TypeORM DataSource, `alembic.ini`, Django `*/migrations/`, `atlas.hcl`, Flyway, Liquibase, golang-migrate folder) and `supabase/migrations/` exist → put "Which one is the source of truth?" under questions. Until answered, the server tool.
2. A server migration tool exists → the server tool (even if the DB is Supabase).
3. A `supabase/` folder exists → Supabase CLI.
4. None → no migrations.

## 1. Follow

Return only what applies to this item.

- For every new endpoint: authentication, object-level authorization (can the requesting user access this object), input schema validation, accepting only allowed fields.
- Multiple writes in one transaction. Idempotency keys for create requests that can be retried (payments, orders).
- Schema changes only through the owning tool's migration files. Do not change the DB by hand.
- Do not leave passwords, tokens, keys, or connection strings in logs or error responses.
- Do not run commands that change the real (remote) database or a deployment environment. If needed, tell the user.
- The rules in the reference.

## 2. Put in the plan / ask

- If the item changes the schema: create a migration with the owning tool (the command in the reference), regenerate types if needed.
- If the item changes the API request or response format: whether the consumers of that API (frontend, other services) also change.
- If there are two migration owners or the monorepo service is unclear, put it under questions.

## Return format

```markdown
### server start check
Detected: Node · NestJS, Supabase (read references/node.md, supabase.md). Migration owner: prisma

#### Follow
- …

#### Put in the plan
- …

#### Ask
- …
```

Leave out sections that have no content.
