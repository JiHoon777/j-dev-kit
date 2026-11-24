# Autonomous coding harnesses and loops (backlog/spec -> plan -> implement -> verify -> PR/merge)

Research date: 2026-11-20. Coverage favors 2025-2026 primary sources. "Unverified" means I could not open a primary source in this session.

## 1. Anthropic's own guidance: long-running harnesses, loops, Stop hooks, GitHub Actions

### Takeaway
Anthropic's published harnesses went through three stages:
- **Nov 2025, two prompts:** an initializer prompt, then repeated coding sessions. Context passes between sessions through a JSON feature list, a progress file, `init.sh` and git. Each session does one feature.
- **Feb 2026, parallel loops:** 16 bare `while true` loops run in containers and coordinate only through git and lock files.
- **Mar 2026, three agents:** a planner, a generator and an evaluator. The evaluator tests the running app with Playwright. Later models made parts of this scaffolding unnecessary.

Across all three, a run is "done" when an external check passes (tests, feature `passes` flags, evaluator thresholds), not when the agent says so. The human writes the spec and the tests or grading criteria, then mostly steps away.

### Cited Findings
**Stage 1: "Effective harnesses for long-running agents" (Justin Young, Nov 26, 2025, Opus 4.5 on the Claude Agent SDK)** — [Anthropic](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- **Problem.** Compaction alone was not enough. With only a high-level prompt such as "clone claude.ai", Opus 4.5 looping on the Agent SDK fell short of a production-quality app.
- **Two failure patterns it targets:**
  - The agent tries to do too much at once, runs out of context mid-feature, and leaves undocumented half-finished work.
  - Later sessions see the existing progress and declare the project finished.
- **Initializer agent (first session only):**
  - writes `init.sh`, which starts the dev server
  - creates `claude-progress.txt`
  - makes the first git commit
  - expands the prompt into a feature list. The claude.ai clone got 200+ features, all marked failing.
- **Feature list format.** JSON, because the model is less likely to overwrite JSON than Markdown. Each entry has `category`, `description`, `steps` (manual test steps; the example has 5) and `passes: false`. The session transcript names the file `feature_list.json`.
- **Coding agent: session start**
  1. run `pwd`
  2. read the git log (`git log --oneline -20`) and the progress file
  3. read the feature list and pick the highest-priority failing feature
  4. run `init.sh`
  5. run a basic end-to-end smoke test, which catches bugs a previous session left behind
- **Coding agent: work rules.** One feature per session. The agent may change only the `passes` field; removing or editing tests is strongly forbidden. The feature must be verified end to end before it is marked passing.
- **Coding agent: session end.** Make a descriptive git commit, update the progress file, and leave the code "clean, mergeable".
- **Roles.** Both "agents" share the same system prompt, tools and harness. Only the first user prompt differs.
- **Testing.** Unit tests and curl missed end-to-end bugs. Browser automation through the Puppeteer MCP server, testing as a human user would, "greatly improved" results. Known blind spot: browser-native `alert` modals are invisible through Puppeteer MCP.
- **Git.** Git is the memory and the rollback mechanism: agents revert bad changes and recover working states.
- **Stop condition.** No formal one is stated. The implied end is every feature `passes: true`.
- **Open questions the authors list.** Whether one general agent is best, or specialized testing, QA and cleanup agents would do better. The demo was limited to full-stack web apps.

**Stage 2: "Building a C compiler with a team of parallel Claudes" (Nicholas Carlini, Feb 5, 2026, Opus 4.6)** — [Anthropic](https://www.anthropic.com/engineering/building-c-compiler)
- **Loop.** A bash `while true` relaunches Claude Code with `--dangerously-skip-permissions` and the prompt file `AGENT_PROMPT.md`. Each run logs to a file named by commit hash. When one session ends, the next begins. The author recommends running it in a container.
- **Parallelism.** 16 agents ran at once, each in its own Docker container. A bare git repo is the shared upstream. Each agent clones it to `/workspace` and pushes back when done.
- **Task claiming.** An agent claims a task by writing a lock file in `current_tasks/` (for example `parse_if_statement.txt`). A git conflict on the lock forces a second agent to pick another task. After finishing, the agent pulls, merges, pushes and removes its lock. Merge conflicts were frequent, and Claude resolved them.
- **No orchestrator.** There is no orchestrator agent and no other inter-agent messaging. Agents pick the "next most obvious" problem and keep a running doc of approaches that failed.
- **Specialized roles.** Some agents deduplicated code, improved performance or generated-code efficiency, critiqued the design from a Rust developer's view, or maintained documentation.
- **Making the work verifiable:**
  - high-quality test suites
  - a CI gate, added late, to stop new commits breaking old features
  - output kept short for the context window: details go to log files, errors are grep-able `ERROR` lines, summary statistics are precomputed
  - a `--fast` flag that runs a random 1% or 10% sample, deterministic per agent but different across agents, to counter "time blindness"
  - GCC used as a known-good oracle plus delta debugging, so agents stopped colliding on the single huge "compile Linux" task
- **Results.** About 100k lines of Rust. It builds Linux 6.9 on x86, ARM and RISC-V, and compiles QEMU, FFmpeg, SQLite, Postgres and Redis. Pass rates are about 99% on most suites.
- **Effort and cost.** Nearly 2,000 sessions over 2 weeks, about 2B input and 140M output tokens, just under $20k in API cost.
- **Limitations reported:**
  - New features often broke existing ones.
  - There is no 16-bit codegen, assembler or linker; GCC's are used.
  - Generated code is slower than GCC at -O0.
  - One agent ran `pkill -9 bash` and killed its own loop.
  - The author is uneasy about deploying code no human has verified.
- **Human role.** The human wrote the spec, the harness, the tests, the CI and the oracle. Once running, the agents worked without active intervention.

**Stage 3: "Harness design for long-running application development" (Prithvi Rajasekaran, Mar 24, 2026)** — [Anthropic](https://www.anthropic.com/engineering/harness-design-long-running-apps)
- **The three agents:**
  - **Planner:** expands a 1-4 sentence prompt into a product spec. It stays high level, because granular technical detail causes cascading errors.
  - **Generator:** builds with React, Vite, FastAPI and SQLite/Postgres, using git.
  - **Evaluator:** uses Playwright to click through the running app and check API endpoints and database state, then grades against hard thresholds. Failing any one criterion fails the sprint.
- **Sprint contracts.** Before each sprint, the generator proposes what "done" means and how it will be verified. The evaluator reviews the proposal until both agree. Agents communicate through files.
- **Context anxiety.** Sonnet 4.5 showed "context anxiety": it wrapped up early as it neared its perceived context limit.
- **Resets vs compaction.** Context resets (a fresh agent plus a structured handoff) fixed context anxiety but added orchestration work, tokens and latency. With Opus 4.5 the behavior largely went away, so resets were dropped in favor of the SDK's automatic compaction.
- **Cost and time:**
  - Retro game maker, solo agent: 20 min and $9, with broken game logic.
  - Same app, full harness: 6 h and $200, far more functional. That is more than 20x the cost.
  - DAW app on the V2 harness with Opus 4.6: about 3 h 50 min and $124.70. The first build round ran over 2 h; each QA round took under 10 min.
- **Simplification with Opus 4.6:**
  - Sprints were removed, because the model stays coherent longer on its own.
  - The planner was kept, because without it the generator under-scoped the app.
  - The evaluator became a single pass at the end. It is worth having only when the task is beyond what the model does reliably alone.
- **Failure modes:**
  - Out of the box, Claude is a poor QA agent. It finds real issues, then talks itself into approving the work, and tests superficially.
  - The evaluator stays "inclined to be generous" toward LLM output.
  - The generator stubbed features, such as non-functional audio recording.
- **Human role.** The human tuned the evaluator over several rounds: reading its logs, finding where its judgment diverged from theirs, and rewriting its prompt.
- **Frontend design variant.** Generator plus evaluator, graded on design quality, originality, craft and functionality. Runs took 5-15 iterations and up to 4 h. A human sometimes preferred a middle iteration over the final one.

**Stop-hook loops and the ralph-loop plugin**
- In Claude Code, a `Stop` hook fires when Claude finishes responding. It can force Claude to keep going in two ways:
  - exit with code 2; the stderr text becomes the reason Claude sees
  - return `{"decision":"block","reason":...}`
  - Either way, `continue: false` takes precedence and ends the turn. Stop and SubagentStop hooks receive `last_assistant_message`. The docs' example blocks stopping while `npm test` fails. — [Claude Code hooks docs](https://code.claude.com/docs/en/hooks)
- The official `ralph-loop` plugin (in `anthropics/claude-plugins-official`) runs the loop inside one session:
  - `/ralph-loop "<prompt>" --max-iterations N --completion-promise "<text>"` starts it; `/cancel-ralph` stops it.
  - `hooks/stop-hook.sh` blocks the exit and feeds the same, unchanged prompt back. Claude sees its earlier work only through the files and git history.
  - Completion is an exact string match on the promise, for example `<promise>COMPLETE</promise>`. One promise therefore cannot encode several outcomes, such as "done" versus "blocked".
  - `--max-iterations` defaults to unlimited and is called the primary safety mechanism.
  - The README says it suits tasks with automatically verifiable success criteria, not ones that need judgment or design decisions.
  - Windows caveat: `bash` may resolve to a broken WSL bash; point the hook at Git's `bin/bash.exe`.
  - Source: [ralph-loop README](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/plugins/ralph-loop/README.md)
  - The old path `anthropics/claude-code/plugins/ralph-wiggum` now returns 404 ([GitHub](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum)). The plugin's cache path still uses the name "ralph-wiggum", which suggests a rename. Unverified.

**Claude Code GitHub Actions (`anthropics/claude-code-action@v1`, built on the Agent SDK)** — [Claude Code docs](https://code.claude.com/docs/en/github-actions)
- **Two modes:**
  - **Interactive:** with no `prompt` input, Claude waits for `@claude` in a comment, review, or new issue body or title, and reports progress as a comment.
  - **Automation:** with a `prompt` input (plain text or a `/skill`), it runs on any event, including cron, and writes results to the run log unless told to post.
- **Trigger checks.** The triggering user must have write access. Bot actors are rejected unless listed in `allowed_bots`, "which keeps bots from triggering Claude in a loop".
- **Cost controls:** `--max-turns` in `claude_args`, workflow timeouts, concurrency limits. Each run costs both Actions minutes and tokens.
- **CI gotcha.** Commits pushed with the default `GITHUB_TOKEN` do not trigger CI, so the action should use the Claude App or a custom app token.
- **Merge.** The docs say to "review Claude's changes before merging". The human merge remains the approval point.
- **Related products:** Code Review (automatic PR review), cloud sessions with PR auto-fix, the Agent SDK for custom automation, and scheduled runs.

### Inferences
- Anthropic's three posts form a design progression:
  - one agent, with artifact-based memory (JSON feature list, progress file, git)
  - many identical agents, with git and lock-file coordination plus strong test oracles
  - role-split agents (planner, generator, evaluator), with scaffolding removed as models improve
- The constant across all three is that the stop condition sits outside the model: tests, `passes` flags, evaluator thresholds, or a completion promise checked by a hook.
- "One feature per session" plus a fresh context per iteration is the recurring answer to two problems: context exhaustion and premature "done".

### Gaps
- I did not fetch the docs for headless `claude -p` (flags such as `--output-format stream-json`, `--max-turns`, `--allowedTools`) or the Agent SDK overview in this session. Details there are unverified.
- The truncated hooks page did not show the `stop_hook_active` input field or the infinite-loop warning. They should be confirmed in the Stop section of https://code.claude.com/docs/en/hooks.
- Not checked: any Anthropic post from Apr-Nov 2026 beyond the three above, such as Managed Agents or cloud routines.

## 2. The Ralph Wiggum loop (Geoffrey Huntley) and its plugin form

### Takeaway
Ralph is literally `while :; do cat PROMPT.md | claude-code ; done`. It is an infinite bash loop that feeds the same prompt to a fresh agent each time. State lives entirely on disk:
- `specs/*`, written with the agent before the loop starts
- `fix_plan.md`, a prioritized TODO list that is often thrown away and regenerated
- `AGENT.md`, build and run notes that Ralph updates
- git

Tests and type checking provide the "backpressure". There is no built-in stop: the human watches, then regenerates the plan or runs `git reset --hard` when Ralph goes off track. Huntley says it suits greenfield work, not existing codebases.

### Cited Findings
- **Loop and files.** Published 14 July 2025. The core command is `while :; do cat PROMPT.md | claude-code ; done`. It works with any tool that doesn't cap tool calls or usage. The files are PROMPT.md, `specs/*` (one spec per file, formed through a long conversation before building), `fix_plan.md` (prioritized bullets, "often" discarded and regenerated) and `AGENT.md` (how to build and run, kept brief, updated by Ralph). — [ghuntley.com/ralph](https://ghuntley.com/ralph/)
- **Granularity.** The advice is "one item per loop", narrowed further if the project goes off the rails. The CURSED example prompt, however, asks for "the most important 10 things", so the page is internally inconsistent. — [ghuntley.com/ralph](https://ghuntley.com/ralph/)
- **Subagents.** The main context acts as a scheduler. Expensive search and summarization go to subagents: up to 500-1,000 parallel subagents for search and file writes, but only one for build and test, to avoid "bad form back pressure". — [ghuntley.com/ralph](https://ghuntley.com/ralph/)
- **Backpressure:**
  - run the tests for each changed unit after each change
  - static typing and analysis (Rust, Dialyzer, Pyrefly)
  - a "no cheating" rule against placeholder implementations
  - commit, push and tag after tests pass
  - test comments that explain why the test matters, since later loops lack that context
  - Source: [ghuntley.com/ralph](https://ghuntley.com/ralph/)
- **Stopping.** None is built in. The loop ends when the TODOs run out or Ralph "goes completely off track". The operator then regenerates the TODO list, resets with git, or uses rescue prompts. — [ghuntley.com/ralph](https://ghuntley.com/ralph/)
- **Failure modes:**
  - The context window is about 170k tokens.
  - Non-deterministic code search makes Ralph conclude something is unimplemented, so he writes duplicate implementations.
  - Placeholder code appears despite instructions.
  - Wrong patterns or wrong specs need tuning.
  - The build is broken "on waking".
  - The repo fills with temp files and binaries.
  - Output comes in three states: "under-baked, baked, or baked with unspecified latent behaviours".
  - Senior engineering judgment is still needed.
  - Source: [ghuntley.com/ralph](https://ghuntley.com/ralph/)
- **Reported results (anecdotal, not verified).** CURSED, a language and LLVM compiler built over about 3 months and not yet launch-ready. A shared iMessage claiming a $50k contract delivered for $297 using Amp. A YC hackathon report, "shipped 6 repos overnight". — [ghuntley.com/ralph](https://ghuntley.com/ralph/); repeated without independent verification in the [ralph-loop README](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/plugins/ralph-loop/README.md)
- **Plugin vs. original.** Anthropic's plugin moves the loop into a Stop hook inside one session, keeping the same prompt every iteration. Huntley's loop is an external bash loop with a fresh process and fresh context each time. The plugin adds `--max-iterations` and an exact-match `--completion-promise` as stop conditions. — [ralph-loop README](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/plugins/ralph-loop/README.md)
- **Same pattern at scale.** Carlini's C compiler harness is the same external `while true` pattern, scaled to 16 containers. — [Anthropic](https://www.anthropic.com/engineering/building-c-compiler)

### Inferences
- The two Ralph variants differ in how context resets:
  - The external loop gives a true reset each iteration, with memory only through files.
  - The Stop-hook plugin continues in the same session and relies on compaction; this is inferred from the README's "same session" description.
- That difference matters for the "context anxiety" and coherence issues Anthropic describes in section 1.
- Ralph's real quality control is the backpressure (tests and types) plus a human who watches and resets. "Little or no human input" in practice means an operator who intervenes when the loop drifts.

### Gaps
- Not fetched: Huntley's later 2025-2026 posts on Ralph, or community harnesses such as Ralph Orchestrator. I did not check whether a canonical repo exists or the stop criteria have been formalized since.
- Not verified: the YC "6 repos overnight" write-up, as a primary source.

## 3. OpenAI harness engineering, Codex cloud, Copilot coding agent, Jules, Cursor, Devin, Factory: their pipelines

### Takeaway
The commercial "issue to PR" agents converge on one pipeline:
1. Intake from an issue, chat or ticket (GitHub, Slack, Linear, Jira, API).
2. Run in an isolated cloud VM or container with a setup script or snapshot.
3. Read AGENTS.md or custom instructions.
4. Plan, sometimes with explicit plan approval (Jules).
5. Code on a separate branch, running tests, linters and sometimes a browser.
6. Open a PR.
7. A human reviews and merges, and gives follow-ups through `@agent` comments on the PR.

The approval points are mostly before code (plan approval), before CI runs (Copilot's "Approve and run workflows"), and at merge. OpenAI's internal "harness engineering" is the extreme case: agents also review and merge. Its primary post blocked fetching, so most of its numbers here are secondary.

### Cited Findings
**OpenAI "Harness engineering: leveraging Codex in an agent-first world" (Ryan Lopopolo, Feb 11, 2026)**
- **Primary post.** openai.com returned 403 to my fetch ([OpenAI](https://openai.com/index/harness-engineering/)). Everything below is secondary.
- **Scale:** a five-month internal beta with no manually written code; about 1M lines covering app logic, infrastructure, tooling, docs and dev utilities. — search-result summary of the post ([OpenAI](https://openai.com/blog/harness-engineering)); [InfoQ, Feb 21 2026](https://www.infoq.com/news/2026/02/openai-harness-engineering-codex)
- **Agent loop:** Codex agents reproduce bugs, propose fixes, validate outcomes, open PRs, evaluate changes and iterate until the task criteria are met. — [InfoQ](https://www.infoq.com/news/2026/02/openai-harness-engineering-codex)
- **Repo as the source of truth:** a structured docs directory (maps, execution plans, design specs) is the agents' single source of truth. Cross-linked docs are enforced by linters and CI.
- **Architecture constraints:** dependencies must flow Types -> Config -> Repo -> Service -> Runtime -> UI, enforced by structural tests.
- **Observability:** agents use logs, metrics and spans in isolated dev environments.
- **Human role:** the work shifts to designing environments, specifying intent and giving feedback.
- Source for the three points above: [InfoQ](https://www.infoq.com/news/2026/02/openai-harness-engineering-codex)
- **Secondary numbers (ZenML summary of a Latent Space piece, not the post itself):**
  - more than 1,500 PRs, all authored, reviewed and merged by agents
  - a seven-person team, each person managing 10-50 agents
  - 3.5 PRs per engineer per day in late Dec 2025, rising to 5-10 per day after GPT-5.2 in early Jan 2026
  - more than 1B tokens per day, about $2-3k per day
  - the first 1.5 months were "10 times slower" than human development
  - review agents are told to bias toward merging and to surface nothing above P2; merging goes through a `$land` skill
  - agent.md is a table of contents; core-beliefs.md, tech-tracker.md and a quality-score table are "gardened" by Codex
  - the local observability stack is Vector, VictoriaMetrics and Grafana
  - session logs are reviewed daily by agent loops
  - Source: [ZenML](https://www.zenml.io/llmops-database/extreme-harness-engineering-building-production-systems-with-zero-human-written-code)
- **Conflict on team size.** Another secondary write-up says three engineers; ZenML says seven. Treat both as unconfirmed. — search summary flagged by [OpenAI search result](https://openai.com/blog/harness-engineering) vs [ZenML](https://www.zenml.io/llmops-database/extreme-harness-engineering-building-production-systems-with-zero-human-written-code)

**Codex cloud** — [OpenAI Codex cloud docs](https://learn.chatgpt.com/docs/cloud)
- Tasks start from web, mobile or desktop ("Work in > Cloud") or from the CLI.
- Each environment has a repo, an install script and a "start skill", and can be published so its setup is reused across tasks.
- Every task gets its own workspace.
- Network settings cover public internet, package-manager domains, allowed domains and HTTP secrets.
- The user reviews the diff and results, asks for follow-ups, then commits or opens a PR.

**GitHub Copilot coding agent ("cloud agent")**
- **Intake:** assign an issue to Copilot via Assignees, with an optional prompt, base branch, custom agent and model. — [GitHub Docs](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/use-cloud-agent-on-github)
- **Context:** Copilot reads the issue title, body, comments and the repo's custom instructions. It ignores comments added after assignment.
- **Output:** it opens a PR and requests the assigner's review. Progress shows in the session logs.
- **CI approval:** by default, Actions workflows do not run on Copilot's changes until a human clicks "Approve and run workflows" (configurable).
- **Iteration:** `@copilot` comments on the PR push new commits. Only users with write access can trigger it.
- Source for the five points above: [GitHub Docs](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/use-cloud-agent-on-github)
- **Environments:** a cloud sandbox, GitHub Actions-based, or remote. Actions-based sessions have a hard 59-minute limit.
- **Branches:** one branch and one PR per task. Branch rulesets can block Copilot unless it is granted a bypass.
- **Automation:** Copilot code review can run automatically. "Agent Merge" with "Watch and fix" works on failing CI or merge conflicts. Scheduled and event "Automations" (for example issue triage) exist.
- **Review:** session logs "do not replace your own review and testing".
- Source for the four points above: [GitHub Docs](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)
- **Entry points:** issues, agents tab, dashboard, Chat, failing Actions runs, mobile, IDE, REST API, CLI, MCP server, Jira, Slack, Teams, Azure Boards, Linear and Raycast. — [GitHub Docs](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-a-pr)

**Google Jules** — [Jules docs](https://jules.google/docs)
- The user picks a repo and branch, writes a prompt and optional setup script, and clicks "Give me a plan".
- Jules runs in a cloud VM, clones the code and installs dependencies.
- It generates a plan that "you can review and approve before any code changes are made".
- It reads the root AGENTS.md.
- It notifies the user when done or when it needs input.

**Cursor cloud agents** (formerly "background agents") — [Cursor docs](https://cursor.com/docs/cloud-agent)
- Agents start from desktop, web, iOS, Slack or Linear `@cursor`, GitHub or Bitbucket PR and issue comments, or the API.
- Each runs in an isolated VM. Setup comes from agent-led setup, a snapshot, or a Dockerfile in `.cursor/environment.json`.
- `.cursor/hooks.json` hooks run, including `beforeShellExecution` and `afterFileEdit`.
- Agents work on a separate branch and open "merge-ready" PRs, one per repo in multi-repo setups.
- They can use a browser or desktop and produce screenshots, video and logs. A human can take over the remote desktop.
- Unlimited agents can run in parallel, and the local machine does not need to stay online.
- A spend limit is requested on first use.

**Devin** — [Devin docs](https://docs.devin.ai/get-started/devin-intro)
- **Intake:** Slack, Teams, Linear or Jira tickets, the web app, the API, or the Devin CLI's `/handoff` to cloud.
- **Workspace:** shell, IDE and browser.
- **Output:** produces draft PRs.
- **Task sizing:** "if you can do it in three hours, Devin can most likely do it". Larger work should be split into well-scoped steps with clear completion criteria, such as CI passing.

**Factory**
- **Headless mode.** `droid exec --auto low|medium|high` runs headless. A command runs automatically when its risk level is at or below the autonomy level. If an action exceeds the level, droid exec stops with a non-zero exit code and makes no partial changes. — [Factory docs](https://docs.factory.ai/droid-exec/overview)
- **Missions.** An orchestrator model plans and coordinates; worker and validator agents execute. Validation runs as "scrutiny" and "user-testing" milestones, which can be skipped with `skipScrutiny` and `skipUserTesting`. Missions run headless via `droid exec --mission` for CI and scheduled jobs. The docs suggest a strong orchestrator paired with a cheaper worker model. — [Factory Missions reference](https://docs.factory.com/features/missions/reference.md)

### Inferences
- Every product except OpenAI's internal setup keeps a human at the merge gate by default. Copilot adds a second gate before CI runs on agent commits, a security measure because agent commits could modify workflows.
- Where "no human input" exists (OpenAI internal, Anthropic C compiler), it depends on:
  - very strong mechanical checks (structural tests, linters, CI, test oracles)
  - agent reviewers told to favor merging
  - humans redirected to building the harness, docs and feedback loops
- "Plan approval" (Jules), "sprint contracts" (Anthropic) and missions with validator milestones (Factory) are three forms of the same idea: settle what "done" means before coding starts.

### Gaps
- The OpenAI primary post was blocked (403). Unverified from the primary source:
  - exact team size
  - AGENTS.md as a ~100-line map
  - the docs/ layout (design-docs, exec-plans active/completed, tech-debt tracker)
  - Chrome DevTools Protocol validation
  - per-git-worktree observability
  - single Codex runs of 6+ hours
  - "golden principles" and garbage-collection agents
  - These match my prior knowledge of the post but could not be confirmed here.
- Not confirmed in the docs I fetched:
  - Copilot: `copilot/` branch naming, draft-PR status, `copilot-setup-steps.yml`, and whether the assigner may approve their own Copilot PR.
  - Devin: planning and approval, Knowledge, Playbooks, ACU pricing and session limits (not on the intro page).
  - Jules: scheduled tasks, concurrency limits and the critic step (not on the getting-started page).
  - Codex cloud: best-of-N attempts, time limits and `@codex` GitHub review (not on the page).
  - Factory Missions: lifecycle, state files and completion criteria.

## 4. Common patterns across harnesses

### Takeaway
Seven patterns show up across nearly every harness:
- one small unit of work per iteration
- a fresh or reset context each iteration, with all memory in repo files and git
- an isolated sandbox per agent (container, VM or worktree)
- an external, mechanical definition of done (tests, JSON pass flags, evaluator thresholds, CI, a completion promise)
- parallelism coordinated through git rather than messaging
- a separate verifier, because self-evaluation is lenient
- a human who writes the spec and tests up front and holds the merge or reset lever

Costs range from about $9 for a single 20-minute agent run, through $125-200 for multi-hour harnessed app builds, to about $20k for two weeks of 16 parallel agents.

### Cited Findings
- **Task granularity:**
  - Anthropic: one feature per session out of 200+, each feature with about 5 test steps — [Anthropic, Nov 2025](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
  - Huntley: "one item per loop" — [ghuntley.com](https://ghuntley.com/ralph/)
  - Carlini: one claimed task per agent via a lock file — [Anthropic, Feb 2026](https://www.anthropic.com/engineering/building-c-compiler)
  - Devin: tasks a human could finish in about 3 hours — [Devin docs](https://docs.devin.ai/get-started/devin-intro)
  - Copilot: one branch and one PR per task — [GitHub Docs](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)
- **Memory through files and git:**
  - Anthropic's harness carries `feature_list.json`, `claude-progress.txt`, `init.sh` and git log — [Anthropic](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
  - Ralph carries PROMPT.md, `specs/`, `fix_plan.md` and `AGENT.md` — [ghuntley.com](https://ghuntley.com/ralph/)
  - Carlini's agents carry `current_tasks/` locks and notes on failed approaches — [Anthropic](https://www.anthropic.com/engineering/building-c-compiler)
  - Anthropic's three-agent harness carries the spec and sprint-contract files — [Anthropic](https://www.anthropic.com/engineering/harness-design-long-running-apps)
  - OpenAI keeps its docs directory as the single source of truth — [InfoQ](https://www.infoq.com/news/2026/02/openai-harness-engineering-codex)
  - Jules reads AGENTS.md — [Jules](https://jules.google/docs)
- **Context reset vs compaction.** Resets plus a handoff were needed for Sonnet 4.5's "context anxiety". With Opus 4.5 and 4.6, SDK compaction was enough and the scaffolding shrank. — [Anthropic, Mar 2026](https://www.anthropic.com/engineering/harness-design-long-running-apps)
- **Sandboxes:**
  - Docker container per agent — [Anthropic](https://www.anthropic.com/engineering/building-c-compiler)
  - isolated cloud VMs — [Cursor](https://cursor.com/docs/cloud-agent), [Jules](https://jules.google/docs)
  - per-task workspace with network allowlists — [Codex cloud](https://learn.chatgpt.com/docs/cloud)
  - cloud, Actions-based (59-minute limit) or remote environments — [Copilot](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)
- **Verification by a separate party:**
  - Puppeteer end-to-end tests — [Anthropic](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
  - a Playwright evaluator with hard thresholds — [Anthropic](https://www.anthropic.com/engineering/harness-design-long-running-apps)
  - a GCC oracle and CI — [Anthropic](https://www.anthropic.com/engineering/building-c-compiler)
  - scrutiny and user-testing validator milestones — [Factory](https://docs.factory.com/features/missions/reference.md)
  - a Stop hook that blocks while tests fail — [Claude Code hooks](https://code.claude.com/docs/en/hooks)
- **Reported failure modes:**
  - premature "done" — [Anthropic](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
  - context exhaustion mid-feature — [Anthropic](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
  - stubbed or placeholder features — [Anthropic](https://www.anthropic.com/engineering/harness-design-long-running-apps), [ghuntley.com](https://ghuntley.com/ralph/)
  - lenient self-QA — [Anthropic](https://www.anthropic.com/engineering/harness-design-long-running-apps)
  - regressions from new features — [Anthropic](https://www.anthropic.com/engineering/building-c-compiler)
  - duplicate implementations from flaky code search — [ghuntley.com](https://ghuntley.com/ralph/)
  - agents colliding on a single big task — [Anthropic](https://www.anthropic.com/engineering/building-c-compiler)
  - runaway loops, guarded by max iterations, max turns and bot-trigger blocks — [ralph-loop](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/plugins/ralph-loop/README.md), [Claude Code Actions](https://code.claude.com/docs/en/github-actions)
  - a slow first phase, "10x slower" for the first 1.5 months (secondary) — [ZenML](https://www.zenml.io/llmops-database/extreme-harness-engineering-building-production-systems-with-zero-human-written-code)
- **Cost and time:**
  - $9 / 20 min solo vs $200 / 6 h with the harness; $124.70 / about 3 h 50 min for the DAW — [Anthropic](https://www.anthropic.com/engineering/harness-design-long-running-apps)
  - just under $20k, about 2,000 sessions, 2 weeks, 2B input and 140M output tokens — [Anthropic](https://www.anthropic.com/engineering/building-c-compiler)
  - about $2-3k per day at more than 1B tokens per day (secondary) — [ZenML](https://www.zenml.io/llmops-database/extreme-harness-engineering-building-production-systems-with-zero-human-written-code)
  - the $297 "$50k contract" (anecdotal) — [ghuntley.com](https://ghuntley.com/ralph/)

### Inferences
A minimal autonomous pipeline that all these sources would support has six parts:
1. A human-approved spec and an explicit feature or task list with machine-checkable pass criteria (JSON).
2. A loop that starts each iteration fresh, picks one item, implements it in a sandbox or worktree, runs the checks, then commits and updates a progress file.
3. A separate verifier: tests or CI, plus an evaluator agent for anything subjective or end to end.
4. A hard stop: every item passing, a completion promise, a max-iterations or max-turns cap, or a timeout.
5. A PR with a human merge gate, unless very strong mechanical checks exist.
6. A periodic cleanup or "gardening" agent to fight entropy.

The biggest risk named consistently is the agent grading itself, so the definition of done must be outside the agent.

### Gaps
- I found no rigorous comparative benchmark of these harnesses on success rate or cost per merged PR from a primary source. The figures above are single case studies.
- Not researched in this session:
  - official cost and time numbers for the commercial products (Copilot, Jules, Cursor, Devin), beyond the pricing notes cited
  - their PR acceptance rates
