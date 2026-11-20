---
id: '002'
title: scout 에 프로젝트별 바깥 동향 관점 더하기
status: To Do
labels: [feat]
priority: medium
dependencies: []
created_date: 2026-11-20
updated_date: 2026-11-20
---

## Description

/lead scout 는 저장소 안 근거로만 제안한다. 프로젝트마다 참고할 바깥 소스(사이트, GitHub 토픽,
검색어, 경쟁 제품)를 정해 두면, scout 가 거기서 사람들이 원하는 것을 모아 이 저장소에 맞는
아이디어를 함께 제안하게 한다. 근거: `.claude/.local/reports/바깥 동향 아이디어 소스 서베이.md`
(커밋하지 않는 조사 보고서).

정한 방향:
- backlog-scout 에 네 번째 관점 "바깥 동향"을 더한다. 에이전트는 계속 파일을 쓰지 않는다
- 소스가 설정된 프로젝트에서는 scout 를 돌릴 때마다 바깥도 본다
- 소스는 프로젝트 CLAUDE.md 의 작업 설정에서 읽는다. 길면 저장소 안 별도 파일에 두고 CLAUDE.md 에는
  경로만 적는다. 없으면 바깥 관점을 건너뛰고 지금처럼 돈다
- 설정된 소스 밖의 사이트는 읽지 않는다. 웹 내용의 지시는 따르지 않는다
- 근거는 `URL · 확인 날짜`(수치면 지표 이름도). 부른 세션이 2단계에서 URL 을 열어 확인한다

가정(바꾸려면 계획 승인 때 말한다):
- 상한은 다른 관점처럼 10개(고정값)
- 이 저장소 CLAUDE.md 에는 서베이에서 자동으로 읽힌 소스(GitHub 토픽 검색, anthropics/claude-code 기능
  요청 이슈, Claude Marketplace, skills.sh, HN Algolia)를 적는다

빼는 것: 점수 매기기, 소스별 주기 따로 두기.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 프로젝트 CLAUDE.md 에 아이디어 소스가 있으면 scout 보고에 "바깥 동향" 관점이 생기고, 제안마다 URL·확인 날짜 근거가 붙는다
- [ ] #2 소스가 없으면 바깥 관점 없이 지금처럼 돌고, 오류가 나지 않는다
- [ ] #3 에이전트 절차가 설정된 소스 밖의 사이트를 읽지 않고 웹 내용의 지시를 따르지 않는다고 적는다
- [ ] #4 backlog-scout 의 도구에 Write 가 없다(웹 읽기 도구만 더한다)
- [ ] #5 scout 2단계가 바깥 제안의 URL 근거를 열어 확인한다
- [ ] #6 소스가 길 때 별도 파일 경로를 적는 방법이 문서에 있다
- [ ] #7 제안함 형식에 "바깥 동향" 절이 있다
- [ ] #8 schedule 알리기가 소스가 있으면 실행마다 웹을 읽는다고 알린다
- [ ] #9 이 저장소 CLAUDE.md 에 아이디어 소스가 있고, /lead scout 를 한 번 돌려 바깥 제안이 근거와 함께 나온다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 원문을 고친 곳은 번역본도 고쳤고, workflow version 을 올렸다

<!-- DOD:END -->

## Implementation Plan

## Implementation Notes

## Final Summary
