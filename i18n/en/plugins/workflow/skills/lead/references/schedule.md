> Translation. Source: [plugins/workflow/skills/lead/references/schedule.md](../../../../../../../plugins/workflow/skills/lead/references/schedule.md). Update this file when the source changes. Claude does not read this file.

# lead schedule: call scout on a cadence in this session

Cadence: the arguments after `schedule`. If missing, ask (e.g. weekdays at 9 in the morning). If the argument is `off` or `끄기`, do only section 3.

The schedule runs only inside this session. At each set time, this session follows the scout procedure (`scout.md`): it starts the agent, takes the report, writes the proposals file, and asks about promoting the new proposals. Do not use a schedule that creates a separate session (the app's scheduled tasks). That session cannot be followed, and its report does not come back to this session.

## 1. Take the proposals file out of git

If `.gitignore` does not have `docs/backlog/_proposals.md`, propose adding it, and on approval add it and commit: `chore: ignore backlog proposals`. The proposals file changes on every run, so it is not committed. If it is not ignored, `/task start` stops at "uncommitted changes".

## 2. Register

Register with the in-session scheduling tool (CronCreate, what `/loop` uses).

- Write the prompt as instructions, not as a slash command. A `/workflow:lead scout` that arrives from a schedule is not expanded into the skill; it arrives only as text. Put in the prompt:
  1. "This is a scheduled lead scout run. Read `<skill folder>/references/scout.md` all the way through with the Read tool and follow it as written."
  2. "`${CLAUDE_SKILL_DIR}` in that file means `<skill folder>`."
  3. "The agent's name is `workflow:backlog-scout`."

  Replace `<skill folder>` with this skill's absolute path (Base directory). Do not paste procedures.
- The path contains the plugin version. After updating the plugin, call `/lead schedule` again to register with the new path.
- Turn the cadence into cron. Unless the user named an exact time, avoid minute 0 and 30.
- If there is an end ("until 5 today"), pin the date and hours in the cron so it does not run after that.
- If a schedule whose prompt starts with "This is a scheduled lead scout run" already exists (CronList), delete it and register anew. It is the same schedule even if the version in the path differs.
- If the user asked to start right away ("from now"), after registering, read `${CLAUDE_SKILL_DIR}/references/scout.md` and follow it once.
- If this session has no in-session scheduling tool, do not register. Show the cadence and the instructions above and tell the user to register them with `/loop` themselves.

## 3. Turn off

Find the schedule whose prompt starts with "This is a scheduled lead scout run" in CronList and delete it with CronDelete. If there is none, say so.

## 4. Tell the user

- The cadence and the next run time (the time given in the registration result)
- Limits: it runs only while this session is open and idle. It can run later than the set time. It expires after 7 days
- To turn it off, `/lead schedule off` (or `끄기`)
