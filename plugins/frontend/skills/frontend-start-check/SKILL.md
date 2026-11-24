---
name: frontend-start-check
description: 프론트엔드 프로젝트의 작업 전 점검. workflow 플러그인 task 스킬의 start 모드가 부른다. 프레임워크를 감지하고, 구현 중 지킬 것(frontend-design, 프레임워크 규칙, 브라우저 확인), 계획 전에 할 것(시안), 플랜에 넣을 것(DESIGN.md)을 돌려준다. 프레임워크별 내용은 references(svelte.md, react.md)에 있다.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# 프론트엔드 시작 점검

`/task start`가 부른다. 고치지 않고, 명령도 거의 돌리지 않는다. 이 항목에 맞는 것만 돌려준다. 보고는 프로젝트의 언어로.

## 0. 해당 여부

- CLAUDE.md 에 frontend 가 빠진 `stack:` 줄이 있으면 "해당 없음"만 돌려준다.
- 볼 package.json 을 정한다. 모노레포(`pnpm-workspace.yaml`의 `packages:`, package.json `workspaces`, `turbo.json`, `nx.json`)면 루트가 아니라 이 항목이 건드리는 앱·패키지의 package.json 이다. 어느 것인지 분명하지 않으면 물을 것으로.
- 그 package.json 의 `dependencies`·`devDependencies`에 react, next, vue, nuxt, svelte, @sveltejs/kit, solid-js, @angular/core, astro 가 하나도 없으면 "해당 없음"만 돌려준다.
- 프레임워크를 감지하고 맞는 reference 를 Read 도구로 끝까지 읽는다. 여럿이면 모두.

  | package.json 에 | reference |
  | --- | --- |
  | `svelte` | `${CLAUDE_SKILL_DIR}/references/svelte.md` |
  | `react` | `${CLAUDE_SKILL_DIR}/references/react.md` |

## 1. 지킬 것

이 항목에 해당하는 것만 돌려준다.

- **새 화면이나 다시 디자인:** `frontend-design` 스킬을 부르고 따른다. 색과 글꼴은 프로젝트의 디자인 토큰 안에서 고르고, 새로 더하려면 먼저 묻는다. 항목에 고른 시안이 있거나 CLAUDE.md 에 제품 원칙이 있으면 그것이 먼저다. 기존 화면을 그대로 옮기는 항목에는 부르지 않는다.
- **새 웹 기능·UI 패턴을 고를 때**(다이얼로그, 팝오버, 레이아웃, 폼 검증 등): `modern-web-guidance` 스킬이 있으면 부른다.
- **브라우저 확인**(UI 가 바뀌면, 구현 마무리에): 구현한 세션이 직접 판정하지 않고 `frontend:frontend-evaluator` 에이전트에 맡긴다.
  - 개발 서버를 띄운다. 포트는 작업 브랜치 항목의 `### 포트`에 있는 웹 포트, 없으면 `.claude/launch.json`의 포트다(launch.json 은 고치지 않는다). launch.json 으로 그 포트에 띄울 수 있으면 그것으로 띄우고 `bash ${CLAUDE_SKILL_DIR}/scripts/dev-server.sh <포트>`로 듣는지 확인한다. 아니면 개발 명령이 포트를 받는 방식(예: Vite `--port`, 위치 인자, `PORT` 환경 변수)을 package.json 스크립트에서 확인해 `bash ${CLAUDE_SKILL_DIR}/scripts/dev-server.sh <포트> <그 포트로 띄우는 명령…>`으로 띄운다. 출력의 `URL:`을 화면 URL 로 쓰고, 0 이 아닌 값으로 끝나면 출력한 이유를 알린다. 백엔드 서버도 띄워야 하면 같은 스크립트로 서버 포트에 띄우고, 웹이 백엔드 주소를 받는 곳(프록시 대상, `VITE_API_URL` 같은 환경 변수)은 파일을 고치지 않고 명령 인자나 환경 변수로 그 서버 포트를 가리키게 한다. 빌드에서만 보이는 변경(서비스 워커, 정적 생성)은 빌드한 뒤 미리보기 명령을 같은 스크립트로 띄운다.
  - 에이전트에 항목 파일 경로, 화면 URL, 뷰포트만 넘긴다. 무엇을 어떻게 구현했는지는 넘기지 않는다.
  - 뷰포트는 CLAUDE.md 에 정한 것, 없으면 데스크톱. 반응형 레이아웃을 바꿨으면 휴대폰(375×812)도.
  - "실패"는 고치고 다시 넘긴다. 같은 AC 가 세 번 고쳐도 실패하면 더 고치지 않고 멈추고, 실패한 AC 와 시도한 것을 사용자에게 알린다. 같은 고치기를 되풀이하기보다 사람이 접근을 다시 보는 편이 낫다. "확인 못 함"은 체크하지 않고 사용자에게 알린다.
  - 에이전트가 "브라우저 도구 없음"이라고 하면 직접 확인한다(`chrome-devtools` 스킬이 있으면 그것, 없으면 앱의 내장 브라우저): 각 Acceptance Criteria 를 사용자처럼 따라가고, 콘솔 오류와 실패한 요청(4xx/5xx)이 없어야 한다. 직접 했다고 `Implementation Notes`에 적는다. 직접도 할 수 없으면 멈추고 알린다.
- reference 의 프레임워크 규칙.

## 2. 계획 전에 할 것 / 플랜에 넣을 것 / 물을 것

- **시안:** 새 화면이나 다시 디자인하는 항목인데 항목에 고른 시안이 없으면, 계획 전에 할 것으로 `frontend:ui-design` 스킬을 `mockup <화면>`으로 부른다. 사용자가 시안 없이 가자고 하면 건너뛴다. 기존 화면을 그대로 옮기는 항목에는 넣지 않는다.
- **DESIGN.md 가 없을 때:** UI 를 바꾸는 항목인데 루트에 `DESIGN.md`가 없고 CLAUDE.md 에 `- DESIGN.md: 안 씀`이 없으면, 이 항목에서 만들지 물을 것으로. 만들기로 하면 플랜에 넣을 것: 구현 첫 단계에 `frontend:ui-design` 스킬을 `system`으로 부른다. 안 쓰기로 하면 다시 묻지 않게 CLAUDE.md `## 작업 설정`에 `- DESIGN.md: 안 씀`을 적자고 제안한다.
- **토큰을 바꿀 때:** 색, 글꼴, 간격 같은 디자인 토큰을 바꾸는 항목이고 `DESIGN.md`가 있으면, 플랜에 넣을 것: `frontend:ui-design` 스킬을 `system`으로 불러 DESIGN.md 를 갱신한다.
- reference 가 더하는 것.

## 돌려줄 형식

```markdown
### frontend start check
감지: svelte 5 (references/svelte.md 읽음)

#### 지킬 것
- …

#### 계획 전에 할 것
- …

#### 플랜에 넣을 것
- …

#### 물을 것
- …
```

내용이 없는 섹션은 빼고 돌려준다.
