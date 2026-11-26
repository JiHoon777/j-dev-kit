---
id: '016'
title: 사람에게 묻는 곳을 꼭 필요한 것만 남긴다 — 계획 승인과 superpowers 를 떼고 start 와 end 를 합친다
status: To Do
labels: [feat]
priority: high
dependencies: []
created_date: 2026-11-26
updated_date: 2026-11-26
---

## Description

### 왜

`/task`가 너무 자주 멈추고 묻는다. 실제 대화 기록에서 세어 보면 항목 하나를 create → start → end 로 끝내는 동안 평균 7.8번 멈춘다(5~15번). 이 항목의 규칙을 적용하면 약 3.4번(2~5번)으로 준다.

가장 많이 줄어드는 곳은 셋이다.
- **계획 승인:** 다른 프로젝트에서 17번 물었고, 사용자가 그 자리에서 계획을 바꾼 적은 0번이다. 대부분 1~2분 안에 그대로 승인했다.
- **end 리뷰 지적 질문:** 사용자가 가장 많이 뒤집은 곳이다. "나중 항목으로 미루자"는 추천을 거절하고 지금 고치라고 한 것이 5번이다. 그러니 타당한 지적은 묻지 말고 고치면 된다.
- **superpowers 스킬의 숨은 질문:** `/task`가 부르는 superpowers 스킬이 각자 따로 묻는다. superpowers 는 떼고, 필요한 규칙만 `/task`에 직접 적는다.

### 묻는 기준

다음 다섯 가지만 묻는다.
1. 되돌릴 수 없거나 밖으로 나가는 일: 머지, 푸시, 삭제, 원격 DB, 배포
2. 프로젝트 밖이나 공유 설정을 바꾸는 일: 플러그인 설치, CLAUDE.md
3. 코드나 실행으로 정할 수 없는 제품·취향 결정
4. 무엇을 할지 고르기
5. 작업을 잃을 수 있는 상태

그 밖은 묻지 않는다. Claude 가 정하고 항목 파일에 적는다. 정한 것은 마지막 메시지에서 추천·근거·위험과 함께 한 번에 보인다.

### 사용자가 정한 것 (2026-11-26)

- **계획 승인(플랜 모드)을 받지 않는다.** 사용자의 말: "구현은 금방 하고, 초기에 중요한 설계 부분은 다 질문하게 해 놨거나 미리 말한다."
  - 012 에서 정한 "하위 세션도 공식 플랜 모드로 계획 승인"(`docs/done/012-chore-official-skills-narrow-stack.md:72-77`)을 뒤집는다.
  - j-dev-kit 004·008·010·012 에서는 계획 승인 때 AC 가 바뀐 적이 있다. 그 일은 이제 AC 승인과 착수 전 질문이 맡는다.
- **start 와 end 를 합친다.** `/task start` 하나가 구현, 검증, 리뷰, 지적 고치기, 머지 질문까지 한다. `end` 모드는 없다. 그래서 "end 를 진행할까요?"도, 사용자가 `/task end`를 치는 일도 없다.
- **AC 승인은 남긴다.** 계획 승인이 없어지면 구현 전에 사람이 확인하는 유일한 계약이다.
- **superpowers 를 쓰지 않는다.** 플러그인 의존성에서 빼고, `/task`가 부르던 다섯 스킬(brainstorming, test-driven-development, verification-before-completion, receiving-code-review, finishing-a-development-branch)에서 필요한 규칙만 `/task` 절차에 직접 적는다.
- **simplify 는 묻지 않고 늘 돈다.** 찾기만 하고 고치지 않는다. 찾은 것은 마지막 메시지에 함께 보이고, 고칠지는 그때 고른다. 11-25 에 정한 "항상 확인한다"(`fa91c89`)는 이렇게 지킨다.

### 근거

- `docs/backlog/references/2026-11-26-016-추가-조사.md`: 실제 멈춤 횟수, `/until-done`이 안 쓰인 이유, superpowers 의 숨은 질문, 플랜 모드 없이 편집 막기와 승인 중계. 노트와 다시 세는 스크립트는 `research_notes/2026-11-26-016-추가-조사/`
- `docs/backlog/references/2026-11-26-pstack-분석과-차용.md`: pstack 과의 비교. 7절이 에이전트 검증 뒤 고친 판단. 노트는 `research_notes/2026-11-26-pstack-분석과-차용/`
- `docs/backlog/references/2026-11-26-코딩-에이전트-실무자-워크플로.md`: 바깥 실무자·도구 팀 워크플로 약 40개 비교. 노트는 `research_notes/2026-11-26-코딩-에이전트-실무자-워크플로/`
- `docs/backlog/references/2026-11-26-질문-줄이기-비교.html`: 단계별 지금 / 바꾼 뒤 비교 페이지
- `docs/backlog/references/2026-11-26-016-인수인계.md`: 다른 컴퓨터에서 이어 하기 위한 문서

### 이번에 빼는 것

