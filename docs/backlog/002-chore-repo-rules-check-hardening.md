---
id: '002'
title: 저장소 규칙 검사 보강 — 설명 일치, 시나리오 테스트, 남은 사소함
status: To Do
labels: [chore]
priority: medium
dependencies: []
created_date: 2026-11-20
updated_date: 2026-11-20
---

## Description

001 에서 만든 `scripts/check-repo-rules.sh` 는 번역본 짝·번역본 갱신·version 올리기만 본다.
이 항목은 남은 세 가지를 메운다.

- CLAUDE.md 의 "README 두 개와 marketplace.json 설명도 맞춘다"는 규칙이 아직 지침으로만 있다.
  최근 30개 커밋 중 19개가 README 를, 8개가 marketplace.json 을 고쳤다.
- 001 에서 돌린 시나리오 12개가 임시 클론에만 있어, 스크립트를 다시 고칠 때 돌려 볼 수 없다.
- 001 리뷰에서 ⚪로 남긴 사소함 4건: quotePath 로 경로가 이스케이프됨, 지웠지만 스테이징하지
  않은 파일(원문·번역본을 함께 지우면 "번역본 없음"으로 잘못 실패), version 을 내려도 통과,
  `origin/<기준>` 을 찾지 못함.

가정: "설명이 맞다"는 각 플러그인의 `plugin.json` description 과 `marketplace.json` 의 그 플러그인
description 이 같다는 뜻이다. README.md·README.en.md 의 플러그인 목록은 플러그인 이름이 빠지지
않았는지만 본다(번역이라 문장 비교는 하지 않는다).

빼는 것: 번역 품질 검사, CI 연동.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 어떤 플러그인의 plugin.json description 과 marketplace.json description 이 다르면 검증 명령이 그 플러그인 이름과 함께 실패한다
- [ ] #2 marketplace.json 에 있는 플러그인이 README.md 나 README.en.md 에 빠져 있으면 검증 명령이 실패한다
- [ ] #3 저장소 안의 한 명령으로 검사 스크립트의 시나리오(001 의 12개와 이번에 더한 것)를 돌릴 수 있고, 모두 통과한다
- [ ] #4 원문과 번역본을 함께 지우고 스테이징하지 않은 상태에서 검증 명령이 통과한다
- [ ] #5 한글 등 비ASCII 경로의 파일이 걸릴 때 메시지에 경로가 이스케이프되지 않고 그대로 나온다
- [ ] #6 plugin.json version 을 기준보다 낮추면 검증 명령이 실패한다
- [ ] #7 로컬 `main` 이 없고 `origin/main` 만 있을 때도 번역본 갱신·version 검사를 건너뛰지 않는다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 UI 가 바뀌었으면 브라우저에서 확인함

<!-- DOD:END -->

## Implementation Plan

## Implementation Notes

## Final Summary
