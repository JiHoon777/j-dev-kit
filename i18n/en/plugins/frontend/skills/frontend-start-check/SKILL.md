---
name: frontend-start-check
description: Pre-work check for frontend projects. Called by the start mode of the workflow plugin's task skill. Detects the framework and returns what to follow during implementation (frontend-design, framework rules, browser check) and what to put in the plan. Framework-specific content lives in references (svelte.md, react.md).
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
  | `react` | `${CLAUDE_SKILL_DIR}/references/react.md` |

## 1. To follow

Return only what applies to this item.

- **New screen or redesign:** invoke the `frontend-design` skill and follow it. Choose colors and fonts within the project's design tokens; ask first before adding new ones. If there is an approved design or product principles in CLAUDE.md, those come first. Do not invoke it for items that move an existing screen as-is.
- **When choosing a new web feature or UI pattern** (dialog, popover, layout, form validation, etc.): invoke the `modern-web-guidance` skill if available.
- **Browser check** (when the UI changes, at the end of implementation):
  - Tool: the `chrome-devtools` skill if available, otherwise the app's built-in browser. If neither is available, stop and say so.
  - Start the dev server (`.claude/launch.json` if present). For changes visible only in a build (service worker, static generation), preview after building.
  - Walk through each Acceptance Criterion as a user would. There must be no console errors and no failed requests (4xx/5xx).
  - Viewport: the one set in CLAUDE.md, otherwise desktop. If you changed a responsive layout, also mobile (375×812).
- The framework rules from the reference.

## 2. To put in the plan / To ask

- If the item is a new screen or redesign and there is no design or spec, make it a question to ask.
- What the reference adds.

## Return format

```markdown
### frontend start check
Detected: svelte 5 (read references/svelte.md)

#### To follow
- …

#### To put in the plan
- …

#### To ask
- …
```

Omit sections with no content when returning.
