---
name: task
description: Backlog-driven work loop with three modes. The create mode writes one backlog item, the start mode plans an item in plan mode and implements it on a work branch, and the end mode reviews the branch with parallel agents, applies the chosen fixes, and merges after approval. Runs the start-check and end-check skills of enabled stack plugins. Runs only when the user invokes it directly.
argument-hint: "create <one or two sentences> | start [backlog number or part of the name] | end"
disable-model-invocation: true
allowed-tools: Bash(git status *), Bash(git branch --show-current), Bash(git branch --list *), Bash(git log *), Bash(git diff *), Bash(ls *)
version: "0.3.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# task

One skill, three modes. This file only routes; each mode's procedure lives in its own reference file.

Arguments: `$ARGUMENTS`

## 1. Pick the mode

Read the first word of the arguments. The rest is passed to the mode.

| First word | Mode | Procedure file |
| --- | --- | --- |
| `create` | Write one backlog item | `${CLAUDE_SKILL_DIR}/references/create.md` |
| `start` | Plan and implement one backlog item | `${CLAUDE_SKILL_DIR}/references/start.md` |
| `end` | Review, fix, finish, and merge the work branch | `${CLAUDE_SKILL_DIR}/references/end.md` |

- If the first word is none of these, or there are no arguments, show this table and ask which mode to run. Do not guess.
- **Read the procedure file for the chosen mode in full with the Read tool before doing anything else, then follow it step by step.** Do not work from memory or from this summary. Read only that one file; the other modes do not apply.

## 2. Project settings (all modes)

Read these from the project's CLAUDE.md. Use the default in parentheses when one is missing. If the verification command is missing, ask for it.

- Base branch (`main`)
- Verification command (for example `pnpm verify`: lint, type check, tests, and build in one go)
- Lint command (for example `pnpm lint`)
- Documents to follow (code rules and structure documents that CLAUDE.md points to)
- Language for backlog items, notes, and reports (otherwise the language of the conversation)

The project's CLAUDE.md rules take precedence over this skill and over superpowers.

## 3. Current state (all modes)

- Branch: !`git branch --show-current 2>/dev/null || echo "(unknown)"`
- Work branches: !`git branch --list 'w/*' 2>/dev/null || echo "(none)"`
- Uncommitted changes: !`git status --short 2>/dev/null | head -20`
- Recent commits: !`git log --oneline -3 2>/dev/null || echo "(no commits)"`
- Backlog: !`ls docs/backlog 2>/dev/null || echo "(none)"`
- Done: !`ls docs/done 2>/dev/null || echo "(none)"`

## 4. Where it comes from

These modes chain proven workflows. Each procedure file lists its sources per step. Do not change how a source works.

| Part | Source |
| --- | --- |
| Item format, good items, definition of done | [Backlog.md](https://github.com/MrLesk/Backlog.md) agent guidelines |
| Exploration, clarifying questions, design options, review | Anthropic `feature-dev` plugin, phases 2–6, and its `code-reviewer` prompt |
| Plan approval | Claude Code plan mode |
| Clarifying a new item, TDD, verification before completion, receiving review, finishing the branch | `superpowers` skills, invoked as is |
| Review | Built-in skills `code-review`, `security-review`, `simplify`, plus stack review agents |
| Stack checks | `*-start-check` and `*-end-check` skills of enabled stack plugins |
