---
id: '004'
title: 'auto 모드: 목표와 끝나는 조건만 받고 묻지 않고 진행'
status: To Do
labels: [feat]
priority: medium
dependencies: []
created_date: 2026-11-21
updated_date: 2026-11-21
---

## Description

지금은 일을 맡겨도 `/task`, `/lead`, `/ui`의 승인 지점(계획 승인, 리뷰 지적 결정, 머지 승인, 제안 승격, 시안 방향)에서 사용자에게 묻고 멈춘다. todak 세션에서 "확신도 90% 넘을 때까지 반복"만 주자 설계 검증을 9회차까지 묻지 않고 돌았다. 능력은 있고, 멈추게 하는 것은 절차의 승인 지점이다.

auto 모드는 시작할 때 **목표와 끝나는 조건 두 가지만** 받는다. 고정할 것, 안 할 것은 미리 묻지 않고 사용자가 중간에 말하면 그때부터 지킨다. 승인 지점에서는 묻지 않고 스스로 정하고, 정한 것을 기록하고 알림만 보낸다.

이번에 빼는 것: 끝나는 조건을 훅으로 지키기(005), QA 역할 에이전트·킥오프 흐름·보기 화면([인수인계](_handoff-app-autopilot.md)의 나머지), 세션이 닫힌 뒤에도 도는 것(클라우드, 예약).

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 목표와 끝나는 조건만 주고 auto 모드를 켜면 그 밖의 것을 미리 묻지 않고 시작한다.
- [ ] #2 auto 모드에서 `/task`·`/lead`·`/ui`의 승인 지점에서 묻지 않고 진행하고, 스스로 정한 것이 기록 파일에 남고 사용자에게 알림이 간다.
- [ ] #3 사용자만 답할 수 있는 것(사용자가 가진 값, 프로젝트 밖을 바꾸는 일, 원격 푸시)에서는 멈추고 묻는다. 모아서 한 번에 묻고, 이미 답한 것은 다시 묻지 않는다.
- [ ] #4 사용자가 중간에 말한 제약(예: "배포는 나중에")이 기록되고 이후 판단에서 지켜진다.
- [ ] #5 auto 모드가 꺼져 있으면 기존의 묻는 동작이 그대로다.

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
