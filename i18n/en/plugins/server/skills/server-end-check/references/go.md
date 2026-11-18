> Translation. Source: [plugins/server/skills/server-end-check/references/go.md](../../../../../../../plugins/server/skills/server-end-check/references/go.md). Update this file when the source changes. Claude does not read this file.

# Go: end check

Read by `server-end-check`.

## Missing migrations

| Tool | Command |
| --- | --- |
| Atlas | `atlas migrate validate` |
| golang-migrate | There is no comparison tool. Check that schema changes in the diff come with a new up/down file pair |

## Config key patterns

`os.Getenv(`, `os.LookupEnv(`, the project's config library (e.g. `envconfig` tags).
