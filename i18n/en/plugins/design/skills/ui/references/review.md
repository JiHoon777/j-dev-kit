> Translation. Source: [plugins/design/skills/ui/references/review.md](../../../../../../../plugins/design/skills/ui/references/review.md). Update this file when the source changes. Claude does not read this file.

# ui review: review a built screen

## 1. Prepare

- **Screen:** use the URL from the arguments. Without one, start the dev server (`.claude/launch.json` if present). If it is unclear which screen, ask.
- **Baseline:** the root `DESIGN.md` and this screen's `docs/design/*/decisions.md`. If several records match or it is unclear, ask. If neither exists, say only accessibility and consistency will be checked.

## 2. Review

Launch the `design:design-reviewer` agent. Pass it the URL, the DESIGN.md path, the decisions.md path, and the code paths to look at.

## 3. Report

Show the findings as received, 🔴/🟡/⚪. Ask which to fix. This mode does not fix anything.
