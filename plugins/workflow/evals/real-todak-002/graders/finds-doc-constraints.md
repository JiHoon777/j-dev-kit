---
type: llm
---

마지막 메시지(리뷰 보고)가 마이그레이션의 `published_cases`에 `document`가 JSON 객체인지(`jsonb_typeof(document) = 'object'` 같은 것)나 `format_version`의 범위(`>= 1` 같은 것)를 강제하는 `check` 제약이 없어서 잘못된 행이 들어갈 수 있다는 문제를 짚었으면 PASS(둘 중 하나라도 올바르게 짚으면 된다). 근거: todak 010 항목의 "002 의 리뷰에서 넘어온 것"(사용자가 새 마이그레이션으로 더하기로 한 것). 어떤 심각도로 적었는지는 따지지 않는다. 문제라고 단정해야 PASS 다. '확인 필요'로만 적었으면 FAIL.
