---
name: task-start
description: 백로그 항목 하나의 작업을 시작한다. 항목을 읽고, 켜진 스택 플러그인의 시작 점검을 돌리고, 플랜 모드에서 탐색·질문·설계를 거쳐 계획을 승인받은 뒤, 작업 브랜치에서 구현한다. 사용자가 /task-start 로 부를 때만 쓴다.
argument-hint: '[백로그 번호 또는 이름 일부] (비우면 목록에서 고르기)'
disable-model-invocation: true
allowed-tools: Bash(git status *), Bash(git branch --show-current), Bash(git branch --list *), Bash(git log *), Bash(ls *)
version: "0.2.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# task-start: 작업 시작

백로그 항목 **하나**를 계획하고 승인받아 구현한다. 리뷰와 머지는 `/task-end`가 한다.

이 명령은 검증된 흐름을 이어 붙인 것이다. 단계마다 출처를 적었다. 출처의 방식을 바꾸지 않는다.

| 단계 | 출처 |
| --- | --- |
| 항목 다루기 | Backlog.md 에이전트 지침 (작업 실행) |
| 1-2 | 켜진 스택 플러그인의 `*-start-check` 스킬 (그대로 호출) |
| 2~5 | Anthropic `feature-dev` 플러그인의 Phase 2~5 |
| 계획과 승인 | Claude Code 플랜 모드 |
| 6 | `superpowers:test-driven-development`, `superpowers:verification-before-completion` (그대로 호출), 스택 점검이 돌려준 "구현 중 지킬 것"·"끝내기 전 할 것" |

요청한 항목: `$ARGUMENTS`

## 프로젝트 설정

프로젝트 CLAUDE.md 에서 아래를 읽는다. 없는 것은 괄호 안 기본값을 쓰고, 검증 명령이 없으면 묻는다.

- 기준 브랜치 (`main`)
- 검증 명령 (예: `pnpm verify`. 린트·타입·테스트·빌드를 한 번에 돌리는 것)
- 린트 명령 (예: `pnpm lint`)
- 지켜야 할 문서 (CLAUDE.md 가 가리키는 코드 규칙·구조 문서)

CLAUDE.md 의 규칙은 이 스킬과 superpowers 보다 우선한다.

## 지금 상태

- 브랜치: !`git branch --show-current 2>/dev/null || echo "(알 수 없음)"`
- 작업 브랜치: !`git branch --list 'w/*' 2>/dev/null || echo "(없음)"`
- 커밋하지 않은 변경: !`git status --short 2>/dev/null | head -20`
- 최근 커밋: !`git log --oneline -3 2>/dev/null || echo "(커밋 없음)"`
- 백로그: !`ls docs/backlog 2>/dev/null || echo "(없음)"`

## 1. 시작해도 되는지 확인하고 항목을 읽는다

아래 중 하나라도 걸리면 **멈추고 사용자에게 알린다.** 스스로 정리하거나 넘어가지 않는다.

| 확인 | 걸리면 |
| --- | --- |
| 기준 브랜치에 커밋이 하나도 없다 | 첫 커밋이 먼저 필요하다고 알린다. 직접 만들지 않는다 |
| 커밋하지 않은 변경이 있다 (추적 안 된 파일 포함) | 무엇이 남아 있는지 보여 주고 어떻게 할지 묻는다 |
| `w/`로 시작하는 브랜치가 이미 있다 | 한 번에 하나만 한다. 그 브랜치를 이어서 할지, `/task-end`로 끝낼지, 버릴지 묻는다 |
| 지금 브랜치가 기준 브랜치가 아니다 | 위와 같다 |

이어서 하기로 하면 그 브랜치로 가서 항목의 `Implementation Plan`을 읽고 6번부터 한다.

항목 찾기: `$ARGUMENTS`로 `docs/backlog/`에서 찾는다. 비어 있거나 여러 개가 맞거나 하나도 안 맞으면 `status: To Do`인 항목을 번호와 제목으로 보여 주고 고르게 한다. `docs/done/`에 있으면 이미 끝난 항목이라고 알린다.

