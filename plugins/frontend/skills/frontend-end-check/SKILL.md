---
name: frontend-end-check
description: Wrap-up check for frontend projects, called by the end mode of the workflow plugin's task skill. Detects the framework, compares checks against the baseline, counts leftover debug markers, checks console, network, and Lighthouse with Chrome DevTools, and runs the framework tools from the matching reference file (svelte.md, react.md). Returns which review agents (ui-reviewer, svelte-reviewer, react-reviewer) to add and a browser test to do after fixes.
user-invocable: false
version: "0.3.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# Frontend end check

Called by `/task end`. Common frontend checks live here; framework-specific checks live in `references/`.

**This skill only runs commands and tools and compares results.** Reviews that read the diff and judge it are not done here; they are handed to review agents (`frontend:ui-reviewer`, and the framework reviewers named in the references), which `/task end` launches in parallel with the other review agents.

Judge each item as **pass · fail · skip (reason)** and return it in the format at the end. `/task end` puts failures in the findings list and calls this skill again after fixes. Write the report in the project's language.

## 0. Applicability and framework detection

- Same criteria as `frontend-start-check`. If not applicable → "not applicable: <reason>". If no frontend code changed, do only step 1 and skip the rest with "no frontend changes".
- **Detect the framework and read its reference.** For each match, **read the file in full with the Read tool and run its checks as well**:

  | Detected in package.json | Reference |
  | --- | --- |
  | `svelte` | `${CLAUDE_SKILL_DIR}/references/svelte.md` |
  | `react` | `${CLAUDE_SKILL_DIR}/references/react.md` |

## 1. Checks (compared with the baseline)

Run the same commands as `### Baseline` in the item's `Implementation Notes`.

- A failure that is not in the baseline → fail. If the baseline failures are unchanged, it passes, but write "N existing failures unchanged" as evidence. Also note failures that disappeared.
- Run the build. It catches problems that only show in the build, not on the dev server (`window`/`document` access during server rendering, static generation failures, environment variables missing at build time).
- If `typescript-lsp` is enabled, diagnostics appeared while editing, but that does not replace the type check command. Run it.

## 2. Leftover markers (counted by command)

Count only **added lines** in `git diff <base>...HEAD -U0`. Only record counts and locations; deciding whether each is acceptable is the job of `ui-reviewer`.

- `console.log`, `debugger`, `.only(`, `.skip(` → fail if any.
- `any`, `as any`, `@ts-ignore`, `@ts-expect-error`, `eslint-disable` → record count and locations. Whether the reason is valid is for `ui-reviewer`.
- `package.json` dependencies changed but the lockfile did not → fail.

## 3. Browser tool checks

Invoke the `chrome-devtools` skill, start the dev server, and for each changed screen:

- Console errors (`list_console_messages`) and failed requests (4xx/5xx in `list_network_requests`). Any → fail. A 404 from deliberately opening a missing URL is fine.
- `lighthouse_audit` accessibility score and findings. New findings on changed screens → fail; record the score as evidence.
- If a screen became heavier (large lists, animation, images), record LCP, INP, and CLS from a performance trace (`performance_start_trace` → `performance_stop_trace`).

If the tool is not available, skip this item with "no browser tool", but say that `/task end` must do the step 4 browser test another way.

## 4. After fixes (to return): browser test

Return the procedure from `frontend-start-check` step 7 as is. In addition:

- If review findings were fixed, recreate the situation each describes and confirm it is now fine.
- Do it once before merging even if nothing was fixed.

## 5. Agents to add to the review

If UI code (components, pages, styles, client logic) changed, return `frontend:ui-reviewer` with the evidence (list of changed UI files and the step 2 marker locations). This agent reviews output of user input, loading/empty/error states, duplicate requests, accessibility, public environment variables, dependencies, and the reasons for the markers counted in step 2. Also return the framework reviewers named in the references read in step 0.

## Return format

```markdown
### frontend end check
| Item | Result | Evidence |
| --- | --- | --- |
| Checks (vs baseline) | … | 0 new failures (0 existing) |
| Build | … | … |
| Leftover markers | … | console.log 0, @ts-ignore 1 (src/a.ts:12) |
| Console and network | … | … |
| Lighthouse accessibility | … | score …, new findings … |
| (framework rows from the reference) | … | … |

#### Failure details
- `file:line` what the problem is, how to fix it

#### Agents to add to the review
- `frontend:ui-reviewer` — evidence: changed UI files …
- (framework reviewers from the reference)

#### After fixes
- Browser test: …
- (framework items from the reference)
```
