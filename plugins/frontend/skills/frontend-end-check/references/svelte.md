# Svelte 5 / SvelteKit: 마무리 점검

package.json 에 `svelte`가 있을 때 `frontend-end-check`가 읽는다.

바뀐 `.svelte`, `.svelte.ts`, `.svelte.js` 파일이 없으면 건너뛴다.

## 검사

바뀐 Svelte 파일마다 `svelte-autofixer`를 돌린다(MCP 도구, 없으면 `npx -y @sveltejs/mcp@0.1.28 svelte-autofixer <파일> --svelte-version 5`). 종료 코드가 아니라 출력으로 판단한다. 남은 문제가 있으면 실패. 타입·접근성 경고(`svelte-check`)는 검증 명령에 들어 있으니 여기서 다시 돌리지 않는다.

## 고친 뒤 할 것

고친 Svelte 파일에 `svelte-autofixer`를 다시 돌린다.
