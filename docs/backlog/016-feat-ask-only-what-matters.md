---
id: '016'
title: 사람에게 묻는 곳을 꼭 필요한 것만 남긴다 — 계획 승인과 superpowers 를 떼고, start 와 end 를 합치고, pstack 원칙을 가져온다
status: In Progress
labels: [feat]
priority: high
dependencies: []
created_date: 2026-11-26
updated_date: 2026-11-26
---

## Description

### 왜

`/task`가 너무 자주 멈추고 묻는다. 실제 대화 기록에서 세어 보면 항목 하나를 create → start → end 로 끝내는 동안 평균 7.8번 멈춘다(5~15번). 이 항목의 규칙을 적용하면 약 3.4번(2~5번)으로 준다.

가장 많이 줄어드는 곳은 셋이다.
- **계획 승인:** 다른 프로젝트에서 17번 물었고, 사용자가 그 자리에서 계획을 바꾼 적은 0번이다. 대부분 1~2분 안에 그대로 승인했다.
- **end 리뷰 지적 질문:** 사용자가 가장 많이 뒤집은 곳이다. "나중 항목으로 미루자"는 추천을 거절하고 지금 고치라고 한 것이 5번이다. 그러니 타당한 지적은 묻지 말고 고치면 된다.
- **superpowers 스킬의 숨은 질문:** `/task`가 부르는 superpowers 스킬이 각자 따로 묻는다. superpowers 는 떼고, 필요한 규칙만 `/task`에 직접 적는다.

### 묻는 기준

다음 다섯 가지만 묻는다.
1. 되돌릴 수 없거나 밖으로 나가는 일: 머지, 기준 브랜치·배포 브랜치로 푸시, 삭제, 원격 DB, 배포. 그 밖의 브랜치(작업 브랜치)는 묻지 않고 푸시한다
2. 프로젝트 밖이나 공유 설정을 바꾸는 일: 플러그인 설치, CLAUDE.md
3. 코드나 실행으로 정할 수 없는 제품·취향 결정
4. 무엇을 할지 고르기
5. 작업을 잃을 수 있는 상태

그 밖은 묻지 않는다. Claude 가 정하고, 정한 것과 왜 그렇게 정했는지를 항목 파일에 적으면서 진행한다. 정한 것은 마지막 메시지에서 추천·근거·위험과 함께 한 번에 보인다.

### 사용자가 정한 것 (2026-11-26)

- **계획 승인(플랜 모드)을 받지 않는다.** 사용자의 말: "구현은 금방 하고, 초기에 중요한 설계 부분은 다 질문하게 해 놨거나 미리 말한다."
  - 012 에서 정한 "하위 세션도 공식 플랜 모드로 계획 승인"(`docs/done/012-chore-official-skills-narrow-stack.md:72-77`)을 뒤집는다.
  - j-dev-kit 004·008·010·012 에서는 계획 승인 때 AC 가 바뀐 적이 있다. 그 일은 이제 AC 승인과 착수 전 질문이 맡는다.
- **start 와 end 를 합친다.** start 하나가 구현, 검증, 리뷰, 지적 고치기, 머지 질문까지 한다. `end` 모드는 없다. 그래서 "end 를 진행할까요?"도, 사용자가 end 명령을 치는 일도 없다.
- **`task` 스킬을 둘로 나눈다.** 항목을 만드는 일은 `backlog` 스킬(`/backlog`), 항목을 구현해 머지까지 가는 일은 `start` 스킬(`/start`)이다. `task` 스킬과 `/task create`·`/task start`는 없앤다.
- **AC 승인은 남긴다.** 계획 승인이 없어지면 구현 전에 사람이 확인하는 유일한 계약이다.
- **superpowers 를 쓰지 않는다.** 플러그인 의존성에서 빼고, `/task`가 부르던 다섯 스킬(brainstorming, test-driven-development, verification-before-completion, receiving-code-review, finishing-a-development-branch)에서 필요한 규칙만 `/task` 절차에 직접 적는다.
- **pstack 에서 가져올 것은 다 가져오고, pstack 처럼 자연스럽게 쓰이게 한다.** pstack(`cursor/plugins`의 `pstack/`, MIT, Lauren Tan)은 진입 스킬 하나에 "언제 → 무엇" 색인을 두고, 본문은 파일 하나씩 따로 두었다가 쓸 때 읽는다. 우리도 같은 모양으로 한다. 단계마다 녹여 넣지 않는다. 가져오는 것은 원칙 24개, 스킬 10개(architect, figure-it-out, blast-radius, how, why, benchmark-checklist, 검증 스킬 만들기·유지하기, unslop, technical-writing), 플레이북 6개(Feature, Bug fix, Refactoring, Prototype, Perf issue, Hillclimb), 일하는 방식 세 줄, 테스트 규칙이다. pstack 이 기대어 쓰는 cursor-team-kit(`cursor/plugins`의 `cursor-team-kit/`, MIT, Cursor)에서도 가져온다: control-ui, control-cli, deslop, verify-this, fix-merge-conflicts. 앞의 셋은 pstack 이 직접 부르는 것이다.
- **정리는 pstack 처럼 deslop 으로 한다.** 커밋 전에 deslop 을 돌려 이 브랜치가 넣은 군더더기를 묻지 않고 바로 고친다. 동작은 바꾸지 않는다. simplify 를 돌릴지, 무엇을 고칠지 묻던 두 질문(11-25, `fa91c89`)은 없앤다.

