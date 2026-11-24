> Translation. Source: [plugins/workflow/skills/task/references/end.md](../../../../../../../plugins/workflow/skills/task/references/end.md). Update this file when the source changes. Claude does not read this file.

# task end: review and merge

Review the work branch's changes, fix what the user decides, close the item, and finish the way the user chooses.

If the project CLAUDE.md has PR/push rules, follow them. At the start, check the state with `git branch --show-current`, `git status --short`, `git log --oneline <base>..HEAD`, and `git diff --stat <base>...HEAD`.

## 1. Can we start

If any of these applies, stop and say so.

| Check | If it applies |
| --- | --- |
| The branch does not start with `w/` | Ask which branch |
| There is no item file matching the branch name | Ask which item |
| There are uncommitted changes | Ask whether to commit or discard them. Do not discard on your own |
| There are no changes in `<base>...HEAD` | Say there is nothing to review |

Read the item file. If it is already in `docs/done/`, start from step 6.

## 2. Stack checks

Call, with the Skill tool, every available skill whose name ends in `-end-check` (e.g. `server:server-end-check`). Each check runs its inspection tools only when the change touched its area, and returns:

- **Failures:** put them in the step 4 findings list as 🔴 without going through the judge. The check tool's output is the evidence.
- **Agents to add to the review:** add them to step 3 (with the evidence).
- **To do after fixing:** do it in step 5.

**Do the tests prove the fix:** after the stack checks and before the review, run the tests added or changed on this branch against the base branch's source. The script changes files for a while, so do not run it alongside the review agents.

- Settle, from the project (CLAUDE.md, package.json scripts, test config), the command that runs one test file, with `{}` in place of the file (for example `pnpm vitest run {}`, `pytest {}`, `bash {}`).
- `bash <task-scripts>/base-tests.sh <base> '<that command>'`. If the project's test files cannot be picked by name, add the files at the end.
- Put each `기준에서도 통과: <file>` (also passes on base) line of the output into the step 4 findings list as 🟡 "does not prove the fix — passes without the fixed code", without going through the judge. The script output is the evidence.
- If the command cannot be settled, or the exit value is 2 (including `HEAD 에서 실패` lines, fails on HEAD), write "could not check" and the reason in `Implementation Notes` and move on.

## 3. Review (agents, in parallel in one message)

| Agent | When | What it does |
| --- | --- | --- |
| general-purpose | Always | Calls the `code-review` skill. Target is the current branch. No `--fix`, no `--comment`, no effort level given |
| general-purpose | When authentication/authorization, input handling, secrets, external calls, or file/command execution changed | Calls the `security-review` skill. Before launching, if `git symbolic-ref refs/remotes/origin/HEAD` fails, run `git remote set-head origin -a` |
| Stack review agents (`frontend:frontend-reviewer`, `frontend:design-reviewer`, `server:api-reviewer`, `server:supabase-reviewer`) | When step 2 returned them | By that agent's own criteria |

**Model:** if this session is Fable, give every agent above the Agent tool's `model` set to the latest model one tier lower (now `opus`). If it is Opus or lower, do not give `model` (they run on the same model as this session).

Agents cannot see this conversation, so put these in the instructions:

1. Scope: `git diff <base>...HEAD`, the item file path, CLAUDE.md. For stack review agents, also the evidence the check returned with them.
2. Do not edit files and do not commit. Do not touch remote or production environments. general-purpose agents do not start servers and do not run build/verify commands (the reviewers run at the same time in the same folder). Stack review agents start servers, install tools, or reproduce locally only when that agent's criteria allow it.
3. Principles: the contents of `docs/review-principles.md` if it exists. Do not raise findings that go against a principle.
4. Report: every problem found, split into confirmed and unconfirmed, as `file:line — problem — how to fix`. Do not give scores.
5. If the skill cannot be called, do not make something up in its place; report that.

## 4. Judge, show and ask

After all have returned, this session does not pick findings. Pass all the reports, as written, to one new general-purpose **judge agent**. Its model is the same as this session's. Brief:

- Scope: same as 1 in step 3, plus `docs/review-principles.md`.
- "Do not edit files. Merge duplicates, check each finding against the code, and judge it valid / wrong with evidence (`file:line`). A finding that goes against a principle is wrong. Count problems that existed before this change separately as pre-existing. Sort the valid ones into 🔴 / 🟡 / ⚪ below. If the same kind as a valid finding is in the Final Summary `리뷰에서 고친 것` (fixed in review) of an item in `docs/done/`, or it appears in several places across these reports, mark it 🔁 with the evidence (item number or locations)."

