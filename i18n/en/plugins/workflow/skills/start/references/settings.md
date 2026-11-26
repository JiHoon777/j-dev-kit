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
    "session": { "model": "auto", "effort": "high" },
    "implement": { "model": "inherit" },
    "review": { "model": "auto" },
    "judge": { "model": "inherit" },
    "mechanical": { "model": "sonnet", "effort": "high" },
    "explore": { "model": "inherit" }
  }
}
```

## Roles

| Role | Who | Default |
| --- | --- | --- |
| `session` | The sub-sessions `start` and `backlog` open | `auto`, effort `high` |
| `implement` | Subagents handed the implementation (where a playbook says to "delegate") | `inherit` |
| `review` | Review agents: `code-review`, `security-review`, stack reviewers | `auto` |
| `judge` | Judge agents: AC judgment, judging review findings, judging the survey, `frontend-evaluator` | `inherit` |
| `mechanical` | Agents handed mechanical fixes where no judgment is left | `sonnet`, effort `high` |
| `explore` | Read-only exploration and research: the `Explore` agents `start` and `backlog` launch, survey gathering | `inherit` |

## Values

- `model`: one of `fable`, `opus`, `sonnet`, `haiku`, `inherit`, `auto`.
  - `inherit`: do not pass a model. It inherits this session's model.
  - `auto`: if this session is Fable, use the latest model one step lower (for now `opus`); otherwise treat it as `inherit`. When it resolves to `inherit`, do not pass that role's `effort` either (both the model and the effort are inherited).
- `effort`: one of `low`, `medium`, `high`, `xhigh`. If not written, it is inherited.

## How to pass them

- **Subagents:** pass them as the Agent tool's `model` and `effort`. `model` takes only the aliases (`fable`, `opus`, `sonnet`, `haiku`). For `inherit`, do not pass `model`. This value takes precedence over the model written in the agent definition file.
- **Sub-sessions:** pass them as the `model` and `effort` of the tool that opens the session. Give `model` the latest model ID for that alias (for example, `opus` is `claude-opus-5-5` for now). The tool does not take a model or effort above this session's. If the setting is higher, leave it out (it inherits) and say so in one line.
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
