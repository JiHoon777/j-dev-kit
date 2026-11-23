---
name: task
description: Use when working through backlog items. create when the user asks to turn work into a backlog item, create --survey when they ask to pick items to fix from sources (logs, issues, and so on), start when they ask to start or implement an item, end when they ask to review, wrap up, or merge a work branch. Not for requests to just fix something with no mention of an item or branch.
argument-hint: "create <one or two sentences> [--here] | create --survey <goal> [sources…] [--here] | start [backlog number or part of a name] [--here] | end"
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

- If the first word is none of the three, show this table and ask. When invoked from a request rather than typed by the user, pick the mode and arguments that fit the request.
- After section 2 decides where to work, if the work happens in this session, read only the chosen mode's procedure file, all the way through, with the Read tool, and follow it as written.

## 2. Where to work

- **`end`:** in this session. It is invoked in the session that did the work (the session `start` opened).
- **`create` or `start` with `--here`:** remove it and work in this session.
- **Any other `create` or `start`:** open a sub-session.
  1. If there is no tool that starts a new session the user can open and talk to directly (for example the desktop app's `start_session`), say in one line that the work happens in this session, and follow the procedure.
     - Open a `create` session only when this session is in the base folder on the base branch. If it is inside a worktree (the two lines of `git rev-parse --path-format=absolute --git-dir --git-common-dir` differ) or on another branch, work in this session and say that the item commit goes onto the current branch. Two sessions sharing one folder mix their commits and index.
  2. For `start`, first find the item in this session ("Find the item" in step 1 of `start.md`). If this item's `w/` branch already exists, do not open a session; tell the user to continue in the session that worked on that branch. If that session no longer exists, continue the branch in this session as `start.md` says.
  3. Open one session. The user asked for this work, so start it right away instead of proposing it.

     | Mode | Session |
     | --- | --- |
     | `create` | This folder as is (no worktree) |
     | `start` | A new worktree off the base branch, branch name `w/<item file name without .md>` |

  4. That session cannot see this conversation. The brief is two lines, "Invoke the `task` skill with `<mode> <rest of the arguments> --here` and follow its procedure" and "Write questions and approval requests (a plan in full) completely in the last message of the turn, then stop", plus any background the user gave or decisions made in this conversation (only if there are any).
  5. Report the session link. That work does not happen in this session; this session directs it.
     - When the sub-session ends a turn, show any question or approval request to the user in full and pass the answer to that session in the user's own words. Check the result (commits, changed files) yourself and report it before the user asks.
     - If the user answered in the sub-session directly, accept that.

## 3. Project settings

Read these from the project CLAUDE.md. If missing, use the default in parentheses; if there is no verify command, ask.

- Base branch (`main`)
- Verify command (e.g. `pnpm verify` — lint, types, tests, build)
- Language for items and reports (the language of the conversation)
- Web port, server port (none): only the ones written down are split per item as `base port + item number`

Rules in the project CLAUDE.md take precedence over this skill and superpowers.

## 4. Working principles

- Do not assume what you do not know; say it. Do not ask what code and docs can answer.
- Do only what the item requires. Every changed line must trace back to the item.
- Before saying "done", run verification fresh and show the result.
