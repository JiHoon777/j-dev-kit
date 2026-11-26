> Translation. Source: [plugins/workflow/skills/ui-design/references/mockup.md](../../../../../../../plugins/workflow/skills/ui-design/references/mockup.md). Update this file when the source changes. Claude does not read this file.

# ui-design mockup: make, pick, and record mockups

Handle one screen at a time.

## 1. Brief

Settle the screen, who uses it, what they do there, and the real copy and data. Ask only what code and docs cannot answer, at most 3 questions at once. Do not ask how many mockups. The default is 3. If the user said a number, use that number.

- One: build one direction right away. Skip step 2.
- Several: at most 5. Compare after building and pick.

Check whether the root has a `DESIGN.md` (`ls DESIGN.md`). If not, suggest `system` first. If the user wants to go ahead anyway, go ahead. If the `start` skill invoked this before planning, do not suggest it (DESIGN.md is handled in that item's plan).

## 2. Directions (several only)

Show a table before building. Build right away without waiting for confirmation. If the user steps in to change it, follow them.

| Name | Axis | Strength | Cost |
| --- | --- | --- | --- |

- Names say what they are (no "Option A").
- The axis is one of hierarchy, layout, typography, color, density, composition. Each direction uses a different axis.
- If you could swap the headlines of two mockups without noticing, they are too similar. Change one.
- Colors and fonts follow DESIGN.md. Add a direction that changes the identity only if the user wants it.

## 3. Canvas

Create a Design canvas with the Artifact tool (`action: quickstart`, `intent: design`, `design_systems: false`). Name this repo's DESIGN.md as the design system. One artboard per direction, titled with the direction's name. Use real copy, no lorem ipsum.

When done, give the link and stop, so the user can look, edit on the canvas, and pick. Do not recommend one in advance.

## 4. Refine

After the pick, change only that artboard. Do not make new directions unless the user asks to widen again.

## 5. Record

When the user says it is done, record it. Do not write mockup files to the repo. The canvas is the source.

```markdown
- Mockup: <canvas link>
- Brief: <one sentence>
- Chosen: <name> — <why>
- Rejected: <name> — <why> (omit when there was one mockup)
- Changed while refining: …
```

- If the `start` skill invoked this before planning, put this under `### 사용자가 정한 것` (decided by the user) in the item file's `Implementation Notes` (the user chose it, so it is not under review). Step 4 of the start procedure writes it to the item file, and the implementation follows the chosen option.
- Otherwise, report it.

## When the canvas is unavailable

If the Artifact tool is missing or refused (API key login, `claude -p`, organization settings), write a single `variants.html` in a temporary folder outside the repo. It is one HTML file that switches between the mockups with tabs. Open it in a browser to show it, and follow the same steps from step 3. Put its path on the record's mockup line, and say it is temporary and may be deleted.
