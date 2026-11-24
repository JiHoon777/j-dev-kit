---
type: regex
target:
  source: file
  path: src/lib/core/line.ts
pattern: 'const\s+MINUTE\s*='
match: not_contains
---

`line.ts`가 `MINUTE`를 스스로 정의하지 않는다(`./time.js`에서 가져다 쓴다).
