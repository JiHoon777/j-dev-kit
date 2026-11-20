> Translation. Source: [plugins/workflow/skills/lead/references/scout.md](../../../../../../../plugins/workflow/skills/lead/references/scout.md). Update this file when the source changes. Claude does not read this file.

# lead scout: take proposals, write them to the proposals file, and raise them

Agents look for proposals and report them. `workflow:backlog-scout` looks at the repository, and `workflow:trend-scout` at outside trends on the web. Only this session writes the proposals file (`docs/backlog/_proposals.md`). The agents write no files.

1. **Start:** start the `workflow:backlog-scout` agent. Unless the project CLAUDE.md has `바깥 동향: 끄기` (outside trends: off), start `workflow:trend-scout` in the same message too. Put only the repository's absolute path in their instructions, and also today's date (`date +%F`) for trend-scout. The agents have the procedure. If one agent fails, go on with the other's report and say so in step 4.
2. **Check:** the report is the agent's claim. For each new proposal, open its evidence (`file:line`, commit, item number, URL) and see that it holds. Open URLs with WebFetch, or with an agent that reads the web if there is none. Numbers change, so only check that the metric is there and not far off. A URL that does not open is wrong. Also check that the reasons for dropping previous proposals hold. Do not write what is wrong; say what was wrong in step 4. If trend-scout's "Queries used" contain code, secrets, or names of people or companies, say so in step 4.
3. **Write:** add the new proposals to the proposals file by angle, and delete the lines of the previous proposals to drop. Update the time (`date`) and the seen commit on the `Updated:` line under the title. Leave the remaining lines and `## Rejected` as they are. If `docs/backlog/` or the file does not exist, create it (`/task create` makes `README.md` and `_template.md`). The format is below. If you created the file, also follow section 1 of `${CLAUDE_SKILL_DIR}/references/schedule.md` (taking the proposals file out of git) in step 4.
4. **Raise:** read step 2 of `${CLAUDE_SKILL_DIR}/references/run.md` and follow it as written. Show the proposals all at once and ask: promote / reject / leave. Add one line each on what is new, what was dropped, what steps 1 and 2 said to raise, and trend-scout's "Could not read".

- If the agents cannot be used, read the files of the agents step 1 would start (`${CLAUDE_SKILL_DIR}/../../agents/<name>.md`), follow those procedures yourself to make reports in the same format, and continue from step 3.

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

## Outside trends

- **<title>** — … (evidence: https://… · YYYY-MM-DD · 👍 488) · Next: needs discussion

## Rejected

- <title> — YYYY-MM-DD — <reason>
```

Write "None" for an angle with no proposals. `## Outside trends` is there only when outside trends are on. `## Rejected` is written by step 2 of `run`.
