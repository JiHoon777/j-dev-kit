> Translation. Source: [plugins/server/skills/server-end-check/references/supabase.md](../../../../../../../plugins/server/skills/server-end-check/references/supabase.md). Update this file when the source changes. Claude does not read this file.

# Supabase: end check

Read by `server-end-check` when there is `supabase/config.toml` or an `@supabase/` dependency.

Skip if nothing under `supabase/` and no code that calls Supabase (`.from(`, `.rpc(`, `.channel(`, `auth.`, `storage.`) changed.

Run CLI checks only when the local stack is running (`supabase status`). If it is stopped, ask whether to start it; if declined, skip with "local stack stopped". Run SQL with `psql "<DB URL>" -c "<SQL>"` using the DB URL from `supabase status`.

## Checks

- **Missing migrations** (when the Supabase CLI is the owner): passes only if `supabase db diff` output is empty. If anything remains, fail: these are changes that exist in the local DB but not in migration files. Use the output SQL as evidence.
- **advisors**: `supabase db advisors` (or, if the project has the Supabase MCP, `get_advisors`, security and performance). Fail if this change introduced new findings.
- **Types** (when there is a generated types file): generate `supabase gen types typescript --local` with the same options into a temp file and compare. Fail if different (regenerate and commit).
- **Keys**: do not copy values.
  ```bash
  grep -rnE "sb_secret_|service_role|SERVICE_ROLE|eyJ[A-Za-z0-9_-]{20,}" --exclude-dir=node_modules --exclude-dir=build --exclude-dir=.next --exclude-dir=.svelte-kit .
  ```
  For `eyJ` tokens, decode the middle part; if `role` is `anon`, it is fine. Fail if a secret key is in client code or a public-prefix environment variable, if a key is hard-coded in code, migrations, or seed, or if a secrets file such as `supabase/functions/.env` is committed.
- **Other-user check** (only when RLS policies changed): with two test users (A, B), check that the visible rows match the permission rules in the Acceptance Criteria. If there are no users, look in seed or `auth.users`; if none, ask whether to create them. Use counts as evidence.
  ```sql
  begin;
  set local role authenticated;
  select set_config('request.jwt.claims', '{"sub":"<id of A>","role":"authenticated"}', true);
  select count(*) from public.<table> where user_id = '<id of B>';  -- 0 if the rules say it must be 0
  rollback;
  ```

## Agents to add to the review

If the scope above changed, `server:rls-reviewer`. Evidence: changed files, new migration files, advisors findings, other-user check results.

## After fixing

If you fixed migrations or policies, rerun `db diff`, advisors, types, and the other-user check.
