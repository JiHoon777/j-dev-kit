# Claude Code orchestration capabilities: how a lead session creates, schedules, monitors and messages other sessions (as of 2026-11-20)

Scope note: all facts come from code.claude.com/docs, the anthropics/claude-code CHANGELOG and GitHub release API, and claude.com/blog, fetched 2026-11-20. Latest release at fetch time: v2.1.329, published 2026-11-19 ([GitHub releases API](https://api.github.com/repos/anthropics/claude-code/releases?per_page=100)). "Lifetime" means: T = ends with the turn, S = lasts for the session (ends when the claude process exits), R = survives a session restart or resume, B = survives a machine reboot.

## Q1. Spawning and messaging agents: subagents, background subagents, forks, agent teams, SendMessage, background sessions (agent view, `claude --bg`), cross-session messaging, Remote Control, Projects, Desktop

### Takeaway
Claude Code now has five official ways to run work in parallel: subagents, agent view (background sessions), agent teams (experimental), dynamic workflows, and Projects (cloud, beta). One `SendMessage` tool now covers subagents, teammates and *any other Claude Code session* (same machine, other machines, cloud), and `ListAgents` finds the targets. For a plugin author, the lead-session building blocks are: the Agent tool (in-session workers), `claude --bg` / `/fork` (separate background sessions run by a supervisor that outlives the terminal but not a reboot), and `SendMessage` + `notify_when_idle` (results and status coming back).

### Cited Findings

**Overview / taxonomy**
- The official list of parallel approaches: subagents, agent view (research preview, `claude agents`), agent teams ("Experimental and disabled by default"), Projects ("Public beta on Pro, Max, and Ultra"), and dynamic workflows. Worktrees, cross-session messaging and `/batch` (a skill that splits a change into 5 to 30 worktree-isolated subagents) are described as supporting tools — [Run agents in parallel](https://code.claude.com/docs/en/agents.md)
- How results come back differs by approach: "Subagents report results back to the conversation that spawned them, and agent view sessions report results only to you. Teammates in an agent team message each other directly" — [agents.md](https://code.claude.com/docs/en/agents.md)
- Status commands: `claude agents` for background sessions; `/tasks` for anything in the background of the current session (it also lists finished subagents); `/workflows` for workflow runs. `/agents` (in-session) is separate from `claude agents` — [agents.md](https://code.claude.com/docs/en/agents.md)
- Running several sessions or subagents at once multiplies token usage — [agents.md](https://code.claude.com/docs/en/agents.md)

**Subagents (Agent tool, `.claude/agents/*.md`)**
- Agent tool per-call parameters named in the docs: `subagent_type`, `model` (alias), `effort` (v2.1.292+), `name` (makes the subagent addressable by `SendMessage`), and `isolation` (`worktree`) — [Create custom subagents](https://code.claude.com/docs/en/sub-agents.md)
- Background is the default. Without configuration, subagents Claude spawns from the main conversation start in the background. `background: true` in frontmatter keeps a subagent in the background. `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1` makes Claude wait — [sub-agents.md](https://code.claude.com/docs/en/sub-agents.md)
- A background subagent's result "arrives as a completion notification in a later turn". Its permission prompts surface in the main session, labelled with the subagent's name. Background subagents get a reduced built-in tool set (Read, Grep, Glob, LSP, Bash, PowerShell, Edit, Write, WebFetch, WebSearch, Skill, Monitor, SendMessage, plus a few more) and keep every MCP tool — [sub-agents.md](https://code.claude.com/docs/en/sub-agents.md)
- Continuing a subagent: `SendMessage` with `to` = agent ID or name resumes a completed subagent in the background with its full history. This doesn't require agent teams. A subagent the user stopped (with `x` in `/tasks`, or SDK `stop_task`) doesn't auto-resume — [sub-agents.md](https://code.claude.com/docs/en/sub-agents.md)
- Nesting goes three layers below the main conversation by default (`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH`; `1` turns nesting off). In interactive mode, a subagent waits for the background subagents it started. In `-p` and the SDK, it waits only for foreground ones — [sub-agents.md](https://code.claude.com/docs/en/sub-agents.md). v2.1.328 changed this: "subagents in `claude -p`, the Agent SDK, desktop and VS Code [now] wait for their own subagents by default" — [CHANGELOG](https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md)
- Limits: 20 concurrent subagents by default (`CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS`). Ultracode sessions are exempt. There is no limit on total subagents per session — [sub-agents.md](https://code.claude.com/docs/en/sub-agents.md)
- Frontmatter fields: `name`, `description`, `tools`, `disallowedTools`, `model`, `permissionMode`, `maxTurns`, `autoCompactWindow`, `skills` (≤32), `mcpServers`, `hooks`, `memory`, `background`, `omitClaudeMd`, `effort`, `isolation: worktree`, `color`, `initialPrompt`, `experimental.cacheTtl`. There is also a `--agents` JSON flag, and `--agent <name>` runs the whole session as that agent — [sub-agents.md](https://code.claude.com/docs/en/sub-agents.md)
- Subagent transcripts are stored at `~/.claude/projects/{project}/{sessionId}/subagents/agent-{agentId}.jsonl` and deleted after `cleanupPeriodDays` (default 30) — [sub-agents.md](https://code.claude.com/docs/en/sub-agents.md)
- `/agents` no longer opens a wizard after v2.1.197. It now prints a reminder to edit `.claude/agents/` (**changed**) — [sub-agents.md](https://code.claude.com/docs/en/sub-agents.md)
- `TaskStop` stops a background task, teammate or named background agent. `TaskOutput` was "Removed in v2.1.277"; Claude reads the background task's output file with `Read` instead (**removed**) — [Tools reference](https://code.claude.com/docs/en/tools-reference.md)
- `SubagentHandback` delivers a subagent's final report. It exists only in auto mode, for local non-fork subagents, and the classifier reviews the report (v2.1.271+) — [tools-reference.md](https://code.claude.com/docs/en/tools-reference.md)

**Forks**
- `/subtask` starts an in-session forked subagent: it inherits the full conversation, the parent's exact tool pool and the parent's model. `/fork` now copies the whole session into a new *background session* that runs alongside. With agent view turned off, `/fork` is the forked-subagent command and `/subtask` isn't available — [agents.md](https://code.claude.com/docs/en/agents.md), [sub-agents.md](https://code.claude.com/docs/en/sub-agents.md)
- Rename history: in v2.1.212, `/fork` started copying the conversation into a new background session, and "the earlier forked-subagent behavior of `/fork` moved to `/subtask`" (**renamed**) — [Agent view version history](https://code.claude.com/docs/en/agent-view.md)

**Agent teams (experimental)**
- Enabled with `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` (env or settings.json `env`). This requires an interactive session: in `-p` and the Agent SDK, Claude doesn't spawn teammates — [Agent teams](https://code.claude.com/docs/en/agent-teams.md)
- A teammate launches when Claude calls the Agent tool with a `name` while teams are enabled. Forks and calls that pass `isolation` are excluded. There is no confirmation, so teams "can form even when you didn't ask for one" — [agent-teams.md](https://code.claude.com/docs/en/agent-teams.md)
- Architecture:
  - A lead, teammates, a shared task list and a mailbox.
  - The mailbox is JSON at `~/.claude/teams/{team}/inboxes/{agent}.json`.
  - The team config at `~/.claude/teams/{team}/config.json` is removed at session end.
  - The task list at `~/.claude/tasks/{team}/` persists.
  - Task claiming uses file locking.
  
  Source: [agent-teams.md](https://code.claude.com/docs/en/agent-teams.md)
- Results flow back automatically: "when a teammate finishes and stops, it automatically notifies the lead and includes its final answer in the notification" — [agent-teams.md](https://code.claude.com/docs/en/agent-teams.md)
- Display modes are in-process (default) or split panes (tmux or iTerm2), set with `teammateMode` or `--teammate-mode` — [agent-teams.md](https://code.claude.com/docs/en/agent-teams.md)
- Hooks for quality gates: `TeammateIdle`, `TaskCreated` and `TaskCompleted`, where exit code 2 blocks the action and sends feedback — [agent-teams.md](https://code.claude.com/docs/en/agent-teams.md)
- Limitations:
  - No resumption of in-process teammates via `/resume` or `/rewind`.
  - One team per session.
  - No nested teams.
  - In-process teammates can't run background subagents.
  - The lead is fixed.
  - Permission modes can't be set per teammate at spawn.
  - Token cost "scale[s] linearly". The docs suggest 3-5 teammates.
  
  Source: [agent-teams.md](https://code.claude.com/docs/en/agent-teams.md)
- Teammates can be spawned from subagent definitions (project, user, managed or plugin scope). Parts of the definition apply differently per mode; for example, `skills` isn't applied — [agent-teams.md](https://code.claude.com/docs/en/agent-teams.md)
- `teammateDefaultModel` was removed in v2.1.234 (**removed**) — [agent-teams.md](https://code.claude.com/docs/en/agent-teams.md)

**Background sessions / agent view (the "lead spawns sessions" feature)**
- Commands:
  - Start: `claude --bg "<prompt>"`, with `--name`, `--agent`, and `--resume <id> --bg`.
  - Background an open session: `/bg` (or `/background`), or `←` on an empty prompt.
  - Shell jobs with no model: `claude --bg --exec '<cmd>'`.
  - Script control: `claude agents --json [--all]`, `claude attach|logs|respawn|stop|rm <id>`, `claude daemon status|stop`.
  
  Source: [Agent view](https://code.claude.com/docs/en/agent-view.md)
- Lifetime:
  - A supervisor process runs the sessions, so they survive closing the terminal, sleep, auto-updates and supervisor restarts.
  - "Shutdown or restart stops running sessions". Sessions stopped within 48 h show as failed and restart from the saved conversation when you attach.
  - Sessions idle and unattached for about 1 h have their process paused; pin one with Ctrl+T to keep it running.
  
  Source: [agent-view.md](https://code.claude.com/docs/en/agent-view.md)
- Isolation: a dispatched session moves into its own worktree under `.claude/worktrees/` before editing (`worktree.bgIsolation: "none"` disables this). When it finishes, a session isolated in a worktree "commits, pushes its own isolated branch, never `main` or `master`, and opens a draft pull request" (v2.1.198) — [agent-view.md](https://code.claude.com/docs/en/agent-view.md)
- Turn agent view off with `disableAgentView` or `CLAUDE_CODE_DISABLE_AGENT_VIEW`. Each session uses subscription quota independently, so 10 agents use quota "roughly ten times as fast" — [agent-view.md](https://code.claude.com/docs/en/agent-view.md)
- `claude --bg` can't be combined with `-p` (v2.1.198). In a script, `claude --bg` in an untrusted directory exits with `Workspace not trusted` (v2.1.281) — [agent-view.md](https://code.claude.com/docs/en/agent-view.md), [headless.md](https://code.claude.com/docs/en/headless.md)
- Session-started sessions are an acknowledged pattern: v2.1.327 "Changed prompt history to leave out most launch prompts of sessions that another Claude Code session started" — [CHANGELOG](https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md)
- Agent view was introduced in v2.1.139 (2026-05-11), together with `/goal` — [release v2.1.139](https://api.github.com/repos/anthropics/claude-code/releases/tags/v2.1.139)

**Cross-session messaging (`ListAgents` + `SendMessage`)**
- Requirements: v2.1.224+ on macOS and Linux (including WSL 2), v2.1.234+ on native Windows. It is on with nothing to enable. Claude finds targets with `ListAgents` and sends with `SendMessage`. A user can also `@`-mention a session (v2.1.232+). `/list-agents` (alias `/peers`) shows what's reachable — [Cross-session messaging](https://code.claude.com/docs/en/cross-session-messaging.md)
- Reach:
  - Sessions on the same machine travel over a per-session Unix socket or named pipe, "never through Anthropic servers".
  - Other machines and cloud sessions go through Anthropic servers and need Remote Control with a claude.ai login.
  - Cloud sessions can't reply with `SendMessage` to a message from another machine.
  - Containers and the host can't reach each other.
  
  Source: [cross-session-messaging.md](https://code.claude.com/docs/en/cross-session-messaging.md)
- Delivery: a message is read between tool calls while the receiver is busy. It starts a new turn if the receiver is idle. Incoming messages "can't approve anything", "can't change configuration", and commands in them don't run — [cross-session-messaging.md](https://code.claude.com/docs/en/cross-session-messaging.md)
- Status callback: `SendMessage`'s `notify_when_idle` asks a same-machine session for one notice when it next goes idle or exits (v2.1.236+ in both sessions). Subscribing costs no tokens in the watched session. The subscription is dropped after 12 h. Only the main conversation can subscribe — [cross-session-messaging.md](https://code.claude.com/docs/en/cross-session-messaging.md)
- Inbound controls: `crossSessionInbound` = `accept` | `hold` | `refuse`, plus `isolatePeerMachines`. To turn messaging off, deny `SendMessage` and `ListAgents`. The default holds messages from bypass-permission senders, and a held message expires after `dialogExpiry` (5 min default) — [cross-session-messaging.md](https://code.claude.com/docs/en/cross-session-messaging.md)
- Headless workers: a `claude -p` session binds an inbox socket, so a long-running `-p` worker can receive messages. Start it with `--settings` setting `crossSessionInbound: accept` so it takes messages unattended. `--bare` sessions don't bind the socket — [cross-session-messaging.md](https://code.claude.com/docs/en/cross-session-messaging.md)
- Scripts and hooks can post into their own session. The socket path is exported as `CLAUDE_CODE_MESSAGING_SOCKET`, and `CLAUDE_CODE_MESSAGING_TOKEN` authenticates (required on Windows) — [cross-session-messaging.md](https://code.claude.com/docs/en/cross-session-messaging.md)
- Limits:
  - Plain text only, about 1M characters per message.
  - Bursts are refused.
  - At most 50 accepted messages are queued.
  - Slow loops "can exchange thousands of messages without a prompt from you".
  
  Source: [cross-session-messaging.md](https://code.claude.com/docs/en/cross-session-messaging.md)
- Introduced in v2.1.224 (2026-08-07): "Added cross-session `SendMessage` ... with `ListAgents` to find them" — [release v2.1.224](https://api.github.com/repos/anthropics/claude-code/releases/tags/v2.1.224)

**Remote Control**
- Three ways to start it: server mode `claude remote-control` (multi-session; `--spawn same-dir|worktree|session`; `--capacity N`, default 32), `claude --remote-control` / `--rc`, or `/remote-control` (`/rc`) inside a session. It requires Pro/Max/Ultra/Team/Enterprise with a claude.ai login; API keys aren't supported. On Team and Enterprise an Owner must enable it — [Remote Control](https://code.claude.com/docs/en/remote-control.md)
- Lifetime: "Local process must keep running". When the server stops, `claude remote-control [--continue|--session-id]` brings sessions back for about 4 hours. Server mode exits after about 10 min of network outage — [remote-control.md](https://code.claude.com/docs/en/remote-control.md)
- Turn it on everywhere with the `/config` setting "Enable Remote Control for all sessions". Turn it off with `disableRemoteControl` — [remote-control.md](https://code.claude.com/docs/en/remote-control.md)
- Remote Control is what makes other machines and cloud sessions reachable for cross-session messaging — [cross-session-messaging.md](https://code.claude.com/docs/en/cross-session-messaging.md)

**Projects (cloud)**
- A project is one ongoing conversation at claude.ai/code or in the Desktop app. Claude starts parallel "threads", usually cloud sessions, or on your computer via Remote Control (v2.1.280+). Cloud threads keep going after the laptop is closed. It is a public beta on Pro/Max/Ultra and not offered on Team or Enterprise — [Projects](https://code.claude.com/docs/en/claude-projects.md)
- Cloud threads don't load local `.claude/skills/`, `.mcp.json` or plugins from `.claude/settings.json`. Plugins are added under Project settings > Plugins. Thread limits ("Run at most two threads at a time") are instructions, not hard caps — [claude-projects.md](https://code.claude.com/docs/en/claude-projects.md)

**Desktop app**
- Claude can list Code-tab sessions, read them, send messages between them, and rename or archive them. Scope is desktop-run sessions only (local, SSH, WSL), up to the "20 most recently active". Messages to a busy session are held until it finishes — [Desktop](https://code.claude.com/docs/en/desktop.md)
- Suggested tasks start in a new session only when the user clicks **Start** / **Start all**. Dispatch, from the phone, can spawn Code sessions itself and pushes to the phone when they finish or need approval (Pro/Max/Ultra only) — [desktop.md](https://code.claude.com/docs/en/desktop.md)

### Inferences
- A plugin "lead" has three tiers to pick from:
  - In-turn or in-session workers: the Agent tool, `/subtask`, workflows.
  - Separate local sessions that outlive the terminal: `claude --bg` through Bash, or `/fork`. Report-back comes through `SendMessage`/`notify_when_idle`, or by polling `claude agents --json`.
  - Cloud sessions: Projects and cloud scheduled tasks.
- Agent teams are the only built-in "lead + roster + shared task list" model, but they are experimental, interactive-only, and gated behind an env var. A plugin probably shouldn't depend on them.
- Observation from this research session's own environment, not documented: the Claude Desktop host exposes MCP tools such as `mcp__ccd_session__start_session` (start_session proposals with initiation "own_initiative" or "offer"), `mcp__ccd_session_mgmt__send_message`, `list_sessions`, and `mcp__scheduled-tasks__create_scheduled_task`. This is consistent with the Desktop docs: Claude-proposed sessions need a user click, and scheduled tasks can be managed by asking Claude. These are host-provided, not plugin-provided.

### Capability matrix (synthesis of the findings above; see per-row sources)

| Mechanism | Invoke | Lifetime | Scheduled? | Results to lead | Notify human | Plugin can use? |
|---|---|---|---|---|---|---|
| Subagent (fg/bg) | Agent tool; `.claude/agents` or plugin `agents/` | S (bg); handed off on background-exit ([agent-view.md](https://code.claude.com/docs/en/agent-view.md)) | No | Completion notification or return value | Via lead | Yes: plugin agents, but `hooks`/`mcpServers`/`permissionMode`/`initialPrompt` are ignored ([plugin components](https://code.claude.com/docs/en/plugins/components.md)) |
| Fork | `/subtask` (in-session), `/fork` (new bg session) | S / like a bg session | No | Notification / SendMessage | — | Skill can instruct |
| Agent team | env flag + Agent `name` | S; teammates aren't restored on resume | No | Idle notification with final answer; mailbox | Lead's prompts | Plugin agents usable as teammate types; enabling needs an env var |
| Background session | `claude --bg`, `/bg`, `/fork` | Survives terminal close and sleep; not reboot | Via `/loop` inside it | SendMessage, `claude agents --json`, `claude logs` | Agent view notifications + `Notification` hook `agent_needs_input`/`agent_completed` | Via Bash/hook scripts |
| Cross-session msg | `ListAgents`/`SendMessage` | Per message; idle-notice 12 h | No | Reply via SendMessage; `notify_when_idle` | Approval dialog for held msgs | Yes (model tools, socket for scripts) |
| Remote Control | `claude remote-control`, `--rc`, `/rc` | While process runs; resumable ~4 h | No | — | Mobile push | Indirect |
| Projects | claude.ai/code / Desktop | Cloud, survives everything | Can create cloud scheduled tasks | Threads in project overview | Desktop notifications | Plugins added per project |

### Gaps
- The exact Agent tool parameter name for background (`run_in_background`) and the exact `subagent_type` value for forks weren't confirmed in the fetched excerpt, which was truncated. The agent-teams page does mention `run_in_background: true` requests from teammates — [agent-teams.md](https://code.claude.com/docs/en/agent-teams.md)
- There is no documented tool letting a CLI session start a *new* background session other than shelling out to `claude --bg` or the user running `/fork`. The Desktop page summary said no such tool is described.
- Whether a background subagent survives the parent session's exit in general (beyond the "Move to background and exit" handoff) is not documented.

## Q2. Scheduling: `/loop`, session cron tools, Desktop scheduled tasks, cloud scheduled tasks (formerly routines, `/schedule`, API/GitHub triggers), GitHub Actions

### Takeaway
There are three official schedulers. `/loop` and the `CronCreate` tools are session-scoped: they need an open session, expire after 7 days, and have a 1-minute minimum. Desktop scheduled tasks are local: the app must be open and the computer awake. Cloud scheduled tasks (renamed from routines) are fully durable, with a 1-hour minimum plus API and GitHub triggers. A cloud task reports back as a new cloud session URL rather than into the lead session. GitHub Actions `schedule` is a fourth option.

### Cited Findings
- Official comparison: Cloud runs on Anthropic infrastructure, needs no machine and no open session, persists across restarts, has no local files (fresh clone), uses auto-mode permissions by default, and has a **1 hour** minimum. Desktop runs on your machine, needs the machine on but no open session, persists, and has a 1-minute minimum when Claude sets it (1 hour in the forms). `/loop` runs on your machine, needs an open session, is "Restored on `--resume`, with exceptions", inherits session MCP and permissions, and has a 1-minute minimum — [Run prompts on a schedule](https://code.claude.com/docs/en/scheduled-tasks.md)

**`/loop` and session cron**
- `/loop 5m <prompt>` runs on a fixed cron schedule. `/loop <prompt>` without an interval lets Claude self-pace between 1 min and 1 h using the `ScheduleWakeup` tool, which ends the loop with `stop: true`. A bare `/loop` runs the built-in maintenance prompt or `.claude/loop.md` / `~/.claude/loop.md` — [scheduled-tasks.md](https://code.claude.com/docs/en/scheduled-tasks.md)
- `/loop 20m /review-pr 1234` re-runs a skill, but only skills Claude may invoke itself. Built-ins and `disable-model-invocation` skills arrive as plain text — [scheduled-tasks.md](https://code.claude.com/docs/en/scheduled-tasks.md)
- The underlying tools are `CronCreate` (5-field cron, recurring or one-shot), `CronList` and `CronDelete`. A session holds at most **50** tasks. Recurring tasks expire **7 days** after creation. Fires happen only between turns, in local time, with deterministic jitter (up to half the interval, max 30 min late). Missed fires don't catch up — [scheduled-tasks.md](https://code.claude.com/docs/en/scheduled-tasks.md)
- Lifetime caveats:
  - Closing the terminal stops tasks.
  - Backgrounding the session (`/bg`) carries `/loop` tasks over.
  - `--resume` restores `CronCreate` tasks, but not self-paced loops, and not tasks if the user chose "Exit and stop tasks".
  - Background bash commands and monitors aren't restarted on resume.
  - Disable everything with `CLAUDE_CODE_DISABLE_CRON=1`.
  
  Source: [scheduled-tasks.md](https://code.claude.com/docs/en/scheduled-tasks.md)
- v2.1.329 added "this session's scheduled tasks, `/loop` wakeups, the goal and this conversation's forks to `/tasks`", and changed "Exit and stop tasks" to end scheduled tasks so they don't run on resume — [CHANGELOG](https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md)
- In agent view, scheduled `/loop` sessions notify only when they need input — [agent-view.md](https://code.claude.com/docs/en/agent-view.md)
- With feature-flag fetching off, tasks to keep across sessions are stored in `.claude/scheduled_tasks.json` and only run in the folder where they were created — [scheduled-tasks.md](https://code.claude.com/docs/en/scheduled-tasks.md)

**Desktop (local) scheduled tasks**
- They require Claude Desktop 1.1.5368+. Create them from Code tab > Scheduled > New task, or by asking Claude in any Desktop session. Each task is stored as `~/.claude/scheduled-tasks/<task-name>/SKILL.md` (frontmatter `name`/`description`, prompt as body). The schedule, folder and enabled state live elsewhere — [Desktop scheduled tasks](https://code.claude.com/docs/en/desktop-scheduled-tasks.md)
- They run only while the app is open and the computer awake ("Keep computer awake" setting available). Each run starts a fresh session. On wake, exactly one catch-up run happens for the most recent missed time within 7 days, with a notification. A per-task permission mode applies. A run stalled on a prompt waits in its session — [desktop-scheduled-tasks.md](https://code.claude.com/docs/en/desktop-scheduled-tasks.md)
- A task can update itself through the `update_scheduled_task` MCP tool, with approval each time. Results appear as a session reachable from the task's History list or the sidebar "Scheduled" group — [desktop-scheduled-tasks.md](https://code.claude.com/docs/en/desktop-scheduled-tasks.md)

**Cloud scheduled tasks (formerly routines)**
- "A cloud scheduled task, formerly a routine, is a saved Claude Code configuration: a prompt, one or more repositories, and a set of connectors". Status: research preview. Plans: Pro, Max, Ultra, Team, Enterprise. Create one at claude.ai/code/routines, in the Desktop app, or with `/schedule` (alias `/routines`) in the CLI — [Cloud scheduled tasks](https://code.claude.com/docs/en/routines.md)
- Triggers:
  - Schedule: hourly minimum, cron in UTC unless prefixed with `CRON_TZ=`, one-off runs supported.
  - API: `POST https://api.anthropic.com/v1/claude_code/routines/<trig_id>/fire` with a bearer token and beta header `experimental-cc-routine-2026-04-01`. The optional `text` arrives wrapped in `<routine-fire-payload>` as untrusted data. The response returns `claude_code_session_id`/`claude_code_session_url`.
  - GitHub: PR, release and issue events, with filters.
  
  Source: [routines.md](https://code.claude.com/docs/en/routines.md)
- API triggers and tokens can only be managed on the web, not the CLI. GitHub triggers can be added from the CLI from v2.1.225 — [routines.md](https://code.claude.com/docs/en/routines.md)
- Programmatic creation: the built-in `RemoteTrigger` tool "Creates, updates, runs, and lists cloud scheduled tasks ... Backs the `/schedule` command". It isn't available on Bedrock, Vertex (Agent Platform) or Foundry — [tools-reference.md](https://code.claude.com/docs/en/tools-reference.md)
- Reporting: each run is a new full cloud session, opened from the task's History list (statuses Succeeded / Failed / Cancelled, which reflect how the session ended, not whether the work was done). `/schedule why did my nightly review do nothing` reads run logs (v2.1.227+). Claude pushes to `claude/`-prefixed branches by default — [routines.md](https://code.claude.com/docs/en/routines.md)
- Permissions: a run starts in auto mode. It stops and waits in its session on ask rules or after repeated classifier blocks. "The fired prompt is therefore not live user input and can't act as approval or consent" — [routines.md](https://code.claude.com/docs/en/routines.md)
- Limits:
  - Scheduled runs: 100/h per account.
  - Run now plus API fires: 30/h per task.
  - API fires: 100/h per account.
  - GitHub events have hourly caps and excess events are dropped.
  - Runs draw on subscription usage, with metered overage if usage credits are on.
  - Tasks belong to the individual account, are not shared, and act as you.
  
  Source: [routines.md](https://code.claude.com/docs/en/routines.md)
- Requirements and blockers: `/schedule` needs a claude.ai subscription login, and Console API keys / Bedrock / Vertex / Foundry don't work. It can be turned off by an org Owner and isn't available inside a cloud session — [routines.md](https://code.claude.com/docs/en/routines.md)
- Rename (**renamed**): "Scheduled tasks were previously called routines". The old name remains in the URL `claude.ai/code/routines`, the `/routines` alias, the `/fire` API path and beta header, and the org toggle "Scheduled tasks (Was Routines)" — [routines.md](https://code.claude.com/docs/en/routines.md). Routines launched as a research preview on 2026-04-14 per a secondary source — [Tessl](https://tessl.io/blog/anthropic-adds-routines-to-claude-code-for-scheduled-agent-tasks/)
- Conflict: a secondary source cites daily caps of 5 (Pro), 15 (Max) and 25 (Team/Enterprise) routines per day — [search summary of secondary sources, e.g. lowcode.agency](https://www.lowcode.agency/blog/claude-code-routines-explained). The current official page lists hourly limits instead — [routines.md](https://code.claude.com/docs/en/routines.md). Treat the daily caps as outdated or unverified.

**GitHub Actions (`anthropics/claude-code-action@v1`)**
- Modes: interactive mode (no `prompt`, responds to `@claude`) and automation mode (`prompt` set, any event including `schedule` cron). Key inputs: `prompt`, `claude_args`, `anthropic_api_key` / `claude_code_oauth_token`, `github_token`, `settings`, `trigger_phrase`, `plugin_marketplaces`, `plugins`, `use_bedrock`/`use_vertex`/`use_foundry`. Quick setup is `/install-github-app` — [GitHub Actions](https://code.claude.com/docs/en/github-actions.md)
- Reporting: interactive mode posts progress and results as a comment on the issue or PR. Automation mode writes to the workflow run log unless the prompt and tools post comments. Costs are Actions minutes plus API tokens or subscription. Scheduled workflows run from the default branch and are disabled after 60 days without activity in public repos — [github-actions.md](https://code.claude.com/docs/en/github-actions.md)
- Plugins can be installed in CI (`plugins: "code-review@claude-plugins-official"`) and their skills invoked as `/plugin:skill` in `prompt` — [github-actions.md](https://code.claude.com/docs/en/github-actions.md)
- **Deprecated**: `@beta` → `@v1`; `mode` input removed; `direct_prompt` → `prompt`; `max_turns`/`model` → `claude_args`; `custom_instructions` → `--append-system-prompt` — [github-actions.md](https://code.claude.com/docs/en/github-actions.md)

### Inferences
- A plugin skill can set up `/loop` or session cron via the model-invocable `CronCreate` tool. It can propose a cloud task via `RemoteTrigger`/`/schedule` (claude.ai login only). It can tell the user to create Desktop tasks. Only cloud tasks and GitHub Actions survive the machine being off.
- None of the durable schedulers report *into an existing lead session* by default; each run is its own session. To aggregate, a run would have to write somewhere shared (PR, artifact, connector), or use `SendMessage` to a Remote-Control-connected lead. Cloud sessions can receive cross-session messages, but replying from cloud to another machine via `SendMessage` is unsupported.

### Gaps
- No official source gives the exact date of the routines-to-scheduled-tasks rename. Secondary sources only indicate it happened before 2026-11-11.
- The `RemoteTrigger` input schema is referenced (Agent SDK TypeScript reference) but wasn't fetched.

## Q3. Orchestration scripts and monitoring: the Workflow tool (dynamic workflows), Monitor tool, task lists, `/goal`

### Takeaway
Dynamic workflows (the `Workflow` tool) are the official "orchestration script". Claude writes JavaScript (`agent()`, `pipeline()`, `parallel()`, `phase()`, `log()`) that runs up to 16 concurrent and 1,000 total subagents in the background. Workflows can be saved to `.claude/workflows/` and shipped in plugins. Monitor streams background-script or WebSocket events into the session with a ≤30 min deadline per watch, and plugins can declare session-long monitors. `/goal` is a built-in Stop-hook loop. The Task* list tools are now off by default on newer models.

### Cited Findings

**Dynamic workflows**
- "A dynamic workflow is a JavaScript script that orchestrates many subagents at once. Claude writes the script ... and a runtime executes it in the background while your session stays responsive." There are three ways in:
  - Ask for one, or include the keyword `ultracode`.
  - `/effort ultracode` lets Claude plan workflows for every substantive task.
  - Run a saved or bundled workflow, such as `/deep-research`.
  
  Source: [Dynamic workflows](https://code.claude.com/docs/en/workflows.md)
- Script API: `export const meta = {name, description, phases?}` must come first. The body can call `agent(prompt, {schema, label, stallMs, ...})`, `pipeline(items, fn)`, `parallel(tasks)`, `phase(title)`, `log(msg)`, and read the `args` global. `Date.now()`/`Math.random()` throw, so replays stay deterministic. `import()` isn't allowed, and the script has no direct filesystem or shell access — [workflows.md](https://code.claude.com/docs/en/workflows.md)
- Limits:
  - 16 concurrent agents by default (`CLAUDE_CODE_WORKFLOW_MAX_CONCURRENT_AGENTS`, 1–256, v2.1.269+).
  - 4,096 items per `parallel`/`pipeline`.
  - 1,000 agents per run.
  - No mid-run user input; a run pauses only for agent permission prompts and usage-limit waits.
  - A "Large workflow" warning appears above 25 agents or about 1.5M projected tokens.
  - Size guideline `workflowSizeGuideline`: small <5, medium <10 (default), large <50.
  
  Source: [workflows.md](https://code.claude.com/docs/en/workflows.md)
- Lifetime and resume: a run is "Resumable in the same session". If you exit or background the session, "the run doesn't continue on its own". Claude must relaunch it with a `Workflow` call, which replays saved results. The run script is saved under `~/.claude/projects/` — [workflows.md](https://code.claude.com/docs/en/workflows.md)
- Results: intermediate results stay in script variables, and only the final report reaches the session. Progress is visible in `/workflows`, where `s` saves a run as a command — [workflows.md](https://code.claude.com/docs/en/workflows.md)
- Permissions: in the CLI there is a per-run approval prompt (auto mode asks on first launch only). In `-p` and the SDK there's no prompt. There, a `Workflow` / `Workflow(<name>)` allow rule, auto mode, bypass mode, a PreToolUse hook `allow`, or a host callback is needed — [workflows.md](https://code.claude.com/docs/en/workflows.md)
- Plugin distribution: put scripts in plugin `workflows/` (or the `workflows` manifest field). They run as `/<plugin>:<meta.name>` — [workflows.md](https://code.claude.com/docs/en/workflows.md), [plugin components](https://code.claude.com/docs/en/plugins/components.md)
- Disable with `disableWorkflows: true` or `CLAUDE_CODE_DISABLE_WORKFLOWS=1`. On Pro, turn workflows on in `/config` — [workflows.md](https://code.claude.com/docs/en/workflows.md)
- Announced 2026-05-28 and now "generally available". On by default for Max/Ultra/Team/Enterprise and API use — [claude.com blog](https://claude.com/blog/introducing-dynamic-workflows-in-claude-code)
- The `ultracode` keyword doesn't trigger from `-p` prompts, scheduled task prompts, webhooks or PR comments — [workflows.md](https://code.claude.com/docs/en/workflows.md)

**Monitor tool**
- "Runs a command in the background and feeds each output line back to Claude ... Can also open a WebSocket and treat each incoming message as an event". It follows Bash permission rules. Each watch has a deadline of 5 min by default, at most 30 min, and at most 10 min in `-p`. At the deadline Claude gets one notice so it can restart the watch. Windows requires Git Bash — [Tools reference](https://code.claude.com/docs/en/tools-reference.md)
- `/loop` without an interval may use Monitor instead of polling, which is "often more token-efficient" — [scheduled-tasks.md](https://code.claude.com/docs/en/scheduled-tasks.md)
- Plugin monitors live in `monitors/monitors.json` (or the `experimental.monitors` manifest key, so **experimental**). They start at session start, or on first use of a named skill via `when`, and run "until it ends". They don't start in `-p`. They can't use `${user_config.*}`. They run outside the sandbox with full user permissions. Disabling the plugin doesn't stop running monitors — [plugin components](https://code.claude.com/docs/en/plugins/components.md)

**Task lists**
- `TaskCreate`/`TaskGet`/`TaskList`/`TaskUpdate` are "available by default only on Opus 4.7, Sonnet 4.6, Haiku 4.5, and earlier models" (v2.1.268+). Opt in with `CLAUDE_CODE_ENABLE_TODO_TOOLS=1`, `--allowedTools`, `--tools`, or the SDK options. Background and cloud sessions always get them. `TodoWrite` is disabled in favour of the Task tools (`CLAUDE_CODE_ENABLE_TASKS=0` re-enables it) (**changed**) — [tools-reference.md](https://code.claude.com/docs/en/tools-reference.md)
- Agents without the Task tools coordinate through messages instead of the shared team task list — [agent-teams.md](https://code.claude.com/docs/en/agent-teams.md)

**`/goal`**
- `/goal <condition>` keeps Claude taking turns until a small fast model judges the condition met or impossible. It is "a wrapper around a session-scoped prompt-based Stop hook". It works in `-p`, Desktop and Remote Control. One goal per session; it is restored on resume. Evaluation is deferred while subagents or background shells run, with idle check-ins after 30 min (`CLAUDE_CODE_GOAL_CHECKIN_MINUTES`). It's unavailable when `disableAllHooks` is set — [Keep Claude working toward a goal](https://code.claude.com/docs/en/goal.md)

### Inferences
- A plugin that needs a repeatable fan-out/verify pattern should ship it as a plugin workflow script rather than a skill that tells Claude to spawn agents. Workflows give caps, resume and progress UI. The catch is that a run doesn't continue across a session exit.
- Plugin monitors plus hooks with `asyncRewake` are the two plugin-native ways to push events into a lead session without polling.

### Gaps
- The `Workflow` tool's input schema (Agent SDK TS reference `#workflow`) wasn't fetched.
- The plugin monitor `when` field and full schema are in the manifest reference, which wasn't fetched.

## Q4. Human-in-the-loop: notifications, permission prompts, AskUserQuestion, hooks, channels, escalation from background jobs

### Takeaway
A background job can escalate to the human in several ways:
- The `PushNotification` tool: a desktop notification, or a phone push with Remote Control or in a cloud session.
- Remote Control mobile push toggles.
- Agent view OS notifications plus the `Notification` hook (`agent_needs_input`, `agent_completed`).
- Desktop OS notifications and Dispatch pushes.
- Two-way chat channels (Telegram, Discord, iMessage), which can relay permission prompts.

Permission prompts from subagents and teammates surface in the lead. Prompts in background or cloud sessions wait in that session until someone answers.

### Cited Findings
- `PushNotification` "Sends a desktop notification from a local session, and a phone push with Remote Control or in a cloud session". It isn't available on Bedrock/Vertex/Foundry — [tools-reference.md](https://code.claude.com/docs/en/tools-reference.md)
- `SendUserFile` sends files to the user's device when a Remote Control client is connected or in a cloud session — [tools-reference.md](https://code.claude.com/docs/en/tools-reference.md)
- Remote Control mobile push: in `/config`, enable "Push when Claude decides" and/or "Push when actions required". There is "no per-event configuration". Pushes are skipped while you're focused on the terminal (`CLAUDE_CLIENT_PRESENCE_FILE` extends this) — [remote-control.md](https://code.claude.com/docs/en/remote-control.md)
- Agent view: "Claude Code sends a notification through your configured terminal notification channel when a local background session needs input, finishes, or fails" (only while agent view is open). v2.1.198 also fires the `Notification` hook with type `agent_needs_input` or `agent_completed` — [agent-view.md](https://code.claude.com/docs/en/agent-view.md)
- Desktop: "sends an OS notification when a Code session finishes a task and you aren't currently viewing that session". Dispatch-spawned sessions push to the phone — [desktop.md](https://code.claude.com/docs/en/desktop.md)
- `AskUserQuestion`: questions stay open until answered by default. Since v2.1.200 there's no auto-continue, with an opt-in idle timeout. The timer never starts in background sessions or with Remote Control connected — [tools-reference.md](https://code.claude.com/docs/en/tools-reference.md), [release v2.1.200](https://api.github.com/repos/anthropics/claude-code/releases/tags/v2.1.200)
- Headless: `--permission-prompts none` (v2.1.259+) denies anything that would prompt and removes `AskUserQuestion`. `permissions.denyInsteadOfPrompting` makes this persistent. `--permission-prompt-tool` / SDK `canUseTool` route approvals to a host. Since v2.1.302, `-p` runs start in Manual mode when nothing sets a mode — [Run Claude Code programmatically](https://code.claude.com/docs/en/headless.md)
- Hook events (full list):
  - Setup, SessionStart, SessionEnd
  - UserPromptSubmit, UserPromptExpansion
  - PreToolUse, PermissionRequest, PermissionDenied, PostToolUse, PostToolUseFailure, PostToolBatch
  - Notification, MessageDisplay
  - SubagentStart, SubagentStop, TaskCreated, TaskCompleted, TeammateIdle
  - Stop, StopFailure
  - InstructionsLoaded, ConfigChange, CwdChanged, DirectoryAdded, FileChanged
  - WorktreeCreate, WorktreeRemove
  - PreCompact, PostCompact, PreModelSwitch, PostModelSwitch
  - Elicitation, ElicitationResult
  
  Source: [Hooks reference](https://code.claude.com/docs/en/hooks.md)
- `Notification` matchers: `permission_prompt`, `idle_prompt`, `auth_success`, `auth_storage_failure`, `elicitation_dialog`, `elicitation_url_dialog`, `elicitation_complete`, `elicitation_response`, `agent_needs_input`, `agent_completed`, `quota_auto_resume_fired`/`_stale`/`_disabled`, `plugin_notification`. `SessionStart` matchers include `fork` — [hooks.md](https://code.claude.com/docs/en/hooks.md)
- Hook types: `command`, `http`, `mcp_tool`, `prompt`, `agent` (experimental). `async: true` runs a hook in the background. `asyncRewake: true` "runs in the background and wakes Claude on exit code 2", with stderr shown as a system reminder. `additionalContext` injects context — [hooks.md](https://code.claude.com/docs/en/hooks.md)
- Stop/SubagentStop input includes `background_tasks`. v2.1.329 changed Monitor scripts to be listed as `monitor`, not `shell` — [CHANGELOG](https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md). The pending self-paced loop wakeup appears in `session_crons` in Stop hook input — [tools-reference.md](https://code.claude.com/docs/en/tools-reference.md)
- Channels (research preview):
  - "A channel is an MCP server that pushes events into your running Claude Code session".
  - It can be two-way: reply tools, plus permission relay for servers that declare it.
  - Official plugins exist for Telegram, Discord and iMessage, plus the fakechat demo; they need Bun.
  - Enable per session with `claude --channels plugin:<name>@<marketplace>`.
  - "Events only arrive while the session is open."
  - Requires claude.ai or Console auth, so not Bedrock/Vertex/Foundry.
  - Team/Enterprise need `channelsEnabled`; `allowedChannelPlugins` restricts which plugins can register.
  - During the preview only allowlisted plugins register; use `--dangerously-load-development-channels` for your own.
  
  Source: [Channels](https://code.claude.com/docs/en/channels.md)
- Slack: "Claude in Slack ... Spawns a cloud session from an `@Claude` mention". It is not a channel into a local session — [channels.md](https://code.claude.com/docs/en/channels.md)
- Permission prompts in cloud scheduled task runs wait in the run's session. Desktop scheduled runs stall on prompts until answered in that session. MCP tools marked `requiresUserInteraction` stall every run — [routines.md](https://code.claude.com/docs/en/routines.md), [desktop-scheduled-tasks.md](https://code.claude.com/docs/en/desktop-scheduled-tasks.md)
- Teammate and background-subagent permission prompts surface in the lead session — [agent-teams.md](https://code.claude.com/docs/en/agent-teams.md), [sub-agents.md](https://code.claude.com/docs/en/sub-agents.md)

### Inferences
- The most portable escalation for a plugin is a `Notification` hook (shell/http) on `permission_prompt` / `idle_prompt` / `agent_needs_input`, plus guidance to use `PushNotification`. Channels give real two-way remote control but need `--channels` on the command line and an allowlisted plugin, so a third-party plugin's channel needs the development flag or an org allowlist during the preview.

### Gaps
- The exact Stop/SubagentStop/TaskCompleted input field schemas: the hooks page was truncated at 100k characters.
- The `preferredNotifChannel` values weren't fetched.

## Q5. Custom orchestrators: Agent SDK, headless `claude -p`, session resume and fork, worktrees

### Takeaway
`claude -p` and the Agent SDK (`@anthropic-ai/claude-agent-sdk`, Python `claude-agent-sdk`) are the supported base for a custom orchestrator:
- JSON and stream-json output, with `total_cost_usd` and `session_id`.
- `--resume` / `--continue` / `forkSession`.
- Session listing APIs.
- Pluggable session storage for cross-host resume.
- `--bare` for reproducibility.

`-p` waits up to 10 min for background work, can't spawn teammates, and rejects `--bg`.

### Cited Findings
- `claude -p` rejects `--bg`. `--cloud <session-id> -p` queues a message into a cloud session and exits — [headless.md](https://code.claude.com/docs/en/headless.md)
- `--bare` skips auto-discovery of hooks, skills, commands, subagents, plugins, MCP, memory and CLAUDE.md. It uses `ANTHROPIC_API_KEY` only. It disables background commands and background subagents (since v2.1.286). It "will become the default for `-p` in a future release" — [headless.md](https://code.claude.com/docs/en/headless.md)
- Background work at exit: `-p` stays open for background commands, subagents, workflows, Monitor watches and pending `/loop` wakeups. Idle waiting is capped at 10 min (`CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS`). `--max-budget-usd` stops the wait. MCP background tasks aren't waited for — [headless.md](https://code.claude.com/docs/en/headless.md)
- Output: `--output-format json|stream-json`, `--json-schema` → `structured_output`. Subagent messages carry `parent_tool_use_id` (`--forward-subagent-text` adds text). The `system/init` event lists `plugins`, `plugin_errors`, `mcp_servers` and `mcp_server_errors` for CI gating — [headless.md](https://code.claude.com/docs/en/headless.md)
- Resume: `--continue`, or `--resume <id|path.jsonl>`, which works from any directory on the same machine. SIGTERM exits with 143 and leaves the turn unfinished. `CLAUDE_CODE_RESUME_INTERRUPTED_TURN=1` continues it on resume — [headless.md](https://code.claude.com/docs/en/headless.md)
- SDK sessions:
  - `continue` / `resume` / `forkSession` (TS) or `fork_session` (Py). `persistSession: false` (TS) avoids writing to disk.
  - Transcripts live at `~/.claude/projects/<encoded-cwd>/*.jsonl`.
  - `listSessions()`, `getSessionMessages()`, `getSessionInfo()`, `renameSession()`, `tagSession()`.
  - A `SessionStore` adapter enables cross-host resume.
  - The TS "V2 session API ... was removed in TypeScript Agent SDK 0.3.142" (**removed**).
  
  Source: [Agent SDK sessions](https://code.claude.com/docs/en/agent-sdk/sessions.md)
- A long-running `-p` worker can receive cross-session messages; set `crossSessionInbound: accept` via `--settings` — [cross-session-messaging.md](https://code.claude.com/docs/en/cross-session-messaging.md)
- Worktrees: the `--worktree` flag and `.worktreeinclude` are covered by a dedicated page — [index](https://code.claude.com/docs/llms.txt). The `EnterWorktree` tool creates or switches into a worktree and `ExitWorktree` leaves it (v2.1.327 makes it ask before removing a worktree with possibly unsaved work). Both are removed when `permissions.blockWritesOutsideWorkingDirectories` is on — [tools-reference.md](https://code.claude.com/docs/en/tools-reference.md), [CHANGELOG](https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md)
- Subagents can use `isolation: worktree`. Agent teams don't isolate teammates in worktrees — [agents.md](https://code.claude.com/docs/en/agents.md)

### Inferences
- An external orchestrator (cron, CI or a daemon) driving `claude -p --output-format json --resume` is the most controllable way to get "survives reboot" behaviour on a local machine, since background sessions don't survive a reboot and Desktop tasks need the app open.

### Gaps
- The worktrees page (`--worktree`, `.worktreeinclude`, cleanup) and the SDK hosting page weren't fetched in detail.

## Q6. Plugin system: what a plugin can ship, and the limits relevant to orchestration

### Takeaway
A plugin can ship skills, commands, agents, hooks, MCP servers, LSP servers, monitors, output styles, themes, workflows, channels, `bin/` executables, `userConfig`, and mods (JS hook modules). The key restrictions: plugin agents can't carry `hooks`, `mcpServers`, `permissionMode` or `initialPrompt`; monitors don't run in `-p`; channels need `--channels` and an allowlist; and agent teams depend on an env var.

### Cited Findings
- Components and their default locations: `.claude-plugin/plugin.json`, `skills/<name>/SKILL.md`, `commands/*.md` (the older format), `agents/**/*.md`, `hooks/hooks.json`, `monitors/monitors.json`, `output-styles/*.md`, `themes/*.json` (`experimental.themes`), `workflows/*.js`, `bin/`, `.mcp.json`, `.lsp.json`, plus `channels` and `userConfig` manifest keys — [Add components to a plugin](https://code.claude.com/docs/en/plugins/components.md)
- Plugin agents support `name`, `description`, `model`, `effort`, `maxTurns`, `autoCompactWindow`, `tools`, `disallowedTools`, `skills`, `memory`, `background`, `omitClaudeMd`, `isolation` (only `"worktree"`), `color` and `experimental.cacheTtl`. They ignore `permissionMode`, `hooks`, `mcpServers` and `initialPrompt` — [plugin components](https://code.claude.com/docs/en/plugins/components.md)
- Plugin hooks register when the plugin loads and fire on all their events, not only when the plugin's skills run. Env vars: `CLAUDE_PLUGIN_ROOT`, `CLAUDE_PLUGIN_DATA` (persistent, `~/.claude/plugins/data/<id>/`), `CLAUDE_PROJECT_DIR`, `CLAUDE_PLUGIN_OPTION_<KEY>`. A `modules` key in `hooks/hooks.json` makes the plugin a "mod" — [plugin components](https://code.claude.com/docs/en/plugins/components.md), [hooks.md](https://code.claude.com/docs/en/hooks.md)
- Plugin MCP tool names follow `mcp__plugin_<plugin>_<server>__<tool>` — [plugin components](https://code.claude.com/docs/en/plugins/components.md)
- A plugin doesn't load a root `CLAUDE.md`. Instructions must go in skills — [plugin components](https://code.claude.com/docs/en/plugins/components.md)
- claude.ai and Cowork don't install plugins with a top-level `bin/` — [plugin components](https://code.claude.com/docs/en/plugins/components.md)
- Plugins load in headless and CI too: `--plugin-dir`/`--plugin-url`, and `plugins` inputs in claude-code-action — [headless.md](https://code.claude.com/docs/en/headless.md), [github-actions.md](https://code.claude.com/docs/en/github-actions.md)
- In Projects, cloud threads load only plugins added in Project settings — [claude-projects.md](https://code.claude.com/docs/en/claude-projects.md)
- Plugin workflows are namespaced as `/<plugin>:<name>`. Running one by name offers "don't ask again for `<name>` in `<path>`" — [workflows.md](https://code.claude.com/docs/en/workflows.md)
- Subagent-definition skills: plugin subagents can be used as agent-team teammate types — [agent-teams.md](https://code.claude.com/docs/en/agent-teams.md)

### Inferences
- What a plugin can reach, by mechanism:
  - Model-invocable tools (Agent, SendMessage, ListAgents, CronCreate, ScheduleWakeup, RemoteTrigger, Monitor, Workflow, PushNotification): a plugin can steer them through skills, agents and workflows, but can't add new built-in tools beyond MCP.
  - Hooks (Stop, SubagentStop, TaskCompleted, TeammateIdle, Notification, with `asyncRewake`): plugin-native.
  - Session-spawning (`claude --bg`) and cross-machine features: reachable only through Bash or `bin/` scripts, and they depend on user auth (claude.ai login) and settings.

### Gaps
- Plugin-level `settings.json` (which keys a plugin may set, e.g. whether it can set `env` such as `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` or `agent`) wasn't fetched. Check [plugin manifest reference](https://code.claude.com/docs/en/plugins/manifest-reference.md).
- The monitor `when` field and full manifest field tables weren't fetched.

## Q7. Changelog: what changed between 2026-06 and 2026-11

### Takeaway
Release dates anchor the June–November 2026 window at roughly v2.1.170 (2026-06-09) to v2.1.329 (2026-11-19). Major orchestration additions in that window:
- Cross-session messaging (v2.1.224, 2026-08-07).
- The `/fork` vs `/subtask` split (v2.1.212).
- Agent view notifications and auto-PR (v2.1.198).
- `notify_when_idle` (v2.1.236).
- The Task tools default change (v2.1.268) and `TaskOutput` removal (v2.1.277).
- Workflow usage-limit pausing (v2.1.271).
- Routines renamed to cloud scheduled tasks.

Agent view, `/goal` (2026-05-11), dynamic workflows (2026-05-28) and routines (2026-04-14) predate the window but kept evolving through it.

### Cited Findings
- Date anchors from GitHub releases:
  - v2.1.139 = 2026-05-11 ([link](https://api.github.com/repos/anthropics/claude-code/releases/tags/v2.1.139))
  - v2.1.170 = 2026-06-09 ([link](https://api.github.com/repos/anthropics/claude-code/releases/tags/v2.1.170))
  - v2.1.200 = 2026-07-03 ([link](https://api.github.com/repos/anthropics/claude-code/releases/tags/v2.1.200))
  - v2.1.224 = 2026-08-07 ([link](https://api.github.com/repos/anthropics/claude-code/releases/tags/v2.1.224))
  - v2.1.260 = 2026-09-03 ([link](https://api.github.com/repos/anthropics/claude-code/releases/tags/v2.1.260))
  - v2.1.300 = 2026-10-14 ([link](https://api.github.com/repos/anthropics/claude-code/releases/tags/v2.1.300))
  - v2.1.327–329 = 2026-11-17 to 2026-11-19 ([link](https://api.github.com/repos/anthropics/claude-code/releases?per_page=100))
- v2.1.139 (2026-05-11, before the window): agent view (research preview) and `/goal` added — [release](https://api.github.com/repos/anthropics/claude-code/releases/tags/v2.1.139)
- Dynamic workflows announced 2026-05-28 and now GA — [blog](https://claude.com/blog/introducing-dynamic-workflows-in-claude-code)
- v2.1.196/v2.1.198 (about late June 2026):
  - Single `←` backgrounds a session.
  - Background shell commands survive restarts.
  - Agent view notifications plus `Notification` hook `agent_needs_input`/`agent_completed`.
  - Worktree-isolated background sessions open draft PRs.
  - "Move to background and exit".
  - `claude --bg` rejected with `-p`.
  
  Source: [agent-view.md version history](https://code.claude.com/docs/en/agent-view.md)
- `/agents` wizard removed after v2.1.197 — [sub-agents.md](https://code.claude.com/docs/en/sub-agents.md)
- v2.1.200 (2026-07-03): `AskUserQuestion` no longer auto-continues, and the default permission mode was renamed "Manual" (**renamed**) — [release](https://api.github.com/repos/anthropics/claude-code/releases/tags/v2.1.200). Remote Control `--continue`/`--session-id` (v2.1.200+) — [remote-control.md](https://code.claude.com/docs/en/remote-control.md)
- v2.1.212: `/fork` became "copy into background session" and the forked subagent moved to `/subtask` (**renamed**) — [agent-view.md](https://code.claude.com/docs/en/agent-view.md)
- v2.1.224 (2026-08-07): cross-session `SendMessage` + `ListAgents`, `crossSessionInbound`, `dialogExpiry` — [release](https://api.github.com/repos/anthropics/claude-code/releases/tags/v2.1.224)
- v2.1.225: GitHub triggers for cloud scheduled tasks from the CLI, and messaging sessions on other machines. v2.1.227: `/schedule` run-history questions — [routines.md](https://code.claude.com/docs/en/routines.md), [cross-session-messaging.md](https://code.claude.com/docs/en/cross-session-messaging.md)
- v2.1.234: cross-session messaging on native Windows; `teammateDefaultModel` removed — [cross-session-messaging.md](https://code.claude.com/docs/en/cross-session-messaging.md), [agent-teams.md](https://code.claude.com/docs/en/agent-teams.md)
- v2.1.236: `notify_when_idle` — [cross-session-messaging.md](https://code.claude.com/docs/en/cross-session-messaging.md)
- v2.1.248: `/workflow-authoring` bundled skill — [workflows.md](https://code.claude.com/docs/en/workflows.md)
- v2.1.259: `--permission-prompts none` — [headless.md](https://code.claude.com/docs/en/headless.md)
- v2.1.268: Task tools on by default only for older models (**changed**) — [tools-reference.md](https://code.claude.com/docs/en/tools-reference.md)
- v2.1.269: `CLAUDE_CODE_WORKFLOW_MAX_CONCURRENT_AGENTS`. v2.1.271: workflows pause at usage limits; `SubagentHandback` — [workflows.md](https://code.claude.com/docs/en/workflows.md), [tools-reference.md](https://code.claude.com/docs/en/tools-reference.md)
- v2.1.277: `TaskOutput` removed (**removed**) — [tools-reference.md](https://code.claude.com/docs/en/tools-reference.md)
- v2.1.280: Projects threads on your own computer via Remote Control — [claude-projects.md](https://code.claude.com/docs/en/claude-projects.md)
- v2.1.286: `--bare` disables background tasks. v2.1.292: Agent tool `effort` parameter — [headless.md](https://code.claude.com/docs/en/headless.md), [sub-agents.md](https://code.claude.com/docs/en/sub-agents.md)
- v2.1.300 (2026-10-14): Remote Control `--sandbox`/`--no-sandbox` removed (**removed**) — [remote-control.md](https://code.claude.com/docs/en/remote-control.md)
- v2.1.302: `-p` defaults to Manual mode. v2.1.310: Monitor and plugin monitors on third-party providers or with telemetry off. v2.1.318: workflow reruns after usage-limit failures — [headless.md](https://code.claude.com/docs/en/headless.md), [tools-reference.md](https://code.claude.com/docs/en/tools-reference.md), [workflows.md](https://code.claude.com/docs/en/workflows.md)
- v2.1.326–329 (2026-11-17 to 2026-11-19), selected:
  - `/tasks` now shows scheduled tasks, loop wakeups, the goal and forks.
  - "Exit and stop tasks" ends scheduled tasks.
  - Stop/SubagentStop `background_tasks` lists monitors as `monitor`.
  - `onFailure: "block"` for `mcp_tool` hooks.
  - Nested subagents in `-p`, SDK, desktop and VS Code now wait for their own subagents.
  - `/list-agents` output shown only to the user.
  - `ExitWorktree` asks before removing a worktree with possibly unsaved work.
  - Code Mode compatible with agent teams.
  
  Source: [CHANGELOG](https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md)
- Routines launched 2026-04-14 (secondary) and were later renamed "scheduled tasks"; the docs acknowledge the old name — [Tessl](https://tessl.io/blog/anthropic-adds-routines-to-claude-code-for-scheduled-agent-tasks/), [routines.md](https://code.claude.com/docs/en/routines.md)

### Inferences
- Version-to-date mapping between anchors is approximate. Linear interpolation is mine; the docs don't date individual versions.

### Gaps
- The CHANGELOG has no dates and is over 1.3M characters. Only the top (v2.1.326–329) was read in full. Introduction versions for channels, `PushNotification`, plugin monitors, the `RemoteTrigger` tool, Projects, and the routines rename weren't pinned to specific versions or dates.
- The Claude Code GitHub Action's release history (v1.x changes in the window) wasn't checked.
