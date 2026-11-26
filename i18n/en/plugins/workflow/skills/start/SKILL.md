---
name: start
description: Use when implementing work through to the merge. Invoke when the user asks to start or implement a backlog item, or to continue a work branch or review, wrap up, or merge it. If the user writes a task after /start, do it right away with no item. Goes through planning, implementation, verification, review, fixing findings, and the merge in one run, and asks only what is truly needed. Creating a new item is the backlog skill's job. Do not invoke it on your own for a request to just fix something when the user did not type /start and there is no mention of an item or branch.
argument-hint: "[backlog number or part of a name | a task in a sentence or two] [--here]"
allowed-tools: Bash(git status *), Bash(git branch --show-current), Bash(git branch --list *), Bash(git log *), Bash(git diff *), Bash(ls *)
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> Translation. Source: [plugins/workflow/skills/start/SKILL.md](../../../../../../plugins/workflow/skills/start/SKILL.md). Update this file when the source changes. Claude does not read this file.

# start

Arguments: `$ARGUMENTS`

Implement one backlog item, or one task the user wrote directly, through to the merge. The procedure is in `${CLAUDE_SKILL_DIR}/references/procedure.md`. After deciding below where to work, if the work happens in this session, read that file all the way through with the Read tool and follow it as written. `<scripts>` in the procedure file is `${CLAUDE_SKILL_DIR}/scripts`, and `<ref>` is `${CLAUDE_SKILL_DIR}/references`.

## 1. Where to work

