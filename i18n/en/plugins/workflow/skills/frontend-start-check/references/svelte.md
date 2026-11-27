> Translation. Source: [plugins/workflow/skills/frontend-start-check/references/svelte.md](../../../../../../../plugins/workflow/skills/frontend-start-check/references/svelte.md). Update this file when the source changes. Claude does not read this file.

# Svelte 5 / SvelteKit: start check

Read by `frontend-start-check` when package.json has `svelte`. Add the following to that skill's "To follow".

## To follow

- When creating or modifying `.svelte`, `.svelte.ts`, `.svelte.js`, invoke the official Svelte plugin's (`svelte@svelte`) `svelte-code-writer` and `svelte-core-bestpractices` skills and follow them. That plugin's `svelte-file-editor` agent is not used. If those skills cannot be invoked, do not install anything and go with the rules below only. Return one line under what to follow (`start` reports it in the last message). If the plugin is not installed: "No official Svelte plugin. Running `/kit-setup` installs it". If it is installed but disabled (`claude plugin list` shows it as disabled): "The official Svelte plugin is disabled. Enable it in `/plugin`". If it is enabled but cannot be invoked in this session: "The official Svelte plugin takes effect from a new session". Do not write that when the `- 공식 스킬 설치 안 함:` (official skills not installed) line under `## 작업 설정` (work settings) in CLAUDE.md has `svelte`.
- Do not fix problems `svelte-autofixer` reports in existing code you did not touch; only report them (they are outside the item's scope). Fix problems reported in the code you wrote this time.
- Do not insert values written by other people with `{@html}`.
- Code that needs secrets goes only in server files (`+page.server.*`, `+server.*`) (`$env/*/private` only in server files). `load` checks authorization and does not return other users' data. Form action failures use `fail()`.
- With `adapter-static`, do not create server files (`+page.server.*`, `+server.*`, form actions).

## To ask

- If the installed `svelte` is 4 or lower, say that the rules above do not apply and ask how to proceed.
