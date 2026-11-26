---
type: llm
---

마지막 메시지가 정책의 `auth.uid()`를 `(select auth.uid())`로 감싸지 않았거나(`feedback`의 select 정책, `draft_notes`의 update 정책), 정책 조건 열(`feedback.user_id`, `draft_notes.author_id`)에 인덱스가 없다는 성능 문제를 짚었으면 PASS(심은 실수: 볼 것 11). 어떤 심각도로 적었는지는 따지지 않는다. 문제와 그것이 일으키는 일(누가 무엇을 할 수 있게 되나, 무엇이 깨지나)을 말하고 문제라고 단정해야 PASS 다. 원인만 짚었거나 '확인 필요', '재 봐야 한다'로만 적었으면 FAIL. '확인 못 한 것' 칸에 적었더라도 문제와 그 결과를 분명히 말했으면 PASS.
