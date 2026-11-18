> Translation. Source: [plugins/server/skills/server-end-check/references/jvm.md](../../../../../../../plugins/server/skills/server-end-check/references/jvm.md). Update this file when the source changes. Claude does not read this file.

# Java / Kotlin: end check

Read by `server-end-check`.

## Missing migrations

| Tool | Command |
| --- | --- |
| Flyway | Check that schema changes in the diff come with a new file in `db/migration/`, then `flyway validate` |
| Liquibase | Check that the diff has a new changeset, then `liquibase validate` |

## Config key patterns

`@Value("${`, `System.getenv(`, new keys in `application*.yml` or `application*.properties` that read `${ENV_VAR}`.
