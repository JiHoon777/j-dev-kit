# React / Next.js: start checks

Read by `frontend-start-check` when `react` is in package.json. Add these rows, baseline lines, prompts, questions, and rules to that skill's report.

| Part | Source |
| --- | --- |
| Hooks and compiler rules | React team's `eslint-plugin-react-hooks` (`recommended` preset) |
| Health score | React Doctor (`millionco/react-doctor`) CLI |
| Writing rules | Vercel `react-best-practices` skill (`vercel-labs/agent-skills`), invoked as is if installed |

## 1. Versions and structure

- Record the installed versions of `react`, `react-dom`, and `next` (if present).
- **React Compiler:** if `babel-plugin-react-compiler` is installed or `reactCompiler` is enabled in the Next config, record "compiler in use", and add to the rules during implementation that new code should not reach for `useMemo`, `useCallback`, or `memo` by habit.
- **Next.js:** `app/` (App Router), `pages/` (Pages Router), or both. Count files with `'use client'` (count only; where and why goes to the exploration prompt).
- **Data fetching:** record only whether `@tanstack/react-query`, `swr`, or `@apollo/client` is a dependency. How data is actually loaded is not investigated here; it goes to the exploration prompt.

## 2. eslint-plugin-react-hooks

- Check that the ESLint config includes `eslint-plugin-react-hooks` with `recommended` enabled (rules `rules-of-hooks`, `exhaustive-deps`, and compiler rules such as `purity`, `refs`, `immutability`, `set-state-in-effect`, `set-state-in-render`, `static-components`).
- If it is missing or partly enabled, it is not a failure; return it as a question. The user decides whether to add it.

## 3. Baseline

- The project's lint result (count react-hooks violations separately).
- React Doctor: score (0–100) and findings per category from `npx -y react-doctor@0.9.22 --verbose --no-telemetry`. Tell the user it downloads the package the first time. If it fails or the user declines, skip with "no React Doctor".

## 4. Exploration prompt (to return)

> Summarize how this React codebase loads and changes data: the query library (react-query, swr, …) and where query keys and the API client live, server component fetches, server actions, route handlers. With the App Router, where the `'use client'` boundaries are and why. Trace one existing feature similar to this item (<item path>) to the end, and return 5–10 files that must be read. Do not edit files.

## 5. Rules during implementation (to return)

- If the `vercel-react-best-practices` skill is installed, invoke it when creating or changing components and follow its rules (request waterfalls, bundle size, server work, client fetching, re-renders, rendering). If not, add a question about installing it (`npx -y skills@1.7.5 add vercel-labs/agent-skills`).
- Call hooks only at the top level of components and custom hooks, never inside conditions or loops.
- Do not keep values computed from other state in state; compute them during render. Do not sync state with `useEffect`.
- If a `useEffect` creates a subscription, timer, or event listener, return a cleanup. Guard requests against races (cancel or ignore flag).
- List `key`s are each item's unique value. Never use the array index for lists that add, remove, or reorder.
- Next App Router: put `'use client'` only on the smallest component that needs interaction. Never import secrets or server-only modules from client components (use the `server-only` package if present).
- Never insert values written by others with `dangerouslySetInnerHTML`.

## Rows to add

```markdown
| React versions | pass | react 19.x, next 16.x (App Router, 'use client' 12 files) |
| React Compiler | … | … |
| react-hooks lint | … | recommended on / missing → question |
```

Baseline lines: `| Lint (react-hooks) | pnpm lint | 0 violations |`, `| React Doctor | npx -y react-doctor@0.9.22 --verbose --no-telemetry | 82 |`
