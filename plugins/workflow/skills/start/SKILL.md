---
name: start
description: 일을 구현해 머지까지 갈 때 쓴다. 사용자가 백로그 항목을 시작하거나 구현하자고 하면, 또는 작업 브랜치를 이어 가거나 리뷰하고 마무리하거나 머지하자고 하면 부른다. 사용자가 /start 뒤에 할 일을 적으면 항목 없이 바로 한다. 계획, 구현, 검증, 리뷰, 지적 고치기, 머지까지 한 번에 가고, 꼭 필요한 것만 묻는다. 항목을 새로 만드는 일은 backlog 스킬이 한다. 사용자가 /start 를 치지 않았고 항목·브랜치 이야기도 없이 바로 고쳐 달라는 요청에는 스스로 부르지 않는다.
argument-hint: "[백로그 번호나 이름 일부 | 할 일 한두 문장] [--here]"
allowed-tools: Bash(git status *), Bash(git branch --show-current), Bash(git branch --list *), Bash(git log *), Bash(git diff *), Bash(ls *)
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# start

인자: `$ARGUMENTS`

백로그 항목 하나, 또는 사용자가 바로 적어 준 일 하나를 구현해 머지까지 간다. 절차는 `${CLAUDE_SKILL_DIR}/references/procedure.md`에 있다. 아래에서 어디서 할지 정한 뒤, 이 세션에서 하게 되면 그 파일을 Read 도구로 끝까지 읽고 그대로 따른다. 절차 파일의 `<scripts>`는 `${CLAUDE_SKILL_DIR}/scripts`, `<ref>`는 `${CLAUDE_SKILL_DIR}/references`다.

## 1. 어디서 하나

- **지금 브랜치가 `w/`로 시작하면:** 이미 작업 중인 세션이다. 세션을 띄우지 않고 이 세션에서 절차를 따른다. 인자가 없거나 "리뷰하고 머지해" 같은 말이어도 그 브랜치의 항목을 이어 간다(절차의 "이어 가기"). 항목 파일이 없는 브랜치면 항목 없이 하던 일을 이어 간다. 인자가 그 항목과 상관없는 새 일이면 절차 "항목 없이 할 때"의 브랜치 규칙을 따른다.
- **인자가 백로그 항목이 아니라 할 일이면:** 항목을 만들지 않고 이 세션에서 바로 한다(절차의 "항목 없이 할 때"). 인자를 `docs/backlog/`와 `docs/done/`에서 찾아 번호나 이름이 맞는 항목이 없으면 할 일로 본다. 여러 모듈에 걸치거나 며칠 걸릴 일이면 `/backlog`로 항목을 만드는 편이 낫다고 한 줄 말하고, 그대로 진행한다.
- **인자에 `--here`가 있으면:** 떼어 내고 이 세션에서 한다.
- **그 밖:** 하위 세션을 띄운다.
  1. 사용자가 열어 보고 직접 대화할 수 있는 세션을 새로 시작하는 도구(예: 데스크톱 앱의 `start_session`)가 없으면, 이 세션에서 한다고 한 줄 알리고 절차를 따른다.
  2. 먼저 이 세션에서 항목을 찾는다(절차 1단계의 "항목 찾기"). 이 항목의 `w/` 브랜치가 이미 있으면 띄우지 않고, 그 브랜치에서 일하던 세션에서 이어 가라고 알린다. 그 세션이 없으면 이 세션에서 절차대로 그 브랜치를 이어 간다.
  3. 세션 하나를 띄운다. 사용자가 시킨 일이니 제안으로 올리지 않고 바로 시작한다. 기준 브랜치에서 딴 새 워크트리, 브랜치 이름은 `w/<.md 를 뺀 항목 파일 이름>`이다.

     모델과 노력: `${CLAUDE_SKILL_DIR}/references/settings.md`의 `session` 역할을 따른다. 설정이 없으면 기본값이다(Opus, 노력 `xhigh`).

  4. 그 세션은 이 대화를 볼 수 없다. 지시문은 "`start` 스킬을 `<항목> --here`로 불러 그 절차를 따른다", "묻는 것은 그 스킬의 묻는 기준에 드는 것뿐이다. 질문은 턴의 마지막 메시지에 빠짐없이 쓰고 멈춘다" 두 줄과, 이 대화에서 사용자가 말한 배경이나 정한 것(있을 때만)이다.
  5. 세션 링크를 알린다. 그 일은 이 세션에서 하지 않고, 이 세션이 지휘한다.
     - 하위 세션이 턴을 끝내면 질문은 빠짐없이 사용자에게 보여 주고 답을 사용자의 말 그대로 그 세션에 전한다. 결과(커밋, 바뀐 파일)는 직접 확인해 사용자가 묻기 전에 보고한다.
     - 하위 세션도 아래 묻는 기준을 따른다. 이 세션이 질문을 더하지 않는다.
     - 사용자가 하위 세션에서 직접 답했으면 그것을 받아들인다.

