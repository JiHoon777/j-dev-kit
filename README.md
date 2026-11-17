# j-dev-kit

**English** | [한국어](README.ko.md)

A personal Claude Code plugin marketplace. The work loop is a single `/task` skill; checks that differ per stack live in stack plugins. Only the checks of enabled plugins run, and enabling several at once causes no conflicts.

## Contents

| Plugin | Skills · agents | Installed along with it |
| --- | --- | --- |
| `workflow` | `/task create`, `/task start`, `/task end` | `superpowers` |
| `frontend` (+ `workflow`) | `frontend-start-check`, `frontend-end-check` (references: svelte, react), agents `ui-reviewer`, `svelte-reviewer`, `react-reviewer` | `chrome-devtools-mcp`, `typescript-lsp`, `frontend-design`, `modern-web-guidance` |
| `supabase` (+ `workflow`) | `supabase-start-check`, `supabase-end-check`, agent `rls-reviewer`, read-only MCP server `supabase-readonly` | `supabase` (official: skills, MCP) |
| `server` (+ `workflow`) | `server-start-check`, `server-end-check` (references: node, python, go, jvm), agent `api-reviewer` | — |

### File layout

Follows the official skill layout (`SKILL.md` plus `references/` that are read only when needed).

```
plugins/workflow/skills/task/
  SKILL.md                 routes by argument (create · start · end) and reads only that reference
  references/create.md, start.md, end.md
plugins/frontend/
  agents/                  ui-reviewer, svelte-reviewer, react-reviewer
  skills/frontend-start-check/  SKILL.md (common) + references/svelte.md, react.md
  skills/frontend-end-check/    SKILL.md (common) + references/svelte.md, react.md
plugins/server/
  agents/api-reviewer.md
  skills/server-start-check/    SKILL.md (common) + references/node.md, python.md, go.md, jvm.md
  skills/server-end-check/      (same layout)
plugins/supabase/
  agents/rls-reviewer.md, skills/supabase-start-check, supabase-end-check
i18n/ko/plugins/…          Korean translations (Claude does not read them)
```

- **English is the source; translations live in `i18n/ko/`** with the same paths, each starting with a link to its source. When a source changes, update its translation too. Reports to the user and backlog items are written in the language the project's CLAUDE.md sets (otherwise the conversation's language).
- **Framework- and language-specific content lives in references.** A check skill detects the project (`svelte`/`react` in package.json, `go.mod`, `pyproject.toml`, …), **reads the matching reference in full**, and runs its checks too. If several match, it reads all of them.

### How stack plugins plug in

- `/task start` invokes every available skill whose name ends with **`-start-check`**; `/task end` invokes every one ending with **`-end-check`**.
- Disabling a plugin removes its skills from the list, so its checks drop out. An enabled check that does not apply to the project returns only "not applicable".
- **Check skills only run commands.** Gathering information by reading code is returned as `Explore` agent prompts, and reviews that judge the diff are handed to the plugin's review agents. `/task start` and `/task end` launch them together with the default agents in parallel. The main conversation never searches or reviews by itself.
- What check skills return:
  - Start: a result table, a **baseline**, **exploration prompts**, items to add to the plan, questions to ask, **rules during implementation**, and **things to do before finishing**
  - End: a result table (only failures that are new compared with the baseline), **agents to add to the review**, and **things to do after fixes**
- To add a stack, create `plugins/<stack>/skills/<stack>-start-check` and `<stack>-end-check` in the same format and register the plugin in `marketplace.json`. Variants within a stack (frameworks, languages) are added as references, not as separate plugins.

## Flow

```
/task create ──► docs/backlog/001-….md ──/task start──► stack start checks ──► plan mode (explore · ask · design) ──► approval ──► implement on a w/ branch
                                                                                                                                │
docs/done/001-….md ◄── merge ◄── approval ◄── fixes ◄── user picks ◄── review agents in parallel ◄── stack end checks ◄── /task end
```

### Where it comes from

Not a newly invented procedure: proven workflows chained together. How each source works is not changed.

