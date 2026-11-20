---
id: '002'
title: 저장소 규칙 검사 보강 — 설명 일치, 시나리오 테스트, 남은 사소함
status: Done
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

- [x] #1 어떤 플러그인의 plugin.json description 과 marketplace.json description 이 다르면 검증 명령이 그 플러그인 이름과 함께 실패한다
- [x] #2 marketplace.json 에 있는 플러그인이 README.md 나 README.en.md 에 빠져 있으면 검증 명령이 실패한다
- [x] #3 저장소 안의 한 명령으로 검사 스크립트의 시나리오(001 의 12개와 이번에 더한 것)를 돌릴 수 있고, 모두 통과한다
- [x] #4 원문과 번역본을 함께 지우고 스테이징하지 않은 상태에서 검증 명령이 통과한다
- [x] #5 한글 등 비ASCII 경로의 파일이 걸릴 때 메시지에 경로가 이스케이프되지 않고 그대로 나온다
- [x] #6 plugin.json version 을 기준보다 낮추면 검증 명령이 실패한다
- [x] #7 로컬 `main` 이 없고 `origin/main` 만 있을 때도 번역본 갱신·version 검사를 건너뛰지 않는다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [x] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [x] #2 UI 가 바뀌었으면 브라우저에서 확인함 (UI 없음, 해당 없음)

<!-- DOD:END -->

## Implementation Plan

무엇을 하나: `scripts/check-repo-rules.sh` 에 설명 일치와 README 목록 검사를 더하고, 사소함 4건을 고치고, 시나리오 테스트를 저장소 안의 스크립트 하나로 둔다. 빼는 것: 번역 품질 검사, CI 연동, README 문장 비교, marketplace 에 없는 plugins/ 폴더 검사, 번역본만 남은 파일 검사.