## 2. 프로젝트 설정

프로젝트 CLAUDE.md 에서 읽는다. 없으면 괄호 안의 기본값을 쓰고, 검증 명령이 없으면 묻는다.

- 기준 브랜치 (`main`)
- 검증 명령 (예: `pnpm verify`. 린트, 타입, 테스트, 빌드)
- 항목·보고에 쓸 언어 (대화의 언어)
- 웹 포트, 서버 포트 (없음): 적은 것만 항목마다 `기준 포트 + 항목 번호`로 나눈다

머지 방식은 CLAUDE.md 가 아니라 설정 파일의 `merge`에서 읽는다(`${CLAUDE_SKILL_DIR}/references/settings.md`). 없으면 마지막 메시지에서 묻는다.

프로젝트 CLAUDE.md 의 규칙이 이 스킬보다 우선한다.

## 3. 일하는 원칙

### 묻는 기준

다음 다섯 가지만 묻는다. `backlog` 스킬과 절차의 모든 질문 지점이 이 기준을 따른다.

1. 되돌릴 수 없거나 밖으로 나가는 일: 머지, 기준 브랜치·배포 브랜치로 푸시, 삭제, 원격 DB, 배포. 그 밖의 브랜치(작업 브랜치)는 묻지 않고 푸시한다.
2. 프로젝트 밖이나 공유 설정을 바꾸는 일: 플러그인·스킬 설치, CLAUDE.md.
3. 코드나 실행으로 정할 수 없는 제품·취향 결정.
4. 무엇을 할지 고르기: 어떤 항목을 만들지, 어디까지 할지.
5. 작업을 잃을 수 있는 상태: 커밋하지 않은 변경, 누구 것인지 모르는 브랜치.

그 밖은 묻지 않는다. 정하고, 정한 것과 이유를 적으면서 진행한다(본문: `principle-never-block-on-the-human` 스킬).

- 돌려 보면 정해지는 갈림길(구조, 라이브러리, 접근)은 묻지 않는다. 돌려 보고 정한 뒤 결과와 근거를 적는다(`playbooks/prototype.md`).
- "다음 단계로 갈까요?" 같은 질문은 하지 않는다.
- `git revert`나 워크트리 삭제로 되돌릴 수 있으면 되돌릴 수 있는 일이다.
- 사용자가 "계획을 보자", "여기서 멈춰"라고 하면 그렇게 한다.
- 몇 시간짜리 실행은 시작 전에 한 번 확인받는다(`figure-it-out` 스킬). 어디까지 할지를 정하는 일이니 기준 4이고, 착수 전 질문에 넣는다.
- 사용자가 "끝까지 해", "멈추지 마", "자리 비운다", "자러 간다"고 하면 멈추지 않는다. 그래도 묻는 것은 셋이다: 기준 1(되돌릴 수 없거나 밖으로 나가는 일. 머지도 여기 든다), 기준 5(커밋하지 않은 변경, 누구 것인지 모르는 브랜치), 새 패키지·도구·플러그인·스킬 설치. 설치 스크립트는 깔리는 순간 돌아서 되돌릴 수 없다. 나머지 질문(착수 전 질문, 범위 목록의 다른 것, 제품·취향 결정)은 추천안으로 정해 정한 것에 적고 마지막 메시지에 모은다. 막다른 길이면 헛돌지 말고 그렇다고 알린다.

