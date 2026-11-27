---
id: '014'
title: 서베이 수집·판정 에이전트를 읽기·웹 도구만 가진 에이전트로 띄운다
status: Done
labels: [feat]
priority: medium
dependencies: ['013']
created_date: 2026-11-25
updated_date: 2026-11-27
---

## Description

013 에서 서베이 모드(지금의 `/backlog --survey`)가 기본으로 바깥 웹을 읽게 됐다. 수집 하위 에이전트와 판정 에이전트는 모든 도구(Bash·Write·Edit·Agent)를 가진 general-purpose 다. 웹·이슈·로그 내용을 지시로 따르지 않게 막는 것은 지시문의 경계 문장뿐이다(013 리뷰에서 넣었다). 013 `/task end` 리뷰의 security-review 가 도구 자체를 줄이자고 제안했고, 사용자가 그 일을 새 항목으로 미뤘다.

선례: 003 의 trend-scout(도구 WebSearch·WebFetch 만), frontend·server 플러그인 에이전트의 `tools:` frontmatter.

근거: `docs/done/013-feat-survey-outside-research.md`(Implementation Notes "`/task end` 리뷰", Final Summary 미룬 것)

이번에 빼는 것: 서베이 밖의 다른 에이전트(`start`의 리뷰어 등) 도구 바꾸기, `.claude/.local/` 무시 목록 처리.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [x] #1 workflow 플러그인에 서베이 수집용 에이전트가 있고, `tools:`가 읽기·웹 도구(Read, Grep, Glob, WebSearch, WebFetch. 메모를 직접 쓰면 Write)로 제한돼 있다
- [x] #2 서베이 판정 에이전트는 근거 원문(웹 포함)을 열어 대조할 수 있게 읽기·웹 도구(Read, Grep, Glob, WebSearch, WebFetch)만 가지고, 파일을 고치거나 명령을 돌리는 도구는 없다
- [x] #3 `backlog` 스킬의 `references/survey.md`(원문·번역본, 016 전의 `create.md` 서베이 절)가 수집과 판정에 그 에이전트를 부르고, 경계 문장은 그대로 있다
- [x] #4 survey-outside eval 을 013 판과 견주어 점수가 낮지 않다(판정 규칙). 결과와 다시 돌리는 명령이 Implementation Notes 에 있다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [x] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [x] #2 번역본을 같이 고쳤다
- [x] #3 workflow `plugin.json` `version`을 올리고 README 두 개와 `marketplace.json` 설명을 맞췄다

<!-- DOD:END -->

## Implementation Plan

만들 때는 비워 둔다. `/start`가 계획을 적는다.

## Implementation Notes

016 뒤의 pstack 점검 수정과 같은 브랜치(`w/pstack-fidelity`)에서 항목 017 과 함께 했다. 계획은 따로 적지 않았다.

### 정한 것

- 수집 에이전트(`survey-collector`)에 Write 를 줬다 — 메모를 직접 써야 메인 세션에 원문이 쌓이지 않는다(AC #1 이 허용한다) — 메모 폴더 밖에 쓸 수 있다. 경로를 막는 장치는 없다(보안 리뷰가 짚었다)
- 명령 자료(`gh issue list`, 로그를 뽑는 명령)는 메인 세션이 돌려 출력을 파일로 넘긴다 — 수집 에이전트에 Bash 가 없다 — 메인 세션이 명령 출력을 한 번 더 다룬다

### eval 결과 (survey-outside, 2026-11-27)

| 판 | 점수 (5회) | 평균 ± 표준편차 | 실행당 비용(API 환산) | 실행당 시간 |
| --- | --- | --- | --- | --- |
| main (general-purpose 에이전트) | 1, 1, 0.75, 1, 1 | 0.95 ± 0.11 | $2.93 | 312초 |
| 이 브랜치 (survey-collector, survey-judge) | 0.75, 1, 1, 1, 1 | 0.95 ± 0.11 | $3.62 | 360초 |

- 평균 차이가 0 이라 판정 규칙(차이가 두 표준오차의 합 0.10 보다 작으면 같음)으로 "같음"이다. 013 때의 고친 판(0.95 ± 0.11)과도 같다.
- 채점 항목별 통과 수도 두 판이 같다: 바깥 검색 5, 보고서 5, 출처 표시 5, 겹침 거르기 4.
- 이 브랜치 판의 기록에는 `workflow:survey-collector`와 `workflow:survey-judge`만 나오고 general-purpose 호출이 없다. main 판은 general-purpose 뿐이다.

다시 돌리기(두 사본: main 판은 `git archive main plugins/workflow`, 고친 판은 이 브랜치의 `plugins/workflow`. 둘 다 `hooks/`를 뺀다):

```bash
claude plugin eval <사본>/workflow --ablation none --scaffold --trust-plugin --model opus --judge-model sonnet --runs 5 --tag survey --no-publish --threshold 0 -j 3 --allow-tools WebSearch WebFetch Write --json <사본>.json
```

### 리뷰

016 뒤의 pstack 점검 수정, 항목 017 와 한 브랜치에서 함께 받았다(커밋 `b93dd92..b4f6a01`. 그 브랜치는 머지한 뒤 지웠다). 고친 것은 `7b27285`, `59c09ec`, `b4f6a01`의 커밋 메시지에 있다. 브랜치 전체로 🔴 3개와 🟡 13개를 고쳤고, 틀린 지적 5개와 ⚪ 3개를 두었다. 틀린 지적과 ⚪ 의 목록은 남기지 않았다.

### 머지

- 로컬에서 main 에 머지하고 푸시한다 (사용자, 2026-11-27).

## Final Summary

**바뀐 것**

- 서베이 수집 에이전트 `workflow:survey-collector`(Read, Grep, Glob, WebSearch, WebFetch, Write)와 판정 에이전트 `workflow:survey-judge`(Read, Grep, Glob, WebSearch, WebFetch)를 더했다. `/backlog --survey`가 general-purpose 대신 이 둘을 띄운다.
- 명령에서 오는 자료(`gh issue list` 등)는 메인 세션이 돌려 출력을 파일로 넘긴다. 두 에이전트에 Bash 가 없기 때문이다.
- eval(`survey-outside`)은 main 판과 5회씩 0.95 ± 0.11 로 같다.
- workflow 0.18.0.

**리뷰에서 고친 것**

- 판정 에이전트가 명령 출력 파일을 받지 못했다 → 경로를 넘긴다.
- 수집·판정 에이전트의 지시문이 `worker.md`를 읽게 하지 않았다 → 첫 줄에 넣는다.
- 판정이 애매한 후보를 탈락시켰다 → 근거 약함으로 둔다.
- README 와 플러그인 설명이 수집 에이전트의 Write 를 빠뜨렸다 → 적었다.

**미룬 것**

- 수집 에이전트의 Write 에 경로 제한이 없다 → 018.

**그대로 둔 지적과 이유**

- 이 항목에만 걸린 것은 없다. 틀린 지적과 ⚪ 의 목록은 남기지 않았다(Implementation Notes 의 `### 리뷰`).

**사용자가 바로잡은 것**

- 없다.
