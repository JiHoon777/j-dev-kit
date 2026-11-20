# j-dev-kit

[한국어](README.md) | **English**

> Translation of README.md. The Korean README is the source.

A personal Claude Code plugin marketplace. The work loop is a single `/task` skill; stack-specific checks live in stack plugins. To direct several items from one session, use `/lead`. Architecture design and review is a separate `/arch`, and UI mockups and design review a separate `/ui` (both stack-agnostic).

| Plugin | Contains | Also installs |
| --- | --- | --- |
| `workflow` | `/task create`, `/task start`, `/task end`, `/lead run`, `/lead scout`, `/lead schedule`, `backlog-scout` | `superpowers` |
| `frontend` | Svelte and React checks, `frontend-reviewer`, and `frontend-evaluator` for browser verification | `workflow`, `typescript-lsp`, `frontend-design` |
| `server` | Server and Supabase checks (migrations, API spec, keys), `api-reviewer`, `supabase-reviewer` | `workflow` |
| `architecture` | `/arch design`, `/arch review`, `architecture-reviewer`, `architecture-researcher` | none |
| `design` | `/ui system`, `/ui mockup`, `/ui review`, `design-reviewer` | none |

If you use Supabase, install `server` even if you call it straight from the frontend.

## Install

```bash
claude plugin marketplace add JiHoon777/j-dev-kit --scope project
claude plugin install frontend@j-dev-kit --scope project
claude plugin install server@j-dev-kit --scope project
claude plugin install architecture@j-dev-kit --scope project
claude plugin install design@j-dev-kit --scope project
```

Install only the stacks you use. `architecture` and `design` can be installed on their own in any project. Do not remove the dependency plugin lines written to `.claude/settings.json`.

Add this to the project CLAUDE.md.

