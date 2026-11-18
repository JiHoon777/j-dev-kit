# Go: 시작 점검

`server-start-check`가 읽는다.

## 지킬 것

- 요청 본문은 핸들러 경계에서 검증한다(프로젝트의 validator, 없으면 명시적 검사).
- `context.Context`를 요청에서 DB 호출까지 넘기고, 오류는 감싸서(`fmt.Errorf("…: %w", err)`) 돌려준다.
- SQL 은 파라미터로만 만든다.

## 마이그레이션 만들기 (서버 도구가 담당일 때)

| 도구 | 명령 |
| --- | --- |
| Atlas | `atlas migrate diff <이름>` |
| golang-migrate | `migrate create -ext sql -dir <디렉터리> -seq <이름>` (up/down 쌍) |
