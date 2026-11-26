---
name: kit-help
description: workflow 플러그인을 어떻게 쓰는지 안내한다. 처음 설정, /backlog 와 /start 쓰는 법, 상황에 맞는 스킬·플레이북·원칙 고르기, 잘 안 될 때. /kit-help 뒤에 질문을 적는다.
disable-model-invocation: true
---

# kit-help

> pstack 의 `poteto-help`(`cursor/plugins`의 `pstack/skills/poteto-help/SKILL.md`, MIT, Lauren Tan)의 짜임을 따랐다.

workflow 플러그인에 대한 질문에 답하고, 사용자가 그대로 보낼 수 있는 명령 한 줄을 주고, 답이 나온 파일을 알려 준다. 도움말 질문에는 일을 시작하지 않는다. 사용자는 방법을 물은 것이니, 명령은 사용자가 보내게 둔다.

"이 버그 고쳐 줘"처럼 일을 시키는 말은 도움말 질문이 아니다. Skill 도구로 `start` 스킬을 불러 그 절차로 한다.

이 파일은 질문을 스킬과 문서로 이어 주는 지도다. 자세한 내용은 그 파일들에 있다. 답하기 전에 가리키는 파일을 Read 도구로 읽고, 이 지도와 다르면 그 파일을 믿는다. 스킬 파일은 `${CLAUDE_SKILL_DIR}/../<이름>/SKILL.md`에 있다. 사용자에게는 공개 사본을 알려 준다: `https://github.com/JiHoon777/j-dev-kit/blob/main/plugins/workflow/` 뒤에 경로를 붙인다.

## 무엇이 필요한지 알아내기

질문과 대화에서 알아낸다. "PR 전에 뭘 돌려?"처럼 상황이 분명하면 바로 그 절로 간다. 분명하지 않으면 아래 넷 중 무엇인지 한 번 묻고, 고른 절만 답한다.

- 처음 설정하기
- `/backlog`와 `/start`로 일하기
- 상황에 맞는 스킬 고르기
- 잘 안 될 때

답을 바꾸는 상태만 확인하고, 답이 달라질 때만 말한다.

- `.claude/workflow.json`과 `~/.claude/workflow.json`이 모두 없으면 `/kit-setup`을 돌린 적이 없고, 모든 역할이 기본 모델을 쓴다.
- 프로젝트에 `verify-*` 스킬이 없으면 앱을 실제로 몰아 확인할 정해진 방법이 없다. 변경을 증명하는 방법을 물으면 `/create-verification-skill`을 알려 준다.
- 프로젝트 CLAUDE.md 에 `검증 명령:` 줄이 없으면 `/start`가 무엇으로 검증할지 묻는다.

## 처음 설정하기

1. 설치: `claude plugin marketplace add JiHoon777/j-dev-kit --scope project`, `claude plugin install workflow@j-dev-kit --scope project`.
2. `/kit-setup`을 돌린다. 역할마다 쓸 모델과 노력, 머지 방식(로컬 머지 후 푸시 / PR)을 묻고 `.claude/workflow.json`에 쓴다. CLAUDE.md 의 작업 설정(기준 브랜치, 검증 명령, 문서 언어, `stack:`)과 검증 스킬도 없으면 만들지 묻는다.
3. 실제 일을 시작한다: `/backlog <할 일>`로 항목을 만들거나 `/start <할 일>`로 바로 한다.

설치만으로는 아무것도 바뀌지 않는다. 스킬을 부를 때 돈다. 자세한 것은 README(`https://github.com/JiHoon777/j-dev-kit#readme`)에 있다.

비용이 걱정이면 토큰이 어디에 드는지 말해 준다. 하위 세션, 리뷰 에이전트, 판정 에이전트에 든다. `/kit-setup`을 다시 돌려 "아끼기"를 고르거나 역할별로 싼 모델을 고르면 된다. 작은 일은 `/start <할 일>`로 하면 리뷰가 크기에 맞게 줄어든다.

## `/backlog`와 `/start`로 일하기

- `/backlog <한두 문장>`: 백로그 항목을 만든다. Acceptance Criteria 전문을 보여 주고 승인받는다. `/backlog --survey <목표>`는 저장소와 바깥을 조사해 항목 후보를 낸다.
- `/start <번호나 이름>`: 항목 하나를 구현해 머지까지 간다. 새 워크트리의 하위 세션에서 돈다. `--here`를 붙이면 이 세션에서 한다.
- `/start <할 일>`: 항목 없이 바로 한다. 이 세션에서 돈다.
- 말로 해도 된다. "백로그에 넣어 줘", "001 시작해 줘", "이 브랜치 리뷰하고 머지해 줘".

