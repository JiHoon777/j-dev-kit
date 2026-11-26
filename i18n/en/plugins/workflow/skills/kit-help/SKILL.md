---
name: kit-help
description: Explains how to use the workflow plugin. First-time setup, how to use /backlog and /start, picking the skill, playbook, or principle that fits the situation, and what to do when things go wrong. Write your question after /kit-help.
disable-model-invocation: true
---

> Translation. Source: [plugins/workflow/skills/kit-help/SKILL.md](../../../../../../plugins/workflow/skills/kit-help/SKILL.md). Update this file when the source changes. Claude does not read this file.

# kit-help

> Follows the structure of pstack's `poteto-help` (`pstack/skills/poteto-help/SKILL.md` in `cursor/plugins`, MIT, Lauren Tan).

Answer questions about the workflow plugin, give one command line the user can send as is, and point to the file the answer came from. Do not start work on a help question. The user asked how, so leave the command for the user to send.

A request to do work, like "fix this bug", is not a help question. Invoke the `start` skill with the Skill tool and follow its procedure.

This file is a map from questions to skills and docs. The details are in those files. Before answering, read the file it points to with the Read tool, and if it differs from this map, trust that file. Skill files are at `${CLAUDE_SKILL_DIR}/../<name>/SKILL.md`. Give the user the public copy: append the path to `https://github.com/JiHoon777/j-dev-kit/blob/main/plugins/workflow/`.

## Finding out what is needed

Work it out from the question and the conversation. If the situation is clear, as in "what do I run before a PR?", go straight to that section. If it is not, ask once which of the four below it is, and answer only the chosen section.

- First-time setup
- Working with `/backlog` and `/start`
- Picking the skill that fits the situation
- When things go wrong

Check only the state that changes the answer, and mention it only when the answer differs.

- If neither `.claude/workflow.json` nor `~/.claude/workflow.json` exists, `/kit-setup` has never been run, and every role uses the default model.
- If the project has no `verify-*` skill, there is no set way to drive the real app and check it. When asked how to prove a change, point to `/create-verification-skill`.
- If the project CLAUDE.md has no `검증 명령:` (verify command) line, `/start` asks what to verify with.

## First-time setup

1. Install: `claude plugin marketplace add JiHoon777/j-dev-kit --scope project`, `claude plugin install workflow@j-dev-kit --scope project`.
2. Run `/kit-setup`. It asks which model and effort each role uses and how to merge (local merge then push / PR), and writes them to `.claude/workflow.json`. It also asks whether to create the work settings in CLAUDE.md (base branch, verify command, document language, `stack:`) and a verification skill, if they are missing. It looks at the project's stack and installs the official skills and plugins that fit it, without asking.
3. Start real work: make an item with `/backlog <task>`, or do it right away with `/start <task>`.

Installing alone changes nothing. Things run when a skill is invoked. The details are in the README (`https://github.com/JiHoon777/j-dev-kit#readme`).

If cost is a worry, say where the tokens go. They go to sub-sessions, review agents, and judge agents. Run `/kit-setup` again and pick "save", or pick a cheaper model per role. For small work, use `/start <task>` and the review shrinks to fit the size.

## Working with `/backlog` and `/start`

- `/backlog <a sentence or two>`: makes a backlog item. It shows the full Acceptance Criteria and gets approval. `/backlog --survey <goal>` researches the repository and the outside and produces item candidates.
- `/start <number or name>`: implements one item through to the merge. It runs in a sub-session on a new worktree. With `--here`, it runs in this session.
- `/start <task>`: does the work right away with no item. It runs in this session.
- Plain words work too. "Put this in the backlog", "start 001", "review this branch and merge it".

`/start` asks only five things (work that cannot be undone, shared settings, product or taste decisions, what to do, and states that could lose work). It decides the rest and writes it down as `decision — reason — cost if wrong`. There is no plan approval. To see the plan, say "let me see the plan". At the end it asks the remaining decisions and the merge, all at once. If how to merge is set with `/kit-setup`, it does not ask how; it asks only whether to merge that way.

A good request states the goal and how to know it is done. It does not list skills. The procedure calls the skills it needs in order.

```text
/start The csv export drops the last line. Reproduce it first, then fix it. It is done when a 60,000-line file comes out whole. Show me the line counts before and after the fix.
```

## Picking the skill that fits the situation

The default answer is `/start`. When the procedure needs one, it reads and uses the skills below. Invoke a skill directly only when you want more or less than the procedure gives. Before recommending a skill, read it, and give one example command.

