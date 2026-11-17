---
name: server-end-check
description: Wrap-up check for backend projects, called by the end mode of the workflow plugin's task skill. Detects the language and migration tool, compares checks against the baseline, uses tools to find missing or misordered migrations, breaking API changes (oasdiff), and undocumented config keys, and calls the changed endpoints on a local server. Language commands come from the matching reference file (node.md, python.md, go.md, jvm.md). Returns the api-reviewer agent to add when server code changed.
user-invocable: false
version: "0.3.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# Server end check

Called by `/task end`. Common backend checks live here; language and migration-tool commands live in `references/`.

**This skill only runs commands and checks results.** Reviews that read code and judge it (authorization, input validation, the impact of breaking changes, secrets in logs, how to handle risky DDL) are handed to the `server:api-reviewer` agent (step 6).

Judge each item as **pass · fail · skip (reason)** and return it in the format at the end. Write the report in the project's language.

## 0. Applicability and language detection

- Same criteria as `server-start-check`. If not applicable → "not applicable". If no server code, migration, or API spec changed, do only step 1 and skip the rest with "no server changes".
- **Detect the language and read its reference** (same table as `server-start-check`). For each match, **read the file in full with the Read tool**:

  | Language | Reference |
  | --- | --- |
  | Node | `${CLAUDE_SKILL_DIR}/references/node.md` |
  | Python | `${CLAUDE_SKILL_DIR}/references/python.md` |
  | Go | `${CLAUDE_SKILL_DIR}/references/go.md` |
  | Java/Kotlin | `${CLAUDE_SKILL_DIR}/references/jvm.md` |

## 1. Checks (compared with the baseline)

Run the same commands as `### Baseline` again. New failures → fail. Language-specific extras are in the reference.

## 2. Migrations (only when server owns migrations)

Decide the migration owner with the same rule as `server-start-check` (section "Migration owner"). If supabase owns migrations, skip this whole step with "skip: migrations owned by supabase plugin".

- **Missing migration:** run the reference's command for the detected tool (Atlas, `atlas.hcl`, is language-neutral: if present, use the Atlas commands in `references/go.md` for any language) (the model changed but no migration was created → fail).
- **Apply from scratch:** **ask** whether to empty the local or development database and re-apply every migration (data will be lost). If approved, run the reference's reset command. If declined → "not verified".
- **Order:** check whether new migrations landed on the base branch during the work. Two heads (Alembic, Django) → fail (a merge migration is needed). With timestamped files, the new file must be later than the newest on the base branch.
- **Risky DDL (locations only):** in the new migration files, `grep -niE "drop (table|column)|truncate|delete from|alter column|set not null|not null|create (unique )?index|rename"`, record `file:line` only, and mark **needs review**. How to handle them (preserving data, rolling back) is for `api-reviewer`.

## 3. API contract

- If there is an OpenAPI spec: compare it with the base branch's spec (`git show origin/<base>:<spec path>`). If `oasdiff` is installed, run `oasdiff breaking --fail-on ERR <base spec> <new spec>` (exit 1 on breaking changes). If not, record "no oasdiff" and pass both spec paths to `api-reviewer` to compare.
- If the spec is generated from code, run the generate command and check with `git diff --exit-code <spec>` that it matches the code. A difference → fail.
- Breaking changes are not a failure but **needs review**: the impact on consumers is for `api-reviewer`, and whether to bump the version is for the user.

## 4. Environment variables

- Check that every config key newly read in added lines (the read patterns are in the reference) is documented by name in `.env.example`. Missing → fail. Only names are compared; values are never read or printed.
- If a value file such as `.env` or `.env.local` is staged for commit → fail.

## 5. Actual calls

Start the server locally (with the test configuration if there is one) and send the acceptance criteria's requests to each changed endpoint with `curl`. Record status codes and the gist of the responses. For endpoints that need authentication, also send one request without authentication and one **with another user's object id**, and check for 401, 403, or 404. If the server cannot start → "not verified" with the reason.

## 6. Agents to add to the review

If server code (routes, controllers, handlers, services, authorization middleware, database queries), the API spec, or migrations changed, return `server:api-reviewer` with: the evidence (changed files), the risky DDL locations from step 2 (only when server owns migrations), the oasdiff result from step 3 (or both spec paths), and the call results from step 5.

## Return format

```markdown
### server end check
| Item | Result | Evidence |
| --- | --- | --- |
| Migration owner | … | server (prisma) / supabase |
| Checks (vs baseline) | … | 0 new failures |
| Missing migration | … | `prisma migrate diff … --exit-code` 0 |
| Apply from scratch | … | … / not verified |
| Order | … | … |
| Risky DDL locations | … | … |
| API contract | … | oasdiff 0 breaking changes / generated spec matches |
| Environment variables | … | 2 new variables, both in .env.example |
| Actual calls | … | POST /orders 201, GET with another user's id 404 |

#### Failure details
- `file:line` what the problem is, how to fix it

#### Agents to add to the review
- `server:api-reviewer` — evidence: …

#### After fixes
- Call the fixed endpoints again (step 5)
```
