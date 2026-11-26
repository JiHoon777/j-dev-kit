---
id: '016'
title: 사람에게 묻는 곳을 꼭 필요한 것만 남기고 계획 승인을 없앤다
status: To Do
labels: [feat]
priority: high
dependencies: []
created_date: 2026-11-26
updated_date: 2026-11-26
---

## Description

사용자는 `/task`가 쓸데없이 확인하는 게 너무 많다고 느낀다. 지금은 화면이 바뀌는 항목 하나를 create → start → end 로 끝내는 동안 약 6~10번 멈춰서 답해야 한다(DESIGN.md 를 새로 만들면 최대 약 14번). pstack(Lauren Tan, `cursor/plugins`)의 poteto-mode 처럼 꼭 필요한 것만 묻고, 나머지는 정하고 적어 둔 뒤 정해진 때 한 번에 보이게 바꾼다. 목표는 약 2~4번이다. 두 수 모두 절차를 따라 센 추정이고, 실제 대화 기록에서 센 값은 아니다.

묻는 기준:
- 되돌릴 수 없거나 밖으로 나가는 일
- 프로젝트 밖·공유 설정을 바꾸는 일
- 코드·실행으로 정할 수 없는 제품·취향 결정
- 무엇을 할지 고르기
- 작업을 잃을 수 있는 상태

그 밖은 묻지 않는다. 정한 것은 항목 파일에 적고, start 끝 보고와 end 머지 전 질문에서 추천·근거·위험과 함께 보인다.

사용자가 정한 것 (2026-11-26):
- **계획 승인(플랜 모드)은 받지 않는다.** 사용자의 말: "구현은 금방 하고, 초기에 중요한 설계 부분은 다 질문하게 해 놨거나 미리 말한다."
  - 012 C절(`docs/done/012-chore-official-skills-narrow-stack.md:72-77`)에서 정한 "하위 세션도 공식 플랜 모드로 계획 승인"을 뒤집는 결정이다.
  - 계획 승인 때 범위가 바뀐 적이 있다(004·008·010·012). 이런 수정은 이제 start 착수 전 질문이나 end 로 옮겨 간다.
- 항목(AC) 승인은 남긴다. 계획 승인이 없어지면 구현 전에 사람이 확인하는 유일한 계약이다.

근거:
- `docs/backlog/references/2026-11-26-pstack-분석과-차용.md` (1~6절 분석, 7절 에이전트 검증과 고친 판단)
- `docs/backlog/references/research_notes/2026-11-26-pstack-분석과-차용/` (에이전트 다섯 개의 보고 원문)
- `docs/backlog/references/2026-11-26-질문-줄이기-비교.html` (단계별 지금 / 바꾼 뒤 비교 페이지)
- `docs/backlog/references/2026-11-26-016-인수인계.md` (남은 조사와 시작 방법)

남은 조사: 인수인계 문서의 "더 조사할 것"을 `start` 전에 보고, 바뀐 것은 계획의 가정에 적는다.

이번에 빼는 것:
- 진입 모드 스킬(`/poteto-mode` 같은 것). 004 의 `/until-done`이 같은 일을 하다가 006 에서 지워졌다. 이 항목을 써 본 뒤 `/task` 밖의 일에도 필요했는지 보고 따로 정한다.
- pstack 의 다른 차용(프로젝트 검증 스킬, 전제 의심하기, blast-radius)
- 다른 플러그인의 리뷰어 에이전트 본문

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 `task` SKILL.md "일하는 원칙"에 묻는 기준이 한 곳에 있다. 계속 묻는 것은 되돌릴 수 없거나 밖으로 나가는 일(머지·푸시·삭제·원격 DB·배포), 프로젝트 밖·공유 설정 변경(플러그인 설치, CLAUDE.md), 코드·실행으로 정할 수 없는 제품·취향 결정, 무엇을 할지 고르기, 작업을 잃을 수 있는 상태다. 나머지는 정하고 항목 파일에 적는다. 각 절차 파일의 질문 지점은 이 기준을 가리킨다
- [ ] #2 `start`에 플랜 모드(`EnterPlanMode`·`ExitPlanMode`)와 계획 승인 대기가 없다. `grep -rn 'EnterPlanMode\|ExitPlanMode' plugins i18n`으로 확인한다. 대신 셋이 적혀 있다. (가) 첫 메시지에서 목표와 가장 작은 변경을 되짚고 진행한다. (나) 착수 전 질문은 있을 때만 한 번에 묻고, 질문이 있으면 답 전에 브랜치도 파일도 만들지 않는다. (다) 계획과 스스로 정한 것은 항목 파일에 적고 기다리지 않는다. 사용자가 "계획을 보자"고 하면 보여 주고 기다린다
- [ ] #3 `start`의 "범위가 커지면 멈춘다"가 확인할 수 있는 목록으로 적혀 있다: AC 밖 동작, 새 의존성·도구 설치, 스키마·공개 API·삭제, CLAUDE.md·설정 변경
- [ ] #4 `create`는 AC 전문을 보여 주고 승인받는다. 서베이 모드는 후보 표에 AC 초안을 넣어, 고르기 한 번으로 항목을 쓰고 다시 승인받지 않는다
- [ ] #5 `start` 마무리의 simplify 질문 두 번(돌릴지, 무엇을 고칠지)이 없다
- [ ] #6 `end`는 판정에서 타당한 🔴·🟡 를 묻지 않고 고친 뒤 알린다. 묻는 것은 AC·정한 것과 부딪히는 지적과 "나중" 후보뿐이다. 스스로 정한 것, 그 질문, 머지 방식을 한 메시지로 추천·근거·위험과 함께 묻는다. "막기" 선택지가 없다
- [ ] #7 `docs/review-principles.md`의 "승인된 계획·AC 가 정한 것은 사용자가 정한 것" 원칙이 AC 와 사용자가 답한 것으로 좁혀져 있다. Claude 가 스스로 정한 가정은 리뷰 대상이다. `plugins`·`i18n`·`docs/backlog/_template.md`에 "승인된 계획" 문구가 남아 있지 않다
- [ ] #8 하위 세션 지시문(`task` SKILL.md 2절)에 플랜 모드 승인 문장이 없고, 하위 세션도 #1 기준을 따른다. 부모 세션이 계획 승인을 기다리는 문장이 없다
- [ ] #9 `/task`가 부르는 superpowers 스킬이 따로 다시 묻지 않게 부르는 쪽에서 미리 정해 넘긴다. 대상은 brainstorming(질문 하나씩, 접근 승인), test-driven-development(설정·문서 파일 예외), receiving-code-review(불분명한 지적), finishing-a-development-branch(기준 브랜치 확인)다. 이 넷이 묻는 지점이 절차 문서에서 하나씩 다뤄져 있다
- [ ] #10 frontend·server 점검과 ui-design 의 질문이 #1 기준을 따른다
  - 시안 수는 기본 3개이고 방향 표는 보여 주기만 한다. 캔버스에서 고르기는 남긴다
  - ui-design 의 쓰기·커밋 승인은 한 번으로 줄이고, `@DESIGN.md` 줄 추가는 묻는다
  - 로컬 Supabase 스택은 켜고 알린다
  - 공식 스킬 설치는 프로젝트당 한 번, 착수 전 질문에 합친다
- [ ] #11 지금 판과 바꾼 판을 같은 실제 사례로 돌려 사용자에게 멈추는 횟수를 셌고, 바꾼 판이 더 적다. 기존 eval 사례(`start-plan` 등)는 새 규칙에 맞게 고쳤다. 결과와 다시 돌리는 명령이 Implementation Notes 에 있다

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