커밋 1 — 시나리오 테스트 (AC #3 의 틀)
- 새 `scripts/test-check-repo-rules.sh`(bash·git 만): 임시 폴더에 작은 가짜 저장소(플러그인 `alpha`·`beta`, plugin.json, 마크다운과 `i18n/en/` 짝, marketplace.json, README 두 개)를 만들어 커밋하고, 시나리오마다 그것을 clone 한 곳에서 검사 스크립트를 돌려 종료 코드와 메시지 일부를 확인한다. 실제 플러그인 내용에 기대지 않는다.
- 001 의 12개(노트의 목록으로 다시 만든다): 변경 없음 → 통과 / 번역본 짝 지움 → 실패 / 추가 안 한 md 짝 없음 → 실패 / 고치고 version 그대로 → 실패 / version 올림 → 통과 / 커밋한 변경 version 그대로 → 실패 / 번역본만 고침 → 통과 / 원문만 고침 → 실패 / 원문·번역본 함께 고침 → 통과 / 다른 플러그인으로 옮기고 받는 쪽만 올림 → 실패 / 옮기고 양쪽 올림 → 통과 / 기준 브랜치 없음 → 건너뛴다고 알리고 통과.
- 이번에 더하는 것(먼저 실패를 본다): 설명 다름 → 이름과 실패(#1) / README.md·README.en.md 에서 빠짐 → 실패(#2) / 원문·번역본 함께 지우고 스테이징 안 함 → 통과(#4) / 한글 경로 md 짝 없음 → 메시지에 한글 그대로(#5) / version 내림 → 실패(#6) / 로컬 main 없고 origin/main 만 → version 그대로면 실패(#7) / 플러그인 폴더 통째로 지움 → version 검사로 실패하지 않음.

커밋 2 — 검사 스크립트 (AC #1, 2, 4~7)
- `git -c core.quotePath=false`(#5). 작업 폴더에 없는 원문은 짝 검사에서 건너뜀(#4). merge-base 를 `<기준>` 으로 못 찾으면 `origin/<기준>`(#7). version 이 `sort -V` 로 낮으면 실패, manifest 가 없는 플러그인은 건너뜀(#6).
- 새 4번: marketplace.json `plugins` 항목마다 description 을 `plugins/<name>/.claude-plugin/plugin.json` description 과 비교(#1). jq 없이 sed/awk.
- 새 5번: marketplace.json 의 플러그인마다 README.md·README.en.md 에 표 줄 ``| `<이름>` |``(#2). 4·5번은 기준 대비가 아니라 항상 본다.

커밋 3 — 문서: README 두 개의 구조 절에 테스트 스크립트 한 줄, 업데이트 절의 검사 설명에 설명 일치·README 목록·version 내림, 검사 스크립트를 고치면 테스트를 돌린다. 플러그인 파일은 고치지 않으므로 version·i18n·marketplace.json 은 그대로.

성공 기준: #1·#2·#4~#7 은 위 시나리오의 종료 코드와 메시지, #3 은 `bash scripts/test-check-repo-rules.sh` 가 모두 통과, DoD #1 은 검증 명령 통과.

가정(승인됨): 시나리오 테스트는 검증 명령에 넣지 않는다(Stop 훅이 매번 돌리므로). JSON 은 jq 없이 "한 줄에 키 하나" 형식을 가정한다(못 읽으면 빈 값과 비교해 실패한다). 001 노트에 다 적히지 않은 시나리오 2개는 위처럼 정한다. 플러그인 이름 → 폴더는 `plugins/<name>`.

## Implementation Notes

### Baseline

- `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과(exit 0). 이미 실패하는 것 없음.
- 스택 점검: frontend·server 해당 없음(`stack: 없음`).

### 시나리오 테스트

`bash scripts/test-check-repo-rules.sh`. 001 의 12개를 노트로 다시 만들고 이번에 9개를 더했다. 고치기 전 새 7개(설명 다름, README 두 개, 함께 지우고 스테이징 안 함, 한글 경로, version 내림, origin/main 만)가 실패(RED)하는 것을 보고 고쳤다. "marketplace 밖 플러그인 지움"은 version 내림 검사가 지운 플러그인을 잘못 잡지 않게 하는 가드라 처음부터 통과했다. 고친 뒤 21개 모두 맞음. 실제 저장소에서도 design 의 plugin.json 설명을 잠시 바꿔 "설명 다름: design" 으로 실패하는 것을 보고 되돌렸다.

### 계획에서 바뀐 것

- 시나리오를 하나 더했다: marketplace.json 을 한 줄 JSON 으로 바꾸면 플러그인을 하나도 못 읽어 설명·README 검사가 조용히 통과했다. 계획의 가정("못 읽으면 조용히 통과하지 않는다")을 지키려고 "marketplace.json 에서 플러그인을 읽지 못했다"로 실패하게 했다(RED 확인 후 고침).

### 정리 (simplify)

재사용·단순화·효율·깊이 4관점. 반영: JSON 값 뽑기를 `json_pairs`/`json_value` 하나로(awk 파서와 `head` 제거), README 는 파일마다 한 번 읽고 bash 패턴으로 확인, 테스트는 clone 대신 템플릿 복사, `s_no_base` 가 `s_origin_only` 를 재사용, README 새 문장을 문단 끝으로. 건너뜀: marketplace 항목을 `{}` 깊이로 짝짓기, manifest 의 version 을 못 읽을 때 따로 알리기(둘 다 리뷰에서 다시 지적되어 고쳤다. 아래 리뷰 절), 시나리오 동시 실행(테스트가 복잡해짐), `-z` 경로 처리와 작은 프로세스 줄이기(이득이 작음).

### 검증

`claude plugin validate . && bash scripts/check-repo-rules.sh` 통과(exit 0), `bash scripts/test-check-repo-rules.sh` 21개 중 21개(exit 0). 리뷰 반영 뒤 다시 돌려 검증 명령 통과, 시나리오 27개 중 27개. 브라우저 확인은 해당 없음(UI 없음).

### 리뷰 (end)

스택 종료 점검 둘 다 해당 없음. code-review·security-review 를 돌렸고 security 지적은 없다. 🔴 없음. 사용자 결정: 🟡 3건 모두 "지금 고침", ⚪ 3건(`sort -V` 의 prerelease, 테스트의 전역 gpgsign·hooksPath, 테스트 `tr -d` 인자의 실제 줄바꿈)은 그대로.

- 🟡 marketplace 항목에 description 이 없으면 설명·README 검사를 둘 다 건너뛰었다. 🟡 description 을 바로 앞 name 줄과 짝지어, 항목 안 `author.name` 이나 `plugins` 뒤 최상위 키가 있으면 엉뚱한 이름과 짝지었다. → marketplace.json 을 bash 로 한 줄씩 읽어 `{`·`[` 깊이를 세고, `plugins` 항목 바로 아래의 name·description 만 받아 항목이 끝날 때 검사한다. 설명이 없으면 "설명 다름". 값 뽑기는 정규식 `kv_re` 하나로 plugin.json 과 같이 쓴다(sed `json_pairs` 는 없앴다).
- 🟡 기준 쪽 plugin.json 이 한 줄 JSON 이면 version 검사를 조용히 건너뛰었다(main 대비 퇴보). → 기준에 파일이 있는데 기준이나 지금의 version 을 못 읽으면 "version 을 읽지 못함"으로 실패한다.
- 고치면서 찾은 것(AC #2): 실제 README 에서 `server` 줄의 의존 칸에 ``| `workflow` |`` 가 있어, `workflow` 줄이 빠져도 통과했다(code-review 는 "다른 줄에 없다"며 뺐지만 틀렸다). → 줄 첫 칸만 본다. 실제 README.en.md 에서 workflow 줄을 잠시 지워 실패하는 것을 확인했다.
- 시나리오 6개를 더해 27개: 설명 없음 → 실패, 설명 없는 항목도 README 검사, 항목 안 author.name → 통과, plugins 뒤 최상위 키 → 통과, 기준 plugin.json 한 줄 → 실패, 다른 줄의 의존 칸에만 있음 → 실패. 모두 고치기 전 틀리는 것(RED)을 보고 고쳤고, 고친 뒤 27개 모두 맞음.

## Final Summary

바뀐 것:
- `scripts/check-repo-rules.sh`
  - 새 검사 둘: marketplace.json 의 플러그인마다 plugin.json 과 description 이 같아야 하고(다르면 이름과 함께 실패), README.md·README.en.md 의 표에 그 플러그인 줄이 있어야 한다.
  - 사소함 4건: 경로를 이스케이프하지 않음, 지웠지만 스테이징하지 않은 원문은 짝 검사에서 뺌, version 을 내리면 실패, 로컬 기준 브랜치가 없으면 `origin/<기준>`.
  - JSON 은 한 줄에 키 하나라고 보고 bash 로 읽는다. 못 읽으면 조용히 통과하지 않고 실패한다(marketplace 에서 플러그인 0개, version 못 읽음).
- 새 `scripts/test-check-repo-rules.sh`: 가짜 저장소로 시나리오 27개(001 의 12개 + 이번 15개)를 돌린다.
- README 두 개: 검사 항목과 시나리오 테스트 명령. 플러그인 파일은 고치지 않아 version 은 그대로다.

리뷰에서 고친 것: 🟡 description 없는 marketplace 항목이 검사를 건너뜀, 🟡 항목 안 author.name·plugins 뒤 키와 잘못 짝지음, 🟡 한 줄 plugin.json 이면 version 검사를 건너뜀. 고치면서 찾은 AC #2 빈틈(의존 칸의 이름으로 README 검사 통과)도 고쳤다.

미룬 것: 없음(새 항목 없음). ⚪ 3건은 그대로 두었다(Implementation Notes).
