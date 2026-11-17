---
name: svelte-end-check
description: Svelte·SvelteKit 프로젝트의 작업 마무리 점검. 바뀐 .svelte 파일 전부를 svelte-autofixer 로 확인하고, sv check 를 기준선과 비교하고, 룬·SSR·load·form action·{@html} 같은 Svelte 전용 문제를 diff 에서 찾아 돌려준다. workflow 의 task-end 가 부른다.
user-invocable: false
version: "0.1.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# Svelte 종료 점검

`task-end`가 부른다. 공통 프론트 점검과 브라우저 테스트는 `frontend` 플러그인이 한다.

각 항목을 **통과 · 실패 · 건너뜀(이유)**으로 판정하고 맨 아래 형식으로 돌려준다.

## 0. 해당 여부

`svelte-start-check`와 같은 기준. 해당 없으면 "해당 없음". 바뀐 파일에 `.svelte`·`.svelte.ts`·`.svelte.js`·SvelteKit 라우트 파일(`+page*`, `+layout*`, `+server*`, `hooks.*`)이 없으면 1만 하고 나머지는 "Svelte 변경 없음"으로 건너뛴다.

## 1. sv check (기준선과 비교)

`### 기준선`과 같은 명령을 다시 돌린다. 새 오류가 있으면 실패. 새 경고(접근성 경고 포함)는 실패로 본다. Svelte 의 접근성 경고는 실제 사용자 문제이기 때문이다. 쓰지 않는 CSS 경고는 근거에만 적는다.

## 2. svelte-autofixer

바뀐 `.svelte`·`.svelte.ts`·`.svelte.js` 파일 **전부**를 `svelte-autofixer`로 돌린다(MCP 도구, 없으면 `npx -y @sveltejs/mcp@0.1.28 svelte-autofixer <파일> --svelte-version 5`). 문제(issues)가 하나라도 남으면 실패, 제안(suggestions)은 근거에 적는다. 이 도구가 잡는 것: `$effect` 안 대입, `$derived`에 함수 넘기기, 룬 import, 스토어 대신 룬, `$app/stores` 대신 `$app/state`, `class:` 대신 clsx, 첨부(attachment) 제안 등.

## 3. diff 점검 (도구가 못 잡는 것)

- **SSR:** 컴포넌트 최상위 코드나 universal `load`(`+page.ts`, `+layout.ts`)에서 `window`·`document`·`localStorage` 접근.
- **비밀값:** `$env/static/private`·`$env/dynamic/private`를 서버 파일(`*.server.*`, `hooks.server.*`) 밖에서 import. universal `load`에서 비밀 키나 내부 주소 사용.
- **form action:** 검증 실패를 `fail(400, …)`이 아니라 `throw`나 일반 반환으로 처리. 리다이렉트를 `redirect()` 없이 처리.
- **어댑터:** `adapter-static`인데 서버 파일·form action·`+server.*`이 새로 생김.
- **`{@html}`:** 새로 쓴 곳이 있으면 넣는 값이 사용자 입력이 아닌지 확인. 사용자 입력이면 실패.
- **`{#each}` key:** 추가·삭제·정렬되는 목록에 `(key)`가 없음.
- **정리:** `$effect`에서 타이머·구독·이벤트를 만들고 정리 함수를 돌려주지 않음.

## 4. 리뷰에 넣을 에이전트

없음.

## 돌려줄 형식

```markdown
### svelte 종료 점검
| 항목 | 결과 | 근거 |
| --- | --- | --- |
| sv check | … | 새 오류 0, 새 경고 0 (기존 …) |
| svelte-autofixer | … | 파일 N개, 남은 문제 0 |
| SSR | … | … |
| 비밀값 | … | … |
| form action | … | … |
| 어댑터 | … | … |
| {@html} | … | … |
| each key | … | … |
| $effect 정리 | … | … |

#### 실패 상세
- `파일:줄` 무엇이 문제인지, 고치는 법

#### 리뷰에 넣을 에이전트
- 없음

#### 고친 뒤 할 것
- 고친 .svelte 파일 svelte-autofixer 다시 돌리기
```
