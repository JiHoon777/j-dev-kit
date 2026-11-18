> Translation. Source: [plugins/architecture/skills/arch/references/docs.md](../../../../../../../plugins/architecture/skills/arch/references/docs.md). Update this file when the source changes. Claude does not read this file.

# Architecture documents

The location and format of the documents design and review write. If the project CLAUDE.md specifies a location, follow it.

## 1. Location

| Document | If one already exists | If none exists |
| --- | --- | --- |
| Overview | Whichever exists of `ARCHITECTURE.md`, `docs/architecture/README.md`, `docs/architecture.md` | `docs/architecture/README.md` |
| ADR | Whichever exists of `docs/adr/`, `docs/decisions/`, `doc/architecture/decisions/`, `docs/architecture/decisions/` | `docs/architecture/decisions/` |
| Research | `docs/architecture/research/` | `docs/architecture/research/` |

If there are two or more ADR folders, ask which one to use. If existing ADRs have a file naming rule and format, follow them; use the format below only when there are none.

## 2. Overview document

A map of about 100 lines. Do not write what can be learned by reading the code (a list of every file, function descriptions). It is enough if a newcomer (human or agent) can tell where to look and where to put things.

```markdown
# Architecture

Updated: YYYY-MM-DD

## Quality goals
1. <goal> — <a scenario that can be checked: who, when doing what, what result within how long>
2. …  (3-5, in ranked order)

## Stack
| Area | Choice | Reason |
| --- | --- | --- |
| Language and runtime | … | [ADR-0001](decisions/0001-….md) |
| … | … | One-line reason (two-way door) |

## Module map
| Path | Responsibility | Public interface | What makes it change |
| --- | --- | --- | --- |
| `src/billing/` | Payments and billing | `src/billing/index.ts` | Adding payment methods, changing pricing plans |

## Dependency rules
- <rule> — enforced by: <check name, or "none yet">

## How to add a new X
### New <common change 1>
1. Create <file> in `<path>` (e.g. `<existing example file>`)
2. …
3. Verify: <command>

## Decisions
- [ADR-0001 title](decisions/0001-….md) — status

## Known debt
- <problem> — where — why it was deferred — when to revisit
```

- In "How to add a new X", write only 2-4 changes that actually happen often in this project. Each step points to a real path and a real example file.
- For content that is in other documents, only link to it.

## 3. ADR

A trimmed-down form of [MADR 4.0](https://adr.github.io/madr/). One file per one-way door decision.

File name: `NNNN-title-in-lowercase-with-hyphens.md`. The number is the largest existing number + 1, four digits.

```markdown
---
status: proposed | accepted | rejected | deprecated | superseded by ADR-NNNN
date: YYYY-MM-DD
---

# <the decision in one sentence>

## Problem
<what needs deciding, and why now. Related quality goals>

## Options considered
- <option A>
- <option B>

## Decision
<the choice>. Reason: <the key evidence from the factor table; link the research file for sources>

## Consequences
- What gets easier: …
- What gets harder: …
- When to revisit: <the conditions for revisiting this decision. E.g. when users pass 100,000, when support for X ends>

## How to verify
<the check that shows this decision is being followed. If none, "Manual: <what to look at>">
```

- Decisions the user approved are `accepted`; proposals before approval are `proposed`.
- Do not edit the decision content of an `accepted` ADR. To change it, write a new ADR and change only the old ADR's status to `superseded by ADR-NNNN`.
- Typos and broken links may be fixed.

## 4. Research files

The format is section 5 of `references/research.md`. Put the checked date at the top of the file. Link to them from ADRs and the overview document.

## 5. CLAUDE.md

When you create the overview document for the first time, ask whether to add one line to CLAUDE.md. Do not copy its content.

```markdown
- Architecture: docs/architecture/README.md (read before changing the structure; record decisions as ADRs)
```
