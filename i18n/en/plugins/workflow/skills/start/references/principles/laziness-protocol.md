# Laziness Protocol

> Source: `pstack/skills/principle-laziness-protocol/SKILL.md` in `cursor/plugins` (MIT, Lauren Tan). Cursor names were replaced with Claude Code names, and lines pointing to skills that were not imported were removed.

**When:** Refactoring, evaluating diff size, or tempted to add abstractions, layers, or signal threading.

Bias toward deletion and the smallest change that solves the problem.

- **Consolidate decisions.** Do not repeat the same choice in several places. Put it behind one source of truth and pass the result as a simple flag.
- **Minimize the diff.** Make the smallest change that solves the problem. Fewer lines beat "elegant" boilerplate.
