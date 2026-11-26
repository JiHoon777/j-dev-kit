> Translation. Source: [plugins/workflow/skills/start/references/procedure.md](../../../../../../../plugins/workflow/skills/start/references/procedure.md). Update this file when the source changes. Claude does not read this file.

# start procedure: implement one item through to the merge

Plan, implement, review, and wrap up **one** backlog item. Stop and ask only at what falls under the asking criteria in `SKILL.md`. Decide the rest and go to the end, writing it into the item file.

Requested item: the arguments.

Run every command from the repository root (`git rev-parse --show-toplevel`). When working in a worktree, that is the worktree's root. If the project CLAUDE.md has PR/push rules, follow them.

## 1. Can we start

Check the state with `git branch --show-current`, `git status --short`, `git branch --list 'w/*'`, and `git log --oneline <base>..HEAD`.

| Check | If it applies |
| --- | --- |
| The base branch has no commits | Say that a first commit is needed, and stop |
| There are uncommitted changes | Show them and ask what to do. Do not discard them on your own |
| You are on this item's `w/` branch | Continue without asking ("Continuing" below) |
| You are in a worktree just made for this item | Go ahead: you are in a worktree (the two lines of `git rev-parse --path-format=absolute --git-dir --git-common-dir` differ) and the branch has no commits after the base branch. If its name is not `w/<name>`, rename it in step 4 |
| This item's `w/` branch already exists and you are not on it | If the session that worked on that branch still exists, tell the user to continue there. If it does not, continue here: if the branch is in another worktree (`git worktree list`), move there by giving that path to `EnterWorktree` (if the tool is missing or refuses, run later commands in that folder); otherwise `git switch w/<name>` |
| You are on neither the base branch nor this item's branch | It may belong to another item or another session. Leave it alone and ask what to do |

Finding the item: look up the argument in `docs/backlog/` (`README.md` and files starting with `_` are not items). If there is no match or several, show the `To Do` items by number and title and let the user pick. Read the item file all the way through, and check that all of its `dependencies` are in `docs/done/`.

**Continuing:** read the item file's `Implementation Plan`, its checked Acceptance Criteria, and `Implementation Notes`, and resume from the step that remains.

- Implementation remains → step 5
- Every AC is checked → step 7 (review)
- The item is already in `docs/done/` → step 12 (merge)

## 2. Baseline and stack checks

0. **Worktree setup:** if this is a worktree:
   - If the project needs dependencies installed (for example `package.json` and a lockfile), install them before the baseline. A new worktree has nothing installed, and a baseline taken before installing hides real failures.
   - If the worktree is inside the base folder (for example `.claude/worktrees/`) and the test, lint or type-check tools read into that folder, verification in the base folder also runs other items' code. If those tool settings do not leave it out, say so.
1. **Baseline:** Run the verify command once. Record only what already fails (the command, the names of failing tests/files). This does not block the work; tell the user. Later verification compares against this to look only at new failures.
2. **Stack checks:** Call, with the Skill tool, every available skill whose name ends in `-start-check` (e.g. `server:server-start-check`). A check that does not apply returns only "not applicable". What comes back:
   - **Follow:** rules to follow and skills to call during implementation
   - **Before planning:** work to finish before the plan (for example mockups). Do it before going to step 3
   - **Put in the plan:** only when it applies to this item
   - **Ask:** only when there is something it cannot decide. Combine these into the pre-start questions in step 3

## 3. Plan

Do not get the plan approved. Do not enter plan mode.

1. **Restate:** in the first message, restate the goal and the smallest change that meets it in one or two sentences.
2. **Match the reading to the size.**
   - Small item (a few files, no new structure): read the relevant code directly, without agents.
   - Large item (several modules, new structure): launch `Explore` agents on different areas in one message. Have them return the files that must be read, then read those files directly.
3. **Playbook:** from the index in `SKILL.md`, pick the playbook that fits the nature of the item and move its steps into the to-do list. If none fits, step 5 of this procedure is the default flow.
4. **Tools and steps:** decide which field this item's work belongs to, and what tools (names, commands) and steps the best practitioners in that field use for it. Do not assume a role; write down the tools and steps. If you do not know, look it up in docs or on the web. Keep the tools the stack checks gave and add only what is missing.
5. **Design:** decide it yourself. For a change that crosses a function boundary, follow `skills/architect.md`. Settle a fork that running something would settle with `playbooks/prototype.md`, and write down the result and the evidence.
6. **Gaps in the ACs:** if, while reading the item, you find ACs that contradict each other or a missing decision that only a person can make, put it in the pre-start questions.
7. **Pre-start questions:** only when something falls under the asking criteria, all at once. Combine the stack checks' "Ask" and what is asked once per project (installing official skills, creating a verification skill) into them. Attach a recommendation and its reason to the options. If there is nothing to ask, do not stop.
8. **Write the plan.** Step 4 writes it into the item file. What goes in:
   - What we do: one or two sentences, what is left out this time
   - The chosen playbook, tools and steps (including what to install)
   - Files to change and the job of each, tests to write first, order
   - Success criteria: how each Acceptance Criterion is checked (command, screen, judge agent)
   - The stack checks' "Put in the plan"
   - Decisions

