---
name: kit-setup
description: Use when setting up the workflow plugin for the first time or changing its settings. Asks which model and effort sub-sessions and subagents use for each role and how to merge (local merge then push / PR), writes them to a JSON settings file, and sets the main session's model too. Also asks whether to create the work settings in the project CLAUDE.md and a verification skill, if they are missing. Looks at the project's stack and installs the official skills and plugins that fit it, without asking. Use for "model settings", "merge settings", "setup", or "let's change which model things run on".
argument-hint: "[--user]"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> Translation. Source: [plugins/workflow/skills/kit-setup/SKILL.md](../../../../../../plugins/workflow/skills/kit-setup/SKILL.md). Update this file when the source changes. Claude does not read this file.

# kit-setup

Arguments: `$ARGUMENTS`

Write the workflow plugin's settings. The format and the roles are in `${CLAUDE_SKILL_DIR}/../start/references/settings.md`. Read that file with the Read tool first.

The only asking is the one time in step 2 below. Attach a recommendation and its reason to each option. If there is a tool for asking (AskUserQuestion), ask with it.

## 1. Read the current state

- Model settings and how to merge (`merge`): `<repository root>/.claude/workflow.json`, `~/.claude/workflow.json`. If neither exists, the model defaults are in use and `/start` asks how to merge each time.
- Past merges: `git log <base> --merges --oneline -20`. Many `Merge pull request` lines mean PRs were used; many `Merge branch` lines mean local merges.
- Main session: this session's model, and where the `model` and `effortLevel` keys are written (`.claude/settings.local.json`, `.claude/settings.json`, `~/.claude/settings.json`). Look only at these keys.
- `## 작업 설정` (work settings) in the project CLAUDE.md: base branch, verify command, document language, `stack:`.
- Project verification skill: whether `.claude/skills/verify-*/` exists, and whether CLAUDE.md has `- 검증 스킬: 안 씀` (verification skill: not used).
- Stack and what is installed: the conditions in the step 4 table (dependencies in `package.json`, `tsconfig.json`, `supabase/config.toml`) and the plugins and skills already installed (`claude plugin list`, `.claude/skills/`, `~/.claude/skills/`). In a monorepo, look at each app and package.

## 2. Show, then ask everything at once

Show, for each role, the value in use, where it comes from (project file, user file, default), and the default in a table. Then ask everything at once.

1. **Where to save:** project (`.claude/workflow.json`, committed. Visible from worktrees and sub-sessions too) / user (`~/.claude/workflow.json`, the default for every project). If the arguments have `--user`, do not ask; it is user. The recommendation is project.
2. **Model and effort per role:** have the user pick one of three.
   - Leave as is (do not change `models`)
   - Save: lower `session`, `implement`, `review`, `judge`, and `mechanical` to `sonnet`, and `explore` to `haiku`
   - Pick roles to change: have the user say which roles and which values
3. **How to merge:** how to bring the work in when `/start` finishes. Merge into the base branch locally and push (`local`) / open a PR that targets the base branch (`pr`) / do not set it (ask each time). Recommend the way the past merges were done. Say that whichever is picked, `/start` still asks at the end whether to merge.
4. **Main session:** leave as is (recommended) / pick a model and effort and write them to the settings. If written, say that they apply from a new session.
5. **CLAUDE.md work settings** (only when missing): show the values found (the base branch from `git symbolic-ref` or `main`, the verify command from the `package.json` scripts or the Makefile) and ask whether to add them. If no verify command is found, ask what it is.
6. **Verification skill** (only when there is no `verify-*` and no "안 씀" (not used) line): ask whether to create a project skill that drives the real app and checks it.

Do not ask about what is already settled.

## 3. Check and write

