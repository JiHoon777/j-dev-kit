---
type: regex
target:
  source: file
  path: src/lib/core/time.ts
pattern: '005'
match: not_contains
---

공용 파일의 머리 주석에 다른 항목(005)의 계획이 없다. 리뷰 전 파일에는 "005"가 이 주석에만 나온다.
