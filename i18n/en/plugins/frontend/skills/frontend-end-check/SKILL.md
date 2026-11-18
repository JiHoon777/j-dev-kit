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

- If CLAUDE.md has a `stack:` line without frontend, "Not applicable".
- If `git diff --name-only <base>...HEAD` contains no frontend code (components, pages, styles, client logic, package.json), return only "No frontend changes".
- The package.json to look at is that of the app or package the changed files belong to (in a monorepo, not the root). If it has no frontend framework (react, next, vue, nuxt, svelte, @sveltejs/kit, solid-js, @angular/core, astro), "Not applicable".
- If that package.json has `svelte`, read `${CLAUDE_SKILL_DIR}/references/svelte.md` to the end with the Read tool. React has no separate checks to run (hook lint and build should be in the verification commands).

## 1. Checks

- If added lines in `git diff <base>...HEAD -U0` contain `console.log`, `debugger`, `.only(`, fail.
- If package.json dependencies changed but the lockfile did not, fail.
- The reference's checks.

## 2. Agents to include in the review

If UI code changed, `frontend:frontend-reviewer`. Pass the list of changed UI files and the detected framework as the basis.

## 3. After fixes

If fixing review findings changed the UI, check the fixed screens in the browser. Also what the reference adds.

- Tool: the `chrome-devtools` skill if available, otherwise the app's built-in browser. If neither is available, stop and say so.
- Start the dev server (`.claude/launch.json` if present). For changes visible only in a build, preview after building.
- Reproduce, as a user would, the situation the fixed finding described and see that the problem is gone. There must be no console errors and no failed requests (4xx/5xx).
- Viewport: the one set in CLAUDE.md, otherwise desktop. If you fixed a responsive layout, also mobile (375×812).

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
