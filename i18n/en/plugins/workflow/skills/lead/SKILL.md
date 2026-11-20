---
name: lead
description: Use when directing several backlog items from one session. scout checks the idea, grooming and improvement proposals the agent finds, writes them to the proposals file and raises them to the user, schedule calls scout on a cadence in this session, and run starts a work session per item that follows the `/task` procedures and reports to the user at the approval points. Runs only when the user invokes it directly.
argument-hint: "run [backlog numbers…] | scout | schedule [cadence | off | 끄기]"
disable-model-invocation: true
allowed-tools: Bash(git status *), Bash(git branch --show-current), Bash(git branch --list *), Bash(git worktree list), Bash(git log *), Bash(git diff *), Bash(ls *), Bash(date *)
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
  tags: [orchestration, backlog, work-sessions, scheduling, human-approval]
---

> Translation. Source: [plugins/workflow/skills/lead/SKILL.md](../../../../../../plugins/workflow/skills/lead/SKILL.md). Update this file when the source changes. Claude does not read this file.

# lead

Arguments: `$ARGUMENTS`

## 1. Choose a mode

Choose the mode by the first word of the arguments, and pass the rest to the mode.

| First word | Mode | Procedure file |
| --- | --- | --- |
| `run` | Raise proposals, start work sessions, report, merge | `${CLAUDE_SKILL_DIR}/references/run.md` |
| `scout` | Take proposals, write them to the proposals file, and raise them | `${CLAUDE_SKILL_DIR}/references/scout.md` |
| `schedule` | Call scout on a cadence in this session, or turn it off | `${CLAUDE_SKILL_DIR}/references/schedule.md` |

Examples:

```
/lead schedule weekdays at 9am   # call scout on a cadence in this session
/lead schedule off               # turn that schedule off (끄기 works too)
/lead scout                      # once, now: take proposals, write them to the proposals file, and raise them
/lead run                        # raise proposals, then start a work session per chosen item
/lead run 003 005                # run only these two items
```

- `backlog-scout` in the procedure files is this plugin's agent. Its name when starting it is `workflow:backlog-scout`.
- If the first word is none of the three, show this table and ask.
- Read only the chosen mode's procedure file, all the way through, with the Read tool, and follow it as written.

## 2. Project settings

Read these from the project CLAUDE.md. If missing, use the default in parentheses.

- Base branch (`main`), verify command, language for items and reports: same as `/task`
- Concurrent work sessions (2)

Rules in the project CLAUDE.md take precedence over this skill.

## 3. Working principles

- Creating items, implementing, reviewing and merging follow the `/task` create, start and end procedure files as they are. This skill only adds splitting the work and raising reports on top.
- Where a `/task` procedure tells the user the next command (`/task start <number>` and so on), point to `/lead run <number>` instead. This session directs the work with `/lead`.
- The lead session does not edit code. It splits the work, checks reports, raises things to the user, and merges.
- Do not approve on the user's behalf. What work sessions send is a report, not an approval.
- Raise only these to the user: proposal promotion, and what the `/task` procedures ask the user (questions, plan approval, review finding decisions, merge approval, blockers). Do not raise progress.
- Keep state in files, not in the conversation: backlog items, the proposals file, commits on work branches.

## 4. Current state

- Branch: !`git branch --show-current 2>/dev/null || echo "(unknown)"`
- Work branches: !`git branch --list 'w/*' 2>/dev/null || echo "(none)"`
- Worktrees: !`git worktree list 2>/dev/null || echo "(none)"`
- Uncommitted changes: !`git status --short 2>/dev/null | head -20`
- Backlog: !`ls docs/backlog 2>/dev/null || echo "(none)"`
