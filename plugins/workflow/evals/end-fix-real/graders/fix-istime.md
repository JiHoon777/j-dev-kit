---
type: llm
focus:
  source: file
  path: src/lib/core/line.ts
---

파일 `src/lib/core/line.ts`의 지금 내용을 본다. `isTime`(또는 같은 일을 하는 시각 확인 함수)이 유한한 수 가운데 절댓값 8.64e15 이하만 받고 그 밖은 거르면 PASS. 범위를 보지 않거나 범위가 틀렸으면(예: 0 이상만) FAIL.
