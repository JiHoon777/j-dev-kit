---
name: frontend-start-check
description: Pre-work check for frontend projects, called by the start mode of the workflow plugin's task skill. Detects the framework, then runs the common checks (package manager, Node version, install, baseline, environment variables) and the framework checks from the matching reference file (svelte.md, react.md). Returns a baseline, exploration prompts, questions, rules during implementation (frontend-design, modern-web-guidance, framework rules), and a browser test to do before finishing.
user-invocable: false
version: "0.3.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# Frontend start check

Called by `/task start`. Common frontend checks live here; framework-specific checks live in `references/`.

**This skill only runs commands to check state.** Gathering information by finding and reading code is not done here; it is returned as **exploration prompts** for `Explore` agents, which `/task start` launches together with its own exploration agents.

Judge each item as **pass · fail · skip (reason) · stop** and return it in the format at the end. Fixing is not this skill's job. Write the report in the project's language.

| Part | Source |
| --- | --- |
| During implementation: screen design | Anthropic `frontend-design` plugin (invoked as is) |
| During implementation: choosing web features | Google `modern-web-guidance` plugin (invoked as is) |
| Before finishing: browser test | Chrome DevTools plugin's `chrome-devtools` skill (invoked as is) |
| Framework checks | `references/svelte.md`, `references/react.md` |

## 0. Applicability and framework detection

- If CLAUDE.md has a `stack:` line without frontend → "not applicable: not in stack setting".
- If none of react, next, vue, nuxt, svelte, @sveltejs/kit, solid-js, @angular/core, astro is in package.json dependencies → "not applicable: no frontend framework".
- In a monorepo (`pnpm-workspace.yaml`, package.json `workspaces`, `turbo.json`, `nx.json`), decide which app or package this item touches and work in that directory. If unclear, return it as a question.
- **Detect the framework and read its reference.** For each match, **read the file in full with the Read tool and run its checks as well**:

  | Detected in package.json | Reference |
  | --- | --- |
  | `svelte` | `${CLAUDE_SKILL_DIR}/references/svelte.md` |
  | `react` | `${CLAUDE_SKILL_DIR}/references/react.md` |

  If several match, read all of them. If the framework has no reference yet (Vue, Angular, …), say so in the report and run only the common checks.

## 1. Environment

1. **Package manager** from the lockfile: `pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, `bun.lock`/`bun.lockb` → bun, `package-lock.json` → npm. More than one → fail. If package.json has `packageManager`, use that version.
2. **Node version**: compare `.nvmrc`, `.node-version`, or `engines.node` with `node -v`. Mismatch → fail.
3. **Install** without changing the lockfile: `pnpm install --frozen-lockfile` / `npm ci` / `yarn install --immutable` (yarn 2+) or `--frozen-lockfile` (yarn 1) / `bun install --frozen-lockfile`. If it fails because the lockfile does not match package.json → **stop**.

## 2. Baseline

Record the state before the work. `/task end` compares against it to find only the failures this work introduced.

- Use the verification command from the project's CLAUDE.md. If there is none, find lint, type check, and test in package.json `scripts` (tests must not start in watch mode: `vitest run`, `CI=true jest`).
- For each: command, exit code, failure count, names of failing files or tests (if many, the count and the first 10).
- Existing failures are recorded as **baseline**; tell the user, but do not block the work.

## 3. Environment variables

- Compare the keys in `.env.example`/`.env.sample` with those in the real `.env`/`.env.local` and list only the **names** that are missing. Never print values.
- If a variable with a public prefix (`NEXT_PUBLIC_`, `VITE_`, `PUBLIC_`, `NUXT_PUBLIC_`, `REACT_APP_`) has `SECRET`, `PRIVATE`, `SERVICE_ROLE`, `TOKEN`, or `PASSWORD` in its name → fail. It ends up in the browser bundle.

## 4. Reuse survey (handed to an exploration agent)

Do not search yourself. Return the prompt below as an exploration prompt, filling `<…>` from the item.

> For each UI element in this item (<item path>) — <element list> — find what already exists in this repository: shared component folders, design tokens (CSS or theme files defining colors, fonts, spacing), the UI library, existing screens that implement the same pattern, and shared utilities. Make a table with "use (path)" or "build new" per element, and return 5–10 files that must be read. Do not edit files.

## 5. Design reference

Check whether the item has a design or spec link. If the item builds a new screen or redesigns one and there is none, return it as a question. Do not make one up.

## 6. Rules during implementation (to return)

- **If the item builds a new screen or redesigns one,** invoke the `frontend-design` skill and work the way it does. But:
  - Pick colors and fonts within the project's design tokens. If the skill suggests a new color or font, ask the user before adding it.
  - The product principles in the project's CLAUDE.md come first.
  - If there is an approved design, follow it.
  - Do not invoke it for items that **port** an existing screen or prototype as is. The skill picks its own visual direction.
- **When choosing a new web feature or UI pattern** (dialog, popover, scroll-driven effects, layout, form validation, …), invoke the `modern-web-guidance` skill and search the way it instructs.
- Add the framework rules from the references read in step 0.

## 7. Before finishing (to return): browser test

Passing tests and type checks do not show that the screen works; it has to be clicked through.

- **Tool:** invoke the `chrome-devtools` skill and use it as it says. If unavailable, use the Claude app's built-in browser preview. If neither is available, **do not skip; stop and tell the user.** Never record something unverified as done.
- **Serving:** the dev server (use `.claude/launch.json` if present). For changes that only show in the build (service worker, manifest, static generation), build and use the preview. After rebuilding, restart the preview server too.
- **Viewport:** whatever CLAUDE.md specifies; otherwise both phone 375×812 and desktop 1280.
- **What to check:**
  1. Go through each acceptance criterion as a user would: click, type, go back, reload.
  2. No console errors and no failed requests (4xx/5xx).
  3. Nothing else broke: open the start screen and related screens once each.
  4. No horizontal scroll and no clipped text.
  5. For screens with motion, check again with "reduce motion" on.
- **Record:** write what you tried and saw in the item's `Implementation Notes`. If something fails, fix it and test again from the start.

## Return format

```markdown
### frontend start check
| Item | Result | Evidence |
| --- | --- | --- |
| Framework | pass | svelte 5.x (references/svelte.md read) |
| Package manager | pass | pnpm 9.x (pnpm-lock.yaml) |
| Node version | … | … |
| Install | … | … |
| Environment variables | … | missing keys: … |
| Design reference | … | … |
| (framework rows from the reference) | … | … |

#### Baseline
| Check | Command | Result |
| --- | --- | --- |

#### Exploration prompts
- Reuse survey: (the step 4 prompt, filled in)
- (framework prompts from the reference)

#### Add to the plan
- …

#### Questions to ask
- …

#### Rules during implementation
- (step 6 items that apply to this item, plus framework rules)

#### Before finishing
- Browser test (step 7 procedure, viewport, server to run)
```

If anything is **stop**, write `stop: <reason>` above the table first.
