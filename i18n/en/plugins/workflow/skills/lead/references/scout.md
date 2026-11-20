> Translation. Source: [plugins/workflow/skills/lead/references/scout.md](../../../../../../../plugins/workflow/skills/lead/references/scout.md). Update this file when the source changes. Claude does not read this file.

# lead scout: refresh the proposals file

The proposals file (`docs/backlog/_proposals.md`) is written by the `workflow:backlog-scout` agent. This session does not read the repository itself; it reads only the finished proposals file.

1. Start the `workflow:backlog-scout` agent. Put only the repository's absolute path in its instructions. The agent has the procedure.
2. When the agent finishes, read `docs/backlog/_proposals.md` and show the proposals as they are. Add one line from the agent's report on what is new and what was dropped.
3. Say that promoting and rejecting happen in `/lead run`. Do not create items here.

If the agent cannot be used, read `${CLAUDE_SKILL_DIR}/../../agents/backlog-scout.md`, follow that procedure yourself, and continue from step 2.
