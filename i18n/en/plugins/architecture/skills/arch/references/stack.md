> Translation. Source: [plugins/architecture/skills/arch/references/stack.md](../../../../../../../plugins/architecture/skills/arch/references/stack.md). Update this file when the source changes. Claude does not read this file.

# Stack recommendations

Used when design has to decide the stack. That is, for a new project, or when adding a new component (database, queue, auth, state management, rendering approach, etc.) to an existing project.

**Stack recommendations always include a web survey** (even without `--research`). Do not answer versions, support periods, or maintenance status from memory.

## 1. Starting point

- **The existing stack is the default.** If the language, framework, and DB already in use can do the job, recommend them. Changing them is a one-way door, so there must be evidence that the existing ones cannot meet the quality goals.
- **Accepted ADRs are constraints.** Propose a new ADR only when a reason to revisit one has come up.
- **Ask about the user's skills.** Only when code and docs cannot tell you and it would change the recommendation. For example: "Are you more familiar with TypeScript or Python?"

## 2. What to decide first, by app type

Determine the factors to decide first, and if there is a decision tree for them, read it during the survey. For types with no official tree, compare only with the factor table below.

| App type | Decide first | Decision trees and guides to consult |
| --- | --- | --- |
| Web app or site | Rendering approach (static, SSR, CSR, mixed per page), degree of personalization, SEO, hosting | [web.dev Rendering on the Web](https://web.dev/articles/rendering-on-the-web) |
| API or backend | Data model (relational, document, key-value, graph), consistency requirements, traffic scale, sync vs. async processing | [Azure: choose a data store](https://learn.microsoft.com/azure/architecture/guide/technology-choices/data-store-decision-tree), [Azure: choose a compute service](https://learn.microsoft.com/azure/architecture/guide/technology-choices/compute-decision-tree), [AWS Decision Guides](https://docs.aws.amazon.com/decision-guides/) |
| Messaging and events | Queue or stream, ordering and duplicate guarantees, reprocessing | [Azure Technology choices](https://learn.microsoft.com/azure/architecture/guide/technology-choices/technology-choices-overview) (messaging) |
| Data pipeline | Latency requirements (batch for minutes or hours, stream for seconds or less), managed or self-operated, declarative or not | The batch and stream processing technology choices in the Azure data guide |
| Mobile | Native UI or shared UI, how deeply platform APIs are used, sharing code with the web team | No neutral official tree. Look at both the platform's official docs and the framework's official docs, and mark comparisons made by a framework's maker as material from an interested party |
| CLI | Distribution (single binary, package manager), startup speed, target OSes | No official tree |
| Library | Target ecosystem and package manager, runtime size, runtime versions to support, license | No official tree |
| Desktop | Native or web-technology based, install size, OS API access, auto-update | No official tree |

## 3. Factor table

For each decision, compare 2-3 candidates on the factors below. Leave out factors that do not apply. For factors that have signals, take the actual values from the survey.

| # | Factor | What to look at | Signals and sources |
| --- | --- | --- | --- |
| 1 | Requirements and quality goals | Does this candidate meet this app's quality goals (in ranked order)? | Official docs, decision trees |
| 2 | Skills | Does the user or team already know it? If not, the cost of learning it | The user's answers, existing code |
| 3 | Ecosystem maturity | Who uses it, release cadence, surrounding libraries | Registry downloads, GitHub releases, [Thoughtworks Radar](https://www.thoughtworks.com/radar) ring, [CNCF stage](https://contribute.cncf.io/projects/lifecycle/), surveys (with year) |
| 4 | Support lifetime | End-of-support date of the current version, LTS | [endoflife.date](https://endoflife.date/) API |
| 5 | Security | Security practices, known vulnerabilities, response speed | [OpenSSF Scorecard](https://scorecard.dev/), [deps.dev](https://deps.dev/) |
| 6 | Operational complexity and cost | The work of running and maintaining it, whether it is managed, pricing structure | Official docs and pricing pages |
| 7 | Lock-in and exit path | How tied it is to proprietary APIs, what would have to be rewritten to move | Official docs, standards compliance |
| 8 | License | Does it fit the project's license and commercial use? | deps.dev, the repository's LICENSE |
| 9 | AI tool familiarity | Is it mainstream, is it a major version released after the training cutoff? | The evidence below. The evidence is of medium strength, so weigh this lighter than 1-8 |

**Evidence for 9 [R, medium]:**
- Code generation performance drops sharply in languages with little training data ([arXiv 2501.19085](https://arxiv.org/abs/2501.19085)).
- The same agent scores lower on multilingual SWE-bench than on Python alone ([SWE-bench Multilingual](https://www.swebench.com/multilingual)).
- LLMs use deprecated APIs 25-38% of the time ([arXiv 2406.09834](https://arxiv.org/abs/2406.09834)).
- Writing code that matches a specific version succeeds only about half the time ([arXiv 2507.12367](https://arxiv.org/abs/2507.12367)).

So if you pick a major version released after the training cutoff, also note that the official docs for that version should be easy to find from the project. This factor alone does not override the other factors.

## 4. Innovation tokens

Count the new or less proven technologies (things the team is using for the first time, Radar's Assess, CNCF Sandbox, pre-1.0, one or two contributors). If a project goes over 2-3, warn and propose what could be cut. Source: [Choose Boring Technology](https://mcfunley.com/choose-boring-technology). Criticism: [Against Innovation Tokens](https://blog.glyph.im/2024/07/against-innovation-tokens.html) — it points out that the real cost is the operational burden at the boundaries between technologies, so look at the number of boundaries along with the count.

## 5. Survey instructions (for architecture-researcher)

- For each decision: the decision name, the app type and quality goals, the existing stack, the candidates (if any), the factor numbers to look at.
- If there are no candidates, have it find 2-3 candidates from decision trees and official docs. Do not decide based on a single popularity-ranking article.
- What to get back for each candidate: the latest stable version and its date, the end-of-support date, the last release, download or usage metrics, the Scorecard score (if any), the license, known major problems, source URLs and the dates they were checked.

## 6. Display format

```markdown
#### Decision: primary database (one-way door)
| Factor | PostgreSQL 17 | MongoDB 8 |
| --- | --- | --- |
| Quality goal: consistency | Transactions, constraints — fits | Multi-document transactions possible, weak schema enforcement |
| Support lifetime | Until 2029-11 (endoflife.date, checked 2026-11-18) | … |
| … | … | … |

Recommendation: PostgreSQL 17 — one or two sentences on why. When to pick the alternative: …
```

For a one-way door, write an ADR (`references/docs.md`). For a two-way door (most libraries), write it as one line in the overview document's Stack table.
