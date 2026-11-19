> Translation. Source: [plugins/design/skills/ui/references/mockup.md](../../../../../../../plugins/design/skills/ui/references/mockup.md). Update this file when the source changes. Claude does not read this file.

# ui mockup: make, pick, and record mockups

Handle one screen at a time.

## 1. Brief

Settle the screen, who uses it, what they do there, and the real copy and data. Ask only what code and docs cannot answer, at most 3 questions at once. **Always ask how many mockups.**

- **One:** build one direction right away. Skip step 2.
- **Several:** 3 by default, at most 5. Compare after building and pick.

If there is no DESIGN.md, suggest `/ui system` first. If the user wants to go ahead anyway, go ahead.

## 2. Directions (several only)

Show a table before building and get confirmation.

| Name | Axis | Strength | Cost |
| --- | --- | --- | --- |

- Names say what they are (no "Option A").
- The axis is one of hierarchy, layout, typography, color, density, composition. Each direction uses a different axis.
- If you could swap the headlines of two mockups without noticing, they are too similar. Change one.
- Colors and fonts follow DESIGN.md. Add a direction that changes the identity only if the user wants it.

## 3. Canvas

Create a Design canvas with the Artifact tool (`action: quickstart`, `intent: design`, `design_systems: false`). Name this repo's DESIGN.md as the design system. One artboard per direction, titled with the direction's name. Use real copy, no lorem ipsum.

When done, give the link and **stop.** The user looks, edits on the canvas, and picks. Do not recommend one in advance.

## 4. Refine

After the pick, change only that artboard. Do not make new directions unless the user asks to widen again.

## 5. Record

When the user says it is done, record it.

1. The folder is `docs/design/<NNN>-<slug>/`. NNN is the last number in `docs/design/` + 1, or 001 the first time.
2. Read the canvas again, including the user's edits, into that folder (`action: read`, `url`, `paths`, `out_dir`).
3. Write `decisions.md`.

   ```markdown
   # <screen>

   - Date: <today>
   - Canvas: <link>
   - Brief: <one sentence>
   - Chosen: <name> — <why>
   - Rejected: <name> — <why> (omit when there was one mockup)
   - Changed while refining: …
   - Open questions: …
   ```

4. Get approval and commit as `design(<NNN>): <screen> mockup`.

## When the canvas is unavailable

If the Artifact tool is missing or refused (API key login, `claude -p`, organization settings), write a single `variants.html` in the same folder. It is one HTML file that switches between the mockups with tabs. Open it in a browser to show it, and follow the same steps from step 3. Put `variants.html` on the canvas line of `decisions.md`.
