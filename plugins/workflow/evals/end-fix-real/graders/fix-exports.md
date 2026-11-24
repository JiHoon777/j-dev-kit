---
type: regex
target:
  source: file
  path: src/lib/core/line.ts
pattern: 'export\s+type\s+(Example|Received|Sent)\b'
match: not_contains
---

`Example`, `Received`, `Sent` 세 타입의 `export`를 지웠다. 처음엔 llm 채점이었는데, 같은 파일 내용에 PASS 와 FAIL 이 갈려(010 본 실행 9회 중 2회 FAIL, 근거 파일은 PASS 한 실행과 같았다) 결정적인 regex 로 바꿨다.