`/start`는 다섯 가지만 묻는다(되돌릴 수 없는 일, 공유 설정, 제품·취향 결정, 무엇을 할지, 작업을 잃을 수 있는 상태). 나머지는 정하고 `정한 것 — 이유 — 틀렸을 때 비용`으로 적는다. 계획 승인은 없다. 계획을 보고 싶으면 "계획 보자"고 한다. 마지막에 남은 결정과 머지를 한 번에 묻는다. 머지 방식은 `/kit-setup`으로 정해 두면 묻지 않고, 그 방식으로 머지할지만 묻는다.

좋은 요청은 목표와 끝났는지 알 방법을 적는다. 스킬을 나열하지 않는다. 절차가 필요한 스킬을 차례로 부른다.

```text
/start csv 내보내기가 마지막 줄을 빠뜨려. 먼저 재현하고 고쳐. 6만 줄 파일이 전부 나오면 끝이야. 고치기 전과 후의 줄 수를 보여 줘.
```

## 상황에 맞는 스킬 고르기

기본 답은 `/start`다. 절차가 필요할 때 아래 스킬을 읽어 쓴다. 절차가 주는 것보다 더 하거나 덜 하고 싶을 때만 스킬을 직접 부른다. 추천하기 전에 그 스킬을 읽고, 예시 명령 하나를 준다.

| 하고 싶은 것 | 스킬 |
| --- | --- |
| 일을 구현해 머지까지 | `/start` |
| 할 일을 백로그 항목으로 | `/backlog` |
| 모델과 노력, 머지 방식, 프로젝트 설정 | `/kit-setup` |
| 맞는 플레이북이 없는 큰 일의 단계를 먼저 짜기 | `/figure-it-out` |
| 코드가 지금 어떻게 동작하는지, 새 코드를 어디에 둘지 | `/how` |
| 코드가 왜 이렇게 됐는지, 숫자가 어디서 왔는지 | `/why` |
| 함수 경계를 넘는 변경 전에 타입과 모듈 모양 정하기 | `/architect` |
| 작은 diff 가 diff 밖에서 무엇을 깰 수 있는지 | `/blast-radius` |
| "고쳤다", "빨라졌다"를 전후 비교로 확인 | `/verify-this` |
| 잰 성능 숫자를 보고하기 전에 점검 | `/benchmark-checklist` |
| 화면을 실제로 몰아 확인하거나 UI 버그 재현 | `/control-ui` |
| CLI·TUI 를 몰아 확인 | `/control-cli` |
| 앱을 몰아 확인하는 프로젝트 스킬과 기능 지도 만들기 | `/create-verification-skill` |
| 그 스킬과 기능 지도를 앱에 다시 맞추기 | `/maintain-verification-skill` |
| 커밋 전에 AI 가 넣은 코드 군더더기 지우기 | `/deslop` |
| 리뷰 전에 필요 없는 주석과 임시방편 코드 짚기 | `/no-comments` |
| 글에서 AI 티 지우기 | `/unslop` |
| 문서, README, 커밋 메시지를 기준에 맞게 쓰기 | `/technical-writing` |
| 머지 충돌 풀기 | `/fix-merge-conflicts` |
| 화면 시안 만들기, DESIGN.md 만들기·갱신 | `/ui-design` |
| 이 플러그인 쓰는 법 | `/kit-help` |

이 표에 없는 스킬 폴더가 옆에 있으면 그 파일의 frontmatter 를 읽고 description 으로 안내한다.

스스로 부르지 않는 것:

- `frontend-start-check`, `frontend-end-check`, `server-start-check`, `server-end-check`: `/start`가 구현 전과 리뷰 전에 부르는 스택 점검이다. CLAUDE.md 의 `stack:` 줄이나 코드를 보고, 해당하지 않으면 "해당 없음"으로 빠진다.
- 리뷰어와 판정 에이전트(`frontend-reviewer`, `design-reviewer`, `frontend-evaluator`, `api-reviewer`, `supabase-reviewer`): `/start`의 리뷰 단계가 띄운다.
- `survey-collector`, `survey-judge`: `/backlog --survey`가 띄운다. 수집 쪽은 읽기·웹 도구와 메모 쓰기만, 판정 쪽은 읽기·웹 도구만 가진다. `comment-sicko`: `/no-comments`가 띄운다.

헷갈리는 것:

