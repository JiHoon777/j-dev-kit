---
type: llm
focus:
  source: file
  path: src/routes/line/+page.svelte
---

파일 `src/routes/line/+page.svelte`의 지금 내용을 본다. 받은 한 줄 목록에서 숨기기 버튼을 감싸던 `span`이 없어지고, 그 그리드 자리 클래스(`col-start-2`, `row-span-2`, `row-start-1`, `self-center`)가 버튼에 바로 붙어 있으면 PASS. `span`이 남아 있으면 FAIL.
