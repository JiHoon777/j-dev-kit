---
name: server-end-check
description: Wrap-up check for backend and Supabase projects. Called by the end mode of the workflow plugin's task skill. Only when server code or Supabase changed, checks missing migrations, migration order, API spec compatibility (oasdiff), config keys missing from docs, and Supabase checks (db diff, advisors, types, keys), and returns api-reviewer and rls-reviewer to add to the review.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> Translation. Source: [plugins/server/skills/server-end-check/SKILL.md](../../../../../../plugins/server/skills/server-end-check/SKILL.md). Update this file when the source changes. Claude does not read this file.

# Server end check

Called by `/task end`. Runs commands and returns only the results. Reviews that read code and make judgments are done by `server:api-reviewer` and `server:rls-reviewer`. Report in the project's language.

## 0. Applicability

- Detect with the same criteria as `server-start-check`, and decide the migration owner with the same rules. Read the matching references to the end with the Read tool (`node.md`, `python.md`, `go.md`, `jvm.md`, `supabase.md` in `${CLAUDE_SKILL_DIR}/references/`).
- If `git diff --name-only <base>...HEAD` contains no server code, migrations, API specs, `supabase/`, or config files, return only "No server changes".

## 1. Checks (only when applicable)

Run database commands only against local or development DBs. If it looks like production, do not run them and say so. Use only project tools that are installed (`npx --no-install`, etc.). If missing, record "tool not available".

- **Missing migrations** (when schema-related code changed): the owning tool's command (reference).
- **Migration order** (when there are new migrations): did new migrations land on the base branch while you were working? For timestamped files, the new file must be later than the newest file on `origin/<base>`. For tools with multiple heads, see the reference.
- **API spec** (when there is an OpenAPI spec and it changed): if `oasdiff` is available, `oasdiff breaking --fail-on ERR <base spec> <new spec>` (the base spec is `git show origin/<base>:<path>`). Breaking changes are not a failure but evidence to pass to the reviewer. If not available, pass the two paths to the reviewer. If the spec is generated from code, run `git diff --exit-code <spec>` after generating; a difference is a failure.
- **Config keys:** if an environment variable newly read in added lines (patterns in the reference) is not in `.env.example`, fail. Compare names only and do not read values. If a value file such as `.env` is committed, fail.
- The checks in the reference.

## 2. Agents to add to the review

- If server code (routes, handlers, services, authorization, queries), API specs, or server migrations changed, `server:api-reviewer`. Evidence: changed files, new migration files, oasdiff result (or the two spec paths).
- If supabase.md returns it, `server:rls-reviewer`.

## 3. After fixing

If you fixed migrations or specs, rerun the corresponding checks from step 1.

## Return format

```markdown
### server end check
Migration owner: prisma
Checks: 1 failure (rest passed, skipped: oasdiff not available)
- .env.example — missing new key STRIPE_WEBHOOK_SECRET

#### Agents to add to the review
- `server:api-reviewer` — evidence: src/orders/*.ts, prisma/migrations/2026…/migration.sql

#### After fixing
- …
```

If there are no failures, write a single line: "Checks: all passed".