- **If the current branch starts with `w/`:** this is a session already at work. Do not open a session; follow the procedure in this session. Even with no arguments, or with words like "review and merge it", continue that branch's item ("Continuing" in the procedure). If the branch has no item file, continue the work that was being done without an item. If the arguments are a new task that has nothing to do with that item, follow the branch rule under "Without an item" in the procedure.
- **If the arguments are a task, not a backlog item:** do not create an item; do the work right away in this session ("Without an item" in the procedure). Look up the arguments in `docs/backlog/` and `docs/done/`, and if no item matches by number or name, treat them as a task. If the work spans several modules or would take days, say in one line that making an item with `/backlog` would be better, and go on as is.
- **If the arguments have `--here`:** remove it and work in this session.
- **Otherwise:** open a sub-session.
  1. If there is no tool that starts a new session the user can open and talk to directly (for example the desktop app's `start_session`), say in one line that the work happens in this session, and follow the procedure.
  2. First find the item in this session ("Finding the item" in step 1 of the procedure). If this item's `w/` branch already exists, do not open a session; tell the user to continue in the session that worked on that branch. If that session no longer exists, continue the branch in this session as the procedure says.
  3. Open one session. The user asked for this work, so start it right away instead of proposing it. It is a new worktree off the base branch, with the branch name `w/<item file name without .md>`.

     Model and effort: follow the `session` role in `${CLAUDE_SKILL_DIR}/references/settings.md`. With no settings, the defaults apply (Opus, effort `xhigh`).

  4. That session cannot see this conversation. The brief is two lines, "Invoke the `start` skill with `<item> --here` and follow its procedure" and "Ask only what falls under that skill's asking criteria. Write questions completely in the last message of the turn, then stop", plus any background the user gave or decisions made in this conversation (only if there are any).
  5. Report the session link. That work does not happen in this session; this session directs it.
     - When the sub-session ends a turn, show any question to the user in full and pass the answer to that session in the user's own words. Check the result (commits, changed files) yourself and report it before the user asks.
     - The sub-session follows the asking criteria below too. This session does not add questions.
     - If the user answered in the sub-session directly, accept that.

## 2. Project settings

Read these from the project CLAUDE.md. If missing, use the default in parentheses; if there is no verify command, ask.

- Base branch (`main`)
- Verify command (e.g. `pnpm verify` — lint, types, tests, build)
- Language for items and reports (the language of the conversation)
- Web port, server port (none): only the ones written down are split per item as `base port + item number`

How to merge is read not from CLAUDE.md but from `merge` in the settings file (`${CLAUDE_SKILL_DIR}/references/settings.md`). If it is not there, ask in the last message.

Rules in the project CLAUDE.md take precedence over this skill.

## 3. Working principles

### Asking criteria

Ask only these five. Every question point in the `backlog` skill and in the procedure follows these criteria.

1. Work that cannot be undone or that goes outside: merging, pushing to the base branch or a deploy branch, deleting, a remote DB, deploying. Other branches (work branches) are pushed without asking.
2. Work that changes something outside the project or shared settings: installing plugins or skills, CLAUDE.md.
3. Product or taste decisions that code or a run cannot settle.
4. Choosing what to do: which items to create, how far to go.
5. States that could lose work: uncommitted changes, a branch whose owner is unknown.

Do not ask anything else. Decide, and go on while writing down what was decided and why (full text: the `principle-never-block-on-the-human` skill).

- Do not ask about a fork that running something would settle (structure, library, approach). Run it, decide, and write down the result and the evidence (`playbooks/prototype.md`).
- Do not ask questions like "Shall I go on to the next step?"
- If `git revert` or removing a worktree can undo it, it can be undone.
- If the user says "let me see the plan" or "stop here", do so.
- If the user says "run it to the end", "don't stop", "I'm stepping away" or "I'm going to bed", do not stop. Only criterion 1 (work that cannot be undone or that goes outside) remains, and the merge is still asked. Decide the other questions (pre-start questions, the ones on the scope list, product or taste decisions) by your recommendation, write them down as decisions, and collect them in the last message. At a dead end, do not spin. Say so.

### Writing down decisions

Write what was decided without asking under `### 정한 것` (decisions) in the item file's `Implementation Notes`, one line each.

```markdown
- decision — reason (name of the principle or skill applied) — cost if wrong
```

Raise the ones with a high cost if wrong in the last message. These lines are not something the user decided. The review and the judge examine them.

### How to work

- Do not assume what you do not know; say it. Do not ask what code and docs can answer.
- Do only what the item requires. Solve it with the smallest change, and every changed line must trace back to the item (full text: the `principle-laziness-protocol` skill).
- Before saying "done", run verification fresh and show what you confirmed on the real output (full text: the `principle-prove-it-works` skill).
- You may say no. If a proposal to widen the scope, or an approach you were shown, is not worth its cost, say so.
- Do not hand a person a check you can run yourself.
- Give evidence for each claim, or mark it as confirmed, inferred, or guessed.

## 4. Models

When opening a sub-session or launching a subagent, read `${CLAUDE_SKILL_DIR}/references/settings.md` with the Read tool and pass the model and effort that fit the role (`session`, `implement`, `review`, `judge`, `mechanical`, `explore`). `/kit-setup` writes the settings file. If there is none, use the defaults in that file.

## 5. Index

The skills and principles are other skills of this plugin. Their bodies are at `${CLAUDE_SKILL_DIR}/../<name>/SKILL.md` from this file. A playbook is at `${CLAUDE_SKILL_DIR}/playbooks/<name>.md`. When a "when" below applies, read that file with the Read tool and follow it. These skills are set not to fire on their own (`disable-model-invocation`), so do not call them with the Skill tool. The user can invoke them directly, as in `/architect` or `/deslop`. Write the name of what you applied in the reason of the decision line. Do not cite a name without reading the body.

### Must follow

- The first message → restate the goal and the smallest change that meets it, then go on.
- Before implementing → call every installed stack check skill (names ending in `-start-check`: `workflow:frontend-start-check`, `workflow:server-start-check`, and any that another plugin provides under the same naming rule) with the Skill tool and follow what they return. Before review → call every one ending in `-end-check`. Do not skip them when following a playbook or `figure-it-out`.
- You do not know how the code to change works → the `how` skill. The question is why it came to be that way → the `why` skill.
- A fork that running something would settle → do not ask; `playbooks/prototype.md`.
- Before writing code → settle the shape of the data first. A change that crosses a function boundary → the `architect` skill.
- Changing a screen or reproducing a UI bug → the `control-ui` skill. For a CLI or TUI → the `control-cli` skill. If the project has a `verify-*` skill, follow that skill and its feature map first. If a stack check has set how to verify (for example, frontend has the `frontend-evaluator` agent judge), that comes first, and these skills are how the screen gets driven.
- The project has no set way to drive the real app and check it → the `create-verification-skill` skill. Whether to create one goes into the pre-start questions, once per project (do not ask if there is a `verify-*` skill or CLAUDE.md has `- 검증 스킬: 안 씀` (verification skill: not used)). The feature map does not match the app → the `maintain-verification-skill` skill. Inside the `start` flow, fix only the features that are off and commit to the work branch. Do not open a separate PR.
- A claim of "fixed" or "faster" → the `verify-this` skill.
- Reporting a measured number, or deciding by it → the `benchmark-checklist` skill.
- A diff that is small but reaches wide and is hard to trust → the `blast-radius` skill before the review.
- When launching an agent → write `먼저 <이 스킬 폴더의 절대 경로>/references/worker.md 를 읽는다.` (read `<absolute path of this skill's folder>/references/worker.md` first) as the first line of the brief, and open the next line with the goal. Skills do not fire on their own, so this is the only way the rules reach a subagent.
- Before committing → the `deslop` skill. Before the review, if code changed → the `no-comments` skill.
- Prose (replies, item files, reports) → the `unslop` skill. Docs and commit messages → the `technical-writing` skill.
- Merge conflicts → the `fix-merge-conflicts` skill.
- Review findings → check each one against the code and judge it. The procedure's judge agent does this.

### Playbooks

Pick the one that fits the nature of the item, move its steps into the task list first, and follow them. If none fits, or the work is large and cross-cutting, or a human will review it after stepping away, design the steps for that work with the `figure-it-out` skill.

- Finding something out without changing code → `playbooks/investigation.md`
- Adding new behavior → `playbooks/feature.md`
- Fixing a bug → `playbooks/bug-fix.md`
- Changing only the structure and leaving the behavior as it is → `playbooks/refactoring.md`
- Settling a fork, or a screen or interaction, with a throwaway prototype → `playbooks/prototype.md`
- Fixing a performance problem that has a measured number → `playbooks/perf-issue.md`
- Raising one number toward a target over repeated rounds → `playbooks/hillclimb.md`

### Principles

When you apply one, read the skill named in the parentheses (`${CLAUDE_SKILL_DIR}/../<name>/SKILL.md`).

**Core**

- **Laziness Protocol** (`principle-laziness-protocol`): Refactoring, evaluating diff size, or tempted to add abstractions or layers. Choose deletion and the smallest change.
- **Foundational Thinking** (`principle-foundational-thinking`): Before writing logic. Settle the core types and data structures, the order of scaffold and feature work, and the shared state first.
- **Redesign from First Principles** (`principle-redesign-from-first-principles`): Integrating a new requirement into an existing design. Redesign as if the requirement had been there from the start.
- **Attack the Premise** (`principle-attack-the-premise`): Two or more fixes that share one premise have failed in the same place. Write the premise down and test it directly.
- **Subtract Before You Add** (`principle-subtract-before-you-add`): Sequencing an addition, refactor, or rewrite. Remove what is dead first.
- **Minimize Reader Load** (`principle-minimize-reader-load`): Reviewing or shaping code that's hard to trace. Cut layers and hidden state.
- **Outcome-Oriented Execution** (`principle-outcome-oriented-execution`): Planned rewrites and migrations with set phases. Converge on the target structure and do not build compatibility code that will be thrown away.
- **Experience First** (`principle-experience-first`): Product, UX, or feature-scope tradeoffs come up. Choose user experience over implementation convenience.
- **Exhaust the Design Space** (`principle-exhaust-the-design-space`): An interaction or architectural decision with no precedent. Build 2–3 prototypes and compare them.
- **Build the Lever** (`principle-build-the-lever`): Any non-trivial work. Do not do it by hand; build the tool that does the work or proves it.

**Structure**

- **Model the Domain** (`principle-model-the-domain`): Stateful logic, or when code branches a lot or repeats the same shape assumption across files.
- **Boundary Discipline** (`principle-boundary-discipline`): Wiring validation, error handling, or framework adapters. Gather the checks at the system boundary.
- **Type System Discipline** (`principle-type-system-discipline`): Designing types or signatures. Make illegal states unrepresentable.
- **Make Operations Idempotent** (`principle-make-operations-idempotent`): Designing commands, steps, or loops that run amid interruptions and retries.
- **Migrate Callers Then Delete Legacy APIs** (`principle-migrate-callers-then-delete-legacy-apis`): Introducing a new internal API while old callers still exist. Migrate in one go and delete.
- **Separate Before Serializing Shared State** (`principle-separate-before-serializing-shared-state`): Several actors might write to the same file, branch, or key. Separate first.

**Verification**

- **Prove It Works** (`principle-prove-it-works`): After completing the work, before declaring done. The verification line in "How to work" is this principle.
- **Fix Root Causes** (`principle-fix-root-causes`): Debugging. Trace the symptom back to the first place that went wrong and fix it there.
- **Sequence Work into Verifiable Units** (`principle-sequence-verifiable-units`): Multi-step work and the order of commits. Check each small unit before moving on.
- **Test Behavior, Not Implementation** (`principle-test-behavior-not-implementation`): You write, change, or keep a test.
- **Explain the Number** (`principle-explain-the-number`): Before you measure, and before you trust, report, or act on a number you measured.

**Delegation**

- **Guard the Context Window** (`principle-guard-the-context-window`): Context is filling up with large outputs, long files, or repeated reads. Send the bulk to a subagent and keep only the summary.
- **Never Block on the Human** (`principle-never-block-on-the-human`): Tempted to ask "should I do X?" on reversible work. The asking criteria above are this principle.

**Meta**

- **Encode Lessons in Structure** (`principle-encode-lessons-in-structure`): You are about to write the same instruction a second time. Block it with a lint rule, check, or script instead of prose.