### 근거

- `docs/backlog/references/2026-11-26-016-추가-조사.md`: 실제 멈춤 횟수, `/until-done`이 안 쓰인 이유, superpowers 의 숨은 질문, 플랜 모드 없이 편집 막기와 승인 중계. 노트와 다시 세는 스크립트는 `research_notes/2026-11-26-016-추가-조사/`
- `docs/backlog/references/2026-11-26-pstack-분석과-차용.md`: pstack 과의 비교. 7절이 에이전트 검증 뒤 고친 판단. 노트는 `research_notes/2026-11-26-pstack-분석과-차용/`
- `docs/backlog/references/2026-11-26-코딩-에이전트-실무자-워크플로.md`: 바깥 실무자·도구 팀 워크플로 약 40개 비교. 노트는 `research_notes/2026-11-26-코딩-에이전트-실무자-워크플로/`
- `docs/backlog/references/2026-11-26-질문-줄이기-비교.html`: 단계별 지금 / 바꾼 뒤 비교 페이지
- `docs/backlog/references/2026-11-26-016-인수인계.md`: 다른 컴퓨터에서 이어 하기 위한 문서

### 이번에 빼는 것

- 진입 모드 스킬(`/poteto-mode` 같은 것). 004 의 `/until-done`이 같은 일을 하다가 한 번도 쓰이지 않고 006 에서 지워졌다. 이 항목을 써 본 뒤 따로 정한다. 만든다면 이 항목과 같은 기준을 따른다: 꼭 필요한 것만 묻고, 나머지는 정한 것과 이유를 적으면서 알아서 한다.
- pstack 의 나머지. 이유는 추가 조사 보고서의 "가져오지 않는 것" 표에 있다
  - PR·Cursor 클라우드 중심 플레이북(Opening a PR, Babysit, Shipping, Autopilot 둘)과 `/task` 밖의 일을 다루는 플레이북(Investigation, Autonomous run, Session pickup, Pause safely 등). 뒤의 것은 진입 모드 스킬을 정할 때 함께 본다
  - 다른 회사 모델 패널이 핵심인 스킬(arena, swarm, interrogate), no-comments, Cursor 전용 스킬
  - cursor-team-kit 의 PR·CI 스킬(fix-ci, loop-on-ci, review-and-ship, pr-review-canvas 등), 주간 요약 스킬, thermo-nuclear 리뷰
- 다른 플러그인의 리뷰어 에이전트 본문
- 사용자 컴퓨터에서 superpowers 플러그인을 지우는 일(사용자가 한다)

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 묻는 기준 다섯 가지가 `start` SKILL.md "일하는 원칙" 한 곳에 있고, `backlog` 스킬과 각 절차의 질문 지점은 이 기준을 가리킨다. 기준 밖의 것은 정하고 항목 파일에 `정한 것 — 이유 — 틀렸을 때 비용`으로 적는다. 돌려 보면 정해지는 갈림길(구조, 라이브러리, 접근)은 묻지 않고 돌려 보고 정한 뒤 결과와 근거를 적는다. "다음 단계로 갈까요?" 같은 질문은 하지 않는다
- [ ] #2 `start`에 플랜 모드와 계획 승인 대기가 없다(`grep -rn 'EnterPlanMode\|ExitPlanMode' plugins i18n` 결과 없음). 대신 이렇게 한다
  - 첫 메시지에서 목표와 가장 작은 변경을 되짚고 진행한다. 항목을 읽다가 AC 끼리 모순되거나 사람만 정할 결정이 빠져 있으면 착수 전 질문에 넣는다
  - 착수 전 질문은 있을 때만 한 번에 묻는다
  - 계획과 정한 것은 항목 파일에 적고 기다리지 않는다. 사용자가 "계획을 보자"고 하면 보여 주고 기다린다