### 정한 것 적기

묻지 않고 정한 것은 항목 파일 `Implementation Notes`의 `### 정한 것` 아래에 한 줄씩 적는다.

```markdown
- 정한 것 — 이유(적용한 원칙·스킬 이름) — 틀렸을 때 비용
```

틀렸을 때 비용이 큰 것은 마지막 메시지에 올린다. 이 줄은 사용자가 정한 것이 아니다. 리뷰와 판정이 검토한다.

### 일하는 방식

- 모르는 것은 가정하지 말고 말한다. 코드와 문서로 답할 수 있는 것은 묻지 않는다.
- 항목이 요구하는 것만 한다. 가장 작은 변경으로 풀고, 바뀐 줄은 모두 항목으로 거슬러 올라갈 수 있어야 한다(본문: `principle-laziness-protocol` 스킬).
- "됐다"고 하기 전에 검증을 새로 돌리고 실제 결과물로 확인한 것을 보여 준다(본문: `principle-prove-it-works` 스킬).
- 아니라고 말해도 된다. 범위를 넓히자는 제안이나 보여 준 접근이 값을 못 하면 그렇게 말한다.
- 스스로 돌릴 수 있는 확인을 사람에게 넘기지 않는다.
- 주장마다 근거를 달거나 확인함, 추론, 추측 중 무엇인지 표시한다.

## 4. 모델

하위 세션이나 하위 에이전트를 띄울 때는 `${CLAUDE_SKILL_DIR}/references/settings.md`를 Read 도구로 읽고, 역할(`session`, `implement`, `review`, `judge`, `mechanical`, `explore`)에 맞는 모델과 노력을 넘긴다. 설정 파일은 `/kit-setup`이 쓴다. 없으면 그 파일의 기본값을 쓴다.

## 5. 색인

스킬과 원칙은 이 플러그인의 다른 스킬이다. 본문은 이 파일에서 `${CLAUDE_SKILL_DIR}/../<이름>/SKILL.md`에 있다. 플레이북은 `${CLAUDE_SKILL_DIR}/playbooks/<이름>.md`다. 아래 "언제"에 해당하면 그 파일을 Read 도구로 읽고 따른다. 이 스킬들은 스스로 뜨지 않게 해 두었으니(`disable-model-invocation`) Skill 도구로 부르지 않는다. 사용자는 `/architect`, `/deslop`처럼 직접 부를 수 있다. 적용한 것은 정한 것 줄의 이유에 이름을 적는다. 본문을 읽지 않고 이름만 대지 않는다.

### 꼭 지킬 것

