---
type: llm
focus:
  source: file
  path: src/lib/core/line.ts
---

파일 `src/lib/core/line.ts`의 지금 내용을 본다. `normalizeLine`이 60자(UTF-16)로 자른 끝이 짝 없는 상위 서로게이트(0xD800~0xDBFF)이면 그 한 칸을 빼서, 이모지 반쪽이 남지 않게 하면 PASS(코드 포인트 단위로 자르는 등 같은 결과를 내는 다른 방법도 PASS, 다만 결과가 60 UTF-16 단위를 넘으면 FAIL). 그대로 `.slice(0, 60)`만 하면 FAIL.