- [ ] #3 `start`의 "범위가 커지면 멈춘다"가 확인할 수 있는 목록이다: AC 밖 동작, 새 의존성·도구 설치, 스키마·공개 API·삭제, CLAUDE.md·설정 변경
- [ ] #4 `backlog`는 AC 전문을 보여 주고 승인받는다. 서베이 모드는 후보 표에 AC 초안을 넣어, 고르기 한 번으로 항목을 쓰고 다시 승인받지 않는다
- [ ] #5 커밋 전에 deslop 을 돌린다. 묻지 않고 바로 고치고, 동작은 바꾸지 않는다. 고친 것을 한 줄로 적는다. simplify 를 돌릴지와 무엇을 고칠지 묻던 질문은 없다
- [ ] #6 리뷰 판정에서 타당한 🔴·🟡 는 묻지 않고 고친 뒤 알린다. 남은 질문(AC·정한 것과 부딪히는 지적, "나중" 후보, 머지 방식)은 한 메시지로 추천·근거·위험과 함께 묻는다. 그 메시지 첫 줄에 사용자를 기다리는 것이 무엇인지 쓰고, Claude 가 스스로 할 수 있는 일은 질문으로 올리지 않는다. 쉬운 말과 짧은 문장으로 쓰고, 해시·경로·명령은 사용자가 행동하는 데 필요할 때만 넣는다. "막기" 선택지는 없다
- [ ] #7 `docs/review-principles.md`의 "승인된 계획·AC 가 정한 것은 사용자가 정한 것" 원칙이 "AC 와 사용자가 답한 것"으로 좁혀져 있다. Claude 가 정한 것은 리뷰 대상이다. `plugins`·`i18n`·`docs/backlog/_template.md`에 "승인된 계획" 문구가 없다
- [ ] #8 하위 세션 지시문(`backlog`·`start` SKILL.md)에 플랜 모드 승인 문장이 없고, 하위 세션도 #1 기준을 따른다. 부모 세션이 계획 승인을 기다리는 문장이 없다
- [ ] #9 superpowers 를 뗀다
  - `grep -rn superpowers plugins i18n .claude-plugin .claude/settings.json` 결과가 없다(`plugin.json`·`marketplace.json` 의존성 포함)
  - 부르던 다섯 스킬에서 필요한 규칙을 절차에 직접 적었다: 테스트 규칙(싸고 분명한 테스트 길이 있으면 실패하는 테스트를 먼저 쓴다. 없으면 억지로 쓰지 않고 가장 가까운 실행 확인을 쓰고 그 이유를 적는다. 나쁜 테스트보다 테스트 없음이 낫다 — pstack `tdd`), 끝났다고 말하기 전에 검증 명령을 다시 돌려 출력 보이기, 리뷰 지적은 코드에서 확인하고 틀린 지적은 이유를 대고 고치지 않기, 질문 규칙(이유 먼저, 절차 질문 안 함, 선택지에 추천, 한 번에 최대 3개), 머지한 뒤 검증 명령 다시 돌리기, 기준 브랜치·배포 브랜치에는 강제 푸시하지 않기
  - README 두 개의 superpowers 안내와 저장소 CLAUDE.md 의 superpowers 절을 정리했다
- [ ] #10 frontend·server 점검과 ui-design 의 질문이 #1 기준을 따른다
  - 시안 수는 기본 3개이고 방향 표는 보여 주기만 한다. 캔버스에서 고르기는 남긴다
  - ui-design 의 쓰기·커밋 승인은 한 번으로 줄이고, `@DESIGN.md` 줄 추가는 묻는다
  - 로컬 Supabase 스택은 켜고 알린다
  - 공식 스킬 설치는 프로젝트당 한 번, 착수 전 질문에 합친다
  - 브라우저 도구가 없으면 멈추지 않고 "확인 못 함"으로 적고 계속한다
