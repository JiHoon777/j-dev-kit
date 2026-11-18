---
name: frontend-end-check
description: Wrap-up check for frontend projects. Called by the end mode of the workflow plugin's task skill. Only when frontend code has changed, checks for leftover debug code and the lockfile and runs the framework's check tools, then returns frontend-reviewer to include in the review and the browser check to do after fixes.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> Translation. Source: [plugins/frontend/skills/frontend-end-check/SKILL.md](../../../../../../plugins/frontend/skills/frontend-end-check/SKILL.md). Update this file when the source changes. Claude does not read this file.

# Frontend end check

Called by `/task end`. Runs commands and returns only the results. The review that reads code and makes judgments is done by `frontend:frontend-reviewer`. Report in the project's language.

## 0. Applicability

- Same criteria as `frontend-start-check`. If not applicable, "Not applicable".
- If `git diff --name-only <base>...HEAD` contains no frontend code (components, pages, styles, client logic, package.json), return only "No frontend changes".
- If package.json has `svelte`, read `${CLAUDE_SKILL_DIR}/references/svelte.md` to the end with the Read tool. React has no separate checks to run (hook lint and build should be in the verification commands).

## 1. Checks

- If added lines in `git diff <base>...HEAD -U0` contain `console.log`, `debugger`, `.only(`, fail.
- If package.json dependencies changed but the lockfile did not, fail.
- The reference's checks.

## 2. Agents to include in the review

If UI code changed, `frontend:frontend-reviewer`. Pass the list of changed UI files and the detected framework as the basis.

## 3. After fixes

If fixing review findings changed the UI, do the browser check from `frontend-start-check` on the fixed screens. Also what the reference adds.

## Return format

```markdown
### frontend end check
Checks: 1 failed (rest passed)
- src/lib/a.ts:12 — console.log left in

#### Agents to include in the review
- `frontend:frontend-reviewer` — basis: src/routes/login/+page.svelte, … (svelte)

#### After fixes
- Browser check of the fixed screens
```

If nothing failed, write a single line: "Checks: all passed".
