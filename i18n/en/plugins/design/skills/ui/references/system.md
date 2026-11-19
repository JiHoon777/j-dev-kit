> Translation. Source: [plugins/design/skills/ui/references/system.md](../../../../../../../plugins/design/skills/ui/references/system.md). Update this file when the source changes. Claude does not read this file.

# ui system: create or update DESIGN.md

The format is Google DESIGN.md (alpha). Do not write the spec from memory; get it with `npx -y -p @google/design.md@0.4.0 designmd spec --rules` and follow it (use this form for the commands below too; `npx @google/design.md …` prints nothing on Windows).

## 1. Read

- Token sources: CSS variables (`:root`, `@theme`), tailwind config, theme files, component library config.
- An existing `DESIGN.md`, and the design section of CLAUDE.md.
- If there are no token sources, say so and ask whether to define new ones. If so, use only values the user picks.

## 2. Write

- **New:** put only values found in the code into the YAML tokens. Keep only sections that have content. Ask about what the code cannot tell (tone, principles, Do's and Don'ts). Do not make it up without asking.
- **Update:** show only the tokens where the code and DESIGN.md differ, as a table (token, DESIGN.md value, code value). Ask which side is right.

Get approval, then write the root `DESIGN.md`.

## 3. Check

Run `npx -y -p @google/design.md@0.4.0 designmd lint DESIGN.md` and fix errors. For an update, show the changed tokens with `diff`.

## 4. Connect

DESIGN.md is not read automatically. If CLAUDE.md has no `@DESIGN.md` line, ask whether to add one, and add it if approved.

## 5. Commit

Get approval and commit as `design: DESIGN.md <create|update>`.
