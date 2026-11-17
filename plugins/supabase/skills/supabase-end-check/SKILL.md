---
name: supabase-end-check
description: Supabase 프로젝트의 작업 마무리 점검. 스키마 변경이 전부 마이그레이션에 담겼는지, 처음부터 다시 적용해도 되는지, 마이그레이션 순서, 위험한 변경, RLS·뷰·함수 보안, 다른 사용자로 행이 보이는지, 타입 재생성, 키 노출을 확인해 돌려준다. workflow 의 task-end 가 부른다.
user-invocable: false
version: "0.2.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# Supabase 종료 점검

`task-end` 가 부른다. 각 항목을 **통과 · 실패 · 건너뜀(이유)** 으로 판정하고 맨 아래 형식으로 돌려준다. 실패는 `task-end` 가 고친 뒤 이 스킬을 다시 부른다.

SQL 은 `supabase status` 의 DB URL 로 `psql "<DB URL>" -c "<SQL>"` 로 돌린다. `psql` 이 없으면 SQL 항목은 "psql 없음"으로 건너뛴다.

## 0. 해당 여부

`supabase-start-check` 와 같은 기준으로 판단한다. 해당 없으면 "해당 없음: <이유>". 로컬 스택이 꺼져 있으면 켤지 묻고, 거절하면 DB 가 필요한 항목은 "로컬 스택 꺼짐"으로 건너뛴다.

새 마이그레이션 = `git diff --name-only origin/<기준 브랜치>...HEAD -- supabase/migrations` 와 미커밋 새 파일.

## 1. 마이그레이션이 전부인가

1. `supabase db diff`. 출력이 비어 있어야 통과. 남아 있으면 실패: 로컬 DB 에는 있는데 마이그레이션 파일에 없는 변경이다. 출력 SQL 을 근거에 붙인다.
2. 스키마를 바꿨는데(diff 에 테이블·컬럼·정책·함수 변경이 보이는데) 새 마이그레이션이 없으면 실패.

## 2. 처음부터 다시 적용

`supabase db reset` 을 할지 **묻는다**(로컬 DB 데이터가 지워지고 마이그레이션과 seed 로 다시 만든다). 승인하면 돌리고, 에러 없이 끝나야 통과. 거절하면 "확인 못 함"으로 남긴다. 이 항목이 확인 못 함이면 PR 설명에 적도록 돌려준다.

## 3. 마이그레이션 순서

`git ls-tree --name-only origin/<기준 브랜치> supabase/migrations/` 의 가장 늦은 타임스탬프보다 새 마이그레이션의 타임스탬프가 커야 통과. 작으면 실패: 작업 도중 기준 브랜치에 다른 마이그레이션이 들어왔다. 원격에는 순서대로 적용되므로 새 파일 이름의 타임스탬프를 지금 시각으로 바꾸라고 돌려준다.

## 4. 위험한 변경

새 마이그레이션에서 아래를 찾는다. 있으면 실패가 아니라 **확인 필요**로 표시하고, 데이터 보존 방법(백업, 단계적 변경)과 되돌리는 SQL 을 PR 설명에 쓰도록 돌려준다.

- `drop table`, `drop column`, `truncate`, 조건 없는 `delete from`·`update`
- `alter column … type`(형 변환 중 데이터 손실·테이블 잠금)
- 기존 컬럼에 `not null` 추가(기존 행에 null 이 있으면 실패한다) — 기본값이나 채우는 SQL 이 있는지
- 큰 테이블의 `create index`(`concurrently` 가 아니면 쓰기 잠금)
- 컬럼·테이블 이름 변경(쓰는 쪽 코드가 같이 바뀌었는지)

## 5. RLS 와 보안

1. 시작 점검의 두 SQL(RLS 꺼진 테이블, 정책 없는 테이블)을 다시 돌린다. 기준선에 없던 테이블이 나오면 실패.
2. 새 테이블마다 select·insert·update·delete 정책이 의도대로 있는지 `select * from pg_policies where tablename = '<테이블>';` 로 본다. update 정책에 `with check` 가 없으면 실패.
3. **다른 사용자로 확인한다.** 테스트 사용자 두 명(A, B)의 id 로, 수용 기준의 권한 규칙대로 보이는지 확인한다. 테스트 사용자가 없으면 seed 나 `auth.users` 에서 찾고, 없으면 만들지 묻는다.
   ```sql
   begin;
   set local role authenticated;
   select set_config('request.jwt.claims', '{"sub":"<A 의 id>","role":"authenticated"}', true);
   select count(*) from public.<테이블>;                      -- A 가 볼 수 있는 행만
   select count(*) from public.<테이블> where user_id = '<B 의 id>';  -- 0 이어야 함(규칙에 따라)
   rollback;
   ```
   `anon` 으로도 같은 확인을 한다(`set local role anon;`). 결과 숫자를 근거에 적는다.