- [ ] #11 멈춘 횟수가 기준선보다 적다. 기준선은 기록에서 센 평균 7.8번이다(`research_notes/2026-11-26-016-추가-조사/stop-count.md`). 바꾼 판을 같은 실제 사례로 돌려 같은 방법으로 센다. 멈춘 횟수와 함께 사용자가 나중에 바로잡은 횟수도 센다. 기존 eval 사례(`start-plan` 등)는 새 규칙에 맞게 고쳤다. 결과와 다시 돌리는 명령이 Implementation Notes 에 있다
- [ ] #12 `task` 스킬이 `backlog`와 `start` 두 스킬로 나뉘어 있다. `backlog`(`/backlog`)는 항목을 만들고 `--survey`도 받는다. `start`(`/start`)는 구현 → 검증 → 리뷰 → 지적 고치기 → 마지막 메시지(머지 방식 등) → 머지까지 멈추지 않고 간다. `task` 스킬, `end` 모드, `references/end.md`는 없다. `grep -rnE '/task |task end|skills/task' plugins i18n scripts README.md README.en.md docs/backlog/README.md docs/backlog/_template.md` 결과가 없다
- [ ] #13 pstack 에서 가져온 것이 pstack 과 같은 모양으로 들어 있다: 색인 하나와 본문 파일들
  - `start` SKILL.md 에 색인이 한 곳에 있다. 모양은 pstack `poteto-mode/SKILL.md`의 Non-negotiables·Principles·Playbooks 를 따른다: 한 줄에 "언제 → 무엇"
  - 본문은 pstack 과 같은 자리에 있다: 스킬과 원칙은 각자 스킬 폴더(`skills/<이름>/SKILL.md`, 원칙은 `skills/principle-<이름>/SKILL.md`)이고 `disable-model-invocation: true`라 스스로 뜨지 않는다. 사용자는 `/architect`처럼 직접 부를 수 있다. 플레이북은 `skills/start/playbooks/<이름>.md`다. 색인이 가리킬 때 읽고 따르고, 절차 파일에 본문을 옮겨 적지 않는다
  - 원칙 24개: 이름, 언제 쓰는지, 본문
  - 스킬 5개: architect(함수 경계를 넘는 변경이면 구조안 두 개를 그려 고른다), blast-radius(믿기 어려운 diff 는 머지 전에 diff 밖 영향을 실행으로 확인한다), how·why(고치기 전에 코드가 어떻게, 왜 그렇게 됐는지 읽는다), benchmark-checklist(잰 숫자를 보고하기 전에 점검한다)
  - 검증 스킬 2개: create-verification-skill(프로젝트에 앱을 실제로 몰아 확인할 정해진 방법이 없으면, 띄우기·점검·몰기·증거·정리와 기능 지도를 프로젝트 스킬로 만든다. 만들지는 프로젝트당 한 번 착수 전 질문에 넣는다), maintain-verification-skill(기능 지도가 앱과 어긋나면 고친다). 지도가 있으면 화면 확인과 AC 판정이 그것을 따른다
  - cursor-team-kit 5개: control-ui(화면을 몰 때: 스냅샷 → 동작 하나 → 스냅샷 → 확인), control-cli(CLI·TUI 를 tmux·PTY 로 몰 때), verify-this(고쳤다는 주장은 전후를 같은 조건으로 재서 VERIFIED / NOT VERIFIED / INCONCLUSIVE 중 하나로 답한다), fix-merge-conflicts(머지 충돌), deslop(커밋 전에 이 브랜치가 넣은 군더더기를 지운다: 쓸데없는 주석, 믿는 경로의 방어 코드, `any` 캐스트, 깊은 중첩)
  - 글쓰기 2개: unslop(답을 포함한 모든 글에서 AI 티가 나는 표현을 뺀다), technical-writing(문서, 항목 파일, 커밋 메시지는 한 번 읽고 이해되게 쓴다). 영어 낱말 목록 같은 규칙은 한국어에서 같은 구실을 하는 표현으로 옮긴다
  - 플레이북 6개: Feature(새 동작을 더한다. 설계하고, 맡기고, 실제 화면에서 검증한다), Bug fix(재현 먼저, 원인을 증거로 좁힌다), Refactoring(동작을 먼저 고정하고 구조만 바꾼다), Prototype(갈림길은 버릴 시제품으로 정한다), Perf issue(먼저 잰다), Hillclimb(한 번에 하나 바꾸고 잰다). `start`는 항목의 성격에 맞는 플레이북을 골라 그 단계를 할 일 목록에 옮긴다. 맞는 것이 없거나 크고 여러 갈래에 걸친 일이면 figure-it-out 스킬로 그 일에 맞는 단계를 짠다
  - 이미 있는 같은 규칙은 한 곳에만 둔다: Never Block on the Human 은 #1 의 묻는 기준과, Prove It Works 는 "검증을 새로 돌리고 결과를 보여 준다"와, Laziness Protocol 은 "항목이 요구하는 것만 한다"와 합친다
  - 정한 것 줄의 이유에 적용한 원칙·스킬 이름을 적는다
  - Cursor 이름(Task, AskQuestion, control-ui, `/loop`, 모델 슬러그, 다른 회사 모델)은 Claude Code 의 것으로 바꾸거나 뺀다. 가져온 파일마다 원문 위치를 적고, pstack 과 cursor-team-kit 의 MIT 저작권·허가 고지를 플러그인에 둔다
  - README 두 개의 출처에 pstack 과 cursor-team-kit 을 적는다
