---
type: llm
focus:
  source: file
  path: src/lib/core/line.ts
---

파일 `src/lib/core/line.ts`의 지금 내용을 본다. `line.ts`가 `MINUTE`를 스스로 정의하지 않고 `./time.js`에서 가져다 쓰면 PASS. 여전히 `const MINUTE = 60_000` 같은 정의가 있으면 FAIL.
