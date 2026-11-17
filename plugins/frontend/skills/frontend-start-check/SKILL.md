---
name: frontend-start-check
description: 프론트엔드 프로젝트의 작업 시작 전 공통 점검. 패키지 매니저·Node 버전·설치, 검사 기준선, 환경변수, 재사용할 것을 확인하고, 구현 중 지킬 것(frontend-design, modern-web-guidance)과 끝내기 전 할 것(브라우저 테스트)을 돌려준다. workflow 의 task-start 가 부른다.
user-invocable: false
version: "0.2.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# 프론트엔드 시작 점검

`task-start`가 부른다. 프레임워크와 상관없는 공통 점검이다. Svelte·React 전용 점검은 `svelte`·`react` 플러그인이 따로 한다.

각 항목을 **통과 · 실패 · 건너뜀(이유) · 중단**으로 판정하고 맨 아래 형식으로 돌려준다. 고치는 것은 이 스킬의 일이 아니다.

| 부분 | 출처 |
| --- | --- |
| 구현 중: 화면 디자인 | Anthropic `frontend-design` 플러그인 (그대로 호출) |
| 구현 중: 웹 기능 선택 | Google `modern-web-guidance` 플러그인 (그대로 호출) |
| 끝내기 전: 브라우저 테스트 | Chrome DevTools 플러그인의 `chrome-devtools` 스킬 (그대로 호출) |

## 0. 해당 여부

- CLAUDE.md 에 `stack:`이 있고 frontend 가 없으면 → "해당 없음: stack 설정에 없음".
- package.json 의 의존성에 react·next·vue·nuxt·svelte·@sveltejs/kit·solid-js·@angular/core·astro 가 하나도 없으면 → "해당 없음: 프론트 프레임워크 없음".
- 모노레포(`pnpm-workspace.yaml`, package.json `workspaces`, `turbo.json`, `nx.json`)면 이번 항목이 건드릴 앱·패키지를 정하고 그 디렉터리 기준으로 한다. 모르겠으면 "물을 것"으로 돌려준다.

## 1. 실행 환경

