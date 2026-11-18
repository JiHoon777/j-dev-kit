---
name: frontend-end-check
description: 프론트엔드 프로젝트의 마무리 점검. workflow 플러그인 task 스킬의 end 모드가 부른다. 프론트엔드 코드가 바뀌었을 때만 남은 디버그 코드와 lockfile 을 확인하고 프레임워크 검사 도구를 돌린 뒤, 리뷰에 넣을 frontend-reviewer 와 고친 뒤 할 브라우저 확인을 돌려준다.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# 프론트엔드 마무리 점검

`/task end`가 부른다. 명령을 돌리고 결과만 돌려준다. 코드를 읽고 판단하는 리뷰는 `frontend:frontend-reviewer`가 한다. 보고는 프로젝트의 언어로.

## 0. 해당 여부

- `frontend-start-check`와 같은 기준. 해당하지 않으면 "해당 없음".
- `git diff --name-only <기준>...HEAD`에 프론트엔드 코드(컴포넌트, 페이지, 스타일, 클라이언트 로직, package.json)가 없으면 "프론트엔드 변경 없음"만 돌려준다.
- package.json 에 `svelte`가 있으면 `${CLAUDE_SKILL_DIR}/references/svelte.md`를 Read 도구로 끝까지 읽는다. React 는 따로 돌릴 검사가 없다(훅 린트와 빌드는 검증 명령에 들어 있어야 한다).

## 1. 검사

- `git diff <기준>...HEAD -U0`의 추가된 줄에 `console.log`, `debugger`, `.only(`가 있으면 실패.
- package.json 의존성이 바뀌었는데 lockfile 이 바뀌지 않았으면 실패.
- reference 의 검사.

## 2. 리뷰에 넣을 에이전트

UI 코드가 바뀌었으면 `frontend:frontend-reviewer`. 근거로 바뀐 UI 파일 목록과 감지한 프레임워크를 넘긴다.

## 3. 고친 뒤 할 것

리뷰 지적을 고쳐 UI 가 바뀌었으면, 고친 화면에 대해 `frontend-start-check`의 브라우저 확인을 한다. reference 가 더하는 것도.

## 돌려줄 형식

```markdown
### frontend end check
검사: 실패 1건 (나머지 통과)
- src/lib/a.ts:12 — console.log 남음

#### 리뷰에 넣을 에이전트
- `frontend:frontend-reviewer` — 근거: src/routes/login/+page.svelte, … (svelte)

#### 고친 뒤 할 것
- 고친 화면 브라우저 확인
```

실패가 없으면 "검사: 모두 통과"라고 한 줄로 쓴다.
