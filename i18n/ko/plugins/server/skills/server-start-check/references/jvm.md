> 번역본입니다. 원문은 [plugins/server/skills/server-start-check/references/jvm.md](../../../../../../../plugins/server/skills/server-start-check/references/jvm.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# Java / Kotlin (Spring Boot): 시작 점검

`server-start-check`가 읽는다. 아래 행과 기준선 줄을 그 스킬의 보고에 더한다.

## 1. 설치와 런타임

- wrapper 로 의존성을 받는다: `./gradlew dependencies` 또는 `./mvnw -q dependency:resolve`. 실패 → **중단**.
- 빌드 파일의 toolchain 을 `java -version`과 비교한다. 맞지 않음 → 실패.

## 2. LSP

`jdtls-lsp`(Java)나 `kotlin-lsp`(Kotlin) 플러그인이 켜져 있고 그 실행 파일이 PATH 에 있는지 확인한다. 아니면 실패가 아니라 질문으로 돌려준다.

## 3. 마이그레이션 상태

| 판별 근거 | 도구 | 적용 상태 |
| --- | --- | --- |
| `flyway.conf` 또는 `db/migration/` | Flyway | `flyway info` (pending 을 본다) |
| `liquibase.properties` 또는 changelog | Liquibase | `liquibase status --verbose` |

pending 마이그레이션 → 실패(적용할지 질문으로 돌려준다). 이력이 갈라졌거나 실패한 마이그레이션이 있음 → **중단**.

## 4. 기준선

프로젝트 CLAUDE.md 의 검증 명령을 쓴다. 검증 명령이 여러 점검을 이어 붙인 것이면(예: `pnpm lint && pnpm check && pnpm test && pnpm build`) 하나가 실패해도 나머지가 가려지지 않도록 각 부분을 따로 돌린다. CLAUDE.md 에 검증 명령이 없으면 `./gradlew check` 또는 `./mvnw -q verify`. 명령, exit code, 실패 개수, 실패한 이름(많으면 처음 10개)을 기록한다.

## 5. 구현 중 지킬 것 (돌려줄 것)

- 요청 본문은 Bean Validation(`@Valid`와 제약)으로 검증하고, 엔티티를 그대로 내보내지 말고 DTO 를 쓴다.
- 인가에는 메서드 보안(`@PreAuthorize` 또는 프로젝트의 같은 방식)을 쓴다.

## 더할 행

```markdown
| Dependencies | … | ./gradlew dependencies |
| Java version | … | … |
| LSP | … | jdtls-lsp enabled |
| Migration status | … | `flyway info`: 0 pending |
```
