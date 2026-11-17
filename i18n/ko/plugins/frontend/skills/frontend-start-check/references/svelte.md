> 번역본입니다. 원문은 [plugins/frontend/skills/frontend-start-check/references/svelte.md](../../../../../../../plugins/frontend/skills/frontend-start-check/references/svelte.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# Svelte 5 / SvelteKit: 시작 점검

package.json에 `svelte`가 있을 때 `frontend-start-check`가 읽는다. 아래 행, 기준선 줄, 지시문, 규칙을 그 스킬의 보고서에 더한다.

| 부분 | 출처 |
| --- | --- |
| 문서 조회, autofixer, 코드 작성 규칙 | 공식 Svelte 플러그인 `svelte@svelte`(MCP `list-sections`, `get-documentation`, `svelte-autofixer`; 스킬 `svelte-code-writer`, `svelte-core-bestpractices`), 그대로 호출. 권장이며 필수는 아님 |
| 타입·접근성 점검 | `sv check` (`svelte-check`) |

## 1. 버전과 구조

- 설치된 `svelte`와 `@sveltejs/kit` 버전을 기록한다(`node_modules/<패키지>/package.json`의 `version`). Svelte가 4 이하면 뒤의 규칙이 다르다는 것과 업그레이드는 이 항목의 범위 밖이라는 것을 말한다.
- SvelteKit이면 어댑터(`svelte.config.js`의 `adapter-*`)를 기록한다. `adapter-static`이면 서버 코드(`+page.server.*`, `+server.*`, form action)를 쓸 수 없다는 것을 구현 중 지킬 것에 더한다.
- 남아 있는 옛 패턴을 `grep`으로 센다. 실패는 아니다. 개수를 근거에 넣는다. 새 코드는 새 패턴을 쓴다.
  - `$app/stores` import → `$app/state` (`npx -y sv@1.2.0 migrate app-state`로 옮길 수 있다)
  - `export let`, `$:`, `on:click`, `<slot>` 같은 Svelte 4 문법이 있는 `.svelte` 파일

## 2. 기준선

- 프로젝트의 타입 체크 명령(보통 `check` 스크립트: `svelte-kit sync && svelte-check …`), 없으면 `npx -y sv@1.2.0 check --output machine`.
- 오류와 경고의 수, 파일을 기록한다(많으면 개수와 처음 10개). 기존 오류와 경고는 **기준선**이다.

## 3. autofixer 사용 가능 여부

- `svelte-autofixer`를 실행할 수 있는지 확인한다: Svelte 플러그인이 있으면 그 MCP 도구, 없으면 CLI `npx -y @sveltejs/mcp@0.1.28 svelte-autofixer <파일> --svelte-version 5`.
- 둘 다 안 되면 → 실패(구현 중에 파일을 자동으로 점검할 수 없다). Svelte 플러그인이 설치되어 있지 않으면 설치를 제안한다(`/plugin marketplace add sveltejs/ai-tools`, 그다음 `/plugin install svelte@svelte`).

## 4. 탐색에 넣을 지시문(돌려줄 것)

> 이 항목(<항목 경로>)을 위해 이 Svelte 코드베이스가 어떻게 짜여 있는지 요약한다: `src/routes` 아래 라우트와 레이아웃 구조, 상태가 있는 곳(룬을 쓰는 `.svelte.ts` 모듈, context, store), 데이터를 불러오는 방식(`load` 함수, 클라이언트 fetch, form action), 공용 컴포넌트. 이 항목과 비슷한 기존 기능 하나를 끝까지 따라가 보고, 꼭 읽어야 할 파일 5–10개를 돌려준다. 파일을 고치지 않는다.

## 5. 구현 중 지킬 것(돌려줄 것)

- `.svelte`, `.svelte.ts`, `.svelte.js` 파일을 만들거나 고칠 때는 Svelte 플러그인의 `svelte-code-writer` 스킬을 호출해 따른다. 룬이나 상태 설계가 걸려 있으면 `svelte-core-bestpractices`도 호출한다.
- 모르는 API를 추측하지 않는다. Svelte MCP의 `list-sections` → `get-documentation`으로 공식 문서를 읽는다.
- **고친 `.svelte` 파일은 모두 `svelte-autofixer`에 돌린다.** MCP 도구가 있으면 그것을, 없으면 `npx -y @sveltejs/mcp@0.1.28 svelte-autofixer <파일 경로> --svelte-version 5`를 쓴다. 문제나 제안이 남지 않을 때까지 고친다.
- 파생 값은 `$derived`를 쓴다. `$effect` 안에서 state에 대입해 파생 값을 만들지 않는다.
- 컴포넌트 최상위 코드에서 `window`, `document`, `localStorage`를 쓰지 않는다(서버 렌더링과 프리렌더링이 깨진다). `onMount`, `$effect` 안이나 `browser` 확인 뒤에 쓴다.
- 다른 사람이 쓴 값을 `{@html}`로 절대 넣지 않는다.
- SvelteKit `load`와 form action: 시크릿이 필요한 코드는 `+page.server.*`에만 두고(`$env/static/private`는 서버 파일에서만), 실패는 `fail()`을 반환한다. 정적 어댑터면 서버 파일을 만들지 않는다.

## 더할 행

```markdown
| Svelte versions | pass | svelte 5.x, @sveltejs/kit 2.x, adapter-static |
| Old patterns | … | $app/stores 2, Svelte 4 syntax files 0 |
| Autofixer | … | MCP tool / CLI |
```

기준선 줄: `| sv check | pnpm check | errors 0, warnings 2 |`
