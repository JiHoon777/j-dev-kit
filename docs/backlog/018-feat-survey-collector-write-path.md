---
id: '018'
title: 서베이 수집 에이전트가 메모 폴더 밖에 쓰지 못하게 막는다
status: To Do
labels: [feat]
priority: low
dependencies: ['014']
created_date: 2026-11-27
updated_date: 2026-11-27
---

## Description

014 에서 서베이 수집 에이전트(`workflow:survey-collector`)의 도구를 읽기·웹 도구와 Write 로 줄였다. Write 는 메모를 직접 쓰려고 남겼다. 메모는 `.claude/.local/survey/<날짜>-<짧은 이름>/<각도>.md`에 쓴다(`plugins/workflow/skills/backlog/references/survey.md`).

Write 에는 경로 제한이 없다. 에이전트 정의의 "지시문이 정한 메모 파일만 쓴다"는 글뿐이다. 수집 에이전트는 바깥 웹과 이슈를 읽으니, 거기에 심은 지시가 먹히면 메모 폴더 밖의 파일(소스, 설정, 스킬)을 덮어쓸 수 있다. 014 의 보안 리뷰가 짚었고 014 Implementation Notes 의 `### 정한 것`에 적혀 있다.

글이 아니라 장치로 막는다(`principle-encode-lessons-in-structure`).

이번에 빼는 것: 판정 에이전트(Write 가 없다), 수집 에이전트의 웹 접근 범위, 다른 에이전트의 쓰기 제한.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 서베이 수집 에이전트가 `.claude/.local/survey/` 밖의 경로에 쓰려 하면 쓰기가 막히고, 막힌 이유가 그 에이전트에 돌아간다
- [ ] #2 서베이 수집 에이전트가 `.claude/.local/survey/` 안에 메모를 쓰는 것은 그대로 된다
- [ ] #3 메인 세션과 다른 에이전트(구현을 맡은 에이전트 등)의 쓰기는 영향받지 않는다
- [ ] #4 `..`이나 심볼릭 링크로 메모 폴더를 벗어나는 경로도 막힌다
- [ ] #5 위 넷을 시나리오 테스트(`scripts/test-*.sh`)가 확인하고, 검증 명령이 그 테스트를 돌린다

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