If the user says "let me see the plan", show the plan and wait.

## 4. Record

1. Set up the work branch `w/<item file name without .md>` (`<name>` below).
   - If you are on the base branch: `git switch -c w/<name>`.
   - If you are in a worktree made for this item and the branch name differs: `git branch -m w/<name>`. The verify Stop hook runs only on `w/` branches.
   - If a web port or server port is set, set the item's port to `base port + item number` (for example web 5000, item 007 → 5007). Only the ones that are set.
     - For each port, run `bash <scripts>/pick-port.sh <base port> <item number>` and use the port on the first line. If it exits with a non-zero value, tell the user the reason it printed.
     - Write the ports into the item file as soon as they are set, so that another session started at the same time can see them.
2. Item file: `status: In Progress`, `updated_date` today, the plan in `Implementation Plan`, the baseline under `### Baseline` in `Implementation Notes`, the ports you set under `### 포트` (one per line, like `- 웹: 5007`), the decisions under `### 정한 것`.
3. Commit: `chore(backlog): <number> start`

## 5. Implement

- Follow the chosen playbook's steps, the plan's tools and steps, and the stack checks' Follow.
- **Tests:** if there is a cheap, clear way to test, write a failing test first, and before fixing, run it to see that it fails for the intended reason. If there is no such way (it needs a broad harness, the mocks break easily, there is only a slow e2e, or only docs or config change), do not force one. Use the closest run check (command, script, browser) and write down why. No test is better than a bad test. Tests assert observable behavior (`principles/test-behavior-not-implementation.md`).
- Do not delete or weaken existing tests to make them pass (deleting, skipping, raising time limits, updating snapshots). If you think a test is wrong, stop and ask.
- Do only what is in the Acceptance Criteria. Do not polish surrounding code. If other work seems needed, note it and raise it as a "later" candidate in step 10.
- **Stop when the scope grows.** If one of the four below applies, stop and ask. Decide anything else that changed, and write it down.
  - A behavior not in the ACs has to be added
  - A new dependency or tool has to be installed
  - A schema or public API has to change, or something has to be deleted
  - CLAUDE.md or settings have to change
- When one AC is done, check it off right away only if there is outside evidence (command output). ACs that need a judge are judged together in step 6.
- Write what you decide without asking under `### 정한 것` as you go. Write what changed from the plan in `Implementation Notes` too.
- Commit to the work branch at each meaningful step. Before committing, follow `skills/deslop.md`. Do not commit to the base branch.

## 6. Wrap-up check

1. **Clean up:** follow `skills/deslop.md` on the diff against the base branch. Fix without asking, and do not change behavior. Write one line on what was fixed.
2. **Verify:** Run the verify command fresh and show the result. If there are failures not in the baseline, fix them. Do not let the memory of an earlier pass stand in for it.
3. **Screen check:** Do it if the stack checks' Follow includes a browser check and the UI changed. If the project has a `verify-*` skill, follow that skill and its feature map. Write what was done and seen in `Implementation Notes`. If there is no tool for it, do not stop. Write it as "could not verify" and continue, and collect it in the step 10 message.
4. **AC judgment:** the implementing session does not judge and check off ACs by itself. Check off only those that have one of these:
   - Outside evidence: the command that shows the result (test, grep, CLI) and its output are written in `Implementation Notes`.
   - A judge other than the implementing session: for UI, the screen check from 3; otherwise a new general-purpose judge agent said pass. Give the judge agent only the item file path and the `git diff <base>...HEAD` range, not how it was implemented. Brief: "Do not edit files. For each AC write pass / fail / could not verify with evidence (`file:line`, command output). When unsure, do not leave it as pass."

   Fix "fail" and get judged again. If the same AC still fails after three fixes, stop fixing and tell the user which AC failed and what you tried. The premise may be wrong (`principles/attack-the-premise.md`). Do not check off "could not verify"; raise it in the step 10 message. Check off Definition of Done the same way, and commit. Leave no uncommitted changes.

Go on to step 7 without asking.

## 7. Prepare the review

