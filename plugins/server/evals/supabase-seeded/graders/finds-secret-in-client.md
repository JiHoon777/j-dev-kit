---
type: llm
---

마지막 메시지가 `src/lib/admin.ts`가 브라우저 번들에 들어가는 `import.meta.env.VITE_SUPABASE_SECRET_KEY`로 secret(service_role) 키를 써서, 그 키가 누구에게나 노출되고 RLS 를 건너뛴다는 문제를 짚었으면 PASS(심은 실수: 볼 것 7). 어떤 심각도로 적었는지는 따지지 않는다. 문제와 그것이 일으키는 일(누가 무엇을 할 수 있게 되나, 무엇이 깨지나)을 말하고 문제라고 단정해야 PASS 다. 원인만 짚었거나 '확인 필요', '재 봐야 한다'로만 적었으면 FAIL. '확인 못 한 것' 칸에 적었더라도 문제와 그 결과를 분명히 말했으면 PASS.
