# 규칙을 검사로 바꾸기

중요한 아키텍처 규칙(의존 방향, 모듈 경계, 금지된 import, 순환 금지)은 자동 검사로 지킨다. 출처: *Building Evolutionary Architectures* 의 피트니스 함수.

이 스킬은 **제안만 한다.** 설치하거나 설정 파일을 만들지 않는다. 제안은 개요 문서의 "의존 규칙"과 ADR 의 "확인 방법"에 적는다.

## 1. 고르는 순서

1. 프로젝트가 이미 쓰는 도구에 규칙을 더할 수 있으면 그것(예: 이미 ESLint 가 있으면 ESLint 플러그인)
2. 그 생태계에서 많이 쓰는 전용 도구(아래 표)
3. 없으면 언어 기본 기능: 모듈 공개 범위(Rust `pub(crate)`, Go `internal/`, Java 모듈, 패키지 `exports` 필드)
4. 그것도 없으면 짧은 스크립트(import 문 grep)로 시작하고 개요 문서에 "임시"로 적는다

## 2. 생태계별 도구

버전은 적지 않는다. 제안할 때 레지스트리에서 최신 버전과 유지보수 상태를 확인한다.

| 생태계 | 도구 | 하는 일 |
| --- | --- | --- |
| JS/TS | [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) | 해석된 모듈 그래프에 금지·허용 규칙, 순환 검출 |
| JS/TS | [eslint-plugin-boundaries](https://github.com/javierbrea/eslint-plugin-boundaries) | 요소 종류별 import 허용 규칙 |
| JS/TS | [Sheriff](https://github.com/softarc-consulting/sheriff) | 모듈 경계와 태그 기반 의존 규칙 |
| Nx 모노레포 | [`@nx/enforce-module-boundaries`](https://nx.dev/docs/features/enforce-module-boundaries) | 프로젝트 태그 기반 의존 제약 |
| Java/JVM | [ArchUnit](https://github.com/TNG/ArchUnit) | 층·슬라이스 규칙을 단위 테스트로 |
| Spring | [Spring Modulith](https://spring.io/projects/spring-modulith) | 애플리케이션 모듈 경계 검증 |
| Python | [import-linter](https://github.com/seddonym/import-linter) | 층, 독립, 금지 계약 |
| Go | [go-arch-lint](https://github.com/fe3dback/go-arch-lint), golangci-lint 의 depguard | 컴포넌트 의존 규칙, 금지 import |
| Rust | 워크스페이스 크레이트 분리 + `pub(crate)`, [cargo-deny](https://github.com/EmbarkStudios/cargo-deny) `[bans]` | 크레이트 사이 금지 의존 |
| PHP | [Deptrac](https://github.com/deptrac/deptrac) | 층 규칙 |
| .NET | [NetArchTest](https://github.com/BenMorris/NetArchTest), ArchUnitNET | 층 규칙을 테스트로 |

## 3. 좋은 검사의 조건

- 검증 명령(CI)에 들어 있어 매번 돈다.
- 실패 메시지가 규칙의 이유와 고치는 법을 말한다. 대부분 도구는 규칙에 설명(`comment`, `message`)을 달 수 있다.
- 기존 위반이 많으면 기준선(baseline)을 두고 **새 위반만** 막는다. 기준선은 줄여 가는 부채로 개요 문서에 적는다.
- 일부러 위반하는 줄을 넣었을 때 실제로 실패하는지 한 번 확인한다(설치하는 사람이 할 일로 적는다).

## 4. 제안 형식

```markdown
- 규칙: `domain/`은 `infra/`와 `ui/`를 import 하지 않는다
  - 이유: ADR-0003
  - 도구: dependency-cruiser (이미 devDependency) — `forbidden` 규칙 하나
  - 실패 메시지에 넣을 말: "domain 은 infra 를 모른다. 포트 인터페이스를 domain/ports 에 두고 infra 가 구현한다."
```
