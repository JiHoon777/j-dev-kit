---
id: '001'
title: lead·scout 정리와 저장소 규칙 검사
status: To Do
labels: [fix]
priority: medium
dependencies: []
created_date: 2026-11-20
updated_date: 2026-11-20
---

## Description

/lead scout 이 2026-11-20 에 올린 제안 12개를 한 항목으로 묶었다(사용자 요청). workflow 의
lead·scout·schedule 절차와 설명의 빈틈을 메우고, 지침으로만 있던 저장소 규칙(번역본 짝, 버전
올리기)을 검사로 강제한다.

정한 방향:
- 저장소 규칙: 검사 스크립트를 두고 CLAUDE.md 의 검증 명령에 더한다
- 서브에이전트 작업 세션의 검증: 훅은 그대로 두고, 상위 세션이 머지마다 검증 명령을 돌리는 것으로 덮는다고 문서에 적는다
- 예약으로 돈 scout: 새로 생긴 제안만 올린다. 쌓인 전체는 /lead run 에서 본다

가정(바꾸려면 계획 승인 때 말한다):
- 관점별 상한 10 은 설정으로 빼지 않고, README 문구를 "고정값"으로 고친다
- 멈춘 백그라운드 서브에이전트에는 같은 에이전트를 이어서(SendMessage) 사용자 답을 전한다

빼는 것: SubagentStop 훅 추가, 상한을 설정으로 빼는 일.
한 항목으로는 큰 편이다. 리뷰하기 크면 /task start 계획에서 커밋을 나눈다.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 plugins/ 의 마크다운에 i18n/en/ 짝이 없으면 검증 명령이 실패한다
- [ ] #2 main 대비 바뀐 플러그인의 version 이 그대로면 검증 명령이 실패한다
- [ ] #3 CLAUDE.md 의 검증 명령이 #1·#2 검사를 포함한다
- [ ] #4 README 두 개가 관점별 상한 10 을 고정값으로 적는다
- [ ] #5 run.md 가 서브에이전트 작업 세션의 검증은 상위 세션의 머지 때 검증으로 덮는다고 적는다
- [ ] #6 run.md 가 멈춘 백그라운드 서브에이전트에 사용자 답을 이어서 전하는 방법을 적는다
- [ ] #7 marketplace.json 의 metadata.description 에 /lead 가 있다
- [ ] #8 workflow 의 plugin.json·marketplace.json 설명에 backlog-scout 에이전트가 있다
- [ ] #9 /lead 의 allowed-tools 에 git diff 가 있다
- [ ] #10 scout 가 "자리가 없어 더하지 못한 것"의 제목을 사용자에게 알린다
- [ ] #11 /lead scout 가 제안함을 처음 만들 때 .gitignore 에 넣자고 제안한다
- [ ] #12 /lead schedule 이 "끄기"와 "off" 둘 다로 예약을 끈다
- [ ] #13 예약으로 돈 scout 는 새로 생긴 제안만 올린다
- [ ] #14 scout 3단계가 갱신 줄을 "제목 아래 갱신: 줄"로 가리킨다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate .` 통과(#3 뒤에는 바뀐 검증 명령 통과)
- [ ] #2 원문을 고친 곳은 번역본도 고쳤고, workflow version 을 올렸다

<!-- DOD:END -->

## Implementation Plan

## Implementation Notes

## Final Summary
