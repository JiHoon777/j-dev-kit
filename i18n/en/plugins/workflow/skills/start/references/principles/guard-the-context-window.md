# Guard the Context Window

> Source: `pstack/skills/principle-guard-the-context-window/SKILL.md` in `cursor/plugins` (MIT, Lauren Tan). Cursor names were replaced with Claude Code names, and lines pointing to skills that were not imported were removed.

**When:** Context is filling up: large outputs, long files, repeated reads, fan-out planning.

Route bulk to subagents. Keep summaries in the main thread, not raw payloads.

**Why:** Context overflow degrades reasoning quality, creates compression artifacts, and halts progress.

**Pattern:**
- **Size phases and cap scope.** Limit files per phase, set turn budgets, account for mechanism costs.
