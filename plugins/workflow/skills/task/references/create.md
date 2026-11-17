# task create: write one backlog item

Create one item file in `docs/backlog/`. Format and rules come from the [Backlog.md](https://github.com/MrLesk/Backlog.md) agent guidelines. Use the format only, not the tool. Finished items move to `docs/done/` (`/task end` does that).

This mode chains proven workflows. Do not change how a source works.

| Step | Source |
| --- | --- |
| 1 | `superpowers:brainstorming` (invoked as is) |
| 2 | Backlog.md agent guidelines (item format, good items) |

What to create: the arguments after `create`.

## 0. First time in a project: create the folders

If `docs/backlog/` does not exist, propose creating the three files below and create them after approval. Never overwrite an existing file.

- `docs/backlog/README.md`: the item file rules (the table in step 2), the label list, and a section "Notes not yet turned into items".
- `docs/backlog/_template.md`: the template below. Replace the verification command in the Definition of Done with the one in the project's CLAUDE.md. If there is none, ask for it.
- `docs/done/README.md`: "Items finished with `/task end` move here. When picking a new number, also look at the numbers in this folder."

Ask the user for the labels. Do not make them up. Write the files in the project's language (see the skill's project settings).

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

Purpose and context of this work, briefly. No implementation details. If something is deliberately left out this time, say so here.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 A sentence whose result can be seen on screen or checked with a command
- [ ] #2 …

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 <verification command> passes
- [ ] #2 If the UI changed, it was checked in a browser by hand
- [ ] #3 If something new was decided, the docs were updated

<!-- DOD:END -->

## Implementation Plan

Leave empty when creating the item. `/task start` writes the approved plan here.

## Implementation Notes

What was learned while working and what changed from the plan.

## Final Summary

Written when `/task end` finishes: what changed, what was fixed in review, and what was deferred.
```

## 1. Make clear what and why

- If the request already states the purpose and the outcome, go to step 2.
- If something is missing, invoke the `superpowers:brainstorming` skill and ask the way it does. But in this mode:
  - Do not write a separate design document. **The backlog item file is that document.**
  - Do not move on to an implementation plan (do not invoke `superpowers:writing-plans`). `/task start` makes the plan.
  - If superpowers is not installed, say so and ask directly for the purpose, outcome, what is out of scope, and the acceptance criteria.
- Check `docs/backlog/` and `docs/done/` for an item that overlaps. If one does, do not create a new one; tell the user.
- If the request came from "Notes not yet turned into items" in `docs/backlog/README.md`, delete that line after creating the item.

## 2. Write the item (Backlog.md guidelines)

Follow `docs/backlog/_template.md`.

| Part | Rule (original wording) |
| --- | --- |
| `title` | "Use a clear brief title that summarizes the task." |
| `Description` | "Provide a concise summary of the task purpose and its goal. Explains the context without implementation details." Also note what is left out this time |
| `Acceptance Criteria` | "Outcome-Oriented: Focus on the result, not the method." "Testable/Verifiable: Each criterion should be objectively testable". Format: `- [ ] #1 sentence`. Bad example: "Add a `handleLogin()` function" |
| Size | "Tasks must be atomic and testable or verifiable" — small enough to review and merge at once. If larger, split it and record the order in `dependencies` |
| Dependencies | "Never reference future tasks (only tasks with id < current task id)" |
| `Implementation Plan` | "Do NOT include an Implementation Plan when creating a task." Leave it empty |

- The `id` and the number in the file name are one more than the largest number across `docs/backlog/` and `docs/done/`. Use three digits.
- File name: `<number>-<label>-<short-english-name>.md`
- `status: To Do`, `labels` from the list in `docs/backlog/README.md`, `created_date` and `updated_date` set to today.
- Keep the Definition of Done lines from the template. Add lines only this item needs.
- If the work contradicts the principles in the project's CLAUDE.md, do not create it; tell the user.

## 3. Show it and get approval

Show the item content to the user before writing the file. If you split it into several items, show all of them. If asked to change something, change it and show it again.

## 4. Save

1. Write the file.
2. If the project has a lint or format command, make sure it passes. If formatting fails, use the auto-fix command.
3. Commit: `docs(backlog): <number> <title>`. Include only the item file (and the note line you deleted). If other changes are present, stage only the item file and `docs/backlog/README.md`.
   - If left uncommitted, `/task start` stops at "uncommitted changes".
   - Do not push.
4. Tell the user the file path and number, and that `/task start <number>` starts it.