| What you want | Skill |
| --- | --- |
| Implement work through to the merge | `/start` |
| Turn a task into a backlog item | `/backlog` |
| Models and effort, how to merge, project settings | `/kit-setup` |
| Design the steps first for large work that no playbook fits | `/figure-it-out` |
| How the code works now, where new code should go | `/how` |
| Why the code came to be this way, where a number came from | `/why` |
| Settle types and module shape before a change that crosses a function boundary | `/architect` |
| What a small diff can break outside the diff | `/blast-radius` |
| Check "fixed" or "faster" with a before-and-after comparison | `/verify-this` |
| Review measured performance numbers before reporting them | `/benchmark-checklist` |
| Drive the real screen to check it, or reproduce a UI bug | `/control-ui` |
| Drive a CLI or TUI to check it | `/control-cli` |
| Create the project skill that drives the app to check it, and its feature map | `/create-verification-skill` |
| Bring that skill and feature map back in line with the app | `/maintain-verification-skill` |
| Remove AI-added code clutter before committing | `/deslop` |
| Flag unneeded comments and workaround code before the review | `/no-comments` |
| Remove AI tells from prose | `/unslop` |
| Write docs, READMEs, and commit messages to the standard | `/technical-writing` |
| Resolve merge conflicts | `/fix-merge-conflicts` |
| Make screen mockups, create or update DESIGN.md | `/ui-design` |
| How to use this plugin | `/kit-help` |

If a skill folder next to this one is not in the table, read that file's frontmatter and guide by its description.

Not invoked by you:

- `frontend-start-check`, `frontend-end-check`, `server-start-check`, `server-end-check`: the stack checks `/start` calls before implementing and before the review. They look at the `stack:` line in CLAUDE.md or at the code, and drop out as "not applicable" if they do not apply.
- Reviewers and judge agents (`frontend-reviewer`, `design-reviewer`, `frontend-evaluator`, `api-reviewer`, `supabase-reviewer`): launched by the review step of `/start`.
- `survey-collector`, `survey-judge`: launched by `/backlog --survey`. The collector has only read and web tools and note writing; the judge has only read and web tools. `comment-sicko`: launched by `/no-comments`.

Easy to mix up:

- `/how` answers what the code does, and `/why` answers why it is that way.
- `/blast-radius` looks at the impact outside the diff. The review of the diff itself is done by the review step of `/start` (`code-review`).
- `/deslop` cleans up code, and `/unslop` cleans up prose.
- `/control-ui` is how to drive a screen, and `/verify-this` is the frame for judging a claim with a before-and-after comparison.

Not in this plugin:

- `code-review`, `security-review`, `/loop`, and `/model` are built into Claude Code.
- pstack's arena, swarm, and interrogate were not brought in, because their point is running a mix of other companies' models.

## Playbooks and principles

A playbook is a list of steps inside `/start`. It is not a skill, so it has no slash command. Describe the work and `/start` picks one.

- Find something out without changing code → investigation
- Add new behavior → feature
- Fix a bug → bug-fix
- Keep the behavior and change only the structure → refactoring
- Settle a fork or a screen with a throwaway prototype → prototype
- A performance problem with a measured number → perf-issue
- Push one metric up to a target, again and again → hillclimb
- None fits, or the work is large and cross-cutting → `figure-it-out` designs the steps

When the merge is by PR, `/start` follows opening-a-pr. It holds the PR title and body format.

The files are `start/playbooks/<name>.md`.

The principles are 24 skills of one rule each (`principle-<name>`). `/start` reads the index and writes the principles it applied in the decision lines. Rather than invoking principles, the user steers by name. For example: "Apply prove it works. Show me the real output, not the build log." Typing `/principle-<name>` reads one. The list is in the index of the `start` SKILL.md.

## When things go wrong

| Symptom | Fix |
| --- | --- |
| It asks too often | If the question is outside the five asking criteria, say "don't ask, decide and write it down". If it keeps happening, the asking criteria in the `start` SKILL.md need fixing |
| It asks how to merge every time | Set how to merge in `/kit-setup`: local merge then push, or a PR |
| You want it to keep going while you are away | Say "run it to the end". It asks only about the merge, work that cannot be undone and states that could lose work, decides the rest by its recommendation, and collects it in the last message |
| You want to see the plan | Say "let me see the plan" and it shows the plan and waits |
| The model was changed but nothing changed | Per-role settings apply from the next session or agent launched, and main session settings from a new session |
| It costs a lot | See the cost paragraph in "First-time setup" |
| A stack check does not run | That stack is missing from `stack:` in CLAUDE.md (`stack: 없음`, none), or the code has no framework |
| The verify command runs when Claude stops | That is the verify hook. It runs only on a `w/` branch, when the item's Definition of Done is checked and the code changed since the last pass |
| It says only that the build passed and finishes | Ask to see the real command, the screen, and the stored value. That is the prove it works principle |
| There is no `/task` | It was split into `/backlog` (creating an item) and `/start` (implementation through to the merge) |
| `frontend@j-dev-kit` or `server@j-dev-kit` cannot be found | They were merged into workflow. Remove the two lines from `enabledPlugins` in the project settings |

## How to answer

Give the answer first. Give at most one code block of example commands, and attach a link to the file the answer came from. Unless the user asked for the whole map, keep the answer short.