1. **패키지 매니저**를 lockfile 로 정한다: `pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, `bun.lock`·`bun.lockb` → bun, `package-lock.json` → npm. 둘 이상이면 실패. package.json `packageManager`가 있으면 그 버전.
2. **Node 버전**: `.nvmrc`·`.node-version`·`engines.node`와 `node -v`를 비교한다. 안 맞으면 실패.
3. **설치**: lockfile 을 바꾸지 않는 설치. `pnpm install --frozen-lockfile` / `npm ci` / `yarn install --immutable`(yarn 2+), `--frozen-lockfile`(yarn 1) / `bun install --frozen-lockfile`. lockfile 이 package.json 과 안 맞아 실패하면 **중단**.

## 2. 기준선

작업 전 상태를 기록한다. `task-end`가 이것과 비교해 이번 작업이 만든 실패만 골라낸다.

- 프로젝트 CLAUDE.md 의 검증 명령을 쓴다. 없으면 package.json `scripts`에서 린트·타입·테스트를 찾는다(테스트는 감시 모드로 뜨지 않게: `vitest run`, `CI=true jest`).
- 각각 명령, 종료 코드, 실패 개수, 실패한 파일·테스트 이름(많으면 개수와 앞 10개)을 적는다.
- 이미 실패하는 것은 **기준선**으로 적고 알린다. 작업을 막지 않는다.

## 3. 환경변수

- `.env.example`·`.env.sample`의 키와 실제 `.env`·`.env.local`의 키를 비교해 빠진 **이름만** 적는다. 값은 출력하지 않는다.
- 공개 접두어(`NEXT_PUBLIC_`·`VITE_`·`PUBLIC_`·`NUXT_PUBLIC_`·`REACT_APP_`) 변수 이름에 `SECRET`·`PRIVATE`·`SERVICE_ROLE`·`TOKEN`·`PASSWORD`가 있으면 실패. 브라우저 번들에 들어간다.

## 4. 재사용 조사

항목에 나오는 화면 요소마다 이미 있는 것을 찾는다: 공용 컴포넌트 폴더, 디자인 토큰(색·글꼴·간격이 정의된 CSS·테마 파일), UI 라이브러리, 같은 패턴을 구현한 기존 화면, 공용 유틸. 요소마다 "쓸 것(경로)" 또는 "새로 만듦"으로 표를 만든다.

## 5. 디자인 기준

항목에 시안·기획 링크가 있는지 본다. 화면을 새로 만들거나 다시 디자인하는 항목인데 없으면 "물을 것"으로 돌려준다. 지어내지 않는다.

## 6. 구현 중 지킬 것 (돌려줄 내용)

- **화면을 새로 만들거나 다시 디자인하는 항목이면** `frontend-design` 스킬을 부르고 그 방식대로 한다. 다만:
  - 색과 글꼴은 프로젝트의 디자인 토큰 안에서 고른다. 스킬이 새 색이나 글꼴을 제안하면 넣기 전에 사용자에게 묻는다.
  - 프로젝트 CLAUDE.md 의 제품 원칙이 우선이다.
  - 승인받은 시안이 있으면 그 시안을 따른다.
  - 기존 화면이나 프로토타입을 **그대로 옮기는** 항목에는 부르지 않는다. 이 스킬은 자기 나름의 분위기를 고르기 때문이다.
- **새 웹 기능이나 UI 패턴을 고를 때**(대화상자, 팝오버, 스크롤 연동, 레이아웃, 폼 검증 등) `modern-web-guidance` 스킬을 부르고 그 스킬이 안내하는 방식대로 찾아본다.

## 7. 끝내기 전 할 것 (돌려줄 내용): 브라우저 테스트

테스트와 타입 검사가 통과해도 화면이 제대로 도는지는 눌러 봐야 안다.

- **도구:** `chrome-devtools` 스킬을 부르고 그 방식대로 쓴다. 쓸 수 없으면 Claude 앱의 내장 브라우저 미리보기를 쓴다. 둘 다 없으면 **건너뛰지 말고 멈춰서 알린다.** 확인하지 못한 것을 됐다고 적지 않는다.
- **띄우기:** 개발 서버(`.claude/launch.json`이 있으면 그 설정). 빌드 결과에서만 드러나는 변경(서비스 워커, 매니페스트, 정적 생성)이면 빌드 후 미리보기로. 다시 빌드했으면 미리보기 서버도 다시 켠다.
- **화면 크기:** CLAUDE.md 에 정해져 있으면 그것, 없으면 폰 375×812 와 데스크톱 1280 둘 다.
- **확인할 것:**
  1. 완료 기준을 하나씩 사용자처럼 해 본다. 누르고, 입력하고, 뒤로 가고, 새로고침한다.
  2. 콘솔 오류와 실패한 요청(4xx·5xx)이 없는지 본다.
  3. 다른 곳이 깨지지 않았는지 처음 화면과 관련 화면을 한 번씩 연다.
  4. 가로 스크롤이 생기거나 글자가 잘리지 않는지 본다.
  5. 움직임이 있는 화면이면 "움직임 줄이기"를 켠 상태에서도 본다.
- **기록:** 무엇을 해 봤고 무엇을 봤는지 항목의 `Implementation Notes`에 적는다. 실패하면 고치고 처음부터 다시 한다.

## 돌려줄 형식

```markdown
### frontend 시작 점검
| 항목 | 결과 | 근거 |
| --- | --- | --- |
| 패키지 매니저 | 통과 | pnpm 9.x (pnpm-lock.yaml) |
| Node 버전 | … | … |
| 설치 | … | … |
| 환경변수 | … | 빠진 키: … |
| 디자인 기준 | … | … |

#### 기준선
| 검사 | 명령 | 결과 |
| --- | --- | --- |

#### 플랜에 넣을 것
- 재사용: (요소 → 쓸 것 / 새로 만듦)

#### 물을 것
- …

#### 구현 중 지킬 것
- (6번에서 이 항목에 해당하는 것만)

#### 끝내기 전 할 것
- 브라우저 테스트 (7번 절차, 화면 크기, 띄울 서버)
```

**중단**이 있으면 표 위에 `중단: <이유>`를 먼저 쓴다.
