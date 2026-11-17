# Go: end checks

Read by `server-end-check`. Add these rows to that skill's report.

## Extra checks

- If `govulncheck` was in the baseline, run `govulncheck ./...` again. New vulnerabilities → fail.

## Missing migration

| Tool | Command |
| --- | --- |
| Atlas | `atlas migrate validate`, `atlas migrate lint --dev-url <dev> --latest <number of new files>` |
| golang-migrate | No model diff tool. Check that the schema change in the diff has a new up/down file pair |

## Apply from scratch (only after approval)

- golang-migrate: `migrate -path <dir> -database <dev url> drop -f` then `up`
- Atlas: `atlas migrate apply` against a fresh development database

## Environment variables read in code

Patterns on added lines: `os.Getenv(`, `os.LookupEnv(`, the project's config library (for example `envconfig` struct tags).

## Rows to add

```markdown
| govulncheck | … | 0 new vulnerabilities |
| Missing migration | … | … |
```