Backlog.md: "Before mutating a task, read its current record and confirm its status, scope, acceptance criteria, and dependencies make it eligible to start." 항목 파일을 끝까지 읽고, `dependencies`에 적힌 항목이 `docs/done/`에 있는지 확인한다. 없으면 멈추고 알린다.

### 1-2. 스택 시작 점검

1. 쓸 수 있는 스킬 목록에서 **이름이 `-start-check`로 끝나는 스킬을 전부** 찾는다(플러그인 접두어가 붙는다. 예: `supabase:supabase-start-check`). 켜진 스택 플러그인의 것만 목록에 있다.
2. 하나씩 Skill 도구로 부른다. 각 스킬은 이 프로젝트에 해당하지 않으면 "해당 없음"만 돌려준다. 하나도 없으면 "켜진 스택 플러그인 없음"으로 적고 넘어간다.
3. 어느 하나라도 **중단**을 돌려주면 멈추고 그 이유를 사용자에게 알린다.
4. 돌려받은 것을 모아 둔다: **기준선**(작업 전 검사 결과), **플랜에 넣을 것**, **구현 중 지킬 것**, **끝내기 전 할 것**. 5번 계획과 6번 구현에 그대로 쓴다.

**여기서 `EnterPlanMode` 도구로 플랜 모드에 들어간다.** 2~5번은 플랜 모드 안에서 한다. 도구가 없으면 파일을 하나도 고치지 않은 채 진행한다.

## 2. 코드 탐색 (feature-dev Phase 2)

1. 탐색 에이전트(`Explore`) 2~3개를 **한 메시지에서 동시에** 띄운다. 각 에이전트는:
   - 코드를 끝까지 따라가며 구조, 추상화, 제어 흐름을 이해한다.
   - 서로 다른 면을 본다. 지시문의 예 (feature-dev 원문):
     - "Find features similar to [feature] and trace through their implementation comprehensively"
     - "Map the architecture and abstractions for [feature area], tracing through the code comprehensively"
     - "Analyze the current implementation of [existing feature/area], tracing through the code comprehensively"
     - "Identify UI patterns, testing approaches, or extension points relevant to [feature]"
   - 꼭 읽어야 할 파일 5~10개의 목록을 돌려준다.
2. 에이전트가 돌아오면 **그들이 꼽은 파일을 직접 다 읽는다.** CLAUDE.md 가 가리키는 문서 중 이 항목에 관련된 것도 읽는다.
3. 찾은 것과 패턴을 사용자에게 요약한다. 스택 점검의 "플랜에 넣을 것"도 같이 보여 준다.

## 3. 확인 질문 (feature-dev Phase 3)

"This is one of the most important phases. DO NOT SKIP."

1. 탐색 결과와 항목을 다시 본다.
2. 덜 정해진 것을 찾는다: 경계 상황, 오류 처리, 다른 부분과 만나는 곳, 범위의 끝, 디자인 선호, 성능. 스택 점검이 "물을 것"으로 돌려준 것도 넣는다.
3. **질문을 정리된 목록으로 한꺼번에 보여 준다.**
4. **답을 받기 전에는 설계로 넘어가지 않는다.**

"알아서 해"라고 하면 추천을 말하고 분명한 확인을 받는다. 항목의 Acceptance Criteria가 확인할 수 없는 문장이면 여기서 같이 정한다. 문서와 코드에서 답을 찾을 수 있는 것은 묻지 않는다. 물을 것이 정말 없으면 없다고 말하고 넘어간다.

## 4. 설계 (feature-dev Phase 4)

1. 설계 에이전트(`Plan`) 2~3개를 **동시에** 띄운다. 초점을 다르게 준다:
   - **최소 변경:** 가장 작은 변경, 있는 것을 최대한 다시 쓴다
   - **깔끔한 구조:** 유지보수하기 좋고 추상화가 단정하다
   - **실용적 균형:** 속도와 품질 사이
2. 세 안을 검토하고 이 항목에 무엇이 맞는지 의견을 정한다. (작은 수정인지 큰 기능인지, 복잡도를 본다.)
3. 사용자에게 보여 줄 것: 각 안의 짧은 요약, 장단점 비교, **이유가 붙은 추천**, 안마다 실제로 달라지는 구현.

