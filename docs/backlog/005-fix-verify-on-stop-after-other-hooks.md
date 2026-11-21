---
id: '005'
title: 다른 Stop 훅이 막은 뒤에도 verify-on-stop 검증이 돌게
status: To Do
labels: [fix]
priority: medium
dependencies: []
created_date: 2026-11-21
updated_date: 2026-11-21
---

## Description

`plugins/workflow/hooks/verify-on-stop.sh`는 입력의 `stop_hook_active`가 true 면 검사 없이 통과시킨다. 자기 자신이 한 번만 되돌려 보내려고 넣은 것인데, 이 값은 어느 Stop 훅이 막았든 true 가 된다. 그래서 내장 `/goal`이나 다른 플러그인의 Stop 훅이 한 번 막은 뒤에는 Definition of Done 을 체크해도 검증 명령이 돌지 않는다. `/goal`을 켜고 일하는 지금도 생기는 문제이고, 004 의 auto 모드는 `/goal`에 기댄다.

알아 둘 사실(공식 hooks.md, 2026-11-21 확인): `stop_hook_active`는 "Stop 훅 때문에 이미 이어 가는 중"이라는 뜻이고 어느 훅인지는 알려 주지 않는다. 훅이 도구 사용 없이 연속 8번 막으면 Claude Code 가 무시한다.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 다른 Stop 훅(`/goal` 포함)이 멈춤을 막은 뒤에도, Definition of Done 을 체크한 항목의 검증 명령 실패가 Claude 에게 돌아간다.
- [ ] #2 같은 내용에 대해 이 훅이 같은 실패로 되풀이해 되돌려 보내지 않는다(지금처럼 한 번).
- [ ] #3 검증이 이미 통과한 내용이면 다시 돌리지 않는다(지금 동작 유지).

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 원문을 고친 곳은 번역본도 고쳤고, workflow version·README 두 개·marketplace.json 설명을 맞췄다
- [ ] #3 `stop_hook_active` 참·거짓, DoD 체크 있음·없음, 검증 통과·실패, 같은 실패 두 번째를 JSON 입력과 임시 저장소로 돌리는 시나리오 테스트가 통과한다

<!-- DOD:END -->

## Implementation Plan

만들 때는 비워 둔다. `/task start`가 승인된 계획을 적는다.

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것.
