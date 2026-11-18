# 아키텍처 문서

design 과 review 가 쓰는 문서의 위치와 형식. 프로젝트 CLAUDE.md 에 위치가 적혀 있으면 그것을 따른다.

## 1. 위치

| 문서 | 이미 있으면 | 없으면 |
| --- | --- | --- |
| 개요 | `ARCHITECTURE.md`, `docs/architecture/README.md`, `docs/architecture.md` 중 있는 것 | `docs/architecture/README.md` |
| ADR | `docs/adr/`, `docs/decisions/`, `doc/architecture/decisions/`, `docs/architecture/decisions/` 중 있는 것 | `docs/architecture/decisions/` |
| 리서치 | `docs/architecture/research/` | `docs/architecture/research/` |

ADR 폴더가 둘 이상이면 어느 쪽을 쓸지 묻는다. 기존 ADR 의 파일 이름 규칙과 형식이 있으면 그것을 따르고, 아래 형식은 없을 때만 쓴다.

## 2. 개요 문서

100줄 안팎의 지도다. 코드를 읽으면 알 수 있는 것(모든 파일 목록, 함수 설명)은 쓰지 않는다. 처음 온 사람(사람이든 에이전트든)이 어디를 보고 어디에 넣을지 알 수 있으면 된다.

```markdown
# 아키텍처

갱신: YYYY-MM-DD

## 품질 목표
1. <목표> — <확인할 수 있는 시나리오: 누가, 무엇을 할 때, 어떤 결과가 얼마 안에>
2. …  (3~5개, 순위대로)

## 스택
| 영역 | 선택 | 이유 |
| --- | --- | --- |
| 언어·런타임 | … | [ADR-0001](decisions/0001-….md) |
| … | … | 한 줄 이유 (양방향 문) |

## 모듈 지도
| 경로 | 책임 | 공개 인터페이스 | 무엇 때문에 바뀌나 |
| --- | --- | --- | --- |
| `src/billing/` | 결제와 청구 | `src/billing/index.ts` | 결제 수단 추가, 요금제 변경 |

## 의존 규칙
- <규칙> — 강제: <검사 이름이나 "아직 없음">

## 새 X 추가하는 법
### 새 <자주 생기는 변경 1>
1. `<경로>`에 <파일>을 만든다 (예: `<기존 예시 파일>`)
2. …
3. 확인: <명령>

## 결정
- [ADR-0001 제목](decisions/0001-….md) — 상태

## 알려진 부채
- <문제> — 어디 — 왜 미뤘나 — 언제 다시 보나
```

- "새 X 추가하는 법"은 이 프로젝트에서 실제로 자주 생기는 변경 2~4개만 쓴다. 각 단계는 실제 경로와 실제 예시 파일을 가리킨다.
- 다른 문서에 있는 내용은 링크만 건다.

## 3. ADR

[MADR 4.0](https://adr.github.io/madr/)을 줄인 형식. 한 방향 문 결정 하나에 파일 하나.

파일 이름: `NNNN-제목-소문자-하이픈.md`. 번호는 기존 가장 큰 번호 + 1, 네 자리.

```markdown
---
status: proposed | accepted | rejected | deprecated | superseded by ADR-NNNN
date: YYYY-MM-DD
---

# <결정을 한 문장으로>

## 문제
<무엇을 정해야 하나, 왜 지금. 관련 품질 목표>

## 고려한 대안
- <대안 A>
- <대안 B>

## 결정
<고른 것>. 이유: <요인표의 핵심 근거, 출처는 리서치 파일 링크>

## 결과
- 쉬워지는 것: …
- 어려워지는 것: …
- 다시 볼 때: <이 결정을 다시 볼 조건. 예: 사용자가 10만 명을 넘으면, X 의 지원이 끝나면>

## 확인 방법
<이 결정을 지키는지 보는 검사. 없으면 "수동: <무엇을 본다>">
```

- 사용자가 승인한 결정은 `accepted`, 승인 전 제안은 `proposed`.
- `accepted`인 ADR 의 결정 내용은 고치지 않는다. 바꾸려면 새 ADR 을 쓰고, 옛 ADR 의 상태만 `superseded by ADR-NNNN`으로 바꾼다.
- 오탈자와 깨진 링크는 고쳐도 된다.

## 4. 리서치 파일

형식은 `references/research.md` 5절. 파일 맨 위에 확인 날짜를 둔다. ADR 과 개요 문서에서 링크한다.

## 5. CLAUDE.md

개요 문서를 처음 만들었으면, CLAUDE.md 에 한 줄을 넣을지 묻는다. 내용을 복사하지 않는다.

```markdown
- 아키텍처: docs/architecture/README.md (구조를 바꾸기 전에 읽고, 결정은 ADR 로)
```
