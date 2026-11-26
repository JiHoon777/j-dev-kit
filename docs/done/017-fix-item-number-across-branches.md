---
id: '017'
title: 항목 번호를 셀 때 다른 브랜치의 항목도 본다
status: Done
labels: [fix]
priority: low
dependencies: ['016']
created_date: 2026-11-26
updated_date: 2026-11-27
---

## Description

`backlog` 스킬은 새 항목의 번호를 지금 폴더의 `docs/backlog/`와 `docs/done/`에서 가장 큰 번호 + 1 로 정한다(`plugins/workflow/skills/backlog/SKILL.md` 3단계). 작업 브랜치에서 항목을 만들면 그 브랜치에 있는 파일만 보게 된다. `/start`가 리뷰의 "나중" 후보를 작업 브랜치에서 새 항목으로 만들 때가 그렇다. 그 사이 기준 브랜치나 다른 `w/` 브랜치에서 같은 번호의 항목이 생겼으면 머지할 때 번호가 겹친다.

016 의 리뷰에서 나온 지적이다(016 전부터 있던 문제). 016 Implementation Notes 의 `### 리뷰` "나중 후보"에 적혀 있다.

이번에 빼는 것: 이미 겹친 번호를 찾아 고치는 일, 원격에만 있고 가져오지 않은 브랜치.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [x] #1 번호를 셀 때 지금 폴더뿐 아니라 기준 브랜치와 다른 `w/` 브랜치의 `docs/backlog/`·`docs/done/`도 본다(로컬 브랜치와 이미 가져온 원격 브랜치. `git ls-tree`로 읽고 체크아웃하지 않는다). 그 가운데 가장 큰 번호 + 1 을 쓴다
- [x] #2 다른 브랜치를 읽을 수 없으면(저장소가 아님, 브랜치 없음) 지금처럼 지금 폴더만 보고 센다. 멈추거나 묻지 않는다
- [x] #3 파일을 쓰기 직전에 번호를 다시 세는 규칙도 같은 범위를 본다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [x] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [x] #2 번역본(`i18n/en/`)을 원문과 같이 고쳤다
- [x] #3 `plugin.json` `version`을 올렸다

<!-- DOD:END -->

## Implementation Plan

만들 때는 비워 둔다. `/start`가 계획을 적는다.

## Implementation Notes

016 뒤의 pstack 점검 수정과 같은 브랜치(`w/pstack-fidelity`)에서 항목 014 와 함께 했다. 계획은 따로 적지 않았다.

### 정한 것

- 번호 세기를 스킬의 글이 아니라 스크립트(`plugins/workflow/skills/backlog/scripts/next-number.sh`)로 했다 — 여러 브랜치를 읽는 명령을 글로 적으면 세션마다 다르게 돌린다. 스크립트는 테스트할 수 있다(`principle-build-the-lever`, `principle-encode-lessons-in-structure`) — 스크립트를 돌릴 수 없는 환경에서는 스킬이 "지금 폴더에서 직접 센다"로 돌아간다
- 저장소 안이면 어느 폴더에서 돌려도 저장소 루트 기준으로 센다 — 리뷰가 하위 폴더에서 `001`이 나오는 것을 찾았다 — 없음

### 확인

- `bash scripts/test-next-number.sh`: 7개 중 7개 맞음(저장소 아님, 다른 로컬 브랜치, 하위 폴더, 원격 추적 브랜치, 한글 이름, 커밋하지 않은 항목).
- 이 테스트는 main 의 소스에서는 실패한다(`base-tests.sh main 'bash {}'` → `기준에서 실패: scripts/test-next-number.sh`). 스크립트가 없기 때문이다.
- 이 저장소에서 돌리면 `018`이 나온다(가장 큰 번호 017).

### 머지

- 로컬에서 main 에 머지하고 푸시한다 (사용자, 2026-11-27).

## Final Summary

**바뀐 것**

- `plugins/workflow/skills/backlog/scripts/next-number.sh`가 작업 트리와 모든 브랜치(로컬, 이미 가져온 원격)의 `docs/backlog/`·`docs/done/`을 통틀어 가장 큰 번호 + 1 을 찍는다. 브랜치는 체크아웃하지 않고 읽는다.
- `backlog` 스킬이 번호를 이 스크립트로 센다. 파일을 쓰기 직전에 다시 세는 것도 같은 스크립트다.
- 짝 테스트 `scripts/test-next-number.sh`(시나리오 7개)를 검증 명령이 돌린다.
- workflow 0.18.0.

**리뷰에서 고친 것**

- 하위 폴더에서 돌리면 `001`이 나왔다 → 저장소 루트 기준으로 센다.
- 이름에 한글이 든 항목을 세지 못했다 → 경로를 그대로 읽게 했다.
- 스킬의 설명이 스크립트의 동작과 어긋났다 → 맞췄다.

**미룬 것**

- 없다. 이미 겹친 번호를 고치는 일과 가져오지 않은 원격 브랜치는 처음부터 뺐다.

**그대로 둔 지적과 이유**

- 이 항목에만 걸린 것은 없다.

**사용자가 바로잡은 것**

- 없다.
