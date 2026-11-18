---
name: server-end-check
description: Wrap-up check for backend and Supabase projects. Called by the end mode of the workflow plugin's task skill. Only when server code or Supabase changed, checks missing migrations, migration order, API spec compatibility (oasdiff), config keys missing from docs, and Supabase checks (db diff, advisors, types, keys), and returns api-reviewer and rls-reviewer to add to the review.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> Translation. Source: [plugins/server/skills/server-end-check/SKILL.md](../../../../../../plugins/server/skills/server-end-check/SKILL.md). Update this file when the source changes. Claude does not read this file.

# Server end check

Called by `/task end`. Runs commands and returns only the results. Review that reads and judges code is done by `server:api-reviewer` and `server:rls-reviewer`. Report in the project's language.

## 0. Applicability

- Detect with the same criteria as `server-start-check`, and decide the migration owner with the same rules.
- If `git diff --name-only <base>...HEAD` has no server code, migrations, API spec, `supabase/`, or config files, return only "No server changes".

## 1. Checks (only when applicable)

Run database commands only against a local or development DB. If it looks like production, do not run them and tell the user. Use only project tools that are installed (`npx --no-install` and so on). If missing, write "tool not installed".

### Missing migrations and order

A schema change must ship with a migration. If schema-related code changed, run the owning tool's check command; if it reports a difference, that is a failure. If there are new migrations, also check the order.

| Tool | Missing migration | Order |
| --- | --- | --- |
| Prisma | `npx --no-install prisma migrate diff --from-migrations prisma/migrations --to-schema prisma/schema.prisma --exit-code` → exit code 2 is a failure (0 means no difference, 1 means error) | timestamp |
| Drizzle | After `npx --no-install drizzle-kit generate`, a new file in `git status --porcelain <output folder>` is a failure (do not delete the generated file; report it) | timestamp |
| TypeORM | If `npx --no-install typeorm migration:generate <temp path> -d <DataSource>` creates a file, failure (delete the temp file) | timestamp |
| Alembic | `alembic check` fails → failure | `alembic heads` returns two or more lines → failure (merge revision needed) |
| Django | `python manage.py makemigrations --check` fails → failure | the same command reports conflicting leaf nodes → failure (`makemigrations --merge`) |
| Atlas | `atlas migrate validate` | timestamp |
| golang-migrate | There is no check tool. See whether the schema change has a new up/down file pair | number |
| Flyway / Liquibase | Check that the schema change has a new migration file or changeset, then `flyway validate` / `liquibase validate` | version number |
| Supabase CLI | Passes only if `supabase db diff` output is empty. If it prints SQL, failure (a change in the local DB that is not in a migration file; use the output as evidence) | timestamp |

**Order (timestamp, number):** if new migrations landed on the base branch while you worked, the new file's timestamp or number must come after the newest file on `origin/<base>`. Otherwise, failure.

### API spec

When an OpenAPI spec exists and changed:

- If `oasdiff` is installed, `oasdiff breaking --fail-on ERR <base spec> <new spec>` (base spec from `git show origin/<base>:<path>`). A breaking change is not a failure but evidence to pass to the reviewer. If not installed, pass both paths to the reviewer.
- If the spec is generated from code, run the generator, then `git diff --exit-code <spec>`. A difference is a failure.

### Config keys

- If an environment variable newly read in added lines is missing from `.env.example`, failure. Compare names only; never read values.
- If a value file such as `.env` is committed, failure.

### Supabase

Only when files under `supabase/` or code that calls Supabase (`.from(`, `.rpc(`, `.channel(`, `auth.`, `storage.`) changed. Checks that need the DB run only while the local stack is running (`supabase status`; if it is off, ask whether to start it).

- **advisors:** `supabase db advisors`. A finding newly introduced by this change is a failure.
- **Types** (when a generated types file exists): generate `supabase gen types typescript --local` into a temp file with the same options and compare. A difference is a failure (regenerate and commit).
- **Keys:** `grep -rnE "sb_secret_|service_role|SERVICE_ROLE|eyJ[A-Za-z0-9_-]{20,}" --exclude-dir=node_modules --exclude-dir=build --exclude-dir=.next --exclude-dir=.svelte-kit .` Do not copy values. For an `eyJ` token, decode the middle part; if `role` is `anon`, it is fine. Failure if a secret key appears in client code or a public-prefixed environment variable, a key is hardcoded in code, migrations, or seed, or a secret file such as `supabase/functions/.env` is committed.

## 2. Agents to add to the review

- If server code (routes, handlers, services, authorization, queries), the API spec, or server migrations changed, `server:api-reviewer`. Evidence: changed files, new migration files, the oasdiff result (or the two spec paths).
- If the Supabase scope above changed, `server:rls-reviewer`. Evidence: changed files, new migration files, advisors findings, whether the local stack is running.

## 3. After fixes

If migrations or the spec were fixed, rerun the relevant step 1 checks.

## Return format

```markdown
### server end check
Migration owner: prisma
Checks: 1 failure (others passed, skipped: oasdiff not installed)
- .env.example — new key STRIPE_WEBHOOK_SECRET missing

#### Agents to add to the review
- `server:api-reviewer` — evidence: src/orders/*.ts, prisma/migrations/2026…/migration.sql

#### After fixes
- …
```

If there are no failures, write "Checks: all passed" on one line.
