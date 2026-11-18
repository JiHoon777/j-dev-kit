# j-dev-kit

[한국어](README.md) | **English**

> Translation of README.md. The Korean README is the source.

A personal Claude Code plugin marketplace. The work loop is a single `/task` skill; stack-specific checks live in stack plugins.

| Plugin | Contains | Also installs |
| --- | --- | --- |
| `workflow` | `/task create`, `/task start`, `/task end` | `superpowers` |
| `frontend` | Svelte and React checks, browser verification, `frontend-reviewer` | `workflow`, `typescript-lsp`, `frontend-design` |
| `server` | Server and Supabase checks (migrations, API spec, keys), `api-reviewer`, `supabase-reviewer` | `workflow` |

If you use Supabase, install `server` even if you call it straight from the frontend.

## Install

```bash
claude plugin marketplace add JiHoon777/j-dev-kit --scope project
claude plugin install frontend@j-dev-kit --scope project
claude plugin install server@j-dev-kit --scope project
```

Install only the stacks you use. Do not remove the dependency plugin lines written to `.claude/settings.json`.

Add this to the project CLAUDE.md.

```markdown
## Work settings
- stack: frontend, server
- base branch: main
- verify command: pnpm verify
- document language: English

## superpowers
The rules in this document take precedence. Follow only the skills `/task` calls; do not use
writing-plans, executing-plans, subagent-driven-development, or using-git-worktrees.
```

Without the superpowers paragraph, superpowers takes over the planning step of `/task start`.

### Used when installed

| Plugin / skill | Install |
| --- | --- |
| Official Svelte | `/plugin marketplace add sveltejs/ai-tools`, `/plugin install svelte@svelte` |
| Chrome DevTools | `/plugin marketplace add ChromeDevTools/chrome-devtools-mcp`, `/plugin install chrome-devtools-mcp@chrome-devtools-plugins` |
| modern-web-guidance | `/plugin marketplace add GoogleChrome/modern-web-guidance`, `/plugin install modern-web-guidance@googlechrome` |
| Vercel react-best-practices | `npx -y skills@1.7.5 add vercel-labs/agent-skills` |
| Official Supabase | `/plugin install supabase@anthropic-plugin-directory` (turn off its bundled MCP in `/mcp`) |

## Usage

```
/task create Add an email and password login screen   # docs/backlog/001-….md
/task start 001                                        # plan → approve → implement on a w/001-… branch
/task end                                              # review → fix → close the item → merge
```

- **start:** baseline (one run of the verify command), stack start checks, planning sized to the item (no agents for small items), test-first implementation, cleanup with `simplify`, verification.
- **end:** stack end checks, review (`code-review` plus `security-review` and stack reviewers when needed), findings shown as 🔴 must fix / 🟡 consider / ⚪ minor with one question per group, fixes, verification, merge. Pushes only on request.

## Layout

```
plugins/workflow/skills/task/       SKILL.md + references/create.md, start.md, end.md
plugins/frontend/                   skills/frontend-{start,end}-check, agents/frontend-reviewer.md
plugins/server/                     skills/server-{start,end}-check, agents/api-reviewer.md, supabase-reviewer.md
i18n/en/                            English translations (Claude does not read them)
```

- The source is Korean (`plugins/`); translations live in `i18n/en/`. Update the translation when you change the source.
- `/task start` calls every skill whose name ends in `-start-check`, and `/task end` every one ending in `-end-check`. To add a stack, make a plugin with the same naming and register it in `marketplace.json`.

## Updating

```bash
claude plugin marketplace update j-dev-kit
claude plugin update <plugin>@j-dev-kit --scope project
```

Then open a new session. Maintainers bump `version` in `plugin.json` for each changed plugin, run `claude plugin validate .`, and push. If the version is unchanged, the update is not picked up.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| `supabase@j-dev-kit` cannot be found | It was merged into `server`. Remove it from `enabledPlugins` and install `server@j-dev-kit`. |
| `Dependency "…" is not installed` | Install the removed dependency plugin with the same `--scope`. |
| No stack checks run | The plugin is disabled, or it is missing from `stack:` in CLAUDE.md. |

## Sources

[Backlog.md](https://github.com/MrLesk/Backlog.md) item format, [superpowers](https://github.com/obra/superpowers) (brainstorming, TDD, verification before completion, receiving review, finishing a branch), [spec-kit](https://github.com/github/spec-kit) (at most 3 questions), [compound-engineering](https://github.com/EveryInc/compound-engineering-plugin) (planning sized to the task), [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills), Claude Code built-in `code-review`, `security-review`, `simplify`, OWASP API Security Top 10, [supabase/agent-skills](https://github.com/supabase/agent-skills), Anthropic [Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices).
