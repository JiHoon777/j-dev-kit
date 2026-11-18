# Supabase: 마무리 점검

`supabase/config.toml`이나 `@supabase/` 의존성이 있을 때 `server-end-check`가 읽는다.

`supabase/` 아래나 Supabase 를 부르는 코드(`.from(`, `.rpc(`, `.channel(`, `auth.`, `storage.`)가 바뀌지 않았으면 건너뛴다.

CLI 검사는 로컬 스택이 돌고 있을 때만 한다(`supabase status`). 꺼져 있으면 켤지 묻고, 거절하면 "로컬 스택 꺼짐"으로 건너뛴다. SQL 은 `supabase status`의 DB URL 로 `psql "<DB URL>" -c "<SQL>"`.

## 검사

- **빠진 마이그레이션**(Supabase CLI 가 담당일 때): `supabase db diff` 출력이 비어 있어야 통과. 남아 있으면 실패: 로컬 DB 에는 있지만 마이그레이션 파일에 없는 변경이다. 출력 SQL 을 근거로.
- **advisors**: `supabase db advisors`(또는 프로젝트에 Supabase MCP 가 있으면 `get_advisors`, security·performance). 이 변경으로 새로 생긴 지적이 있으면 실패.
- **타입**(생성된 타입 파일이 있을 때): 같은 옵션으로 임시 파일에 `supabase gen types typescript --local`을 만들어 비교. 다르면 실패(다시 생성해 커밋).
- **키**: 값은 옮겨 적지 않는다.
  ```bash
  grep -rnE "sb_secret_|service_role|SERVICE_ROLE|eyJ[A-Za-z0-9_-]{20,}" --exclude-dir=node_modules --exclude-dir=build --exclude-dir=.next --exclude-dir=.svelte-kit .
  ```
  `eyJ` 토큰은 가운데 부분을 디코드해 `role`이 `anon`이면 괜찮다. 클라이언트 코드나 공개 접두사 환경 변수에 비밀 키가 있거나, 코드·마이그레이션·seed 에 키가 박혀 있거나, `supabase/functions/.env` 같은 시크릿 파일이 커밋돼 있으면 실패.
- **다른 사용자 확인**(RLS 정책이 바뀌었을 때만): 테스트 사용자 둘(A, B)로 보이는 행이 Acceptance Criteria 의 권한 규칙과 맞는지 확인한다. 사용자가 없으면 seed 나 `auth.users`에서 찾고, 없으면 만들지 묻는다. 개수를 근거로.
  ```sql
  begin;
  set local role authenticated;
  select set_config('request.jwt.claims', '{"sub":"<A의 id>","role":"authenticated"}', true);
  select count(*) from public.<테이블> where user_id = '<B의 id>';  -- 규칙상 0 이어야 하면 0
  rollback;
  ```

## 리뷰에 넣을 에이전트

위 범위가 바뀌었으면 `server:rls-reviewer`. 근거: 바뀐 파일, 새 마이그레이션 파일, advisors 지적, 다른 사용자 확인 결과.

## 고친 뒤 할 것

마이그레이션이나 정책을 고쳤으면 `db diff`, advisors, 타입, 다른 사용자 확인을 다시.