1. **Stack checks:** Call, with the Skill tool, every available skill whose name ends in `-end-check` (e.g. `server:server-end-check`). Each check runs its inspection tools only when the change touched its area, and returns:
   - **Failures:** put them in the step 9 findings list as 🔴 without going through the judge. The check tool's output is the evidence.
   - **Agents to add to the review:** add them to step 8 (with the evidence).
   - **To do after fixing:** do it in step 9.
2. **Do the tests prove the fix:** before the review, run the tests added or changed on this branch against the base branch's source. The script changes files for a while, so do not run it alongside the review agents.
   - Settle, from the project (CLAUDE.md, package.json scripts, test config), the command that runs one test file, with `{}` in place of the file (for example `pnpm vitest run {}`, `pytest {}`, `bash {}`).
   - `bash <scripts>/base-tests.sh <base> '<that command>'`. If the project's test files cannot be picked by name, add the files at the end, and if there are test helpers outside the naming rules (for example `src/testing/`), prefix `BASE_TESTS_KEEP='<path regex>'`.
   - Put each `기준에서도 통과: <file>` (also passes on base) line of the output into the findings list as 🟡 "does not prove the fix. It passes without the fixed code", without going through the judge.
   - If the output is `바뀐 테스트 없음.` (no changed tests, exit value 2), add the test files outside the naming rules and run again; if there are none, raise "could not verify. No tests found on this branch" in the step 10 message.
   - If the command cannot be settled or the exit value is 2 for another reason, write "could not verify" and the reason in `Implementation Notes`; for each `HEAD 에서 실패: <file>` (fails on HEAD) line, whatever the exit value, write that test as "could not verify"; then move on.
3. If the change is small but reaches wide, follow `skills/blast-radius.md` and put what it finds into the findings list.

## 8. Review (agents, in parallel in one message)

| Agent | When | What it does |
| --- | --- | --- |
| general-purpose | Always | Calls the `code-review` skill. Target is the current branch. No `--fix`, no `--comment`, no effort level given |
| general-purpose | When authentication/authorization, input handling, secrets, external calls, or file/command execution changed | Calls the `security-review` skill. Before launching, if `git symbolic-ref refs/remotes/origin/HEAD` fails, run `git remote set-head origin -a` |
| Stack review agents (`frontend:frontend-reviewer`, `frontend:design-reviewer`, `server:api-reviewer`, `server:supabase-reviewer`) | When step 7 returned them | By that agent's own criteria |

**Model:** if this session is Fable, give every agent above the Agent tool's `model` set to the latest model one tier lower (now `opus`). If it is Opus or lower, do not give `model`.

Agents cannot see this conversation, so put these in the instructions:

1. Scope: `git diff <base>...HEAD`, the item file path, CLAUDE.md. For stack review agents, also the evidence the check returned with them.
2. Do not edit files and do not commit. Do not touch remote or production environments. general-purpose agents do not start servers and do not run build/verify commands (the reviewers run at the same time in the same folder). Stack review agents start servers, install tools, or reproduce locally only when that agent's criteria allow it.
3. Principles: the contents of `docs/review-principles.md` if it exists. Report findings that seem to go against a principle too, and say which principle they clash with.
4. The user decided only the Acceptance Criteria and what the user answered. `### 정한 것` and `Implementation Plan` in the item file are what Claude decided, so they are under review.
5. Report: every problem found, split into confirmed and unconfirmed, as `file:line — problem — how to fix`. Do not give scores.
6. If the skill cannot be called, do not make something up in its place; report that.

## 9. Judge and fix

After all have returned, this session does not pick findings. Pass all the reports, as written, to one new general-purpose **judge agent**. Its model is the same as this session's. Brief:

- Scope: 1 and 4 in step 8, plus `docs/review-principles.md`.
- "Do not edit files. Merge duplicates, check each finding against the code, and judge it valid / wrong with evidence (`file:line`). A finding that goes against a principle is wrong. Count problems that existed before this change separately as pre-existing. Sort the valid ones into 🔴 (confirmed bugs, security problems, data loss, AC violations, stack check failures) / 🟡 (real problems that do not block the merge) / ⚪ (minor). Among the valid findings, mark as 'for a person to decide' those that clash with the Acceptance Criteria or with what the user answered, and those whose fix depends on a product or taste decision. Mark those beyond this item's scope as 'later candidate'. If the same kind is in the Final Summary `리뷰에서 고친 것` (fixed in review) of an item in `docs/done/`, or it appears in several places across these reports, mark it 🔁 with the evidence (item number or locations)."

**Fix valid 🔴 and 🟡 without asking.** Do not fix "for a person to decide" and "later candidate"; pass them on to step 10. Do not fix ⚪; write only the count. If an agent suggests changing permissions, CLAUDE.md, or `.claude/` settings, do not change them; raise it as a suggestion in step 10.

