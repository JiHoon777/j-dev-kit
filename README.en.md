# j-dev-kit

[한국어](README.md) | **English**

> Translation of README.md. The Korean README is the source.

A personal plugin marketplace for Claude Code. The workflow lives in a single `/task` skill, and checks that differ per stack are split into stack plugins. Only the checks of enabled plugins run.

There is one principle: **if you cannot say which failure a step prevents, leave it out.** Small work stays light; only big work gets heavy.

## Contents

| Plugin | Skills · agents | Installed along with it |
| --- | --- | --- |
| `workflow` | `/task create`, `/task start`, `/task end` | `superpowers` |
| `frontend` (+ `workflow`) | `frontend-start-check`, `frontend-end-check` (references: svelte, react), agent `frontend-reviewer` | `typescript-lsp`, `frontend-design` |
| `server` (+ `workflow`) | `server-start-check`, `server-end-check` (references: supabase), agents `api-reviewer`, `rls-reviewer` | — |

If you use Supabase (including calling it directly from the frontend), install `server`. Supabase checks and `rls-reviewer` turn on when `supabase/config.toml` or an `@supabase/` dependency is found.

### File structure

Follows the official skill structure (`SKILL.md` + `references/` read only when needed).

```
plugins/workflow/skills/task/
  SKILL.md                 picks one reference by argument (create·start·end)
  references/create.md, start.md, end.md
plugins/frontend/
  agents/frontend-reviewer.md
  skills/frontend-start-check/  SKILL.md + references/svelte.md, react.md
  skills/frontend-end-check/    SKILL.md + references/svelte.md
plugins/server/
  agents/api-reviewer.md, rls-reviewer.md
  skills/server-start-check/    SKILL.md + references/supabase.md
  skills/server-end-check/      (same structure)
i18n/en/…                  English translations (Claude does not read them)
```

- **English translations live in `i18n/en/`; the Korean in `plugins/` is the source.** They use the same path structure, and each translation links to its source at the top. When you change a source file, update its translation too. Reports the skills give the user and backlog items are written in the language set by the project's CLAUDE.md (or the conversation language if none).
- **Framework- and language-specific content goes in references.** A check skill detects the project and reads only the matching references.

### How stack plugins plug in

- `/task start` calls every skill whose name ends in `-start-check`, and `/task end` calls every skill whose name ends in `-end-check`. Disabling a plugin drops its checks too. If a check does not apply to the project, it returns only "Not applicable".
- What a start check returns: **Follow** (rules during implementation and skills to call), **Put in the plan**, **Ask**. Only what applies.
- What an end check returns: **failures** of the checks it ran (only when the change touched that area), **agents to add to the review**, **after fixing**.
- Check skills only run commands. Reviews that read the diff and make judgments are done by review agents.
- For a new stack, create `plugins/<stack>/skills/<stack>-start-check` and `<stack>-end-check` in the same format and register them in `marketplace.json`. Variants within the same stack (frameworks, languages) are added as references.

## Flow

```
/task create ──► docs/backlog/001-….md ──/task start──► baseline·stack checks ──► plan mode (sized to fit) ──► approval ──► implement on w/ branch ──► clean up·verify
                                                                                                                                │
docs/done/001-….md ◄── merge ◄── verify ◄── fix ◄── pick 🔴/🟡 ◄── review (code-review + matching reviewers) ◄── stack end checks ◄── /task end
```

- **`/task start`**: runs the verify command once to record a baseline and calls the stack start checks. Small items are planned right away without agents; only large items launch up to 2 `Explore` agents. At most 3 questions, only about things the code cannot answer. Implementation is test-first, and only what the item requires. At the end, cleans up with `simplify` and runs verification fresh once.
- **`/task end`**: launches in parallel `code-review` always, `security-review` only when authentication, input, secrets, etc. changed, and stack reviewers only when they apply. Findings are shown without scores as 🔴 Must fix / 🟡 Consider / ⚪ Minor (count only), and it asks per category. After fixing, it runs verification once, closes the item, and lets you choose how to merge. It does not push unless asked.

### Where it comes from

Proven flows stitched together. What to include and what to drop was decided by comparing popular repos and official guides.

