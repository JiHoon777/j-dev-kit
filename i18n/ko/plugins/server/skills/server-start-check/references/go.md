> 번역본입니다. 원문은 [plugins/server/skills/server-start-check/references/go.md](../../../../../../../plugins/server/skills/server-start-check/references/go.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# Go: 시작 점검

`server-start-check`가 읽는다. 아래 행과 기준선 줄을 그 스킬의 보고에 더한다.

## 1. 설치와 런타임

- `go mod download`. 실패 → **중단**.
- `go.mod`의 `go` 줄을 `go version`과 비교한다. 툴체인이 더 옛 버전 → 실패.

## 2. LSP

`gopls-lsp` 플러그인이 켜져 있고 `gopls`가 PATH 에 있는지 확인한다. 아니면 실패가 아니라 질문으로 돌려준다(설치는 사용자가 한다: `go install golang.org/x/tools/gopls@latest`).

## 3. 마이그레이션 상태

| 판별 근거 | 도구 | 적용 상태 | 모델 대 마이그레이션 |
| --- | --- | --- | --- |
| `atlas.hcl` | Atlas | `atlas migrate status --url <url> --dir <디렉터리>` | `atlas migrate validate` |
| `migrate` (golang-migrate)와 마이그레이션 폴더 | golang-migrate | `migrate -path <디렉터리> -database <url> version` | — |

적용 안 된 마이그레이션 → 실패. 갈라졌거나 dirty 상태 → **중단**.

## 4. 기준선

프로젝트 CLAUDE.md 의 검증 명령을 쓴다. 없으면 `go vet ./...`와 `go test ./...`, 그리고 설치돼 있으면 `govulncheck ./...`. 명령, exit code, 실패 개수, 실패한 이름(많으면 처음 10개)을 기록한다.

## 더할 행

```markdown
| go mod download | … | … |
| Go version | … | go.mod 1.23, toolchain 1.23.x |
| LSP | … | gopls-lsp enabled |
| Migration status | … | … |
```
