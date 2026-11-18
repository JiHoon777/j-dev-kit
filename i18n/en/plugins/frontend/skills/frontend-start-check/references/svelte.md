> Translation. Source: [plugins/frontend/skills/frontend-start-check/references/svelte.md](../../../../../../../plugins/frontend/skills/frontend-start-check/references/svelte.md). Update this file when the source changes. Claude does not read this file.

# Svelte 5 / SvelteKit: start check

Read by `frontend-start-check` when package.json has `svelte`. Add the following to that skill's "To follow".

If the official Svelte plugin (`svelte@svelte`) is installed, use its skills and MCP tools. Without it, the CLI below works.

## To follow

- When creating or modifying `.svelte`, `.svelte.ts`, `.svelte.js`, invoke the `svelte-code-writer` skill if available.
- Do not guess APIs you don't know. Look up the docs with the Svelte MCP's `list-sections` → `get-documentation`.
- Check modified Svelte files with `svelte-autofixer`: the MCP tool, otherwise `npx -y @sveltejs/mcp@0.1.28 svelte-autofixer <file> --svelte-version 5`. Judge by the output, not the exit code, and fix until no problems remain.
- Derived values use `$derived`. Do not create them by assigning to state inside `$effect`.
- Do not use `window`, `document`, `localStorage` at component top level. Use them inside `onMount`, `$effect`, or after a `browser` check.
- Do not insert values written by other people with `{@html}`.
- Code that needs secrets goes only in `+page.server.*` (`$env/static/private` only in server files). Form action failures use `fail()`.
- With `adapter-static`, do not create server files (`+page.server.*`, `+server.*`, form actions).
- Do not use Svelte 4 syntax (`export let`, `$:`, `on:click`, `<slot>`, `$app/stores`) in new code.

## To ask

If the installed `svelte` is 4 or lower, say that the rules above do not apply and ask how to proceed.
