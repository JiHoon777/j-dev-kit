> 번역본입니다. 원문은 [plugins/frontend/skills/frontend-end-check/references/svelte.md](../../../../../../../plugins/frontend/skills/frontend-end-check/references/svelte.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# Svelte 5 / SvelteKit: 마무리 점검

package.json에 `svelte`가 있을 때 `frontend-end-check`가 읽는다. 아래 행, 에이전트, 고친 뒤 할 항목을 그 스킬의 보고서에 더한다.

이 파일은 도구를 실행하고 결과를 비교하기만 한다. diff를 읽고 판단하는 리뷰(룬, SSR, 서버/클라이언트 경계, load와 form action, …)는 `frontend:svelte-reviewer` 에이전트에게 넘긴다(3단계).

`.svelte`, `.svelte.ts`, `.svelte.js`, SvelteKit 라우트 파일(`+page*`, `+layout*`, `+server*`, `hooks.*`) 중 바뀐 것이 없으면 1단계만 하고 나머지는 "Svelte 변경 없음"으로 건너뛴다.

## 1. sv check(기준선과 비교)

`### Baseline`과 같은 명령을 실행한다. 새 오류 → 실패. 새 경고(접근성 경고 포함) → 실패. Svelte의 접근성 경고는 실제 사용자 문제다. 쓰지 않는 CSS 경고는 근거에만 넣는다.

## 2. svelte-autofixer

바뀐 `.svelte`, `.svelte.ts`, `.svelte.js` 파일을 **모두** `svelte-autofixer`에 돌린다(MCP 도구, 없으면 `npx -y @sveltejs/mcp@0.1.28 svelte-autofixer <파일> --svelte-version 5`). 남은 문제가 있으면 → 실패. 제안은 근거에 넣는다. 이것이 잡는 것: `$effect` 안의 대입, `$derived`에 함수 넘기기, 룬 import, 룬 대신 store, `$app/state` 대신 `$app/stores`, clsx 대신 `class:`, attachment 제안 등.

## 3. 리뷰에 넣을 에이전트

위의 Svelte 파일 중 하나라도 바뀌었으면 근거(바뀐 파일 목록과 2단계에서 남은 제안)와 함께 `frontend:svelte-reviewer`를 돌려준다. 이 에이전트는 룬 사용, `$effect` 정리, SSR, 비공개 환경 변수, load와 form action, 어댑터, `{@html}`, each 키, 옛 문법을 리뷰한다.

## 더할 행

```markdown
| sv check | … | 0 new errors, 0 new warnings (existing …) |
| svelte-autofixer | … | N files, 0 issues left, suggestions … |
```

고친 뒤 할 것: 고친 `.svelte` 파일에 `svelte-autofixer`를 다시 돌린다.
