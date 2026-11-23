> Translation. Source: [plugins/workflow/skills/task/references/start.md](../../../../../../../plugins/workflow/skills/task/references/start.md). Update this file when the source changes. Claude does not read this file.

# task start: plan and implement one item

Plan **one** backlog item, get approval, and implement it. `/task end` does the review and merge.

Requested item: the arguments after `start`.

Run every command from the repository root (`git rev-parse --show-toplevel`). When working in a worktree, that is the worktree's root.

## 1. Can we start

If any of these applies, stop and say so. Do not clean it up on your own.

| Check | If it applies |
| --- | --- |
| The base branch has no commits | Say that a first commit is needed |
| There are uncommitted changes | Show them and ask what to do |
| The current branch is not the base branch | If this is a worktree just made for this item (a sub-session), go ahead: you are in a worktree (the two lines of `git rev-parse --path-format=absolute --git-dir --git-common-dir` differ) and the branch has no commits after the base branch. If its name is not `w/<name>` (a prefix the app adds, for example), rename it in step 4. Otherwise ask whether to continue, finish with `/task end`, or discard. If continuing, read the item's `Implementation Plan` and resume from step 5 |
| This item's `w/` branch already exists and you are not on it | If the session that worked on that branch still exists, tell the user to continue there. If it does not, continue here: if the branch is in another worktree (`git worktree list`), move there by giving that path to `EnterWorktree` (if the tool is missing or refuses, run later commands in that folder); otherwise `git switch w/<name>`. Then read the item's `Implementation Plan` and resume from step 5. Other items' `w/` branches belong to other sessions; leave them alone |

Finding the item: look up the argument in `docs/backlog/` (`README.md` and files starting with `_` are not items). If there is no match or several, show the `To Do` items by number and title and let the user pick. Read the item file all the way through, and check that all of its `dependencies` are in `docs/done/`.

## 2. Baseline and stack checks

