> Translation. Source: [plugins/server/skills/server-start-check/references/jvm.md](../../../../../../../plugins/server/skills/server-start-check/references/jvm.md). Update this file when the source changes. Claude does not read this file.

# Java / Kotlin (Spring Boot): start check

Read by `server-start-check`.

## Follow

- Validate request bodies with Bean Validation (`@Valid` and constraints), and exchange DTOs instead of entities.
- Authorization with method security (`@PreAuthorize` or the project's equivalent).
- Outside tests, do not change the schema with Hibernate `ddl-auto`.

## Creating migrations (when the server tool is the owner)

| Tool | How |
| --- | --- |
| Flyway | Next version `V<n>__<name>.sql` in `db/migration/` |
| Liquibase | New changeset in the changelog |
