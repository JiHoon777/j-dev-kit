---
name: frontend-start-check
description: 프론트엔드 프로젝트의 작업 전 점검. workflow 플러그인 task 스킬의 start 모드가 부른다. 프레임워크를 감지하고, 구현 중 지킬 것(frontend-design, 프레임워크 규칙, 브라우저 확인)과 플랜에 넣을 것을 돌려준다. 프레임워크별 내용은 references(svelte.md, react.md)에 있다.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# 프론트엔드 시작 점검

`/task start`가 부른다. 고치지 않고, 명령도 거의 돌리지 않는다. 이 항목에 맞는 것만 돌려준다. 보고는 프로젝트의 언어로.

## 0. 해당 여부

- CLAUDE.md 에 frontend 가 빠진 `stack:` 줄이 있거나, package.json `dependencies`·`devDependencies`에 react, next, vue, nuxt, svelte, @sveltejs/kit, solid-js, @angular/core, astro 가 하나도 없으면 → "해당 없음"만 돌려준다.
- 모노레포면 이 항목이 건드리는 앱을 정한다. 분명하지 않으면 물을 것으로.
- 프레임워크를 감지하고 맞는 reference 를 Read 도구로 끝까지 읽는다. 여럿이면 모두.

  | package.json 에 | reference |
  | --- | --- |
  | `svelte` | `${CLAUDE_SKILL_DIR}/references/svelte.md` |
  | `react` | `${CLAUDE_SKILL_DIR}/references/react.md` |

## 1. 지킬 것

이 항목에 해당하는 것만 돌려준다.

- **새 화면이나 다시 디자인:** `frontend-design` 스킬을 부르고 따른다. 색과 글꼴은 프로젝트의 디자인 토큰 안에서 고르고, 새로 더하려면 먼저 묻는다. 승인된 디자인이나 CLAUDE.md 의 제품 원칙이 있으면 그것이 먼저다. 기존 화면을 그대로 옮기는 항목에는 부르지 않는다.
- **새 웹 기능·UI 패턴을 고를 때**(다이얼로그, 팝오버, 레이아웃, 폼 검증 등): `modern-web-guidance` 스킬이 있으면 부른다.
- **브라우저 확인**(UI 가 바뀌면, 구현 마무리에):
  - 도구: `chrome-devtools` 스킬이 있으면 그것, 없으면 앱의 내장 브라우저. 둘 다 없으면 멈추고 알린다.
  - 개발 서버를 띄운다(`.claude/launch.json`이 있으면 그것). 빌드에서만 보이는 변경(서비스 워커, 정적 생성)은 빌드 후 미리보기.
  - 각 Acceptance Criteria 를 사용자처럼 따라간다. 콘솔 오류와 실패한 요청(4xx/5xx)이 없어야 한다.
  - 뷰포트는 CLAUDE.md 에 정한 것, 없으면 데스크톱. 반응형 레이아웃을 바꿨으면 휴대폰(375×812)도.
- reference 의 프레임워크 규칙.

## 2. 플랜에 넣을 것 / 물을 것

- 새 화면이나 다시 디자인하는 항목인데 디자인·명세가 없으면 물을 것으로.
- reference 가 더하는 것.

## 돌려줄 형식

```markdown
### frontend start check
감지: svelte 5 (references/svelte.md 읽음)

#### 지킬 것
- …

#### 플랜에 넣을 것
- …

#### 물을 것
- …
```

내용이 없는 섹션은 빼고 돌려준다.
