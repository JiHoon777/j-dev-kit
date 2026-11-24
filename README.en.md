# j-dev-kit

[한국어](README.md) | **English**

> Translation of README.md. The Korean README is the source.

A personal Claude Code plugin marketplace. The work loop is a single `/task` skill; stack-specific checks live in stack plugins. You can type `/task` yourself, or say things like "put this in the backlog" or "start 006" and Claude invokes it on its own.

| Plugin | Contains | Also installs |
| --- | --- | --- |
| `workflow` | `/task create`, `/task start`, `/task end`, the verify Stop hook, scripts that pick item ports and check tests against the base branch | `superpowers` |
| `frontend` | Svelte and React checks (scripts that start the dev server and check the diff), `ui-design` for DESIGN.md and canvas mockups, `frontend-reviewer`, `design-reviewer` for screen review, and `frontend-evaluator` for browser verification | `workflow`, `typescript-lsp`, `frontend-design` |
| `server` | Node server and Supabase checks (migrations, keys; config keys and keys by a script), `api-reviewer`, `supabase-reviewer` | `workflow` |

If you use Supabase, install `server` even if you call it straight from the frontend.

## Install

```bash
claude plugin marketplace add JiHoon777/j-dev-kit --scope project
claude plugin install frontend@j-dev-kit --scope project
claude plugin install server@j-dev-kit --scope project
```

Install only the stacks you use. Do not remove the dependency plugin lines written to `.claude/settings.json`.

Add this to the project CLAUDE.md.

```markdown
## Work settings
- stack: frontend, server
- base branch: main
- verify command: pnpm verify
- document language: English

## superpowers
The rules in this document take precedence. Follow only the skills `/task` calls; do not use
writing-plans, executing-plans, subagent-driven-development, or using-git-worktrees.
```

Without the superpowers paragraph, superpowers takes over the planning step of `/task start`.

### Used when installed

| Plugin / skill | Install |
| --- | --- |
| Official Svelte | `/plugin marketplace add sveltejs/ai-tools`, `/plugin install svelte@svelte` |
| Chrome DevTools | `/plugin marketplace add ChromeDevTools/chrome-devtools-mcp`, `/plugin install chrome-devtools-mcp@chrome-devtools-plugins` |
| modern-web-guidance | `/plugin marketplace add GoogleChrome/modern-web-guidance`, `/plugin install modern-web-guidance@googlechrome` |
| React (Vercel react-best-practices, composition-patterns) | `npx -y skills@1.7.5 add vercel-labs/agent-skills --skill vercel-react-best-practices --skill vercel-composition-patterns -a claude-code` |
| React Router | `npx -y skills@1.7.5 add https://github.com/remix-run/react-router --skill react-router -a claude-code` |
| Next.js docs | On 16.3 or later `next dev` writes `AGENTS.md`. Below that, `npx @next/codemod@canary agents-md` |
| Official Supabase | `/plugin install supabase@anthropic-plugin-directory` (turn off its bundled MCP in `/mcp`) |

## Usage

```
/task create Add an email and password login screen   # writes docs/backlog/001-….md in a sub-session
/task start 001                                        # in a worktree sub-session: plan → approve → implement on a w/001-… branch
/task end                                              # in that session: review → fix → close the item → merge
/task start 001 --here                                 # in this session, no sub-session
/task create --survey Reduce frequent errors logs/      # read the sources directly and show item candidates
```

- **Sub-sessions:** `create` and `start` open one session by default and only report its link. `create` runs in the same folder (only from the base branch; from a work branch or a worktree it runs in this session); `start` runs in a new worktree off the base branch (on a `w/<item>` branch). The starting session directs: it shows the sub-session's questions and approval requests here and passes on the answers, and when the sub-session finishes it checks the result and reports first. The sub-session puts the plan up in plan mode and the user approves it on that session's plan screen (the starting session only reports the link and points worth checking). Answering in the sub-session directly also works. From a Fable session, sub-sessions run on the latest model one step lower (for now Opus) at `high` effort; from Opus or lower, on this session's model and effort. If the work session was closed, `start <number>` continues that branch in this session. Invoke `end` in the session that did the work. Without a tool that opens new sessions (outside the desktop app), the work happens in this session. To run several items together, call `start` several times.