4. **뷰**: 새 뷰가 `security_invoker` 없이 만들어졌으면 실패.
   ```sql
   select c.relname, c.reloptions from pg_class c
   where c.relkind = 'v' and c.relnamespace = 'public'::regnamespace;
   ```
5. **함수**: `security definer` 인데 `search_path` 를 고정하지 않은 함수가 새로 생겼으면 실패.
   ```sql
   select p.proname from pg_proc p
   where p.pronamespace = 'public'::regnamespace and p.prosecdef
     and coalesce(array_to_string(p.proconfig, ','), '') not like '%search_path=%';
   ```
6. 정책에 `auth.uid()` 가 `(select auth.uid())` 로 감싸지지 않은 곳, 정책 조건 컬럼에 인덱스가 없는 곳은 실패가 아니라 근거에 적는다.
7. `supabase db lint` 와 `supabase test db`(테스트가 있으면)를 기준선과 비교한다. 새 오류·새 실패가 있으면 실패.
8. 새 권한 규칙을 pgTAP 테스트로 남기지 않았으면 "나중에"로 돌려준다.

## 6. 타입

`supabase-start-check` 4와 같은 방법으로 임시 파일에 생성해 저장소의 타입 파일과 비교한다. 다르면 실패: 타입을 다시 생성해 커밋해야 한다.

## 7. 키와 비밀값

diff 와 클라이언트 코드에서 찾는다. 있으면 실패.

- `service_role`, `SERVICE_ROLE`, `sb_secret_` 가 클라이언트에서 쓰이는 파일(브라우저 번들에 들어가는 코드)이나 공개 접두어 환경변수(`NEXT_PUBLIC_`·`VITE_` 등)에 있음.
- JWT 형태 문자열(`eyJ` 로 시작하는 긴 문자열)이나 키가 코드·마이그레이션·seed 에 직접 들어감.
- Edge Function 비밀값이 파일로 커밋됨(`supabase/functions/.env` 등). 비밀값은 `supabase secrets set` 으로 넣는다.

## 8. Edge Function

`supabase/functions/` 가 바뀌었으면 `supabase functions serve <이름>` 으로 띄우고 수용 기준의 요청을 curl 로 보내 상태 코드와 응답을 근거에 적는다. 인증이 필요한 함수는 Authorization 헤더 없이도 보내 401 이 나오는지 본다.

## 9. 어드바이저 (선택)

Supabase MCP 가 **개발용 프로젝트에 읽기 전용으로** 연결돼 있고 이번 변경이 그 프로젝트에 적용돼 있을 때만 `get_advisors`를 `security`, `performance`로 한 번씩 부른다. 새로 생긴 지적을 근거에 적는다. 실제 서비스 프로젝트이거나 연결이 없으면 "어드바이저 확인 안 함(이유)"으로 건너뛴다.

## 10. 리뷰에 넣을 에이전트

아래 중 하나라도 바뀌었으면 `supabase:rls-reviewer`를 `task-end` 리뷰 단계에 넣으라고 돌려준다. 근거(바뀐 파일)를 같이 적는다.

- `supabase/` 아래 파일
- Supabase 를 부르는 코드(`.from(`, `.rpc(`, `.channel(`, `auth.`, `storage.`)
- 브라우저 저장소(`localStorage`)만 쓰는 변경은 해당하지 않는다.

## 돌려줄 형식

```markdown
### supabase 종료 점검
| 항목 | 결과 | 근거 |
| --- | --- | --- |
| 마이그레이션 누락 | 통과 | `db diff` 출력 없음 |
| 처음부터 적용 | … | `db reset` 종료 0 / 확인 못 함 |
| 순서 | … | 새 20261117…, 기준 최신 20261110… |
| 위험한 변경 | 확인 필요 | drop column orders.memo |
| RLS·정책 | … | … |
| 다른 사용자 확인 | … | A: 3행, A 로 B 행 조회: 0, anon: 0 |
| 뷰·함수 | … | … |
| 린트·DB 테스트 | … | 새 오류 0 |
| 타입 | … | … |
| 키·비밀값 | … | … |
| Edge Function | 건너뜀 | 변경 없음 |

| 어드바이저 | 건너뜀 | MCP 연결 없음 |

#### 실패 상세
- `파일:줄` 무엇이 문제인지, 고치는 법

#### 리뷰에 넣을 에이전트
- `supabase:rls-reviewer` — 근거: supabase/migrations/2026…_orders.sql 추가

#### 고친 뒤 할 것
- 고친 마이그레이션이 있으면 `db diff`·타입·RLS 확인(1, 5, 6) 다시
- (위험한 변경이 있으면) 백업·되돌리기 방법 사용자 확인

#### 나중에
- pgTAP 으로 남길 권한 규칙: …
```
