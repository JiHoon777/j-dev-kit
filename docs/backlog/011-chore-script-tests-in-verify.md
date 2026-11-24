---
id: '011'
title: 바뀐 스크립트의 테스트를 검증이 돌리고, 두 벌인 port_open 이 같은지 검사
status: In Progress
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

- [x] #1 기준 브랜치 대비 `plugins/` 아래 `.sh` 파일이나 `scripts/check-repo-rules.sh`가 바뀌었으면, 검증 명령이 그 스크립트의 짝 테스트 `scripts/test-<스크립트 이름>.sh`를 돌린다. 테스트가 하나라도 틀리면 검증이 실패한다. 바뀐 스크립트가 없으면 테스트를 돌리지 않는다
- [x] #2 바뀐 스크립트에 짝 테스트가 없으면 검증이 그 스크립트 경로와 이유를 적고 실패한다
- [x] #3 `pick-port.sh`와 `dev-server.sh`의 `port_open` 함수 본문이 다르면 `check-repo-rules.sh`가 두 파일을 적고 실패한다
- [x] #4 `scripts/test-check-repo-rules.sh`에 #1~#3·#5 의 경우(바뀐 스크립트의 테스트 통과·실패, 바뀐 스크립트 없음, 짝 테스트 없음, 짝 테스트만 바뀜, port_open 같음·다름)가 있고 통과한다
- [x] #5 기준 브랜치 대비 짝 테스트 파일(`scripts/test-*.sh`)만 바뀌어도 검증 명령이 그 테스트를 돌리고, 틀리면 검증이 실패한다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [x] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [x] #2 원문(`plugins/`)을 고친 곳은 번역본(`i18n/en/`)도 같이 고쳤다
- [x] #3 고친 플러그인마다 `plugin.json` `version`을 올렸고, README 두 개와 `marketplace.json` 설명을 맞췄다

<!-- DOD:END -->

## Implementation Plan

승인: 2026-11-24, 부모 세션을 거쳐 사용자("추천안대로 승인"). 질문 1(짝 테스트만 바뀌어도 돌리기)은 추천대로 AC #5 로 더했다.

1. **무엇을 하나:** `scripts/check-repo-rules.sh`에 검사 6(바뀐 스크립트와 바뀐 짝 테스트의 테스트 돌리기)과 검사 7(두 `port_open` 본문 비교)을 더한다. 플러그인 스크립트와 훅 설정은 고치지 않는다.
2. **도구와 단계:** bash, git. 바뀐 파일은 기존 4번 검사처럼 `git diff --name-only --no-renames <merge-base>`와 추적하지 않는 파일. 본문은 `sed -n '/^port_open() {$/,/^}$/p'`로 뽑아 비교한다. 테스트 먼저 쓰고 틀리는 것을 본 뒤 검사를 고친다.
3. **바꿀 파일과 순서**
   1. `scripts/test-check-repo-rules.sh`(먼저)
      - 가짜 저장소 기준 커밋에 `plugins/alpha/scripts/tool.sh`와 짝 `scripts/test-tool.sh`, 실제 경로의 `pick-port.sh`·`dev-server.sh`(같은 작은 `port_open`, 위 주석은 다름)와 가짜 짝 테스트, 가짜 `scripts/check-repo-rules.sh`와 짝을 둔다.
      - `scenario()`의 문구가 `!`로 시작하면 출력에 없어야 한다.
      - 시나리오: 테스트 통과, 테스트 실패, 마크다운만 바뀜(테스트 안 돌림), 짝 없음, `scripts/check-repo-rules.sh` 바뀜, 짝 테스트만 바뀜(돌림)·그 테스트가 틀림, evals 의 `fixture.sh`만 바뀜, 스크립트 지움, port_open 같음(주석만)·다름·없음.
   2. `scripts/check-repo-rules.sh`
      - 7: 두 파일의 본문이 없으면 "port_open 을 찾지 못함: <파일>", 다르면 "port_open 다름: <파일1>, <파일2>"로 실패한다.
      - 6: 바뀐 `plugins/**/*.sh`(evals 제외)와 `scripts/check-repo-rules.sh`는 짝 `scripts/test-<이름>.sh`, 바뀐 `scripts/test-*.sh`는 그 자신. 지금 있는 파일만. 짝이 없으면 "짝 테스트 없음: <경로>"로 실패한다. 테스트마다 한 번 돌려 "테스트 통과: <테스트>" 또는 출력 마지막 20줄 뒤에 "테스트 실패: <테스트> (<바뀐 파일>)". 다른 검사 뒤 맨 마지막에 돈다.
      - 맨 위 주석과 기준 브랜치 없음 문구를 맞춘다.
   3. README 두 개: `check-repo-rules.sh` 설명(README.md:81, README.en.md:83)과 검사 문단(README.md:97, README.en.md:99).
   4. 정리(`simplify`) → 검증 → 판정 에이전트 → 커밋.
