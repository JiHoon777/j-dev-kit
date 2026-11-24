# server eval

리뷰어의 고정 체크리스트가 지금 모델에 도움이 되는지 잰다. 모델이 바뀌면 다시 돌린다. 측정 방법은 Anthropic 공식 `skill-creator` 스킬을 따르고, 실행은 `claude plugin eval`로 한다(frontend evals README 참고).

| 사례 | 재는 것 |
| --- | --- |
| `real-todak-002` | 실제 리뷰 사례(todak 002 리뷰 전 `b902a6a`, 기준 `ecc333d`). `supabase-reviewer`가 고친 커밋 `cf61e36`이나 todak 010 항목("002 의 리뷰에서 넘어온 것")이 근거인 지적 3개를 찾는지, 공개본 읽기 정책을 🔴 로 올리지 않는지. 항목 파일에 리뷰 전부터 적혀 있던 지적은 정답에서 뺐다. todak 로컬 저장소가 있는 기계에서만 돈다. 경로는 커밋하지 않는 `evals/todak-src.local`에 한 줄로 쓴다. `--tag real` |
| `supabase-seeded` | 합성 사례(실제 리뷰 아님). todak 010 모양의 코드에 Supabase 일반 규칙(RLS, 인가, RPC, 뷰, 스토리지, 키, 입력 제약, Realtime·Edge Function, 마이그레이션, 정책 성능)마다 실수를 하나씩 심고, 맞게 쓴 테이블 하나를 둔다. 실제 사례와 함께 써서, 리뷰어 항목을 지우는 결정은 두 사례 모두에서 나빠지지 않을 때만 한다(012). `--tag seeded` |
| `api-seeded` | 합성 사례. 같은 코드에서 `api-reviewer`의 쿼리 항목(N+1, 상한 없는 조회·인덱스). `--tag seeded` |
| `plan-todak-010` | `server-start-check` "지킬 것"의 원칙을 실제 항목(todak 010, main `b545b27`)을 계획하는 사례로. 승인된 계획이 없어 원칙(트랜잭션, 비밀 값, 함수 입력·권한)이 계획에 들어가는지 본다. `--tag real-plan` |

다시 돌리기와 판정: frontend evals README 와 같다. 셸 도구는 주지 않는다(fixture 가 diff 를 `review.diff`로 남긴다).
