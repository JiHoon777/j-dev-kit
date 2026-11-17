---
name: frontend-start-check
description: 프론트엔드 프로젝트의 작업 전 점검. workflow 플러그인 task 스킬의 start 모드가 부른다. 프레임워크를 감지한 뒤 공통 점검(패키지 매니저, Node 버전, 설치, 기준선, 환경 변수)과 해당 reference 파일(svelte.md, react.md)의 프레임워크 점검을 실행한다. 기준선, 탐색에 넣을 지시문, 물을 것, 구현 중 지킬 것(frontend-design, modern-web-guidance, 프레임워크 규칙), 끝내기 전 할 브라우저 테스트를 돌려준다.
user-invocable: false
version: "0.3.3"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> 번역본입니다. 원문은 [plugins/frontend/skills/frontend-start-check/SKILL.md](../../../../../../plugins/frontend/skills/frontend-start-check/SKILL.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# 프론트엔드 시작 점검

`/task start`가 부른다. 프론트엔드 공통 점검은 여기에 있고, 프레임워크별 점검은 `references/`에 있다.

**이 스킬은 상태를 확인하는 명령만 실행한다.** 코드를 찾아 읽어 정보를 모으는 일은 여기서 하지 않는다. 그 일은 `Explore` 에이전트용 **탐색에 넣을 지시문**으로 돌려주고, `/task start`가 자기 탐색 에이전트와 함께 그 에이전트를 띄운다.

각 항목을 **통과 · 실패 · 건너뜀(이유) · 중단**으로 판정하고, 끝에 있는 형식으로 돌려준다. 고치는 일은 이 스킬의 몫이 아니다. 보고서는 프로젝트의 언어로 쓴다.

| 부분 | 출처 |
| --- | --- |
| 구현 중: 화면 디자인 | Anthropic `frontend-design` 플러그인(그대로 호출) |
| 구현 중: 웹 기능 고르기 | Google `modern-web-guidance` 플러그인(그대로 호출) |
| 끝내기 전: 브라우저 테스트 | Chrome DevTools 플러그인의 `chrome-devtools` 스킬(그대로 호출) |
| 프레임워크 점검 | `references/svelte.md`, `references/react.md` |

## 0. 적용 여부와 프레임워크 감지

- CLAUDE.md에 frontend가 빠진 `stack:` 줄이 있으면 → "해당 없음: stack 설정에 없음".
- package.json `dependencies`나 `devDependencies`에 react, next, vue, nuxt, svelte, @sveltejs/kit, solid-js, @angular/core, astro가 하나도 없으면 → "해당 없음: 프론트엔드 프레임워크 없음". (Svelte와 SvelteKit은 보통 `devDependencies`에 있다.)
- 모노레포(`packages:` 목록이 있는 `pnpm-workspace.yaml`, package.json `workspaces`, `turbo.json`, `nx.json`. pnpm 설정만 담은 `pnpm-workspace.yaml`은 모노레포가 아니다)에서는 이 항목이 건드리는 앱이나 패키지를 정하고 그 디렉터리에서 작업한다. 분명하지 않으면 질문으로 돌려준다.
- **프레임워크를 감지하고 그 레퍼런스를 읽는다.** 맞는 것마다 **Read 도구로 파일 전체를 읽고 그 점검도 실행한다**:

  | package.json에서 감지(dependencies 또는 devDependencies) | 레퍼런스 |
  | --- | --- |
  | `svelte` | `${CLAUDE_SKILL_DIR}/references/svelte.md` |
  | `react` | `${CLAUDE_SKILL_DIR}/references/react.md` |

  여러 개가 맞으면 모두 읽는다. 아직 레퍼런스가 없는 프레임워크(Vue, Angular, …)면 보고서에 그렇게 적고 공통 점검만 실행한다.

## 1. 환경

1. **패키지 매니저**는 lockfile로 정한다: `pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, `bun.lock`/`bun.lockb` → bun, `package-lock.json` → npm. 둘 이상이면 → 실패. package.json에 `packageManager`가 있으면 그 버전을 쓴다.
2. **Node 버전**: `.nvmrc`, `.node-version`, `engines.node`를 `node -v`와 비교한다. 다르면 → 실패. 셋 다 없으면 → 건너뜀("Node 버전 고정 없음").
3. 패키지 매니저 명령이 이 머신에 설치되어 있지 않으면 → 실패. 설치와 기준선을 건너뛰고 물을 것으로 돌려준다("<pm>을 설치할까?"). 버전을 짐작하지 않는다.
4. lockfile을 바꾸지 않고 **설치**한다: `pnpm install --frozen-lockfile` / `npm ci` / `yarn install --immutable` (yarn 2+) 또는 `--frozen-lockfile` (yarn 1) / `bun install --frozen-lockfile`. lockfile이 package.json과 맞지 않아 실패하면 → **중단**.

## 2. 기준선

작업 전 상태를 기록한다. `/task end`가 이것과 비교해 이번 작업이 만든 실패만 찾는다.

- 프로젝트 CLAUDE.md의 검증 명령을 쓴다. 검증 명령이 여러 점검을 이어 붙인 것이면(예: `pnpm lint && pnpm check && pnpm test && pnpm build`) 하나가 실패해도 나머지가 가려지지 않도록 각 부분을 따로 돌린다. CLAUDE.md에 검증 명령이 없으면 package.json `scripts`에서 lint, 타입 체크, 테스트를 찾는다(테스트는 watch 모드로 시작하면 안 된다: `vitest run`, `CI=true jest`).
- 각각: 명령, 종료 코드, 실패 수, 실패한 파일이나 테스트 이름(많으면 개수와 처음 10개).
- 기존 실패는 **기준선**으로 기록한다. 사용자에게 알리되 작업을 막지는 않는다.

## 3. 환경 변수

- `.env.example`/`.env.sample`의 키를 실제 `.env`/`.env.local`의 키와 비교해 빠진 **이름**만 나열한다. 값은 절대 출력하지 않는다. 실제 env 파일이 하나도 없으면 실패가 아니라 건너뜀("로컬 env 파일 없음")이다. 예시 파일의 키를 물을 것으로 돌려준다("`.env`를 만들고 넣을 키: …").
- 공개 접두사(`NEXT_PUBLIC_`, `VITE_`, `PUBLIC_`, `NUXT_PUBLIC_`, `REACT_APP_`)가 붙은 변수 이름에 `SECRET`, `PRIVATE`, `SERVICE_ROLE`, `TOKEN`, `PASSWORD`가 들어 있으면 → 실패. 브라우저 번들에 들어가 버린다.

## 4. 재사용 조사(탐색 에이전트에게 넘김)

직접 찾지 않는다. 아래 지시문을 탐색에 넣을 지시문으로 돌려주되, `<…>`는 항목에서 채운다.

> 이 항목(<항목 경로>)의 각 UI 요소 — <요소 목록> — 마다 이 저장소에 이미 있는 것을 찾는다: 공용 컴포넌트 폴더, 디자인 토큰(색, 글꼴, 간격을 정의하는 CSS나 테마 파일), UI 라이브러리, 같은 패턴을 구현한 기존 화면, 공용 유틸리티. 요소마다 "사용(경로)" 또는 "새로 만듦"을 적은 표를 만들고, 꼭 읽어야 할 파일 5–10개를 돌려준다. 파일을 고치지 않는다.

## 5. 디자인 참고 자료

항목에 디자인이나 명세 링크가 있는지 확인한다. 새 화면을 만들거나 다시 디자인하는 항목인데 없으면 질문으로 돌려준다. 지어내지 않는다.

## 6. 구현 중 지킬 것(돌려줄 것)

- **항목이 새 화면을 만들거나 다시 디자인하면** `frontend-design` 스킬을 호출해 그 방식대로 작업한다. 단:
  - 색과 글꼴은 프로젝트의 디자인 토큰 안에서 고른다. 스킬이 새 색이나 글꼴을 제안하면 추가하기 전에 사용자에게 묻는다.
  - 프로젝트 CLAUDE.md의 제품 원칙이 먼저다.
  - 승인된 디자인이 있으면 그것을 따른다.
  - 기존 화면이나 프로토타입을 그대로 **옮기는** 항목에는 호출하지 않는다. 이 스킬은 시각적 방향을 스스로 고른다.
- **새 웹 기능이나 UI 패턴을 고를 때**(다이얼로그, 팝오버, 스크롤 연동 효과, 레이아웃, 폼 검증, …) `modern-web-guidance` 스킬을 호출하고 그것이 지시하는 대로 검색한다.
- 0단계에서 읽은 레퍼런스의 프레임워크 규칙을 더한다.

## 7. 끝내기 전 할 것(돌려줄 것): 브라우저 테스트

테스트와 타입 체크가 통과해도 화면이 동작한다는 것을 보여 주지는 못한다. 직접 눌러 봐야 한다.

- **도구:** `chrome-devtools` 스킬을 호출해 그것이 말하는 대로 쓴다. 쓸 수 없으면 Claude 앱의 내장 브라우저 미리보기를 쓴다. 둘 다 없으면 **건너뛰지 말고 중단한 뒤 사용자에게 알린다.** 확인하지 않은 것을 완료로 기록하지 않는다.
- **서빙:** 개발 서버(`.claude/launch.json`이 있으면 그것을 쓴다). 빌드에서만 보이는 변경(서비스 워커, 매니페스트, 정적 생성)은 빌드하고 미리보기를 쓴다. 다시 빌드한 뒤에는 미리보기 서버도 다시 시작한다.
- **뷰포트:** CLAUDE.md에 정한 것. 없으면 휴대폰 375×812와 데스크톱 1280 둘 다.
- **확인할 것:**
  1. 각 인수 조건을 사용자처럼 따라간다: 클릭, 입력, 뒤로 가기, 새로고침.
  2. 콘솔 오류가 없고 실패한 요청(4xx/5xx)이 없다.
  3. 다른 것이 깨지지 않았다: 시작 화면과 관련 화면을 한 번씩 연다.
  4. 가로 스크롤이 없고 잘린 텍스트가 없다.
  5. 움직임이 있는 화면은 "동작 줄이기"를 켜고 다시 확인한다.
- **기록:** 해 본 것과 본 것을 항목의 `Implementation Notes`에 쓴다. 실패하면 고치고 처음부터 다시 테스트한다.

## 돌려줄 형식

```markdown
### frontend start check
| Item | Result | Evidence |
| --- | --- | --- |
| Framework | pass | svelte 5.x (references/svelte.md read) |
| Package manager | pass | pnpm 9.x (pnpm-lock.yaml) |
| Node version | … | … |
| Install | … | … |
| Environment variables | … | missing keys: … |
| Design reference | … | … |
| (framework rows from the reference) | … | … |

#### Baseline
| Check | Command | Result |
| --- | --- | --- |

#### Exploration prompts
- Reuse survey: (the step 4 prompt, filled in)
- (framework prompts from the reference)

#### Add to the plan
- …

#### Questions to ask
- …

#### Rules during implementation
- (step 6 items that apply to this item, plus framework rules)

#### Before finishing
- Browser test (step 7 procedure, viewport, server to run)
```

**중단**인 것이 있으면 표 위에 `stop: <이유>`를 먼저 적는다.
