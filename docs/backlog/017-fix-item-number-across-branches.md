---
id: '017'
title: 항목 번호를 셀 때 다른 브랜치의 항목도 본다
status: To Do
labels: [fix]
priority: low
dependencies: ['016']
created_date: 2026-11-26
updated_date: 2026-11-26
---

## Description

`backlog` 스킬은 새 항목의 번호를 지금 폴더의 `docs/backlog/`와 `docs/done/`에서 가장 큰 번호 + 1 로 정한다(`plugins/workflow/skills/backlog/SKILL.md` 3단계). 작업 브랜치에서 항목을 만들면 그 브랜치에 있는 파일만 보게 된다. `/start`가 리뷰의 "나중" 후보를 작업 브랜치에서 새 항목으로 만들 때가 그렇다. 그 사이 기준 브랜치나 다른 `w/` 브랜치에서 같은 번호의 항목이 생겼으면 머지할 때 번호가 겹친다.

016 의 리뷰에서 나온 지적이다(016 전부터 있던 문제). 016 Implementation Notes 의 `### 리뷰` "나중 후보"에 적혀 있다.

이번에 빼는 것: 이미 겹친 번호를 찾아 고치는 일, 원격에만 있고 가져오지 않은 브랜치.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 번호를 셀 때 지금 폴더뿐 아니라 기준 브랜치와 다른 `w/` 브랜치의 `docs/backlog/`·`docs/done/`도 본다(로컬 브랜치와 이미 가져온 원격 브랜치. `git ls-tree`로 읽고 체크아웃하지 않는다). 그 가운데 가장 큰 번호 + 1 을 쓴다
- [ ] #2 다른 브랜치를 읽을 수 없으면(저장소가 아님, 브랜치 없음) 지금처럼 지금 폴더만 보고 센다. 멈추거나 묻지 않는다
- [ ] #3 파일을 쓰기 직전에 번호를 다시 세는 규칙도 같은 범위를 본다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 번역본(`i18n/en/`)을 원문과 같이 고쳤다
- [ ] #3 `plugin.json` `version`을 올렸다

<!-- DOD:END -->

## Implementation Plan

만들 때는 비워 둔다. `/start`가 계획을 적는다.

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

## Final Summary

`/start`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것, 그대로 둔 지적과 이유, 사용자가 바로잡은 것.
