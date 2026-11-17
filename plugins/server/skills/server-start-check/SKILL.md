---
name: server-start-check
description: Pre-work check for backend projects, called by the start mode of the workflow plugin's task skill. Detects the language, framework, and migration tool, then runs the common checks (environment variables, local services) and the language checks from the matching reference file (node.md, python.md, go.md, jvm.md), covering install, LSP, migration status, and baseline. Returns a baseline, an exploration prompt for the API and its consumers, questions, and rules during implementation.
user-invocable: false
version: "0.3.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# Server start check

Called by `/task start`. Common backend checks live here; language and migration-tool checks live in `references/`.

**This skill only runs commands to check state.** Gathering information by finding and reading code is returned as **exploration prompts** for `Explore` agents, which `/task start` launches together with its own exploration agents.

Judge each item as **pass · fail · skip (reason) · stop** and return it in the format at the end. Fixing is not this skill's job. Write the report in the project's language.

| Part | Source |
| --- | --- |
| Code diagnostics | Anthropic's official LSP plugins (`typescript-lsp`, `pyright-lsp`, `gopls-lsp`, `jdtls-lsp`, `kotlin-lsp` @claude-plugins-official) |
| Migration status | Each ORM or tool's official CLI (in the references) |
| Rules during implementation | OWASP API Security Top 10 2023, OWASP Logging Cheat Sheet |

## 0. Applicability and language detection

- If CLAUDE.md has a `stack:` line without server → "not applicable: not in stack setting".
- If the project has only `supabase/` and no server code below, this skill does not apply (the `supabase` plugin covers it).
- **Detect the language and read its reference.** For each match, **read the file in full with the Read tool and run its checks as well**. If none matches → "not applicable: no server code".

  | Detected | Language | Reference |
  | --- | --- | --- |
  | package.json has `express`, `@nestjs/core`, `fastify`, `hono`, or `koa` | Node | `${CLAUDE_SKILL_DIR}/references/node.md` |
  | `pyproject.toml` or `requirements*.txt` has `fastapi`, `django`, or `flask` | Python | `${CLAUDE_SKILL_DIR}/references/python.md` |
  | `go.mod` | Go | `${CLAUDE_SKILL_DIR}/references/go.md` |
  | `pom.xml` or `build.gradle*` has `spring-boot` | Java/Kotlin | `${CLAUDE_SKILL_DIR}/references/jvm.md` |

  In a monorepo, decide which service this item touches and work in that directory. If unclear, return it as a question.

### Migration owner

Exactly one plugin owns the migration checks. The `supabase` and `server` plugins decide it with the same rule, so the result is the same whichever runs first:

1. A server migration tool is present (`prisma/schema.prisma`, `drizzle.config.*`, a TypeORM DataSource, `alembic.ini`, Django `*/migrations/`, `atlas.hcl`, Flyway `db/migration/` or `flyway.conf`, Liquibase changelog, a golang-migrate folder) → **server** owns migrations, even if the database is Supabase Postgres.
2. Otherwise, `supabase/migrations/` exists → **supabase** owns migrations.
3. Both a server tool and SQL files in `supabase/migrations/` → the schema is managed in two places. Return it as a question ("which one is the source of truth?") and treat **server** as the owner until the user answers.

Record the owner as the first row of the report. The plugin that does not own migrations skips its migration items with "skip: migrations owned by <owner> plugin".

## 1. Environment variables and local services

- Compare the keys in `.env.example` with those in the real `.env` and list only the missing **names**. Never print values.
- If `docker-compose.yml` or `compose.yaml` exists, check with `docker compose ps` that services such as the database and cache are running. If they are stopped, ask whether to start them. If the user declines, skip the items that need the database.

## 2. Language checks (from the reference)

Run the reference's install, runtime version, LSP, migration status, and baseline checks. **Run the migration status check only when server owns migrations**; otherwise skip it with "skip: migrations owned by supabase plugin". Commands that touch a database run **only against a local or development database**. If the connection looks like production, do not run them; **stop**.

`npx --no-install` uses only tools installed in the project and never downloads. If a tool is not installed, do not install it; report "tool not installed".

## 3. API spec and consumers (handed to an exploration agent)

Only check by command whether an OpenAPI spec file (`openapi.*`, `swagger.*`) exists. Do not search for the APIs this item changes or for their consumers yourself; return the prompt below as an exploration prompt.

> Find and summarize the API this item (<item path>) will touch: where the routes are defined, the flow through controllers, handlers, services, and queries, where authentication and authorization middleware applies, and where request and response formats are defined (DTOs, schemas, the spec, and the command if the spec is generated from code). Then find the consumers of that API (frontend code in the same repository, other services, tests). Return 5–10 files that must be read. Do not edit files.

## 4. Rules during implementation (to return)

- For every new endpoint: authentication, **object-level authorization** (does the requesting user own this object), input validation (a schema: zod, class-validator, pydantic, Bean Validation), accepting only allowed fields (no mass assignment), and an upper bound on page size for lists.
- Wrap multiple writes in one transaction. Give create requests that may be retried (payments, orders) an idempotency key.
- Make schema changes as migration files (the tool's generate command). Never change the database by hand.
- Never log passwords, tokens, sessions, keys, or connection strings; mask personal data.
- Write tests first for calculation and validation logic and for authorization rules.
- Add the language rules from the reference read in step 0.

## Return format

```markdown
### server start check
| Item | Result | Evidence |
| --- | --- | --- |
| Migration owner | … | server (prisma) / supabase (supabase/migrations) |
| Detection | pass | Node · NestJS, Prisma (references/node.md read) |
| Environment variables | … | missing keys: … |
| Local services | … | docker compose: db running |
| (language rows from the reference: install, runtime, LSP, migration status) | … | … |

#### Baseline
| Check | Command | Result |
| --- | --- | --- |

#### Exploration prompts
- API and consumers: (the step 3 prompt, filled in)

#### Add to the plan
- Migration: …

#### Questions to ask
- …

#### Rules during implementation
- (step 4, plus language rules)
```

If anything is **stop**, write `stop: <reason>` above the table first.
