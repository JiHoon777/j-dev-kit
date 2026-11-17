---
name: supabase-start-check
description: Supabase 프로젝트의 작업 시작 전 점검. 로컬 스택 상태, 마이그레이션 적용 여부, 마이그레이션에 없는 스키마 변경(드리프트), 타입 파일 최신 여부를 확인하고 DB 린트·테스트 기준선과 플랜에 넣을 스키마·RLS 항목을 돌려준다. workflow 의 task-start 가 부른다.
user-invocable: false
version: "0.2.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# Supabase 시작 점검

`task-start` 가 부른다. 각 항목을 **통과 · 실패 · 건너뜀(이유) · 중단** 으로 판정하고 맨 아래 형식으로 돌려준다. 고치는 것은 이 스킬의 일이 아니다.

| 부분 | 출처 |
| --- | --- |
| 마이그레이션·드리프트·타입·린트·DB 테스트 | Supabase CLI |
| 구현 중: SQL·RLS 작성 규칙 | Supabase 공식 플러그인의 `supabase`, `supabase-postgres-best-practices` 스킬 (그대로 호출) |
| 구현 중: 문서 조회 | Supabase MCP `search_docs` (연결돼 있으면) |

**Supabase MCP 주의:** MCP 가 실제 서비스 프로젝트에 연결돼 있으면 쓰지 않는다. 써야 하면 읽기 전용(`read_only=true`)으로, 프로젝트 하나(`project_ref`)로 범위를 좁힌 개발용 프로젝트에만. 남이 쓴 글이 들어 있는 테이블을 읽으면 그 글이 지시처럼 작용할 수 있다.

## 0. 해당 여부

- CLAUDE.md 에 `stack:` 이 있고 supabase 가 없으면 → "해당 없음: stack 설정에 없음".
- `supabase/config.toml` 도 없고 package.json 에 `@supabase/` 의존성도 없으면 → "해당 없음: Supabase 사용 흔적 없음".
- `@supabase/` 의존성만 있고 `supabase/` 폴더가 없으면(원격 프로젝트만 쓰는 경우) → 1~4는 건너뛰고 5·6만 한다. 근거에 "로컬 Supabase 없음, 스키마가 저장소에서 관리되지 않음"을 적는다.

## 1. CLI 와 로컬 스택

1. `supabase --version`. 없으면 실패로 표시하고 1~4를 건너뛴다(설치는 사용자가 한다).
2. `supabase status`. 떠 있지 않으면 `supabase start` 를 할지 **묻는다**(Docker 컨테이너 여러 개가 뜬다). 거절하면 2~4를 "로컬 스택 꺼짐"으로 건너뛴다.
3. 출력에서 DB URL 을 기억해 둔다(기본 `postgresql://postgres:postgres@127.0.0.1:54322/postgres`). 아래 SQL 은 `psql "<DB URL>" -c "<SQL>"` 로 돌린다. `psql` 이 없으면 SQL 이 필요한 항목은 "psql 없음"으로 건너뛴다.

## 2. 마이그레이션 상태

1. `supabase migration list --local`. `supabase/migrations/` 에 있는데 로컬 DB 에 적용 안 된 것이 있으면 실패로 표시하고 `supabase migration up` 을 제안한다.
2. 원격 프로젝트가 연결돼 있으면(`supabase/.temp/project-ref` 존재) `supabase migration list --linked` 도 본다. **원격에만 있고 저장소에 없는 마이그레이션**이 있으면 중단: 누군가 저장소를 거치지 않고 원격에 적용했다. 로그인·비밀번호를 요구하거나 네트워크가 안 되면 "원격 확인 못 함"으로 건너뛴다.

## 3. 드리프트

`supabase db diff` 를 돌린다. 출력 SQL 이 비어 있지 않으면 **중단**: 로컬 DB 에 마이그레이션 파일로 남지 않은 스키마 변경이 있다(대시보드에서 직접 바꾼 경우 등). 출력 SQL 을 근거에 붙이고, 마이그레이션으로 남길지(`supabase db diff -f <이름>`) 버릴지(`supabase db reset`) 사용자가 정해야 한다고 돌려준다.

## 4. 타입 파일

1. 프로젝트의 생성 타입 파일을 찾는다. package.json 스크립트의 `supabase gen types` 줄, 또는 `Database` 타입을 내보내는 파일(`database.types.ts`, `supabase.ts`, `types/supabase.ts` 등).
2. 같은 옵션으로 임시 파일에 생성한다: `supabase gen types typescript --local > <임시 경로>`(스키마 옵션 `--schema` 를 쓰고 있으면 똑같이).
3. 기존 파일과 비교한다. 다르면 실패: 타입이 스키마보다 낡았다. 작업 전에 갱신할지 플랜에서 묻도록 돌려준다. 기존 파일은 여기서 바꾸지 않는다.

## 5. 기준선

