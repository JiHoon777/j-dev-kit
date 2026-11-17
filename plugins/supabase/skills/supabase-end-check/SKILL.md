---
name: supabase-end-check
description: End-of-task check for Supabase projects. Uses the CLI and SQL to check for missing migrations, reapplying from scratch, ordering, RLS/view/function settings, whether rows are visible as another user, types, and key exposure. If Supabase changed, returns that the rls-reviewer agent should be added to the review. Called by `/task end` in the workflow plugin.
user-invocable: false
version: "0.4.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# Supabase end check

Called by `/task end`. Write the report in the project's language. Judge each item as **pass · fail · skip (reason)** and return the result in the format at the bottom. On a fail, `/task end` fixes it and calls this skill again.

This skill only **runs the CLI and SQL and checks the results**. Do not do the review that reads and judges migrations and policies yourself (whether policies work as intended, how to handle risky changes, abuse potential); hand it to the `supabase:rls-reviewer` agent (item 10).

Run SQL with `psql "<DB URL>" -c "<SQL>"` using the DB URL from `supabase status`. If `psql` is missing, skip SQL items as "no psql".

## 0. Applicability

Decide by the same criteria as `supabase-start-check`. If not applicable, "not applicable: <reason>". If the local stack is off, ask whether to start it; if declined, skip items that need the DB as "local stack off".

Decide the migration owner with the same rule as `supabase-start-check` (section "Migration owner"). **Steps 1–4 run only when supabase owns migrations**; otherwise skip them with "skip: migrations owned by server plugin". Steps 5 onward always run.

New migrations = `git diff --name-only origin/<base branch>...HEAD -- supabase/migrations` plus uncommitted new files.

## 1. Are the migrations complete?

1. `supabase db diff`. Passes only if the output is empty. If anything remains, fail: the change is in the local DB but not in a migration file. Attach the output SQL to the evidence.
2. If the schema changed (the diff shows table, column, policy, or function changes) but there is no new migration, fail.

## 2. Reapply from scratch

**Ask** whether to run `supabase db reset` (it wipes the local DB data and rebuilds it from migrations and seed). If approved, run it; it passes if it finishes without errors. If declined, leave it as "not verified". If this item is not verified, return that it should be noted in the PR description.

## 3. Migration order

Passes if the timestamp of each new migration is later than the latest timestamp in `git ls-tree --name-only origin/<base branch> supabase/migrations/`. If earlier, fail: another migration landed on the base branch during the work. Migrations are applied to the remote in order, so return that the timestamp in the new file name should be changed to the current time.

## 4. Risky changes (find locations only)

In the new migrations, find lines with the keywords below and record only `file:line`. If any exist, mark them **needs review**. `rls-reviewer` decides how to handle data preservation and rollback.

```bash
grep -niE "drop (table|column)|truncate|delete from|alter column .* type|set not null|not null|create (unique )?index|rename (to|column)" <new migration files>
```

## 5. RLS and security

1. Rerun the two SQL queries from the start check (tables with RLS off, tables without policies). If a table not in the baseline shows up, fail.
2. Extract the policy list for new tables and attach it to the evidence (`rls-reviewer` checks whether the policies work as intended). If there is an update policy without `with check`, fail.
   ```sql
   select tablename, policyname, cmd, roles, qual, with_check from pg_policies
   where schemaname = 'public' and tablename in (<new tables>);

   select tablename, policyname from pg_policies
   where schemaname = 'public' and cmd = 'UPDATE' and with_check is null;
   ```
3. **Check as another user.** Using the ids of two test users (A, B), check that visibility matches the permission rules in the acceptance criteria. If there are no test users, look in seed or `auth.users`; if there are none, ask whether to create them.
   ```sql
   begin;
   set local role authenticated;
   select set_config('request.jwt.claims', '{"sub":"<id of A>","role":"authenticated"}', true);
   select count(*) from public.<table>;                      -- only rows A can see
   select count(*) from public.<table> where user_id = '<id of B>';  -- should be 0 (depending on the rules)
   rollback;
   ```
   Do the same check as `anon` (`set local role anon;`). Record the resulting counts in the evidence.
