> Translation. Source: [plugins/architecture/skills/arch/references/enforce.md](../../../../../../../plugins/architecture/skills/arch/references/enforce.md). Update this file when the source changes. Claude does not read this file.

# Turning rules into checks

Important architecture rules (dependency direction, module boundaries, forbidden imports, no cycles) are kept with automated checks. Source: fitness functions in *Building Evolutionary Architectures*.

This skill **only proposes.** It does not install anything or create config files. Write proposals in the overview document's "Dependency rules" and in the ADR's "How to verify".

## 1. Order of choice

1. If a rule can be added to a tool the project already uses, that (e.g. if ESLint is already there, an ESLint plugin)
2. A dedicated tool widely used in that ecosystem (table below)
3. If none, the language's built-in features: module visibility (Rust `pub(crate)`, Go `internal/`, Java modules, the package `exports` field)
4. If none of those either, start with a short script (grep for import statements) and mark it "temporary" in the overview document

## 2. Tools by ecosystem

Do not write versions. When proposing, check the latest version and maintenance status in the registry.

| Ecosystem | Tool | What it does |
| --- | --- | --- |
| JS/TS | [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) | Forbid/allow rules on the resolved module graph, cycle detection |
| JS/TS | [eslint-plugin-boundaries](https://github.com/javierbrea/eslint-plugin-boundaries) | Import allow rules per element type |
| JS/TS | [Sheriff](https://github.com/softarc-consulting/sheriff) | Module boundaries and tag-based dependency rules |
| Nx monorepo | [`@nx/enforce-module-boundaries`](https://nx.dev/docs/features/enforce-module-boundaries) | Dependency constraints based on project tags |
| Java/JVM | [ArchUnit](https://github.com/TNG/ArchUnit) | Layer and slice rules as unit tests |
| Spring | [Spring Modulith](https://spring.io/projects/spring-modulith) | Verifying application module boundaries |
| Python | [import-linter](https://github.com/seddonym/import-linter) | Layers, independence, and forbidden contracts |
| Go | [go-arch-lint](https://github.com/fe3dback/go-arch-lint), depguard in golangci-lint | Component dependency rules, forbidden imports |
| Rust | Splitting into workspace crates + `pub(crate)`, [cargo-deny](https://github.com/EmbarkStudios/cargo-deny) `[bans]` | Forbidden dependencies between crates |
| PHP | [Deptrac](https://github.com/deptrac/deptrac) | Layer rules |
| .NET | [NetArchTest](https://github.com/BenMorris/NetArchTest), ArchUnitNET | Layer rules as tests |

## 3. What makes a good check

- It is part of the verify command (CI), so it runs every time.
- The failure message states the reason for the rule and how to fix it. Most tools let you attach a description (`comment`, `message`) to a rule.
- If there are many existing violations, set a baseline and block **only new violations**. Record the baseline in the overview document as debt to be reduced.
- Confirm once that it actually fails when you add a line that deliberately violates it (write this down as a task for whoever installs it).

## 4. Proposal format

```markdown
- Rule: `domain/` does not import `infra/` or `ui/`
  - Reason: ADR-0003
  - Tool: dependency-cruiser (already a devDependency) — one `forbidden` rule
  - Text for the failure message: "domain does not know about infra. Put the port interface in domain/ports and have infra implement it."
```
