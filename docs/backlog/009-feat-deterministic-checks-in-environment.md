---
id: '009'
title: 정해진 절차는 스크립트로, 되풀이되는 지적은 자동 검사로, 테스트는 고치기 전 코드에서 확인 (네 자료 1~4)
status: In Progress
labels: [feat]
priority: medium
dependencies: []
created_date: 2026-11-23
updated_date: 2026-11-24
---

## Description

Lauren Tan(pstack) 영상과 Satya Nadella 영상, 그리고 두 영상을 옮긴 뉴스레터 글 두 편(아래 참고 자료)을 j-dev-kit 과 대조한 보고서 `.claude/.local/reports/2026-11-23-네-자료-비교.md`(커밋하지 않음)의 3절 개선 후보 1~4를 한 항목으로 한다. 사용자가 나누지 않기로 정했다. 아래 타임스탬프는 그 시점으로 가는 링크다. "탠"과 "포콕"은 Tan 영상, "나델라"는 Nadella 영상이다.

1. **기계적인 절차를 스크립트로:** 스킬의 결정적인 부분은 스크립트로 옮겨 판단을 아낀다(탠 [20:51](https://www.youtube.com/watch?v=MN9dGgmLyso&t=1251s), [23:05](https://www.youtube.com/watch?v=MN9dGgmLyso&t=1385s) "rebuild the world each time", [23:43](https://www.youtube.com/watch?v=MN9dGgmLyso&t=1423s), 글 1의 「첫 계단은 검증, 실수는 환경으로」 단락). 지금 포트 정하기(`start.md` 4단계), 개발 서버를 띄우고 듣는지 확인하기(`frontend-start-check`와 `frontend-end-check`에 같은 긴 문단이 두 번), 추가된 줄의 디버그 코드·lockfile 검사(`frontend-end-check` 1절)는 마크다운 문장이고 `lsof`만 쓴다. 이 Windows 기계에는 `lsof`도 `nc`도 없어 세션마다 다른 방법을 지어낸다. 판단이 필요한 부분(무엇을 띄울지, 백엔드도 필요한지)은 마크다운에 남긴다. `server-end-check`의 기계적 검사(새로 읽는 환경 변수가 `.env.example`에 없음, 값 파일 커밋, 키 패턴)도 같다. 전문가 스킬 활용 조사(`.claude/.local/reports/2026-11-23-전문가-스킬-활용.md` 공통분모 2, 후보 4)가 같은 결론이라 이 항목에 더했다. 마이그레이션 담당 판별, oasdiff 결과 해석처럼 판단이 필요한 검사는 글로 남긴다.
2. **되풀이되는 지적은 린트·테스트·타입으로:** 같은 실수를 두 번 보면 글로 당부하지 말고 자동 검사로 막는다(탠 [31:43](https://www.youtube.com/watch?v=MN9dGgmLyso&t=1903s)–[32:01](https://www.youtube.com/watch?v=MN9dGgmLyso&t=1921s), [50:24](https://www.youtube.com/watch?v=MN9dGgmLyso&t=3024s)–[51:06](https://www.youtube.com/watch?v=MN9dGgmLyso&t=3066s), [54:02](https://www.youtube.com/watch?v=MN9dGgmLyso&t=3242s), 포콕 [32:42](https://www.youtube.com/watch?v=MN9dGgmLyso&t=1962s), 글 1의 「첫 계단은 검증, 실수는 환경으로」 단락의 역피라미드와 「1인 창업자를 위한 체크리스트」 3번). 지금 `/task end` 4단계는 🟡 에 "지금 / 나중 / 그대로"만 묻는다. 받아들여 고친 지적이 전에도 있었거나 이번 리뷰에서 여러 곳에 나오면 "자동 검사로 막기"를 고를 수 있게 한다. 한 번뿐인 지적에는 붙이지 않는다.
3. **새 테스트가 고치기 전 코드에서 실패하는지:** 고친 코드를 뺀 채 새 테스트를 돌려 그래도 통과하면 고쳤다는 증거로 치지 않는다(나델라 [13:22](https://www.youtube.com/watch?v=0NE89Nzfk20&t=802s) "make sure you truly verify the test", 글 2의 「나델라도 배우는 검증, 일은 작게 나눠 에이전트에게 맡기고 결과는 테스트와 운영 로그로 본다」 단락 중 [참고]의 Cowork 팀 방식, 탠 [9:32](https://www.youtube.com/watch?v=MN9dGgmLyso&t=572s) 동어반복 테스트). 지금은 TDD 의 빨강을 구현 세션이 스스로 확인할 뿐이다(`start.md` 5단계, `end.md` 5단계).
4. **`design-reviewer` 쓰기 권한:** 권한을 지능과 떼고 에이전트를 내부자 위험으로 본다(나델라 [51:53](https://www.youtube.com/watch?v=0NE89Nzfk20&t=3113s), [52:01](https://www.youtube.com/watch?v=0NE89Nzfk20&t=3121s)). `design-reviewer`는 frontmatter 에 도구 제한이 없어 쓰기 금지가 문장뿐이다. 같은 성격의 `frontend-evaluator`는 이미 `disallowedTools`로 막는다.

008 과 겹치는 곳(묶지 않는다. 함께 돌리고 충돌은 머지 때 푼다):

- 008 이 고치는 곳: `start.md` 3단계 전문가 단계·6단계 AC 판정, `end.md` 3단계 리뷰 입력·4단계 판정을 작업 세션 밖으로·6단계 Final Summary, 리뷰 에이전트 5개의 첫 문장(`design-reviewer` 포함).
- 이 항목이 고치는 곳: `start.md` 4단계 포트, `end.md` 4단계의 선택지와 새 🟡 지적, `frontend-start-check`·`frontend-end-check`의 절차, `server-end-check` 1절의 설정 키·키 검사, `design-reviewer`의 frontmatter.
- 008 은 그대로 둔 지적을 원칙(글)으로 모은다. 2는 받아들여 고친 지적을 자동 검사로 올리는 것이라 다르다. 3은 008 AC #7 이 말하는 "바깥 증거"의 구체적인 수단 하나다.

가정: 어느 절차를 스크립트로 옮길지, 스크립트 이름·위치·언어, 되풀이를 무엇으로 알아볼지(`docs/done/`의 Final Summary 등), 테스트를 기준 브랜치 소스에 대고 돌리는 방법은 `/task start` 계획에서 정한다.

이번에 빼는 것: 항목 번호 세기(`create.md` 2단계. 제안함의 "항목 번호 겹침 막기"가 아직 "논의 필요"다). 보고서 3절 5~7(008 에 넣었다). `frontend-reviewer`·`api-reviewer`·`supabase-reviewer`의 `tools`(이미 Edit·Write 가 없고 Bash 는 008 이 쓴다). 자동 검사 규칙을 대신 써 주는 것(항목만 만든다).

참고 자료:

- Tan 영상: 「LIVE: Poteto (creator of pstack) on shipping 1,000's of PR's a month at SpaceX」, Matt Pocock 채널, Lauren Tan 출연 — https://www.youtube.com/watch?v=MN9dGgmLyso
- Nadella 영상: 「Software engineering after code becomes cheap with Satya Nadella」, The Pragmatic Engineer(Gergely Orosz 진행) — https://www.youtube.com/watch?v=0NE89Nzfk20
- 글 1: 「한 달 PR 2,500개 머지했다는 개발자는 왜 PR을 다 리뷰하지 않을까?」, 조쉬의 뉴스레터, Tan 영상을 Q&A 로 옮긴 글 — https://maily.so/josh/posts/xyowyd21z28
- 글 2: 「마이크로소프트 CEO 나델라, 코드는 싸졌지만 어려워진 건 검증이다」, 조쉬의 뉴스레터, Nadella 영상을 Q&A 로 옮긴 글 — https://maily.so/josh/posts/32z831mjon4

## Acceptance Criteria

<!-- AC:BEGIN -->

- [x] #1 빈 포트 고르기, 개발 서버를 그 포트로 띄우고 듣는지 확인하기, 추가된 줄의 `console.log`·`debugger`·`.only(`와 lockfile 검사가 스킬 폴더 안 스크립트로 있고, `start.md` 4단계와 `frontend-start-check`·`frontend-end-check`의 해당 자리에는 그 스크립트를 돌려 출력을 쓰라는 말만 남았다(`grep -rn 'lsof' plugins/ i18n/`이 비어 있다)
- [x] #8 `server-end-check`의 새 환경 변수가 `.env.example`에 없는지, 값 파일(`.env` 등)이 커밋됐는지, 키 패턴 검사가 스킬 폴더 안 스크립트로 있고 실패만 `파일:줄 — 이유`(키는 파일 이름만)로 출력한다. `server-end-check` 해당 자리에는 그 스크립트를 돌려 실패를 돌려준다는 말만 남았다. 이 스크립트도 #2 처럼 테스트가 있다
- [x] #2 #1 의 스크립트마다 `scripts/`에 테스트가 있고, `lsof`·`nc`가 없는 이 Windows(Git Bash)에서 통과한다. 포트를 확인할 방법이 없으면 스크립트가 그렇다고 출력하고 0 이 아닌 값으로 끝난다
- [x] #3 `end.md` 4단계에서, 받아들여 고칠 지적이 이전 항목의 Final Summary "리뷰에서 고친 것"에 같은 종류로 있거나 이번 리뷰에서 여러 곳에 나오면, 그 지적에 "린트 규칙·테스트·타입으로 막기(새 항목)" 선택지가 붙는다고 적혀 있다. 한 번뿐인 지적에는 붙지 않는다
- [x] #4 그 선택지를 고르면 `end.md` 5단계가 "나중"과 같이 `task` 스킬을 `create <지적과 근거, 막을 수단> --here`로 불러 항목을 만든다고 적혀 있다
- [x] #5 `/task end`가 이번 브랜치에서 더하거나 바꾼 테스트를 기준 브랜치의 소스에 대고 돌리고, 거기서도 통과하는 테스트를 🟡 "고친 것을 증명하지 못함"으로 지적 목록에 넣는다고 `end.md`에 적혀 있다. 그렇게 돌릴 수 없으면 "확인 못 함"으로 적고 넘어간다
- [x] #6 #5 의 확인이 #1 처럼 스크립트로 있고, 그 스크립트의 테스트가 "기준 브랜치에서도 통과하는 테스트"와 "기준 브랜치에서는 실패하는 테스트"를 구별하는 것을 보인다
- [x] #7 `plugins/frontend/agents/design-reviewer.md`와 번역본의 frontmatter 에 `disallowedTools: Edit, Write, NotebookEdit`이 있다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [x] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [x] #2 원문(`plugins/`)을 고친 곳은 번역본(`i18n/en/`)도 같이 고쳤다
- [x] #3 고친 플러그인마다 `plugin.json` `version`을 올렸고, README 두 개와 `marketplace.json` 설명을 맞췄다

<!-- DOD:END -->

## Implementation Plan

승인: 2026-11-24 (사용자 "진행", 부모 세션 경유)

### 1. 무엇을 하나
네 가지를 한다. 기계적인 절차 다섯 개(빈 포트 고르기, 개발 서버 띄우고 듣는지 확인, 프론트엔드 diff 검사, 서버 설정 키·키 검사, 새 테스트를 고치기 전 코드에 대고 돌리기)를 테스트가 있는 bash 스크립트로 옮긴다. `end.md`에 되풀이되는 지적을 "막기(새 항목)"로 올리는 선택지를 더한다. 기준 브랜치에서도 통과하는 테스트는 🟡 로 넣는다. `design-reviewer`에 `disallowedTools`를 단다.
이번에 빼는 것: 항목 파일의 "이번에 빼는 것" 그대로. eval 도 돌리지 않는다(6 참고).

### 2. 도구와 단계
- 분야: 셸 스크립트로 개발 도구 만들기. 도구는 bash(Git Bash·macOS·Linux 공통), git, 포트 확인용 bash `/dev/tcp`(없으면 `nc`), `timeout`.
- 단계: 스크립트마다 테스트를 먼저 쓴다. 테스트는 `scripts/test-*.sh`이고 기존 방식(임시 가짜 저장소, 시나리오, "N 개 중 N 개 맞음")을 따른다. 그다음 스크립트를 쓰고, 마크다운을 바꾸고, 번역본을 고친다.
- 설치할 것: 없음. 이 기계에서 확인한 것:
  - `lsof`·`nc`·`ss`·`jq`는 없다. `/dev/tcp`, `node`, `python`, `base64`, `timeout`, `netstat`은 있다.
  - Node 가 `localhost`를 `::1`에만 묶는 것을 확인했다. 그래서 127.0.0.1 만 보면 놓친다.
  - 백그라운드로 띄운 서버는 명령이 끝나도 산다.

### 3. 바꿀 파일과 순서 (각각 테스트 먼저)
1. **design-reviewer** (AC #7): 원문과 번역본 frontmatter 에 `disallowedTools: Edit, Write, NotebookEdit`.
2. **pick-port** (AC #1, #2)
   - `plugins/workflow/skills/task/scripts/pick-port.sh <기준 포트> <항목 번호>`를 만든다.
     - 후보는 기준 포트 + 번호다. 지금 듣는 포트, 다른 `w/*` 브랜치에서 진행 중인 항목의 `### 포트`와 그 기본 포트는 피하고 1씩 올린다.
     - 포트 확인은 `/dev/tcp`로 127.0.0.1 과 ::1 을 본다. 안 되면 `nc`를 쓴다.
     - 확인할 방법이 없으면 항목만 피한 포트와 "확인할 방법 없음"을 출력하고 2 로 끝난다.
   - 테스트: `scripts/test-pick-port.sh`. 시험용 서버는 node, 없으면 python.
   - 확인 방법 목록은 환경 변수 `PORT_CHECK_METHODS`로 바꿀 수 있다. 테스트가 "방법 없음"을 흉내 낼 때 쓴다.
   - `task` SKILL.md 1절에 "절차 파일의 `<task-scripts>`는 `${CLAUDE_SKILL_DIR}/scripts`" 한 줄을 넣는다.
   - `start.md` 4단계의 lsof·nc 문장을 "스크립트를 돌려 나온 포트를 쓰고, 0 이 아니면 이유를 알린다"로 바꾼다.
3. **dev-server** (AC #1, #2)
   - `plugins/frontend/skills/frontend-start-check/scripts/dev-server.sh <포트> [<명령…>]`를 만든다.
     - 포트를 이미 누가 쓰면 실패한다.
     - 명령을 받으면 로그 파일로 백그라운드에 띄우고 듣기를 기다린다(기본 60초). 성공하면 URL, PID, LOG, 끄는 명령을 출력한다. Windows 에서는 `/proc/<pid>/winpid`로 `taskkill //PID … //T //F`를 알려 준다.
     - 명령 없이 부르면 듣는지만 확인한다. launch.json·preview_start 로 띄웠을 때 쓴다.
     - 프로세스가 먼저 끝나면 로그 끝을 보이고 1 로 끝난다. 시간이 다 되면 끄고 1 로 끝난다. 확인할 방법이 없으면 2 로 끝난다.
   - 테스트: `scripts/test-dev-server.sh`.
   - `frontend-start-check` 1절과 `frontend-end-check` 3절의 긴 문단을 줄인다. 남는 것은 판단 부분(어느 포트, launch.json 은 안 고침, 명령이 포트를 받는 방식, 백엔드와 그 주소, 빌드 미리보기)과 "스크립트로 띄워 출력의 URL 을 쓴다"는 말이다. end-check 는 `${CLAUDE_SKILL_DIR}/../frontend-start-check/scripts/dev-server.sh`를 쓴다(같은 플러그인).
4. **diff-check** (AC #1, #2)
   - `plugins/frontend/skills/frontend-end-check/scripts/diff-check.sh <기준>`를 만든다.
     - `git diff -U0`의 추가된 줄에 `console.log`·`debugger`·`.only(`가 있으면 `파일:줄 — 이유`를 출력한다. `*.md`는 뺀다.
     - 바뀐 package.json 마다 의존성 필드를 node 로 기준과 비교한다. 바뀌었는데 그 폴더나 상위 폴더의 lockfile(npm·pnpm·yarn·bun)이 그대로면 실패다.
     - 실패만 출력하고 1 로 끝난다. node 가 없으면 lockfile 은 "확인 못 함"이다.
   - 테스트: `scripts/test-diff-check.sh`.
   - `frontend-end-check` 1절은 "스크립트를 돌려 나온 줄이 실패"와 reference 검사만 남긴다.
5. **config-check** (AC #8)
   - `plugins/server/skills/server-end-check/scripts/config-check.sh <기준>`를 만든다.
     - 추가된 줄에서 새로 읽는 환경 변수(Node·Vite·Deno·Bun·Python·Go·Rust·Java·Ruby·PHP 의 흔한 형태)가 추적하는 `.env.example`·`.env.sample`에 없으면 `파일:줄 — 이유`를 출력한다. `NODE_ENV`, `CI`는 뺀다.
     - 커밋된 값 파일은 기존 정규식 그대로 본다.
     - 키 검사 세 가지는 파일 이름만 출력한다:
       - `sb_secret_`
       - `eyJ` 토큰. 가운데 부분만 디코드해 role 이 anon 이 아니면 실패다.
       - 공개 접두사 환경 변수 이름에 SERVICE_ROLE·SECRET 이 들어 있으면 실패다.
     - 값은 출력하지 않는다.
   - 테스트: `scripts/test-config-check.sh`. 키가 출력에 나오지 않는 것도 확인한다.
   - `server-end-check`의 "설정 키"와 Supabase "키" 자리는 "스크립트를 돌려 나온 줄을 실패로"만 남긴다. 클라이언트 코드에서 service_role 을 쓰는지는 판단이라 `supabase-reviewer` 7번이 이미 본다.
6. **base-tests** (AC #5, #6)
   - `plugins/workflow/skills/task/scripts/base-tests.sh <기준> '<테스트 파일 하나를 돌리는 명령, 파일 자리에 {}>' [파일…]`를 만든다.
     - 작업 트리가 깨끗해야 한다.
     - 바뀐 파일을 이름 규칙(`*.test.*`, `*.spec.*`, `test_*.py`, `*_test.*`, `test-*.sh`, `tests/`·`__tests__/` 폴더)으로 테스트와 그 밖으로 나눈다.
     - 테스트를 HEAD 에서 먼저 돌린다. 실패하면 "HEAD 에서 실패"로 판단하지 않는다.
     - 그다음 테스트 밖 파일만 merge-base 판으로 되돌리고(브랜치에서 더한 파일은 잠시 지움) 다시 돌린다. 결과를 "기준에서도 통과" 또는 "기준에서 실패"로 출력한다.
     - 끝나면(중단돼도 trap 으로) HEAD 로 되돌리고 `git status`가 비었는지 확인한다.
     - 끝 값: 0 모두 기준에서 실패, 1 기준에서도 통과한 것 있음, 2 돌릴 수 없음.
     - 테스트만 바꾼 브랜치는 건너뛴다.
   - 테스트: `scripts/test-base-tests.sh`. 가짜 저장소에서 버그를 고친 브랜치에 "기준에서 실패하는 테스트"와 "기준에서도 통과하는 테스트"를 둬 둘을 구별하고, 원래대로 돌아오는지 본다.
   - `end.md` 2단계 끝에 넣는다. 스택 점검 뒤, 리뷰 전에 돌린다(파일을 잠시 바꾸니 리뷰어와 동시에 돌지 않게). 명령은 프로젝트 설정에서 정한다. "기준에서도 통과"는 판정 없이 🟡 "고친 것을 증명하지 못함"이 된다. 돌릴 수 없으면 "확인 못 함"으로 적는다.
7. **end.md 4·5단계** (AC #3, #4)
   - 판정 에이전트 지시에 하나를 더한다. 타당한 지적이 `docs/done/` Final Summary 의 "리뷰에서 고친 것"에 같은 종류로 있거나 이번 보고서에서 여러 곳에 나오면 🔁 와 근거를 붙인다.
   - 질문에 덧붙인다: 🔁 지적에만 "린트 규칙·테스트·타입으로 막기(새 항목)"를 더 고를 수 있다. 한 번뿐인 지적에는 붙지 않는다.
   - 5단계: "막기"를 고르면 "나중"과 같이 `task` 스킬을 `create <지적과 근거, 막을 수단> --here`로 부른다. 지적 자체는 고른 대로 고친다.
8. **번역본, version, 설명**
   - 고친 마크다운의 번역본 7개를 고친다.
   - version 을 올린다: workflow 0.11.0→0.12.0, frontend 0.8.0→0.9.0, server 0.5.0→0.6.0.
   - 설명에 스크립트 한 구절을 더한다. plugin.json·marketplace.json·README 두 개의 표와 구조 목록을 맞춘다.
   - 스크립트 머리에 "고치면 scripts/test-X.sh 를 돌린다"를 적는다.

### 4. 성공 기준
- AC #1: 세 스크립트가 있다. `grep -rn 'lsof' plugins/ i18n/`이 비어 있다. 스크립트도 lsof 를 쓰지 않는다.
- AC #2: 테스트 셋의 출력이 "N 개 중 N 개 맞음"이다. "확인할 방법 없음"이면 0 이 아닌 값으로 끝나는 시나리오도 들어 있다.
- AC #8: `test-config-check.sh`가 통과한다. server-end-check 를 grep 으로 확인한다.
- AC #6: `test-base-tests.sh`가 두 경우를 구별한다.
- AC #7: frontmatter 를 grep 으로 확인한다.
- AC #3·#4·#5: 문장이라 새 general-purpose 판정 에이전트가 판정한다(항목 경로와 diff 범위만 넘긴다).
- DoD: 검증 명령, check-repo-rules(번역본·version), README·marketplace grep.

### 5. 스택 점검
frontend, server 모두 해당 없음(`stack: 없음`).

### 6. 가정과 정한 것
- **스크립트 언어·위치:** bash 로 쓰고 쓰는 스킬 폴더의 `scripts/`에 둔다. 출력은 한국어다. 번역본은 마크다운만 만든다(스크립트는 하나).
- **lsof 를 쓰지 않음:** AC #1 의 grep 이 스크립트까지 덮는다. `/dev/tcp`는 macOS·Linux bash 에도 있고, `0.0.0.0`·`::`·localhost 에 묶은 서버를 다 찾는다.
- **pick-port 가 다른 `w/*` 브랜치를 읽음:** 다른 세션의 `In Progress`는 그 세션 브랜치에만 있어 기준 폴더의 `docs/backlog`에는 보이지 않는다(005 의 미룬 것). 그래서 브랜치의 항목 파일을 `git show`로 읽는다. 지금 문장대로는 실제로 피하지 못한다.
- **base-tests 를 제자리에서 돌림:** 임시 워크트리는 의존성 설치가 다시 필요하다. 그래서 제자리에서 테스트 밖 파일만 잠시 되돌리고, 리뷰어보다 먼저 돌려 동시 실행을 피한다.
  - 판단 단위는 테스트 파일이다. 한 파일 안의 테스트 하나는 가려내지 못한다.
  - 테스트가 소스 안에 있는 언어(Rust 등)는 가려내지 못해 "확인 못 함"이 된다.
- **되풀이 판단:** 판정 에이전트가 이미 보고서와 코드를 보니 같이 맡긴다.
- **eval 없음:** 바뀌는 것은 대부분 결정적인 스크립트이고, 테스트가 판정한다. `end.md`에 더한 문장을 잴 end eval 이 없다. 새로 만들면 실행마다 수 달러가 든다(008 의 사례는 하나에 $1~3). 예상 비용은 $0 이다. 원하면 따로 넣는다.
- **질문:** 없음. 위 가정을 바꾸고 싶으면 승인 때 말하면 된다.

## Implementation Notes

### Baseline

- `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과. `scripts/test-check-repo-rules.sh` 30/30, `scripts/test-verify-on-stop.sh` 11/11.

### 포트

없음(CLAUDE.md 에 웹·서버 포트 설정 없음).

### 계획에서 바뀐 것

- **포트 확인에 netstat 을 먼저 쓴다:** 정리 리뷰가 이 기계에서 쟀다. 닫힌 포트에 bash `/dev/tcp`로 붙으면 2초쯤 걸리고(Windows 가 루프백 연결을 다시 시도한다), dev-server 의 60초 제한이 실제로는 10분 가까이 됐다.
  - 확인 방법은 `netstat -an` 한 번(0.17초)을 먼저 쓰고, 없으면 `/dev/tcp`(두 주소에 함께), 그다음 `nc`를 쓴다.
  - netstat 의 상태 낱말(LISTEN)은 언어마다 달라 보지 않는다. 상대 주소가 빈 TCP 줄(`0.0.0.0:0`, `[::]:0`, `*.*`, `:::*` 등)을 듣는 줄로 본다.
  - `/dev/tcp` 지원 여부는 `LC_ALL=C` 오류 문구로 본다.
  - 대기 시간은 `SECONDS` 마감 시각으로 잰다.
- **base-tests 는 git 대신 떠 둔 사본으로 되돌린다:** 이 기계는 `core.autocrlf=true`다. `git checkout HEAD -- 파일`이 LF 파일을 CRLF 로 다시 써서, 테스트가 "작업 트리가 달라졌다"를 잡았다. 기준 판으로 바꿀 때는 `git restore --source=<기준> --worktree`로 인덱스를 건드리지 않는다.
- **dev-server 의 끄기 명령은 쓸 때 정한다:** Git Bash 에서는 `exec`가 같은 PID 로 새 Windows 프로세스를 띄워 winpid 가 바뀐다. 띄울 때 한 번만 정하면 `exec`하는 명령이 꺼지지 않는다(테스트 7이 잡았다).
- **config-check:** 추가된 줄은 awk 한 번으로 본다.
  - 6천 줄 diff 기준 20초에서 3초로 줄었다.
  - `sb_secret_`는 뒤에 키 문자가 10개 넘게 이어질 때만 키로 본다(낱말만 적은 문서는 걸리지 않게).
- **diff-check:** "확인 못 함"(node 없음)은 표준 오류로 보낸다. 표준 출력에는 실패만 남는다.
- **frontend-end-check 의 개발 서버 문단:** frontend-start-check 의 그 항목을 읽고 따르게 했다. 같은 문단이 원문·번역본 4곳에 있던 것을 2곳으로 줄였다.
- **eval:** 계획대로 돌리지 않았다(비용 $0).

### 정리 (simplify)

재사용·단순화·효율·깊이 네 에이전트의 지적 중 고친 것: 위 "계획에서 바뀐 것"의 netstat·SECONDS·git restore·awk 한 번·stderr·문단 한 곳, pick-port 의 항목 읽기를 awk 한 번으로, end.md 나중·막기 줄 합치기, server-end-check 제목, start.md 문장 줄이기, 같은 사례 13번을 1번으로, 죽은 변수·정규식 갈래.

건너뛴 것:
- 테스트 하네스를 공용 파일로 합치기: 기존 test-* 도 파일마다 둔다.
- 플러그인 사이에 `port_open` 합치기: 플러그인은 따로 설치된다. 두 곳 주석에 "같은 함수, 고치면 둘 다"를 적었다.
- 끄기 명령을 한 번만 정하기: 위 winpid 이유.
- JSON 을 인자로 넘기기: Git Bash 가 `/`로 시작하는 인자를 경로로 바꿀 수 있다.
- 새 테스트를 검증 명령에 넣기와 두 `port_open`이 같은지 검사하기: 이 항목 밖이다(아래 제안).

### 확인 (바깥 증거)

이 Windows(Git Bash, `lsof`·`nc` 없음)에서 새로 돌린 출력:

```
test-pick-port: 15 개 중 15 개 맞음
test-dev-server: 9 개 중 9 개 맞음
test-diff-check: 15 개 중 15 개 맞음
test-config-check: 17 개 중 17 개 맞음
test-base-tests: 12 개 중 12 개 맞음
test-check-repo-rules: 30 개 중 30 개 맞음
test-verify-on-stop: 11 개 중 11 개 맞음
claude plugin validate . && bash scripts/check-repo-rules.sh → ✔ Validation passed, 저장소 규칙 검사 통과
grep -rn 'lsof' plugins/ i18n/ → 없음
```

- 테스트마다 스크립트를 망가뜨려 테스트가 잡는지 봤다.
  - pick-port: 포트 칸 밖의 숫자까지 읽게 바꿨더니 1건 틀림.
  - base-tests: 기준 판으로 되돌리지 않게 바꿨더니 5건 틀림.
- dev-server 테스트 뒤에 남은 서버는 없었다(`netstat`).
- AC #3·#4·#5 와 나머지는 구현하지 않은 general-purpose 판정 에이전트가 판정했다. 항목 경로와 `git diff main...HEAD` 범위만 넘겼고, 판정은 AC #1~#8, DoD #1~#3 모두 통과다.
  - 판정이 짚은 두 문장(end.md 의 `HEAD 에서 실패` 처리, server-end-check 의 끝 값 2)은 고쳤다.

### 알아 둘 것

- 이 저장소에서 `diff-check.sh`·`config-check.sh`를 돌리면 스크립트와 테스트 안의 패턴 문자열(`console.log`, `sb_secret_…`)이 걸린다. 패턴 검사라 생기는 오탐이다. 이 저장소는 `stack: 없음`이라 점검이 돌지 않는다.
- 새 테스트는 한 번에 1분 안팎이다(Windows 의 프로세스 비용). 검증 명령에는 넣지 않았다.
- 제안(새 항목 후보):
  - 검증 명령이나 check-repo-rules 가 `scripts/test-*.sh`를 돌린다(바뀐 스크립트의 테스트만이라도).
  - 두 `port_open` 본문이 같은지 검사한다.

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것.
