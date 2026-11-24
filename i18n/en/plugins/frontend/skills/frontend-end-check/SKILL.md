---
name: frontend-end-check
description: Wrap-up check for frontend projects. Called by the end mode of the workflow plugin's task skill. Only when frontend code has changed, checks for leftover debug code and the lockfile and runs the framework's check tools, then returns frontend-reviewer and design-reviewer to include in the review and the browser check to do after fixes.
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

- Run `bash ${CLAUDE_SKILL_DIR}/scripts/diff-check.sh <base>`. Each line it prints is a failure (`console.log`, `debugger`, `.only(` in added lines, dependencies changed without the lockfile). A line marked "확인 못 함" (could not check) is not a failure; record it as not checked.
- The reference's checks.

## 2. Agents to include in the review

If UI code changed, `frontend:frontend-reviewer`. Pass the list of changed UI files and the detected framework as the basis.

If a screen (components, pages, styles) changed, also `frontend:design-reviewer`. Pass the screen URL, the root `DESIGN.md` path (if any), and the changed screen files as the basis. Get the URL by starting the dev server the way section 3 says. If it cannot be started, leave it out and say so.

## 3. After fixes

If fixing review findings changed the UI, hand the fixed screens to the `frontend:frontend-evaluator` agent to check. Also what the reference adds.

- Start the dev server. The port is the web port under `### 포트` in the work branch item, or else the port in `.claude/launch.json` (do not edit launch.json). If launch.json can start it on that port, start it that way and confirm it is listening with `bash ${CLAUDE_SKILL_DIR}/../frontend-start-check/scripts/dev-server.sh <port>`. Otherwise check in the package.json scripts how the dev command takes a port (for example Vite `--port`, a positional argument, or the `PORT` environment variable) and start it with `bash ${CLAUDE_SKILL_DIR}/../frontend-start-check/scripts/dev-server.sh <port> <command that starts it on that port…>`. Use the `URL:` line of the output as the screen URL, and if it exits with a non-zero value, report the reason it printed. If a backend server is needed too, start it on the server port with the same script, and point the place where the web app takes the backend address (proxy target, an environment variable like `VITE_API_URL`) at that server port through command arguments or environment variables, without editing files. For changes visible only in a build, build and then start the preview command with the same script.
- Pass the agent the item file path, the screen URL, the viewport and the list of fixed findings. Do not pass how they were fixed.
- Viewport: the one set in CLAUDE.md, otherwise desktop. If you fixed a responsive layout, also mobile (375×812).
- Fix a "fail" again. If the agent says "no browser tool", check it yourself (the `chrome-devtools` skill if available, otherwise the app's built-in browser) and write that you did it yourself. If you cannot do that either, stop and say so.

## Return format

```markdown
### frontend end check
Checks: 1 failed (rest passed)
- src/lib/a.ts:12 — console.log left in

#### Agents to include in the review
- `frontend:frontend-reviewer` — basis: src/routes/login/+page.svelte, … (svelte)
- `frontend:design-reviewer` — basis: http://localhost:5007/login, DESIGN.md, src/routes/login/+page.svelte

#### After fixes
- Check the fixed screens with `frontend:frontend-evaluator`
```

If nothing failed, write a single line: "Checks: all passed".
