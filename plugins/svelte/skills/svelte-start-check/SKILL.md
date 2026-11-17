---
name: svelte-start-check
description: Svelte·SvelteKit 프로젝트의 작업 시작 전 점검. Svelte·SvelteKit 버전과 남은 옛 문법, sv check 기준선을 확인하고, 구현 중 지킬 것(svelte 공식 플러그인의 스킬과 svelte-autofixer, 공식 문서 조회)을 돌려준다. workflow 의 task-start 가 부른다.
user-invocable: false
---

# Svelte 시작 점검

`task-start`가 부른다. 공통 프론트 점검(설치, 환경변수, 브라우저 테스트)은 `frontend` 플러그인이 한다. 여기서는 Svelte 에만 해당하는 것을 한다.

각 항목을 **통과 · 실패 · 건너뜀(이유) · 중단**으로 판정하고 맨 아래 형식으로 돌려준다.

| 부분 | 출처 |
| --- | --- |
| 문서 조회, 자동 교정, 코드 작성 규칙 | Svelte 공식 플러그인 `svelte@svelte` (MCP `list-sections`·`get-documentation`·`svelte-autofixer`, 스킬 `svelte-code-writer`·`svelte-core-bestpractices`) — 그대로 호출 |
| 타입·접근성 검사 | `sv check` (`svelte-check`) |

## 0. 해당 여부

- CLAUDE.md 에 `stack:`이 있고 svelte 가 없으면 → "해당 없음: stack 설정에 없음".
- package.json 에 `svelte`가 없으면 → "해당 없음: Svelte 없음".

## 1. 버전과 구조

- `svelte`와 `@sveltejs/kit`의 설치된 버전(`node_modules/<패키지>/package.json`의 `version`)을 적는다. Svelte 4 이하면 이후 규칙이 다르다고 알리고, 업그레이드는 이 항목의 범위가 아니라고 적는다.
- SvelteKit 이면 어댑터(`svelte.config.js`의 `adapter-*`)를 적는다. `adapter-static`이면 서버 코드(`+page.server.*`, `+server.*`, form actions)를 쓸 수 없다는 것을 "구현 중 지킬 것"에 넣는다.
- 옛 방식이 남아 있는지 본다. 남아 있어도 실패가 아니라 근거에 적는다. 새로 쓰는 코드는 새 방식으로 쓴다.
  - `$app/stores` import → `$app/state`(`npx sv migrate app-state`로 옮길 수 있다)
  - `export let`, `$:`, `on:click`, `<slot>` 같은 Svelte 4 문법이 있는 `.svelte` 파일 수

## 2. 기준선

- 프로젝트의 타입 검사 명령(보통 `check` 스크립트: `svelte-kit sync && svelte-check …`)이 있으면 그것, 없으면 `npx sv check --output machine`.
- 오류·경고 개수와 파일 목록(많으면 개수와 앞 10개)을 적는다. 이미 있는 오류·경고는 **기준선**이다.

## 3. Svelte 플러그인 연결 확인

- `svelte-autofixer`를 쓸 수 있는지 본다: Svelte 플러그인의 MCP 도구가 있으면 그것, 없으면 CLI `npx -y @sveltejs/mcp svelte-autofixer <파일> --svelte-version 5`.
- 둘 다 안 되면 실패로 표시한다(구현 중 자동 교정을 못 한다).

## 4. 구현 중 지킬 것 (돌려줄 내용)

- `.svelte`·`.svelte.ts`·`.svelte.js` 파일을 만들거나 고칠 때 Svelte 플러그인의 `svelte-code-writer` 스킬을 부르고 그 방식대로 쓴다. 룬·상태 설계가 걸리면 `svelte-core-bestpractices`도 부른다.
- 모르는 API 는 짐작하지 않고 Svelte MCP 의 `list-sections` → `get-documentation`으로 공식 문서를 읽는다.
- **고친 `.svelte` 파일은 매번 `svelte-autofixer`를 거친다.** MCP 도구가 있으면 그것을, 없으면 `npx -y @sveltejs/mcp svelte-autofixer <파일 경로> --svelte-version 5`. 문제와 제안이 없어질 때까지 고친다.
- 파생 값은 `$derived`로 만든다. `$effect` 안에서 상태에 값을 대입해 파생 값을 만들지 않는다.
- 컴포넌트 최상위 코드에서 `window`·`document`·`localStorage`를 쓰지 않는다(서버 렌더링·미리 그리기에서 깨진다). `onMount`나 `$effect`, `browser` 확인 뒤에 쓴다.
- 남이 쓴 값을 `{@html}`로 넣지 않는다.
- SvelteKit `load`·form action 을 쓰면: 비밀값이 필요한 코드는 `+page.server.*`에만 두고(`$env/static/private`는 서버 파일에서만), 실패는 `fail()`로 돌려준다. 어댑터가 정적이면 서버 파일을 만들지 않는다.

## 돌려줄 형식

```markdown
### svelte 시작 점검
| 항목 | 결과 | 근거 |
| --- | --- | --- |
| 버전 | 통과 | svelte 5.x, @sveltejs/kit 2.x, adapter-static |
| 옛 방식 | … | $app/stores 2곳, Svelte 4 문법 파일 0 |
| autofixer 연결 | … | MCP 도구 / CLI |

#### 기준선
| 검사 | 명령 | 결과 |
| --- | --- | --- |
| sv check | `pnpm check` | 오류 0, 경고 2 |

#### 구현 중 지킬 것
- (4번 중 이 프로젝트·항목에 해당하는 것)
```
