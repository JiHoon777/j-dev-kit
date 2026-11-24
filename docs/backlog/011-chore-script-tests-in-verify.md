---
id: '011'
title: 바뀐 스크립트의 테스트를 검증이 돌리고, 두 벌인 port_open 이 같은지 검사
status: To Do
labels: [chore]
priority: medium
dependencies: ['009']
created_date: 2026-11-24
updated_date: 2026-11-24
---

## Description

009 가 더한 스크립트 다섯 개(`pick-port.sh`, `base-tests.sh`, `dev-server.sh`, `diff-check.sh`, `config-check.sh`)에는 `scripts/test-*.sh` 테스트가 있다. 하지만 검증 명령(`claude plugin validate . && bash scripts/check-repo-rules.sh`)은 그 테스트를 돌리지 않는다. 지키는 것은 스크립트 머리 주석의 "고치면 scripts/test-X.sh 를 돌린다"는 당부뿐이다. 기존 `check-repo-rules.sh`, `verify-on-stop.sh`도 같다. 그래서 스크립트를 고치고 테스트를 돌리지 않아도 검증과 Stop 훅이 통과한다. 009 의 원칙("되풀이되는 실수는 글로 당부하지 말고 자동 검사로 막는다")과 어긋난다. 근거는 009 정리 리뷰(깊이 #6)와 009 Implementation Notes 의 "알아 둘 것"이다.

테스트는 이 Windows 에서 한 번에 1분 안팎 걸린다(`test-base-tests.sh`는 5분 안팎). 그래서 매번 전부 돌리지 않고, 기준 브랜치 대비 바뀐 스크립트의 테스트만 돌린다.

포트를 듣는지 확인하는 `port_open` 함수는 `plugins/workflow/skills/task/scripts/pick-port.sh`와 `plugins/frontend/skills/frontend-start-check/scripts/dev-server.sh`에 같은 본문으로 두 벌 있다. 플러그인은 따로 설치되니 한 파일로 합칠 수는 없다. 두 곳 주석에 "같은 함수, 고치면 둘 다"라고 적어 둔 것이 전부라, 한쪽만 고치면 조용히 어긋난다. 근거는 009 정리 리뷰(깊이 #3, 재사용, 단순화 #9)다.

이번에 빼는 것:
- 테스트를 빠르게 만들기
- CI 에서 돌리기
- 테스트 하네스를 공용 파일로 합치기(기존 관례대로 파일마다 둔다)

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 기준 브랜치 대비 `plugins/` 아래 `.sh` 파일이나 `scripts/check-repo-rules.sh`가 바뀌었으면, 검증 명령이 그 스크립트의 짝 테스트 `scripts/test-<스크립트 이름>.sh`를 돌린다. 테스트가 하나라도 틀리면 검증이 실패한다. 바뀐 스크립트가 없으면 테스트를 돌리지 않는다
- [ ] #2 바뀐 스크립트에 짝 테스트가 없으면 검증이 그 스크립트 경로와 이유를 적고 실패한다
- [ ] #3 `pick-port.sh`와 `dev-server.sh`의 `port_open` 함수 본문이 다르면 `check-repo-rules.sh`가 두 파일을 적고 실패한다
- [ ] #4 `scripts/test-check-repo-rules.sh`에 #1~#3 의 경우(바뀐 스크립트의 테스트 통과·실패, 바뀐 스크립트 없음, 짝 테스트 없음, port_open 같음·다름)가 있고 통과한다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 원문(`plugins/`)을 고친 곳은 번역본(`i18n/en/`)도 같이 고쳤다
- [ ] #3 고친 플러그인마다 `plugin.json` `version`을 올렸고, README 두 개와 `marketplace.json` 설명을 맞췄다

<!-- DOD:END -->

## Implementation Plan

만들 때는 비워 둔다. `/task start`가 승인된 계획을 적는다.

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것, 그대로 둔 지적과 이유, 사용자가 바로잡은 것.