| Part | Source |
| --- | --- |
| Item format, good items, definition of done | [Backlog.md](https://github.com/MrLesk/Backlog.md) agent guidelines |
| Refining vague requests | `superpowers:brainstorming` |
| At most 3 questions, the rest as assumptions | [github/spec-kit](https://github.com/github/spec-kit) `specify` |
| Planning sized to fit (small work without agents) | superpowers, [compound-engineering](https://github.com/EveryInc/compound-engineering-plugin) `ce-plan`·`ce-work` |
| Think before coding, keep it simple, only where needed, verify against the goal | [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) |
| Test first, verify once before done | `superpowers:test-driven-development`, `verification-before-completion` |
| Cleanup right after implementation | Built-in skill `simplify` (like the official `code-simplifier`, right after writing code rather than at review) |
| Review | Built-in skill `code-review`, conditional `security-review`, stack review agents (only those matching the change, the [pr-review-toolkit](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/pr-review-toolkit) approach) |
| Finding labels (categories instead of scores) | Claude Code Code Review (🔴 Important / 🟡 Nit), superpowers code-reviewer (Critical / Important / Minor) |
| Handling findings, finishing the branch | `superpowers:receiving-code-review`, `finishing-a-development-branch` |
| New screen design | Anthropic `frontend-design` |
| Svelte rules and autofixer | Official Svelte plugin (`svelte-code-writer`, `svelte-autofixer`) |
| React rules | Vercel `react-best-practices` |
| API review criteria | OWASP API Security Top 10 2023 |
| Supabase rules and checks | Official [supabase/agent-skills](https://github.com/supabase/agent-skills) security checklist, Supabase CLI (`db diff`, `db advisors`) |
| Skill authoring | Anthropic [Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) |

Deliberately left out: 3 design agents launched every time (feature-dev), per-stack baselines, dependency installs, Lighthouse, and React Doctor before work (none of the popular stack skills have them), 0–100 confidence scores (every reference uses them only for internal filtering), and `simplify` at the review stage.

## Installation

Run inside Claude Code (in a terminal, `claude plugin …`).

```
/plugin marketplace add JiHoon777/j-dev-kit
/plugin install frontend@j-dev-kit
/plugin install server@j-dev-kit
```

- Install only the stacks you use. Every stack plugin depends on `workflow`, so `/task` and `superpowers` are installed along with it.
- Dependency plugins come from `anthropic-plugin-directory`, which ships with Claude Code by default. You do not need to add another marketplace.
- To enable it for a single repository only, install with `--scope project` (below).

### Used if present (optional)

If installed, the skills call them; without them, the checks still run.

| Plugin · skill | Used for | Install |
| --- | --- | --- |
| Official Svelte plugin | Docs lookup, `svelte-code-writer`, autofixer MCP | `/plugin marketplace add sveltejs/ai-tools`, `/plugin install svelte@svelte` |
| Chrome DevTools | Browser checks (otherwise the app's built-in browser) | `/plugin marketplace add ChromeDevTools/chrome-devtools-mcp`, `/plugin install chrome-devtools-mcp@chrome-devtools-plugins` |
| `modern-web-guidance` | Choosing new web features and UI patterns | `/plugin marketplace add GoogleChrome/modern-web-guidance`, `/plugin install modern-web-guidance@googlechrome` |
| Vercel `react-best-practices` | Writing React components | `npx -y skills@1.7.5 add vercel-labs/agent-skills` |
| Official Supabase plugin | Rules for writing Supabase code | `/plugin install supabase@anthropic-plugin-directory` (the MCP server that comes with it is not read-only, so turning it off in `/mcp` is recommended) |
| Per-language LSP | Code diagnostics | `pyright-lsp`, `gopls-lsp`, `jdtls-lsp`, `typescript-lsp` (`anthropic-plugin-directory`; install the executables separately) |

For React projects, if you enable `recommended` from `eslint-plugin-react-hooks` and include linting in the verify command, `/task` does not need to check hook rules separately.

### Pinning to a project

```bash
claude plugin marketplace add JiHoon777/j-dev-kit --scope project
claude plugin install frontend@j-dev-kit --scope project
claude plugin install server@j-dev-kit --scope project
```

Claude Code writes the marketplace and the dependency plugins into `.claude/settings.json`. If you commit it, anyone who opens the repository is offered the same setup.

```json
{
  "extraKnownMarketplaces": {
    "j-dev-kit": { "source": { "source": "github", "repo": "JiHoon777/j-dev-kit" } }
  },
  "enabledPlugins": {
    "frontend@j-dev-kit": true,
    "server@j-dev-kit": true,
    "workflow@j-dev-kit": true,
    "superpowers@anthropic-plugin-directory": true,
    "frontend-design@anthropic-plugin-directory": true,
    "typescript-lsp@anthropic-plugin-directory": true
  }
}
```

When tidying this file, **do not delete the dependency plugin lines.** If you do, plugins that use them will not load.

### What to put in the project CLAUDE.md

```markdown
## Work settings
- stack: frontend, server                   # if absent, check skills infer it from files
- base branch: main
- verify command: pnpm verify               # lint, types, tests, build in one go
- document language: Korean                 # language for backlog items and reports

## superpowers
The rules in this document take precedence. Follow the skills `/task` calls (brainstorming, test-driven-development,
verification-before-completion, receiving-code-review, finishing-a-development-branch), and do not use
the other planning and execution skills (writing-plans, executing-plans, subagent-driven-development, using-git-worktrees),
since they overlap with this flow.
```

superpowers injects an instruction every session saying "if a skill seems to fit, you must use it". The paragraph above is needed so it does not hijack the planning step of `/task start`.

## Usage

```
/task create Add an email/password login screen  # after approval, creates docs/backlog/001-….md
/task start 001                                  # makes a plan, and after approval implements on a w/001-… branch
/task end                                        # reviews, fixes what you pick, closes the item, and merges after approval
```

- The first time you run `/task create` in a project, it offers to create `docs/backlog/` (README, `_template.md`) and asks for labels.
- `/task start` stops first if there are uncommitted changes or another `w/` branch.
- Calling just `/task` with no argument shows the three modes and asks.
- `/task` runs only when typed directly (`disable-model-invocation: true`).

## Updating

Claude Code updates a plugin only when the version in `plugin.json` has been bumped.

```bash
claude plugin marketplace update j-dev-kit
claude plugin update workflow@j-dev-kit --scope project    # for each installed plugin, with the scope used at install
```

Then restart Claude Code.

### Shipping changes (maintainer)

1. Bump `version` in `plugin.json` for every plugin whose files changed.
2. `claude plugin validate .` and `claude plugin validate plugins/<name>`.
3. Update the `i18n/en/` translations too.
4. Commit and push.

## Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| `supabase@j-dev-kit` cannot be found / does not load | It was merged into `server` in 0.4.0. Remove `supabase@j-dev-kit` (and `supabase@anthropic-plugin-directory` if you don't use it) from `enabledPlugins` in `.claude/settings.json` and install `server@j-dev-kit`. |
| `Dependency "…" is not installed` in `claude plugin list` | A dependency plugin was removed from `enabledPlugins`. Install it with the command in the message, using the same `--scope`. |
| `/task start` runs no stack checks at all | The stack plugin is disabled, or it decided it does not apply (check `stack:` in CLAUDE.md). |
| superpowers starts its own brainstorming or plan files | Add the superpowers paragraph above to the project CLAUDE.md. |
| Pushed changes do not show up after updating | `version` was not bumped, or Claude Code was not restarted. |

## Good to know

- **One migration owner.** If there is a server migration tool (Prisma, Drizzle, TypeORM, Alembic, Django, Atlas, Flyway, Liquibase, golang-migrate), that tool is the owner even if the DB is Supabase. If there is none and `supabase/` exists, the Supabase CLI is the owner. If both exist, it asks which one is the source of truth.
- **External CLIs are version-pinned.** Tools downloaded with `npx` (`@sveltejs/mcp`, `skills`) are pinned to versions published more than 2 weeks ago. Project tools (Prisma, Drizzle, TypeORM) are used only if installed, via `npx --no-install`.

### Supabase MCP (optional)

Supabase checks run with the CLI. If you want to use the MCP, connect it in the project `.mcp.json`, read-only and scoped to a single project (`<ref>` is the xxxx in `https://xxxx.supabase.co`). When connected, advisors are also called through the MCP.

```json
{
  "mcpServers": {
    "local_supabase": {
      "type": "http",
      "url": "https://mcp.supabase.com/mcp?read_only=true&project_ref=<ref>"
    }
  }
}
```

### Blocking Supabase writes via the CLI (optional)

The Supabase CLI and `psql` can make changes when connected to a remote project. To block them, add these to `permissions.deny` in the project `.claude/settings.json`. Local work (`supabase start`, `supabase db reset` without `--linked`, `psql` to `127.0.0.1`) still works.

```json
      "Bash(supabase link*)",
      "Bash(supabase db push*)",
      "Bash(supabase db reset --linked*)",
      "Bash(supabase db reset --db-url*)",
      "Bash(supabase migration up --linked*)",
      "Bash(supabase migration up --db-url*)",
      "Bash(supabase migration repair*)",
      "Bash(supabase config push*)",
      "Bash(supabase functions deploy*)",
      "Bash(supabase functions delete*)",
      "Bash(supabase secrets*)",
      "Bash(supabase storage rm*)",
      "Bash(supabase storage mv*)",
      "Bash(supabase storage cp*)",
      "Bash(supabase branches delete*)",
      "Bash(supabase projects delete*)",
      "Bash(psql *supabase.co*)",
      "Bash(psql *supabase.com*)"
```

What settings cannot block: the app itself. Browser checks that save data write to the project the app's env file points to.
