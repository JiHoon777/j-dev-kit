# Svelte 5 / SvelteKit: start checks

Read by `frontend-start-check` when `svelte` is in package.json. Add these rows, baseline lines, prompts, and rules to that skill's report.

| Part | Source |
| --- | --- |
| Docs lookup, autofixer, code-writing rules | Official Svelte plugin `svelte@svelte` (MCP `list-sections`, `get-documentation`, `svelte-autofixer`; skills `svelte-code-writer`, `svelte-core-bestpractices`), invoked as is. Recommended, not required |
| Type and accessibility checks | `sv check` (`svelte-check`) |

## 1. Versions and structure

- Record the installed versions of `svelte` and `@sveltejs/kit` (`version` in `node_modules/<package>/package.json`). If Svelte is 4 or older, say the later rules differ and that upgrading is outside this item's scope.
- For SvelteKit, record the adapter (`adapter-*` in `svelte.config.js`). If it is `adapter-static`, add to the rules during implementation that server code (`+page.server.*`, `+server.*`, form actions) cannot be used.
- Count leftovers of old patterns with `grep`. They are not failures; put the counts in the evidence. New code uses the new patterns.
  - `$app/stores` imports → `$app/state` (`npx -y sv@1.2.0 migrate app-state` can move them)
  - `.svelte` files with Svelte 4 syntax such as `export let`, `$:`, `on:click`, `<slot>`

## 2. Baseline

- The project's type check command (usually the `check` script: `svelte-kit sync && svelte-check …`), otherwise `npx -y sv@1.2.0 check --output machine`.
- Record the number of errors and warnings and the files (if many, the count and the first 10). Existing errors and warnings are **baseline**.

## 3. Autofixer availability

- Check that `svelte-autofixer` can run: the MCP tool from the Svelte plugin if present, otherwise the CLI `npx -y @sveltejs/mcp@0.1.28 svelte-autofixer <file> --svelte-version 5`.
- If neither works → fail (files cannot be auto-checked during implementation). If the Svelte plugin is not installed, suggest installing it (`/plugin marketplace add sveltejs/ai-tools`, then `/plugin install svelte@svelte`).

## 4. Exploration prompt (to return)

> Summarize how this Svelte codebase is put together for this item (<item path>): the route and layout structure under `src/routes`, where state lives (`.svelte.ts` modules with runes, context, stores), how data is loaded (`load` functions, client fetches, form actions), and shared components. Trace one existing feature similar to this item to the end, and return 5–10 files that must be read. Do not edit files.

## 5. Rules during implementation (to return)

- When creating or editing `.svelte`, `.svelte.ts`, or `.svelte.js` files, invoke the Svelte plugin's `svelte-code-writer` skill and follow it. When rune or state design is involved, also invoke `svelte-core-bestpractices`.
- Do not guess unknown APIs. Read the official docs with the Svelte MCP's `list-sections` → `get-documentation`.
- **Run every edited `.svelte` file through `svelte-autofixer`.** The MCP tool if available, otherwise `npx -y @sveltejs/mcp@0.1.28 svelte-autofixer <file path> --svelte-version 5`. Fix until no issues or suggestions remain.
- Derived values use `$derived`. Do not build derived values by assigning to state inside `$effect`.
- Do not use `window`, `document`, or `localStorage` in a component's top-level code (it breaks server rendering and prerendering). Use them in `onMount`, `$effect`, or after a `browser` check.
- Never insert values written by others with `{@html}`.
- With SvelteKit `load` and form actions: code that needs secrets goes only in `+page.server.*` (`$env/static/private` only in server files), and failures return `fail()`. With a static adapter, do not create server files.

## Rows to add

```markdown
| Svelte versions | pass | svelte 5.x, @sveltejs/kit 2.x, adapter-static |
| Old patterns | … | $app/stores 2, Svelte 4 syntax files 0 |
| Autofixer | … | MCP tool / CLI |
```

Baseline line: `| sv check | pnpm check | errors 0, warnings 2 |`
