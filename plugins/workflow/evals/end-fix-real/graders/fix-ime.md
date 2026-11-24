---
type: llm
focus:
  source: file
  path: src/routes/line/Compose.svelte
---

파일 `src/routes/line/Compose.svelte`의 지금 내용을 본다. Enter 키 처리(`onkeydown`)가 `event.keyCode === 229`일 때도 보내지 않으면(기존 `isComposing`·`shiftKey` 확인은 그대로) PASS. 229 를 보지 않거나 Enter 보내기가 아예 망가졌으면 FAIL.
