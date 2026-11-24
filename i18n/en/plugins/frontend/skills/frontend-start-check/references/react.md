> Translation. Source: [plugins/frontend/skills/frontend-start-check/references/react.md](../../../../../../../plugins/frontend/skills/frontend-start-check/references/react.md). Update this file when the source changes. Claude does not read this file.

# React / Next.js / React Router: start check

Read by `frontend-start-check` when package.json has `react`. Add the following to that skill's "To follow".

## To follow

- When creating or changing components, invoke the `vercel-react-best-practices` skill and follow it. If you change how components are put together (composition, props design), also `vercel-composition-patterns`.
- If there is `react-router`, invoke the `react-router` skill and follow it.
- If there is `next`, read the `AGENTS.md` that Next generated and the installed version's docs it points to as the reference for APIs. Do not guess an API you do not know.

## To ask

- If the skills above are not installed, ask whether to install them (the commands under "Used when installed" in the README).
- If Next is below 16.3 and there is no `.next-docs/`, ask whether to fetch the docs with `npx @next/codemod@canary agents-md`.