```markdown
## Work settings
- stack: frontend, server
- base branch: main
- verify command: pnpm verify
- document language: English
- concurrent work sessions: 2

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
| Vercel react-best-practices | `npx -y skills@1.7.5 add vercel-labs/agent-skills` |
| Official Supabase | `/plugin install supabase@anthropic-plugin-directory` (turn off its bundled MCP in `/mcp`) |

## Usage

```
/task create Add an email and password login screen   # docs/backlog/001-….md
/task start 001                                        # plan → approve → implement on a w/001-… branch
/task end                                              # review → fix → close the item → merge
```

- **start:** baseline (one run of the verify command), stack start checks, planning sized to the item (no agents for small items), test-first implementation, cleanup with `simplify`, verification.
- **end:** stack end checks, review (`code-review` plus `security-review` and stack reviewers when needed), findings shown as 🔴 must fix / 🟡 consider / ⚪ minor with one question per group, fixes, verification, merge. Pushes only on request.
- **Verify hook:** on a `w/` branch, when the item's Definition of Done is checked and Claude stops, a hook runs the `verify command:` from CLAUDE.md itself. On failure it sends Claude back once with the output. It does not run again while the code is unchanged. It can overlap the verification the skill already ran, so it may run once more per stage. On Windows it needs Git Bash.
- **Browser check:** when the UI changes, the `frontend-evaluator` agent, not the implementing session, judges each Acceptance Criterion on the running screen.

### Directing

```
/lead schedule weekdays at 9am   # call scout on a cadence in this session (off: /lead schedule off, or 끄기)
/lead scout                      # once, now: take proposals → write the proposals file (docs/backlog/_proposals.md) → ask about promotion
/lead run                        # promote proposals → a work session per item → report at plan and merge points → merge
/lead run 003 005                # only the chosen items
```

- **scout:** the `backlog-scout` agent reads the repository and returns idea, backlog-grooming and improvement proposals as a report. The agent writes no files. The calling session checks the evidence, writes the proposals file, and asks about promotion and rejection as `run` does. A schedule also just follows the scout procedure inside this session, so the flow is the same (a slash command arriving from a schedule is not expanded into the skill, so the schedule uses instructions). A scheduled run raises only the newly found proposals; the whole accumulated list is shown in `/lead run`. Proposals accumulate (at most 10 per angle, a fixed value) and only resolved ones drop out. Nothing without evidence, and "None" when there is nothing. A proposal becomes an item only when the user promotes it.
- **run:** the lead session does not edit code. Promoted proposals become items by the `/task create` procedure; it starts a work session per item in its own worktree that follows the `/task start` and `end` procedures as they are, and checks each report itself before raising it. What a work session would ask the user in the `/task` procedures (questions, plan approval, review finding decisions) is taken by the lead session and raised. The lead session merges one branch at a time by the wrap-up step of `/task end`, resolves conflicts then, and verifies after each.
- Starting sessions uses what the app provides. Scheduling is in-session (what `/loop` uses), so it creates no separate session; it runs only while this session is open and expires after 7 days. Without a session-start tool, work runs in subagents isolated in worktrees.

### Architecture

```
/arch design A team schedule-sharing web app (new project)  # quality goals → stack survey → structure → approve → overview and ADRs
/arch design Structure for adding payment methods          # existing project: current stack and ADRs are constraints
/arch review                                                # confirm system map → git measurements → review → per finding: ADR / debt / leave
/arch review src/billing --research                         # one path, also survey the latest structural guidance
```

- Only criteria with a source are used (ISO 25010 maintainability, information hiding and deep modules, coupling and cohesion, fitness functions, arc42 quality goals, and so on). Research evidence about coding agents is added only to the items it actually supports.
- Stack recommendations always run a web survey to check versions, end of support and maintenance status. Structural-guidance surveys run only with `--research`.
- It never edits code. It only writes the overview, ADRs and research files under `docs/architecture/`, and asks before writing.

### Design

```
/ui system                     # create or update DESIGN.md from the code's tokens, @DESIGN.md in CLAUDE.md
/ui mockup login screen        # one or several mockups → pick on the canvas → record in docs/design/<NNN>-<slug>/
/ui review http://localhost:5173/login   # review at 1440/768/375 against DESIGN.md, the chosen mockup, WCAG AA
```

- Mockups are drawn on the Claude Code design canvas (claude.ai login, CLI or desktop). Without it, a single `variants.html` is used instead.
- Aesthetic and accessibility rules are left to the canvas and `frontend-design`; this plugin holds only the steps (brief, mockup count, directions, pick, record).

## Layout

```
plugins/workflow/skills/task/       SKILL.md + references/create.md, start.md, end.md
plugins/workflow/skills/lead/       SKILL.md + references/run.md, scout.md, schedule.md
plugins/workflow/agents/            backlog-scout.md
plugins/workflow/hooks/             hooks.json, verify-on-stop.sh (Stop hook)
plugins/frontend/                   skills/frontend-{start,end}-check, agents/frontend-reviewer.md, frontend-evaluator.md
plugins/server/                     skills/server-{start,end}-check, agents/api-reviewer.md, supabase-reviewer.md
plugins/architecture/               skills/arch (SKILL.md + references/), agents/architecture-{reviewer,researcher}.md
plugins/design/                     skills/ui (SKILL.md + references/), agents/design-reviewer.md
i18n/en/                            English translations (Claude does not read them)
scripts/check-repo-rules.sh         repository rule check (translation pairs, version bumps)
```

- The source is Korean (`plugins/`); translations live in `i18n/en/`. Update the translation when you change the source.
- `/task start` calls every skill whose name ends in `-start-check`, and `/task end` every one ending in `-end-check`. To add a stack, make a plugin with the same naming and register it in `marketplace.json`.

## Updating

```bash
claude plugin marketplace update j-dev-kit
claude plugin update <plugin>@j-dev-kit --scope project
```

Then open a new session. Maintainers bump `version` in `plugin.json` for each changed plugin, run the verify command in CLAUDE.md (`claude plugin validate .` and `scripts/check-repo-rules.sh`), and push. The check script fails when a markdown file in `plugins/` has no translation in `i18n/en/`, or when a plugin changed since `main` still has the same `version`. If the version is unchanged, the update is not picked up.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| `supabase@j-dev-kit` cannot be found | It was merged into `server`. Remove it from `enabledPlugins` and install `server@j-dev-kit`. |
| `Dependency "…" is not installed` | Install the removed dependency plugin with the same `--scope`. |
| The verify command runs when Claude stops | That is the verify hook. It runs only when the item's Definition of Done is checked and the code changed since the last pass. Without a `verify command:` line in CLAUDE.md it does not run. |
| No stack checks run | The plugin is disabled, or it is missing from `stack:` in CLAUDE.md. |

## Sources

[Backlog.md](https://github.com/MrLesk/Backlog.md) item format, [superpowers](https://github.com/obra/superpowers) (brainstorming, TDD, verification before completion, receiving review, finishing a branch), [spec-kit](https://github.com/github/spec-kit) (at most 3 questions), [compound-engineering](https://github.com/EveryInc/compound-engineering-plugin) (planning sized to the task), [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills), Claude Code built-in `code-review`, `security-review`, `simplify`, OWASP API Security Top 10, [supabase/agent-skills](https://github.com/supabase/agent-skills), Anthropic [Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices).

Verify hook and `frontend-evaluator`: Claude Code [hooks](https://code.claude.com/docs/en/hooks.md) (rules that must hold go in hooks, not instructions), Anthropic [harness design](https://www.anthropic.com/engineering/harness-design-long-running-apps) (an evaluator kept apart from the builder uses the running app itself).

`/lead`: [GitHub Agentic Workflows safe outputs](https://github.github.com/gh-aw/reference/safe-outputs/) (a cap per run, "nothing to do" allowed, proposals promoted by a person), [Langfuse weekly digest](https://langfuse.com/blog/2026-03-13-weekly-digest-ai-skill) (evidence links, clear next step / needs discussion), Anthropic [multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system) (workers report with artifacts and a short summary) and [long-running harness](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents) (state in files and git, never delete tests), Claude Code [scheduled tasks](https://code.claude.com/docs/en/scheduled-tasks). The number 10 per angle is a fixed value we chose, not an evidence-based one (it cannot be configured).

`architecture`: ISO/IEC 25010:2023, Parnas (information hiding), Ousterhout (deep modules), *Building Evolutionary Architectures* (fitness functions), [arc42](https://arc42.org/), [MADR](https://adr.github.io/madr/), [Choose Boring Technology](https://mcfunley.com/choose-boring-technology), Azure Architecture Center and AWS Decision Guides, [endoflife.date](https://endoflife.date/), [deps.dev](https://deps.dev/), [OpenSSF Scorecard](https://scorecard.dev/). Ideas borrowed from skills: [alexei-led/architect](https://github.com/alexei-led/architect) (confirm the map before judging, no evidence means "could not verify"), [mattpocock/skills](https://github.com/mattpocock/skills) `improve-codebase-architecture` (hotspots, deletion test), [mblode/agent-skills](https://github.com/mblode/agent-skills) `codebase-architecture` (a fresh agent follows the recipes). The research papers behind the AI evidence are linked in `criteria.md`.

`design`: [Google DESIGN.md](https://github.com/google-labs-code/design.md), WCAG 2.2, Claude Code [artifacts](https://code.claude.com/docs/en/artifacts.md). Ideas borrowed from: [emilkowalski/skills](https://github.com/emilkowalski/skills) `prototype` (name and axis, 3–5 mockups, stop until the user picks), [compound-engineering](https://github.com/EveryInc/compound-engineering-plugin) `ce-prototype` (`decisions.md`), [impeccable](https://github.com/pbakaus/impeccable) (axis list, identity lock), [gstack](https://github.com/garrytan/gstack) `design-shotgun` (headline swap test), [OneRedOak/claude-code-workflows](https://github.com/OneRedOak/claude-code-workflows) `design-review` (live review per width).
