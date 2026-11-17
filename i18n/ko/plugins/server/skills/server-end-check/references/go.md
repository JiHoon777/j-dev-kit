> 번역본입니다. 원문은 [plugins/server/skills/server-end-check/references/go.md](../../../../../../../plugins/server/skills/server-end-check/references/go.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# Go: 종료 점검

`server-end-check`가 읽는다. 아래 행을 그 스킬의 보고에 더한다.

## 추가 검사

- 기준선에 `govulncheck`가 있었으면 `govulncheck ./...`를 다시 돌린다. 새 취약점 → 실패.

## 빠진 마이그레이션

| 도구 | 명령 |
| --- | --- |
| Atlas | `atlas migrate validate`, `atlas migrate lint --dev-url <개발 DB> --latest <새 파일 수>` |
| golang-migrate | 모델 diff 도구가 없다. diff 의 스키마 변경에 새 up/down 파일 쌍이 있는지 확인한다 |

## 처음부터 다시 적용 (승인 후에만)

- golang-migrate: `migrate -path <디렉터리> -database <개발 DB url> drop -f` 뒤 `up`
- Atlas: 새로 만든 개발 데이터베이스에 `atlas migrate apply`

## 코드에서 읽는 환경 변수

추가된 줄에서 찾을 패턴: `os.Getenv(`, `os.LookupEnv(`, 프로젝트의 설정 라이브러리(예: `envconfig` struct 태그).

## 더할 행

```markdown
| govulncheck | … | 0 new vulnerabilities |
| Missing migration | … | … |
```
