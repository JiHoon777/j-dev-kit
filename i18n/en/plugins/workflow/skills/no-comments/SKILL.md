---
name: no-comments
description: "Use to check comments before review. Spawn the comment-sicko agent to flag unneeded comments and workaround code, fix accepted findings, and offer ways to encode the constraints that comments claim as types, tests, or lint."
disable-model-invocation: true
---

# No comments

> Source: `pstack/skills/no-comments/SKILL.md` in `cursor/plugins` (MIT, Lauren Tan). Cursor names were replaced with Claude Code names.

**When:** Before review, when code changed. When the user says "clean up the comments" or "no comments".

Spawn comment-sicko. Act on accepted findings.

Defer to comment-sicko's fresh perspective.

## Scope

Use the caller's files or diff. Otherwise use the current diff against the base branch, default `main`, including the working tree.

## Steps

1. Spawn the `workflow:comment-sicko` agent with the `Agent` tool. Before spawning it, take a snapshot of the current state (the hash `git stash create` prints, or `HEAD` if there are no uncommitted changes). The snapshot does not hold untracked files. If there are such files in the scope (`git ls-files --others --exclude-standard -- <scope>`), take them out of the scope and say so. The first line of the brief is `먼저 <start 스킬 폴더의 절대 경로>/references/worker.md 를 읽는다.` (read `<absolute path of the start skill folder>/references/worker.md` first). Pass the scope and the absolute path of the `why` skill's body. The `start` and `why` skills are at `../start` and `../why` from this skill's folder. The model follows the `review` role in `references/settings.md` of the `start` skill. Do not restate the agent's rules in the brief.
2. Inspect its report and diff. Reject application-code edits, scope escapes, exception-protected deletions, misstated `MUST KILL` reasons, and flags that treat kept intentional code as guilty.
   - Reshape flags on our-code surprises stay actionable. Do not restore those comments.
   - A keep survives only with proof it is about something we cannot change.
   - Audit missed scoped lint and TypeScript suppressions. Correctness or safety suppressions stay actionable `MUST KILL`s.
   - Restore deletions only with exact exceptions and scoped proof.
   - Before accepting thin `IMPORTANT` or `do not remove` kills or keeps, trace their symbol or run the `why` skill on it. If a kill is ambiguous, do not restore. If a keep is refuted or still ambiguous, delete it.
   - Revert a rejected report and rerun it once with the failure named. When reverting, restore only the files comment-sicko touched, from the snapshot in step 1 (`git restore --source=<snapshot> --worktree -- <file>`. Leave what is staged as it is). Do not wipe the user's uncommitted changes. Reject a second, report it open, and fail `no-comments`.
3. Fix trivial accepted flags directly by deleting a dead path, dropping a parameter, or using the real API. If any fix needs a shape, run the `architect` skill once for the accepted set and surrounding code. Stop at the sketch. Architect shapes. Step 4 implements.
4. Implement the smallest root-cause fix in scope. Remove every named workaround. If the root cause is out of scope, land the smallest in-scope fix and report the rest open. The `principle-fix-root-causes` and `principle-redesign-from-first-principles` skills guide intent only. Neither authorizes widening the fence nor fixing instances outside it. Never bolt on symptom guards.
5. Constraint comments say `do not remove`, `do not change wording`, or `talk to X before changing`. Leave keeps about things we cannot change. For the rest, offer the cheapest in-scope type, runtime check, test, or CI lint.
   - If the user invoked the skill directly, wait for approval. If approved, encode then delete the comment. Otherwise delete the comment, report the constraint open, and sketch the out-of-scope work.
   - Inside the `start` flow, or in an unattended run, do not wait. If the caller approved it in advance, encode then delete the comment. Otherwise delete the comment, and raise the constraint and its encoding as a "later" candidate in the last message.
6. Report the deletion count, restored comments, reruns, architect sketch, fixes, encoding offers, encodings, unenforced constraints, and other open work.