0. **Worktree setup:** if this is a worktree (the two lines of `git rev-parse --path-format=absolute --git-dir --git-common-dir` differ):
   - If the project needs dependencies installed (for example `package.json` and a lockfile), install them before the baseline. A new worktree has nothing installed, and a baseline taken before installing hides real failures.
   - If the worktree is inside the base folder (for example `.claude/worktrees/`) and the test, lint or type-check tools read into that folder (many do not look at git's ignore lists), verification in the base folder also runs other items' code. If those tool settings do not leave it out, say so.
1. **Baseline:** Run the verify command once. Record only what already fails (the command, the names of failing tests/files). This does not block the work; tell the user. `/task end` compares against this to look only at new failures.
2. **Stack checks:** Call, with the Skill tool, every available skill whose name ends in `-start-check` (e.g. `server:server-start-check`). A check that does not apply returns only "not applicable". What comes back:
   - **Follow:** rules to follow and skills to call during implementation
   - **Before planning:** work to finish before the plan (for example mockups). Do it before going to step 3
   - **Put in the plan:** only when it applies to this item
   - **Ask:** only when there is something it cannot decide

## 3. Plan (plan mode)

Enter with `EnterPlanMode`. Do not edit files in this step. If the brief says to write questions and approval requests in the last message (when the starting session directs), do not use the plan mode tools; write the plan in full in the last message and stop.

**Match the size.**

- **Small item** (a few files, no new structure): read the relevant code directly, without agents.
- **Large item** (several modules, new structure): launch at most 2 `Explore` agents, on different areas, in one message. Have them follow similar existing features and connected code and return the files that must be read, then read those files directly.

**Tools and steps:** before designing, decide which field this item's work belongs to, and what tools (names, commands) and steps the best practitioners in that field use for it. Do not assume a role; write down the tools and steps. If you do not know, look it up in docs or on the web. You may pick tools that are not installed; then put installing them in the plan. Keep the tools the stack checks gave and add only what is missing.

**Questions:** only those that code and docs cannot answer and that change the plan, combined with the stack checks' "Ask", at most 3 at once. Decide the rest reasonably and write them in the plan as assumptions. Do not finalize the plan before getting answers.

**Design:** decide it yourself. Only when there is a genuinely split choice (structure, library, data model), show the difference between two options and a recommendation.

**What goes in the plan (`ExitPlanMode`):**

1. What we do: one or two sentences, what is left out this time
2. Tools and steps: the field, the tools and steps of its best practitioners, what to install
3. Files to change and the job of each, tests to write first, order
4. Success criteria: how each Acceptance Criterion is checked (command, screen, judge agent)
5. The stack checks' "Put in the plan"
6. Assumptions and decisions

Before approval, do not edit files and do not create a branch.

## 4. Record

1. Set up the work branch `w/<item file name without .md>` (`<name>` below).
   - If you are on the base branch: `git switch -c w/<name>`.
   - If you are in a worktree made for this item and the branch name differs: `git branch -m w/<name>`. The verify Stop hook runs only on `w/` branches.
   - If a web port or server port is set, set the item's port to `base port + item number` (for example web 5000, item 007 → 5007). Only the ones that are set.
     - Treat these ports as in use and go up by 1 to avoid them: ports something is listening on (`lsof -nP -iTCP:<port> -sTCP:LISTEN`, or `nc -z 127.0.0.1 <port>` if lsof is missing or fails), the `### 포트` of items in progress in other sessions (`In Progress` in `docs/backlog/`), and those items' default ports (base port + their number). This keeps it clear of other items and of other projects' servers. If there is no way to check whether a port is listening, say so.
     - Write the ports into the item file as soon as they are set (2 below), so that another session started at the same time can see them.
2. Item file: `status: In Progress`, `updated_date` today, the approved plan in `Implementation Plan`, the baseline under `### Baseline` in `Implementation Notes`, the ports you set under `### 포트` (one per line, like `- 웹: 5007`).
3. Commit: `chore(backlog): <number> start`

## 5. Implement

- Call the `superpowers:test-driven-development` skill and follow it.
- Follow the plan's **tools and steps**. If you change them, write it in `Implementation Notes`.
- Follow the stack checks' **Follow**.
- Do not delete or weaken existing tests to make them pass. If you think a test is wrong, stop and ask.
- Do only what is in the Acceptance Criteria. Do not polish or refactor surrounding code. If other work seems needed, say so, and if agreed, invoke the `task` skill with `create <that work> --here` to make a separate item.
- When one AC is done, check it off as soon as it is confirmed the way step 6.4 says. Write what changed from the plan in `Implementation Notes`. If the scope grows, stop and ask.
- Commit to the work branch at each meaningful step. Do not commit to the base branch and do not push.

## 6. Wrap up

1. **Clean up:** If the change is not small, call the `simplify` skill once. This skill finds places in the changed code to reuse or simplify and fixes them directly. Revert any fix that changes behavior. Write one line on what was cleaned up.
2. **Verify:** Call the `superpowers:verification-before-completion` skill and follow it. Run the verify command fresh and show the result. If there are failures not in the baseline, fix them.
3. **Browser check:** Do it if the stack checks' Follow includes a browser check and the UI changed. If there is no tool for it, do not skip; stop and say so. Write what was done and seen in `Implementation Notes`.
4. **AC judgment:** the implementing session does not judge and check off ACs by itself. Check off only those that have one of these:
   - Outside evidence: the command that shows the result (test, grep, CLI) and its output are written in `Implementation Notes`.
   - A judge other than the implementing session: for UI, `frontend:frontend-evaluator` from 3; otherwise a new general-purpose judge agent said pass. Give the judge agent only the item file path and the `git diff <base>...HEAD` range, not how it was implemented. Brief: "Do not edit files. For each AC write pass / fail / could not verify with evidence (`file:line`, command output). When unsure, do not leave it as pass."

   Fix "fail" and get judged again. Do not check off "could not verify"; say so. Check off Definition of Done the same way, and commit. Leave no uncommitted changes.
5. Report: what was done, the result per AC, what changed from the plan, what could not be verified. Next is `/task end`.
