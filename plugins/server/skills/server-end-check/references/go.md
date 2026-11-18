# Go: 마무리 점검

`server-end-check`가 읽는다.

## 빠진 마이그레이션

| 도구 | 명령 |
| --- | --- |
| Atlas | `atlas migrate validate` |
| golang-migrate | 비교 도구가 없다. diff 의 스키마 변경에 새 up/down 파일 쌍이 있는지 확인한다 |

## 설정 키 패턴

`os.Getenv(`, `os.LookupEnv(`, 프로젝트의 설정 라이브러리(예: `envconfig` 태그).
