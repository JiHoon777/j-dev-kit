> Translation. Source: [plugins/workflow/skills/start/references/procedure.md](../../../../../../../plugins/workflow/skills/start/references/procedure.md). Update this file when the source changes. Claude does not read this file.

# start procedure: implement one item through to the merge

Plan, implement, review, and wrap up **one** backlog item. Stop and ask only at what falls under the asking criteria in `SKILL.md`. Decide the rest and go to the end, writing it into the item file.

Requested item: the arguments.

Below, "follow the `<name>` skill" means: read that skill's body file (`<this skill's folder>/../<name>/SKILL.md`) with the Read tool, as the index in `SKILL.md` says, and follow it. A playbook is at `<this skill's folder>/playbooks/<name>.md`.

Run every command from the repository root (`git rev-parse --show-toplevel`). When working in a worktree, that is the worktree's root. If the project CLAUDE.md has PR/push rules, follow them.

When launching a subagent, write `먼저 <ref>/worker.md 를 읽는다.` (read `<ref>/worker.md` first), with an absolute path, as the first line of the brief, and open the next line with the goal. The same goes for review and judge agents.

## 0. Without an item

If the user wrote the task directly instead of a backlog item, do not create an item file. Only the following differs; the rest is the same.

- **The contract is the user's words.** In the first message, restate the goal, the smallest change that meets it, and the condition for calling it done (a command to run or a screen to check), then go straight on. Do not wait for approval. If the words are ambiguous enough that what to build forks, ask just that, once.
- **What is skipped:** finding the item in step 1, the item file record and the start commit in step 4, and step 11 (closing the item).
- **Branch:** if you are on the base branch or on a merged `w/` branch (the table in step 1), make a `w/<short-english-name>` worktree as in "Making the worktree" in step 1 and work there. On any other branch, work on that branch as is. But if that is a `w/` branch with an item file and the task has nothing to do with that item, ask once whether to put it on this branch (it would mix with another item's work). For a read-only investigation (`playbooks/investigation.md`), do not create a branch.
- **Record:** there is no item file, so write the plan and the decisions (`decision — reason — cost if wrong`) in the last message, and write what changed and why in the commit messages.
- **Judgment:** treat the restated done condition like Acceptance Criteria. Call done only what outside evidence (command output) or a judge other than the implementing session confirmed. The verify Stop hook runs only when there is an item file, so be sure to run step 6's verification yourself.
- **When handing to agents:** where a brief says to pass the item file path, put in the restated goal and done condition and the user's words as they are. What a skill says to write in the item file (for example, the chosen mockup) goes in the last message.
- **Match the review to the size.** For a change of a few lines, launch only one `code-review` agent. Call the stack checks (`-start-check`, `-end-check`) as usual.
- **Last message:** the same as step 10. If the work was done on a newly created `w/` branch, ask how to merge. If you were somewhere other than the base branch from the start and worked on that branch as is, do not ask about the merge; report only what was committed and the remaining decisions.
- **Continuing:** if you are on a `w/` branch and there is no item file with that name in `docs/backlog/` or in `docs/done/`, it is work that was being done without an item. Read what was done from `git log <base>..HEAD` and the diff, take the task left in the arguments and the conversation as the contract, and go on from the remaining steps. If you cannot tell what the task is, ask only that.

If the work is large or no playbook fits, follow the `figure-it-out` skill. If a place to keep the plan and the decisions is then needed, invoke the `backlog` skill with `<task> --here` to make an item and continue with that item.

## 1. Can we start

**Updating the base:** first run `bash <scripts>/make-worktree.sh <base>` (if `SKILL.md` already did, do not run it again). From whatever folder it is called, it pulls the base branch up to date in the base folder (the first line of `git worktree list`; skipped with no upstream) and writes the base folder path on the first line. If the user said not to pull, add `--no-pull` as the first argument to this call and to the call in "Making the worktree" below (`make-worktree.sh --no-pull <base> [<name>]`). Exit code 1 means the pull failed and the local base branch is used as it is: say the reason it printed. Exit code 2 writes no path, so use the first line of `git worktree list` as the base folder, say the reason, and go on.

Then check the state with `git branch --show-current`, `git status --short`, `git branch --list 'w/*'`, and `git log --oneline <base>..HEAD`.

| Check | If it applies |
| --- | --- |
| The base branch has no commits | Say that a first commit is needed, and stop |
| There are uncommitted changes | Show them and ask what to do. Do not discard them on your own |
| You are on this item's `w/` branch | Continue without asking ("Continuing" below) |
| You are in a worktree just made for this item | Go ahead: you are in a worktree (the two lines of `git rev-parse --path-format=absolute --git-dir --git-common-dir` differ), the branch has no commits after the base branch, and the branch name is this item's `w/<name>` or does not start with `w/` (a name the app gave). If its name is not `w/<name>`, rename it in step 4 |
| You are on another `w/` branch (including one worked without an item) and that branch was merged: the first line of `git merge-tree --write-tree <base> HEAD` equals `git rev-parse <base>^{tree}` (it has nothing to add to the base branch; this also catches squash merges and branches with no commits) | Make a new one with "Making the worktree" below |
| This item's `w/` branch already exists and you are not on it | If the session that worked on that branch still exists, tell the user to continue there. If it does not, continue here: if the branch is in another worktree (`git worktree list`), move there by giving that path to `EnterWorktree` (handle the tool as in step 2 of "Making the worktree" below); otherwise `git switch w/<name>` |
| None of the rows above apply, and you are on neither the base branch nor this item's branch | It may belong to another item or another session. Leave it alone and ask what to do |

Finding the item: if there is no argument and the current branch is `w/<name>`, the item is `docs/backlog/<name>.md`, then `docs/done/<name>.md`. If there is an argument, look it up in the base folder's `docs/backlog/`, then `docs/done/` (the path "Updating the base" wrote; it is up to date). If it is not in the base folder but only in the current folder (an item `/backlog` made in a worktree), say it is not on the base branch yet and ask what to do. If you are on this item's `w/` branch, read the item file in the current folder (`README.md` and files starting with `_` are not items). If there is no argument and this is not a work branch, or there are several matches, show the `To Do` items by number and title and let the user pick. If the current branch is `w/<name>` and that file is in neither place, it is work that was being done without an item ("Continuing" in step 0). Read the item file all the way through, and check that all of its `dependencies` are in the base folder's `docs/done/`.

**Making the worktree:** if you are on the base branch or on a merged `w/` branch from the table above, and this item's `w/` branch does not exist yet, make a new worktree and move this session into it. Do every later step in that worktree. `<name>` is the item file name without `.md` (`<short-english-name>` when working without an item). If the user said to work in this folder, do not make a worktree; create the work branch in step 4.

1. Run `bash <scripts>/make-worktree.sh <base> <name>`. It updates the base branch again in the base folder and makes the worktree at `.claude/worktrees/<name>` on a `w/<name>` branch. The first line is the worktree path. Exit code 1 means the pull failed and the worktree was made from the local base branch as it is: say the reason it printed. Exit code 2 means it could not make the worktree: say the reason and stop.
2. Move there by giving that path to `EnterWorktree` (`path`). Moving from another worktree is fine. If it is a deferred tool, load it with ToolSearch first. If the tool is missing or refuses, run later commands in that folder (`git -C <path>`, absolute paths). On this path the verify Stop hook does not run, so be sure to run the verification in steps 6 and 11 yourself in that folder.

**Continuing:** read the item file's `Implementation Plan`, its checked Acceptance Criteria, and `Implementation Notes`, and resume from the step that remains. Read the list below from the top and follow the first line that matches.

- The item is already in `docs/done/` → step 12. For how to merge, use the answer written under `### 머지` (merge) in `Implementation Notes`. If there is none, ask again only about how to merge
- There is a `### 리뷰` → step 10. Send the last message again
- `Implementation Plan` is empty → step 2
- There are unchecked Acceptance Criteria → step 5
- Every AC is checked but Definition of Done is not → step 6
- DoD is checked too and `Implementation Notes` has no `### 리뷰` (review) → step 7

## 2. Baseline and stack checks

0. **Worktree setup:** if this is a worktree:
   - If the project needs dependencies installed (for example `package.json` and a lockfile), install them before the baseline. A new worktree has nothing installed, and a baseline taken before installing hides real failures.
   - If the worktree is inside the base folder (for example `.claude/worktrees/`) and the test, lint or type-check tools read into that folder, verification in the base folder also runs other items' code. If those tool settings do not leave it out, say so.
1. **Baseline:** Run the verify command once. Record only what already fails (the command, the names of failing tests/files). This does not block the work; tell the user. Later verification compares against this to look only at new failures.
2. **Stack checks:** Call, with the Skill tool, every available skill whose name ends in `-start-check` (e.g. `workflow:server-start-check`). A check that does not apply returns only "not applicable". What comes back:
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
3. **Playbook:** from the index in `SKILL.md`, pick the playbook that fits the nature of the item and move its steps into the to-do list. If none fits, or the work is large and cross-cutting, design the steps for that work with the `figure-it-out` skill. The playbook's research and design steps (tracing, reproducing, narrowing down the cause, measuring, `architect`) are done here in step 3, and the plan is written from their results. The remaining steps run inside step 5 (implementation). The playbook's verification step is 2–4 of step 6. Do not do it twice. The playbook's last step continues into step 6. If there is reproducing or measuring that needs a running server, do 1 of step 4 (the work branch and the item ports) first and come back. `prototype.md` is for settling the fork in 5. Where a playbook says to delegate the implementation, follow "When delegating" in step 5.
   - **Investigation and prototype:** for an investigation done without an item (`investigation.md`), the answer is the deliverable. Skip 4–8 of this step 3 and steps 4–12, give the answer as the last message, and finish. When a backlog item is itself an investigation or a prototype, the deliverable is the text written in the item file. Write the result (the answer for an investigation, the result and a recommendation for a prototype) in `Implementation Notes`, and the rest goes like any other item (AC and DoD judgment, review, step 10, steps 11–12). Prototype code is throwaway, so do not commit it to the work branch (keep it in a temp folder outside the repository). If the investigation or prototype should lead to a code change, raise it as a "later" candidate in the step 10 message.
4. **Tools and steps:** decide which field this item's work belongs to, and what tools (names, commands) and steps the best practitioners in that field use for it. Do not assume a role; write down the tools and steps. If you do not know, look it up in docs or on the web. Keep the tools the stack checks gave and add only what is missing.
5. **Design:** decide it yourself. For a change that crosses a function boundary, follow the `architect` skill. Settle a fork that running something would settle with `playbooks/prototype.md`, and write down the result and the evidence.
6. **Gaps in the ACs:** if, while reading the item, you find ACs that contradict each other or a missing decision that only a person can make, put it in the pre-start questions.
7. **Pre-start questions:** only when something falls under the asking criteria, all at once. Combine the stack checks' "Ask" into them. Also put in what is already visible from the plan and is on the step 5 scope list (changing a schema or public API, deleting, changing CLAUDE.md or settings outside the project). Do not ask about installs (the asking criteria in `SKILL.md`). What is asked once per project goes here too: creating a verification skill (do not ask if `.claude/skills/verify-*` exists or CLAUDE.md has `- 검증 스킬: 안 씀` (verification skill: not used). If the answer is not to create one, suggest writing that line). Attach a recommendation and its reason to the options. If there is nothing to ask, do not stop.
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
   - If no worktree was made and you are on the base branch: `git switch -c w/<name>`.
   - If you are in a worktree made for this item and the branch name differs: `git branch -m w/<name>`. The verify Stop hook runs only on `w/` branches.
   - If a web port or server port is set, set the item's port to `base port + item number` (for example web 5000, item 007 → 5007). Only the ones that are set.
     - For each port, run `bash <scripts>/pick-port.sh <base port> <item number>` and use the port on the first line. If it exits with a non-zero value, tell the user the reason it printed.
     - Write the ports into the item file as soon as they are set, so that another session started at the same time can see them.
2. Item file: `status: In Progress`, `updated_date` today, the plan in `Implementation Plan`, the baseline under `### Baseline` in `Implementation Notes`, the ports you set under `### 포트` (one per line, like `- 웹: 5007`), the decisions under `### 정한 것`. What the user answered (answers to the pre-start questions, the chosen mockup, corrections made along the way) goes under `### 사용자가 정한 것` (decided by the user). This is not under review.
3. Commit: `chore(backlog): <number> start`

## 5. Implement

- Follow the chosen playbook's steps, the plan's tools and steps, and the stack checks' Follow.
- **Tests:** if there is a cheap, clear way to test, write a failing test first, and before fixing, run it to see that it fails for the intended reason. If there is no such way (it needs a broad harness, the mocks break easily, there is only a slow e2e, only docs or config change, it is a structural change with no behavior change so the refactoring playbook's pinning test stands in, or it is a throwaway prototype), do not force one. Use the closest run check (command, script, browser) and write down why. No test is better than a bad test. Tests assert observable behavior (the `principle-test-behavior-not-implementation` skill).
- Do not delete or weaken existing tests to make them pass (deleting, skipping, raising time limits, updating snapshots). If an expected value changed because of a behavior change the Acceptance Criteria require, fix the test and write it under `### 정한 것`. Rewriting a test that asserted implementation details so that it asserts observable behavior is not weakening it. If you do, write it under `### 정한 것`. Otherwise do not change the tests.
- Do only what is in the Acceptance Criteria. Do not polish surrounding code. If other work seems needed, note it and raise it as a "later" candidate in step 10.
- **Stop when the scope grows.** If one of the three below applies and it was not answered in the pre-start questions, stop and ask. Decide anything else that changed, and write it down.
  - A behavior not in the ACs has to be added
  - A schema or public API has to change, or something has to be deleted
  - CLAUDE.md or settings outside the project have to change. Do not ask about adding a dependency that changes `package.json` and the lockfile, or about `hillclimb.md` adding `.claude/.local/` to `.gitignore`
- When a new dependency or tool is needed, do not ask. Follow the install rules in the asking criteria in `SKILL.md` (inside the project, at a pinned version, proven ones only). Write what you installed (name, version, source) and why under `### 정한 것`.
- When one AC is done, check it off right away only if there is outside evidence (command output). ACs that need a judge are judged together in step 6.
- Write what you decide without asking under `### 정한 것` as you go. Write what changed from the plan in `Implementation Notes` too.
- Commit to the work branch at each meaningful step. Before committing, follow the `deslop` skill (with the same limit as 1 in step 6). Do not commit to the base branch.
- **When delegating:** if you hand implementation or a fix to a subagent, put these in the brief: the scope (files, what to do, success criteria), this step's test rules, do only what is within the Acceptance Criteria, if something on the scope list above comes up do not fix it but come back, do not commit to the base branch, the rules the stack checks returned, do not do work under ask criterion 1 (merging, pushing to the base or deploy branch, deleting, remote DB, deploying) but come back, and install only the new dependencies or tools named in the brief, and if anything else is needed do not install it but come back. Also put the absolute path of `SKILL.md` in the brief and write this: "Read only two sections of that file, `### 일하는 방식` (how to work) and `### 원칙` (principles). When you apply a principle, read its body (`../<name>/SKILL.md` from the folder that holds that file; `${CLAUDE_SKILL_DIR}` inside the file is that folder), and write the principle name and the choice it changed in your report. Every other section of that file is the delegating session's job, so do not follow it." Skills do not fire on their own, so this is the only way the principles reach the delegated agent. The model follows the `implement` role in `<ref>/settings.md`. Read the diff of the delegated result yourself and check it. When the delegated agent reports what it chose and why, move that under `### 정한 것`. Hand fixes, follow-up work and retries to a new agent, and put the original brief, the instructions after it, and the earlier agent's report in its brief.

## 6. Wrap-up check

1. **Clean up:** follow the `deslop` skill on the diff against the base branch. If code changed, follow the `no-comments` skill right after it (it is done here so that what it changes goes through the verification, judgment and commit in 2–4 below and falls within the review's scope. Fixes `no-comments` makes while removing workarounds follow the test rules in step 5). `deslop` fixes without asking and does not change behavior. Do not use `deslop`'s "unless fixing a clear bug" exception. If something looks like a bug, do not fix it; write it down and pass it to the review. Write one line on what was fixed.
2. **Verify:** Run the verify command fresh and show the result. If there are failures not in the baseline, fix them. Do not let the memory of an earlier pass stand in for it. If there are numbers measured with `perf-issue.md` or `hillclimb.md`, measure again with the same harness after the cleanup in 1 and update the numbers.
3. **Screen check:** Do it if the stack checks' Follow includes a browser check and the UI changed. Who judges is as the stack check set it (for frontend, the `frontend-evaluator` agent). When a playbook says to verify with the `control-ui` skill, do it this way too. If the project has a `verify-*` skill, follow that skill and its feature map. Write what was done and seen in `Implementation Notes`. If there is no tool for it, do not stop. Write it as "could not verify" and continue, and collect it in the step 10 message.
4. **AC judgment:** the implementing session does not judge and check off ACs by itself. Check off only those that have one of these:
   - Outside evidence: the command that shows the result (test, grep, CLI) and its output are written in `Implementation Notes`.
   - A judge other than the implementing session: for UI, the screen check from 3; otherwise a new general-purpose judge agent said pass. Give the judge agent only the item file path and the `git diff <base>...HEAD` range, not how it was implemented. Brief: "Do not edit files. For each AC write pass / fail / could not verify with evidence (`file:line`, command output). When unsure, do not leave it as pass."

   Fix "fail" and get judged again. If the same AC still fails after three fixes, stop fixing and tell the user which AC failed and what you tried. The premise may be wrong (the `principle-attack-the-premise` skill). Do not check off "could not verify"; raise it in the step 10 message. Check off Definition of Done the same way, and commit. Leave no uncommitted changes.

Go on to step 7 without asking.

## 7. Prepare the review

1. **Stack checks:** Call, with the Skill tool, every available skill whose name ends in `-end-check` (e.g. `workflow:server-end-check`). Each check runs its inspection tools only when the change touched its area, and returns:
   - **Failures:** put them in the step 9 findings list as 🔴 without going through the judge. The check tool's output is the evidence.
   - **Agents to add to the review:** add them to step 8 (with the evidence).
   - **To do after fixing:** do it in step 9.
2. **Do the tests prove the fix:** before the review, run the tests added or changed on this branch against the base branch's source. The script changes files for a while, so do not run it alongside the review agents.
   - Settle, from the project (CLAUDE.md, package.json scripts, test config), the command that runs one test file, with `{}` in place of the file (for example `pnpm vitest run {}`, `pytest {}`, `bash {}`).
   - `bash <scripts>/base-tests.sh <base> '<that command>'`. If the project's test files cannot be picked by name, add the files at the end, and if there are test helpers outside the naming rules (for example `src/testing/`), prefix `BASE_TESTS_KEEP='<path regex>'`.
   - Put each `기준에서도 통과: <file>` (also passes on base) line of the output into the findings list as 🟡 "does not prove the fix. It passes without the fixed code", without going through the judge.
   - A test written to pin the current behavior (the refactoring playbook's pinning test, hillclimb's regression gate) is right to pass on base. A pinning test named in the plan from step 4, and an existing test rewritten to assert behavior and written under `### 정한 것`, are left out of the findings; say so in `Implementation Notes`. One that was not in the plan goes into the findings list marked "claimed to be a pinning test", and the judge decides.
   - If the output is `바뀐 테스트 없음.` (no changed tests, exit value 2), add the test files outside the naming rules and run again; if there are none, raise "could not verify. No tests found on this branch" in the step 10 message.
   - If the command cannot be settled or the exit value is 2 for another reason, write "could not verify" and the reason in `Implementation Notes`; for each `HEAD 에서 실패: <file>` (fails on HEAD) line, whatever the exit value, write that test as "could not verify"; then move on.
3. If the change is small but reaches wide, follow the `blast-radius` skill, put what it finds into the findings list, and leave it to the judge.

## 8. Review (agents, in parallel in one message)

| Agent | When | What it does |
| --- | --- | --- |
| general-purpose | Always | Calls the `code-review` skill. Target is the current branch. No `--fix`, no `--comment`, no effort level given |
| general-purpose | When authentication/authorization, input handling, secrets, external calls, or file/command execution changed | Calls the `security-review` skill. Before launching, if `git symbolic-ref refs/remotes/origin/HEAD` fails, run `git remote set-head origin -a` |
| Stack review agents (`workflow:frontend-reviewer`, `workflow:design-reviewer`, `workflow:api-reviewer`, `workflow:supabase-reviewer`) | When step 7 returned them | By that agent's own criteria |

**Model:** every agent above follows the `review` role in `<ref>/settings.md`.

Agents cannot see this conversation, so put these in the instructions:

1. Scope: `git diff <base>...HEAD`, the item file path, CLAUDE.md. For stack review agents, also the evidence the check returned with them.
2. Do not edit files and do not commit. Do not touch remote or production environments. general-purpose agents do not start servers and do not run build/verify commands (the reviewers run at the same time in the same folder). Stack review agents start servers, install tools, or reproduce locally only when that agent's criteria allow it.
3. Principles: the contents of `docs/review-principles.md` if it exists. Report findings that seem to go against a principle too, and say which principle they clash with.
4. The user decided only the Acceptance Criteria and what the user answered (`### 사용자가 정한 것` in the item file). `### 정한 것` and `Implementation Plan` in the item file are what Claude decided, so they are under review.
5. Report: every problem found, split into confirmed and unconfirmed, as `file:line — problem — how to fix`. Do not give scores.
6. If the skill cannot be called, do not make something up in its place; report that.

## 9. Judge and fix

After all have returned, this session does not pick findings. Pass all the reports, as written, together with the findings step 7 left to the judge, to one new general-purpose **judge agent**. Its model follows the `judge` role in `<ref>/settings.md`. Brief:

- Scope: 1 and 4 in step 8, plus `docs/review-principles.md`.
- "Do not edit files. Merge duplicates, check each finding against the code, and judge it valid / wrong with evidence (`file:line`). A finding that goes against a principle is wrong. Count problems that existed before this change separately as pre-existing. Sort the valid ones into 🔴 (confirmed bugs, security problems, data loss, AC violations, stack check failures) / 🟡 (real problems that do not block the merge) / ⚪ (minor). Among the valid findings, mark as 'for a person to decide' those that clash with the Acceptance Criteria or with what the user answered, those whose fix depends on a product or taste decision, and those that touch money, data, authentication or security. Mark those beyond this item's scope as 'later candidate'. If the same kind is in the Final Summary `리뷰에서 고친 것` (fixed in review) of an item in `docs/done/`, or it appears in several places across these reports, mark it 🔁 with the evidence (item number or locations)."

**Fix valid 🔴 and 🟡 without asking.** Do not fix "for a person to decide" and "later candidate"; pass them on to step 10. Findings that went onto the list without the judge (stack check failures from step 7, tests that also pass on the base) are also treated as "for a person to decide" when they touch money, data, auth or security: do not fix them, pass them on. Do not fix ⚪; write only the count. If an agent suggests changing permissions, CLAUDE.md, or `.claude/` settings, do not change them; raise it as a suggestion in step 10.

How to fix:

- Check the finding against the code yourself, then fix it. If a finding turns out to be wrong, write the reason and do not fix it.
- Fixes that change behavior follow the test rules in step 5.
- Fixes that need judgment (changing the design, spanning several files, or with no settled way to fix) are made by this session itself.
- Mechanical fixes, where the finding states exactly where and what to change and no judgment is left, can be collected and handed to one agent (the `mechanical` role in `<ref>/settings.md`). If you hand them over, the prompt includes that list of findings, the item file path, what "When delegating" in step 5 lists, and "do not fix anything outside the list and do not commit".
- Do not judge the fixes by the fixer's report. Run the verify command, and for each fixed finding have a new general-purpose judge agent decide whether it is fixed, given only the item file path, the list of fixed findings, `git diff HEAD` and `git status --short`. Its prompt: "Do not edit files. For each finding, write fixed / not fixed with evidence (`file:line`). If unclear, do not leave it as fixed." For UI, step 7's "To do after fixing" judges.
- If the same finding is still there after three fixes, stop fixing and tell the user the finding and what you tried.
- For an item done with `perf-issue.md` or `hillclimb.md`, measure again with the same harness after fixing and update the numbers. The code changed after the measurement.
- Do step 7's "To do after fixing" for the fixed parts. If a fix touched a stack check's area, call that `*-end-check` again.
- Write what was fixed and seen under `### 리뷰` (review) in `Implementation Notes` and commit. Write so even when there was nothing to fix (when continuing, this section is how you know the review is done).

## 10. Last message (once)

Stop here once. Always ask about the merge. Put every remaining decision into this one message. If the verify command line changed in `git diff <base>...HEAD -- CLAUDE.md`, also include "This branch changed the verify command (old → new). Until the merge, the verify Stop hook judges with the base branch's command".

How to write it:

- On the first line, write what is waiting for the user.
- Then what was done, briefly: what changed, the result per AC, what was fixed in review (the 🔴 and 🟡 counts and one line each), N dropped by the judge, N pre-existing problems, N ⚪, what was installed (name, version, source, reason), install commands not run but reported, and official skills the stack checks reported (missing, disabled, from a new session).
- Attach a recommendation, the evidence, and the risk to each decision. Write it so that the user can decide from the reply alone.
  - Findings for a person to decide: the finding, the options, the recommendation
  - "Later" candidates: whether to make them new items. Attach a title and draft ACs to each candidate
  - ACs and DoD lines left unchecked because they could not be verified: the user verifies and checks them / close with them left as not verified / leave the item open
  - The merge: if `<ref>/settings.md` has a `merge` setting, do not ask how; ask only whether to merge that way. For `local` it is "Merge into `<base>` locally and push?", and for `pr` it is "Open a PR that targets `<base>`?". With no setting, ask how: local merge (whether to push the base branch goes with it) / PR / leave as is. Then add one line saying that setting it with `/kit-setup` stops this question from next time
  - Any suggested change to permissions or settings
- Write decisions with a high cost if wrong, and what could not be verified, as notices, not as decisions to make. Raise it as the decision above only when an AC or DoD line could not be checked because it could not be verified.
- Do not raise as a question what Claude can do by itself.
- Write in plain words and short sentences. Include hashes, paths, and commands only when the user needs them to act.

When the answer comes:

- Write the chosen way to merge (including whether to push the base branch) under `### 머지` (merge) in `Implementation Notes`, and the other answers under `### 사용자가 정한 것`.

- Fix the findings for a person to decide as decided, and check them again the step 9 way.
- For candidates chosen as "later", invoke the `backlog` skill with `<the finding and its evidence> --here` to make a new item. The draft ACs were already shown, so do not get approval again.
- Do not take a vague answer ("looks fine") as permission to merge. Ask again only about how to merge.

## 11. Verify and close the item

1. Run the verify command fresh once. If there are failures not in `### Baseline`, stop and say so.
2. Write the item's `Final Summary`: what changed, what was fixed in review, what was deferred (new item numbers), findings left as is and why, what the user corrected (one line each).
3. **Principles:** if a reason for leaving a finding as is, or something the user corrected, holds for other items too, add it to `docs/review-principles.md` as one line (`- principle — reason (item number)`). Do not add a principle that is already there. If a check can block it instead of prose, that is better (the `principle-encode-lessons-in-structure` skill). Look first, as principle candidates, at findings the judge marked 🔁 (the same kind recurring).
4. Close only when everything is in place. If anything is missing, stop and say so.
   - [ ] All Acceptance Criteria checked
   - [ ] All Definition of Done checked
   - For a line where the user chose "close with them left as not verified" in step 10, do not check it; write `(확인 못 함, 사용자가 받아들임)` (not verified, accepted by the user) at the end of the line. That line counts as in place. If the user chose "leave the item open", do not close the item and do not do step 12.
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

Do it the way the `merge` setting says. With no setting, do it the way the user chose in step 10. If the user said not to merge, it is "leave as is".

- **Local merge:** do it in the order below. `<base folder>` is the folder where the base branch is checked out. If the work was done in a worktree, it is the first line of `git worktree list`; otherwise it is this folder.
  1. If the work was not done in a worktree, switch to the base branch with `git switch <base>`.
  2. Check that the base folder is on the base branch (`git -C <base folder> branch --show-current`) and clean (`git -C <base folder> status --short`). If not, stop and say so.
  3. If the base branch has an upstream, bring it up to date with `git -C <base folder> pull`. If it has none, skip that.
  4. `git -C <base folder> merge w/<name>`. If there is a conflict, follow the `fix-merge-conflicts` skill.
  5. Run the verify command again in the base folder. If it fails, do not push; say so.
  6. If the user accepted the push in step 10, `git -C <base folder> push`.
  7. Cleanup: if the work was not done in a worktree, `git branch -d w/<name>`. If the session is inside a worktree, do not remove the worktree or the branch from this session. If the app made the worktree, archiving the session lets the app clean it up. For a worktree this procedure made in step 1, say that running `git worktree remove <worktree path>` and `git branch -d w/<name>` in the base folder does it.
- **PR:** follow `playbooks/opening-a-pr.md` to push the work branch and open a PR that targets the base branch. If a PR cannot be created (CLAUDE.md says so, or `gh auth status` fails), say so. Leave the worktree.
- **Leave as is:** do nothing. Leave the worktree and the branch.

Push the base branch and deploy branches only when the user accepted it in step 10 (saying yes to "merge and push?" asked from the `local` setting counts as accepting). Do not force-push.

When done, report: the merged commits, the moved item file, new items, and the remaining `To Do` items (`README.md` and files starting with `_` are not items).
