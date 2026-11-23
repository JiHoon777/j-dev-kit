---
name: frontend-end-check
description: 프론트엔드 프로젝트의 마무리 점검. workflow 플러그인 task 스킬의 end 모드가 부른다. 프론트엔드 코드가 바뀌었을 때만 남은 디버그 코드와 lockfile 을 확인하고 프레임워크 검사 도구를 돌린 뒤, 리뷰에 넣을 frontend-reviewer·design-reviewer 와 고친 뒤 할 브라우저 확인을 돌려준다.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# 프론트엔드 마무리 점검

`/task end`가 부른다. 명령을 돌리고 결과만 돌려준다. 코드를 읽고 판단하는 리뷰는 `frontend:frontend-reviewer`가 한다. 보고는 프로젝트의 언어로.

## 0. 해당 여부

- CLAUDE.md 에 frontend 가 빠진 `stack:` 줄이 있으면 "해당 없음".
- `git diff --name-only <기준>...HEAD`에 프론트엔드 코드(컴포넌트, 페이지, 스타일, 클라이언트 로직, package.json)가 없으면 "프론트엔드 변경 없음"만 돌려준다.
- 볼 package.json 은 바뀐 파일이 속한 앱·패키지의 것이다(모노레포면 루트가 아니다). 거기에 프런트엔드 프레임워크(react, next, vue, nuxt, svelte, @sveltejs/kit, solid-js, @angular/core, astro)가 없으면 "해당 없음".
- 그 package.json 에 `svelte`가 있으면 `${CLAUDE_SKILL_DIR}/references/svelte.md`를 Read 도구로 끝까지 읽는다. React 는 따로 돌릴 검사가 없다(훅 린트와 빌드는 검증 명령에 들어 있어야 한다).

## 1. 검사

- `git diff <기준>...HEAD -U0`의 추가된 줄에 `console.log`, `debugger`, `.only(`가 있으면 실패.
- package.json 의존성이 바뀌었는데 lockfile 이 바뀌지 않았으면 실패.
- reference 의 검사.

## 2. 리뷰에 넣을 에이전트

UI 코드가 바뀌었으면 `frontend:frontend-reviewer`. 근거로 바뀐 UI 파일 목록과 감지한 프레임워크를 넘긴다.

화면(컴포넌트, 페이지, 스타일)이 바뀌었으면 `frontend:design-reviewer`도. 근거로 화면 URL, 루트 `DESIGN.md` 경로(있으면), 바뀐 화면 파일을 넘긴다. URL 은 3절의 방식으로 개발 서버를 띄워 얻는다. 띄울 수 없으면 넣지 않고 그렇다고 적는다.

## 3. 고친 뒤 할 것

리뷰 지적을 고쳐 UI 가 바뀌었으면, 고친 화면을 `frontend:frontend-evaluator` 에이전트에 맡겨 확인한다. reference 가 더하는 것도.

- 개발 서버를 띄운다(`.claude/launch.json`이 있으면 그것). 작업 브랜치 항목의 `### 포트`에 웹 포트가 있으면 `.claude/launch.json`의 포트보다 그것을 쓴다(launch.json 은 고치지 않는다. 그 포트가 다르면 launch.json 대신 개발 명령을 직접 띄운다). 개발 명령이 포트를 받는 방식(예: Vite `--port`, 위치 인자, `PORT` 환경 변수)을 스크립트에서 확인해 그 포트로 띄우고, 실제로 그 포트에서 듣는지(`lsof -nP -iTCP:<포트> -sTCP:LISTEN`) 확인한 뒤 화면 URL 에 쓴다. 백엔드 서버도 띄워야 하면 같은 방식으로 서버 포트에 띄우고, 웹이 백엔드 주소를 받는 곳(프록시 대상, `VITE_API_URL` 같은 환경 변수)도 파일을 고치지 않고 명령 인자나 환경 변수로 그 서버 포트를 가리키게 한다. 빌드에서만 보이는 변경은 빌드 후 미리보기.
- 에이전트에 항목 파일 경로, 화면 URL, 뷰포트, 고친 지적 목록을 넘긴다. 어떻게 고쳤는지는 넘기지 않는다.
- 뷰포트는 CLAUDE.md 에 정한 것, 없으면 데스크톱. 반응형 레이아웃을 고쳤으면 휴대폰(375×812)도.
- "실패"는 다시 고친다. 에이전트가 "브라우저 도구 없음"이라고 하면 직접 확인하고(`chrome-devtools` 스킬이 있으면 그것, 없으면 앱의 내장 브라우저) 직접 했다고 적는다. 직접도 할 수 없으면 멈추고 알린다.

## 돌려줄 형식

```markdown
### frontend end check
검사: 실패 1건 (나머지 통과)
- src/lib/a.ts:12 — console.log 남음

#### 리뷰에 넣을 에이전트
- `frontend:frontend-reviewer` — 근거: src/routes/login/+page.svelte, … (svelte)
- `frontend:design-reviewer` — 근거: http://localhost:5007/login, DESIGN.md, src/routes/login/+page.svelte

#### 고친 뒤 할 것
- 고친 화면을 `frontend:frontend-evaluator`로 확인
```

실패가 없으면 "검사: 모두 통과"라고 한 줄로 쓴다.