- Check the values. `model` is one of `fable`, `opus`, `sonnet`, `haiku`, `inherit`, `auto`, `effort` is one of `low`, `medium`, `high`, `xhigh`, and `merge` is one of `local`, `pr`. If not, ask again for that role only. The main session's `model` takes only `fable`, `opus`, `sonnet`, or `haiku` (`inherit` and `auto` are for roles only).
- Rewrite the settings file whole. Running it again must give the same result. Write only the roles the user set. Roles left out follow the next source (the user file, then the default). Writing defaults into the project file would hide the user file's values in that project.
- If the main session is to change, edit only the `model` and `effortLevel` keys in `.claude/settings.local.json`. If the file does not exist, create one with only those two keys. Do not touch other keys. Do not edit permission, hook, or plugin keys.
- If CLAUDE.md is to be added to, add only the `## 작업 설정` (work settings) section.
- If a project file was written, commit with `chore: workflow 설정` (workflow settings). Do not push. If this is not the base branch, say that the commit goes onto this branch.

## 4. Install the skills and plugins that fit the stack

Install without asking (the asking criteria in the `start` skill: do not ask about installs). From the table below pick every row that fits the project, and install only what is missing. The stack checks in `/start` also install what is missing, but doing it here in one pass keeps the first item from being slowed by installs.

A frontend framework means one of react, next, vue, nuxt, svelte, @sveltejs/kit, solid-js, @angular/core, astro in the `dependencies` or `devDependencies` of `package.json`.

| Condition | Install | Command |
| --- | --- | --- |
| There is a frontend framework | frontend-design | `claude plugin install frontend-design@anthropic-plugin-directory --scope project` |
| There is a frontend framework | Chrome DevTools | `claude plugin marketplace add ChromeDevTools/chrome-devtools-mcp --scope project`, `claude plugin install chrome-devtools-mcp@chrome-devtools-plugins --scope project` |
| There is a frontend framework | modern-web-guidance | `claude plugin marketplace add GoogleChrome/modern-web-guidance --scope project`, `claude plugin install modern-web-guidance@googlechrome --scope project` |
| There is a `tsconfig.json`, or `typescript` is a dependency | typescript-lsp | `claude plugin install typescript-lsp@anthropic-plugin-directory --scope project` |
| `svelte` is present | Official Svelte | `claude plugin marketplace add sveltejs/ai-tools --scope project`, `claude plugin install svelte@svelte --scope project` |
| `react` is present | Vercel React skills | `npx -y skills@1.7.5 add vercel-labs/agent-skills --skill vercel-react-best-practices --skill vercel-composition-patterns -a claude-code` |
| `react-router` is present | React Router skill | `npx -y skills@1.7.5 add https://github.com/remix-run/react-router --skill react-router -a claude-code` |
| There is a `supabase/config.toml`, or an `@supabase/` package | Official Supabase | `claude plugin install supabase@anthropic-plugin-directory --scope project` |

- Do not install anything named on the `- 공식 스킬 설치 안 함:` (official skills not installed) line under `## 작업 설정` (work settings) in CLAUDE.md.
- If CLAUDE.md has a `stack:` line, skip the rows of stacks it does not list.
- Install only with the commands above. Do not edit the plugin keys in settings files by hand.
- If a command fails, do not stop. Report what failed and why in step 6.
- The official Supabase plugin comes with an MCP server. Say that it can be turned off in `/mcp`.
- If `next` is present there is nothing to install. From 16.3 on, `next dev` creates `AGENTS.md`. Below that, say that `npx @next/codemod@canary agents-md` does it.
- If the installs changed project files (`.claude/settings.json`, `.claude/skills/`), commit with `chore: 스택 스킬과 플러그인 설치` (install stack skills and plugins). Do not push.

## 5. Verification skill

If one is to be created, read the `create-verification-skill` skill (`${CLAUDE_SKILL_DIR}/../create-verification-skill/SKILL.md`) and follow it. If not, suggest writing `- 검증 스킬: 안 씀` (verification skill: not used) under `## 작업 설정` (work settings) in CLAUDE.md so it is not asked again.

## 6. Report

Report the files written, the value set for each role, how to merge, what was installed and what could not be installed, and when they take effect. Per-role settings apply from the next session or agent launched, and main session settings and installed plugins from a new session. To change them again, invoke `/kit-setup` once more.
