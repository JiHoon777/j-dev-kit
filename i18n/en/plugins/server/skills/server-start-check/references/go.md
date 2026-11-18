> Translation. Source: [plugins/server/skills/server-start-check/references/go.md](../../../../../../../plugins/server/skills/server-start-check/references/go.md). Update this file when the source changes. Claude does not read this file.

# Go: start check

Read by `server-start-check`.

## Follow

- Validate request bodies at the handler boundary (the project's validator, or explicit checks if none).
- Pass `context.Context` from the request down to DB calls, and return errors wrapped (`fmt.Errorf("…: %w", err)`).
- Build SQL only with parameters.

## Creating migrations (when the server tool is the owner)

| Tool | Command |
| --- | --- |
| Atlas | `atlas migrate diff <name>` |
| golang-migrate | `migrate create -ext sql -dir <directory> -seq <name>` (up/down pair) |
