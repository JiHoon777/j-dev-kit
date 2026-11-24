---
name: frontend-start-check
description: Pre-work check for frontend projects. Called by the start mode of the workflow plugin's task skill. Detects the framework and returns what to follow during implementation (frontend-design, framework rules, browser check), what to do before planning (mockups), and what to put in the plan (DESIGN.md). Svelte content lives in references/svelte.md.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> Translation. Source: [plugins/frontend/skills/frontend-start-check/SKILL.md](../../../../../../plugins/frontend/skills/frontend-start-check/SKILL.md). Update this file when the source changes. Claude does not read this file.

# Frontend start check

Called by `/task start`. Does not modify anything and runs almost no commands. Returns only what fits this item. Report in the project's language.

## 0. Applicability

- If CLAUDE.md has a `stack:` line without frontend, return only "Not applicable".
- Decide which package.json to look at. In a monorepo (`packages:` in `pnpm-workspace.yaml`, package.json `workspaces`, `turbo.json`, `nx.json`), it is the package.json of the app or package this item touches, not the root. If it is unclear which one, make it a question to ask.
- If that package.json's `dependencies`/`devDependencies` contain none of react, next, vue, nuxt, svelte, @sveltejs/kit, solid-js, @angular/core, astro, return only "Not applicable".
- Detect the framework and read the matching reference to the end with the Read tool. If there are several, read all of them.

  | In package.json | reference |
  | --- | --- |
  | `svelte` | `${CLAUDE_SKILL_DIR}/references/svelte.md` |

## 1. To follow

Return only what applies to this item.

- **New screen or redesign:** invoke the `frontend-design` skill and follow it. Choose colors and fonts within the project's design tokens; ask first before adding new ones. If the item has a chosen mockup or CLAUDE.md has product principles, those come first. Do not invoke it for items that move an existing screen as-is.
- **When choosing a new web feature or UI pattern** (dialog, popover, layout, form validation, etc.): invoke the `modern-web-guidance` skill if available.
- **Browser check** (when the UI changes, at the end of implementation): the implementing session does not judge it itself; hand it to the `frontend:frontend-evaluator` agent.
  - Start the dev server. The port is the web port under `### 포트` in the work branch item, or else the port in `.claude/launch.json` (do not edit launch.json). If launch.json can start it on that port, start it that way and confirm it is listening with `bash ${CLAUDE_SKILL_DIR}/scripts/dev-server.sh <port>`. Otherwise check in the package.json scripts how the dev command takes a port (for example Vite `--port`, a positional argument, or the `PORT` environment variable) and start it with `bash ${CLAUDE_SKILL_DIR}/scripts/dev-server.sh <port> <command that starts it on that port…>`. Use the `URL:` line of the output as the screen URL, and if it exits with a non-zero value, report the reason it printed. If a backend server is needed too, start it on the server port with the same script, and point the place where the web app takes the backend address (proxy target, an environment variable like `VITE_API_URL`) at that server port through command arguments or environment variables, without editing files. For changes visible only in a build (service worker, static generation), build and then start the preview command with the same script.
  - Pass the agent only the item file path, the screen URL and the viewport. Do not pass what was implemented or how.
  - Viewport: the one set in CLAUDE.md, otherwise desktop. If you changed a responsive layout, also mobile (375×812).
  - Fix a "fail" and hand it over again. If the same AC still fails after three fixes, stop fixing and tell the user which AC failed and what you tried. A person rethinking the approach beats repeating the same fix. Do not check off a "could not verify"; tell the user.
  - If the agent says "no browser tool", check it yourself (the `chrome-devtools` skill if available, otherwise the app's built-in browser): walk through each Acceptance Criterion as a user would, with no console errors and no failed requests (4xx/5xx). Write in `Implementation Notes` that you did it yourself. If you cannot do that either, stop and say so.
- The framework rules from the reference.

## 2. Before planning / To put in the plan / To ask

- **Mockups:** if the item adds or redesigns a screen and has no chosen mockup, return as "before planning": invoke the `frontend:ui-design` skill with `mockup <screen>`. Skip it if the user wants to go without one. Do not add it for items that move an existing screen as-is.
- **No DESIGN.md:** if the item changes UI, there is no root `DESIGN.md`, and CLAUDE.md has no `- DESIGN.md: 안 씀` (not used), ask whether to make it in this item. If yes, put in the plan: invoke the `frontend:ui-design` skill with `system` as the first implementation step. If not, suggest writing `- DESIGN.md: 안 씀` under `## 작업 설정` in CLAUDE.md so it is not asked again.
- **Token changes:** if the item changes design tokens such as colors, fonts or spacing and `DESIGN.md` exists, put in the plan: invoke the `frontend:ui-design` skill with `system` to update DESIGN.md.
- What the reference adds.

## Return format

```markdown
### frontend start check
Detected: svelte 5 (read references/svelte.md)

#### To follow
- …

#### Before planning
- …

#### To put in the plan
- …

#### To ask
- …
```

Omit sections with no content when returning.
