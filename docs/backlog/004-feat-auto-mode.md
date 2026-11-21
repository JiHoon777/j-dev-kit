---
id: '004'
title: 'auto 모드: 목표와 끝나는 조건만 주면 묻지 않고 끝까지 진행'
status: In Progress
labels: [feat]
priority: medium
dependencies: []
created_date: 2026-11-21
updated_date: 2026-11-21
---

## Description

지금은 일을 맡겨도 j-dev-kit 스킬이 묻는 곳(계획 승인, 머지 승인, 시안 고르기 등)에서 멈춘다. 다른 저장소의 세션에서 스킬은 그대로 두고 "확신도 90% 넘을 때까지 반복"만 주자 설계 검증을 9회차까지 묻지 않고 돌았다. 매 회차 대화를 보지 못한 새 에이전트가 판정했다. 스킬을 고칠 필요 없이, 세션에 "맡겨진 상태"라고 알려 주면 된다.

`/auto <목표> <끝나는 조건>` 스킬 하나를 둔다. 이 스킬이 세션에 하는 말은 이것뿐이다.

1. 이 세션은 맡겨진 상태다. j-dev-kit 스킬이 사용자에게 물으라는 곳에서 묻지 말고, 스스로 정하고 적어 둔 뒤 계속한다.
2. 끝났는지는 직접 판단하지 말고, 대화를 보지 못한 새 에이전트나 명령으로 확인한다.
3. 되돌릴 수 없는 일(지우기, 푸시, 프로젝트 밖 변경)만 멈추고 묻는다.
4. 끝나면 한 일과 스스로 정한 것을 보고한다.

끝나는 조건을 채울 때까지 이어 가는 것은 새로 만들지 않고 Claude Code 내장 `/goal`을 쓴다. `/goal`의 판정 모델은 대화만 보므로(공식 문서 goal.md, 2026-11-21 확인) 확인 결과를 대화에 그대로 보여 준다.

`/goal`과 함께 쓰려면 `plugins/workflow/hooks/verify-on-stop.sh`도 고쳐야 한다. 이 훅은 `stop_hook_active`가 true 면 검사 없이 통과시키는데, 이 값은 어느 Stop 훅이 막았든 true 가 된다(공식 hooks.md). 그래서 `/goal`이 한 번 막은 뒤에는 Definition of Done 을 체크해도 검증 명령이 돌지 않는다.

이번에 빼는 것: 다른 스킬 고치기, 새 Stop 훅, 도구 권한 프롬프트(권한 모드는 사용자가 정한다).

이름 "auto 모드"는 Claude Code 의 권한 모드 이름과 겹친다. 만들 때 이름을 정한다.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 목표와 끝나는 조건을 주고 켜면 그 밖의 것을 묻지 않고 j-dev-kit 스킬로 일을 시작한다.
- [ ] #2 스킬이 사용자에게 물으라는 곳에서 묻지 않고 정해서 진행하고, 정한 것이 적혀 남는다.
- [ ] #3 끝났는지를 일한 세션의 말이 아니라 명령 결과나 대화를 보지 못한 에이전트의 확인으로 정한다.
- [ ] #4 되돌릴 수 없는 일(지우기, 푸시, 프로젝트 밖 변경)에서만 멈추고 묻는다.
- [ ] #5 끝나면 한 일, 스스로 정한 것, 못 한 것을 보고한다.
- [ ] #6 `/goal` 같은 다른 Stop 훅이 멈춤을 막은 뒤에도 Definition of Done 을 체크한 항목의 검증 명령 실패가 Claude 에게 돌아가고, 같은 실패로 되풀이해 되돌려 보내지는 않는다.

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 원문을 고친 곳은 번역본도 고쳤고, 고친 플러그인의 version·README 두 개·marketplace.json 설명을 맞췄다
- [ ] #3 임시 저장소에서 목표 하나로 한 번 돌려 보고, 질문 횟수와 끝 보고를 Implementation Notes 에 적었다
- [ ] #4 `verify-on-stop.sh`를 `stop_hook_active` 참·거짓, DoD 체크 있음·없음, 검증 통과·실패, 같은 실패 두 번째의 JSON 입력과 임시 저장소로 돌리는 시나리오 테스트가 통과한다

<!-- DOD:END -->

## Implementation Plan

명령 이름은 `/until-done`(사용자가 "더 명시적으로"를 요청). workflow 플러그인에 스킬 하나를 더하고 verify-on-stop 을 고친다. 다른 스킬은 고치지 않는다.

1. `scripts/test-verify-on-stop.sh` 를 먼저 쓴다(test-check-repo-rules.sh 처럼 임시 저장소 + JSON 입력). 시나리오: `w/` 아님, DoD 체크 없음, 검증 통과, 검증 실패, `stop_hook_active: true` 에서 검증 실패(지금은 통과돼 실패해야 함), 같은 내용 두 번째 실패, 내용을 바꾼 뒤 실패.
2. `plugins/workflow/hooks/verify-on-stop.sh`: `stop_hook_active`로 빠져나가는 줄을 빼고, 되돌려 보낸 내용(tree)을 표시 파일에 남겨 같은 내용이면 다시 되돌리지 않는다.
3. `plugins/workflow/skills/until-done/SKILL.md`(사용자만 부름): 맡겨진 상태 네 줄, `Ruling:` 기록, 대화를 못 본 에이전트나 명령으로 끝 확인, 되돌릴 수 없는 일만 모아서 묻기, 끝 보고, 시작할 때 `/goal` 한 줄 안내, 절차 파일 찾는 곳.
4. 번역본 `i18n/en/plugins/workflow/skills/until-done/SKILL.md`.
5. workflow version 0.8.0, plugin.json·marketplace.json 설명, README 두 개(표, 사용법, 구조, 권한 모드 auto 와 다르다는 줄).

성공 기준: AC #1~#5 는 임시 저장소에서 `claude -p --plugin-dir`로 작은 목표 한 번(안 되면 적고 수동 방법을 남긴다). AC #6 은 시나리오 테스트. DoD #1·#2 는 검증 명령.

가정: 스킬은 workflow 플러그인에 둔다. 다른 플러그인의 절차 파일은 설치 폴더에서 가장 높은 버전을 읽는다(옛 버전에 고정된 프로젝트에서는 틀릴 수 있다).

## Implementation Notes

### Baseline

`claude plugin validate . && bash scripts/check-repo-rules.sh` 통과(2026-11-21). 스택 점검(`-start-check`) 스킬은 이 세션에 없어 해당 없음.

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것.
