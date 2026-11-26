---
name: backlog
description: Use when creating a backlog item. Invoke when the user asks to turn work into a backlog item. Invoke with --survey when they ask to pick items to fix from sources (logs, issues, and so on) or from a goal. Implementing an item is the start skill's job. Not for requests to just fix something with no mention of an item.
argument-hint: "<one or two sentences> [--here] | --survey <goal> [sources…] [--internal] [--here]"
allowed-tools: Bash(git status *), Bash(git branch --show-current), Bash(git branch --list *), Bash(git log *), Bash(git diff *), Bash(ls *)
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> Translation. Source: [plugins/workflow/skills/backlog/SKILL.md](../../../../../../plugins/workflow/skills/backlog/SKILL.md). Update this file when the source changes. Claude does not read this file.

# backlog

Arguments: `$ARGUMENTS`

Create one item file in `docs/backlog/`. The format follows the [Backlog.md](https://github.com/MrLesk/Backlog.md) agent guidelines, without using the tool. Implementing and finishing an item is the `start` skill's job. `start` moves finished items to `docs/done/`.

What to create: the arguments. If they start with `--survey`, read `${CLAUDE_SKILL_DIR}/references/survey.md` all the way through with the Read tool and follow it.

## Where to work

- **If the arguments have `--here`:** remove it and work in this session.
- **Otherwise:** open a sub-session.
  1. If there is no tool that starts a new session the user can open and talk to directly (for example the desktop app's `start_session`), say in one line that the work happens in this session, and follow the procedure.
  2. Open a session only when this session is in the base folder on the base branch. If it is inside a worktree (the two lines of `git rev-parse --path-format=absolute --git-dir --git-common-dir` differ) or on another branch, work in this session and say that the item commit goes onto the current branch. Two sessions sharing one folder mix their commits and index.
  3. Open one session in this folder as is (no worktree). The user asked for this work, so start it right away instead of proposing it. Model and effort follow the `session` role in `${CLAUDE_SKILL_DIR}/../start/references/settings.md`.
  4. That session cannot see this conversation. The brief is two lines, "Invoke the `backlog` skill with `<arguments> --here` and follow its procedure" and "Write questions and approval requests completely in the last message of the turn, then stop", plus any background the user gave or decisions made in this conversation (only if there are any).
  5. Report the session link. That work does not happen in this session; this session directs it. When the sub-session ends a turn, show any question or approval request to the user in full and pass the answer on in the user's own words. Check the result (commits, changed files) yourself and report it. If the user answered in the sub-session directly, accept that.

Read the base branch (`main` if missing) and the language for items (the language of the conversation if missing) from the project CLAUDE.md. Rules in the project CLAUDE.md take precedence over this skill.

## Asking criteria

Follow the "Asking criteria" in `${CLAUDE_SKILL_DIR}/../start/SKILL.md`. This skill asks only four things: whether to create the two files and the labels the first time (step 0), the questions when the request is ambiguous (step 1), item approval (step 3), and picking survey candidates. Decide the rest and write it as assumptions in the Description.

## 0. The first time

If `docs/backlog/README.md` does not exist, propose creating the two files below, and create them once approved. Ask the user for the labels.

- `docs/backlog/README.md`: the rules from step 2, the label list, and a "Notes not yet made into items" section
- `docs/backlog/_template.md`: the template below. Replace `<verify command>` with the project's.

```markdown
---
id: '000'
title: Short description of what to do
status: To Do
labels: [common]
priority: medium
dependencies: []
created_date: YYYY-MM-DD
updated_date: YYYY-MM-DD
---

## Description

Purpose and background, briefly. Do not write how to implement it. If anything is left out this time, note it.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 One sentence describing a result that can be checked on screen or by a command
- [ ] #2 …

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `<verify command>` passes
- [ ] #2 If the UI changed, checked in the browser

<!-- DOD:END -->

## Implementation Plan

Leave empty when creating. `/start` writes the plan.

## Implementation Notes

What was learned while working, what changed from the plan.

## Final Summary

Written by `/start`: what changed, what was fixed in review, what was deferred, findings left as is and why, what the user corrected.
```

## 1. What and why

- If the request has a purpose and an outcome, go straight to step 2.
- If it is ambiguous, ask. Question rules:
  - Ask only what would change the item (purpose, outcome, scope) and cannot be answered from the repository or docs. All at once, at most 3.
  - If you do not know why the user wants it, ask that first.
  - If it is a choice between options, attach the options and a recommendation.
  - Do not ask about procedure such as file location, labels, or format. Decide and write it as an assumption in the Description.
  - Do not ask about the method (approach). The item does not say how.
- If an overlapping item exists in `docs/backlog/` or `docs/done/`, do not create one; say so.

## 2. Write the item (Backlog.md guidelines)

| Part | Rule |
| --- | --- |
| `title` | A short title summarizing the task |
| Description | Purpose and background. Leave out how to implement it; note what is left out this time |
| Acceptance Criteria | Outcomes, not methods. Each one must be checkable. Bad example: "Add a `handleLogin()` function" |
| Size | Small enough to review and merge in one go. If large, split it and put the order in `dependencies` |
| Dependencies | Only items with smaller numbers |
| Implementation Plan | Leave empty |
| Prose | Follow `${CLAUDE_SKILL_DIR}/../unslop/SKILL.md` and `${CLAUDE_SKILL_DIR}/../technical-writing/SKILL.md` |

- Number: use the number that `bash ${CLAUDE_SKILL_DIR}/scripts/next-number.sh` prints. It is the largest number across `docs/backlog/` and `docs/done/` in this folder and on every branch (local, and remote ones already fetched) + 1, three digits. Branches are read without being checked out. This keeps an item made on a work branch from sharing a number with an item on the base branch or on another work branch. If this is not a git repository or the branches cannot be read, the script counts from this folder only. `README.md` and files starting with `_` are not items.
- File name: `<number>-<label>-<short-english-name>.md`. `status: To Do`, dates set to today.
- Another session may be creating an item at the same time. In step 4, count the number again with the same script right before writing the file; if that number appeared in the meantime, switch to the next number and say so.
- If the request came from a note, delete that line from `docs/backlog/README.md` after creating the item.

## 3. Show and get approval

Before writing, show the full Description and Acceptance Criteria and get approval. There is no plan approval, so this is the only contract a person checks before implementation. If asked for changes, make them and show it again.

Do not get approval again for an item whose draft ACs were already shown and that the user picked: one picked from the candidate table in survey mode, or one chosen as "later" in `start`'s last message.

## 4. Save

1. Write the file, and if the project has a format command, run it until it passes.
2. Commit the item file and the deleted note line, plus any files newly created in step 0: `docs(backlog): <number> <title>`. For the first item from survey mode, include the report too. Do not include other changes. If they are left behind, `/start` stops at "There are uncommitted changes". Do not push.
3. Report the path and number, and say that to start, use `/start <number>` (or "start it").
