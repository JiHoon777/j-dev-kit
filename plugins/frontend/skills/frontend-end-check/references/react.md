# React / Next.js: end checks

Read by `frontend-end-check` when `react` is in package.json `dependencies` or `devDependencies`. Add these rows, agents, and after-fix items to that skill's report.

This file only runs tools and compares results. Reviews that read the diff and judge it (derived state, effects, keys, request waterfalls, Next boundaries, …) are handed to the `frontend:react-reviewer` agent (step 4).

If no `.jsx`/`.tsx` (or `.js`/`.ts` holding hooks) changed, do only step 1 and skip the rest with "no React changes".

## 1. Lint (compared with the baseline)

Run the lint command from `### Baseline` again. New react-hooks violations (`rules-of-hooks`, `exhaustive-deps`, compiler rules) → fail. Record the count and locations of `eslint-disable` on added lines (whether the reason is valid is for `react-reviewer`).

## 2. React Doctor

Run `npx -y react-doctor@0.9.22 --verbose --no-telemetry --scope changed`. A lower score than the baseline, or new findings in changed files → fail. Without a baseline, record only the score. If it cannot run, skip with "no React Doctor".

## 3. Build

For Next.js, check that `next build` (the project's build script) passes. If the common step already ran it, use that result.

## 4. Agent to add to the review

If any React file above changed, return `frontend:react-reviewer` with the evidence (list of changed files and the React Doctor findings). This agent reviews derived state, effect cleanup and races, keys, request waterfalls, the Next server/client boundary, server action validation, `dangerouslySetInnerHTML`, unnecessary memoization, and the reasons for `eslint-disable`.

## Rows to add

```markdown
| react-hooks lint | … | 0 new violations, 0 new eslint-disable |
| React Doctor | … | 82 → 84 |
| Next build | … | … |
```

After fixes: run the lint and React Doctor again.