- **create --survey:** takes a goal and sources (paths, commands, URLs; if none, it looks in the repository), reads the raw material directly, and picks item candidates. Sources with the same cause become one candidate, and bug reports are reproduced on the base branch. It shows one list with evidence and a way to check each, and writes only the ones picked. It does not call `start`.
- **start:** baseline (one run of the verify command), stack start checks, planning sized to the item (no agents for small items), settling the tools and steps the best practitioners in the field use, test-first implementation, cleanup with `simplify`, verification. ACs are checked off only with outside evidence (command output) or a judge agent other than the implementing session. If the same AC still fails after three fixes, it stops and hands over to the user.
- **end:** stack end checks, review (`code-review` plus `security-review` and stack reviewers when needed, and `design-reviewer` when a screen changed), a judge agent other than the work session decides which findings are valid, and only those are shown as 🔴 must fix / 🟡 consider / ⚪ minor with one question per group, fixes (the work session makes fixes that need judgment, mechanical ones go to a Sonnet agent when the work session chooses, the verify command and a judge agent decide whether they are fixed, and it stops when the same finding remains after three fixes), verification, merge. Pushes only on request. Before the review, the branch's new tests also run against the base branch's source, and a test that passes without the fixed code goes in as 🟡. For a finding fixed before or seen in several places (🔁), you can also choose a new item that blocks it with a lint rule, test or type.
- **Review principles:** findings left as is and what the user corrected go in the Final Summary, and when they hold for other items they are collected as one-line principles in `docs/review-principles.md`, which become input to later reviews.
- **Verify hook:** on a `w/` branch, when the item's Definition of Done is checked and Claude stops, a hook runs the `verify command:` from the base branch's CLAUDE.md itself. If the work branch changed that line, it judges with the base branch's command and says the command changed (the new one takes effect after the merge). It looks for the base branch locally, then on `origin`. If the base branch has no such line, it uses the working tree's; if it cannot find the base branch, it uses the working tree's and says so. On failure it sends Claude back with the output, only once for the same content. It does not run again while the code is unchanged. It still runs after another Stop hook such as `/goal` has blocked the stop. It can overlap the verification the skill already ran, so it may run once more per stage. It waits up to 30 minutes for the verify command (`timeout` 1800 seconds), since the default 600 seconds can run out when the verify command also runs the tests of changed scripts. On Windows it needs Git Bash.
- **Ports:** with `- 웹 포트: 5000` (web port) and `- 서버 포트: 6000` (server port) under `## 작업 설정` (work settings) in CLAUDE.md, each item gets `base port + item number` (item 007 → 5007, 6007) written under the item's `### 포트`, and the checks that start a dev server and the `design-reviewer` review use those ports. `pick-port.sh` picks the ports, going up by 1 past ports something is listening on and ports of other items in progress (including other `w/` branches). `dev-server.sh` starts the dev server on that port and confirms it is listening. If you work on several projects together, keep base ports 1000 apart per project and between web and server (for example project A web 5000, server 6000; project B web 7000, server 8000). Item numbers are three digits, so they do not overlap. Supabase and database ports are not split.
- **Worktrees:** if a sub-session's worktree is created inside the repository (for example `.claude/worktrees/`), leave that folder out of test and lint tool settings. After merging, archiving the session lets the app clean up the worktree.
- **Browser check:** when the UI changes, the `frontend-evaluator` agent, not the implementing session, judges each Acceptance Criterion on the running screen.
- **Design (frontend):** steps in only when needed, without being invoked. For an item that adds or redesigns a screen, `start` makes mockups on the Claude Code design canvas before planning (one or several; the user picks on the canvas) and writes the chosen one into the plan and the item. For a UI item with no root `DESIGN.md`, it asks whether to make one in this item (to opt out, `- DESIGN.md: 안 씀` under `## 작업 설정` in CLAUDE.md), and for an item that changes tokens it puts a DESIGN.md update in the plan. Once made, DESIGN.md is always read through `@DESIGN.md` in CLAUDE.md. Saying "make mockups for the login screen" without an item also runs `ui-design`. Without the canvas, a temporary `variants.html` outside the repo stands in.

## Layout

```
plugins/workflow/skills/task/       SKILL.md + references/create.md, start.md, end.md + scripts/pick-port.sh, base-tests.sh
plugins/workflow/hooks/             hooks.json, verify-on-stop.sh (Stop hook)
plugins/frontend/                   skills/frontend-{start,end}-check (scripts/dev-server.sh, diff-check.sh), ui-design, agents/frontend-reviewer.md, design-reviewer.md, frontend-evaluator.md
plugins/server/                     skills/server-{start,end}-check (scripts/config-check.sh), agents/api-reviewer.md, supabase-reviewer.md
i18n/en/                            English translations (Claude does not read them)
scripts/check-repo-rules.sh         repository rule check (translation pairs and updates, matching descriptions, README lists, version bumps, shell injection lines in skills, the duplicated port_open, paired tests of changed scripts)
scripts/test-check-repo-rules.sh    scenario tests for the check script
scripts/test-verify-on-stop.sh      scenario tests for the verify hook
scripts/test-{pick-port,base-tests,dev-server,diff-check,config-check}.sh  scenario tests for the plugin scripts
```

