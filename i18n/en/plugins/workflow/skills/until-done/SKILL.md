---
name: until-done
description: Takes only a goal and an end condition and works to the end. Where the j-dev-kit skills would ask the user, it decides and writes the decision down instead; it checks completion with a command or with a fresh agent that has not seen the conversation; it asks only about irreversible actions. Runs only when the user invokes it directly.
argument-hint: "<goal> — done: <end condition>"
disable-model-invocation: true
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
  tags: [autonomy, completion-check, goal]
---

> Translation. Source: [plugins/workflow/skills/until-done/SKILL.md](../../../../../../plugins/workflow/skills/until-done/SKILL.md). Update this file when the source changes. Claude does not read this file.

# until-done

Arguments: `$ARGUMENTS`

This session has been handed the work. It received only a goal and an end condition, and it keeps going without asking the user until it is done. The project CLAUDE.md rules take precedence over this skill. It does not change the permission mode (tool permission prompts still appear).

## 1. Start

1. Read the goal and the end condition from the arguments. If there is no end condition, ask for that one thing only. Do not ask about anything else (what to keep fixed, what not to do, order).
2. Decide how the end condition will be checked: a command if one can check it, otherwise a checklist where each criterion can be marked pass or fail. If the condition cannot be checked at all, say so before starting.
3. Tell the user once, without asking: the goal, the end condition, how it will be checked, and the line the user can type to keep the session going until the end.

   ```
   /goal <end condition>. Done when every check result shown in the conversation passes; stop after the same failure three times
   ```

   `/goal` is a built-in Claude Code command. After every turn a small model judges the condition and, if it is not met, keeps the session going. That model sees only the conversation, so show the check results from section 3 in the conversation as they are.

## 2. How to work

- The j-dev-kit `/task`, `/lead`, `/ui` and `/arch` skills can be invoked only by the user. Read the SKILL.md and procedure files of the skill you need with Read and follow them as written.

  | Skill | Where to find it |
  | --- | --- |
  | `/task`, `/lead` | `${CLAUDE_SKILL_DIR}/../task/`, `${CLAUDE_SKILL_DIR}/../lead/` |
  | `/ui` | Installed: `${CLAUDE_SKILL_DIR}/../../../../design/<version>/skills/ui/` (the highest version if there are several). Used straight from the repository: `${CLAUDE_SKILL_DIR}/../../../design/skills/ui/` |
  | `/arch` | The same way, `architecture/…/skills/arch/` |

  If you cannot find it, do not do that work and list it in the section 5 report.
- Where a procedure says to ask the user or get approval (questions, plan approval, review finding decisions, merge approval, number, direction and choice of mockups, and so on), do not ask. Pick what best fits the goal and the end condition, write one line, and continue. Do not enter plan mode either.

  ```
  Ruling: <what you decided> — <why> — <what it costs if wrong>
  ```

  While working on an item, write it in that item's `Implementation Notes`; otherwise collect it for the section 5 report.
- Keep anything the user says along the way (for example "deploy later") until the end. Do not widen the work beyond the goal.

## 3. Checking whether it is done

Do not judge "done" yourself. After each round of work, check:

- If it is a command, run it again.
- If it is a checklist, start a fresh agent with the Agent tool. Give it only the end condition, the checklist and the files to look at, and get back pass or fail with evidence for each criterion. Do not hand over this conversation or your own judgment.

Show the results in the conversation as they are: `pass`/`fail` and one line of evidence for each criterion. If failures remain, make them the next work and continue. If the same failure repeats three times, stop and give the section 5 report.

## 4. What to stop and ask about

Ask only about irreversible actions.

- Deleting or discarding: files, branches, worktrees, uncommitted changes
- Anything visible outside: push, PR, deploy, sending messages
- Changes outside the project: global installs, other repositories, remote databases and services
- Values only the user knows

Ask them together, once. Do not ask again about something already answered.

## 5. Finish

When every end-condition check passes, when the user says "stop", or after the same failure three times, report and end the handed-over state.

- What was done
- What you decided yourself: every `Ruling:` line
- What was not done and why, and what could not be checked
- If `/goal` is still set, say it can be turned off with `/goal clear`