- 첫 메시지 → 목표와 그것을 채우는 가장 작은 변경을 되짚고 진행한다.
- 구현 전 → 설치된 스택 점검 스킬(이름이 `-start-check`로 끝나는 것: `workflow:frontend-start-check`, `workflow:server-start-check`, 다른 플러그인이 같은 이름 규칙으로 둔 것)을 모두 Skill 도구로 부르고, 돌려준 지킬 것을 따른다. 리뷰 전 → `-end-check`로 끝나는 것을 모두 부른다. 플레이북이나 `figure-it-out`을 따를 때도 건너뛰지 않는다.
- 고칠 코드가 어떻게 동작하는지 모른다 → `how` 스킬. 왜 그렇게 됐는지가 문제다 → `why` 스킬.
- 돌려 보면 정해지는 갈림길 → 묻지 말고 `playbooks/prototype.md`.
- 코드를 쓰기 전 → 데이터 모양을 먼저 정한다. 함수 경계를 넘는 변경 → `architect` 스킬.
- 화면을 바꾸거나 UI 버그를 재현한다 → `control-ui` 스킬. CLI·TUI 면 → `control-cli` 스킬. 프로젝트에 `verify-*` 스킬이 있으면 그 스킬과 기능 지도를 먼저 따른다. 스택 점검이 확인 방법을 정해 줬으면(예: frontend 의 `frontend-evaluator` 에이전트가 판정한다) 그것이 먼저이고, 이 스킬들은 화면을 모는 방법이다.
- 프로젝트에 앱을 실제로 몰아 확인할 정해진 방법이 없다 → `create-verification-skill` 스킬. 만들지는 프로젝트당 한 번 착수 전 질문에 넣는다(`verify-*` 스킬이 있거나 CLAUDE.md 에 `- 검증 스킬: 안 씀`이 있으면 묻지 않는다). 기능 지도가 앱과 어긋난다 → `maintain-verification-skill` 스킬. `start` 흐름 안에서는 어긋난 기능만 고치고 작업 브랜치에 커밋한다. PR 을 따로 열지 않는다.
- "고쳤다", "빨라졌다"는 주장 → `verify-this` 스킬.
- 잰 숫자를 보고하거나 그 숫자로 정한다 → `benchmark-checklist` 스킬.
- 작은데 넓게 닿아 믿기 어려운 diff → 리뷰 전에 `blast-radius` 스킬.
- 에이전트를 띄울 때 → 지시문의 첫 줄에 `먼저 <이 스킬 폴더의 절대 경로>/references/worker.md 를 읽는다.`를 쓰고, 다음 줄을 목표로 연다. 스킬은 스스로 뜨지 않으니, 규칙이 하위 에이전트에 닿는 길은 이것뿐이다. 구현을 맡기는 에이전트에는 이 파일의 절대 경로도 줘서 원칙을 읽게 한다(절차 5단계의 "맡길 때").
- 커밋 전 → `deslop` 스킬. 리뷰 전, 코드가 바뀌었으면 → `no-comments` 스킬.
- PR 을 연다 → `playbooks/opening-a-pr.md`. 절차 12단계가 PR 로 머지할 때 부른다.
- 글(답, 항목 파일, 보고) → `unslop` 스킬. 문서와 커밋 메시지 → `technical-writing` 스킬.
- 머지 충돌 → `fix-merge-conflicts` 스킬.
- 리뷰 지적 → 하나씩 코드에서 확인해 따진다. 절차의 판정 에이전트가 한다.

### 플레이북

항목의 성격에 맞는 것을 하나 고르고, 그 단계를 먼저 할 일 목록에 옮긴 뒤 따른다. 맞는 것이 없거나, 크고 여러 갈래에 걸친 일이거나, 사람이 자리를 비운 뒤 검토할 일이면 `figure-it-out` 스킬로 그 일에 맞는 단계를 짠다.

- 코드는 고치지 않고 알아보기만 한다 → `playbooks/investigation.md`
- 새 동작을 더한다 → `playbooks/feature.md`
- 버그를 고친다 → `playbooks/bug-fix.md`
- 동작은 그대로 두고 구조만 바꾼다 → `playbooks/refactoring.md`
- 갈림길이나 화면·상호작용을 버릴 시제품으로 정한다 → `playbooks/prototype.md`
- 잰 숫자가 있는 성능 문제를 고친다 → `playbooks/perf-issue.md`
- 수치 하나를 목표까지 거듭 끌어올린다 → `playbooks/hillclimb.md`

### 원칙

적용할 때 괄호 안 이름의 스킬(`${CLAUDE_SKILL_DIR}/../<이름>/SKILL.md`)을 읽는다.

**핵심**

