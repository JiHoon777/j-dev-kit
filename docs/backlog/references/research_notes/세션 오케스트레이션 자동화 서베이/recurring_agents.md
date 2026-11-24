# Recurring / continuously-running agents that feed a software backlog (as of 2026-11-20)

Scope: agents that run on a schedule or on events to *propose or prepare* work (reports, issues, backlog items, draft PRs), not only execute assigned tasks. Covers GitHub Next Continuous AI / gh-aw, company examples, product-idea agents, backlog-management agents, cadence/cost/failure modes.

Source-quality legend: [primary] = vendor/company's own page; [self-reported] = numbers reported by the builder; [secondary] = trade press or third-party write-up; [unverified] = only from search snippets or mirrors.

## 1. GitHub Next "Continuous AI" and GitHub Agentic Workflows (gh-aw): mechanics and safe-output design

### Takeaway
gh-aw is the most fully documented recurring-agent design: a Markdown file with YAML frontmatter, compiled into a GitHub Actions lock file, where the agent runs read-only and every write goes through a separate, capped, permission-scoped "safe output" job. Recurring reports avoid piling up through built-in dedup, expiry, close-older and group-by-day options. Humans stay in the loop because PRs are never auto-merged. The team self-reports merge rates of roughly 50 to 78% for agent-proposed PRs in its own repo.

