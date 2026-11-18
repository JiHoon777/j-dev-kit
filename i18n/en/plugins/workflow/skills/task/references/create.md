> Translation. Source: [plugins/workflow/skills/task/references/create.md](../../../../../../../plugins/workflow/skills/task/references/create.md). Update this file when the source changes. Claude does not read this file.

# task create: write one backlog item

Create one item file in `docs/backlog/`. The format follows the [Backlog.md](https://github.com/MrLesk/Backlog.md) agent guidelines, without using the tool. `/task end` moves finished items to `docs/done/`.

What to create: the arguments after `create`.

## 0. The first time

If `docs/backlog/` does not exist, propose creating the two files below, and create them once approved. Ask the user for the labels.

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

Leave empty when creating. `/task start` writes the approved plan.

## Implementation Notes

What was learned while working, what changed from the plan.

## Final Summary

Written by `/task end`: what changed, what was fixed in review, what was deferred.
```

## 1. What and why

- If the request has a purpose and an outcome, go straight to step 2.
- If it is ambiguous, call the `superpowers:brainstorming` skill. However, do not write a separate design document (the item file is that document) and do not move on to an implementation plan. Ask only what is truly unknown, at most 3 questions at once; write the rest as assumptions in the Description.
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

- Number: the largest number across `docs/backlog/` and `docs/done/` + 1, three digits. `README.md` and files starting with `_` are not items.
- File name: `<number>-<label>-<short-english-name>.md`. `status: To Do`, dates set to today.
- If the request came from a note, delete that line from `docs/backlog/README.md` after creating the item.

## 3. Show and get approval

Show the content before writing. If asked for changes, make them and show it again.

## 4. Save

1. Write the file, and if the project has a format command, run it until it passes.
2. Commit the item file and the deleted note line, plus any files newly created in step 0: `docs(backlog): <number> <title>`. Do not include other changes. If they are left behind, `/task start` stops at "There are uncommitted changes". Do not push.
3. Report the path and number, and say to start with `/task start <number>`.