- `/how`는 코드가 무엇을 하는지, `/why`는 왜 그런지 답한다.
- `/blast-radius`는 diff 밖의 영향을 본다. diff 자체의 리뷰는 `/start`의 리뷰 단계(`code-review`)가 한다.
- `/deslop`은 코드를, `/unslop`은 글을 치운다.
- `/control-ui`는 화면을 모는 방법이고, `/verify-this`는 주장을 전후 비교로 판정하는 틀이다.

이 플러그인에 없는 것:

- `code-review`, `security-review`, `/loop`, `/model`은 Claude Code 에 든 것이다.
- pstack 의 arena, swarm, interrogate 는 가져오지 않았다. 다른 회사 모델을 섞어 돌리는 것이 핵심이라서다.

## 플레이북과 원칙

플레이북은 `/start` 안의 단계 목록이다. 스킬이 아니라 슬래시 명령이 없다. 일을 설명하면 `/start`가 고른다.

- 코드는 고치지 않고 알아보기만 한다 → investigation
- 새 동작을 더한다 → feature
- 버그를 고친다 → bug-fix
- 동작은 그대로 두고 구조만 바꾼다 → refactoring
- 갈림길이나 화면을 버릴 시제품으로 정한다 → prototype
- 잰 숫자가 있는 성능 문제 → perf-issue
- 수치 하나를 목표까지 거듭 끌어올린다 → hillclimb
- 맞는 것이 없거나 크고 여러 갈래에 걸친 일 → `figure-it-out`이 단계를 짠다

PR 로 머지할 때는 `/start`가 opening-a-pr 를 따른다. PR 의 제목과 본문 형식이 거기 있다.

파일은 `start/playbooks/<이름>.md`다.

원칙은 규칙 하나짜리 스킬 24개다(`principle-<이름>`). `/start`가 색인을 읽고 적용한 원칙을 정한 것 줄에 적는다. 사용자는 원칙을 부르기보다 이름으로 방향을 잡는다. 예: "prove it works 적용해. 빌드 로그 말고 실제 출력 보여 줘." `/principle-<이름>`을 치면 하나를 읽는다. 목록은 `start` SKILL.md 의 색인에 있다.

## 잘 안 될 때

| 증상 | 해결 |
| --- | --- |
| 너무 자주 묻는다 | 묻는 기준 다섯 밖의 질문이면 "묻지 말고 정해서 적어"라고 한다. 되풀이되면 `start` SKILL.md 의 묻는 기준을 고칠 일이다 |
| 머지 방식을 매번 묻는다 | `/kit-setup`에서 머지 방식을 정한다. 로컬 머지 후 푸시나 PR 가운데 하나다 |
| 자리를 비우는 동안 멈추지 않게 하고 싶다 | "끝까지 해"라고 한다. 머지와 되돌릴 수 없는 일, 작업을 잃을 수 있는 상태만 묻고, 나머지는 추천안으로 정해 마지막 메시지에 모은다 |
| 계획을 보고 싶다 | "계획 보자"고 하면 보여 주고 기다린다 |
| 모델을 바꿨는데 그대로다 | 역할별 설정은 다음에 세션이나 에이전트를 띄울 때부터, 메인 세션 설정은 새 세션부터 적용된다 |
| 비용이 많이 든다 | "처음 설정하기"의 비용 문단을 본다 |
| 스택 점검이 돌지 않는다 | CLAUDE.md 의 `stack:`에 그 스택이 빠져 있거나(`stack: 없음`), 코드에 프레임워크가 없다 |
| 멈출 때 검증 명령이 돈다 | 검증 훅이다. `w/` 브랜치에서 항목의 Definition of Done 이 체크돼 있고 코드가 마지막 통과 뒤에 바뀌었을 때만 돈다 |
| 빌드가 통과했다고만 하고 끝낸다 | 실제 명령, 화면, 저장된 값을 보여 달라고 한다. prove it works 원칙이다 |
| `/task`가 없다 | `/backlog`(항목 만들기)와 `/start`(구현부터 머지까지)로 나뉘었다 |
| `frontend@j-dev-kit`, `server@j-dev-kit`을 찾을 수 없다 | workflow 로 합쳤다. 프로젝트 설정의 `enabledPlugins`에서 두 줄을 지운다 |

## 답하는 법

답부터 말한다. 예시 명령은 코드 블록 하나까지만 주고, 그 답이 나온 파일의 링크를 붙인다. 사용자가 전체 지도를 달라고 하지 않았으면 짧게 답한다.