4. **성공 기준:** AC #1·#2·#3·#5 는 `bash scripts/test-check-repo-rules.sh`의 해당 시나리오 "맞음", #4 는 "N 개 중 N 개 맞음"과 판정 에이전트. 실제 저장소의 검증 명령 출력에 "테스트 통과: scripts/test-check-repo-rules.sh". DoD #2·#3 은 `plugins/`를 고치지 않아 해당 없음(`git diff --stat main...HEAD`).
5. **스택 점검:** frontend·server 모두 해당 없음.
6. **가정과 정한 것**
   - `plugins/*/evals/` 아래 `fixture.sh`는 뺀다(eval 준비 파일, 짝 테스트 없음).
   - 플러그인 스크립트 주석은 그대로 둔다. 그래서 플러그인 버전을 올리지 않고, 010 과 버전 번호가 겹치지 않는다.
   - 짝은 파일 이름만으로 찾는다.
   - Stop 훅의 기본 timeout 은 공식 문서로 확인해 가장 오래 걸리는 테스트와 비교해 적는다. 기본값이 더 짧으면 훅 설정을 고치지 않고 멈춰 부모 세션에 알린다.
   - 010 과 겹치는 파일은 README 두 개(고치는 줄이 다르다).

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

### Baseline

- `claude plugin validate . && bash scripts/check-repo-rules.sh`: 통과. 실패 없음(2026-11-24, main 2dba1aa).

### 계획에서 바뀐 것

- 시나리오는 12개를 더했다(계획 10개 + AC #5 의 짝 테스트만 바뀜 통과·틀림 2개). 문구 검사는 `has` 도우미로 묶고, `!`로 시작하면 없어야 하는 문구로 본다.
- 변경이 작아(검사 스크립트 약 40줄, 테스트 약 40줄) `simplify`는 부르지 않았다.

### 검증과 판정

- 테스트 먼저: 검사를 고치기 전 `bash scripts/test-check-repo-rules.sh`는 "42 개 중 33 개 맞음"(새 시나리오 9개 틀림, 없어야 할 문구 3개와 기존 30개는 맞음). 고친 뒤 "42 개 중 42 개 맞음".
- 실제 저장소: 검증 명령 종료 0. 출력 끝은 "✔ Validation passed / 테스트 통과: scripts/test-check-repo-rules.sh / 저장소 규칙 검사 통과". 이 브랜치가 검사 스크립트를 바꿔서 짝 테스트가 돌았다.
- 줄 끝: `.gitattributes`가 `* text=auto eol=lf`이고 두 `port_open` 파일은 `i/lf w/lf`라 본문 비교가 CRLF 에 흔들리지 않는다.
- 판정 에이전트(general-purpose, 항목 파일과 `git diff main...HEAD`만 받음): AC #1~#5, DoD #1~#3 모두 통과. 스스로 시나리오 테스트(42/42)와 검증 명령(종료 0)을 다시 돌렸다. DoD #2·#3 은 `git diff --stat main...HEAD -- plugins i18n .claude-plugin`가 비어 해당 없음.

### Stop 훅 시간 제한

- 공식 문서(https://code.claude.com/docs/en/hooks): `command` 훅의 기본 `timeout`은 600초다. 30초 예외는 `UserPromptSubmit`이고 Stop 은 600초에 든다. 시간 제한에 닿은 훅은 취소된다. `plugins/workflow/hooks/hooks.json`의 Stop 훅에는 `timeout`이 없다.
- 이 Windows 에서 잰 시간(초, 다른 실행이 없을 때): `test-base-tests.sh` 284, 검증 명령 전체(이 브랜치처럼 검사 스크립트가 바뀐 경우) 154.
- 다른 테스트와 겹쳐 돌 때 잰 시간(참고, 실제보다 길다): pick-port 46, base-tests 445, dev-server 23, diff-check 39, config-check 99, verify-on-stop 66, check-repo-rules 254. 합 972.
- 비교
  - 스크립트 하나가 바뀐 경우는 기본 600초 안이다. 가장 긴 `base-tests.sh`만 바뀌면 검증은 약 290초다(겹쳐 돌면 약 450초).
  - 여러 스크립트를 한 브랜치에서 함께 고치면 테스트가 차례로 돌아 600초를 넘을 수 있다. `base-tests.sh`와 `check-repo-rules.sh`만 함께 바뀌어도 단독 기준 약 440초다. 모두 바뀌면 단독 기준으로도 약 700초 이상으로 본다.
  - 넘으면 훅이 취소된다. 그러면 검증 없이 멈출 수 있다.
- 훅 설정은 고치지 않았다. 010 이나 새 항목에서 다룰지는 사용자가 정한다(부모 세션에 알림).

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것, 그대로 둔 지적과 이유, 사용자가 바로잡은 것.