- The source is Korean (`plugins/`); translations live in `i18n/en/`. Update the translation when you change the source.
- `/task start` calls every skill whose name ends in `-start-check`, and `/task end` every one ending in `-end-check`. To add a stack, make a plugin with the same naming and register it in `marketplace.json`.

## Updating

```bash
claude plugin marketplace update j-dev-kit
claude plugin update <plugin>@j-dev-kit --scope project
```

Then open a new session. Maintainers bump `version` in `plugin.json` for each changed plugin, run the verify command in CLAUDE.md (`claude plugin validate .` and `scripts/check-repo-rules.sh`), and push. The check script fails when a markdown file in `plugins/` has no translation in `i18n/en/`, when a plugin's description differs between `plugin.json` and `marketplace.json`, when a plugin in `marketplace.json` is missing from the table in either README, when a source changed since `main` (or `origin/main` if there is no local `main`) but its translation did not, when a plugin changed since `main` kept or lowered its `version`, or when the `port_open` bodies in `pick-port.sh` and `dev-server.sh` differ. If the version is unchanged, the update is not picked up. It also runs the paired test `scripts/test-<name>.sh` of each script changed since `main` (the `.sh` files in `plugins/` outside evals, and the check script) and each changed paired test, and fails when one fails or a script has no pair. Each test takes about a minute (`test-check-repo-rules.sh` three to four, `test-base-tests.sh` about five), and one that runs past `CHECK_TESTS_TIMEOUT` seconds (default 540) is stopped and fails.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| `supabase@j-dev-kit` cannot be found | It was merged into `server`. Remove it from `enabledPlugins` and install `server@j-dev-kit`. |
| `architecture@j-dev-kit` or `design@j-dev-kit` cannot be found | They were removed. Remove them from `enabledPlugins`. DESIGN.md and mockups moved to `ui-design` in `frontend`, and screen review to `design-reviewer` in `frontend`. |
| `Dependency "…" is not installed` | Install the removed dependency plugin with the same `--scope`. |
| The verify command runs when Claude stops | That is the verify hook. It runs only when the item's Definition of Done is checked and the code changed since the last pass. Without a `verify command:` line in CLAUDE.md it does not run. |
| No stack checks run | The plugin is disabled, or it is missing from `stack:` in CLAUDE.md. |

## Sources

[Backlog.md](https://github.com/MrLesk/Backlog.md) item format, [superpowers](https://github.com/obra/superpowers) (brainstorming, TDD, verification before completion, receiving review, finishing a branch), [spec-kit](https://github.com/github/spec-kit) (at most 3 questions), [compound-engineering](https://github.com/EveryInc/compound-engineering-plugin) (planning sized to the task), [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills), Claude Code built-in `code-review`, `security-review`, `simplify`, OWASP API Security Top 10, [supabase/agent-skills](https://github.com/supabase/agent-skills), Anthropic [Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices).

Verify hook, `frontend-evaluator`, `design-reviewer`: Claude Code [hooks](https://code.claude.com/docs/en/hooks.md) (rules that must hold go in hooks, not instructions), Anthropic [harness design](https://www.anthropic.com/engineering/harness-design-long-running-apps) (an evaluator kept apart from the builder uses the running app itself).

Practitioners' tools and steps, outside judging, review principles, trimming with evals, survey: the Felix Rieseberg talk ([video](https://youtu.be/D-SVFneJ_Nk)), Lauren Tan ([video](https://www.youtube.com/watch?v=MN9dGgmLyso), grouping related reports and reproducing them), Satya Nadella ([video](https://www.youtube.com/watch?v=0NE89Nzfk20), keep evals and re-measure when the model changes).

`ui-design` and `design-reviewer`: [Google DESIGN.md](https://github.com/google-labs-code/design.md), WCAG 2.2, Claude Code [artifacts](https://code.claude.com/docs/en/artifacts.md). Ideas borrowed from: [emilkowalski/skills](https://github.com/emilkowalski/skills) `prototype` (name and axis, 3–5 mockups, stop until the user picks), [impeccable](https://github.com/pbakaus/impeccable) (axis list, identity lock), [gstack](https://github.com/garrytan/gstack) `design-shotgun` (headline swap test), [OneRedOak/claude-code-workflows](https://github.com/OneRedOak/claude-code-workflows) `design-review` (live review per width).
