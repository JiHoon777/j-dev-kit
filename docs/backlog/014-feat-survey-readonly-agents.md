---
id: '014'
title: 서베이 수집·판정 에이전트를 읽기·웹 도구만 가진 에이전트로 띄운다
status: To Do
labels: [feat]
priority: medium
dependencies: ['013']
created_date: 2026-11-25
updated_date: 2026-11-26
---

## Description

013 에서 서베이 모드(지금의 `/backlog --survey`)가 기본으로 바깥 웹을 읽게 됐다. 수집 하위 에이전트와 판정 에이전트는 모든 도구(Bash·Write·Edit·Agent)를 가진 general-purpose 다. 웹·이슈·로그 내용을 지시로 따르지 않게 막는 것은 지시문의 경계 문장뿐이다(013 리뷰에서 넣었다). 013 `/task end` 리뷰의 security-review 가 도구 자체를 줄이자고 제안했고, 사용자가 그 일을 새 항목으로 미뤘다.

선례: 003 의 trend-scout(도구 WebSearch·WebFetch 만), frontend·server 플러그인 에이전트의 `tools:` frontmatter.

근거: `docs/done/013-feat-survey-outside-research.md`(Implementation Notes "`/task end` 리뷰", Final Summary 미룬 것)

이번에 빼는 것: 서베이 밖의 다른 에이전트(`start`의 리뷰어 등) 도구 바꾸기, `.claude/.local/` 무시 목록 처리.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 workflow 플러그인에 서베이 수집용 에이전트가 있고, `tools:`가 읽기·웹 도구(Read, Grep, Glob, WebSearch, WebFetch. 메모를 직접 쓰면 Write)로 제한돼 있다
- [ ] #2 서베이 판정 에이전트는 근거 원문(웹 포함)을 열어 대조할 수 있게 읽기·웹 도구(Read, Grep, Glob, WebSearch, WebFetch)만 가지고, 파일을 고치거나 명령을 돌리는 도구는 없다
- [ ] #3 `backlog` 스킬의 `references/survey.md`(원문·번역본, 016 전의 `create.md` 서베이 절)가 수집과 판정에 그 에이전트를 부르고, 경계 문장은 그대로 있다
- [ ] #4 survey-outside eval 을 013 판과 견주어 점수가 낮지 않다(판정 규칙). 결과와 다시 돌리는 명령이 Implementation Notes 에 있다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 번역본을 같이 고쳤다
- [ ] #3 workflow `plugin.json` `version`을 올리고 README 두 개와 `marketplace.json` 설명을 맞췄다

<!-- DOD:END -->

## Implementation Plan

만들 때는 비워 둔다. `/start`가 계획을 적는다.

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

## Final Summary

`/start`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것, 그대로 둔 지적과 이유, 사용자가 바로잡은 것.
