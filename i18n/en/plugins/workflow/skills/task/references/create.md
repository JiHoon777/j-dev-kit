> Translation. Source: [plugins/workflow/skills/task/references/create.md](../../../../../../../plugins/workflow/skills/task/references/create.md). Update this file when the source changes. Claude does not read this file.

# task create: write one backlog item

Create one item file in `docs/backlog/`. The format follows the [Backlog.md](https://github.com/MrLesk/Backlog.md) agent guidelines, without using the tool. `/task end` moves finished items to `docs/done/`.

What to create: the arguments after `create`. If they start with `--survey`, follow "Survey mode" at the bottom.

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

Leave empty when creating. `/task start` writes the approved plan.

## Implementation Notes

What was learned while working, what changed from the plan.

## Final Summary

Written by `/task end`: what changed, what was fixed in review, what was deferred, findings left as is and why, what the user corrected.
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
- Another session may be creating an item at the same time. In step 4, count the number again right before writing the file; if that number appeared in the meantime, switch to the next number and say so.
- If the request came from a note, delete that line from `docs/backlog/README.md` after creating the item.

## 3. Show and get approval

Show the content before writing. If asked for changes, make them and show it again.

## 4. Save

1. Write the file, and if the project has a format command, run it until it passes.
2. Commit the item file and the deleted note line, plus any files newly created in step 0: `docs(backlog): <number> <title>`. For the first item from survey mode, include the report too. Do not include other changes. If they are left behind, `/task start` stops at "There are uncommitted changes". Do not push.
3. Report the path and number, and say that to start, use `/task start <number>` (or "start it").

## Survey mode (`create --survey <goal> [sources…] [--internal]`)

Do not hand-pick sources one at a time. Take the goal, and Claude researches inside (the repository) and outside and chooses what becomes an item. Only create items; do not call `start` or open sessions. There is no set number of candidates.

1. **Split the goal:** write the goal as one outcome sentence ("what has to get better for this to count as done") and a few research questions, and set an angle (inside, outside) for each question. A narrow goal gets fewer questions and angles. Show this in a few lines and go on to 2 without waiting for approval. If the user steps in to change it, follow them.
2. **Gather sources:** even when no sources are given, look both inside and outside.
   - Inside: error logs, `docs/backlog/` and `docs/done/`, the notes in the README, the issue list if available (`gh issue list`), usage data.
   - Outside: the official docs, changelogs and issues of the tools and libraries in use, other tools and precedents that do the same job, and writing and talks by practitioners in the field.
   - Sources the user gave (file or folder paths, command output, URLs) are a starting point and do not narrow the scope. Leave out the outside only when the user says so with `--internal` or in words.
   - Start searches with short, broad queries and then narrow. Put official docs, the original author's writing and the repository source ahead of summary articles.
   - Gather in parallel: open one subagent (general-purpose) per angle, in one message. Put in the prompt: the goal and the research questions it owns, the output format (the notes below), the sources to use (that angle's from the inside and outside lists above), and the boundaries (read only; write nothing but the notes file; run only commands that read; do not widen beyond its angle).
   - Each agent writes a note per source to `.claude/.local/survey/<date>-<short name>/<angle>.md` and returns only the path. A note: what was looked at, a short quote from the source, the location (`file:line`, command, URL), the date read, and **[direct]** (opened and read the source) or **[search]** (saw only a search-result summary).
   - Read the raw material. For each claim used as evidence for a candidate, the main session opens that source again to check it. If it cannot be opened, mark it **[search]** or drop it from the evidence. Run only commands that read.
3. **Pick candidates:** in the order notes → categories → counts.
   - Group the notes into categories across sources. Build the categories from the notes, not by fitting them into a frame set in advance. Group sources that look like the same cause into one category, and list every evidence location.
   - Count the evidence for each category.
   - Stop gathering when newly read sources no longer add a category. If they do, read more toward that category (2).
   - List as candidates only the categories that fit the goal. Write a candidate as a problem or need, not a solution, with the solution in one line under it. Add one line each for size (how much evidence, in how many places) and how directly it reaches the goal. Do not build a scoring formula.
   - For a candidate that comes from a bug report, try to reproduce it on the base branch. Attach how it was reproduced, or that it could not be, to the evidence.
     - In this folder, reproduce only in ways that just read. If it needs installs or builds, do it in a temporary worktree (`git worktree add <temp path> <base>`) and remove it when done (`git worktree remove <temp path>`). When done, check that `git status --short` is empty.
4. **Filter:** before showing the candidates, hand one new general-purpose **judge agent**, not this session, only the candidate list, the notes file paths, and the `docs/backlog/` and `docs/done/` paths. The model is the same as this session. Prompt: "Do not edit files. For each candidate, check whether the evidence supports the claim (open the source), whether it overlaps an existing item or something already fixed, and whether the source is primary, and write pass / drop with the reason. If unsure, do not pass it." Do not throw away dropped candidates; keep them under "Not proposed" with the reason.
5. **Report:** write it to `.claude/.local/reports/<date>-<short name>.md`.
   - The date checked and the marks (**[direct]**, **[search]**)
   - A summary of conclusions
   - A candidate table: problem or need, one-line solution, evidence (location and [direct]/[search]), size, how directly it reaches the goal, a way to check it is done (command, screen, number)
   - Not proposed, with reasons
   - What could not be read
6. **Show them at once:** show the report path and the candidate table, and let the user pick.
7. **Write:** write only the picked candidates, by the step 2 rules. Put the way to check into that item's Acceptance Criteria. Show the written items together and get approval once (step 3). Then, per item, recount the number and write it as in step 4, and commit it separately. Do not write candidates that were not picked.
   - If any candidate was picked, move the report to `docs/backlog/references/`, put its path as evidence in each item's Description, and include the report in the first item's commit. If none was picked, leave the report in `.claude/.local/reports/`.