### Cited Findings
**Positioning and status**
- "Continuous AI" is GitHub Next's umbrella term for an open-ended category of activities, workloads, recipes and capabilities, not a single tool. GitHub Next says these workflows are not fully autonomous and keep human oversight and control. — [GitHub Next: Continuous AI](https://githubnext.com/projects/continuous-ai/) [primary; seen via search snippet]
- gh-aw went into technical preview with a GitHub Blog post on 2026-02-13 by Don Syme (GitHub Next) and Peli de Halleux (Microsoft Research). It is described as "designed to augment existing CI/CD rather than replace it." — [GitHub Blog, Automate repository tasks with GitHub Agentic Workflows](https://github.blog/news-insights/product-news/automate-repository-tasks-with-github-agentic-workflows/) [primary]
- An older README mirror calls gh-aw a "research demonstrator… not for production use." This probably predates the technical-preview launch. — [pkg.go.dev gh-aw v0.1.2](https://pkg.go.dev/github.com/githubnext/gh-aw@v0.1.2) [unverified, older]

**Mechanics**
- A workflow is a `.md` file. Its frontmatter sets the trigger, permissions, tools and safe outputs, and natural-language instructions follow. `gh aw compile` generates a `.lock.yml` that GitHub Actions runs. Supported engines are Copilot CLI, Claude Code and OpenAI Codex. Triggers include schedules (the example uses `on: schedule: daily`) and manual dispatch. — [GitHub Blog](https://github.blog/news-insights/product-news/automate-repository-tasks-with-github-agentic-workflows/) [primary]
- Workflows are read-only by default. Writes go through safe outputs, which are pre-approved, reviewable operations such as creating a PR or adding a comment. The run is sandboxed, with tool allowlisting and network isolation. "Pull requests are never merged automatically"; humans must review and approve them. — [GitHub Blog](https://github.blog/news-insights/product-news/automate-repository-tasks-with-github-agentic-workflows/) [primary]
- Cost: with default Copilot settings, a run typically uses 2 premium requests, one for the agentic work and one for the safe-outputs guardrail check. Models can be configured to manage cost. — [GitHub Blog](https://github.blog/news-insights/product-news/automate-repository-tasks-with-github-agentic-workflows/) [primary]
- Rollout guidance: start with low-risk outputs (comments, drafts, reports) before enabling PR creation, define what "good" looks like and when to stop, and treat workflow Markdown as code. — [GitHub Blog](https://github.blog/news-insights/product-news/automate-repository-tasks-with-github-agentic-workflows/) [primary]
- Example daily repo status report: it creates an issue with a `[repo status]` title prefix and a `report` label. The 2026-02-09 sample summarises 1,737 commits, 100 issues closed / 190 opened, and 50 of 93 PRs merged. — [GitHub Blog](https://github.blog/news-insights/product-news/automate-repository-tasks-with-github-agentic-workflows/) [primary]

**Safe-output design (dedup and noise controls)**
- The agent requests actions as structured output and holds no write permissions. A "separate permission-controlled job" with, for example, `issues: write` carries out the requests. This allows validation, auditing and per-operation limits. — [gh-aw Safe Outputs reference](https://github.github.com/gh-aw/reference/safe-outputs/) [primary]
- `create-issue` defaults to `max: 1`. Its options include `title-prefix`, `labels`, `expires` (e.g. `7d`, `2w`), `group` (parent issue with up to 64 sub-issues), `close-older-issues` (closes up to 10 earlier open issues from the same workflow as "not planned" and links to the new one, only after the new issue is created), `group-by-day` (same-day runs become comments on one issue, by UTC date, without using a `max` slot), and `deduplicate-by-title` (`true` for an exact match, or an integer 0–100 for Levenshtein distance), ANDed with `deduplicate-by-labels`. — [Safe Outputs reference](https://github.github.com/gh-aw/reference/safe-outputs/) [primary]
- `expires` auto-generates an `agentics-maintenance.yml` workflow. It runs every 2 hours up to daily, depending on the shortest expiry, and closes stale agent issues. — [Safe Outputs reference](https://github.github.com/gh-aw/reference/safe-outputs/) [primary]
- Other controls: `add-comment` supports `hide-older-comments` and `replace-older-comments`. `add-labels` has `allowed`/`blocked` lists (blocked is checked first) and `create-if-missing: false` by default. `close-issue` can require `required-labels` or `required-title-prefix`. `noop`, `report-missing-tool` and `report-missing-data` are always available, so an agent can report "nothing to do" without inventing work. Staged mode previews outputs with no API side effects. — [Safe Outputs reference](https://github.github.com/gh-aw/reference/safe-outputs/) [primary]
- I did not read the draft-PR, PR-protection and threat-detection sections of the Safe Outputs page; the fetch was truncated at 100k of 205k characters. — [Safe Outputs reference](https://github.github.com/gh-aw/reference/safe-outputs/)

**Sample workflow catalogue (githubnext/agentics)**
- Scheduled samples include Daily Repo Status, Daily Team Status, Daily Plan (updates planning issues), Daily Test Improver, Daily Perf Improver, Daily Efficiency Improver, Daily Documentation Updater, Daily Accessibility Review, Daily Adhoc QA, Daily Malicious Code Scan, Link Checker, Repository Quality Improver (daily rotating focus), Weekly Research, Weekly Issue Activity, and Weekly Repository Map. Issue Monster assigns `cookie`-labelled issues to the Copilot coding agent every 30 minutes. — [githubnext/agentics](https://github.com/githubnext/agentics) [primary]
- Backlog and grooming samples: Issue Triage ("labels issues and PRs and not much more"), Repo Assist (a "multi-task backlog burner" that triages, investigates, comments and fixes), Issue Arborist (links related issues as sub-issues), Sub-Issue Closer, Discussion Task Miner (turns Discussions into issues), and `/plan` (breaks an issue into sub-tasks). Analysis-only workflows such as Large File Simplifier, Contribution Check, CI Doctor and Cost Tracker change no code; their reports are meant to become issues through `/plan`. — [githubnext/agentics](https://github.com/githubnext/agentics) [primary]
- Multi-phase improvers (2026-01-13): Daily Perf Improver works in three phases (research bottlenecks, set up profiling, implement optimisations). Daily Backlog Burner handles one issue per day. These workflows "maintain state across days using repo-memory." — [gh-aw blog, Multi-Phase Improvers](https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-multi-phase/) [primary]

**Peli's Agent Factory: results and lessons (Jan–Mar 2026)**
- The team built and runs "over 100" agentic workflows in github/gh-aw, some also applied to GitHub-internal repos. Lessons: specialised agents beat one monolithic agent; strict guardrails make experiments safe; meta-agents that watch other agents are "incredibly valuable"; cost-quality tradeoffs are real and longer analyses are not always better. Also: "No one can read all these outputs (except, of course, another workflow)." — [Welcome to Peli's Agent Factory, 2026-01-12](https://github.github.com/gh-aw/blog/2026-01-12-welcome-to-pelis-agent-factory/) [primary]
- The dominant pattern is a report-to-issue-to-PR chain. Repository Quality Improver (new focus area daily, about 20 minutes of analysis per run, focus split 60% repo-specific / 30% standard / 10% revisits, cache memory of recent history) produced 59 discussions, 30 issues and 40 PRs, of which 25 were merged (62%). Typist: 57 discussions, 22 issues, 25 PRs, 19 merged (76%); it only analyses, and a human runs `/plan` before issues exist. Go Module Usage Expert (daily, prioritises recently updated modules then round-robin, cache-memory to avoid repeat reviews): 58 of 74 PRs merged (78%). Functional Pragmatist (Tue/Thu mornings, direct PRs): 2 of 2 merged. — [Meet the Workflows: Continuous Improvement, 2026-01-13](https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-continuous-improvement/) [primary, self-reported]
- More self-reported merge rates from the series: Plan Command 514 of 761 (67%), Discussion Task Miner 60 of 105 (57%), Changeset Generator 22 of 28 (78%), CLI Consistency Checker 80 of 102 (78%), CI Doctor 9 of 13 (69%), CI Coach 9 of 9. — [gh-aw blog index](https://github.github.com/gh-aw/blog/) [self-reported; figures came from search snippets, and CI Doctor's from a mirror, so unverified individually]
- Issue Arborist: 77 discussion reports, 18 parent issues. Issue Monster assigns issues to Copilot "one at a time" so parallel agents don't collide on the codebase. — [Meet the Workflows: Issue & PR Management](https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-issue-management/) [primary, self-reported]
- A secondary article says humans merged 79% of PRs from GitHub's refactoring agents. — [hyrax.dev, 2026-07-06](https://hyrax.dev/blog/github-agents-refactor-code-humans-merged-79-percent) [secondary, unverified]

### Inferences
- gh-aw's answer to noise is structural, not prompt-based: hard caps (`max: 1`), a title-prefix plus label identity per workflow, close-older/expire/group-by-day so only one live report exists, dedup by title distance, and an explicit `noop`. A scheduled agent that can only create one issue, and closes its previous one, cannot spam.
- Recurring analysis agents mostly write Discussions or reports. A human (or `/plan`) promotes the useful ones into issues, and only then do PR-producing agents act. Approval happens at the promotion step and at PR review.
- Merge rates (about 57–78%) are measured on the authors' own repo by the authors; expect lower in repos without that tuning.

### Gaps
- No published dollar cost per run beyond "2 premium requests"; no data on how many reports are ignored or closed unread.
- I did not read the threat-detection and PR-protection details of the safe-outputs reference (page truncated).
- Failure modes are described only vaguely ("fail in instructive ways").

## 2. Company examples (Spotify, Stripe, Google, Dependabot-style agents, others)

### Takeaway
At company scale, recurring agents are mostly fleet-maintenance engines: a scheduler or targeter selects repos and change types, and the agent prepares PRs. Spotify's Fleet Management/Honk is the main example. Stripe's proactive piece is narrower: CI files flaky-test tickets that offer a one-click minion run. GitHub productised "assign this Dependabot alert to an agent" (draft PR) in April 2026. I found no primary 2026 write-ups from Shopify, Uber, Airbnb or Meta on scheduled backlog-feeding agents.

### Cited Findings
**Spotify (Fleet Management + Honk)**
- Honk came out of Fleet Management, which Spotify has built since 2022 for fleet-wide automated changes such as dependency bumps. By Nov 2025, Honk had produced 1,500+ merged AI-generated PRs. — [Spotify Engineering, Honk Part 1 (Nov 2025)](https://engineering.atspotify.com/2025/11/spotifys-background-coding-agent-part-1) [primary, self-reported; numbers via search snippet]
- Fleetshift does target selection, scheduling and progress tracking. Honk (Claude via the Agent SDK in Kubernetes pods) makes the changes and can run CI builds. Fleet Management has merged more than 2.5 million automated maintenance PRs, most auto-merged after safety checks. Monthly merged changes rose from about 8,100 to 17,000 year over year (as of Aug 2026), across nearly 3,000 production services. — [InfoQ, 2026-10-12](https://www.infoq.com/news/2026/10/spotify-ai-quality-controls) [secondary, reporting Spotify figures]
- Failure modes: an automated dependency upgrade passed checks but failed in production. In a 2026-06-24 incident, Spotify found change volume had "outpaced some verification controls" (no material direct AI-code contribution). The response was stronger safeguards, more rollback capacity, end-to-end monitoring, and **scheduling automated changes during owning teams' working hours**. Quality/optimisation work rose from 27% to 31% of merged changes, with no reported increase in rework, though PR size and complexity are rising. — [InfoQ, 2026-10-12](https://www.infoq.com/news/2026/10/spotify-ai-quality-controls) [secondary]
- Honk Part 4 (Apr 2026) covers downstream dataset migrations. — [Spotify Engineering, Honk Part 4](https://engineering.atspotify.com/2026/4/background-coding-agents-dataset-migrations-honk-part-4) [primary; not read in full]

**Stripe (Minions)**
- Post dated 2026-02-09: "over a thousand pull requests merged each week" are fully minion-produced. Most runs start from Slack. When CI detects a flaky test, it creates an automated ticket with a button to launch a minion to fix it. Every PR gets human review. Minions get "often one, at most two" CI rounds. The post describes no scheduled runs. — [Stripe, Minions Part 1](https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents) [primary, self-reported]
- Secondary write-ups cite about 1,300 PRs/week. — [ByteByteGo](https://blog.bytebytego.com/p/how-stripes-minions-ship-1300-prs) [secondary]

**Google**
- "Migrating Code At Scale With LLMs At Google" (arXiv Apr 2025, FSE 2025): the pipeline finds code to change, has an LLM generate edits, validates, and sends changes to developers for review. Across 39 migrations, 595 code changes, 74.45% of changes were LLM-generated, and developers estimated about 50% time saved. This is a 2025 source; I found no 2026 Google paper on scheduled code-health agents. — [arXiv 2504.09691](https://arxiv.org/abs/2504.09691v1) [primary]

**Others**
- DoorDash: a multi-agent feature-flag cleanup system (ICSME 2026) designed so that failure yields an unmerged or incomplete cleanup, not a breaking change. — [ZenML LLMOps DB](https://www.zenml.io/llmops-database/multi-agent-automation-for-feature-flag-cleanup) [secondary]
- GitHub (2026-04-07): Dependabot alerts can be assigned to coding agents (Copilot, Claude, Codex). The agent opens a **draft** PR and can investigate build or test breakage caused by the update. Several agents can work the same alert independently. Requires GitHub Code Security plus Copilot coding agent. — [GitHub Changelog](https://github.blog/changelog/2026-04-07-dependabot-alerts-are-now-assignable-to-ai-agents-for-remediation) [primary]
- Cursor Automations (2026-03-05): agents triggered by schedules (cron), Slack messages, new Linear issues, merged PRs, PagerDuty incidents or webhooks, with a memory tool to "learn from past runs." Examples: a morning test-coverage agent that opens PRs; a weekly Slack digest of repo changes; a bug-triage agent that checks Slack bug reports for duplicates, files a Linear issue and investigates; a security review on push to main that skips issues already discussed. Rippling runs a cron agent every two hours that dedups across sources. "Agentic codeowners" auto-approves low-risk PRs and assigns up to two reviewers to riskier ones, with decisions logged for tuning. — [Cursor blog, Build agents that run automatically](https://cursor.com/blog/automations) [primary, vendor]

### Inferences
- In practice, "who decides what to work on" is a deterministic layer (Fleetshift targeting, CI flake detection, Dependabot alerts) and the agent only prepares the fix. Fully open-ended "find work" agents at companies are less documented than trigger-plus-agent setups.
- Spotify's working-hours scheduling is a concrete cadence lesson: run automated changes when the owning team is around to absorb failures.

### Gaps
- No primary 2026 write-ups found for Shopify, Uber, Airbnb or Meta on recurring backlog agents (not searched exhaustively).
- No cost-per-run data from Spotify or Stripe.
- Renovate-style agent variants beyond GitHub's Dependabot integration were not researched.

## 3. Agents that generate product/feature ideas or roadmap proposals from feedback, support and analytics

### Takeaway
The best primary example is Langfuse's weekly digest skill (Mar 2026). It pulls support tickets, GitHub issues and meeting transcripts, clusters and dedups them across sources, cites every item, groups items by "clear next step" versus "needs discussion," and was tuned with LLM-as-judge evals. Most other material is vendor marketing for scheduled feedback-to-PRD/backlog agents.

### Cited Findings
- Langfuse (2026-03-13): a weekly run covered 481 support tickets (Plain), 53 open and 14 recently closed GitHub issues, and 38 meeting transcripts (Circleback). Each source has a fetch script, and SKILL.md holds the processing rules. Each topic gets severity/category, what users experience, evidence, who is affected, and source links. Related items across sources (e.g., a ticket and an issue about the same bug) merge into one entry. — [Langfuse blog](https://langfuse.com/blog/2026-03-13-weekly-digest-ai-skill) [primary]
- How Langfuse kept it useful: LLM-as-judge scores for actionability, source citation and category count each run; humans commented on traces and another agent updated SKILL.md, about 10 minutes per cycle over 9 iterations. Source attribution reached 1.0 after run 4, and categories settled at about 3–5. Output was regrouped by "next step clear vs. needs discussion" instead of product area. — [Langfuse blog](https://langfuse.com/blog/2026-03-13-weekly-digest-ai-skill) [primary, self-reported]
- Failure modes Langfuse hit: silent data loss when a source was down (skipped without saying so); generic instead of record-specific links; a stale six-month-old issue flagged as current because of a recent comment; an assumption-laden "Quick Fixes" label; a prompt change that made descriptions vague in run 7, caught by the evaluator. — [Langfuse blog](https://langfuse.com/blog/2026-03-13-weekly-digest-ai-skill) [primary]
- Vendor patterns (marketing, from search snippets only): Gamut template that pulls tickets and CRM notes on a schedule into a weekly digest with PRD stubs and files feature requests to Jira/Linear ([Gamut](https://www.gamut.so/agent-templates/product-engineering/product-feedback-roadmap)); Replit workflow that posts to Slack when a new theme appears or volume jumps ([Replit docs](https://docs.replit.com/use-cases/analyze-customer-feedback.md)); Kortix spec outputs linked back to source tickets ([Kortix](https://kortix.com/solutions/product)); Linear also has a "Product Intelligence" doc page ([Linear docs](https://linear.app/docs/product-intelligence), not read). [vendor, unverified]

### Inferences
- What keeps feedback agents useful: (1) mandatory links to the underlying records, (2) cross-source clustering, (3) a fixed small number of categories, (4) grouping by actionability rather than area, (5) per-run eval scores, and (6) explicit reporting of missing sources (compare gh-aw's `report-missing-data`).
- These agents output digests or reports for a human PM to promote, not backlog items written directly.

### Gaps
- No primary source found for competitor-scan or analytics-driven roadmap agents with reported outcomes.
- No data on whether recommendations from such digests get adopted.

## 4. Backlog-management agents: dedup, sizing, prioritisation, keeping a tracker clean

### Takeaway
Tracker vendors ship triage *suggestions* (team, assignee, labels, duplicate/related links) with per-property choices of show, hide or auto-apply. Repo-native setups (gh-aw) add grooming workflows: sub-issue linking, auto-closing parents, mining discussions into issues, and expiring stale agent issues. Evidence for automatic sizing or prioritisation is thin and mostly community or consultancy material.

### Cited Findings
- Linear Triage Intelligence (Business/Enterprise only): uses LLMs ("agentic models") on issues entering Triage to suggest team, project, assignee and labels from history, and suggests duplicate or related relations when semantic similarity is strong. For each property type, teams choose show, hide or auto-apply, optionally limited to specific values and inherited by sub-teams. Users accept or dismiss and can see the reasoning. Team or workspace guidance refines suggestions, and the most local guidance wins; Linear advises adding guidance reactively when wrong suggestions persist. Processing takes about 1–4 minutes per issue, a deliberate quality tradeoff. — [Linear docs: Triage Intelligence](https://linear.app/docs/triage-intelligence) [primary]
- Sources disagree on Linear AI plan gating (Linear Agent on all plans vs. Business/Enterprise only). — [BuildBetter guide](https://blog.buildbetter.ai/linear-ai-agents-2026-guide-5-alternatives-for-engineering-teams/); [Sentra](https://www.sentra.app/articles/linear-ai) [secondary, conflicting]
- Jira/Rovo: Atlassian lists "detect potential duplicates as you create work items." — [Atlassian support: Rovo AI features in Jira](https://support.atlassian.com/organization-administration/docs/atlassian-intelligence-features-in-jira-software) [primary, page garbled]. A consultancy guide gives an example of a custom Rovo agent that flags duplicate tickets, missing details and label-convention violations. — [Seibert Rovo agents guide (PDF)](https://us.seibert.group/pdfs/rovo-agents-guide.pdf) [secondary]. Community advice: scope the agent to one project and require structured output (duplicate links, component, priority, one-line summary). One user could not measure time saved versus saved filters. — [Atlassian Community](https://community.atlassian.com/forums/Rovo-questions/How-are-you-using-Rovo-in-Jira-Software-to-actually-reduce/qaq-p/3252774) [community]. A community post reports a Rovo agent "unable to reliably remove duplicate entries." — [Atlassian Community](https://community.atlassian.com/forums/Rovo-questions/Rovo-Agent-Unable-to-Reliably-Remove-Duplicate-Entries-in/qaq-p/3189852) [community; title only]
- gh-aw AI issue triage sample: runs on new issues, classifies them, sets priority labels and flags likely duplicates, staying read-only during analysis while writes go through safe outputs. — [gh-aw gallery: AI issue triage](https://github.github.com/gh-aw/gallery/ai-issue-triage/) [primary; via search snippet]
- gh-aw grooming: Issue Arborist (sub-issue linking), Sub-Issue Closer, Discussion Task Miner (57% merge rate on resulting PRs), `/plan` (67%), and `expires` plus the auto-generated maintenance workflow to close stale agent issues. — see Section 1 sources: [agentics](https://github.com/githubnext/agentics), [Safe Outputs](https://github.github.com/gh-aw/reference/safe-outputs/)

### Inferences
- Common design: suggestions by default, auto-apply only for properties where history shows the model is reliable, and guidance files to correct systematic errors. Duplicate handling is a "suggest relation" step, not auto-closing.

### Gaps
- Task Master, GitHub Copilot's own issue-triage features, and Rovo's official agent docs were not researched in depth (budget).
- No accuracy metrics published for Linear's or Atlassian's duplicate or label suggestions.
- No sources found on automated effort estimation or sizing with reported results.

## 5. Cadence, cost per run, and reported failure modes

### Takeaway
Typical cadences are event-driven for triage, every 30 minutes to 2 hours for dispatchers or monitors, daily for status and improvement agents (often rotating focus areas with memory), and weekly for digests and trend reports. Published cost data is minimal. Failure modes are well documented at ecosystem level: noise and spam, stale proposals, silent gaps, and change volume outrunning verification.

### Cited Findings
**Cadence**
- gh-aw samples: Issue Monster every 30 min; many "Daily …" improvers; Weekly Research, Weekly Issue Activity, Weekly Repository Map; Functional Pragmatist Tue/Thu mornings; the `expires` maintenance job every 2h up to daily. — [agentics](https://github.com/githubnext/agentics); [Continuous Improvement post](https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-continuous-improvement/); [Safe Outputs](https://github.github.com/gh-aw/reference/safe-outputs/) [primary]
- Cursor: test-coverage agent every morning; weekly digest; Rippling cron every two hours. — [Cursor blog](https://cursor.com/blog/automations) [primary]
- Langfuse: weekly feedback digest. — [Langfuse](https://langfuse.com/blog/2026-03-13-weekly-digest-ai-skill) [primary]
- Spotify: automated changes scheduled during owning teams' working hours after an incident. — [InfoQ](https://www.infoq.com/news/2026/10/spotify-ai-quality-controls) [secondary]

**Cost**
- gh-aw: about 2 Copilot premium requests per run by default. — [GitHub Blog](https://github.blog/news-insights/product-news/automate-repository-tasks-with-github-agentic-workflows/) [primary]
- Repository Quality Improver: about 20 minutes of analysis per run. "Longer analyses aren't always better." A Cost Tracker sample posts per-run agent spend on PRs. — [Continuous Improvement post](https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-continuous-improvement/); [Peli's Agent Factory](https://github.github.com/gh-aw/blog/2026-01-12-welcome-to-pelis-agent-factory/); [agentics](https://github.com/githubnext/agentics) [primary]

**Failure modes**
- Output volume: "No one can read all these outputs (except… another workflow)", so the team uses meta-agents. — [Peli's Agent Factory](https://github.github.com/gh-aw/blog/2026-01-12-welcome-to-pelis-agent-factory/) [primary]
- Ecosystem spam: curl received 20 AI-generated security reports in the first 21 days of 2026, none valid, and ended its 6-year bug bounty. Jazzband shut down, citing AI spam PRs and issues. An Airflow committer said real users' issues were closed as spam by mistake. — [The New Stack](https://thenewstack.io/ai-generated-code-crisis/); [Axios, 2026-03-10](https://axios.com/2026/03/10/ai-agents-spam-the-volunteers-securing-open-source-software); [InfoQ, 2026-02](https://infoq.com/news/2026/02/ai-floods-close-projects) [secondary; details came from search snippets, so treat as unverified individually]
- Stale and silent errors: stale issues resurfaced as current, a source outage silently skipped, wrong links, vague regressions. — [Langfuse](https://langfuse.com/blog/2026-03-13-weekly-digest-ai-skill) [primary]
- Verification lag: a dependency upgrade that passed checks failed in production; change volume outpaced verification controls. — [InfoQ on Spotify](https://www.infoq.com/news/2026/10/spotify-ai-quality-controls) [secondary]
- Unmerged work: in gh-aw's own repo, about 22–43% of agent-proposed PRs went unmerged per workflow (from the self-reported 57–78% merge rates). — [Continuous Improvement post](https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-continuous-improvement/) [self-reported]

### Inferences
- Common countermeasures: cap outputs per run; keep one rolling report per workflow (close-older, group-by-day, replace-older-comments); expire unpromoted proposals; rotate focus areas with memory so runs don't repeat; allow "nothing to do"; require citations; put a human promotion gate between report and issue/PR; run during owners' working hours.
- Humans ignoring reports is acknowledged only indirectly (meta-agents, analysis to `/plan` promotion). No one publishes read rates for reports.

### Gaps
- No public dollar cost per run or per month from any company.
- No quantitative data on human read or adoption rates of scheduled reports, or on stale-proposal rates.
