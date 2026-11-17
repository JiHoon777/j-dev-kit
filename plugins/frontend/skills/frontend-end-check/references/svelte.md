# Svelte 5 / SvelteKit: end checks

Read by `frontend-end-check` when `svelte` is in package.json `dependencies` or `devDependencies`. Add these rows, agents, and after-fix items to that skill's report.

This file only runs tools and compares results. Reviews that read the diff and judge it (runes, SSR, server/client boundary, load and form actions, …) are handed to the `frontend:svelte-reviewer` agent (step 3).

If no `.svelte`, `.svelte.ts`, `.svelte.js`, or SvelteKit route file (`+page*`, `+layout*`, `+server*`, `hooks.*`) changed, do only step 1 and skip the rest with "no Svelte changes".

## 1. sv check (compared with the baseline)

Run the same command as `### Baseline`. New errors → fail. New warnings (including accessibility warnings) → fail; Svelte's accessibility warnings are real user problems. Unused CSS warnings go into the evidence only.

## 2. svelte-autofixer

Run **every** changed `.svelte`, `.svelte.ts`, and `.svelte.js` file through `svelte-autofixer` (the MCP tool, otherwise `npx -y @sveltejs/mcp@0.1.28 svelte-autofixer <file> --svelte-version 5`). Any remaining issue → fail; suggestions go into the evidence. What it catches: assignment inside `$effect`, passing a function to `$derived`, importing runes, stores instead of runes, `$app/stores` instead of `$app/state`, `class:` instead of clsx, attachment suggestions, and more.

## 3. Agent to add to the review

If any Svelte file above changed, return `frontend:svelte-reviewer` with the evidence (list of changed files and the suggestions left from step 2). This agent reviews rune usage, `$effect` cleanup, SSR, private environment variables, load and form actions, the adapter, `{@html}`, each keys, and old syntax.

## Rows to add

```markdown
| sv check | … | 0 new errors, 0 new warnings (existing …) |
| svelte-autofixer | … | N files, 0 issues left, suggestions … |
```

After fixes: run `svelte-autofixer` again on the fixed `.svelte` files.
