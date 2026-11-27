> Translation. Source: [plugins/workflow/skills/frontend-start-check/references/react.md](../../../../../../../plugins/workflow/skills/frontend-start-check/references/react.md). Update this file when the source changes. Claude does not read this file.

# React / Next.js / React Router: start check

Read by `frontend-start-check` when package.json has `react`. Add the following to that skill's "To follow".

## To follow

- When creating or changing components, invoke the `vercel-react-best-practices` skill and follow it. If you change how components are put together (composition, props design), also `vercel-composition-patterns`.
- If there is `react-router`, invoke the `react-router` skill and follow it.
- If the skills above cannot be invoked, do not install anything and go with the rules below only. Return one line under what to follow (`start` reports it in the last message). If a skill is not installed: "No <skill name>. Running `/kit-setup` installs it". If it was installed after this session opened and is not picked up yet: "<skill name> takes effect from a new session". Do not write that when the `- 공식 스킬 설치 안 함:` (official skills not installed) line under `## 작업 설정` (work settings) in CLAUDE.md has that name (`react`, `react-router`). Do not write it either when `react-native` or `expo` is present and `react-dom` is not. `/kit-setup` does not install them in that case.
- If there is `next`, read the `AGENTS.md` that Next generated and the installed version's docs it points to as the reference for APIs. Do not guess an API you do not know.
- Do not import secrets or server-only modules in client components (`'use client'`). Server actions and route handlers perform input validation and authorization checks.
- Do not insert values written by other people with `dangerouslySetInnerHTML`.

## To ask

- If Next is below 16.3 and there is no `.next-docs/`, ask whether to fetch the docs with `npx @next/codemod@canary agents-md`. The command is not pinned to a version, so do not run it without asking.
