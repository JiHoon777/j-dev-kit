> Translation. Source: [plugins/frontend/skills/frontend-start-check/references/svelte.md](../../../../../../../plugins/frontend/skills/frontend-start-check/references/svelte.md). Update this file when the source changes. Claude does not read this file.

# Svelte 5 / SvelteKit: start check

Read by `frontend-start-check` when package.json has `svelte`. Add the following to that skill's "To follow".

Svelte's basic rules (runes, not using Svelte 4 syntax), `svelte-autofixer`, and doc lookup are left to the skills of the official Svelte plugin (`svelte@svelte`). That plugin's `svelte-file-editor` agent is not used.

## To follow

- When creating or modifying `.svelte`, `.svelte.ts`, `.svelte.js`, invoke the `svelte-code-writer` and `svelte-core-bestpractices` skills and follow them.
- Do not fix problems `svelte-autofixer` reports in existing code you did not touch; only report them (they are outside the item's scope). Fix problems reported in the code you wrote this time.
- Do not insert values written by other people with `{@html}`.
- Code that needs secrets goes only in server files (`+page.server.*`, `+server.*`) (`$env/*/private` only in server files). `load` checks authorization and does not return other users' data. Form action failures use `fail()`.
- With `adapter-static`, do not create server files (`+page.server.*`, `+server.*`, form actions).

## To ask

- If the official Svelte plugin is not installed, ask whether to install it (the command under "Used when installed" in the README).
- If the installed `svelte` is 4 or lower, say that the rules above do not apply and ask how to proceed.
