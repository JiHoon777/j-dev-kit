# Java / Kotlin: 마무리 점검

`server-end-check`가 읽는다.

## 빠진 마이그레이션

| 도구 | 명령 |
| --- | --- |
| Flyway | diff 의 스키마 변경에 `db/migration/` 새 파일이 있는지 확인한 뒤 `flyway validate` |
| Liquibase | diff 에 새 changeset 이 있는지 확인한 뒤 `liquibase validate` |

## 설정 키 패턴

`@Value("${`, `System.getenv(`, `application*.yml`·`application*.properties`에서 `${ENV_VAR}`를 읽는 새 키.
