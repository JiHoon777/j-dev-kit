---
name: architect
description: "Non-trivial work where jumping to code would lock in the wrong shape, or a change that crosses a function boundary. Sketch types, signatures, and module structure before code, then stay in the loop while implementation fills in."
disable-model-invocation: true
---

# Architect

> Source: `pstack/skills/architect/SKILL.md` in `cursor/plugins` (MIT, Lauren Tan). Cursor names were replaced with Claude Code names, and lines pointing to skills that were not imported were removed.

**When:** Non-trivial work where jumping to code would lock in the wrong shape, or a change that crosses a function boundary. Sketch types, signatures, and module structure before code, then stay in the loop while implementation fills in.

Before writing code, trace every system the change touches, then sketch two different shapes for it (types, signatures, module boundaries) and pick the one where each piece of state has one owner, each task has one way to do it, and callers need to know least. Redesign instead of patching if workarounds repeat.
