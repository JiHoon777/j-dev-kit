---
id: '007'
title: 검증 훅 테스트의 "내용을 못 구함" 시나리오가 Windows 에서도 그 경로를 타게
status: Done
labels: [fix]
priority: medium
dependencies: []
created_date: 2026-11-23
updated_date: 2026-11-23
---

## Description

`scripts/test-verify-on-stop.sh`의 "내용을 못 구하고 다른 훅이 막은 뒤 → 통과"가 Windows(Git Bash)에서 실패한다(종료 2, 기대 0). 준비 함수 `hide_index`가 `chmod 000 .git/index`로 인덱스를 못 읽게 하려 하지만, Windows 에서는 읽기 전용이 될 뿐 계속 읽혀서 훅이 내용(tree)을 구해 버린다. 옆 시나리오 "내용을 못 구해도 첫 멈춤의 실패 → 되돌림"은 기대값이 우연히 같아 통과할 뿐 그 경로를 시험하지 못한다.

이번에 빼는 것: 훅(`plugins/workflow/hooks/verify-on-stop.sh`)의 동작은 바꾸지 않는다.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [x] #1 Windows(Git Bash)에서 `bash scripts/test-verify-on-stop.sh`가 모두 맞는다
- [x] #2 두 "내용을 못 구함" 시나리오에서 훅이 실제로 내용을 구하지 못한다(빈 tree)

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [x] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과

<!-- DOD:END -->

## Implementation Plan

사용자가 대화에서 진행을 요청함(2026-11-23). `hide_index`를 `chmod 000` 대신 `.git/index`를 깨진 내용으로 덮게 바꾼다. 깨진 인덱스로는 `git add`·`write-tree`가 실패해 어느 OS 에서나 내용을 못 구한다.

## Implementation Notes

### 한 것

- `hide_index`: `chmod 000` 대신 `.git/index`를 깨진 내용으로 덮고, 그래도 `git write-tree`가 되면 준비 실패로 둔다.
- Windows(Git Bash)에서 11개 중 11개 맞음. 훅 사본에 tree 를 찍는 줄을 넣어 돌려, 두 "내용을 못 구함" 시나리오만 `tree=[]`이고 나머지는 내용을 구하는 것을 봤다(저장소의 훅은 그대로).
- macOS·Linux 에서는 돌려 보지 않았다. 깨진 인덱스로 `write-tree`가 실패하는 것은 git 동작이라 같아야 한다.

### Baseline

`claude plugin validate . && bash scripts/check-repo-rules.sh` 통과. `bash scripts/test-verify-on-stop.sh`는 11개 중 10개(이 항목의 시나리오가 틀림).

## Final Summary

- **바뀐 것:** `scripts/test-verify-on-stop.sh`의 `hide_index`가 `chmod 000` 대신 인덱스를 깨뜨려, Windows 에서도 "내용을 못 구함" 경로를 시험한다. 그래도 tree 가 구해지면 준비 실패로 둔다. 훅은 그대로다.
- **리뷰에서 고친 것:** 없음(리뷰 에이전트를 돌리지 않았다. 사용자가 바로 머지를 요청했다).
- **미룬 것:** 없음. macOS·Linux 에서는 돌려 보지 않았다.
