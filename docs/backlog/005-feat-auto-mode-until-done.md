---
id: '005'
title: auto 모드가 끝나는 조건을 채우기 전에는 멈추지 않게
status: To Do
labels: [feat]
priority: medium
dependencies: ['004']
created_date: 2026-11-21
updated_date: 2026-11-21
---

## Description

auto 모드(004)에서 끝나는 조건을 채우지 못한 채 Claude 가 대답을 마치면 그대로 멈춘다. 채울 때까지 이어 가게 하되, 끝났다는 판정은 일한 세션의 말이 아니라 명령의 결과나 대화를 보지 못한 검증 에이전트의 판정에 근거하게 한다.

새 훅을 만들기보다 Claude Code 내장 `/goal`을 쓴다. 알아 둘 사실(공식 문서 code.claude.com/docs/en/goal.md, hooks.md, 2026-11-21 확인):

- `/goal`은 세션 범위의 prompt Stop 훅이다. 매 턴 작은 모델이 조건을 not yet met / met / impossible 로 판정하고, not yet met 이면 사유를 다음 지시로 넣어 이어 간다. 데스크톱 앱에서도 된다.
- 판정 모델은 **대화만 본다**. 명령을 돌리거나 파일을 읽지 않는다. 그래서 독립 판정 결과가 대화에 그대로 드러나 있어야 한다.
- 고정 반복 상한이 없다. 조건 문장에 상한을 적는 방식이다.
- 스킬이 `/goal`을 직접 걸 수 있는지는 문서에 없다.
- 기존 `verify-on-stop.sh`는 `stop_hook_active`가 true 면 검사 없이 통과시킨다. 다른 Stop 훅(`/goal` 포함)이 한 번 막은 뒤에는 검증 명령이 돌지 않는다. auto 모드와 상관없이 지금도 있는 문제다.
- 질문으로 턴을 끝내면 판정 모델이 not yet met 으로 보고 답 없이 이어 갈 수 있다(추론). `AskUserQuestion`은 답을 받을 때까지 턴이 끝나지 않는 것으로 보인다(문서로 확인하지 못함).

선행 사례: 공식 ralph-loop 는 일한 Claude 가 완료 문구를 말하면 끝나서 자기 채점이 된다. 근거 보고서는 `.claude/.local/reports/auto-mode-선행사례-조사.md`(커밋하지 않음).

이번에 빼는 것: 세션이 닫힌 뒤 이어 가기, 비용·시간 상한.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 auto 모드에서 끝나는 조건을 채우지 못한 채 대답을 마치면 멈추지 않고 이어 간다.
- [ ] #2 끝났다는 판정의 근거가 명령 결과나 대화를 보지 못한 검증 에이전트의 판정이고, 그 결과가 기준별 통과/실패로 대화에 그대로 보인다.
- [ ] #3 004 의 꼭 묻는 질문을 하면 사용자의 답을 받기 전에는 이어 가지 않는다.
- [ ] #4 반복 상한에 닿거나 같은 실패가 되풀이되면 멈추고 004 의 끝 보고를 한다.
- [ ] #5 다른 Stop 훅(`/goal` 포함)이 멈춤을 막은 뒤에도, Definition of Done 을 체크한 항목의 검증 명령 실패는 Claude 에게 돌아간다.
- [ ] #6 시작 뒤 끝나는 조건이 바뀌거나 지워지면 끝났다고 보지 않고 사용자에게 알린다.
- [ ] #7 auto 모드가 꺼져 있으면 동작이 바뀌지 않는다.

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 원문을 고친 곳은 번역본도 고쳤고, 고친 플러그인의 version·README 두 개·marketplace.json 설명을 맞췄다
- [ ] #3 `verify-on-stop.sh`를 `stop_hook_active` 참·거짓, DoD 체크 있음·없음, 검증 통과·실패의 JSON 입력과 임시 저장소로 돌리는 시나리오 테스트가 통과한다

<!-- DOD:END -->

## Implementation Plan

만들 때는 비워 둔다. `/task start`가 승인된 계획을 적는다.

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것.