| Step | Source | How |
| --- | --- | --- |
| Item format, good items, definition of done | [Backlog.md](https://github.com/MrLesk/Backlog.md) agent guidelines | Format and rules adopted |
| Clarifying what and why in `/task create` | `superpowers:brainstorming` | Invoked as is |
| Exploration, questions, design options in `/task start` | Anthropic `feature-dev` plugin, phases 2–4 | Structure carried over as is |
| Plan approval in `/task start` | Claude Code plan mode, `feature-dev` phase 5 | As is |
| Implementation and verification in `/task start` | `superpowers:test-driven-development`, `verification-before-completion` | Invoked as is |
| Building or redesigning a screen | Anthropic `frontend-design` | Invoked as is (frontend) |
| Browser testing | Chrome DevTools plugin's `chrome-devtools` skill | Invoked as is (frontend) |
| Svelte autofix and docs | Official Svelte plugin (`svelte-autofixer`, docs MCP) | Invoked if installed, otherwise a version-pinned CLI (frontend/svelte) |
| React rules | `eslint-plugin-react-hooks`, React Doctor, Vercel `react-best-practices` | Tools run, skill invoked (frontend/react) |
| Review in `/task end` | Built-in skills `code-review`, `security-review`, `simplify` + stack review agents | One per agent, invoked as is |
| How reviews run and are reported in `/task end` | `feature-dev` phase 6 and its `code-reviewer` prompt (only the 80-point cutoff removed) | Structure and prompt carried over as is |
| Handling findings in `/task end` | `superpowers:receiving-code-review` | Invoked as is |
| Approval and merge in `/task end` | `superpowers:finishing-a-development-branch` | Invoked as is |
| API review criteria | OWASP API Security Top 10 2023, OWASP Logging Cheat Sheet, Google AIP-180 | Turned into check items |

Compared and not used: Compound Engineering (38 skills; replaces the whole flow), superpowers' planning and execution skills (`writing-plans`, `executing-plans`, `subagent-driven-development`, `using-git-worktrees`; they overlap this flow), `vercel-plugin` (only the React rules were needed, but it brings session hooks, telemetry, and deployment skills).

## Install

Run these inside Claude Code (or as `claude plugin …` in a terminal). Add the marketplaces first; a stack plugin's dependencies come from them.

```
/plugin marketplace add JiHoon777/j-dev-kit
/plugin marketplace add GoogleChrome/modern-web-guidance   # needed by frontend
/plugin marketplace add ChromeDevTools/chrome-devtools-mcp  # needed by frontend
/plugin install frontend@j-dev-kit
/plugin install supabase@j-dev-kit
/plugin install server@j-dev-kit
```

- Install only the stacks you use. Every stack plugin depends on `workflow`, so installing any of them also installs and enables `/task` and `superpowers`.
- `anthropic-plugin-directory` (superpowers, frontend-design, typescript-lsp, supabase) is built into Claude Code; there is nothing to add for it.
- `/plugin install` uses the user scope (every project) by default. To enable plugins for one repository only, use `claude plugin install <name>@j-dev-kit --scope project` (see below).

For Svelte projects the official Svelte plugin is recommended too (checks still run without it through a version-pinned CLI).

```
/plugin marketplace add sveltejs/ai-tools
/plugin install svelte@svelte
```

### Pin it to a project

Run the installs with `--scope project` in the repository. Claude Code writes the marketplaces and every plugin, **including dependencies**, into `.claude/settings.json`. Commit that file; anyone who opens the repository is offered the same setup and installs it once with the same commands.

```bash
claude plugin marketplace add JiHoon777/j-dev-kit --scope project
claude plugin marketplace add GoogleChrome/modern-web-guidance --scope project
claude plugin marketplace add ChromeDevTools/chrome-devtools-mcp --scope project
claude plugin install frontend@j-dev-kit --scope project
claude plugin install supabase@j-dev-kit --scope project
```

The result looks like this (frontend + supabase + Svelte):

```json
{
  "extraKnownMarketplaces": {
    "j-dev-kit": { "source": { "source": "github", "repo": "JiHoon777/j-dev-kit" } },
    "chrome-devtools-plugins": { "source": { "source": "github", "repo": "ChromeDevTools/chrome-devtools-mcp" } },
    "googlechrome": { "source": { "source": "github", "repo": "GoogleChrome/modern-web-guidance" } },
    "svelte": { "source": { "source": "github", "repo": "sveltejs/ai-tools" } }
  },
  "enabledPlugins": {
    "frontend@j-dev-kit": true,
    "supabase@j-dev-kit": true,
    "workflow@j-dev-kit": true,
    "superpowers@anthropic-plugin-directory": true,
    "frontend-design@anthropic-plugin-directory": true,
    "typescript-lsp@anthropic-plugin-directory": true,
    "chrome-devtools-mcp@chrome-devtools-plugins": true,
    "modern-web-guidance@googlechrome": true,
    "supabase@anthropic-plugin-directory": true,
    "svelte@svelte": true
  }
}
```

**Do not delete the dependency entries** when tidying this file. A plugin whose dependency is not enabled does not load (`Dependency "workflow@j-dev-kit" is not installed`), and running the install again does not always restore every dependency.

### What to put in the project's CLAUDE.md

```markdown
## Work settings
- stack: frontend, supabase                 # if missing, check skills infer it from files
- Base branch: main
- Verification command: pnpm verify         # lint, type check, tests, build in one go
- Lint command: pnpm lint
- Language: English                         # language for backlog items and reports

## superpowers
The rules in this document come first. Follow the skills that `/task` invokes (brainstorming,
test-driven-development, verification-before-completion, receiving-code-review,
finishing-a-development-branch) as they are. Do not use the other planning and execution skills
(writing-plans, executing-plans, subagent-driven-development, using-git-worktrees); they overlap this flow.
```

superpowers injects "if a skill might apply, you must use it" at every session start, and there is no switch to turn it off. Without the paragraph above saying CLAUDE.md comes first, it takes over the planning step of `/task start`.

### LSP per server language (optional)

The `server` plugin detects the language and suggests installing the matching LSP plugin when missing: `pyright-lsp`, `gopls-lsp`, `jdtls-lsp`, `typescript-lsp` from the built-in `anthropic-plugin-directory`. The executables (`pyright-langserver`, `gopls`, …) are installed separately.

## Usage

```
/task create Add a login screen with email and password   # writes docs/backlog/001-….md after you approve it
/task start 001                                           # plans it in plan mode, then implements on w/001-…
/task end                                                 # reviews, fixes what you pick, closes the item, merges after approval
```

- **First `/task create` in a project** proposes creating `docs/backlog/` (README, `_template.md`) and `docs/done/`, and asks for your labels.
- **`/task start`** stops first if there are uncommitted changes or another `w/` branch. It runs the stack start checks, then in plan mode explores the code with parallel agents, asks its questions in one list, offers three design options with a recommendation, and waits for your approval before creating the branch. Implementation happens in the main conversation, test first, with a commit per step.
- **`/task end`** runs the stack end checks and the review agents in parallel, shows every finding with a confidence score, and asks per finding: fix now, fix later (a new backlog item), or leave it. After fixes it re-tests, moves the item to `docs/done/`, and offers merge options. It never pushes unless you ask.
- **With no argument,** `/task` shows the three modes and asks which one to run.

## Update

Updates are **by version**. Claude Code caches each installed plugin under its version (`~/.claude/plugins/cache/j-dev-kit/<plugin>/<version>/`) and only replaces it when the version in `plugin.json` goes up. A new commit with the same version is ignored ("already at the latest version").

To pick up a new release:

```bash
claude plugin marketplace update j-dev-kit
claude plugin update workflow@j-dev-kit --scope project    # repeat for each installed plugin, with the scope you installed it in
```

Then **restart Claude Code**; a running session keeps the old skill text.

### Releasing a change (maintainer)

1. Bump `version` in the `plugin.json` of **every plugin whose files changed** (and the `version` in those plugins' SKILL.md frontmatter). Without a bump, nobody receives the change.
2. `claude plugin validate .` and `claude plugin validate plugins/<name>`.
3. Commit and push.

## Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| `Dependency "…" not found. Is the "…" marketplace added?` while installing | Add the marketplace named in the message (see Install), then install again. |
| `Dependency "…" is not installed` in `claude plugin list` | A dependency was removed from `enabledPlugins`. Install the missing plugin with the command in the message (same `--scope`). |
| `/task start` does not run any stack check | The stack plugin is not enabled in this project, or it reports "not applicable" for this project (check `stack:` in CLAUDE.md). |
| superpowers starts its own brainstorming or plan files | Add the superpowers paragraph above to the project's CLAUDE.md. |
| A pushed change does not show up after updating | The plugin's `version` was not bumped, or Claude Code was not restarted (see Update). |

## Good to know

- **One owner for migrations.** If a server migration tool (Prisma, Drizzle, TypeORM, Alembic, Django, Atlas, Flyway, Liquibase, golang-migrate) is present, the `server` plugin owns migration checks, even on Supabase Postgres. Otherwise, if `supabase/migrations/` exists, the `supabase` plugin owns them. If both exist, the checks ask which one is the source of truth. The other plugin skips its migration items, so the same database is never checked twice.
- `/task` runs only when typed (`disable-model-invocation: true`). Saying "put this in the backlog" does not trigger it; use `/task create …`. This prevents `start` from running on its own.
- Dependencies point to the marketplaces Claude Code actually has: Anthropic's plugins come from the built-in `anthropic-plugin-directory` (superpowers, frontend-design, typescript-lsp, supabase), and Chrome DevTools from Google's own `chrome-devtools-plugins` marketplace. Do not also enable the same plugin from another marketplace (for example `supabase@claude-plugins-official`); the same MCP server would start twice.
- **External CLIs are version-pinned.** Tools that skills download and run with `npx` (React Doctor, `@sveltejs/mcp`, `sv`, `skills`) are pinned to versions published more than two weeks ago. To upgrade, check the new version and change only the number. Project tools (Prisma, Drizzle, TypeORM) use `npx --no-install` so only the project's installed copy runs. `modern-web-guidance` is left to its plugin's skill, with no command written here.
- **The Supabase MCP is read-only.** The `supabase` plugin bundles its own server, `supabase-readonly`, which connects with `read_only=true`. Which project it reads is set in the project's `.claude/.local/project.json` as `{ "supabaseMcpUrl": "https://<ref>.supabase.co" }`; the checks ask for it when it is missing. The first use asks you to sign in to Supabase (`/mcp`).
