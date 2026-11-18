> Translation. Source: [plugins/architecture/skills/arch/references/design.md](../../../../../../../plugins/architecture/skills/arch/references/design.md). Update this file when the source changes. Claude does not read this file.

# arch design: structure and stack design

Design a new project, the structure of a new feature, a structural change, or the stack of a new component. **Do not edit code.** The results are an overview document, ADRs, and research files, and you get approval before writing them.

What to design: the arguments after `design` (without `--research`). If empty, ask what to design.

## 1. Read

- The overview document and ADRs (location in `references/docs.md`). `accepted` ADRs are constraints.
- CLAUDE.md, manifests (`package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `pom.xml`, `*.csproj`, `pubspec.yaml`, etc.), the top-level folder structure.
- The file names and dates in the research folder.
- For a new project (almost no code), stop here.
- For an existing project, read the code connected to what you are designing.
  - Small scope (one or two modules): read it directly.
  - Large scope (several modules, new structure): launch at most 2 `Explore` agents, on different areas, in one message. Have them follow similar existing features and connected code and return the files that must be read, then read those files directly.

## 2. App type and quality goals

1. **App type:** which of the types in section 2 of `references/stack.md` is it (it can be more than one).
2. **Set 3-5 quality goals** in ranked order. Write each as a scenario that can be checked (e.g. "95% of sign-up requests within 300ms", "add a new payment method by changing only one module").
3. **Questions:** only those that code and docs cannot answer and that change the design, at most 3 at once. For example: expected scale, languages you are skilled in, deployment environment, things that must be used. Decide the rest reasonably and write them down as assumptions. Do not finalize the design before getting answers.

## 3. List of decisions

List the decisions to make in this design, and classify each one.

- **One-way doors** (hard to reverse): language and runtime, primary database, rendering approach, module boundaries and dependency direction, public API and data formats, deployment form (server, serverless, static, app store)
- **Two-way doors** (easy to reverse): most libraries, internal folder names, tools that can be swapped out

In an existing project, do not put already-decided things (the existing stack, `accepted` ADRs) on the list. If there is a reason to change one, write it separately under "Revisit".

## 4. Survey

- **Always, when there is a stack decision:** launch `architecture-researcher` as described in section 5 of `references/stack.md` and in `references/research.md`. Split different decisions across agents and launch them at the same time in one message (at most 3).
- **Structural guidance only with `--research`:** use the same agent to research the latest structural guidance for this app type and stack (the recommended structure in the official docs, the framework's project structure guide). Without `--research`, use the existing files in the research folder and state their dates. If there are no existing files either, design with `references/criteria.md` alone, and at the end of the report write "The latest guidance can be checked with `--research`".
- Once you have the survey results, do not use numbers that have no [official] or [standard] source.

## 5. Design

Decide using the criteria in `references/criteria.md` and the factor table in `references/stack.md`.

- **One-way doors:** compare 2-3 options and recommend one. A comparison table (the format in section 6 of `references/stack.md`) and two or three sentences on why you recommend it.
- **Two-way doors:** decide in one line. Do not list options.
- **Structure:**
  - Module map (path → responsibility → public interface → what makes it change), dependency direction.
  - For 2-4 common changes, "How to add a new X": which module, which files.
  - Map each layer, module, and abstraction to the quality goal it contributes to, one by one. If there is no matching goal, remove it.
  - The number of innovation tokens (section 4 of `references/stack.md`).
- **Enforcement:** for each important rule, propose a check as described in `references/enforce.md`.
- If the framework defines a structure, follow it, and add only what is needed on top of it.

## 6. Show and get approval

Show it all at once.

```markdown
### App and quality goals
- Type: …
- Quality goals: 1. … 2. … 3. …
- Assumptions: …

### Stack
<comparison table and recommendation per decision (one-way doors)>
- <one line per two-way door>
Innovation tokens: N (…)

### Structure
<module map table, dependency direction>
<how to add a new X>

### Rules to enforce
- …

### Documents to write
- Overview: <path> (new / edit)
- ADR: NNNN-…, NNNN-…
- Research: <file name>

### Revisit (if any)
- …
```

Ask: "Shall I write the documents as shown? If there is a decision you want to change, let me know." Do not write any file before getting an answer. If the user changes a decision, compare only that part again and show it again.

## 7. Write the documents

Write them in the format of `references/docs.md`.

1. The research file (if you did a survey).
2. An ADR (`accepted`) for each one-way door decision. Link the research file in the "Decision" section.
3. The overview document: create it, or if it exists, edit only the sections that changed. Do not touch other sections.

## 8. Fresh-reader check

Launch one `general-purpose` agent. It cannot see this conversation, so put the following in its instructions.

- What to read: the paths of the overview document and ADRs you just wrote, and the repository.
- What to do: for each "How to add a new X" in the overview document, follow the steps in the actual code (for a new project, sketch the structure from the documents alone). Do not edit files and do not run commands.
- What to return: the steps where it got stuck (a path does not exist, the example file is different, it is unclear where to put something) and questions the documents cannot answer. Only what it confirmed.

Improve the documents with what comes back. If a question would require changing a design decision, do not change it; ask the user.

## 9. Wrap up

1. If you created the overview document, ask whether to add one line to CLAUDE.md (section 5 of `references/docs.md`).
2. Report: the files written, the list of decisions (ADR numbers for one-way doors), the proposed checks, assumptions, what you could not verify. Commit only when the user asks.
