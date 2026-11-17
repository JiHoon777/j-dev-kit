> 번역본입니다. 원문은 [plugins/server/skills/server-end-check/references/jvm.md](../../../../../../../plugins/server/skills/server-end-check/references/jvm.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# Java / Kotlin: 종료 점검

`server-end-check`가 읽는다. 아래 행을 그 스킬의 보고에 더한다.

## 빠진 마이그레이션

| 도구 | 명령 |
| --- | --- |
| Flyway | diff 의 스키마 변경에 `db/migration/` 아래 새 파일이 있는지 확인한 뒤 `flyway validate` |
| Liquibase | diff 에 새 changeset 이 있는지 확인한 뒤 `liquibase validate` |

프로젝트가 테스트 밖에서 Hibernate `ddl-auto`를 `validate`나 `none`이 아닌 값으로 쓰면 보고한다: 마이그레이션 없이 스키마가 바뀌고 있을 수 있다.

## 처음부터 다시 적용 (승인 후에만)

- Flyway: `flyway clean`(개발 데이터베이스에서 `cleanDisabled`가 false 일 때만) 뒤 `flyway migrate`
- Liquibase: 개발 데이터베이스에 `liquibase drop-all` 뒤 `liquibase update`

## 코드에서 읽는 환경 변수

추가된 줄에서 찾을 패턴: `@Value("${`, `System.getenv(`, `application*.yml` / `application*.properties`에서 `${ENV_VAR}`를 읽는 새 키.

## 채울 줄

보고서 표에서 맞는 줄을 채운다(같은 줄을 하나 더 만들지 않는다):

```markdown
| Missing migration | … | `flyway validate` exit 0 |
```
