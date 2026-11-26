---
name: figure-it-out
description: "When no playbook fits, or for work a human reviews after stepping away, such as a large migration or an ambitious multi-part change. Design the workflow first, scale rigor to the task, run a hypothesis loop, and log decisions."
disable-model-invocation: true
---

# Figure it out

> Source: `pstack/skills/figure-it-out/SKILL.md` in `cursor/plugins` (MIT, Lauren Tan). Cursor names were replaced with Claude Code names, and lines pointing to skills that were not imported were removed.

**When:** When no playbook fits, or for work a human reviews after stepping away, such as a large migration or an ambitious multi-part change.

When the task matches no playbook, design one. The deliverable before any code is the workflow itself: a sequence of phases that scales rigor to the task, runs the scientific method, and leaves a decision trail a human can audit after stepping away.

## Start

Open a task list whose first item is to read the principles index in the SKILL.md of the `start` skill. Then add the phases below as tasks.

## Phase A: Frame

Ground first, then commit. Don't start the run until you can state:

- The definition of done as a falsifiable predicate (the `principle-prove-it-works` skill).
- Scope, quantified: rough units and effort, plus the blockers grounding surfaced.
- The rigor level, biased high. One-way doors and high blast radius get more. Reversible low-stakes steps get less. Rigor is gates and artifacts, not "try harder".

Present the framing and tradeoffs before committing to a long run, then proceed. Do not wait for approval (the `principle-never-block-on-the-human` skill). If only a person can decide how far to go, put just that into the pre-start questions of the `start` procedure (asking criterion 4).

## Phase B: Design the workflow

Decompose into atomic, independently-landable units. Sequence riskiest-unknown-first. Scaffold and verification come before features (the `principle-foundational-thinking` skill).

- Build the verification harness before the work, with the baseline captured from the pre-change state, so the check reads as "old value vs new value".
- For one-way-door design decisions, run the `architect` skill. Skip it for mechanical work whose shape is already concrete. Re-contesting a settled design is over-engineering (the `principle-laziness-protocol` skill).
- Decide what fans out. Parallelize only across seams, and give each worker its own worktree or branch (the `principle-separate-before-serializing-shared-state` skill). Don't over-fan.
- Write the designed phase list down. That list is what the human reviews. Put it in the item file's `Implementation Plan`.

Then execute the design. Add its steps to the task list as concrete items between the Phase C and Phase D entries. Run each under the Phase C loop discipline, and weave the Phase D log through them, a line as each step lands, rather than saving the whole trail for the end.

## Phase C: Run the loop

Each unit is an experiment. State the hypothesis, make the smallest change, measure against the predicate on the real artifact, keep it if it advanced, revert it if it didn't. Apply the `principle-sequence-verifiable-units` skill, verifying each unit before starting the next instead of batching checks at the end.

- Verify by inspecting the artifact, never a self-report. When something passes too easily, suspect the observation method before the system.
- Pair delegated work with a judge. If a worker games the gate, reset and harden the contract. If the gate itself is wrong, fix the gate in its own change rather than routing around it.
- A verdict is VERIFIED, NOT VERIFIED, or INCONCLUSIVE. Inconclusive is not a pass. Don't hide a negative.

## Phase D: Keep the audit trail

Log decisions under `### 정한 것` (decisions) in the item file's `Implementation Notes` as `decision — reason — cost if wrong`. For each unit, also write one line with the evidence (commit, `file:line`, command output) and the result. The trail plus the diff is what lets the human come back and trust the work.

## Phase E: Verify and hand back

Check the whole against the Phase A predicate on the real product, not just the harness. Encode any recurring correction as a gate, a lint rule, a check, or a script (the `principle-encode-lessons-in-structure` skill).

**Reply:** the playbook you designed, the rigor level and why, where the decisions are logged, what's verified against the predicate, and what's still open.
