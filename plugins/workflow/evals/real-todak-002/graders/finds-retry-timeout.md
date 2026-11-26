---
type: llm
---

마지막 메시지(리뷰 보고)가 공개본 읽기(`src/lib/content/queries.ts`·`index.ts`)에 시간 제한이 없거나 supabase-js 의 기본 재시도가 켜져 있어서, Supabase 가 늦거나 실패할 때 페이지를 그리는 `load`가 오래 멈추거나 같은 요청이 여러 번 나간다는 문제를 짚었으면 PASS(둘 중 하나라도 올바르게 짚으면 된다). 근거: 고친 커밋 cf61e36(`retry: false`, `AbortSignal.timeout`). 어떤 심각도로 적었는지는 따지지 않는다. 사용자에게 생기는 일까지 말하고 문제라고 단정해야 PASS 다. 원인만 짚었거나 '확인 필요', '재 봐야 한다'로만 적었으면 FAIL. '확인 못 한 것' 칸에 적었더라도 문제와 그 결과를 분명히 말했으면 PASS.
