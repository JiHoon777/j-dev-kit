> Translation. Source: [plugins/workflow/skills/start/references/settings.md](../../../../../../../plugins/workflow/skills/start/references/settings.md). Update this file when the source changes. Claude does not read this file.

# Settings

The workflow plugin's settings file. It sets two things: the model and effort each role uses when opening a sub-session or launching a subagent, and how to merge when the work is done. The values are in a JSON settings file, which the `kit-setup` skill writes. `start` and `backlog` follow this file. When another skill is invoked directly (`/how`, for example), these settings are not used.

## Settings files

- Project: `<repository root>/.claude/workflow.json`. Once committed, it is visible from worktrees and sub-sessions too.
- User: `~/.claude/workflow.json`. The default for every project.

Before opening a session or launching an agent, read both files with the Read tool (skip a file that does not exist). For each role, use the project value if there is one, otherwise the user value, and otherwise the default below. If both files are missing or cannot be read, go with the defaults without asking. A value read once does not need to be read again during that session.

With the defaults written out, it looks like this. You may write only the roles you change.

```json
{
  "models": {
    "session": { "model": "opus", "effort": "xhigh" },
    "implement": { "model": "opus", "effort": "xhigh" },
    "review": { "model": "opus", "effort": "xhigh" },
    "judge": { "model": "opus", "effort": "xhigh" },
    "mechanical": { "model": "opus", "effort": "high" },
    "explore": { "model": "opus", "effort": "high" }
  }
}
```

## Roles

| Role | Who | Default |
| --- | --- | --- |
| `session` | The sub-sessions `start` and `backlog` open | `opus`, effort `xhigh` |
| `implement` | Subagents handed the implementation (where a playbook says to "delegate") | `opus`, effort `xhigh` |
| `review` | Review agents: `code-review`, `security-review`, stack reviewers | `opus`, effort `xhigh` |
| `judge` | Judge agents: AC judgment, judging review findings, judging the survey, `frontend-evaluator` | `opus`, effort `xhigh` |
| `mechanical` | Agents handed mechanical fixes where no judgment is left | `opus`, effort `high` |
| `explore` | Read-only exploration and research: the `Explore` agents `start` and `backlog` launch, survey gathering | `opus`, effort `high` |

## What the defaults follow

The defaults follow pstack's per-role defaults (`pstack/skills/setup-pstack/SKILL.md` and the Subagents section of `poteto-mode/SKILL.md` in `cursor/plugins`). Code, prose, and judgment run on Opus at effort `xhigh`, and mechanical fixes on Opus at `high`. pstack's review panel mixes one model per seat from different vendors. Here each reviewer has a different job, so they share one model at the level for judgment (`xhigh`). `explore` is a role pstack does not have, so it is set to `high`.

- No role runs above `xhigh`.
- Match the model to the job. Start from the role's value, raise it one step (up to `xhigh`) for the hardest or subtlest work, and lower it two or more steps for routine work. pstack lowers judgment-only work one step and runs verification at `high`. Here the judge is the last gate that decides Acceptance Criteria and review findings, so `judge` stays at `xhigh` and is not lowered.
- Fable is an exception. It runs only when the user named it for this task or two Opus `xhigh` runs of the same brief failed. Say which. Difficulty alone never qualifies. A role the user set to `fable` or `inherit` in the settings file follows that setting.

## Values

- `model`: one of `fable`, `opus`, `sonnet`, `haiku`, `inherit`, `auto`.
  - `inherit`: do not pass a model. It inherits this session's model.
  - `auto`: if this session is Fable, use the latest model one step lower (for now `opus`); otherwise treat it as `inherit`. When it resolves to `inherit`, do not pass that role's `effort` either (both the model and the effort are inherited).
- `effort`: one of `low`, `medium`, `high`, `xhigh`. If not written, it is inherited.

## How to pass them

- **Subagents:** pass them as the Agent tool's `model` and `effort`. `model` takes only the aliases (`fable`, `opus`, `sonnet`, `haiku`). For `inherit`, do not pass `model`. This value takes precedence over the model written in the agent definition file.
- **Sub-sessions:** pass them as the `model` and `effort` of the tool that opens the session. Give `model` the latest model ID for that alias (for example, `opus` is `claude-opus-5-5` for now). The tool does not take a model or effort above this session's. Check each value on its own. Leave out only the value where the setting is higher (that value inherits) and say so in one line.
- If the tool rejects a value, launch without that value and then say so.

## How to merge

The `merge` key in the same file. Write it next to `models`.

```json
{
  "merge": "local"
}
```

- `local`: merge the work branch into the base branch locally and push the base branch.
- `pr`: push the work branch and open a PR that targets the base branch.
- Use the project value if there is one, otherwise the user value. If neither exists, `start` asks how to merge in its last message.
- This value sets only the way. Whether to merge at all is still asked by `start` in its last message. Merging and pushing the base branch fall under the asking criteria.

## Main session

This file cannot change the main session's model. The main session's model and effort are set by the Claude Code settings (`model` and `effortLevel` in `settings.json`) and apply from a new session. `kit-setup` writes the chosen values to those keys. During a session, change it with `/model`.
