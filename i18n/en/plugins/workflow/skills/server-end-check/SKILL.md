---
name: server-end-check
description: Wrap-up check for backend and Supabase projects. Called by the review step of the workflow plugin's start skill. Only when server code or Supabase changed, checks missing migrations, migration order, config keys missing from docs, and Supabase checks (db diff, advisors, types, keys), and returns api-reviewer and supabase-reviewer to add to the review.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> Translation. Source: [plugins/workflow/skills/server-end-check/SKILL.md](../../../../../../plugins/workflow/skills/server-end-check/SKILL.md). Update this file when the source changes. Claude does not read this file.

# Server end check

Called by the `start` skill's review step. Runs commands and returns only the results. Review that reads and judges code is done by `workflow:api-reviewer` and `workflow:supabase-reviewer`. Report in the project's language.

## 0. Applicability

- Detect with the same criteria as `server-start-check`, and decide the migration owner with the same rules.
- If `git diff --name-only <base>...HEAD` has no server code, migrations, `supabase/`, or config files, and no added line has code that calls Supabase (`.from(`, `.rpc(`, `.channel(`, `auth.`, `storage.`) either, return only "No server changes". Changes that call Supabase from browser code are also in scope for this check.

## 1. Checks (only when applicable)

Run database commands only against a local or development DB. If it looks like production, do not run them and tell the user. If a needed check tool is missing, install and use it: pin the version, and use a way that does not change project files or global installs. First use the tools this document names (Supabase CLI: `npx -y supabase@<version>`) and tools the project already lists as dependencies. If another tool is needed, do not ask: use a proven one (widely used and maintained) the same way, and write its name and source in the result. If it cannot be installed, write "tool not installed".

### Missing migrations and order

A schema change must ship with a migration. If schema-related code changed:

- **Missing migration:** use the check the project defines (CLAUDE.md, package.json or Makefile scripts). If there is none, use the owning tool's drift check command. For tools that compare against the DB, apply the migrations to the local DB first (otherwise a difference shows up even when nothing is missing). A reported difference is a failure. If there is no way to check, write "could not check" and pass it to the reviewer.
- **If the Supabase CLI is the owner:** apply locally with `supabase migration up`, then `supabase db diff`. Passes only if the output is empty; if it prints SQL, failure (a change not in a migration file; use the output as evidence).
- **Order:** if new migrations landed on the base branch while you worked, the new file's timestamp or number must come after the newest file on the base branch. Otherwise, failure.

### Config keys, value files, keys

Run `bash ${CLAUDE_SKILL_DIR}/scripts/config-check.sh <base>`. Each line it prints is a failure: an environment variable newly read in added lines is missing from `.env.example`, a committed value file such as `.env`, or a key in added lines (`sb_secret_`, a JWT whose role is not anon, a secret key name in a public-prefixed environment variable). If it exits with 2, record the reason in its error output as "could not check". The script compares names only and writes only file names for keys. So that key values never enter the conversation, use only that output as evidence.

### Supabase

Only when files under `supabase/` or code that calls Supabase (`.from(`, `.rpc(`, `.channel(`, `auth.`, `storage.`) changed. Checks that need the DB run only while the local stack is running (`supabase status`; if it is off, start it with `supabase start` and say that you did. Do not stop it).

- **advisors:** `supabase db advisors`. A finding newly introduced by this change is a failure.
- **Types** (when a generated types file exists): generate `supabase gen types typescript --local` into a temp file with the same options and compare. A difference is a failure (regenerate and commit).
- **Keys:** whether client code uses a secret key is for `workflow:supabase-reviewer` (the script above checks key patterns).

## 2. Agents to add to the review

- If server code (routes, handlers, services, authorization, queries) or server migrations changed, `workflow:api-reviewer`. Evidence: changed files, new migration files.
- If the Supabase scope above changed, `workflow:supabase-reviewer`. Evidence: changed files, new migration files, advisors findings, whether the local stack is running.

## 3. After fixes

If migrations were fixed, rerun the relevant step 1 checks.

## Return format

```markdown
### server end check
Migration owner: prisma
Checks: 1 failure (others passed)
- src/orders/webhook.ts:12 — 새 환경 변수 STRIPE_WEBHOOK_SECRET 이 .env.example 에 없음 (new environment variable missing from .env.example)

#### Agents to add to the review
- `workflow:api-reviewer` — evidence: src/orders/*.ts, prisma/migrations/2026…/migration.sql

#### After fixes
- …
```

If there are no failures, write "Checks: all passed" on one line.
