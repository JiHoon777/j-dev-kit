# Svelte 5 / SvelteKit: 시작 점검

package.json 에 `svelte`가 있을 때 `frontend-start-check`가 읽는다. 아래를 그 스킬의 "지킬 것"에 더한다.

## 지킬 것

- `.svelte`, `.svelte.ts`, `.svelte.js`를 만들거나 고칠 때 공식 Svelte 플러그인(`svelte@svelte`)의 `svelte-code-writer`와 `svelte-core-bestpractices` 스킬을 부르고 따른다. 그 플러그인의 `svelte-file-editor` 에이전트는 쓰지 않는다.
- `svelte-autofixer`가 손대지 않은 기존 코드에서 낸 문제는 고치지 않고 알리기만 한다(항목 범위 밖이다). 이번에 쓴 코드에서 나온 문제는 고친다.
- 다른 사람이 쓴 값을 `{@html}`로 넣지 않는다.
- 비밀 값이 필요한 코드는 서버 파일(`+page.server.*`, `+server.*`)에만 둔다(`$env/*/private`는 서버 파일에서만). `load`는 권한을 확인하고 다른 사용자의 데이터를 돌려주지 않는다. form action 실패는 `fail()`.
- `adapter-static`이면 서버 파일(`+page.server.*`, `+server.*`, form action)을 만들지 않는다.

## 물을 것

- 공식 Svelte 플러그인이 설치돼 있지 않으면 묻지 않고 설치한다(README "있으면 좋은 플러그인"의 명령). 설치했다고 계획 전에 할 것에 적어 돌려준다. CLAUDE.md `## 작업 설정`의 `- 공식 스킬 설치 안 함:` 줄에 `svelte`가 있으면 설치하지 않는다.
- 설치된 `svelte`가 4 이하면 위 규칙이 맞지 않는다고 알리고 어떻게 할지 묻는다.
