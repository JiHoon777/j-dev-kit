> 번역본입니다. 원문은 [plugins/workflow/skills/task/references/start.md](../../../../../../../plugins/workflow/skills/task/references/start.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# task start: 백로그 항목 하나 계획하고 구현하기

백로그 항목 **하나**를 계획하고, 승인을 받고, 구현한다. 리뷰와 머지는 `/task end`가 한다.

이 모드는 검증된 흐름을 이어 붙인 것이다. 단계마다 출처를 적었다. 출처의 방식을 바꾸지 않는다.

| 단계 | 출처 |
| --- | --- |
| 항목 다루기 | Backlog.md 에이전트 지침 (task execution) |
| 1-2 | 켜 둔 스택 플러그인의 `*-start-check` 스킬 (그대로 호출) |
| 2–5 | Anthropic `feature-dev` 플러그인 Phase 2–5 |
| 계획과 승인 | Claude Code 플랜 모드 |
| 6 | `superpowers:test-driven-development`, `superpowers:verification-before-completion` (그대로 호출), 그리고 스택 점검이 돌려준 "구현 중 지킬 것"과 "끝내기 전 할 것" |

요청한 항목: `start` 뒤의 인자.

## 1. 작업을 시작할 수 있는지 확인하고 항목 읽기

아래 중 하나라도 해당하면 **멈추고 사용자에게 알린다.** 스스로 정리하거나 넘어가지 않는다.

| 확인 | 해당하면 |
| --- | --- |
| 기준 브랜치에 커밋이 없다 | 첫 커밋이 필요하다고 말한다. 직접 만들지 않는다 |
| 커밋하지 않은 변경이 있다(추적하지 않는 파일 포함) | 남은 것을 보여 주고 어떻게 할지 묻는다 |
| `w/`로 시작하는 브랜치가 이미 있다 | 한 번에 한 항목. 그 브랜치를 이어 갈지, `/task end`로 끝낼지, 버릴지 묻는다 |
| 현재 브랜치가 기준 브랜치가 아니다 | 위와 같다 |

사용자가 이어 가기를 고르면 그 브랜치로 바꾸고, 항목의 `Implementation Plan`을 읽고, 6단계부터 다시 한다.

항목 찾기: 인자를 `docs/backlog/`에서 찾는다. 비었거나, 여러 개가 맞거나, 하나도 안 맞으면 `status: To Do` 항목을 번호와 제목으로 나열하고 사용자가 고르게 한다. `docs/done/`에 있으면 이미 끝났다고 말한다.

Backlog.md: "Before mutating a task, read its current record and confirm its status, scope, acceptance criteria, and dependencies make it eligible to start." 항목 파일을 끝까지 읽고, `dependencies`의 모든 항목이 `docs/done/`에 있는지 확인한다. 아니면 멈추고 사용자에게 알린다.

### 1-2. 스택 시작 점검

1. 쓸 수 있는 스킬 목록에서 **이름이 `-start-check`로 끝나는 스킬을 전부** 찾는다(플러그인 접두어가 붙는다. 예: `supabase:supabase-start-check`). 켜 둔 스택 플러그인만 목록에 나온다.
2. 각각을 Skill 도구로 호출한다. 이 프로젝트에 해당하지 않는 점검은 "해당 없음"만 돌려준다. 하나도 없으면 "켠 스택 플러그인 없음"이라고 적고 넘어간다.
3. 하나라도 **중단**을 돌려주면 멈추고 사용자에게 이유를 알린다.
4. 돌려받은 것을 보관한다: **기준선**(작업 전 검사 결과), **탐색에 넣을 지시문**, **플랜에 넣을 것**, **물을 것**, **구현 중 지킬 것**, **끝내기 전 할 것**. 탐색에 넣을 지시문은 2단계로, 나머지는 그대로 3–6단계로 넘긴다.
5. 점검 스킬은 명령만 돌린다. 코드를 찾아 읽는 정보 취합은 점검 스킬이 하지 않는다. 점검 스킬은 탐색에 넣을 지시문을 돌려주고, 2단계가 그것을 에이전트로 돌린다. 이 대화에서 직접 코드를 찾아다니지 않는다.

**이제 `EnterPlanMode` 도구로 플랜 모드에 들어간다.** 2–5단계는 플랜 모드에서 한다. 도구를 쓸 수 없으면 파일을 하나도 고치지 않고 진행한다.

## 2. 코드 탐색 (feature-dev Phase 2)

1. 탐색 에이전트(`Explore`) 2–3개와, 1-2에서 돌려받은 **탐색에 넣을 지시문마다 `Explore` 에이전트 하나씩**을 **한 메시지에서 한꺼번에** 띄운다. 스택 지시문은 받은 그대로 주고, `<…>`는 항목에서 채운다. 기본 탐색 에이전트는:
   - 코드를 끝까지 따라가 구조, 추상화, 제어 흐름을 이해한다.
   - 저마다 다른 면을 본다. 지시문 예(feature-dev 원문):
     - "Find features similar to [feature] and trace through their implementation comprehensively"
     - "Map the architecture and abstractions for [feature area], tracing through the code comprehensively"
     - "Analyze the current implementation of [existing feature/area], tracing through the code comprehensively"
     - "Identify UI patterns, testing approaches, or extension points relevant to [feature]"
   - 꼭 읽어야 할 파일 5–10개 목록을 돌려준다.
2. 에이전트들이 돌아오면 **목록에 있는 파일을 모두 직접 읽는다.** CLAUDE.md 가 가리키는 문서 중 이 항목과 관련된 것도 읽는다.
3. 찾은 것과 패턴을 스택 점검의 "플랜에 넣을 것"과 함께 사용자에게 요약한다.

## 3. 확인 질문 (feature-dev Phase 3)

"This is one of the most important phases. DO NOT SKIP."

1. 탐색 결과와 항목을 다시 본다.
2. 덜 정해진 것을 찾는다: 경계 상황, 오류 처리, 연동 지점, 범위 경계, 설계 취향, 성능. 스택 점검의 "물을 것"을 더한다.
3. **질문을 모두 모아 정리된 목록으로 한꺼번에 내놓는다.**
4. **답을 받기 전에는 설계로 넘어가지 않는다.**

사용자가 "알아서 해"라고 하면 추천안을 내고 명시적으로 확인을 받는다. 항목의 Acceptance Criteria 를 확인할 수 없으면 여기서 함께 정한다. 문서와 코드가 이미 답하는 것은 묻지 않는다. 정말 물을 게 없으면 그렇다고 말하고 넘어간다.

## 4. 설계 (feature-dev Phase 4)

1. 설계 에이전트(`Plan`) 2–3개를 **한꺼번에** 띄운다. 각자 초점이 다르다:
   - **최소 변경:** 가장 작은 변경, 최대한 재사용
   - **깔끔한 구조:** 유지보수하기 좋고 추상화가 정돈된 것
   - **실용적 균형:** 속도와 품질 사이
2. 세 안을 검토하고, 이 항목에 무엇이 맞는지 스스로 판단한다(작은 수정인지 큰 기능인지, 복잡도를 본다).
3. 사용자에게 보여 준다: 각 안의 짧은 요약, 장단점 비교, **이유를 단 추천안**, 안마다 구현이 실제로 어떻게 다른지.

## 5. 계획을 보여 주고 승인 받기 (feature-dev Phase 5 관문)

`ExitPlanMode`로 계획을 이 순서로 보여 준다:

1. **무엇을 하나:** 항목을 한두 문장으로. 이번에 빼는 것도 포함한다.
2. **세 안과 추천안:** 4단계에서 나온 것. 사용자가 다른 안을 고를 수 있게 한다.
3. **추천안의 계획:** 만들거나 바꿀 파일과 각각이 맡는 일, 먼저 쓸 테스트, 작은 단계의 순서. 스택 점검의 "플랜에 넣을 것"은 빠짐없이 들어가야 한다.
4. **어떻게 검증하나:** Acceptance Criteria 와 Definition of Done 의 각 줄을 어떻게 확인할지. 스택 점검의 "끝내기 전 할 것"을 포함한다.
5. **3단계에서 정한 것.**

"DO NOT START WITHOUT USER APPROVAL" — 승인 전에는 파일을 고치지 않고 브랜치도 만들지 않는다. 사용자가 다른 안을 고르거나 수정을 요청하면 계획을 고쳐 다시 보여 준다.

## 6. 구현 (승인 후)

**먼저 기록한다 (Backlog.md task execution 지침):**

1. 브랜치를 만든다: `w/` 뒤에 `.md`를 뺀 항목 파일 이름. 예: `git switch -c w/001-common-login`
2. 항목 파일에서: `status: In Progress`, `updated_date`를 오늘로, 승인된 계획을 `Implementation Plan`에. 스택 점검의 기준선은 `Implementation Notes`의 `### Baseline` 아래에 넣는다. 3단계에서 Acceptance Criteria 가 바뀌었으면 지금 고친다. ("write it down in the task so that you can refer to it later.")
3. 린트 명령을 통과시키고 커밋한다: `chore(backlog): <번호> start`

**만든다:**

- `superpowers:test-driven-development` 스킬을 호출해 그대로 따른다.
- feature-dev Phase 5: 앞서 찾은 파일을 다시 읽고, 고른 설계를 따르고, 이 코드베이스의 관례를 철저히 따른다.
- 스택 점검의 **구현 중 지킬 것**을 그대로 따른다(예: 새 화면을 만들 때 호출할 스킬, 파일마다 돌릴 자동 교정 도구).
- Backlog.md: "Only implement what's in the Acceptance Criteria." 항목이 다루지 않는 것은 바꾸지 않는다. 필요해 보이는 게 있으면 사용자에게 알리고, 동의하면 `/task create`로 따로 만든다.
- Backlog.md: "Follow the acceptance criteria one by one and MARK THEM AS COMPLETE as soon as you finish them." 하나 끝낼 때마다 바로 확인하고 체크한다.
- 배운 것과 계획에서 바뀐 것을 `Implementation Notes`에 적는다. 범위가 커지면 멈추고 묻는다.
- 의미 있는 단계마다 작업 브랜치에 커밋한다. **기준 브랜치에 커밋하지 않고, 푸시하지 않는다.**

**마무리:**

1. `superpowers:verification-before-completion` 스킬을 호출해 그대로 따른다. 이 프로젝트의 검증 명령을 쓴다.
2. 스택 점검의 **끝내기 전 할 것**을 한다(예: 브라우저 테스트). 도구를 쓸 수 없으면 건너뛰지 말고 멈춰서 사용자에게 알린다. 한 일과 본 것을 `Implementation Notes`에 적는다.
3. Acceptance Criteria 와 Definition of Done 에서 **실제로 검증한 것만** 체크한다.
4. 항목 파일을 고쳤으면 린트 명령을 돌리고 커밋한다. **커밋하지 않은 변경을 남기지 않는다.** 남기면 `/task end`가 시작하지 못한다.
5. 사용자에게 보고한다: 한 일, 기준별 결과, 계획에서 바뀐 것, 검증하지 못한 것. 다음은 `/task end`라고 말한다.
