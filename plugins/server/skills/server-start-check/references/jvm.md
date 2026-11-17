# Java / Kotlin (Spring Boot): start checks

Read by `server-start-check`. Add these rows and baseline lines to that skill's report.

## 1. Install and runtime

- Resolve dependencies with the wrapper: `./gradlew dependencies` or `./mvnw -q dependency:resolve`. Failure → **stop**.
- Compare the toolchain in the build file with `java -version`. Mismatch → fail.

## 2. LSP

Check that the `jdtls-lsp` (Java) or `kotlin-lsp` (Kotlin) plugin is enabled and its executable is on PATH. If not, it is not a failure; return it as a question.

## 3. Migration status

| Detected | Tool | Applied status |
| --- | --- | --- |
| `flyway.conf` or `db/migration/` | Flyway | `flyway info` (look for pending) |
| `liquibase.properties` or a changelog | Liquibase | `liquibase status --verbose` |

Pending migrations → fail (return a question about applying them). Diverged history or failed migrations → **stop**.

## 4. Baseline

Use the verification command from the project's CLAUDE.md. If the verification command chains several checks (for example `pnpm lint && pnpm check && pnpm test && pnpm build`), run each part separately, so a failure in one does not hide the others. If CLAUDE.md has no verification command, use `./gradlew check` or `./mvnw -q verify`. Record command, exit code, failure count, and failing names (first 10 if many).

## 5. Rules during implementation (to return)

- Validate request bodies with Bean Validation (`@Valid` and constraints) and use DTOs instead of exposing entities.
- Use method security (`@PreAuthorize` or the project's equivalent) for authorization.

## Rows to add

```markdown
| Dependencies | … | ./gradlew dependencies |
| Java version | … | … |
| LSP | … | jdtls-lsp enabled |
| Migration status | … | `flyway info`: 0 pending |
```
