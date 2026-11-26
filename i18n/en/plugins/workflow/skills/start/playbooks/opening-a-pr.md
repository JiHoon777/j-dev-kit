# Opening a PR

> Source: `pstack/skills/poteto-mode/playbooks/opening-a-pr.md` in `cursor/plugins` (MIT, Lauren Tan). Cursor names were replaced with Claude Code names. The source is invoked at the end of every other playbook. Here, step 12 of the `start` procedure calls it when the merge is by PR. The source's "rebase into small commits" applies only to commits not yet pushed, because the procedure forbids force-pushing.

**When:** The merge method is PR. Either the `merge` setting is `pr`, or the user chose PR in the final message. If the project CLAUDE.md has PR rules, they come first.

Work from a work branch (worktree) off the base branch, and keep unrelated work out of it. Rebase commits not yet pushed into small, landable units. Do not rewrite pushed commits. Follow the `deslop` skill over the diff before commit.

Title: `type(scope): subject`, naming a real symbol when one carries the change. Body: a one-minute briefing of at most 40 lines with these `##` headings in order, dropping empty ones: `## Why`, `## What changed`, `## Scope`, `## Tradeoffs` (only rejected alternatives a reviewer would otherwise ask about), `## Blast Radius`, `## Verification`.

Stack a follow-up PR by using the earlier PR's branch as its base. Open PRs ready for review, never as drafts: use `gh pr create` without `--draft`. Opening a PR does not start watching it (CI, review replies).