The user sees only findings judged valid and step 2 stack check failures and test check results. Those judged wrong are written only as a count, "N dropped by the judge", and pre-existing ones as "N pre-existing problems". Do not show scores.

```markdown
🔴 Must fix — confirmed bugs, security problems, data loss, AC violations, stack check failures
- src/a.ts:12 — problem — how to fix (code-review)
- src/b.ts:30 — problem — how to fix (code-review) 🔁 also fixed in 006

🟡 Consider — real problems but do not block the merge
- …

⚪ 4 minor (say so if you want to see them)
```

Ask once: "I'll fix 🔴 now. For 🟡: now / later (new item) / leave as is?" If there are findings marked 🔁, add "For 🔁, along with the fix you can also choose to block it with a lint rule, test or type (new item)". A repeated mistake is better blocked by an automatic check than warned against in prose. Do not attach this choice to findings without 🔁. If the user wants, decide one at a time. If an agent suggests changing permissions, CLAUDE.md, or `.claude/` settings, do not change them; pass it on as a suggestion.

Do not fix anything before getting an answer.

## 5. Fix

- Call the `superpowers:receiving-code-review` skill and follow it (check findings against the code; for wrong findings, give the reason and do not apply them).
- For fixes that change behavior, write a failing test first.
- Do step 2's "To do after fixing" for the fixed parts (e.g. browser-check only the fixed screens). If a fix touched a stack check's area, call that `*-end-check` again.
- For "later" and "block", invoke the `task` skill with `create <the finding and its evidence> --here` to make a new item. For "block", also pass the means to block it (lint rule, test or type), and fix the finding itself as the user chose. The user already chose, so for create step 3's approval, show only the item's content and get approval.
- Write what was done and seen in `Implementation Notes` and commit.

## 6. Verify and close the item (Backlog.md definition of done)

1. Run the verify command fresh once. If there are failures not in `### Baseline`, stop and say so.
2. Write the item's `Final Summary`: what changed, what was fixed in review, what was deferred (new item numbers), findings left as is and why, what the user corrected (during `start` and `end`, one line each).
3. **Principles:** if a reason for leaving a finding as is, or something the user corrected, holds for other items too, add it to `docs/review-principles.md` as one line (`- principle — reason (item number)`). Do not add a principle that is already there.
4. Close only when everything is in place. If anything is missing, stop and say so.
   - [ ] All Acceptance Criteria checked
   - [ ] All Definition of Done checked
   - [ ] `Final Summary` written
5. On the work branch:

```bash
# after changing the item file's status to Done and updated_date to today
git mv docs/backlog/<file> docs/done/<file>
git add -A docs/
git commit -m "docs(backlog): <number> done"
git status --short   # must be empty
```

## 7. Finish

Call the `superpowers:finishing-a-development-branch` skill and follow it. This skill shows options and waits for the user's answer. That is the merge approval. Tell the skill:

- The verify command just passed in step 6. The base branch is the one from project settings.
- If no worktree was used, there is no worktree to remove.
- If this session worked in a worktree (the two lines of `git rev-parse --path-format=absolute --git-dir --git-common-dir` differ, for example a sub-session `start` opened), this line takes precedence over the skill's matching steps for merging and cleanup. The base branch is in the base folder (the first line of `git worktree list`), so run the merge there, like `git -C <base folder> merge …`. Before merging, check that the base folder is on the base branch (`git -C <base folder> branch --show-current`) and clean (`status --short`); if not, stop and say so. The session is inside that worktree, so do not remove the worktree or the branch from this session. If a local merge was chosen, say that archiving the session lets the app clean up the worktree, and otherwise running `git worktree remove <worktree path>` and `git branch -d w/<name>` in the base folder does it. If a PR or keeping it as is was chosen, leave the worktree.
- If a PR cannot be created (CLAUDE.md says so, or `gh auth status` fails), say so.
- If the base branch has no upstream, skip `git pull`.
- Push only when the user asks.

When done, report: the merged commits, the moved item file, new items, and the remaining `To Do` items (`README.md` and files starting with `_` are not items).