- `supabase db lint` 의 결과(오류·경고 개수와 대상 함수).
- `supabase/tests/` 에 pgTAP 테스트가 있으면 `supabase test db` 결과.
- 아래 두 SQL 의 결과(목록).
  ```sql
  -- RLS 가 꺼진 public 테이블
  select c.relname from pg_class c join pg_namespace n on n.oid = c.relnamespace
  where n.nspname = 'public' and c.relkind = 'r' and not c.relrowsecurity;

  -- RLS 는 켜졌지만 정책이 하나도 없는 테이블(아무도 못 읽는다)
  select t.tablename from pg_tables t
  where t.schemaname = 'public' and t.rowsecurity
    and not exists (select 1 from pg_policies p
                    where p.schemaname = 'public' and p.tablename = t.tablename);
  ```
- 이미 실패하거나 목록에 걸리는 것이 있으면 **기준선**으로 적고 사용자에게 알린다. 작업을 막지는 않는다.

## 6. 플랜에 넣을 것

작업 설명(백로그 상세)을 보고 스키마가 바뀌는 작업인지 판단한다. 바뀌면 플랜에 아래를 넣으라고 돌려준다.

- **마이그레이션**: `supabase migration new <영문_이름>` 으로 파일을 만들고 SQL 로 쓴다. 대시보드에서 바꾸고 나중에 diff 로 뽑는 방식은 쓰지 않는다.
- **RLS**: 새 테이블마다 `alter table … enable row level security;` 와 select·insert·update·delete 각각의 정책. 누가(anon·authenticated·특정 역할) 어떤 행을 볼 수 있는지 수용 기준의 권한 규칙과 맞춘다.
  - 정책에서 `auth.uid()` 는 `(select auth.uid())` 로 감싼다(행마다 다시 계산하지 않게).
  - 정책 조건에 쓰는 컬럼(`user_id` 등)에 인덱스를 만든다.
  - update 정책은 `using`(바꿀 수 있는 행)과 `with check`(바뀐 뒤의 행) 둘 다 쓴다.
- **뷰**: 새 뷰는 `with (security_invoker = true)` 로 만든다. 아니면 만든 사람 권한으로 실행돼 RLS 를 우회한다.
- **함수**: `security definer` 함수는 `set search_path = ''` 를 걸고 테이블을 스키마까지 적는다(`public.orders`).
- **스토리지**: 새 버킷이면 `storage.objects` 정책.
- **타입 재생성**과 **seed**(`supabase/seed.sql`)에 새 테이블 데이터가 필요한지.
- **키**: 클라이언트는 anon(publishable) 키만 쓴다. service role(secret) 키가 필요한 일은 서버나 Edge Function 에서 한다.
- `supabase/functions/` 의 Edge Function 을 건드리면 로컬 확인 방법(`supabase functions serve <이름>`)과 필요한 비밀값 이름.

## 7. 구현 중 지킬 것 (돌려줄 내용)

- Supabase 코드(마이그레이션 SQL, 정책, RPC, 클라이언트 호출)를 쓸 때 Supabase 공식 플러그인의 `supabase` 스킬을, SQL·인덱스·정책 성능이 걸리면 `supabase-postgres-best-practices` 스킬을 부르고 그 방식대로 한다. 플러그인이 없으면 그 사실을 알린다.
- 스키마 변경은 `supabase migration new <이름>`으로 만든 파일에 SQL 로 쓴다. 대시보드에서 바꾸지 않는다.
- 정책과 RPC 는 테스트를 먼저 쓴다: `supabase/tests/`에 pgTAP 테스트가 있는 프로젝트면 거기에, 없으면 다른 사용자로 확인하는 SQL 을 `Implementation Notes`에 남긴다.
- 실제 Supabase 프로젝트에 닿는 명령(`db push`, `--linked` 붙은 변경, `functions deploy`, `secrets set`)은 실행하지 않는다. 필요하면 사용자에게 알린다.

## 돌려줄 형식

```markdown
### supabase 시작 점검
| 항목 | 결과 | 근거 |
| --- | --- | --- |
| CLI·로컬 스택 | 통과 | supabase 2.x, status 정상 |
| 로컬 마이그레이션 | … | … |
| 원격 마이그레이션 | 건너뜀 | 연결 안 됨 |
| 드리프트 | … | `db diff` 출력 없음 |
| 타입 파일 | … | src/types/database.types.ts |

#### 기준선
| 검사 | 결과 |
| --- | --- |
| `supabase db lint` | 오류 0, 경고 1 |
| `supabase test db` | 테스트 없음 |
| RLS 꺼진 테이블 | 없음 |
| 정책 없는 테이블 | 없음 |

#### 플랜에 넣을 것
- 스키마 변경: 있음 → 마이그레이션, RLS 정책(…), 인덱스(…), 타입 재생성

#### 구현 중 지킬 것
- (7번 중 해당하는 것)
```

**중단**이 있으면 표 위에 `중단: <이유>` 를 먼저 쓴다.
