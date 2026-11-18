# Java / Kotlin (Spring Boot): 시작 점검

`server-start-check`가 읽는다.

## 지킬 것

- 요청 본문은 Bean Validation(`@Valid`와 제약)으로 검증하고, 엔티티 대신 DTO 를 주고받는다.
- 인가는 메서드 보안(`@PreAuthorize` 또는 프로젝트의 같은 방식).
- 테스트 밖에서 Hibernate `ddl-auto`로 스키마를 바꾸지 않는다.

## 마이그레이션 만들기 (서버 도구가 담당일 때)

| 도구 | 방법 |
| --- | --- |
| Flyway | `db/migration/` 에 다음 버전 `V<n>__<이름>.sql` |
| Liquibase | changelog 에 새 changeset |
