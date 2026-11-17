# task end: review and merge

Have agents review the current work branch's changes, fix what the user decides, and finish the way the user chooses.

This mode chains proven workflows. Do not change how a source works.

| Step | Source |
| --- | --- |
| 1-2 | `*-end-check` skills of enabled stack plugins (invoked as is) |
| 2 | Built-in skills `code-review`, `security-review`, `simplify` (one per agent, invoked as is), and stack review agents |
| 2–3 | Anthropic `feature-dev` plugin phase 6 and its `code-reviewer` prompt (run in parallel, score confidence, consolidate, present, ask) |
| 4 | `superpowers:receiving-code-review` (invoked as is) |
| 5 | Backlog.md agent guidelines (definition of done) |
| 6 | `superpowers:finishing-a-development-branch` (invoked as is) |

If the project's CLAUDE.md says PRs cannot be created in this environment or sets push rules, follow it. The skill's "current state" compares against `main`; if the base branch differs, check the branch's commits and changed files again with that branch (`git log --oneline <base>..HEAD`, `git diff --stat <base>...HEAD`).

## 1. Check that review can start

If any of these applies, **stop and tell the user.**

| Check | If it applies |
| --- | --- |
| The branch does not start with `w/` | Not a work branch to review. Ask which branch |
| No item file matching the branch name in `docs/backlog/` or `docs/done/` | Ask which item |
| There are uncommitted changes (including untracked files) | Ask whether to commit or discard. Never discard on your own |
| `<base>...HEAD` has no changes | Say there is nothing to review |
| The verification command fails | Show the failure and ask whether to fix, commit, and continue |

Read the item file. (If the item is already in `docs/done/`, steps up to 5 are done. Resume from step 6.)

### 1-2. Stack end checks

1. In the list of available skills, find **every skill whose name ends with `-end-check`** and invoke each with the Skill tool (for example `supabase:supabase-end-check`). If there are none, write "no stack plugin enabled".
2. Each compares against `### Baseline` in the item's `Implementation Notes` and returns only **new failures** as failures. Put those failures in the findings list in step 3 with "stack check" as the source.
3. Add each check's **agents to add to the review** (with their conditions and evidence) to step 2.
4. Do each check's **after fixes** items (for example a browser test) in step 4.
5. Put each check's **later** items (for example permission rules to capture as tests) in the `Final Summary`, or create new items for them with `/task create` after approval.

## 2. Run review agents in parallel (feature-dev phase 6)

"Launch 3 code-reviewer agents in parallel with different focuses" — launch them all **in a single message**. **Each agent actually invokes one review skill.** Do not just give them different names with the same prompt.

| Agent | When | Invokes (Skill tool) |
| --- | --- | --- |
| Correctness (general-purpose) | Always | `code-review` — without the fix option (`--fix`) |
| Security (general-purpose) | Always | `security-review` |
| Simplification (general-purpose) | Always | `simplify` — find only, skip the fixing step |
| Stack review agents (`frontend:ui-reviewer`, `frontend:svelte-reviewer`, `frontend:react-reviewer`, `supabase:rls-reviewer`, `server:api-reviewer`, …) | When a stack check in 1-2 returned it | (as the agent defines) |

Before launching, check once: if `git symbolic-ref refs/remotes/origin/HEAD` fails, run `git remote set-head origin -a`. `security-review` finds changes by comparing against `origin/HEAD`.

Check skills only run commands. Reviews that read the diff and judge it are not done directly in this conversation; all of them are done by the agents in this step.

Put **all** of the following in the prompt for every agent (the three above and the stack review agents). Agents cannot see this conversation. For stack review agents, instead of item 1 (the skill to invoke), give the evidence the check skill returned together with that agent (changed files, locations found, tool results).

1. **Skill to invoke:** "Invoke the `<skill name>` skill with the Skill tool and review the way it does." Say that the other reviews are done by other agents.
   - `code-review`: the target is the current branch (`w/<name>`). Do not pass `--fix` or `--comment`. Give no effort level or `medium`. Never use `max` or `ultra`.
   - `simplify`: this skill normally fixes what it finds right away. **Do not fix; report findings only.**
2. **Read only:** do not edit or create files, do not commit, do not start servers, and do not run build or verification commands (several agents would write to the same folder at once). Tests and read-only commands are fine.
3. **Scope:** write out `git diff <base>...HEAD` and the list of changed files. If the skill cannot find the scope, it uses this one.
4. **Criteria:** the path of the item file, `CLAUDE.md`, and the paths of related documents.
5. **Report:** report findings in the format of the **reviewer prompt** below. Score each finding's confidence (0–100) and report **all of them, including low ones**. Each needs `file:line`, what the problem is, and how to fix it. Write the report in the project's language.
6. **If the skill cannot be invoked,** do not substitute something made up; report "could not invoke the skill". Then tell the user.

### Reviewer prompt (feature-dev `code-reviewer` original)

Attach the prompt below as is to every agent. The skill decides **what to look at and how**; this prompt decides **what to report** (confidence criteria and format).

**What was changed from the original:** the original drops everything under confidence 80 ("Only report issues with confidence ≥ 80"). That hides even a 75 ("very likely a real issue that will be hit in practice"). Here, **nothing is cut; every issue is reported with its score**, because the user chooses in step 3. Only that sentence and the two places in the output description that depend on it were changed.

