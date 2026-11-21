---
id: '005'
title: auto 모드의 끝나는 조건을 Stop 훅으로 지키기
status: To Do
labels: [feat]
priority: medium
dependencies: ['004']
created_date: 2026-11-21
updated_date: 2026-11-21
---

## Description

auto 모드(004)에서 끝나는 조건을 채우지 못한 채 Claude가 멈추려 하면 Stop 훅이 막고 남은 일을 지시로 돌려준다. 끝났는지는 일한 세션이 아니라 명령의 결과나 대화를 보지 못한 판정자가 정한다. 공식 ralph-loop 플러그인은 일한 Claude가 완료 문구를 말하면 끝나서 자기 채점이 된다. 이걸 피하려는 것이다.

알아 둘 사실 (공식 hooks 문서, 2026-11-21 확인):

- Stop 훅은 질문으로 턴을 끝낼 때도 실행되고, "답 기다리는 중"과 "끝났다고 봄"을 구분하는 필드는 없다.
- 훅이 도구 사용 없이 연속 8번 막으면 Claude Code가 무시한다. 일하는 동안은 횟수가 초기화되므로 반복 상한은 따로 필요하다.
- 플러그인 훅은 스킬을 부르지 않아도 늘 등록된다.
- agent 훅(별도 에이전트가 판정)은 experimental 이다.

이번에 빼는 것: 세션이 닫힌 뒤 이어 가기.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 끝나는 조건을 채우지 못한 채 멈추려 하면 멈추지 않고 남은 일을 받아 계속한다.
- [ ] #2 끝났다는 판정이 작업한 세션의 말이 아니라 명령의 결과나 대화를 보지 못한 판정자의 결과로 난다.
- [ ] #3 사용자에게 답을 기다리는 중이면 훅이 막지 않고 멈추게 둔다.
- [ ] #4 반복 상한에 닿으면 멈추고 한 일, 정한 것, 못 한 것을 보고한다.
- [ ] #5 auto 모드가 꺼져 있으면 훅이 아무것도 하지 않고, 기존 verify-on-stop 동작이 그대로다.

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 원문을 고친 곳은 번역본도 고쳤고, 고친 플러그인의 version·README 두 개·marketplace.json 설명을 맞췄다

<!-- DOD:END -->

## Implementation Plan

만들 때는 비워 둔다. `/task start`가 승인된 계획을 적는다.

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것.
