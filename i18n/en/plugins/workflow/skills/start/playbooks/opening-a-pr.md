# Opening a PR

> Source: `pstack/skills/poteto-mode/playbooks/opening-a-pr.md` in `cursor/plugins` (MIT, Lauren Tan). Cursor names were replaced with Claude Code names. The source is invoked at the end of every other playbook. Here, step 12 of the `start` procedure calls it when the merge is by PR. So it differs from the source in three ways. The source's "rebase into small commits" and "deslop before commit" were dropped. Steps 5 and 6 of the procedure do that work, and step 12 does not change the tree that passed verification and review. The sentence about stacking a follow-up PR on the earlier PR's branch was dropped. `start` always branches off the base branch and opens the PR against the base branch. The source's branches for the PR tool that comes with the run and for the Origin CLI were dropped.

**When:** The merge method is PR. Either the `merge` setting is `pr`, or the user chose PR in the final message. If the project CLAUDE.md has PR rules, they come first.

Work from a work branch (worktree) off the base branch, and keep unrelated work out of it. Build commits up as you work, in small, landable units (step 5 of the procedure). When opening the PR, do not rewrite commits or clean up the code again. The tree that passed verification and review goes out as the PR as is.

Title: `type(scope): subject`, naming a real symbol when one carries the change. Body: a one-minute briefing of at most 40 lines with these `##` headings in order, dropping empty ones: `## Why`, `## What changed`, `## Scope`, `## Tradeoffs` (only rejected alternatives a reviewer would otherwise ask about), `## Blast Radius`, `## Verification`. Open `## Why` with the goal.

Open the PR against the base branch, ready for review, never as a draft: use `gh pr create` without `--draft`. Opening a PR does not start watching it (CI, review replies).