4. **Views**: If a new view was created without `security_invoker`, fail.
   ```sql
   select c.relname, c.reloptions from pg_class c
   where c.relkind = 'v' and c.relnamespace = 'public'::regnamespace;
   ```
5. **Functions**: If a new `security definer` function does not pin `search_path`, fail.
   ```sql
   select p.proname from pg_proc p
   where p.pronamespace = 'public'::regnamespace and p.prosecdef
     and coalesce(array_to_string(p.proconfig, ','), '') not like '%search_path=%';
   ```
6. Compare `supabase db lint` and `supabase test db` (if there are tests) against the baseline. If there are new errors or new failures, fail.
7. If the new permission rules were not captured as pgTAP tests, return them under "Later".

## 6. Types

Generate into a temp file the same way as `supabase-start-check` step 4 and compare with the types file in the repository. If they differ, fail: the types must be regenerated and committed.

## 7. Keys and secrets

Search with the command. Do not copy the values into the evidence.

```bash
grep -rnE "sb_secret_|service_role|SERVICE_ROLE|eyJ[A-Za-z0-9_-]{20,}" --exclude-dir=node_modules --exclude-dir=build --exclude-dir=.next --exclude-dir=.svelte-kit .
```

If an `eyJ` token turns up, decode its middle part and check whether `role` is `anon` (the anon key may be public).

Fail if any of the following is found (an `eyJ` token whose `role` is `anon` is allowed):

- `service_role`, `SERVICE_ROLE`, or `sb_secret_` appears in files used on the client (code that goes into the browser bundle) or in environment variables with a public prefix (`NEXT_PUBLIC_`, `VITE_`, etc.).
- JWT-shaped strings (long strings starting with `eyJ`) or keys are hardcoded in code, migrations, or seed.
- Edge Function secrets are committed as files (`supabase/functions/.env`, etc.). Secrets are set with `supabase secrets set`.

## 8. Edge Function

If `supabase/functions/` changed, start it with `supabase functions serve <name>`, send the requests from the acceptance criteria with curl, and record the status codes and responses in the evidence. For functions that require auth, also send a request without the Authorization header and check that it returns 401.

## 9. Advisors (optional)

If this plugin's read-only MCP server (`mcp__plugin_supabase_supabase-readonly__*`) is connected and this change has been applied to its development project, call `get_advisors` once each with `security` and `performance`. Record new findings in the evidence. If it is not connected or not authenticated, skip as "advisors not checked (reason)". Never use `mcp__plugin_supabase_supabase__*` tools.

## 10. Agents to add to the review

If any of the following changed, return that `supabase:rls-reviewer` should be added to the review step of `/task end`. Pass along the evidence (changed files), the risky change locations found in step 4 (only when supabase owns migrations; otherwise `server:api-reviewer` judges them), and the policy list and other-user check results from step 5. This agent checks whether policies work as intended, abuse potential, handling of risky migrations, and policy performance.

- Files under `supabase/`
- Code that calls Supabase (`.from(`, `.rpc(`, `.channel(`, `auth.`, `storage.`)
- Changes that only use browser storage (`localStorage`) do not count.

## Return format

```markdown
### supabase end check
| Item | Result | Evidence |
| --- | --- | --- |
| Migration owner | … | supabase (supabase/migrations) / server (prisma) |
| Missing migrations | pass | no `db diff` output |
| Apply from scratch | … | `db reset` exit 0 / not verified |
| Order | … | new 20261117…, latest on base 20261110… |
| Risky change locations | needs review | 2026…_orders.sql:4 drop column |
| RLS and policies | … | … |
| Other-user check | … | A: 3 rows, B's rows queried as A: 0, anon: 0 |
| Views and functions | … | … |
| Lint and DB tests | … | 0 new errors |
| Types | … | … |
| Keys and secrets | … | … |
| Edge Function | skip | no changes |
| Advisors | skip | no MCP connection |

#### Failure details
- `file:line` what the problem is, how to fix it

#### Agents to add to the review
- `supabase:rls-reviewer` — evidence: added supabase/migrations/2026…_orders.sql

#### After fixes
- If any migration was fixed, rerun the `db diff`, RLS, and types checks (steps 1, 5, 6)
- (If there are risky changes) confirm the backup and rollback plan with the user

#### Later
- Permission rules to capture in pgTAP: …
```
