---
id: '001'
title: lead·scout 정리와 저장소 규칙 검사
status: In Progress
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

- [x] #1 plugins/ 의 마크다운에 i18n/en/ 짝이 없으면 검증 명령이 실패한다
- [x] #2 main 대비 바뀐 플러그인의 version 이 그대로면 검증 명령이 실패한다
- [x] #3 CLAUDE.md 의 검증 명령이 #1·#2 검사를 포함한다
- [x] #4 README 두 개가 관점별 상한 10 을 고정값으로 적는다
- [x] #5 run.md 가 서브에이전트 작업 세션의 검증은 상위 세션의 머지 때 검증으로 덮는다고 적는다
- [x] #6 run.md 가 멈춘 백그라운드 서브에이전트에 사용자 답을 이어서 전하는 방법을 적는다
- [x] #7 marketplace.json 의 metadata.description 에 /lead 가 있다
- [x] #8 workflow 의 plugin.json·marketplace.json 설명에 backlog-scout 에이전트가 있다
- [x] #9 /lead 의 allowed-tools 에 git diff 가 있다
- [x] #10 scout 가 "자리가 없어 더하지 못한 것"의 제목을 사용자에게 알린다
- [x] #11 /lead scout 가 제안함을 처음 만들 때 .gitignore 에 넣자고 제안한다
- [x] #12 /lead schedule 이 "끄기"와 "off" 둘 다로 예약을 끈다
- [x] #13 예약으로 돈 scout 는 새로 생긴 제안만 올린다
- [x] #14 scout 3단계가 갱신 줄을 "제목 아래 갱신: 줄"로 가리킨다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate .` 통과(#3 뒤에는 바뀐 검증 명령 통과)
- [ ] #2 원문을 고친 곳은 번역본도 고쳤고, workflow version 을 올렸다

<!-- DOD:END -->

## Implementation Plan

무엇을 하나: 저장소 규칙 두 가지(번역본 짝, version 올리기)를 검사 스크립트로 강제하고, lead·scout·schedule 절차와 설명의 빈틈을 메운다. 빼는 것: SubagentStop 훅, 상한 설정화, 번역본만 남은 파일 검사, README·marketplace 설명 일치 검사.

커밋 A — 검사 (AC #1~3)
- `scripts/check-repo-rules.sh` 새로(bash·git 만): `plugins/` 의 md(추적 + untracked)마다 `i18n/en/<같은 경로>` 확인. `git merge-base <기준, 기본 main> HEAD` 대비 작업 폴더에서 `plugins/<이름>/` 이 바뀐 플러그인마다 `plugin.json` `version` 이 기준과 같으면 실패. 기준에 없던 플러그인은 건너뛴다. main 에서는 diff 가 비어 통과
- CLAUDE.md 검증 명령: `claude plugin validate . && bash scripts/check-repo-rules.sh`
- README 두 개: 구조·업데이트 절에 스크립트 한 줄
- 테스트: en 파일 하나 잠시 지움 → 실패 / workflow md 고치고 version 그대로 → 실패 / version 올림 → 통과 / 변경 없음 → 통과. 결과는 Implementation Notes 에

커밋 B — 설명 (AC #4, 7, 8)
- README 두 개: "관점마다 10개는 기본값" → "고정값(설정으로 바꿀 수 없다)"
- marketplace.json `metadata.description` 에 /lead, workflow 설명에 backlog-scout 에이전트. plugin.json description 도 같은 문구

커밋 C — lead 절차 (AC #5, 6, 9~14), 원문 + en, workflow 0.6.6 → 0.6.7
- lead/SKILL.md: allowed-tools 에 `Bash(git diff *)`, argument-hint `schedule [주기 | 끄기 | off]`
- run.md 4단계: 서브에이전트 작업 세션에는 Stop 검증 훅이 돌지 않고 6단계 머지 때 검증이 덮는다. 5단계: 멈춘 백그라운드 서브에이전트에는 같은 에이전트에 SendMessage 로 이어서 전한다
- scout.md 3단계: "제목 아래 `갱신:` 줄", 제안함을 새로 만들었고 .gitignore 에 없으면 4단계에서 넣자고 제안. 4단계: "자리가 없어 더하지 못한 것" 제목을 알린다, 예약 실행이면 새로 생긴 제안만 올리고 없으면 한 줄로 알린다
- schedule.md: `끄기`나 `off` 면 3절만, 4절에 둘 다
- README 두 개 진두지휘 절에 끄기 두 가지, 예약은 새 제안만

성공 기준: #1·#2 는 위 경우를 돌려 확인, #3 은 CLAUDE.md 줄과 새 검증 명령 통과, #4~#14 는 고친 줄을 grep 으로(원문·en 둘 다).

가정: 항목의 가정 둘(상한 고정값, SendMessage 로 이어 전하기). version 은 패치(0.6.7). 스크립트는 저장소 루트 `scripts/`(플러그인 밖이라 version 검사 대상 아님). schedule 1절의 .gitignore 제안은 그대로 두고 scout 에 "처음 만들 때"만 더한다.

## Implementation Notes

### Baseline

- `claude plugin validate .` 통과. 이미 실패하는 것 없음.
- 스택 점검: frontend·server 해당 없음(`stack: 없음`).

### 검사 스크립트 테스트

저장소 안에 테스트 파일은 두지 않았다(계획대로). 임시 클론에서 시나리오를 돌렸다. 스크립트를 쓰기 전에는 통과해야 할 3개가 실패(127)했고, 쓴 뒤 7개 모두 맞았다: 변경 없음 → 통과, en 짝 지움 → 실패, untracked md 짝 없음 → 실패, frontend 고치고 version 그대로 → 실패, version 올림 → 통과, 커밋한 변경 version 그대로 → 실패, 번역본만 고침 → 통과. 기준 브랜치를 못 찾으면 version 검사를 건너뛰고 그렇다고 알린다.

### 계획에서 바뀐 것

- workflow version(0.6.7)을 커밋 C 대신 커밋 B 에서 올렸다. B 가 workflow 의 plugin.json 을 고치므로, 올리지 않으면 새 검사가 B 에서 실패한다.

## Final Summary
