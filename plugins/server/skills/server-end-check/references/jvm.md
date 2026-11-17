# Java / Kotlin: end checks

Read by `server-end-check`. Add these rows to that skill's report.

## Missing migration

| Tool | Command |
| --- | --- |
| Flyway | Check that the schema change in the diff has a new file under `db/migration/`, then `flyway validate` |
| Liquibase | Check that the diff has a new changeset, then `liquibase validate` |

If the project uses Hibernate `ddl-auto` other than `validate` or `none` outside tests, report it: the schema may be changing without migrations.

## Apply from scratch (only after approval)

- Flyway: `flyway clean` (only if `cleanDisabled` is false for the development database) then `flyway migrate`
- Liquibase: `liquibase drop-all` then `liquibase update` against the development database

## Environment variables read in code

Patterns on added lines: `@Value("${`, `System.getenv(`, new keys in `application*.yml` / `application*.properties` that read `${ENV_VAR}`.

## Rows to fill

Fill the matching rows of the main table (do not add a second row):

```markdown
| Missing migration | … | `flyway validate` exit 0 |
```