> You are an expert code reviewer. Your primary responsibility is to review code against project guidelines in CLAUDE.md with high precision to minimize false positives.
>
> **Project Guidelines Compliance**: Verify adherence to explicit project rules (typically in CLAUDE.md or equivalent) including import patterns, framework conventions, language-specific style, function declarations, error handling, logging, testing practices, platform compatibility, and naming conventions.
>
> **Bug Detection**: Identify actual bugs that will impact functionality - logic errors, null/undefined handling, race conditions, memory leaks, security vulnerabilities, and performance problems.
>
> **Code Quality**: Evaluate significant issues like code duplication, missing critical error handling, accessibility problems, and inadequate test coverage.
>
> **Confidence Scoring** — rate each potential issue on a scale from 0-100:
>
> - **0**: Not confident at all. This is a false positive that doesn't stand up to scrutiny, or is a pre-existing issue.
> - **25**: Somewhat confident. This might be a real issue, but may also be a false positive. If stylistic, it wasn't explicitly called out in project guidelines.
> - **50**: Moderately confident. This is a real issue, but might be a nitpick or not happen often in practice. Not very important relative to the rest of the changes.
> - **75**: Highly confident. Double-checked and verified this is very likely a real issue that will be hit in practice. The existing approach is insufficient. Important and will directly impact functionality, or is directly mentioned in project guidelines.
> - **100**: Absolutely certain. Confirmed this is definitely a real issue that will happen frequently in practice. The evidence directly confirms this.
>
> **Report every issue you found, each with its confidence score. Do not drop low-confidence issues** — the person reading decides what to do with them. Do not pad the list either: an issue you scored 0 is not an issue.
>
> **Output**: Start by clearly stating what you're reviewing. For each issue, provide: clear description with confidence score; file path and line number; specific project guideline reference or bug explanation; concrete fix suggestion. Group issues by severity (Critical vs Important) and list them from highest confidence to lowest. If you found no issues, confirm the code meets standards with a brief summary.

## 3. Consolidate, present, and ask (feature-dev phase 6)

Do this after every agent has reported.

1. "Consolidate findings and identify highest severity issues that you recommend fixing" — merge duplicates and decide what you recommend fixing. Include the stack check failures from 1-2.
2. "**Present findings to user and ask what they want to do** (fix now, fix later, or proceed as-is)" — show a table with, for each finding, which review it came from, `file:line`, what the problem is, the confidence, and the recommended handling, and ask. List **highest confidence first** and do not leave out low ones. Before fixing a low-confidence finding, verify it in the code yourself.
   - **Fix now**
   - **Fix later** → with approval, create a new item (`To Do`) following `/task create`
   - **Proceed as-is**
3. If an agent suggests changing permission settings, `CLAUDE.md`, or `.claude/` settings, do not change them; pass them to the user as suggestions.

**Do not fix anything before getting the answer.**

## 4. Fix what was decided

- Invoke the `superpowers:receiving-code-review` skill and follow it as is. (Do not trust a finding blindly; verify it in the code. Do not apply a wrong finding; give the reason. Fix one at a time and verify each.)
- For fixes that change behavior, write a failing test first, following `superpowers:test-driven-development`.
- When all fixes are done, run the verification command.
- **Then always do the "after fixes" items the stack checks returned in 1-2** (for example a browser test), even if the fix looks unrelated. For each fixed finding, reproduce the situation it described and confirm the problem is gone. If the tool is not available, do not skip it: stop and tell the user.
- Even if nothing was fixed (everything was "proceed as-is"), do the "after fixes" items once before merging.
- If a fix touches what a stack check covers, invoke that `*-end-check` again.
- Write what you tested and saw in the item's `Implementation Notes`.
- Commit to the work branch.

## 5. Close the item (Backlog.md definition of done)

"A task is **Done** only when **ALL** of the following are complete" — if any is missing, stop and tell the user. "NEVER mark a task as Done without completing ALL items above."

- [ ] All Acceptance Criteria are ticked
- [ ] All Definition of Done lines are ticked
- [ ] `Final Summary` is written: what changed, what was fixed in review, what was deferred (new item numbers)

When everything is done, on the work branch:

```bash
# in the item file: set status: Done and updated_date to today, then
git mv docs/backlog/<file> docs/done/<file>
git add -A docs/
<verification command>                         # fix here if it fails
git commit -m "docs(backlog): <number> done"
git status --short                             # must be empty
```

Committing after only `git mv` leaves out the edits you just made. Always run `git add -A docs/`.

## 6. Finish

Invoke the `superpowers:finishing-a-development-branch` skill and follow it as is. It runs the tests, presents the options, and **waits for the user's answer** before acting. That is the approval before merging.

Tell the skill about this repository:

- The test command is this project's verification command; the base branch is the one in the project settings.
- If no worktree was used, there is no worktree to remove.
- If PRs cannot be created in this environment (stated in CLAUDE.md, or `gh auth status` fails), still present the options, but say so.
- If the base branch has no upstream (`git rev-parse --abbrev-ref <base>@{upstream}` fails), skip `git pull`.
- After merging, push only when the user asks separately.

When done, report: the merged commit, the moved item file, any new items, and the `To Do` items left in `docs/backlog/`.
