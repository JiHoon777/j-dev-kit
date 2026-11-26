---
name: principle-prove-it-works
description: "The Prove It Works principle. After completing a task, before declaring done."
disable-model-invocation: true
---

# Prove It Works

> Source: `pstack/skills/principle-prove-it-works/SKILL.md` in `cursor/plugins` (MIT, Lauren Tan). Cursor names were replaced with Claude Code names, and lines pointing to skills that were not imported were removed.

**When:** After completing a task, before declaring done.

Verify every output by checking the real thing directly: run the feature, read the actual value, inspect the diff. Proxies (file mtimes, self-reports, cached output, "it compiles") do not count. When a check fails, suspect the observation method before the system.

Script the check when you can. A deterministic script that reruns the comparison beats a one-time look. Keep its output where the human can see it, and commit it only when the trail must be auditable later.
