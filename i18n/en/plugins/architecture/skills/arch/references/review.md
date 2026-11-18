> Translation. Source: [plugins/architecture/skills/arch/references/review.md](../../../../../../../plugins/architecture/skills/arch/references/review.md). Update this file when the source changes. Claude does not read this file.

# arch review: review an existing codebase

Review an existing codebase (or one path) against the criteria in `references/criteria.md`. **Do not edit code.** Write only the findings the user picks into documents (ADRs, the overview document's Known debt).

Scope: the path after `review` (without `--research`). If there is none, the whole repository.

## 1. Can we start

- If it is not a git repository, skip the git parts of the measurements and say so.
- If there is almost no code in scope (a few files), say there is no structure to review and suggest `/arch design`.

## 2. System map

1. Read: the overview document and ADRs (location in `references/docs.md`), CLAUDE.md, manifests, top-level and second-level folders, entry points.
2. Sketch it briefly:
   - App type and stack (with versions)
   - Module list: path → responsibility → public interface → what makes it change
   - Dependency direction
   - Quality goals: those in the docs if there are any; otherwise infer them and mark them "inferred"
3. Show it and ask: "Is this map right? If anything is wrong, or there is somewhere the review should look at in particular, let me know." Do not make judgments on top of a wrong map. Apply what the user corrects.

## 3. Measure

Run only read-only commands. Do not build, test, install, or run servers. If the scope is one path, add `-- <path>` to the commands. Exclude generated files, dependency folders, and lock files. The commands assume bash. If one fails, mark that measurement "could not measure" and move on.

```bash
# Top 20 largest files (line count)
git ls-files | grep -vE '(^|/)(vendor|node_modules|dist|build|generated|__generated__)/|\.(lock|svg|png|jpg|jpeg|gif|ico|pdf|min\.js|map)$|(^|/)[^/]*lock[^/]*$' \
  | tr '\n' '\0' | xargs -0 wc -l 2>/dev/null | grep -v ' total$' | sort -rn | head -20

# Hotspots: number of changes in the last 12 months and line count
git log --since='12 months ago' --no-merges --name-only --format= | grep -v '^$' | sort | uniq -c | sort -rn | head -40 \
  | while read -r n f; do [ -f "$f" ] && printf '%s\t%s\t%s\n' "$n" "$(wc -l < "$f")" "$f"; done | head -20

# Files changed per commit (median, top 10%)
git log --since='12 months ago' --no-merges --name-only --format='@@%h' \
  | awk '/^@@/{if(n)print n; n=0; next} NF{n++} END{if(n)print n}' | sort -n \
  | awk '{a[NR]=$1} END{if(!NR) exit; p=int(NR*0.9); if(p<1)p=1; print "commits", NR, "median", a[int((NR+1)/2)], "p90", a[p]}'

# File pairs that change together (3 or more times, excluding commits that changed more than 20 files)
git log --since='12 months ago' --no-merges --name-only --format='@@%h' | awk '
  function flush(  i,j,a,b,t){ if(k>1 && k<=20) for(i=1;i<=k;i++) for(j=i+1;j<=k;j++){ a=f[i]; b=f[j]; if(a>b){t=a;a=b;b=t} c[a" "b]++ } k=0 }
  /^@@/{flush(); next} NF{f[++k]=$0} END{flush(); for(p in c) if(c[p]>=3) print c[p], p}' | sort -rn | head -20
```

Then look at:

- **Verify commands:** are there lint, type, and test commands in CLAUDE.md, `package.json` scripts, `Makefile`, `justfile`, or the CI config? Do not run them.
- **Architecture check tools:** is there a config file for a tool in the table in `references/enforce.md`?
- **End of support:** are the current versions of the main language, runtime, and framework still supported? Launch `architecture-researcher` to check with [endoflife.date](https://endoflife.date/). This is a short research task that does only this.

From the measurement results, use the **top hotspots** and **distant file pairs that change together** as the priorities for the review scope. Do not look deeply at old code that rarely changes unless its cost is visible.

## 4. Research (only with `--research`)

Launch `architecture-researcher` as described in `references/research.md` to research the latest structural guidance for this app type and stack. Launch it at the same time, in one message, as the end-of-support check from section 3. In the results, mark what differs from or adds to `references/criteria.md`.

## 5. Review

Launch `architecture-reviewer` agents.

- 1 if there are five modules or fewer or the scope is small.
- If large, split the module map from section 2 into 2-3 areas and launch them at the same time in one message. For dependencies that cross areas, have each agent look at "what it uses across the boundary", and look at them when combining.

The agents cannot see this conversation, so put the following in their instructions:

1. The absolute path of the criteria file: `<this skill's folder>/references/criteria.md`
2. The assigned scope (paths), the system map from section 2 (with the user's corrections applied), and the quality goals
3. The measurement results from section 3 (those that apply to that scope), the end-of-support results, and the research summary from section 4 (if any)
4. The paths of the overview document and ADRs
5. Read only: do not edit files, and do not run build, test, install, or server commands.

## 6. Show and ask

After all of them come back:

1. Merge duplicates.
2. Open the code yourself to confirm each finding. Drop findings that are wrong, findings without evidence, and findings that fall under "Do not flag" in `criteria.md`.
3. Classify:
   - 🔴 Must fix: structural problems that are already costing something (hotspots, or forcing every change to touch several modules), circular dependencies, things that block the top-ranked quality goal, runtimes or frameworks whose support has ended
   - 🟡 Consider: real problems whose cost is small for now
   - ⚪ Minor: count only

```markdown
### System map (confirmed)
<brief>

### Measurements
- Files per commit: median N, top 10% N
- Top 5 hotspots: …
- Distant file pairs that change together: …
- Verify commands: … / Architecture checks: yes (tool) / none
- End of support: …

🔴 Must fix
- `src/a.ts:12` — problem — criterion: 2 Coupling and cohesion (source) — direction of the fix — what gets easier once fixed

🟡 Consider
- …

⚪ Minor: N items (let me know if you want to see them)

### What checks could prevent
- <rule> — <tool> (format in section 4 of `references/enforce.md`)

### Could not verify
- …
```

Ask once: "For each finding, choose **decide with an ADR** / **record as Known debt** / **leave as is**. For 🔴, I recommend an ADR or a debt record." If the user wants, decide them one by one. Do not write anything before getting an answer.

## 7. Write the documents

- **Decide with an ADR:** if there are alternatives for the direction of the fix, write a `proposed` ADR in the format of section 3 of `references/docs.md`. If the user also decided the direction, `accepted`. If you did research, save the research file as well and link it.
- **Record as Known debt:** one line each under "Known debt" in the overview document. If there is no overview document, ask whether to create one from the system map in section 2.
- **Leave as is:** write nothing.
- Do not edit code. The user does the fixing separately (e.g. as a backlog item).

Report: the files written, what was decided for each finding, what you could not verify. Commit only when the user asks.
