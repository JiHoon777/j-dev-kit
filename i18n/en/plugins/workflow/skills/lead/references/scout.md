> Translation. Source: [plugins/workflow/skills/lead/references/scout.md](../../../../../../../plugins/workflow/skills/lead/references/scout.md). Update this file when the source changes. Claude does not read this file.

# lead scout: refresh the proposals file

Read the repository and rewrite the single file `docs/backlog/_proposals.md`. Only propose. A proposal becomes a backlog item only when the user promotes it in `/lead run`.

## 1. Rules

- The only file written is `docs/backlog/_proposals.md`. Do not edit code, backlog items or other docs. Do not commit.
- Read only: reading files, `git log`, `git diff`. Do not run the verify command, builds or servers.
- If `docs/backlog/` does not exist, write nothing and report that.
- Use the document language set in the project CLAUDE.md.

## 2. What to read

- Items in `docs/backlog/` and `docs/done/`, and the notes in `docs/backlog/README.md`
- The existing `docs/backlog/_proposals.md`: what is under `## Rejected`, and the previous proposals
- README, CLAUDE.md, and the commits since the last run (from after the "seen commit" in `_proposals.md`; on the first run, the latest 30)

## 3. Look for proposals from three angles

| Angle | What to look for |
| --- | --- |
| Ideas | Goals written in the docs that have no item, notes worth turning into items, things left as "deferred" in the `Final Summary` of finished items |
| Backlog grooming | Overlapping items, items already reflected in the code, items too big to review at once, wrong `dependencies` |
| Improvements | `TODO` and `FIXME`, signs in recent commits of the same place being fixed repeatedly, problems written in the `Implementation Notes` of finished items |

- At most 3 per angle. If nothing is found, write "None". Do not invent proposals to fill the list.
- Give evidence for every proposal: a `file:line`, a commit hash or an item number. If you cannot give evidence, do not propose it.
- Do not propose anything that overlaps an item in `docs/backlog/` or `docs/done/`, or that is under `## Rejected`.
- Keep a previous proposal only if it still holds. Rewrite the whole file (carry over only `## Rejected` as it is).

## 4. File format

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

"Next: clear" means it can be made into an item right away; "needs discussion" means the user has to set the direction. `## Rejected` is written by `/lead run`.

## 5. Report

End in one or two lines: the number of proposals per angle and the titles of the proposals that are new this time. If there are no new proposals, "No new proposals".
