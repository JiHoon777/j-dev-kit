---
name: server-end-check
description: Wrap-up check for backend and Supabase projects. Called by the end mode of the workflow plugin's task skill. Only when server code or Supabase changed, checks missing migrations, migration order, API spec compatibility (oasdiff), config keys missing from docs, and Supabase checks (db diff, advisors, types, keys), and returns api-reviewer and supabase-reviewer to add to the review.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> Translation. Source: [plugins/server/skills/server-end-check/SKILL.md](../../../../../../plugins/server/skills/server-end-check/SKILL.md). Update this file when the source changes. Claude does not read this file.

# Server end check

Called by `/task end`. Runs commands and returns only the results. Review that reads and judges code is done by `server:api-reviewer` and `server:supabase-reviewer`. Report in the project's language.

## 0. Applicability

- Detect with the same criteria as `server-start-check`, and decide the migration owner with the same rules.
- If `git diff --name-only <base>...HEAD` has no server code, migrations, API spec, `supabase/`, or config files, and no added line has code that calls Supabase (`.from(`, `.rpc(`, `.channel(`, `auth.`, `storage.`) either, return only "No server changes". Changes that call Supabase from browser code are also in scope for this check.

## 1. Checks (only when applicable)

Run database commands only against a local or development DB. If it looks like production, do not run them and tell the user. If a needed check tool is missing, install and use it: pin the version, and use a way that does not change project files or global installs. You may install only the tools this document names (oasdiff: `go run github.com/oasdiff/oasdiff@<version>` or `docker run --rm tufin/oasdiff:<tag>`; Supabase CLI: `npx -y supabase@<version>`) and tools the project already lists as dependencies. For any other tool, show the user its name and source and ask before installing. If it cannot be installed, write "tool not installed".

### Missing migrations and order

A schema change must ship with a migration. If schema-related code changed:

- **Missing migration:** use the check the project defines (CLAUDE.md, package.json or Makefile scripts). If there is none, use the owning tool's drift check command. For tools that compare against the DB, apply the migrations to the local DB first (otherwise a difference shows up even when nothing is missing). A reported difference is a failure. If there is no way to check, write "could not check" and pass it to the reviewer.
- **If the Supabase CLI is the owner:** apply locally with `supabase migration up`, then `supabase db diff`. Passes only if the output is empty; if it prints SQL, failure (a change not in a migration file; use the output as evidence).
- **Order:** if new migrations landed on the base branch while you worked, the new file's timestamp or number must come after the newest file on the base branch. Otherwise, failure.

### API spec

When an OpenAPI spec exists and changed:

- `oasdiff breaking --fail-on ERR <base spec> <new spec>` (base spec from `git show origin/<base>:<path>`). A breaking change is not a failure but evidence to pass to the reviewer. If it cannot be installed, pass both paths to the reviewer.
- If the spec is generated from code, run the generator, then `git diff --exit-code <spec>`. A difference is a failure.

### Config keys, value files, keys

Run `bash ${CLAUDE_SKILL_DIR}/scripts/config-check.sh <base>`. Each line it prints is a failure: an environment variable newly read in added lines is missing from `.env.example`, a committed value file such as `.env`, or a key in added lines (`sb_secret_`, a JWT whose role is not anon, a secret key name in a public-prefixed environment variable). The script compares names only and writes only file names for keys. So that key values never enter the conversation, use only that output as evidence.

### Supabase

Only when files under `supabase/` or code that calls Supabase (`.from(`, `.rpc(`, `.channel(`, `auth.`, `storage.`) changed. Checks that need the DB run only while the local stack is running (`supabase status`; if it is off, ask whether to start it).

- **advisors:** `supabase db advisors`. A finding newly introduced by this change is a failure.
- **Types** (when a generated types file exists): generate `supabase gen types typescript --local` into a temp file with the same options and compare. A difference is a failure (regenerate and commit).
- **Keys:** whether client code uses a secret key is for `server:supabase-reviewer` (the script above checks key patterns).

## 2. Agents to add to the review

- If server code (routes, handlers, services, authorization, queries), the API spec, or server migrations changed, `server:api-reviewer`. Evidence: changed files, new migration files, the oasdiff result (or the two spec paths).
- If the Supabase scope above changed, `server:supabase-reviewer`. Evidence: changed files, new migration files, advisors findings, whether the local stack is running.

## 3. After fixes

If migrations or the spec were fixed, rerun the relevant step 1 checks.

## Return format

```markdown
### server end check
Migration owner: prisma
Checks: 1 failure (others passed, skipped: oasdiff not installed)
- src/orders/webhook.ts:12 — 새 환경 변수 STRIPE_WEBHOOK_SECRET 이 .env.example 에 없음 (new environment variable missing from .env.example)

#### Agents to add to the review
- `server:api-reviewer` — evidence: src/orders/*.ts, prisma/migrations/2026…/migration.sql

#### After fixes
- …
```

If there are no failures, write "Checks: all passed" on one line.
