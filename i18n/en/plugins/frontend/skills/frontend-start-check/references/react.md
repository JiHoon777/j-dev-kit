> Translation. Source: [plugins/frontend/skills/frontend-start-check/references/react.md](../../../../../../../plugins/frontend/skills/frontend-start-check/references/react.md). Update this file when the source changes. Claude does not read this file.

# React / Next.js: start check

Read by `frontend-start-check` when package.json has `react`. Add the following to that skill's "To follow".

## To follow

- When creating or changing components, invoke the `vercel-react-best-practices` skill if available and follow it.
- Call hooks only at the top level of components and custom hooks.
- Values that can be computed from other state or props are not kept in state; compute them during rendering. Do not sync state with `useEffect`.
- If `useEffect` creates a subscription, timer, or listener, return a cleanup function. Cancel or ignore requests so that a late response does not overwrite a newer one.
- Do not use array indexes as `key` for lists with additions, deletions, or reordering.
- If you use React Compiler (`babel-plugin-react-compiler`, Next `reactCompiler`), do not habitually add `useMemo`, `useCallback`, `memo`.
- Next App Router: put `'use client'` only on the smallest component that needs interactivity. Do not import secrets or server-only modules in client components. Server actions perform input validation and authorization checks.
- Do not insert values written by other people with `dangerouslySetInnerHTML`.
