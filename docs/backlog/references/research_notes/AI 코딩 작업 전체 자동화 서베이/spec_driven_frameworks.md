# Spec-driven / plan-driven workflow frameworks for AI coding agents (as of 2026-11-20)

Research note conventions: "(page, 2026-11)" means read from the live primary page during this research. Items marked **UNVERIFIED** come from the researcher's prior knowledge (pre-2026-06) or secondary sources only. Primary pages often did not render full docs, so several details are listed under Gaps.

## Q1. Stages, artifacts, gates, task sizing, review, autonomy per framework

### Takeaway
Every major framework runs some version of: clarify intent → written spec/design → plan → small tasks → implement (often in fresh subagent contexts) → verify/review → close/archive. They differ mainly in (a) how many intermediate markdown artifacts they produce, (b) where the human must approve, and (c) whether execution of the task list can run unattended. By late 2026 most have added a "small change / quick" bypass and a loop/autonomous executor.

### Cited Findings

**Adoption snapshot (GitHub stars)**
- Repo pages read 2026-11: obra/superpowers ~322k stars, 28.6k forks — [superpowers repo](https://github.com/obra/superpowers); github/spec-kit ~150.7k stars, 13.5k forks — [spec-kit repo](https://github.com/github/spec-kit); bmad-code-org/BMAD-METHOD 55.6k stars — [BMAD repo](https://github.com/bmad-code-org/BMAD-METHOD); gsd-build/get-shit-done 64.1k stars (archived) — [GSD repo](https://github.com/gsd-build/get-shit-done); open-gsd/gsd-core ~11.7k stars — [GSD Core](https://github.com/open-gsd/gsd-core); eyaltoledano/claude-task-master ~28.4k stars — [Task Master repo](https://github.com/eyaltoledano/claude-task-master).
- Snapshot of 2026-09-26: Superpowers 291.7k, Spec Kit 138.9k, OpenSpec 70.4k, BMAD 53.5k, cc-sdd 3.7k; the page warns "Stars measure attention, not usage." — [developertoolkit.ai comparison](https://developertoolkit.ai/en/ecosystem/frameworks/spec-driven-frameworks/). (Consistent with the Nov repo numbers; growth Sep→Nov.)
- Other named patterns: PRPs (13.9k stars, `/generate-prp` → `/execute-prp`), HumanLayer RPI ("research, plan, implement", described as "pretty much all deprecated"), RIPER-5, spec-workflow-mcp (4.3k stars, last release 2026-03-02), Spec Kitty (Spec Kit fork with worktrees) — [developertoolkit.ai](https://developertoolkit.ai/en/ecosystem/frameworks/spec-driven-frameworks/). Kiro-shaped clone for other agents: cc-sdd (gotalab), EARS `requirements.md`/`design.md`/`tasks.md`, gated phases, `kiro-impl` gives each task a fresh implementer plus an independent reviewer — same source.

**GitHub Spec Kit**
- Core commands, in order: `/speckit-constitution` (once per project) → `/speckit-specify` → `/speckit-plan` → `/speckit-tasks` → `/speckit-implement` → `/speckit-converge`, repeating implement/converge until it reports "Converged" — [spec-kit README](https://github.com/github/spec-kit). Clarify, checklist and analyze are described in the SDD walkthrough, not listed as core stages on the README — same source. A secondary source lists the full chain as constitution, specify, clarify, plan, tasks, analyze, implement, converge, "a person drives each stage" — [developertoolkit.ai](https://developertoolkit.ai/en/ecosystem/frameworks/spec-driven-frameworks/).
- Gate model: "run each skill one at a time and review each result before continuing" — [spec-kit README](https://github.com/github/spec-kit).
- Artifacts: `memory/constitution.md`; per feature in `specs/[branch-name]/`: `spec.md` (what/why, no implementation detail), `plan.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md` (validation scenarios), `tasks.md` — [spec-driven.md](https://github.com/github/spec-kit/blob/main/spec-driven.md).
- Ambiguity handling: templates require `[NEEDS CLARIFICATION: question]` markers instead of guessing; completeness checklist requires none remain — [spec-driven.md](https://github.com/github/spec-kit/blob/main/spec-driven.md).
- Built-in "Phase -1 gates" in plan: Simplicity (≤3 projects, no future-proofing), Anti-Abstraction, Integration-First (contracts + contract tests); failures must be justified in a "Complexity Tracking" section — [spec-driven.md](https://github.com/github/spec-kit/blob/main/spec-driven.md).
- Constitution Article III "Test-First Imperative": tests written, approved, failing before implementation, "NON-NEGOTIABLE" — [spec-driven.md](https://github.com/github/spec-kit/blob/main/spec-driven.md).
- Task sizing/parallelism: `/speckit.tasks` marks independent tasks `[P]` and outlines safe parallel groups — [spec-driven.md](https://github.com/github/spec-kit/blob/main/spec-driven.md).
- Philosophy: "Specifications don't serve code—code serves specifications" — [spec-driven.md](https://github.com/github/spec-kit/blob/main/spec-driven.md).
- 2026 changes: Spec Kit 1.0 (video Oct 16, 2026), extensions (bug-fix extension → `.specify/bugs/<slug>/` with verdict `verified`/`partial`/`failed`; idea-assessment extension → `.specify/assessments/<slug>/decision.md` with `go`/`needs-clarification`/`kill`), presets, hooks and runtime events, workflows with custom steps, bundles, catalogs; Oct 15 blog on "living, capability-level specs" — [spec-kit README](https://github.com/github/spec-kit).

**AWS Kiro**
- Three phases per spec: Requirements (feature) or Bug analysis (bugfix) → Design (architecture, sequence diagrams, data flow, error handling, testing strategy) → Tasks; files `requirements.md` (or `bugfix.md`), `design.md`, `tasks.md` — [Kiro specs docs](https://kiro.dev/docs/specs/).
- Variants: Feature specs support Requirements-First and Design-First; Bugfix specs (root cause, fix, regression checks); **Quick Spec** generates all three artifacts in one pass "without approval gates" — [Kiro specs docs](https://kiro.dev/docs/specs/). (Implies standard specs have approval gates between phases.)
- Execution: run tasks one by one or all at once; "Run all" builds a dependency graph, groups tasks into waves; "Waves execute sequentially; tasks within a wave execute concurrently" (IDE, CLI, Web, Mobile) — [Kiro specs docs](https://kiro.dev/docs/specs/).
- Verification aids: Analyze Requirements (inconsistencies/gaps before design), Correctness = property-based testing (IDE), Markdown Review (inline comments on spec docs sent back to the agent) — [Kiro specs docs](https://kiro.dev/docs/specs/).
- Hooks: JSON in `.kiro/hooks/` (global `~/.kiro/hooks/` in CLI V3); triggers include `PostFileSave`, `Stop`, `PreToolUse`, `PostToolUse`; actions are shell Command (60s default timeout, session context on STDIN) or Agent prompt; examples: ESLint --fix after edits, generate tests/docs for new files, gate dangerous ops, validate before commit — [Kiro hooks docs](https://kiro.dev/docs/hooks/).
- Steering files (memory bank): `product.md`, `tech.md`, `structure.md`; acceptance criteria as user stories with GIVEN/WHEN/THEN — [Böckeler, martinfowler.com](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html).
- **UNVERIFIED**: EARS notation for requirements and Autopilot vs Supervised modes (prior knowledge; not on the pages read). cc-sdd describes its requirements as EARS in Kiro's shape — [developertoolkit.ai](https://developertoolkit.ai/en/ecosystem/frameworks/spec-driven-frameworks/).

**BMAD Method**
- Versions: stable v6.12 (frozen except bug fixes, `npx bmad-method install`); v7 in preview alpha with breaking changes, release ETA mid-November 2026 — [BMAD repo](https://github.com/bmad-code-org/BMAD-METHOD).
- Current docs frame a delivery loop: Clarify → Plan → Build and verify → Learn and adjust (feeds back into Plan); routing by size: small changes straight to `bmad-build`, big clear ideas start at Plan, vague ideas at Clarify — [BMAD docs](https://docs.bmad-method.org/).
- Named personas as skills: Sofia the Product Owner (`bmad-agent-po`, sizes ideas, writes initiative/epic), John the PM (`bmad-agent-pm`, writes PRD); artifacts include initiatives, epics, PRDs and a "ticket" carrying the spec through the loop ("Ticket Tree") — [BMAD docs](https://docs.bmad-method.org/).
- Autonomy: separate "BMad Loop" module "Builds, verifies, and retros a whole epic unattended" — [BMAD repo](https://github.com/bmad-code-org/BMAD-METHOD).
- Secondary description: artifacts product brief, PRD, architecture, `SPEC.md`, epics and stories; persona hand-offs; `bmad-build` waits for your approval of a plan before writing code; two install tracks ship different skills — [developertoolkit.ai](https://developertoolkit.ai/en/ecosystem/frameworks/spec-driven-frameworks/).
- **UNVERIFIED** (v4–v6 era, prior knowledge): four phases Analysis → Planning → Solutioning → Implementation; scale tracks Quick Flow / BMad Method / Enterprise; personas Analyst, PM, Architect, UX, Scrum Master, Dev, QA/TEA; implementation-readiness check; story cycle sprint-planning → create-story → dev-story → code-review → retrospective with `sprint-status.yaml` and per-story files. The 2026 docs read here use different vocabulary (Clarify/Plan/Build/Learn, tickets), suggesting a v7 reframe.

**obra/superpowers**
- Skill chain: brainstorming (Socratic questions, plays back understanding) → using-git-worktrees (after design approval; isolated branch, verifies clean test baseline) → writing-plans (tasks "2-5 minutes each" with exact file paths, complete code, verification steps) → subagent-driven-development (fresh subagent per task, review after each) or executing-plans (single session, one final review) → test-driven-development (RED-GREEN-REFACTOR; deletes code written before its tests) → requesting-code-review (between tasks, against plan, severity-ranked, critical issues block) → finishing-a-development-branch (verify tests, merge/PR/keep/discard, clean worktree) — [superpowers README](https://github.com/obra/superpowers).
- Gates: user signs off design (shown in readable chunks); user says "go" before subagent-driven development — [superpowers README](https://github.com/obra/superpowers).
- Two-stage review per task in subagent mode: spec compliance, then code quality — [superpowers README](https://github.com/obra/superpowers).
- Autonomy claim (anecdotal): "not uncommon" to work autonomously "for a couple hours at a time without deviating from the plan" — [superpowers README](https://github.com/obra/superpowers).
- Task classing: spike / bounded / architectural; design doc and plan only for architectural work; subagent-driven development costs ~11.8k tokens each time it fires — [developertoolkit.ai](https://developertoolkit.ai/en/ecosystem/frameworks/spec-driven-frameworks/) (secondary).
- Recent: many new harnesses (Antigravity, Devin CLI, Grok Build CLI, Kimi Code, Pi, Qwen Code, etc.), `diagnosing-superpowers` skill, telemetry opt-out `SUPERPOWERS_DISABLE_TELEMETRY`; new skill contributions generally not accepted — [superpowers README](https://github.com/obra/superpowers).

**Claude Task Master (task-master-ai)**
- Flow: PRD at `.taskmaster/docs/prd.txt` → `parse-prd` → `list`/`next`/`show`; MCP tools `analyze_project_complexity`, `expand_task`, `expand_all`, `set_task_status`; tags for workstreams; "Loop Command" under automation (details not shown) — [Task Master repo](https://github.com/eyaltoledano/claude-task-master).
- Task schema: id, title, description, status (pending/done/deferred…), dependencies, priority, details, **testStrategy**, subtasks — [Task Master docs](https://docs.task-master.dev/capabilities/task-structure).
- Sizing: `analyze-complexity` scores each task 1–10, recommends subtask counts and per-task expansion prompts, writes `scripts/task-complexity-report.json`; `expand --all` processes most complex first; `next` picks next task whose dependencies are satisfied — [Task Master docs](https://docs.task-master.dev/capabilities/task-structure).
- Editors: Cursor, Windsurf, VS Code, Amazon Q CLI, Claude Code (no API key for `claude-code/sonnet|opus`), Codex CLI, Roo, Lovable — [Task Master repo](https://github.com/eyaltoledano/claude-task-master).
- Note: Task Master is a task manager, not a full spec workflow — it has no design/spec stage and no built-in review stage beyond `testStrategy` (inference from the docs above).

**GSD ("Get Shit Done")**
- Original gsd-build/get-shit-done (TÂCHES) archived 2026-06-26, read-only; development moved to GSD Core — [GSD repo](https://github.com/gsd-build/get-shit-done).
- GSD Core v1.7.0 (`npx @opengsd/gsd-core@latest`; Claude Code, Codex, Copilot…): `/gsd-new-project` (greenfield), `/gsd-onboard` (existing code); per-milestone phase loop Discuss (capture implementation decisions) → Plan (research, decompose, check plan fits a fresh context window) → Execute (parallel waves, each executor in clean 200k-token context) → Verify (walk through what was built, diagnose and fix) → Ship (PR, archive phase); `STATE.md`, `CONTEXT.md` persist across sessions; explicit goal is countering "context rot" — [GSD Core](https://github.com/open-gsd/gsd-core).
- **UNVERIFIED** (prior knowledge / secondary): `.planning/` with PROJECT.md, REQUIREMENTS.md, ROADMAP.md, per-phase PLAN.md with ~2–3 XML-formatted tasks, SUMMARY.md, VERIFICATION.md/UAT; plan-checker and verifier agents; "yolo" vs interactive mode. Secondary claim of 58.9k stars — [Augment Code](https://www.augmentcode.com/learn/gsd-58k-stars-claude-code).

**Agent OS (Builder Methods)**
- v3 repositioned as a lightweight standards system: Install → Discover (extract patterns into documented standards) → Inject (load relevant standards into context) → Shape (enhanced shaping questions in plan mode to create specs aligned with standards); outputs are markdown in `agent-os/` — [Agent OS](https://buildermethods.com/agent-os).
- **UNVERIFIED**: earlier v2 had a full spec pipeline (plan-product, shape-spec, write-spec, create-tasks, implement-tasks, orchestrate-tasks) that v3 apparently dropped in favor of the host agent's native plan mode; page did not confirm this.

**OpenSpec (Fission AI)** — brownfield-first
- Per-change directory: `proposal.md`, spec deltas, `design.md`, `tasks.md`; flow Propose (writes all four) → review → apply (works through tasks.md) → archive (merges deltas into `openspec/specs/`) — [developertoolkit.ai](https://developertoolkit.ai/en/ecosystem/frameworks/spec-driven-frameworks/). Listed on Thoughtworks Radar — [Thoughtworks Radar: OpenSpec](https://www.thoughtworks.com/de-de/radar/tools/openspec) (not read in full).

**Tessl** — only tool explicitly aiming at spec-anchored / spec-as-source; code marked "GENERATED FROM SPEC - DO NOT EDIT", 1:1 spec→code file mapping (private beta at time of article) — [Böckeler](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html).

### Inferences
- Gate placement converges on two mandatory human checkpoints: approve the spec/design, approve the plan (or a "go" before execution). Per-task approval is optional and increasingly replaced by agent review (Superpowers' two-stage review, cc-sdd's independent reviewer, Spec Kit's converge loop).
- Task sizing is defined three ways: by time (Superpowers 2–5 min), by context budget (GSD: plan must fit a fresh window), by AI-scored complexity (Task Master 1–10). Spec Kit and Kiro size by dependency/parallelism (`[P]`, waves) rather than explicit size.
- Unattended execution exists at the "execute task list" level in nearly all (Kiro Run all, Spec Kit implement/converge, Superpowers SDD, GSD execute waves, BMad Loop, Task Master Loop); none of the primary pages claims unattended requirements/spec approval.

### Gaps
- BMAD v6/v7 exact phase names, story-file format, and BMad Loop mechanics: docs pages read did not render them.
- GSD Core full command list, plan sizing, yolo/autonomous mode: not on the README read (see `docs/COMMANDS.md`, `docs/CONFIGURATION.md` in the repo).
- Kiro Autopilot/Supervised modes and EARS: not confirmed on the 2026 pages read.
- Task Master "Loop Command"/autopilot TDD details: linked but not read.
- Agent OS v3 migration details ("What's New" page not read).
- Spec Kit `converge` semantics (what "Converged" checks) not documented on the README.

## Q2. Criticisms and evidence (spec bloat, small-task overhead, drift)

### Takeaway
The main qualitative critique (Böckeler/Thoughtworks) is over-ceremony for small tasks, markdown review burden, and agents ignoring the spec anyway; the only quantitative benchmark found (Uvik, Q4 2026, vendor-run) suggests specs help on medium/large and feature tickets but not on small tickets/bug fixes, with differences mostly inside the noise band.

### Cited Findings
- Böckeler's taxonomy: spec-first, spec-anchored, spec-as-source; almost all tools are spec-first with little maintenance strategy — [martinfowler.com](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html).
- Overhead: Kiro turned a small bug fix into 4 user stories with 16 acceptance criteria ("a sledgehammer to crack a nut"); Spec Kit overkill for a 3–5 point feature — [martinfowler.com](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html).
- Review burden: Spec Kit generates many repetitive markdown files; "I'd rather review code than all these markdown files" — [martinfowler.com](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html).
- Agents ignore specs: Spec Kit agent disregarded research notes about existing classes and created duplicates; elsewhere over-followed instructions; large contexts give a "false sense of control" — [martinfowler.com](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html).
- MDD analogy: LLM specs risk combining inflexibility and non-determinism; Spec Kit's per-branch specs suggest change-request lifetime, not living feature specs — [martinfowler.com](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html).
- Drift: Spec Kit per-feature folders can drift from the running system with no single current description; ceremony swamps small changes so teams bypass the process; OpenSpec `validate --strict` passed a malformed scenario; "A framework adds ceremony; it does not make a spec true" — [developertoolkit.ai](https://developertoolkit.ai/en/ecosystem/frameworks/spec-driven-frameworks/).
- Uvik SDD Benchmark 2026 (Paul Francis; run 2026-10-15, updated 2026-11-02): 50 brownfield Python tickets, Spec Kit 1.0 / Kiro / BMAD 6.x / OpenSpec / no-spec control, all claude-sonnet-5, blind senior review — [Uvik](https://uvik.net/spec-driven-development-benchmark/):
  - Merge rate: Spec Kit 80%, Kiro 82%, BMAD 82%, OpenSpec 84%, control 72%. Cost per merged ticket: $3.33 / $2.35 / $4.23 / $2.71 / $2.43. Median time to merge: 44 / 41 / 55 / 36 / 29 min. Spec phase median: 18 / 16 / 28 / 12 min. Spec drift: 12.5% / 4.9% / 12.2% / 2.4%. Defects per merged ticket: 0.57 / 0.39 / 0.49 / 0.40 / control 0.86.
  - By size: small (1–2 files) spec arms 80–85% vs control 85%; medium 80–85% vs 70%; large 80% vs 50%. Bug fixes: control 90% vs spec arms 80–90%.
  - Spec phase consumed 35.1% of tokens (BMAD 43.9%, OpenSpec 28.3%). Setup: OpenSpec 10 min, Kiro 12, Spec Kit 18, BMAD 28.
  - Specs scoring ≥6/8 on completeness merged 89.3% vs 60.0% for weaker specs.
  - Caveats stated by authors: overall gaps mostly within ±10-pt noise band; single team, Python only, one model; Kiro ran in its own IDE; did not measure long-lived specs.
- A process-taxonomy paper exists ("From Prompt to Process: a Process Taxonomy and Comparative…") — [alphaxiv 2606.04967](https://www.alphaxiv.org/abs/2606.04967.md) (not read; UNVERIFIED content).

### Inferences
- Evidence supports a size-adaptive rule: skip or minimize specs for small changes/bug fixes; use spec+plan for multi-file features. This matches the "quick" bypasses frameworks added (Kiro Quick Spec, BMAD small→`bmad-build`, Superpowers bounded tasks without spec).
- Spec quality (completeness) appears to matter more than which framework produced it.
- Uvik is a single consultancy's benchmark, not peer-reviewed; treat as directional.

### Gaps
- No independent replication of the Uvik numbers found. No data found on Superpowers or GSD in controlled comparisons.
- Did not locate a newer (2026) Böckeler/Thoughtworks follow-up article; the cited article's publication date was not captured (believed Oct 2025, UNVERIFIED).

## Q3. Common-denominator process

### Takeaway
Across all frameworks the shared skeleton is: (1) persistent project context/rules, (2) clarify intent with questions, (3) a written spec/design with acceptance criteria, approved by a human, (4) a plan decomposed into small, dependency-ordered, independently verifiable tasks, approved or "go", (5) execution task-by-task, increasingly in fresh subagent contexts and parallel waves, (6) verification per task (tests, TDD, agent review against spec) plus a final check, (7) close out: PR/merge, archive, update living docs.

### Cited Findings
- "Most frameworks follow the same arc: write a requirement, review it, plan, break it into tasks, implement, then archive or close," differing in where human review sits; tests derived from acceptance scenarios, not framework verdicts, prove the code — [developertoolkit.ai](https://developertoolkit.ai/en/ecosystem/frameworks/spec-driven-frameworks/).
- Persistent context layer: Spec Kit constitution — [spec-driven.md](https://github.com/github/spec-kit/blob/main/spec-driven.md); Kiro steering — [Böckeler](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html); Agent OS standards — [Agent OS](https://buildermethods.com/agent-os); GSD STATE.md/CONTEXT.md — [GSD Core](https://github.com/open-gsd/gsd-core).
- Clarification step: Spec Kit `[NEEDS CLARIFICATION]` — [spec-driven.md](https://github.com/github/spec-kit/blob/main/spec-driven.md); Superpowers brainstorming — [superpowers](https://github.com/obra/superpowers); GSD Discuss — [GSD Core](https://github.com/open-gsd/gsd-core); BMAD Clarify — [BMAD docs](https://docs.bmad-method.org/); Kiro Analyze Requirements — [Kiro specs](https://kiro.dev/docs/specs/).
- Fresh-context execution / parallel waves: Kiro waves — [Kiro specs](https://kiro.dev/docs/specs/); GSD clean 200k context per executor — [GSD Core](https://github.com/open-gsd/gsd-core); Superpowers fresh subagent per task — [superpowers](https://github.com/obra/superpowers); Spec Kit `[P]` — [spec-driven.md](https://github.com/github/spec-kit/blob/main/spec-driven.md).
- Test-first / verification: Spec Kit Article III — [spec-driven.md](https://github.com/github/spec-kit/blob/main/spec-driven.md); Superpowers TDD + two-stage review — [superpowers](https://github.com/obra/superpowers); Task Master `testStrategy` — [Task Master docs](https://docs.task-master.dev/capabilities/task-structure); Kiro property-based tests and hooks — [Kiro specs](https://kiro.dev/docs/specs/), [Kiro hooks](https://kiro.dev/docs/hooks/); GSD Verify — [GSD Core](https://github.com/open-gsd/gsd-core).
- Size routing: Kiro Quick Spec (no gates) — [Kiro specs](https://kiro.dev/docs/specs/); BMAD small → build — [BMAD docs](https://docs.bmad-method.org/).

### Inferences
- Minimal common process (for designing a lean skill): context file → clarify questions → short spec with acceptance criteria [human gate] → plan of small verifiable tasks [human gate / "go"] → per-task execute + test + review (can be unattended) → final verification → PR/close. Everything else (personas, constitution articles, research.md/data-model.md/contracts, epics/stories, complexity scoring) is framework-specific and is where bloat critiques land.
- Where frameworks diverge most: artifact count (OpenSpec/Kiro 3–4 files vs Spec Kit 7+ vs BMAD multi-document) and spec lifetime (per-change archive vs living spec merge, e.g., OpenSpec archive merges deltas; Spec Kit 1.0 moving toward "living, capability-level specs").

### Gaps
- No primary source defines a formal "done" criterion common to all; Spec Kit's "Converged" and GSD Verify are the closest, but their checks were not documented on pages read.
