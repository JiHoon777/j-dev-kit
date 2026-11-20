> Translation. Source: [plugins/workflow/skills/lead/references/schedule.md](../../../../../../../plugins/workflow/skills/lead/references/schedule.md). Update this file when the source changes. Claude does not read this file.

# lead schedule: put scout on a recurring run

Cadence: the arguments after `schedule`. If missing, ask (e.g. weekdays at 9 in the morning).

## 1. Take the proposals file out of git

If `.gitignore` does not have `docs/backlog/_proposals.md`, propose adding it, and on approval add it and commit: `chore: ignore backlog proposals`. The proposals file is rewritten on every run, so it is not committed. If it is not ignored, `/task start` stops at "uncommitted changes".

## 2. Register

Pick from the scheduling means available now, from the top.

| Means | Characteristics |
| --- | --- |
| The app's scheduled-task tool | Runs while the app is open. Each run is a new session, and this session is notified when it finishes |
| `/loop` | Runs only while this session is open. Expires after 7 days |

- A scheduled run knows neither this conversation nor the plugin's path. Put in the prompt the repository's absolute path, a line saying "work in this folder", and the full text of `${CLAUDE_SKILL_DIR}/references/scout.md` as it is.
- If a schedule doing the same job already exists, do not create a new one; update it.
- If registering is blocked by permissions, do not work around it. Show the prompt and the cadence and let the user create it in the app.

## 3. Tell the user

- The cadence, the next run time, and which means was used
- That means' limit (it does not run while the app or the session is closed)
- After updating the plugin, call `/lead schedule` again to put in the new prompt
- Proposals are reviewed in `/lead run`
