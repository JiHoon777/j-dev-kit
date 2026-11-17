---
name: supabase-end-check
description: Supabase 프로젝트의 작업 끝 점검. CLI 와 SQL 로 빠진 마이그레이션, 처음부터 다시 적용하기, 순서, RLS·뷰·함수 설정, 다른 사용자로 행이 보이는지, 타입, 키 노출을 확인한다. Supabase 쪽이 바뀌었으면 rls-reviewer 에이전트를 리뷰에 넣어야 한다고 돌려준다. workflow 플러그인의 `/task end`가 부른다.
user-invocable: false
version: "0.4.1"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> 번역본입니다. 원문은 [plugins/supabase/skills/supabase-end-check/SKILL.md](../../../../../../plugins/supabase/skills/supabase-end-check/SKILL.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# Supabase 종료 점검

`/task end`가 부른다. 보고서는 프로젝트의 언어로 쓴다. 각 항목을 **통과 · 실패 · 건너뜀(이유)** 중 하나로 판정하고, 결과를 맨 아래 형식으로 돌려준다. 실패가 있으면 `/task end`가 고친 뒤 이 스킬을 다시 부른다.

이 스킬은 **CLI 와 SQL 을 돌리고 결과를 확인하는 것만** 한다. 마이그레이션과 정책을 읽고 판단하는 리뷰(정책이 의도대로 동작하는지, 위험한 변경을 어떻게 다룰지, 악용 가능성)는 직접 하지 않는다. `supabase:rls-reviewer` 에이전트에 넘긴다(10번 항목).

SQL 은 `supabase status`의 DB URL 로 `psql "<DB URL>" -c "<SQL>"`을 써서 돌린다. `psql`이 없으면 SQL 항목은 "psql 없음"으로 건너뛴다.

## 0. 해당 여부

`supabase-start-check`와 같은 기준으로 정한다. 해당하지 않으면 "해당 없음: <이유>". 로컬 스택이 꺼져 있으면 켤지 묻는다. 거절하면 DB 가 필요한 항목은 "로컬 스택 꺼짐"으로 건너뛴다.

마이그레이션 담당은 `supabase-start-check`와 같은 규칙("마이그레이션 담당" 절)으로 정한다. **1~4단계는 supabase 가 마이그레이션을 맡을 때만 돌린다.** 아니면 "건너뜀: 마이그레이션은 server 플러그인 담당"으로 건너뛴다. 5단계부터는 항상 돌린다.

새 마이그레이션 = `git diff --name-only origin/<기준 브랜치>...HEAD -- supabase/migrations`, 그리고 커밋하지 않은 새 파일.

## 1. 마이그레이션이 다 있는가?

1. `supabase db diff`. 출력이 비어 있어야만 통과한다. 뭔가 남아 있으면 실패: 변경이 로컬 DB 에는 있지만 마이그레이션 파일에는 없다. 출력 SQL 을 근거에 붙인다.
2. 스키마가 바뀌었는데(diff 에 테이블, 컬럼, 정책, 함수 변경이 보이는데) 새 마이그레이션이 없으면 실패.

## 2. 처음부터 다시 적용

`supabase db reset`을 돌릴지 **묻는다**(로컬 DB 데이터를 지우고 마이그레이션과 seed 로 다시 만든다). 승인하면 돌리고, 오류 없이 끝나면 통과. 거절하면 "검증 안 함"으로 둔다. 이 항목을 검증하지 않았으면 PR 설명에 적어야 한다고 돌려준다.

## 3. 마이그레이션 순서

새 마이그레이션마다 타임스탬프가 `git ls-tree --name-only origin/<기준 브랜치> supabase/migrations/`의 가장 늦은 타임스탬프보다 늦으면 통과. 이르면 실패: 작업하는 동안 다른 마이그레이션이 기준 브랜치에 들어왔다. 마이그레이션은 원격에 순서대로 적용되므로, 새 파일 이름의 타임스탬프를 현재 시각으로 바꿔야 한다고 돌려준다.

## 4. 위험한 변경 (위치만 찾기)

새 마이그레이션에서 아래 키워드가 있는 줄을 찾아 `file:line`만 기록한다. 있으면 **확인 필요**로 표시한다. 데이터 보존과 롤백을 어떻게 다룰지는 `rls-reviewer`가 정한다.

```bash
grep -niE "drop (table|column)|truncate|delete from|alter column .* type|set not null|not null|create (unique )?index|rename (to|column)" <새 마이그레이션 파일>
```

## 5. RLS 와 보안

1. 시작 점검의 SQL 두 개(RLS 가 꺼진 테이블, 정책이 없는 테이블)를 다시 돌린다. 기준선에 없던 테이블이 나오면 실패.
2. 새 테이블의 정책 목록을 뽑아 근거에 붙인다(정책이 의도대로 동작하는지는 `rls-reviewer`가 본다). `with check`가 없는 update 정책이 있으면 실패.
   ```sql
   select tablename, policyname, cmd, roles, qual, with_check from pg_policies
   where schemaname = 'public' and tablename in (<새 테이블>);

   select tablename, policyname from pg_policies
   where schemaname = 'public' and cmd = 'UPDATE' and with_check is null;
   ```
3. **다른 사용자로 확인한다.** 테스트 사용자 두 명(A, B)의 id 로, 보이는 범위가 인수 조건의 권한 규칙과 맞는지 확인한다. 테스트 사용자가 없으면 seed 나 `auth.users`에서 찾고, 거기도 없으면 만들지 묻는다.
   ```sql
   begin;
   set local role authenticated;
   select set_config('request.jwt.claims', '{"sub":"<A의 id>","role":"authenticated"}', true);
   select count(*) from public.<테이블>;                      -- A 가 볼 수 있는 행만
   select count(*) from public.<테이블> where user_id = '<B의 id>';  -- 0 이어야 한다 (규칙에 따라)
   rollback;
   ```
   `anon`으로도 같은 확인을 한다(`set local role anon;`). 나온 개수를 근거에 기록한다.
4. **뷰**: 새 뷰가 `security_invoker` 없이 만들어졌으면 실패.
   ```sql
   select c.relname, c.reloptions from pg_class c
   where c.relkind = 'v' and c.relnamespace = 'public'::regnamespace;
   ```
5. **함수**: 새 `security definer` 함수가 `search_path`를 고정하지 않았으면 실패.
   ```sql
   select p.proname from pg_proc p
   where p.pronamespace = 'public'::regnamespace and p.prosecdef
     and coalesce(array_to_string(p.proconfig, ','), '') not like '%search_path=%';
   ```
6. `supabase db lint`와 `supabase test db`(테스트가 있으면)를 기준선과 비교한다. 새 오류나 새 실패가 있으면 실패.
7. 새 권한 규칙이 pgTAP 테스트로 남지 않았으면 "나중에"에 넣어 돌려준다.

## 6. 타입

`supabase-start-check` 4단계와 같은 방법으로 임시 파일에 생성해 저장소의 타입 파일과 비교한다. 다르면 실패: 타입을 다시 생성해 커밋해야 한다.

## 7. 키와 시크릿

명령으로 찾는다. 값을 근거에 옮겨 적지 않는다.

```bash
grep -rnE "sb_secret_|service_role|SERVICE_ROLE|eyJ[A-Za-z0-9_-]{20,}" --exclude-dir=node_modules --exclude-dir=build --exclude-dir=.next --exclude-dir=.svelte-kit .
```

`eyJ` 토큰이 나오면 가운데 부분을 디코드해 `role`이 `anon`인지 확인한다(anon 키는 공개돼도 된다).

다음 중 하나라도 나오면 실패다(`role`이 `anon`인 `eyJ` 토큰은 괜찮다).

- 클라이언트에서 쓰는 파일(브라우저 번들에 들어가는 코드)이나 공개 접두어가 붙은 환경 변수(`NEXT_PUBLIC_`, `VITE_` 등)에 `service_role`, `SERVICE_ROLE`, `sb_secret_`이 나온다.
- JWT 모양의 문자열(`eyJ`로 시작하는 긴 문자열)이나 키가 코드, 마이그레이션, seed 에 박혀 있다.
- Edge Function 시크릿이 파일로 커밋돼 있다(`supabase/functions/.env` 등). 시크릿은 `supabase secrets set`으로 설정한다.

## 8. Edge Function

`supabase/functions/`가 바뀌었으면 `supabase functions serve <이름>`으로 띄우고, 인수 조건의 요청을 curl 로 보내 상태 코드와 응답을 근거에 기록한다. 인증이 필요한 함수는 Authorization 헤더 없이도 요청을 보내 401을 돌려주는지 확인한다.

## 9. Advisors (선택)

이 플러그인의 읽기 전용 MCP 서버(`mcp__plugin_supabase_supabase-readonly__*`)가 연결돼 있으면, 이번 변경을 적용한 환경의 프로젝트(그 환경 env 파일의 ref)에 `get_advisors`를 `security`, `performance`로 한 번씩 부른다. 새로 생긴 지적을 근거에 적는다. 연결이나 인증이 안 돼 있으면 "어드바이저 확인 안 함(이유)"으로 건너뛴다. `mcp__plugin_supabase_supabase__*` 도구는 절대 쓰지 않는다.

## 10. 리뷰에 넣을 에이전트

아래 중 하나라도 바뀌었으면 `/task end`의 리뷰 단계에 `supabase:rls-reviewer`를 넣어야 한다고 돌려준다. 근거(바뀐 파일), 4단계에서 찾은 위험한 변경 위치(supabase 가 마이그레이션을 맡을 때만. 아니면 `server:api-reviewer`가 판단한다), 5단계의 정책 목록과 다른 사용자 확인 결과를 함께 넘긴다. 이 에이전트는 정책이 의도대로 동작하는지, 악용 가능성, 위험한 마이그레이션 처리, 정책 성능을 본다.

- `supabase/` 아래 파일
- Supabase 를 부르는 코드(`.from(`, `.rpc(`, `.channel(`, `auth.`, `storage.`)
- 브라우저 저장소(`localStorage`)만 쓰는 변경은 치지 않는다.

## 돌려줄 형식

```markdown
### supabase end check
| Item | Result | Evidence |
| --- | --- | --- |
| Migration owner | … | supabase (supabase/migrations) / server (prisma) |
| Missing migrations | pass | no `db diff` output |
| Apply from scratch | … | `db reset` exit 0 / not verified |
| Order | … | new 20261117…, latest on base 20261110… |
| Risky change locations | needs review | 2026…_orders.sql:4 drop column |
| RLS and policies | … | … |
| Other-user check | … | A: 3 rows, B's rows queried as A: 0, anon: 0 |
| Views and functions | … | … |
| Lint and DB tests | … | 0 new errors |
| Types | … | … |
| Keys and secrets | … | … |
| Edge Function | skip | no changes |
| Advisors | skip | no MCP connection |

#### Failure details
- `file:line` what the problem is, how to fix it

#### Agents to add to the review
- `supabase:rls-reviewer` — evidence: added supabase/migrations/2026…_orders.sql

#### After fixes
- If any migration was fixed, rerun the `db diff`, RLS, and types checks (steps 1, 5, 6)
- (If there are risky changes) confirm the backup and rollback plan with the user

#### Later
- Permission rules to capture in pgTAP: …
```
