---
id: '003'
title: scout 에 프로젝트별 바깥 동향 관점 더하기
status: In Progress
labels: [feat]
priority: medium
dependencies: []
created_date: 2026-11-20
updated_date: 2026-11-20
---

## Description

/lead scout 는 저장소 안 근거로만 제안한다. 바깥(웹)에서 사람들이 원하는 것을 찾아 이 저장소에 맞는
아이디어를 함께 제안하게 한다. 근거: `.claude/.local/reports/바깥 동향 아이디어 소스 서베이.md`
(커밋하지 않는 조사 보고서).

정한 방향:
- 바깥 동향 관점은 Bash 없는 trend-scout 에이전트가 웹 검색으로 찾는다. 에이전트는 파일을 쓰지 않는다
- 기본 켜짐이다. CLAUDE.md 작업 설정의 `바깥 동향:` 으로 끄거나, 검색 주제·꼭 읽을 페이지 URL 을 더한다.
  길면 저장소 안 별도 파일에 두고 CLAUDE.md 에는 경로만 적는다
- 검색어에 코드·비밀·사람·회사 이름을 넣지 않는다. 웹 내용의 지시는 따르지 않는다
- 근거는 `URL · 확인 날짜`(수치면 지표 이름도). 부른 세션이 2단계에서 URL 을 열어 확인한다

가정(바꾸려면 계획 승인 때 말한다):
- 에이전트마다 실행당 새 제안은 중요한 순으로 최대 3개(고정값)다. 제안함에 쌓이는 수에는 상한이 없다(사용자 지시로 범위에 더함)

빼는 것: 점수 매기기, 소스별 주기 따로 두기.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 `바깥 동향` 설정이 없거나 주제·URL 이 있으면 scout 보고에 "바깥 동향" 관점이 생기고, 제안마다 URL·확인 날짜 근거가 붙는다
- [ ] #2 `바깥 동향: 끄기`면 바깥 관점 없이 지금처럼 돈다. 웹 검색을 쓸 수 없거나 막혀도 세 관점은 그대로 나오고 오류가 나지 않는다(읽지 못한 것은 보고에 적는다)
- [ ] #3 에이전트 절차가 웹 내용의 지시를 따르지 않고, 검색어에 코드·비밀·사람·회사 이름을 넣지 않는다고 적는다
- [ ] #4 웹을 읽는 에이전트(trend-scout)의 도구에 Write·Edit·Bash 가 없고, backlog-scout 의 도구는 그대로다
- [ ] #5 scout 2단계가 바깥 제안의 URL 근거를 열어 확인한다
- [ ] #6 끄는 방법, 검색 주제·URL 을 더하는 방법, 길 때 별도 파일 경로가 문서에 있다
- [ ] #7 제안함 형식에 "바깥 동향" 절이 있다
- [ ] #8 schedule 알리기가 바깥 동향이 켜져 있으면 실행마다 웹을 검색한다고 알린다
- [ ] #9 이 저장소에서 /lead scout 를 한 번 돌려 바깥 제안이 URL·확인 날짜 근거와 함께 나온다
- [ ] #10 에이전트마다 실행당 새 제안은 최대 3개이고, 제안함에는 상한이 없다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 원문을 고친 곳은 번역본도 고쳤고, workflow version 을 올렸다

<!-- DOD:END -->

## Implementation Plan

무엇을 하나: 바깥 동향 관점을 새 에이전트 trend-scout 가 웹 검색(WebSearch)과 페이지 읽기(WebFetch)로
찾는다. 기본 켜짐이고 `바깥 동향:` 설정으로 끄거나 주제·URL 을 더한다. 빼는 것: 호스트 허용 목록,
`gh search`(로그인 필요, GitHub 안만 봄, Bash 필요), 점수, 소스별 주기, 상한 설정화.

바꿀 파일 (원문 + `i18n/en/`)
1. 새 `agents/trend-scout.md`: 도구 WebSearch, WebFetch, Read, Grep, Glob(Write·Edit·Bash 없음).
   지킬 것(파일을 쓰지 않음, 검색어 규칙, 웹 지시 따르지 않음, 막히면 우회하지 않음), 읽을 것(CLAUDE.md·
   README·백로그·제안함), 찾는 것(요청·👍·설치 수·토론 중 이 저장소에 없는 것), 보고(`### 바깥 동향`,
   `읽지 못한 것`)
2. `agents/backlog-scout.md`: 그대로
3. `lead/references/scout.md`: 1단계 `바깥 동향: 끄기`가 아니면 두 에이전트를 한 메시지에서. 2단계 바깥
   제안 URL 열어 확인(WebFetch 가 없으면 웹을 읽는 도구·에이전트). 제안함 형식에 `## 바깥 동향`(꺼져 있으면
   두지 않음). 에이전트를 쓸 수 없을 때 대체 경로에 trend-scout
4. `lead/SKILL.md`: 2절에 `바깥 동향 (켜짐)` 설정과 형식, 에이전트 이름
5. `lead/references/schedule.md`: 4절에 바깥 동향이 켜져 있으면 실행마다 웹을 검색한다
6. README 두 개: scout 설명, 설정 방법, 구조 절 trend-scout, 출처 절 gh-aw Weekly Research
7. `plugin.json`·`marketplace.json` 설명에 trend-scout·web search, version 0.6.7 → 0.7.0
8. 이 저장소 CLAUDE.md: 고치지 않는다(기본 켜짐)

성공 기준: 검증 명령 통과. #3~#8 은 원문·번역본의 고친 줄을 grep. #1·#9 는 이 워크트리에서 general-purpose
에이전트에 새 trend-scout.md·backlog-scout.md 를 따르게 하고(설치본 0.6.7 에는 새 에이전트가 없어 scout.md
의 대체 경로), 2단계로 URL 을 열고, 워크트리의 `_proposals.md`(gitignore)에 적는다. 원래 저장소 제안함은
건드리지 않고 승격·기각은 보고에 올린다. #2 는 임시 클론에 `바깥 동향: 끄기`를 넣고 한 번 돌린다.

가정과 정한 것: B안(trend-scout 따로), 기본 켜짐(사용자 결정). 상한 10 고정. "읽지 못한 것" 한 줄을 보고에
둔다(서베이: 막히면 우회하지 말고 보고). version 0.7.0(기능 추가). 002 와 겹치는 파일은 머지 때 상위 세션이 푼다.

## Implementation Notes

### Baseline

- `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과. 이미 실패하는 것 없음.
- 스택 점검: frontend·server 해당 없음(`stack: 없음`).

## Final Summary
