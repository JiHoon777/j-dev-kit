> Translation. Source: [plugins/workflow/skills/lead/references/scout.md](../../../../../../../plugins/workflow/skills/lead/references/scout.md). Update this file when the source changes. Claude does not read this file.

# lead scout: take proposals, write them to the proposals file, and raise them

The `workflow:backlog-scout` agent looks for proposals and reports them. Only this session writes the proposals file (`docs/backlog/_proposals.md`). The agent writes no files.

1. **Start:** start the `workflow:backlog-scout` agent. Put only the repository's absolute path in its instructions. The agent has the procedure.
2. **Check:** the report is the agent's claim. For each new proposal, open its evidence (`file:line`, commit, item number) and see that it holds. Also check that the reasons for dropping previous proposals hold. Do not write what is wrong; say what was wrong in step 4.
3. **Write:** add the new proposals to the proposals file by angle, and delete the lines of the previous proposals to drop. Update the time (`date`) and the seen commit on the `Updated:` line under the title. Leave the remaining lines and `## Rejected` as they are. If `docs/backlog/` or the file does not exist, create it (`/task create` makes `README.md` and `_template.md`). The format is below. If you created the file, also follow section 1 of `${CLAUDE_SKILL_DIR}/references/schedule.md` (taking the proposals file out of git) in step 4.
4. **Raise:** read step 2 of `${CLAUDE_SKILL_DIR}/references/run.md` and follow it as written. Show the proposals all at once and ask: promote / reject / leave. Add one line each on what is new, what was dropped, and the titles under "Could not add for lack of room" in the report.

- If the agent cannot be used, read `${CLAUDE_SKILL_DIR}/../../agents/backlog-scout.md`, follow that procedure yourself to make a report in the same format, and continue from step 3.

## Proposals file format

```markdown
# Proposals

Updated: YYYY-MM-DD HH:MM · Seen commit: <hash>

## Ideas

- **<title>** — <one sentence on why it is needed> (evidence: `src/a.ts:12`) · Next: clear
- **<title>** — … (evidence: item 004) · Next: needs discussion

## Backlog grooming

None

## Improvements

- …

## Rejected

- <title> — YYYY-MM-DD — <reason>
```

Write "None" for an angle with no proposals. `## Rejected` is written by step 2 of `run`.
