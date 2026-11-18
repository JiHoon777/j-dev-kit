# Svelte 5 / SvelteKit: 시작 점검

package.json 에 `svelte`가 있을 때 `frontend-start-check`가 읽는다. 아래를 그 스킬의 "지킬 것"에 더한다.

공식 Svelte 플러그인(`svelte@svelte`)이 있으면 그 스킬과 MCP 도구를 쓴다. 없어도 아래 CLI 로 된다.

## 지킬 것

- `.svelte`, `.svelte.ts`, `.svelte.js`를 만들거나 고칠 때 `svelte-code-writer` 스킬이 있으면 부른다.
- 모르는 API 는 추측하지 않는다. Svelte MCP 의 `list-sections` → `get-documentation`으로 문서를 본다.
- 고친 Svelte 파일은 `svelte-autofixer`로 확인한다: MCP 도구, 없으면 `npx -y @sveltejs/mcp@0.1.28 svelte-autofixer <파일> --svelte-version 5`. 종료 코드가 아니라 출력으로 판단하고, 이번에 쓴 코드에서 나온 문제는 없어질 때까지 고친다. 손대지 않은 기존 코드의 문제는 고치지 않고 알리기만 한다(항목 범위 밖이다).
- 파생 값은 `$derived`. `$effect` 안에서 state 에 대입해 만들지 않는다.
- 컴포넌트 최상위에서 `window`, `document`, `localStorage`를 쓰지 않는다. `onMount`, `$effect` 안이나 `browser` 확인 뒤에.
- 다른 사람이 쓴 값을 `{@html}`로 넣지 않는다.
- 비밀 값이 필요한 코드는 `+page.server.*`에만(`$env/static/private`는 서버 파일에서만). form action 실패는 `fail()`.
- `adapter-static`이면 서버 파일(`+page.server.*`, `+server.*`, form action)을 만들지 않는다.
- 새 코드에 Svelte 4 문법(`export let`, `$:`, `on:click`, `<slot>`, `$app/stores`)을 쓰지 않는다.

## 물을 것

설치된 `svelte`가 4 이하면 위 규칙이 맞지 않는다고 알리고 어떻게 할지 묻는다.
