> Translation. Source: [plugins/architecture/skills/arch/references/criteria.md](../../../../../../../plugins/architecture/skills/arch/references/criteria.md). Update this file when the source changes. Claude does not read this file.

# Criteria for good architecture

Used by both design and review. Only criteria with sources are listed. To make a finding based on a principle not listed here, attach a source.

An **AI evidence** line appears only when there is research evidence about coding agents. [R] is papers or large-scale data, [V] is vendor research. Items without AI evidence carry the same weight as criteria.

Criteria set: ISO/IEC 25010:2023 maintainability (modularity, reusability, analysability, modifiability, testability) — [arc42 summary](https://quality.arc42.org/articles/iso-25010-update-2023). 1-8 below spell this out in a checkable form, and 9-10 are suitability and extensibility.

## 1. Modularity and boundaries

- **What:** A module hides one decision that can change (information hiding). The public interface is small and the implementation is deep. Callers do not need to know the internals.
- **Check:**
  - Compare a module's public surface (exports, public, entry file) with the amount of implementation behind it. Many shallow modules that mostly just pass things through are a cost.
  - **Deletion test:** if you delete this module, does the complexity disappear, or does it spread to many callers? If it spreads, the module is pulling its weight. If it disappears, it is an unneeded layer.
  - Places that directly import another module's internal files.
- **Sources:** Parnas, [On the Criteria To Be Used in Decomposing Systems into Modules (1972)](https://dl.acm.org/doi/10.1145/361598.361623); Ousterhout, *A Philosophy of Software Design* (deep modules).

## 2. Coupling and cohesion

- **What:** Keep together what changes together, and keep apart what changes separately. Dependencies flow in one direction with no cycles. Stable things (domain rules) do not depend on things that change often (UI, frameworks, external services).
- **Check:**
  - Cycles in the import graph. With a tool if there is one (`references/enforce.md`), otherwise by grepping import statements.
  - File pairs that always change together in `git log` but are far apart (the measurement in `references/review.md`).
  - Places where domain code directly uses framework, DB, or HTTP types.
- **Sources:** Constantine & Yourdon, *Structured Design* (coupling and cohesion); Robert C. Martin, *Clean Architecture* (the dependency rule, the acyclic dependencies principle); Khononov, *Balancing Coupling in Software Design* (evaluating coupling by strength, distance, and volatility).

## 3. Change locality

- **What:** A common change (adding or modifying one feature) is finished within a few files and one or two modules.
- **Check:** The median and top 10% of files changed per commit recently. Pick a few feature commits and see how many layers and folders they touched. If one feature crosses 5-6 layers every time, that is a cost.
- **Sources:** A consequence of the same principles as 1 and 2 above. Hotspot analysis: [Tornhill, *Your Code as a Crime Scene*](https://pragprog.com/titles/atcrime2/your-code-as-a-crime-scene-second-edition/), [summary](https://understandlegacycode.com/blog/focus-refactoring-with-hotspots-analysis/).
- **AI evidence [R]:** As the number of files to change grows, agent success rates drop sharply. On SWE-bench-Live, small single-file fixes succeed 48% of the time, and fixes touching 3 or more files less than 10% ([arXiv 2505.23419](https://arxiv.org/abs/2505.23419)).

## 4. Analysability: reading and finding

- **What:** Names speak the domain, paths are predictable, and call relationships can be followed by search.
- **Check:**
  - Are there several names for the same concept, or names that differ from what the thing does?
  - Places where connections cannot be found by search, such as names built from strings, auto-registration based on reflection or decorators, and global events. Do not flag the framework's standard way of doing things. Look only at places where the project built the same thing separately, as magic.
  - Can you guess where things are just from file and folder names?
- **Sources:** ISO 25010 analysability; Evans, *Domain-Driven Design* (ubiquitous language).
- **AI evidence [R]:** Hiding or badly naming identifiers sharply lowers LLM code comprehension ([arXiv 2510.03178](https://arxiv.org/abs/2510.03178), [arXiv 2307.12488](https://arxiv.org/abs/2307.12488)).

## 5. Testability and feedback loops

- **What:** Modules can be tested in isolation, the project has a single verify command that runs everything at once (lint, types, tests, build), and its results are fast and the same every time. External input is parsed and validated at the boundary, and the inside uses validated types.
- **Check:**
  - The verify command in CLAUDE.md, package.json, Makefile, justfile, etc. Do not run the command.
  - Do tests exercise modules through their public interface rather than reaching into their internals? Is there a place to swap out external dependencies?
  - Are there many places that turn off static types or schema validation (`any`, ignore comments)?
- **Sources:** ISO 25010 testability; Feathers, *Working Effectively with Legacy Code* (seams); [Parse, don't validate](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/).
- **AI evidence [R]:** 94% of LLM-generated TypeScript compile errors are type errors, and guiding with type checking reduces errors ([arXiv 2504.09246](https://arxiv.org/abs/2504.09246)). This is evidence that the type checker provides a signal for fixes, not evidence that typed languages are better overall.

## 6. Consistency

- **What:** There is one way to do the same job (data access, error handling, reading config, logging, HTTP calls). Where shared code lives is decided.
- **Check:** Are there two or more libraries for the same purpose (two ORMs, two HTTP clients)? Is similar code copied in several places?
- **Sources:** ISO 25010 reusability and modifiability; Hunt & Thomas, *The Pragmatic Programmer* (DRY is about duplication of knowledge, not code).
- **See also:** Small duplication that is likely to change separately is better than coupling. Flag only duplication of the same knowledge (rules, invariants).

## 7. Enforcing rules (fitness functions)

- **What:** Important architecture decisions (dependency direction, module boundaries, forbidden imports) exist not only in documents but as automated checks (lint rules, architecture tests). When a check fails, it says what to fix and how.
- **Check:** Is there tool configuration from `references/enforce.md`? Rules in the overview document or ADRs that have no check.
- **Sources:** Ford, Parsons, Kua, Sadalage, *Building Evolutionary Architectures* 2nd ed. (fitness functions).
- **AI evidence [R]:** Agents often violate a project's design constraints while passing tests. Passing tests and following the design are almost uncorrelated ([arXiv 2604.05955](https://arxiv.org/abs/2604.05955), [arXiv 2603.27745](https://arxiv.org/abs/2603.27745)).

## 8. Decision records

- **What:** Decisions that are hard to reverse have their reasons and alternatives kept in ADRs. The overview document is a short map and does not repeat what can be learned by reading the code. CLAUDE.md is short.
- **Check:** The ADR folder, the overview document, the length of CLAUDE.md. Places where the documents and the actual code disagree.
- **Sources:** Nygard, [Documenting Architecture Decisions (2011)](https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions); [MADR](https://adr.github.io/madr/); [arc42](https://arc42.org/overview).
- **AI evidence [R]:** Repository context files barely raised success rates and increased cost by more than 20%, and LLM-generated ones actually lowered them. Keep them short, with only what is truly needed, written by people ([arXiv 2602.11988](https://arxiv.org/abs/2602.11988)).

## 9. Suitability

- **What:** The structure and stack fit this project's quality goals, scale, and team. Nothing that is not needed now was built in advance, and new or less proven technology is used only where it is truly needed.
- **Check:**
  - Write down 3-5 quality goals (arc42 1.2) in ranked order, and ask which goal each structural choice contributes to. A layer, service, or abstraction that contributes to no goal is over-design.
  - Things that are heavy for the scale (microservices, event sourcing, or multiple DBs for a handful of users).
  - The number of new or less proven technologies (innovation tokens in `references/stack.md`).
- **Sources:** [arc42 quality goals](https://docs.arc42.org/section-1/); McKinley, [Choose Boring Technology](https://mcfunley.com/choose-boring-technology); Fowler, [Yagni](https://martinfowler.com/bliki/Yagni.html); Bezos 2015 shareholder letter (Type 1/Type 2 decisions — [summary](https://fortune.com/2017/05/11/jeff-bezos-shareholder-letter/)).

## 10. Extensibility

- **What:** For each kind of future change (a new screen, a new endpoint, a new payment method, a new data source) there is a defined place to put it. That change is finished in one place, without editing existing code all over. There is no god module that everything passes through.
- **Check:**
  - For each module, write down its **volatility**: what makes it change, and how often. If things that change often are mixed deep inside stable things, that is a cost.
  - Follow "How to add a new X" in the actual code. How many files and how many modules have to change?
  - Files with high line counts and high change frequency that are imported from a great many places.
  - A seam (a place to swap things out) is justified only when there are two or more implementations or one is coming soon. An interface with only one implementation is a hypothesis.
- **Sources:** Parnas (dividing modules by likelihood of change); Khononov (volatility); Ford et al. (evolutionary architecture); Feathers (seams).

## Do not flag

- Complexity that comes from the domain being inherently complex
- Structure that the framework enforces or recommends (the approach in that framework's official docs)
- Taste: folder naming style, quotes, line length, syntax choices
- Principles without sources, or because a pattern is fashionable (merely "not using" clean architecture, hexagonal, or microservices)
- Judgments based only on the shape of folders. Only what was confirmed by code or measurement
- Old code that is outside this scope and whose cost does not show up in measurements either
- What an accepted ADR has already decided. Propose a new ADR only when a reason to revisit that decision (the ADR's "When to revisit") has come up

## What not to use as AI evidence

Do not use claims backed only by practitioner opinion (an upper limit on file line count, a particular folder structure being good for AI, etc.) as criteria. If you found new research with `--research`, write it in the research file with its source, and mark in the report only where it differs from the criteria in this file.
