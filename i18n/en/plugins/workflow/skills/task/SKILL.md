---
name: task
description: Backlog-based work loop. create writes one backlog item, start plans an item and implements it on a work branch, end reviews the branch, fixes what needs fixing, then gets approval and merges. Calls the start-check and end-check skills of the enabled stack plugins. Runs only when the user invokes it directly.
argument-hint: "create <one or two sentences> | start [backlog number or part of a name] | end"
disable-model-invocation: true
allowed-tools: Bash(git status *), Bash(git branch --show-current), Bash(git branch --list *), Bash(git log *), Bash(git diff *), Bash(ls *)
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> Translation. Source: [plugins/workflow/skills/task/SKILL.md](../../../../../../plugins/workflow/skills/task/SKILL.md). Update this file when the source changes. Claude does not read this file.

# task

Arguments: `$ARGUMENTS`

## 1. Choose a mode

Choose the mode by the first word of the arguments, and pass the rest to the mode.

| First word | Mode | Procedure file |
| --- | --- | --- |
| `create` | Write one backlog item | `${CLAUDE_SKILL_DIR}/references/create.md` |
| `start` | Plan and implement one item | `${CLAUDE_SKILL_DIR}/references/start.md` |
| `end` | Review, fix, wrap up, merge | `${CLAUDE_SKILL_DIR}/references/end.md` |

- If the first word is none of the three, show this table and ask.
- Read only the chosen mode's procedure file, all the way through, with the Read tool, and follow it as written.

## 2. Project settings

Read these from the project CLAUDE.md. If missing, use the default in parentheses; if there is no verify command, ask.

- Base branch (`main`)
- Verify command (e.g. `pnpm verify` — lint, types, tests, build)
- Language for items and reports (the language of the conversation)
- Worktree (off): when `켜기` (on), `/task start` makes a worktree per item under `.claude/worktrees/`
- Web port, server port (none): only the ones written down are split per item as `base port + item number`

Rules in the project CLAUDE.md take precedence over this skill and superpowers.

## 3. Working principles

- Do not assume what you do not know; say it. Do not ask what code and docs can answer.
- Do only what the item requires. Every changed line must trace back to the item.
- Before saying "done", run verification fresh and show the result.

## 4. Current state

- Branch: !`git branch --show-current 2>/dev/null || echo "(unknown)"`
- Work branches: !`git branch --list 'w/*' 2>/dev/null || echo "(none)"`
- Uncommitted changes: !`git status --short 2>/dev/null | head -20`
- Recent commits: !`git log --oneline -3 2>/dev/null || echo "(no commits)"`
- Backlog: !`ls docs/backlog 2>/dev/null || echo "(none)"`
- Done: !`ls docs/done 2>/dev/null || echo "(none)"`
- Commits on this branch (vs `main`): !`git log --oneline main..HEAD 2>/dev/null | head -30`
- Files changed vs `main`: !`git diff --stat main...HEAD 2>/dev/null | tail -30`
