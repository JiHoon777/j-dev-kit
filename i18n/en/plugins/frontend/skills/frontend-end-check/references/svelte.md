> Translation. Source: [plugins/frontend/skills/frontend-end-check/references/svelte.md](../../../../../../../plugins/frontend/skills/frontend-end-check/references/svelte.md). Update this file when the source changes. Claude does not read this file.

# Svelte 5 / SvelteKit: end check

Read by `frontend-end-check` when package.json has `svelte`.

If no `.svelte`, `.svelte.ts`, `.svelte.js` files changed, skip.

## Checks

Run `svelte-autofixer` on each changed Svelte file (the MCP tool, otherwise `npx -y @sveltejs/mcp@0.1.28 svelte-autofixer <file> --svelte-version 5`). Judge by the output, not the exit code. If problems remain, fail. Type and accessibility warnings (`svelte-check`) are in the verification commands, so do not run them again here.

## After fixes

Run `svelte-autofixer` again on the fixed Svelte files.