- **Laziness Protocol** (`principle-laziness-protocol`): 리팩터링하거나 diff 크기를 가늠할 때, 추상화나 층을 더하고 싶을 때. 지우는 쪽과 가장 작은 변경을 고른다.
- **Foundational Thinking** (`principle-foundational-thinking`): 로직을 쓰기 전. 핵심 타입과 자료구조, 뼈대와 기능의 순서, 함께 쓰는 상태를 먼저 정한다.
- **Redesign from First Principles** (`principle-redesign-from-first-principles`): 새 요구를 기존 설계에 넣을 때. 처음부터 그 요구가 있었던 것처럼 다시 설계한다.
- **Attack the Premise** (`principle-attack-the-premise`): 같은 전제를 깔고 한 수정이 둘 이상 같은 곳에서 실패했을 때. 전제를 적고 직접 시험한다.
- **Subtract Before You Add** (`principle-subtract-before-you-add`): 더하기, 리팩터링, 다시 쓰기의 순서를 정할 때. 죽은 것부터 지운다.
- **Minimize Reader Load** (`principle-minimize-reader-load`): 따라가기 어려운 코드를 보거나 다듬을 때. 층과 숨은 상태를 줄인다.
- **Outcome-Oriented Execution** (`principle-outcome-oriented-execution`): 단계가 정해진 다시 쓰기와 이전. 목표 구조로 수렴하고 버릴 호환 코드를 만들지 않는다.
- **Experience First** (`principle-experience-first`): 제품, UX, 기능 범위를 저울질할 때. 구현 편의보다 사용자 경험을 고른다.
- **Exhaust the Design Space** (`principle-exhaust-the-design-space`): 선례가 없는 상호작용이나 구조 결정. 시제품 2~3개를 만들어 견준다.
- **Build the Lever** (`principle-build-the-lever`): 사소하지 않은 모든 일. 손으로 하지 말고 그 일을 하거나 증명하는 도구를 만든다.

**구조**

- **Model the Domain** (`principle-model-the-domain`): 상태가 있는 로직, 분기가 많거나 같은 모양 가정이 여러 파일에 되풀이될 때.
- **Boundary Discipline** (`principle-boundary-discipline`): 검증, 오류 처리, 프레임워크 어댑터를 엮을 때. 검사는 시스템 경계에 모은다.
- **Type System Discipline** (`principle-type-system-discipline`): 타입이나 시그니처를 설계할 때. 있을 수 없는 상태를 표현할 수 없게 한다.
- **Make Operations Idempotent** (`principle-make-operations-idempotent`): 중단과 재시도 속에서 도는 명령, 단계, 루프를 설계할 때.
- **Migrate Callers Then Delete Legacy APIs** (`principle-migrate-callers-then-delete-legacy-apis`): 옛 호출자가 남은 채 새 내부 API 를 들일 때. 한 번에 옮기고 지운다.
- **Separate Before Serializing Shared State** (`principle-separate-before-serializing-shared-state`): 여럿이 같은 파일, 브랜치, 키에 쓸 수 있을 때. 먼저 나눈다.

**검증**

- **Prove It Works** (`principle-prove-it-works`): 일을 마치고 "됐다"고 하기 전. 일하는 방식의 검증 줄이 이 원칙이다.
- **Fix Root Causes** (`principle-fix-root-causes`): 디버깅. 증상을 처음 잘못된 곳까지 거슬러 올라가 거기서 고친다.
- **Sequence Work into Verifiable Units** (`principle-sequence-verifiable-units`): 여러 단계로 된 일과 커밋 순서. 작은 단위마다 확인하고 넘어간다.
- **Test Behavior, Not Implementation** (`principle-test-behavior-not-implementation`): 테스트를 쓰거나 고치거나 남길 때.
- **Explain the Number** (`principle-explain-the-number`): 재기 전, 그리고 잰 숫자를 믿거나 보고하거나 그것으로 정하기 전.

**맡기기**

- **Guard the Context Window** (`principle-guard-the-context-window`): 큰 출력, 긴 파일, 되풀이 읽기로 컨텍스트가 찰 때. 덩어리는 하위 에이전트로 보내고 요약만 남긴다.
- **Never Block on the Human** (`principle-never-block-on-the-human`): 되돌릴 수 있는 일에 "X 해도 될까요?"를 묻고 싶을 때. 위 묻는 기준이 이 원칙이다.

**메타**

- **Encode Lessons in Structure** (`principle-encode-lessons-in-structure`): 같은 당부를 두 번째 쓰게 될 때. 글 대신 린트, 검사, 스크립트로 막는다.
