> Translation. Source: [plugins/workflow/skills/lead/references/run.md](../../../../../../../plugins/workflow/skills/lead/references/run.md). Update this file when the source changes. Claude does not read this file.

# lead run: start work sessions and direct them

Raise proposals to the user and turn them into items, start a work session per item, check the reports and raise them to the user at the plan and merge points, and merge the approved branches.

Items to run: the numbers after `run`. If none, choose in step 3.

## 1. Read the state

- The items in `docs/backlog/` (`README.md` and files starting with `_` are not items) and each item's `status` and `dependencies`
- `docs/backlog/_proposals.md` (skip if missing)
- The work branches and worktrees in "Current state": work already running or stopped

If this is not the base branch, or there are uncommitted changes (not counting the proposals file), stop and say so.

## 2. Promote proposals

If the proposals file has proposals, show them all at once and ask: promote / reject / leave.

- **Promote:** read `${CLAUDE_SKILL_DIR}/../task/references/create.md` and create the item by its steps 2–4. Remove that line from the proposals file.
- **Reject:** write the title, date and reason under `## Rejected` in the proposals file and remove the original line.
- Do not start work from a proposal the user has not promoted.

## 3. Split the work

- Candidates: items with `status: To Do` whose `dependencies` are all in `docs/done/`. For an item that is `In Progress` with no session running, ask whether to continue it.
- Choose up to the "concurrent work sessions" number at a time. Judge for yourself what to run together. Items that touch the same place may run together; conflicts are resolved in step 6.
- Show the chosen items one line each, by number and title, and start right away.

## 4. Start work sessions

One session per item. Have it run in its own worktree cut from the base branch.

- If there is a tool that starts a new session, use it (the user can open the session and talk to it directly).
- Otherwise, use a background subagent isolated in a worktree.

A work session cannot see this conversation, so put in its instructions:

1. The item file path, base branch, verify command, document language.
2. The absolute path of `${CLAUDE_SKILL_DIR}/../task/references/start.md`. Read that file all the way through and follow it, but the lines below take precedence.
3. This session is its own worktree, freshly cut from the base branch. Skip the branch check in start step 1. Other `w/` branches belong to other work sessions; do not touch them.
4. **Plan:** do not use plan mode. Report the plan and stop. When the approval message arrives, continue from start step 4.
5. **After implementing:** do steps 1–6 of `end.md` in the same folder. Do not ask in step 4. Fix the 🔴 findings; do not fix the 🟡 ones, write them in the report. Do not do step 7 (merge). Do not push.
6. Do not create new backlog items. Write other work that seems needed in the report.
7. Report and stop on anything you do not know, on scope growing, and on a failure that was not in the baseline and that you cannot fix.
8. **Report format:** on the first line the state (`awaiting plan approval` / `question` / `blocked` / `ready to merge`) and the item number. Then the branch name, a few lines on what was done or planned, the 🟡 findings left, and what could not be verified.

## 5. Check reports and raise them

A report is that session's claim. Look for yourself before raising it.

| State | What to check | To the user |
| --- | --- | --- |
| Awaiting plan approval | That the plan covers all of the item's Acceptance Criteria and adds nothing else | Plan summary, approve / what to change |
| Question, blocked | If code and docs can answer it, answer it yourself and send it back | Only what you cannot answer, right away |
| Ready to merge | `git diff --stat <base>...<branch>`, the AC and DoD checks and `Final Summary` in the item file, the verification result | Step 6 |

- Bundle plans and merge-ready reports that arrive at the same time and raise them once. Raise questions and blockers without waiting.
- Pass the user's answer to the session by quoting their words as they are. If there is no answer, wait.
- If a report does not match reality, do not raise it to the user; write what differs and send it back.

## 6. Merge (one at a time)

Show the merge-ready branches and ask: what changed, the remaining 🟡 (fix now / new item / leave), and whether to merge.

1. Merge only the branches the user approved, one at a time, into the base branch. Follow the PR and push rules in the project CLAUDE.md if there are any. Push only on request.
2. On a conflict, look at the intent of both items and resolve it. If you cannot judge which side to keep, stop and ask.
3. Run the verify command fresh after every merge. If it fails, stop the next merge and say so. Do not revert on your own.
4. Send "fix now" back to that work session. Create "new item" as in step 2.
5. Propose cleaning up the work session and worktree of each merged item.

## 7. Next

- If a slot is free and candidates remain, go back to step 3.
- Show the "other work" that work sessions reported together with the proposals in the next step 2.
- When finished, report: merged items, what is waiting for approval, what stopped, and the remaining `To Do` items.
