---
name: start
description: Use when implementing a backlog item. Invoke when the user asks to start or implement an item, or to continue a work branch or review, wrap up, or merge it. Goes through planning, implementation, verification, review, fixing findings, and the merge in one run, and asks only what is truly needed. Creating a new item is the backlog skill's job. Not for requests to just fix something with no mention of an item or branch.
argument-hint: "[backlog number or part of a name] [--here]"
allowed-tools: Bash(git status *), Bash(git branch --show-current), Bash(git branch --list *), Bash(git log *), Bash(git diff *), Bash(ls *)
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> Translation. Source: [plugins/workflow/skills/start/SKILL.md](../../../../../../plugins/workflow/skills/start/SKILL.md). Update this file when the source changes. Claude does not read this file.

# start

Arguments: `$ARGUMENTS`

Implement one backlog item through to the merge. The procedure is in `${CLAUDE_SKILL_DIR}/references/procedure.md`. After deciding below where to work, if the work happens in this session, read that file all the way through with the Read tool and follow it as written. `<scripts>` in the procedure file is `${CLAUDE_SKILL_DIR}/scripts`, and `<ref>` is `${CLAUDE_SKILL_DIR}/references`.

## 1. Where to work

- **If the arguments have `--here`:** remove it and work in this session.
- **Otherwise:** open a sub-session.
  1. If there is no tool that starts a new session the user can open and talk to directly (for example the desktop app's `start_session`), say in one line that the work happens in this session, and follow the procedure.
  2. First find the item in this session ("Finding the item" in step 1 of the procedure). If this item's `w/` branch already exists, do not open a session; tell the user to continue in the session that worked on that branch. If that session no longer exists, continue the branch in this session as the procedure says.
  3. Open one session. The user asked for this work, so start it right away instead of proposing it. It is a new worktree off the base branch, with the branch name `w/<item file name without .md>`.

     Model and effort: if this session is Fable, pass `model` as the latest model one step lower (for now Opus, `claude-opus-5-5`) and `effort` as `high`. The tool does not take an effort above this session's, so if this session's effort is below `high`, leave `effort` out (it inherits) and say so. On Opus or lower, pass neither (it inherits this session's model and effort).

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

Rules in the project CLAUDE.md take precedence over this skill.

## 3. Working principles

### Asking criteria

Ask only these five. Every question point in the `backlog` skill and in the procedure follows these criteria.

1. Work that cannot be undone or that goes outside: merging, pushing to the base branch or a deploy branch, deleting, a remote DB, deploying. Other branches (work branches) are pushed without asking.
2. Work that changes something outside the project or shared settings: installing plugins or skills, CLAUDE.md.
3. Product or taste decisions that code or a run cannot settle.
4. Choosing what to do: which items to create, how far to go.
5. States that could lose work: uncommitted changes, a branch whose owner is unknown.

Do not ask anything else. Decide, and go on while writing down what was decided and why (full text: `principles/never-block-on-the-human.md`).

- Do not ask about a fork that running something would settle (structure, library, approach). Run it, decide, and write down the result and the evidence (`playbooks/prototype.md`).
- Do not ask questions like "Shall I go on to the next step?"
- If `git revert` or removing a worktree can undo it, it can be undone.
- If the user says "let me see the plan" or "stop here", do so.

### Writing down decisions

Write what was decided without asking under `### 정한 것` (decisions) in the item file's `Implementation Notes`, one line each.

```markdown
- decision — reason (name of the principle or skill applied) — cost if wrong
```

Raise the ones with a high cost if wrong in the last message. These lines are not something the user decided. The review and the judge examine them.

### How to work

- Do not assume what you do not know; say it. Do not ask what code and docs can answer.
- Do only what the item requires. Solve it with the smallest change, and every changed line must trace back to the item (full text: `principles/laziness-protocol.md`).
- Before saying "done", run verification fresh and show what you confirmed on the real output (full text: `principles/prove-it-works.md`).
- You may say no. If a proposal to widen the scope, or an approach you were shown, is not worth its cost, say so.
- Do not hand a person a check you can run yourself.
- Give evidence for each claim, or mark it as confirmed, inferred, or guessed.

## 4. Index

The body files are under `${CLAUDE_SKILL_DIR}/references/`. When a "when" below applies, read that file with the Read tool and follow it. Write the name of what you applied in the reason of the decision line. Do not cite a name without reading the body.

### Must follow

- The first message → restate the goal and the smallest change that meets it, then go on.
- You do not know how the code to change works → `skills/how.md`. The question is why it came to be that way → `skills/why.md`.
- A fork that running something would settle → do not ask; `playbooks/prototype.md`.
- Before writing code → settle the shape of the data first. A change that crosses a function boundary → `skills/architect.md`.
- Changing a screen or reproducing a UI bug → `skills/control-ui.md`. For a CLI or TUI → `skills/control-cli.md`. If the project has a `verify-*` skill, follow that skill and its feature map first.
- The project has no set way to drive the real app and check it → `skills/create-verification-skill.md`. Whether to create one goes into the pre-start questions, once per project. The feature map does not match the app → `skills/maintain-verification-skill.md`.
- A claim of "fixed" or "faster" → `skills/verify-this.md`.
- Reporting a measured number, or deciding by it → `skills/benchmark-checklist.md`.
- A diff that is small but reaches wide and is hard to trust → `skills/blast-radius.md` before the review.
- Before committing → `skills/deslop.md`.
- Prose (replies, item files, reports) → `skills/unslop.md`. Docs and commit messages → `skills/technical-writing.md`.
- Merge conflicts → `skills/fix-merge-conflicts.md`.
- Review findings → check each one against the code and judge it. The procedure's judge agent does this.

### Playbooks

Pick the one that fits the nature of the item, move its steps into the to-do list, and follow them. If none fits, go with the procedure's default flow.

- Fixing a bug → `playbooks/bug-fix.md`
- Changing only the structure and leaving the behavior as it is → `playbooks/refactoring.md`
- Settling a fork, or a screen or interaction, with a throwaway prototype → `playbooks/prototype.md`
- Fixing a performance problem that has a measured number → `playbooks/perf-issue.md`
- Raising one number toward a target over repeated rounds → `playbooks/hillclimb.md`

### Principles

Read `principles/<name>.md` when you apply one.

**Core**

- **Laziness Protocol** (`laziness-protocol`): Refactoring, evaluating diff size, or tempted to add abstractions or layers. Choose deletion and the smallest change.
- **Foundational Thinking** (`foundational-thinking`): Before writing logic. Settle the core types and data structures, the order of scaffold and feature work, and the shared state first.
- **Redesign from First Principles** (`redesign-from-first-principles`): Integrating a new requirement into an existing design. Redesign as if the requirement had been there from the start.
- **Attack the Premise** (`attack-the-premise`): Two or more fixes that share one premise have failed in the same place. Write the premise down and test it directly.
- **Subtract Before You Add** (`subtract-before-you-add`): Sequencing an addition, refactor, or rewrite. Remove what is dead first.
- **Minimize Reader Load** (`minimize-reader-load`): Reviewing or shaping code that's hard to trace. Cut layers and hidden state.
- **Outcome-Oriented Execution** (`outcome-oriented-execution`): Planned rewrites and migrations with set phases. Converge on the target structure and do not build compatibility code that will be thrown away.
- **Experience First** (`experience-first`): Product, UX, or feature-scope tradeoffs come up. Choose user experience over implementation convenience.
- **Exhaust the Design Space** (`exhaust-the-design-space`): An interaction or architectural decision with no precedent. Build 2–3 prototypes and compare them.
- **Build the Lever** (`build-the-lever`): Any non-trivial work. Do not do it by hand; build the tool that does the work or proves it.

**Structure**

- **Model the Domain** (`model-the-domain`): Stateful logic, or when code branches a lot or repeats the same shape assumption across files.
- **Boundary Discipline** (`boundary-discipline`): Wiring validation, error handling, or framework adapters. Gather the checks at the system boundary.
- **Type System Discipline** (`type-system-discipline`): Designing types or signatures. Make illegal states unrepresentable.
- **Make Operations Idempotent** (`make-operations-idempotent`): Designing commands, steps, or loops that run amid interruptions and retries.
- **Migrate Callers Then Delete Legacy APIs** (`migrate-callers-then-delete-legacy-apis`): Introducing a new internal API while old callers still exist. Migrate in one go and delete.
- **Separate Before Serializing Shared State** (`separate-before-serializing-shared-state`): Several actors might write to the same file, branch, or key. Separate first.

**Verification**

- **Prove It Works** (`prove-it-works`): After completing the work, before declaring done. The verification line in "How to work" is this principle.
- **Fix Root Causes** (`fix-root-causes`): Debugging. Trace the symptom back to the first place that went wrong and fix it there.
- **Sequence Work into Verifiable Units** (`sequence-verifiable-units`): Multi-step work and the order of commits. Check each small unit before moving on.
- **Test Behavior, Not Implementation** (`test-behavior-not-implementation`): You write, change, or keep a test.
- **Explain the Number** (`explain-the-number`): Before you measure, and before you trust, report, or act on a number you measured.

**Delegation**

- **Guard the Context Window** (`guard-the-context-window`): Context is filling up with large outputs, long files, or repeated reads. Send the bulk to a subagent and keep only the summary.
- **Never Block on the Human** (`never-block-on-the-human`): Tempted to ask "should I do X?" on reversible work. The asking criteria above are this principle.

**Meta**

- **Encode Lessons in Structure** (`encode-lessons-in-structure`): You are about to write the same instruction a second time. Block it with a lint rule, check, or script instead of prose.
