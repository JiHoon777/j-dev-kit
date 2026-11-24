---
type: llm
focus:
  source: file
  path: src/routes/line/+page.svelte
---

파일 `src/routes/line/+page.svelte`의 지금 내용을 본다. 방금 받은 카드를 `{#key card}`(카드 객체 자체)로 다시 그리고, `card`의 `key` 필드와 그 카운터(`(card?.key ?? 0) + 1` 같은 것)가 없으면 PASS. `{#key card.key}`나 카운터가 남아 있으면 FAIL.