## 5. 계획을 보여 주고 승인받는다 (feature-dev Phase 5의 문턱)

`ExitPlanMode`로 계획을 보여 준다. 계획에는 이 순서로 담는다.

1. **무엇을 하는가:** 항목을 한두 문장으로. 이번에 빼는 것도 그대로.
2. **세 가지 안과 추천:** 4번의 내용. 사용자가 다른 안을 고를 수 있게 한다.
3. **추천 안의 계획:** 만들거나 바꿀 파일과 각 파일이 맡는 일, 먼저 쓸 테스트, 작은 단계의 순서. 스택 점검의 "플랜에 넣을 것"이 빠짐없이 들어가야 한다.
4. **확인 방법:** Acceptance Criteria와 Definition of Done을 하나씩 어떻게 확인할지. 스택 점검의 "끝내기 전 할 것"을 포함한다.
5. **3번에서 정한 것.**

"DO NOT START WITHOUT USER APPROVAL" — 승인 전에는 파일을 고치지 않고 브랜치도 만들지 않는다. 다른 안을 고르거나 고쳐 달라고 하면 계획을 고쳐 다시 보여 준다.

## 6. 구현 (승인 뒤)

**먼저 기록한다 (Backlog.md 작업 실행 지침):**

1. 브랜치를 만든다. 이름은 `w/` 뒤에 항목 파일 이름에서 `.md`를 뺀 것. 예: `git switch -c w/001-common-login`
2. 항목 파일: `status: In Progress`, `updated_date`를 오늘로, `Implementation Plan`에 승인받은 계획을 적는다. 스택 점검의 기준선은 `Implementation Notes`에 `### 기준선`으로 적는다. 3번에서 Acceptance Criteria를 고치기로 했으면 이때 고친다. ("write it down in the task so that you can refer to it later.")
3. 린트를 통과시키고 커밋한다: `chore(backlog): <번호> 작업 시작`

**만든다:**

- `superpowers:test-driven-development` 스킬을 부르고 그대로 따른다.
- feature-dev Phase 5: 앞 단계에서 꼽은 파일을 다시 읽고, 고른 설계대로, 이 코드베이스의 방식을 엄격히 따른다.
- 스택 점검이 돌려준 **구현 중 지킬 것**을 그대로 따른다(예: 화면을 새로 만들 때 부를 스킬, 파일마다 돌릴 자동 교정).
- Backlog.md: "Only implement what's in the Acceptance Criteria." 항목에 없는 것은 고치지 않는다. 필요해 보이면 사용자에게 알리고, 하기로 하면 `/backlog-create`로 따로 만든다.
- Backlog.md: "Follow the acceptance criteria one by one and MARK THEM AS COMPLETE as soon as you finish them." 하나 끝낼 때마다 확인하고 체크한다.
- 알게 된 것과 계획에서 달라진 것은 `Implementation Notes`에 적는다. 범위가 커지면 멈추고 묻는다.
- 의미 있는 단계마다 작업 브랜치에 커밋한다. **기준 브랜치에 커밋하지 않고, 푸시하지 않는다.**

**끝낸다:**

1. `superpowers:verification-before-completion` 스킬을 부르고 그대로 따른다. 이 프로젝트의 검증 명령을 쓴다.
2. 스택 점검이 돌려준 **끝내기 전 할 것**을 한다(예: 브라우저 테스트). 도구를 쓸 수 없으면 건너뛰지 말고 멈춰서 사용자에게 알린다. 한 것과 본 것을 `Implementation Notes`에 적는다.
3. Acceptance Criteria와 Definition of Done에서 **실제로 확인한 것만** 체크한다.
4. 항목 파일을 고쳤으면 린트를 돌리고 커밋한다. **커밋하지 않은 변경을 남기지 않는다.** 남으면 `/task-end`가 시작하지 못한다.
5. 사용자에게 보고한다: 한 일, 기준별 결과, 계획과 달라진 것, 확인하지 못한 것. 다음은 `/task-end`라고 알린다.
