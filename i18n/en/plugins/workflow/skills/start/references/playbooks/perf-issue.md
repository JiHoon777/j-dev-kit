# Perf issue

> Source: `pstack/skills/poteto-mode/playbooks/perf-issue.md` in `cursor/plugins` (MIT, Lauren Tan). Cursor names were replaced with Claude Code names, and lines pointing to skills that were not imported were removed.

**When:** A performance problem with a measured number. Tie every fix to a measurement.

**You own the measurement story. Plan, review, verify the numbers.** Tie every fix to a measurement, don't read source instead of measuring.

1. Capture a baseline trace via `skills/control-ui.md` or `skills/control-cli.md`, whichever matches the surface. Vet the baseline, and each later number, with `skills/benchmark-checklist.md`.
2. Trace the code to ground hypotheses. Don't claim a perf ceiling without running it first.
   Try the performance mantras in order, cheapest first:
   1. Don't do it. Stop work whose result nothing uses rather than cheapening it.
   2. Do it, but don't do it again.
   3. Do it less.
   4. Do it later.
   5. Do it when they're not looking.
   6. Do it concurrently.
   7. Do it cheaper.

   When an earlier mantra meets the target, stop.
3. Plan the fix from the trace. If it crosses a function boundary, `skills/architect.md` first. Delegate implementation to a subagent. Review the diff. Capture a post-fix trace.
   Apply `principles/sequence-verifiable-units.md`, verifying each attempt before trying the next.
4. Parse and compare the artifacts (JSON to sqlite, diff). "Inconclusive" or wrong-surface is not a pass. Flag it.
5. Cite the measurement in the commit message. If the project uses PRs, cite it in the PR too.
6. Continue with the wrap-up in the `start` procedure.

For sustained improvement against a metric rather than a one-off fix, use `playbooks/hillclimb.md`.

**Reply:** baseline number, post-fix number, delta, artifact path.
