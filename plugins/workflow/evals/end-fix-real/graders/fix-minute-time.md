---
type: regex
target:
  source: file
  path: src/lib/core/time.ts
pattern: 'export\s+const\s+MINUTE\b'
match: contains
---

`time.ts`가 `MINUTE`를 export 한다.