How to fix:

- Check the finding against the code yourself, then fix it. If a finding turns out to be wrong, write the reason and do not fix it.
- Fixes that change behavior follow the test rules in step 5.
- Fixes that need judgment (changing the design, spanning several files, or with no settled way to fix) are made by this session itself.
- Mechanical fixes, where the finding states exactly where and what to change and no judgment is left, can be collected and handed to one agent (Agent tool `model: sonnet`, `effort: high`). If you hand them over, the prompt includes that list of findings, the item file path, and "do not fix anything outside the list and do not commit".
- Do not judge the fixes by the fixer's report. Run the verify command, and for each fixed finding have a new general-purpose judge agent decide whether it is fixed, given only the item file path, the list of fixed findings, `git diff HEAD` and `git status --short`. Its prompt: "Do not edit files. For each finding, write fixed / not fixed with evidence (`file:line`). If unclear, do not leave it as fixed." For UI, step 7's "To do after fixing" judges.
- If the same finding is still there after three fixes, stop fixing and tell the user the finding and what you tried.
- Do step 7's "To do after fixing" for the fixed parts. If a fix touched a stack check's area, call that `*-end-check` again.
- Write what was fixed and seen in `Implementation Notes` and commit.

## 10. Last message (once)

Stop here once. Always ask about the merge. Put every remaining decision into this one message. If the verify command line changed in `git diff <base>...HEAD -- CLAUDE.md`, also include "This branch changed the verify command (old → new). Until the merge, the verify Stop hook judges with the base branch's command".

How to write it:

- On the first line, write what is waiting for the user.
- Then what was done, briefly: what changed, the result per AC, what was fixed in review (the 🔴 and 🟡 counts and one line each), N dropped by the judge, N pre-existing problems, N ⚪.
- Attach a recommendation, the evidence, and the risk to each decision. Write it so that the user can decide from the reply alone.
  - Findings for a person to decide: the finding, the options, the recommendation
  - "Later" candidates: whether to make them new items. Attach a title and draft ACs to each candidate
  - How to merge: local merge / PR / leave as is. Whether to push the base branch goes with it
  - Any suggested change to permissions or settings
- Write decisions with a high cost if wrong, and what could not be verified, as notices, not as decisions to make.
- Do not raise as a question what Claude can do by itself.
- Write in plain words and short sentences. Include hashes, paths, and commands only when the user needs them to act.

When the answer comes:

- Fix the findings for a person to decide as decided, and check them again the step 9 way.
- For candidates chosen as "later", invoke the `backlog` skill with `<the finding and its evidence> --here` to make a new item. The draft ACs were already shown, so do not get approval again.
- Do not take a vague answer ("looks fine") as permission to merge. Ask again only about how to merge.

## 11. Verify and close the item

1. Run the verify command fresh once. If there are failures not in `### Baseline`, stop and say so.
2. Write the item's `Final Summary`: what changed, what was fixed in review, what was deferred (new item numbers), findings left as is and why, what the user corrected (one line each).
3. **Principles:** if a reason for leaving a finding as is, or something the user corrected, holds for other items too, add it to `docs/review-principles.md` as one line (`- principle — reason (item number)`). Do not add a principle that is already there. If a check can block it instead of prose, that is better (`principles/encode-lessons-in-structure.md`).
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

## 12. Merge

Do it the way the user chose in step 10.

- **Local merge:**
  - If the work was done in a worktree, the base branch is in the base folder (the first line of `git worktree list`). Run the merge there, like `git -C <base folder> merge …`. Before merging, check that the base folder is on the base branch (`git -C <base folder> branch --show-current`) and clean (`status --short`); if not, stop and say so.
  - If the base branch has an upstream, bring it up to date with `git pull` first. If it has none, skip that.
  - If there is a conflict, follow `skills/fix-merge-conflicts.md`.
  - After merging, run the verify command again on the base branch. If it fails, do not push; say so.
  - If the session is inside a worktree, do not remove the worktree or the branch from this session. Say that archiving the session lets the app clean up the worktree, and otherwise running `git worktree remove <worktree path>` and `git branch -d w/<name>` in the base folder does it. If no worktree was used, delete the branch with `git branch -d w/<name>`.
- **PR:** push the work branch and open a PR. If a PR cannot be created (CLAUDE.md says so, or `gh auth status` fails), say so. Leave the worktree.
- **Leave as is:** do nothing. Leave the worktree and the branch.

Push the base branch and deploy branches only when the user asks. Do not force-push.

When done, report: the merged commits, the moved item file, new items, and the remaining `To Do` items (`README.md` and files starting with `_` are not items).
