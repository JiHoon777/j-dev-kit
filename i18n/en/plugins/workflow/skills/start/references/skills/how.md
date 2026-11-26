# How

> Source: `pstack/skills/how/SKILL.md` in `cursor/plugins` (MIT, Lauren Tan). Cursor names were replaced with Claude Code names, and lines pointing to skills that were not imported were removed.

**When:** Use for "how does X work", code walkthroughs before changing something, and placement, ownership, and layering questions ("where should this live", "which package owns this", "is this the right layer"). Explains subsystem architecture, runtime flow, and onboarding mental models. Use `skills/why.md` for motivation.

Explore the codebase to answer "how does X work?" questions.

If the scope is ambiguous, state your interpretation and explore. The user can redirect.

## 1. Explain

Use the `Agent` tool to spawn one `Explore` agent that explores and explains in one pass. Give it the user's question and this brief:

> You are writing an architectural explanation for a senior engineer. Explore the codebase and write an explanation that a senior engineer unfamiliar with this area could read and walk away with a solid mental model. They should understand the architecture well enough to start working in it confidently. You have read-only access to the codebase. Do not edit files.

## 2. Present

Present the subagent's output. Light edits for clarity or context from the conversation are fine. Do not substantially rewrite it.
