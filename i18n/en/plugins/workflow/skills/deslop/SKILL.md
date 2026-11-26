---
name: deslop
description: "Before committing. Remove AI-generated code slop from the branch and clean up code style."
disable-model-invocation: true
---

# Remove AI code slop

> Source: `cursor-team-kit/skills/deslop/SKILL.md` in `cursor/plugins` (MIT, Cursor). Cursor names were replaced with Claude Code names, and lines pointing to skills that were not imported were removed.

**When:** Before committing. Remove AI-generated code slop from the branch and clean up code style.

Check the diff against the base branch and remove AI-generated slop introduced in the branch.

## Focus Areas

- Extra comments that are unnecessary or inconsistent with local style
- Defensive checks or try/catch blocks that are abnormal for trusted code paths
- Casts to `any` used only to bypass type issues
- Deeply nested code that should be simplified with early returns
- Other patterns inconsistent with the file and surrounding codebase

## Guardrails

- Keep behavior unchanged unless fixing a clear bug.
- Prefer minimal, focused edits over broad rewrites.
- Keep the final summary concise (1-3 sentences).
