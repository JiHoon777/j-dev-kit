> Translation. Source: [plugins/workflow/skills/lead/references/run.md](../../../../../../../plugins/workflow/skills/lead/references/run.md). Update this file when the source changes. Claude does not read this file.

# lead run: start work sessions and direct them

Creating items, implementing, reviewing and merging follow the `/task` procedure files as they are. All this mode adds is splitting the work and taking what a work session would ask the user and raising it.

| Job | Procedure followed | Who |
| --- | --- | --- |
| Create an item | `${CLAUDE_SKILL_DIR}/../task/references/create.md` | Lead session |
| Plan and implement | `${CLAUDE_SKILL_DIR}/../task/references/start.md` | Work session |
| Review, fix, close the item | `${CLAUDE_SKILL_DIR}/../task/references/end.md` steps 1–6 | Work session |
| Wrap up (merge) | Step 7 of the same `end.md` | Lead session |

`/task` can only be invoked by the user, so do not call it with the Skill tool. Read the procedure files all the way through with the Read tool and follow them.

Items to run: the numbers after `run`. If none, choose in step 3.

## 1. Read the state

- The items in `docs/backlog/` (`README.md` and files starting with `_` are not items) and each item's `status` and `dependencies`
- `docs/backlog/_proposals.md` (skip if missing)
- The work branches and worktrees in "Current state": work already running or stopped

If this is not the base branch, or there are uncommitted changes (not counting the proposals file), stop and say so.

## 2. Promote proposals

If the proposals file has proposals, show them all at once and ask: promote / reject / leave.

- **Promote:** read `create.md` and follow it as it is to create the item. What to create is that proposal's title and evidence. Afterwards remove that line from the proposals file.
- **Reject:** write the title, date and reason under `## Rejected` in the proposals file and remove the original line.
- Do not start work from a proposal the user has not promoted.

## 3. Split the work

- Candidates: items with `status: To Do` whose `dependencies` are all in `docs/done/`. For an item that is `In Progress` with no session running, ask whether to continue it.
- Choose up to the "concurrent work sessions" number at a time. Judge for yourself what to run together. Items that touch the same place may run together; conflicts are resolved in step 6.
- Show the chosen items one line each, by number and title, and start right away.

## 4. Start work sessions

One session per item. Have it run in its own worktree cut from the base branch.

- If there is a tool that starts a new session, use it (the user can open the session and talk to it directly).
- Otherwise, use a background subagent isolated in a worktree. The Stop hook (which runs the verify command once the Definition of Done is checked) does not run for subagents. That check is covered by the verification the work session runs by the procedures (start step 6, end step 6) and by the verification before and after each merge in step 6.

A work session cannot see this conversation, so put in its instructions:

1. The item file path, base branch, verify command, document language.
2. The absolute paths of `start.md` and `end.md`. Read `start.md` all the way through and follow it as it is; when done, read `end.md` all the way through and follow its steps 1–6 as they are. Only the four things below differ.
3. **Wherever the procedure says to ask the user or get approval** (the questions and plan approval in start, the finding decisions in end step 4, the places that say stop and tell the user), do not ask directly. Report what you would ask and stop. The lead session passes on the user's words. Raise the plan as a report instead of using plan mode, and on approval continue from start step 4.
4. **Branch check:** this session is its own worktree, freshly cut from the base branch. Skip the branch check in start step 1. Other `w/` branches belong to other work sessions; do not touch them.
5. **New items:** where the procedure says to create a new backlog item, do not create it; write it in the report (the number would collide with other sessions).
6. **Merge:** do not do end step 7. Do not push.
7. **Report format:** on the first line the state (`awaiting plan approval` / `question` / `awaiting review decision` / `blocked` / `ready to merge`) and the item number. Then the branch name, a few lines on what you would ask or what was done, and what could not be verified.

## 5. Check reports and raise them

A report is that session's claim. Look for yourself before raising it.

| State | What to check | To the user |
| --- | --- | --- |
| Awaiting plan approval | That the plan contains what start step 3 requires, covers all of the item's Acceptance Criteria and adds nothing else | Plan summary, approve / what to change |
| Question, blocked | If code and docs can answer it, answer it yourself and send it back | Only what you cannot answer, right away |
| Awaiting review decision | That the findings are in the end step 4 format (🔴 / 🟡 / ⚪) and the 🔴 ones hold in the code | The end step 4 question as it is |
| Ready to merge | `git diff --stat <base>...<branch>`, that the item file is in `docs/done/` with AC and DoD checked, the `Final Summary`, the verification result | Step 6 |

- Bundle what arrives at the same time and raise it once. Raise questions and blockers without waiting.
- Pass the user's answer to the session by quoting their words as they are. If there is no answer, wait.
  - A work session started as a background subagent has reported and stopped. Do not start a new one; send to the same agent with the agent ID you got when starting it (SendMessage), so it continues with what it has read and done.
- If a report does not match reality, do not raise it to the user; write what differs and send it back.
- Show the user the "new items" a work session reported, and if they decide to create one, create it by `create.md`.

## 6. Wrap up (one at a time)

For each merge-ready branch the lead session does step 7 of `end.md`. The answer that step gets from the user is the merge approval.

- Also tell the skill that step 7 invokes: the branch to finish is `w/<item file name>` and it lives in the work session's worktree. The lead session is on the base branch.
- **Before merging:** in the work session's worktree, bring the latest base branch into the work branch (`git merge <base>`) and run the verify command. Overlaps with items merged earlier (such as bumping to the same version) show up here. If it fails, do not merge; send it back to that work session with the output.
- Finish only one branch at a time. Move to the next after one is done.
- On a conflict, look at the intent of both items and resolve it. If you cannot judge which side to keep, stop and ask.
- Run the verify command fresh after every merge. If it fails, stop the next merge and say so. Do not revert on your own.
- Propose cleaning up the work session and worktree of each merged item.

## 7. Next

- If a slot is free and candidates remain, go back to step 3.
- When finished, report: merged items, what is waiting for approval, what stopped, and the remaining `To Do` items.
