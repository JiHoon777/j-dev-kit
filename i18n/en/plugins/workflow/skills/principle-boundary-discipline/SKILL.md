---
name: principle-boundary-discipline
description: "The Boundary Discipline principle. Wiring validation, error handling, or framework adapters."
disable-model-invocation: true
---

# Boundary Discipline

> Source: `pstack/skills/principle-boundary-discipline/SKILL.md` in `cursor/plugins` (MIT, Lauren Tan). Cursor names were replaced with Claude Code names, and lines pointing to skills that were not imported were removed.

**When:** Wiring validation, error handling, or framework adapters.

Validate, narrow types, and handle errors where data crosses a system boundary (CLI args, config files, external APIs, network). Inside, trust the types: no re-validation and no redundant nil checks. Parse raw data into domain types at the boundary, and keep transport and framework types out of the public surface. Business logic lives in pure functions with no framework dependencies. The shell that calls them is thin.

Two tests. Is this data crossing a boundary right now? If not, the validation is redundant. Can this be a pure function the shell just calls? If yes, extract it.
