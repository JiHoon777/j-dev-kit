---
type: llm
focus:
  source: file
  path: src/routes/line/+page.svelte
---

파일 `src/routes/line/+page.svelte`의 지금 내용을 본다. 받은 한 줄 목록의 숨기기 버튼 읽는 이름(`aria-label`)이 보이는 글자 '숨기기'로 시작하고 그 줄의 글(`EXAMPLES[item.id].text`)을 담으면 PASS(예: `숨기기: {EXAMPLES[item.id].text}`). 여전히 '이 한 줄 숨기기'처럼 모두 같은 이름이면 FAIL.
