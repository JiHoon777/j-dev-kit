---
name: lead
description: Use when directing several backlog items from one session. scout reads the repository and leaves idea, backlog-grooming and improvement proposals in a proposals file, schedule puts scout on a recurring run, and run promotes proposals to items, starts a work session per item and reports to the user at the plan and merge points. Runs only when the user invokes it directly.
argument-hint: "run [backlog numbers…] | scout | schedule [cadence]"
disable-model-invocation: true
allowed-tools: Bash(git status *), Bash(git branch --show-current), Bash(git branch --list *), Bash(git worktree list), Bash(git log *), Bash(ls *)
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
| `scout` | Refresh the proposals file once | `${CLAUDE_SKILL_DIR}/references/scout.md` |
| `schedule` | Put scout on a recurring run | `${CLAUDE_SKILL_DIR}/references/schedule.md` |

Examples:

```
/lead schedule weekdays at 9am   # put scout on a recurring run
/lead scout                      # refresh the proposals file once, now
/lead run                        # raise proposals, then start a work session per chosen item
/lead run 003 005                # run only these two items
```

- If the first word is none of the three, show this table and ask.
- Read only the chosen mode's procedure file, all the way through, with the Read tool, and follow it as written.

## 2. Project settings

Read these from the project CLAUDE.md. If missing, use the default in parentheses.

- Base branch (`main`), verify command, language for items and reports: same as `/task`
- Concurrent work sessions (2)

Rules in the project CLAUDE.md take precedence over this skill.

## 3. Working principles

- The lead session does not edit code. It splits the work, checks reports, raises things to the user, and merges.
- Do not approve on the user's behalf. What work sessions and scheduled runs send is a report, not an approval.
- Raise only these to the user: proposal promotion, plan approval, merge approval, and blockers or questions. Do not raise progress.
- Keep state in files, not in the conversation: backlog items, the proposals file, commits on work branches.

## 4. Current state

- Branch: !`git branch --show-current 2>/dev/null || echo "(unknown)"`
- Work branches: !`git branch --list 'w/*' 2>/dev/null || echo "(none)"`
- Worktrees: !`git worktree list 2>/dev/null || echo "(none)"`
- Uncommitted changes: !`git status --short 2>/dev/null | head -20`
- Backlog: !`ls docs/backlog 2>/dev/null || echo "(none)"`