- 진입 모드 스킬(`/poteto-mode` 같은 것). 004 의 `/until-done`이 같은 일을 하다가 한 번도 쓰이지 않고 006 에서 지워졌다. 이 항목을 써 본 뒤 따로 정한다.
- pstack 의 다른 차용(프로젝트 검증 스킬, 전제 의심하기, blast-radius)
- 다른 플러그인의 리뷰어 에이전트 본문
- 사용자 컴퓨터에서 superpowers 플러그인을 지우는 일(사용자가 한다)

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 묻는 기준 다섯 가지가 `task` SKILL.md "일하는 원칙" 한 곳에 있고, 각 절차 파일의 질문 지점은 이 기준을 가리킨다. 기준 밖의 것은 정하고 항목 파일에 `정한 것 — 이유 — 틀렸을 때 비용`으로 적는다. "다음 단계로 갈까요?" 같은 질문은 하지 않는다
- [ ] #2 `start`에 플랜 모드와 계획 승인 대기가 없다(`grep -rn 'EnterPlanMode\|ExitPlanMode' plugins i18n` 결과 없음). 대신 이렇게 한다
  - 첫 메시지에서 목표와 가장 작은 변경을 되짚고 진행한다
  - 착수 전 질문은 있을 때만 한 번에 묻는다
  - 계획과 정한 것은 항목 파일에 적고 기다리지 않는다. 사용자가 "계획을 보자"고 하면 보여 주고 기다린다
- [ ] #3 `start`의 "범위가 커지면 멈춘다"가 확인할 수 있는 목록이다: AC 밖 동작, 새 의존성·도구 설치, 스키마·공개 API·삭제, CLAUDE.md·설정 변경
- [ ] #4 `create`는 AC 전문을 보여 주고 승인받는다. 서베이 모드는 후보 표에 AC 초안을 넣어, 고르기 한 번으로 항목을 쓰고 다시 승인받지 않는다
- [ ] #5 구현을 마치면 simplify 를 묻지 않고 찾기만 모드로 돌린다. 찾은 것은 항목 파일에 적고, 마지막 메시지에서 고칠지 고르게 한다
- [ ] #6 리뷰 판정에서 타당한 🔴·🟡 는 묻지 않고 고친 뒤 알린다. 남은 질문(AC·정한 것과 부딪히는 지적, "나중" 후보, simplify 가 찾은 것, 머지 방식)은 한 메시지로 추천·근거·위험과 함께 묻는다. "막기" 선택지는 없다
- [ ] #7 `docs/review-principles.md`의 "승인된 계획·AC 가 정한 것은 사용자가 정한 것" 원칙이 "AC 와 사용자가 답한 것"으로 좁혀져 있다. Claude 가 정한 것은 리뷰 대상이다. `plugins`·`i18n`·`docs/backlog/_template.md`에 "승인된 계획" 문구가 없다
- [ ] #8 하위 세션 지시문(`task` SKILL.md 2절)에 플랜 모드 승인 문장이 없고, 하위 세션도 #1 기준을 따른다. 부모 세션이 계획 승인을 기다리는 문장이 없다
- [ ] #9 superpowers 를 뗀다
  - `grep -rn superpowers plugins i18n .claude-plugin .claude/settings.json` 결과가 없다(`plugin.json`·`marketplace.json` 의존성 포함)
  - 부르던 다섯 스킬에서 필요한 규칙을 `/task` 절차에 직접 적었다: 테스트 먼저(예외는 시안·생성 코드·설정·문서), 끝났다고 말하기 전에 검증 명령을 다시 돌려 출력 보이기, 리뷰 지적은 코드에서 확인하고 틀린 지적은 이유를 대고 고치지 않기, 질문 규칙(이유 먼저, 절차 질문 안 함, 선택지에 추천, 한 번에 최대 3개)
  - README 두 개의 superpowers 안내와 저장소 CLAUDE.md 의 superpowers 절을 정리했다
- [ ] #10 frontend·server 점검과 ui-design 의 질문이 #1 기준을 따른다
  - 시안 수는 기본 3개이고 방향 표는 보여 주기만 한다. 캔버스에서 고르기는 남긴다
  - ui-design 의 쓰기·커밋 승인은 한 번으로 줄이고, `@DESIGN.md` 줄 추가는 묻는다
  - 로컬 Supabase 스택은 켜고 알린다
  - 공식 스킬 설치는 프로젝트당 한 번, 착수 전 질문에 합친다
  - 브라우저 도구가 없으면 멈추지 않고 "확인 못 함"으로 적고 계속한다
- [ ] #11 멈춘 횟수가 기준선보다 적다. 기준선은 기록에서 센 평균 7.8번이다(`research_notes/2026-11-26-016-추가-조사/stop-count.md`). 바꾼 판을 같은 실제 사례로 돌려 같은 방법으로 센다. 기존 eval 사례(`start-plan` 등)는 새 규칙에 맞게 고쳤다. 결과와 다시 돌리는 명령이 Implementation Notes 에 있다
- [ ] #12 `start`와 `end`가 한 모드다. `/task start` 하나가 구현 → 검증 → 리뷰 → 지적 고치기 → 마지막 메시지(머지 방식 등)까지 멈추지 않고 간다. `end` 모드와 `references/end.md`는 없고, 그 절차는 `start.md`에 들어 있다. `grep -rn 'task end' plugins i18n README.md README.en.md` 결과가 없다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 번역본(`i18n/en/`)을 원문과 같이 고쳤다
- [ ] #3 바꾼 플러그인의 `plugin.json` `version`을 올렸고 README 두 개와 `marketplace.json` 설명을 맞췄다

<!-- DOD:END -->

## Implementation Plan

만들 때는 비워 둔다. `/task start`가 계획을 적는다.

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것, 그대로 둔 지적과 이유, 사용자가 바로잡은 것.
