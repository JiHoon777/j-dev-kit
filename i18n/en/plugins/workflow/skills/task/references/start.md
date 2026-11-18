> Translation. Source: [plugins/workflow/skills/task/references/start.md](../../../../../../../plugins/workflow/skills/task/references/start.md). Update this file when the source changes. Claude does not read this file.

# task start: plan and implement one item

Plan **one** backlog item, get approval, and implement it. `/task end` does the review and merge.

Requested item: the arguments after `start`.

## 1. Can we start

If any of these applies, stop and say so. Do not clean it up on your own.

| Check | If it applies |
| --- | --- |
| The base branch has no commits | Say that a first commit is needed |
| There are uncommitted changes | Show them and ask what to do |
| A `w/` branch already exists, or the current branch is not the base branch | Ask whether to continue, finish with `/task end`, or discard. If continuing, switch to that branch, read the item's `Implementation Plan`, and resume from step 5 |

Finding the item: look up the argument in `docs/backlog/` (`README.md` and files starting with `_` are not items). If there is no match or several, show the `To Do` items by number and title and let the user pick. Read the item file all the way through, and check that all of its `dependencies` are in `docs/done/`.

## 2. Baseline and stack checks

1. **Baseline:** Run the verify command once. Record only what already fails (the command, the names of failing tests/files). This does not block the work; tell the user. `/task end` compares against this to look only at new failures.
2. **Stack checks:** Call, with the Skill tool, every available skill whose name ends in `-start-check` (e.g. `server:server-start-check`). A check that does not apply returns only "not applicable". What comes back:
   - **Follow:** rules to follow and skills to call during implementation
   - **Put in the plan:** only when it applies to this item
   - **Ask:** only when there is something it cannot decide

## 3. Plan (plan mode)

Enter with `EnterPlanMode`. Do not edit files in this step.

**Match the size.**

- **Small item** (a few files, no new structure): read the relevant code directly, without agents.
- **Large item** (several modules, new structure): launch at most 2 `Explore` agents, on different areas, in one message. Have them follow similar existing features and connected code and return the files that must be read, then read those files directly.

**Questions:** only those that code and docs cannot answer and that change the plan, combined with the stack checks' "Ask", at most 3 at once. Decide the rest reasonably and write them in the plan as assumptions. Do not finalize the plan before getting answers.

**Design:** decide it yourself. Only when there is a genuinely split choice (structure, library, data model), show the difference between two options and a recommendation.

**What goes in the plan (`ExitPlanMode`):**

1. What we do: one or two sentences, what is left out this time
2. Files to change and the job of each, tests to write first, order
3. Success criteria: how each Acceptance Criterion is checked
4. The stack checks' "Put in the plan"
5. Assumptions and decisions

Before approval, do not edit files and do not create a branch.

## 4. Record

1. `git switch -c w/<item file name without .md>`
2. Item file: `status: In Progress`, `updated_date` today, the approved plan in `Implementation Plan`, the baseline under `### Baseline` in `Implementation Notes`.
3. Commit: `chore(backlog): <number> start`

## 5. Implement

- Call the `superpowers:test-driven-development` skill and follow it.
- Follow the stack checks' **Follow**.
- Do only what is in the Acceptance Criteria. Do not polish or refactor surrounding code. If other work seems needed, say so, and if agreed, create a separate item following steps 2-4 of `${CLAUDE_SKILL_DIR}/references/create.md`.
- When one AC is done, verify it and check it off right away. Write what changed from the plan in `Implementation Notes`. If the scope grows, stop and ask.
- Commit to the work branch at each meaningful step. Do not commit to the base branch and do not push.

## 6. Wrap up

1. **Clean up:** If the change is not small, call the `simplify` skill once. This skill finds places in the changed code to reuse or simplify and fixes them directly. Revert any fix that changes behavior. Write one line on what was cleaned up.
2. **Verify:** Call the `superpowers:verification-before-completion` skill and follow it. Run the verify command fresh and show the result. If there are failures not in the baseline, fix them.
3. **Browser check:** Do it if the stack checks' Follow includes a browser check and the UI changed. If there is no tool for it, do not skip; stop and say so. Write what was done and seen in `Implementation Notes`.
4. Check off only what was actually verified in AC and Definition of Done, and commit. Leave no uncommitted changes.
5. Report: what was done, the result per AC, what changed from the plan, what could not be verified. Next is `/task end`.
