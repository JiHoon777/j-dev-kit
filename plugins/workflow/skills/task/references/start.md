# task start: plan and implement one backlog item

Plan **one** backlog item, get approval, and implement it. Review and merge are done by `/task end`.

This mode chains proven workflows. Each step names its source. Do not change how a source works.

| Step | Source |
| --- | --- |
| Handling the item | Backlog.md agent guidelines (task execution) |
| 1-2 | `*-start-check` skills of enabled stack plugins (invoked as is) |
| 2–5 | Anthropic `feature-dev` plugin, phases 2–5 |
| Plan and approval | Claude Code plan mode |
| 6 | `superpowers:test-driven-development`, `superpowers:verification-before-completion` (invoked as is), and the "Rules during implementation" and "Before finishing" returned by the stack checks |

Requested item: the arguments after `start`.

## 1. Check that work can start and read the item

If any of these applies, **stop and tell the user.** Do not clean up or move on by yourself.

| Check | If it applies |
| --- | --- |
| The base branch has no commits | Say a first commit is needed. Do not create it yourself |
| There are uncommitted changes (including untracked files) | Show what is left and ask what to do |
| A branch starting with `w/` already exists | One item at a time. Ask whether to continue that branch, finish it with `/task end`, or drop it |
| The current branch is not the base branch | Same as above |

If the user chooses to continue, switch to that branch, read the item's `Implementation Plan`, and resume from step 6.

Finding the item: look up the argument in `docs/backlog/`. If it is empty, matches several, or matches none, list the `status: To Do` items by number and title and let the user pick. If it is in `docs/done/`, say it is already finished.

Backlog.md: "Before mutating a task, read its current record and confirm its status, scope, acceptance criteria, and dependencies make it eligible to start." Read the item file to the end and check that every item in `dependencies` is in `docs/done/`. If not, stop and tell the user.

### 1-2. Stack start checks

1. In the list of available skills, find **every skill whose name ends with `-start-check`** (they carry a plugin prefix, e.g. `supabase:supabase-start-check`). Only enabled stack plugins appear in the list.
2. Invoke each with the Skill tool. A check that does not apply to this project returns only "not applicable". If there are none, write "no stack plugin enabled" and move on.
3. If any of them returns **stop**, stop and tell the user why.
4. Keep what they return: **baseline** (check results before the work), **exploration prompts**, **add to the plan**, **questions to ask**, **rules during implementation**, **before finishing**. Exploration prompts go to step 2; the rest go to steps 3–6 as they are.
5. Check skills only run commands. Gathering information by finding and reading code is not done by the check skills; they return exploration prompts, and step 2 runs them as agents. Do not go searching through the code yourself in this conversation.

**Now enter plan mode with the `EnterPlanMode` tool.** Steps 2–5 happen in plan mode. If the tool is not available, proceed without editing any file.

## 2. Explore the code (feature-dev phase 2)

1. Launch 2–3 exploration agents (`Explore`) plus **one `Explore` agent per exploration prompt** returned in 1-2, **all at once in a single message**. Give stack prompts as received, filling `<…>` from the item. The default exploration agents:
   - Follow the code to the end to understand structure, abstractions, and control flow.
   - Each looks at a different aspect. Example prompts (feature-dev original):
     - "Find features similar to [feature] and trace through their implementation comprehensively"
     - "Map the architecture and abstractions for [feature area], tracing through the code comprehensively"
     - "Analyze the current implementation of [existing feature/area], tracing through the code comprehensively"
     - "Identify UI patterns, testing approaches, or extension points relevant to [feature]"
   - Return a list of 5–10 files that must be read.
2. When the agents return, **read every file they listed yourself.** Also read the documents CLAUDE.md points to that relate to this item.
3. Summarize what you found and the patterns for the user, together with the stack checks' "add to the plan".

## 3. Clarifying questions (feature-dev phase 3)

"This is one of the most important phases. DO NOT SKIP."

1. Look at the exploration results and the item again.
2. Find what is underspecified: edge cases, error handling, integration points, scope boundaries, design preferences, performance. Add the stack checks' "questions to ask".
3. **Present all questions together as an organized list.**
4. **Do not move on to design before getting answers.**

If the user says "you decide", give your recommendation and get explicit confirmation. If the item's Acceptance Criteria cannot be checked, settle them here together. Do not ask what the docs and code already answer. If there is truly nothing to ask, say so and move on.

## 4. Design (feature-dev phase 4)

1. Launch 2–3 design agents (`Plan`) **at once**, each with a different focus:
   - **Minimal change:** the smallest change, reusing as much as possible
   - **Clean architecture:** maintainable, with tidy abstractions
   - **Pragmatic balance:** between speed and quality
2. Review the three options and form your own view of what fits this item (a small fix or a large feature; look at the complexity).
3. Show the user: a short summary of each option, a comparison of trade-offs, **a recommendation with reasons**, and how the implementation actually differs between options.

## 5. Show the plan and get approval (feature-dev phase 5 gate)

Show the plan with `ExitPlanMode`, in this order:

1. **What we are doing:** the item in one or two sentences, including what is left out this time.
2. **The three options and the recommendation:** from step 4. Let the user pick another option.
3. **The plan for the recommended option:** files to create or change and what each is responsible for, tests to write first, the order of small steps. Every "add to the plan" from the stack checks must be in it.
4. **How it will be verified:** how each Acceptance Criteria and Definition of Done line will be checked, including the stack checks' "before finishing".
5. **What was decided in step 3.**

"DO NOT START WITHOUT USER APPROVAL" — before approval, do not edit files and do not create the branch. If the user picks another option or asks for changes, revise the plan and show it again.

## 6. Implement (after approval)

**Record first (Backlog.md task execution guidelines):**

1. Create the branch: `w/` followed by the item file name without `.md`. Example: `git switch -c w/001-common-login`
2. In the item file: `status: In Progress`, `updated_date` to today, and the approved plan in `Implementation Plan`. Put the stack checks' baseline under `### Baseline` in `Implementation Notes`. If step 3 changed the Acceptance Criteria, change them now. ("write it down in the task so that you can refer to it later.")
3. Make the lint command pass and commit: `chore(backlog): <number> start`

**Build:**

- Invoke the `superpowers:test-driven-development` skill and follow it as is.
- feature-dev phase 5: re-read the files identified earlier, follow the chosen design, and strictly follow this codebase's conventions.
- Follow the stack checks' **rules during implementation** as they are (for example, a skill to invoke when building a new screen, or an autofixer to run on each file).
- Backlog.md: "Only implement what's in the Acceptance Criteria." Do not change what the item does not cover. If something seems necessary, tell the user, and if they agree, create it separately with `/task create`.
- Backlog.md: "Follow the acceptance criteria one by one and MARK THEM AS COMPLETE as soon as you finish them." Check and tick each one as soon as it is done.
- Write what you learn and what changed from the plan in `Implementation Notes`. If the scope grows, stop and ask.
- Commit to the work branch at each meaningful step. **Do not commit to the base branch, and do not push.**

**Finish:**

1. Invoke the `superpowers:verification-before-completion` skill and follow it as is, using this project's verification command.
2. Do the stack checks' **before finishing** items (for example a browser test). If the tool is not available, do not skip it: stop and tell the user. Write what you did and saw in `Implementation Notes`.
3. In Acceptance Criteria and Definition of Done, tick **only what you actually verified**.
4. If you changed the item file, run the lint command and commit. **Do not leave uncommitted changes**; otherwise `/task end` cannot start.
5. Report to the user: what was done, the result per criterion, what changed from the plan, and what could not be verified. Say that `/task end` is next.