- [ ] #14 `start` SKILL.md "일하는 원칙"에 세 줄이 있다: 아니라고 말해도 된다(범위를 넓히자는 제안이 값을 못 하면 그렇게 말한다), 스스로 돌릴 수 있는 확인을 사람에게 넘기지 않는다, 주장마다 근거를 달거나 확인함·추론·추측 중 무엇인지 표시한다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 번역본(`i18n/en/`)을 원문과 같이 고쳤다
- [ ] #3 바꾼 플러그인의 `plugin.json` `version`을 올렸고 README 두 개와 `marketplace.json` 설명을 맞췄다

<!-- DOD:END -->

## Implementation Plan

사용자가 정한 대로 계획 승인을 받지 않고 진행한다(2026-11-26). 하위 세션 없이 이 세션에서 한다(사용자: "여기서 작업해").

**목표:** `/task`가 꼭 필요한 것만 묻게 하고, 계획 승인과 superpowers 를 떼고, start 와 end 를 합치고, pstack·cursor-team-kit 에서 가져올 것을 색인과 본문 파일로 들인다.

**단계**

1. 본문 파일 가져오기 (하위 에이전트 셋이 나눠 쓴다. 한국어 원문과 `i18n/en/` 번역본을 함께)
   - `plugins/workflow/skills/principle-<이름>/SKILL.md` 24개
   - `plugins/workflow/skills/<이름>/SKILL.md` 15개: figure-it-out, architect, blast-radius, how, why, benchmark-checklist, create-verification-skill, maintain-verification-skill, unslop, technical-writing, control-ui, control-cli, deslop, verify-this, fix-merge-conflicts. 기능 지도 예시 3개는 `create-verification-skill/references/feature-map-example/`
   - `plugins/workflow/skills/start/playbooks/<이름>.md` 6개: feature, bug-fix, refactoring, prototype, perf-issue, hillclimb
   - `plugins/workflow/THIRD_PARTY_NOTICES.md`: pstack 과 cursor-team-kit 의 MIT 고지
   - Cursor 이름은 Claude Code 것으로 바꾸고, 가져오지 않은 스킬을 가리키는 줄은 빼거나 풀어 쓴다
