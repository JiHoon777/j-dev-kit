# Go: start checks

Read by `server-start-check`. Add these rows and baseline lines to that skill's report.

## 1. Install and runtime

- `go mod download`. Failure → **stop**.
- Compare the `go` line in `go.mod` with `go version`. Older toolchain → fail.

## 2. LSP

Check that the `gopls-lsp` plugin is enabled and `gopls` is on PATH. If not, it is not a failure; return it as a question (the user installs it: `go install golang.org/x/tools/gopls@latest`).

## 3. Migration status

| Detected | Tool | Applied status | Model vs migrations |
| --- | --- | --- | --- |
| `atlas.hcl` | Atlas | `atlas migrate status --url <url> --dir <dir>` | `atlas migrate validate` |
| `migrate` (golang-migrate) and a migrations folder | golang-migrate | `migrate -path <dir> -database <url> version` | — |

Unapplied migrations → fail. Diverged or dirty state → **stop**.

## 4. Baseline

Use the verification command from the project's CLAUDE.md. Otherwise `go vet ./...` and `go test ./...`, plus `govulncheck ./...` if it is installed. Record command, exit code, failure count, and failing names (first 10 if many).

## Rows to add

```markdown
| go mod download | … | … |
| Go version | … | go.mod 1.23, toolchain 1.23.x |
| LSP | … | gopls-lsp enabled |
| Migration status | … | … |
```
