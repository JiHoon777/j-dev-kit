# Investigation

> Source: `pstack/skills/poteto-mode/playbooks/investigation.md` in `cursor/plugins` (MIT, Lauren Tan). Cursor names were replaced with Claude Code names, and lines pointing to skills that were not imported were removed.

**When:** A request to find something out without changing code. "How does this work?", "Why does this happen?", "Which of the two is better?", "Don't change the code yet".

**You own the answer. Plan, route, write.**

Investigation requests are read-only. They produce a cited explanation or a recommendation, not a code change.

1. Trace the code the question is about. For motivation questions, also route through the `why` skill.
2. Throughput checkpoint stays one line: `처리량 점검: 해당 없음, 읽기만 하는 조사` (throughput checkpoint: n/a, read-only investigation).
3. Produce the output (Overview / Key Concepts / How It Works / Where Things Live / Gotchas), or a recommendation with a tradeoffs table if the request is a decision between alternatives.
4. Apply the `unslop` skill to the reply.

An investigation done without an item has no branch, no commit, no review, no merge. When a backlog item is an investigation, write the result in the item file and close it like any other item ("Investigation and prototype" under 3 in step 3 of the `start` procedure). No `architect`. If the investigation leads to a code change, hand back to the user and re-route to `bug-fix.md` or `feature.md`.

**Reply:** the investigation output. For "are we sure?" answers, include your real judgment with reasons. Push back if the premise is wrong (see "You may say no" in the `start` skill).