2. `start` 스킬 만들기(`plugins/workflow/skills/start/`): SKILL.md 에 묻는 기준 다섯, 정한 것 줄 형식, 일하는 방식 세 줄, 색인(꼭 지킬 것, 원칙 24, 플레이북 5), 어디서 하나와 하위 세션 지시문. 절차는 `references/procedure.md`: 플랜 모드 없이 되짚기 → 플레이북 고르기 → 착수 전 질문(있을 때만) → 구현 → deslop → 검증 → AC 판정 → 리뷰 → 타당한 지적 고치기 → 마지막 메시지 하나 → 항목 닫기 → 머지. 스크립트 둘(`base-tests.sh`, `pick-port.sh`)은 `skills/start/scripts/`로 옮기고 `check-repo-rules.sh`와 짝 테스트의 경로를 맞춘다
3. `backlog` 스킬 만들기(`plugins/workflow/skills/backlog/`): 지금의 `create.md`에서 brainstorming 호출을 질문 규칙으로 바꾸고, AC 전문 승인, 서베이 후보 표에 AC 초안
4. `task` 스킬 폴더(`SKILL.md`, `create.md`, `start.md`, `end.md`)를 지운다
5. superpowers 떼기: `plugin.json`·`marketplace.json` 의존성, `.claude/settings.json`, README 두 개, 저장소 CLAUDE.md
6. `docs/review-principles.md`, `docs/backlog/README.md`·`_template.md` 문구
7. frontend·server·ui-design 의 질문 지점(AC #10)과 "end 모드" 문구
8. 번역본, `plugin.json` version(workflow 0.17.0, frontend 0.12.0, server 0.8.0), README 두 개, `marketplace.json` 설명
9. eval 사례를 새 규칙에 맞게 고치고, 멈춘 횟수를 잰다(AC #11)

**확인 방법:** AC #2·#9·#12 는 grep, #1·#3~#8·#10·#13·#14 는 구현 세션이 아닌 판정 에이전트, #11 은 eval 실행 결과. DoD 는 검증 명령.

**정한 것** (정한 것 — 이유 — 틀렸을 때 비용)

- 스킬과 원칙은 pstack 처럼 각자 스킬 폴더로 두고(`disable-model-invocation: true`), 플레이북은 `start/playbooks/`에, 색인은 `start` SKILL.md 에 둔다 — 처음에는 전부 `start/references/` 아래 참고 파일로 넣었는데 사용자가 pstack 과 다르다고 짚었다. pstack 모양이면 `/architect`, `/deslop`을 직접 부를 수 있다 — 슬래시 메뉴에 스킬 38개가 더 보인다
- `start` SKILL.md 는 원칙과 색인만 두고 절차는 `references/procedure.md`에 둔다 — SKILL.md 가 길면 대화가 압축될 때 뒤가 잘릴 수 있다(superpowers #2481) — 파일을 하나 더 읽는다
- 번역본(`i18n/en/`)은 pstack·team-kit 원문을 바탕으로 같은 고침만 적용한다 — 원문이 영어다 — 없음
- `frontend-end-check`·`server-end-check` 스킬 이름은 그대로 둔다 — README 가 새 스택에 이 이름 규칙을 쓰게 한다. 이름을 바꾸면 쓰는 프로젝트가 깨진다 — 이름이 "end 모드"를 떠올리게 한다
- 이 저장소는 마크다운과 셸뿐이라 테스트 먼저 쓰기는 스크립트를 고칠 때만 해당한다. 문서 변경은 grep 과 판정 에이전트로 확인한다 (Prove It Works)

## Implementation Notes

### Baseline

- `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과(2026-11-26, main `2c90103`). 이미 실패하는 것 없음.
- 스택 점검: frontend·server 모두 "해당 없음"(CLAUDE.md `stack: 없음`).

### 정한 것

- 스크립트 둘을 `skills/start/scripts/`로 옮기면서 짝 테스트가 검증에 걸렸는데, 이 맥에서는 변경 전(main)에도 실패했다. 테스트와 스크립트를 최소로 고쳤다 — 검증 명령이 통과해야 항목을 닫을 수 있다(Prove It Works) — 016 의 범위 밖 수정 셋이 들어갔다
  - `scripts/test-check-repo-rules.sh`: `sed -i`가 BSD sed(macOS)에서 돌지 않아 두 sed 모두에서 도는 함수로 감쌌다. 44개 중 15개 → 44개 통과
  - `pick-port.sh`·`dev-server.sh`의 `port_open`: 이 맥에서 bash 로 돌린 `netstat -an`은 TCP 줄을 하나도 보여 주지 않는데 출력에 "tcp"라는 글자는 있어(`com.apple.network.tcp_ccdebug`), 듣는 포트를 "없음"으로 판정했다. TCP 줄이 없으면 다음 방법(`/dev/tcp`)으로 넘어가게 고쳤다(Fix Root Causes). 쓰는 중인 포트를 못 피하던 실제 버그다
  - `scripts/test-pick-port.sh`: 이 기계에서 흉내 낼 수 없는 두 경우(netstat 만 쓰기, `nc`가 `git`·`head`와 같은 폴더에 있을 때의 "nc 없음")는 건너뛰고 그렇다고 출력한다
- 번역본의 `> Source:` 줄 문구를 43개 파일에서 하나로 맞췄다 — 한 가지를 한 이름으로(unslop 11) — 없음
- eval 트리거 사례의 채점은 어느 스킬을 불렀는지까지 본다(`(:|")start"`, `(:|")backlog"`) — 스킬이 둘로 나뉘어 "불렀다"만으로는 맞는 스킬인지 모른다 — 러너가 Skill 입력을 다른 모양으로 적으면 정규식을 고쳐야 한다
- README 에 "superpowers 는 쓰지 않는다. 켜져 있으면 끈다"와 문제 해결 줄을 남겼다 — 예전 안내대로 CLAUDE.md 문단을 넣어 둔 사용자가 있다. AC #9 의 grep 범위(plugins, i18n, 매니페스트, 설정)에는 들지 않는다 — README 에 superpowers 라는 말이 남는다

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것, 그대로 둔 지적과 이유, 사용자가 바로잡은 것.
