---
name: supabase-start-check
description: Supabase 프로젝트의 작업 전 점검. 로컬 스택 상태, 마이그레이션 적용 여부, 마이그레이션에 담기지 않은 스키마 변경(드리프트), 타입 파일이 최신인지 확인하고, DB 린트와 테스트 기준선, 플랜에 넣을 스키마·RLS 항목을 돌려준다. workflow 플러그인의 `/task start`가 부른다.
user-invocable: false
version: "0.3.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> 번역본입니다. 원문은 [plugins/supabase/skills/supabase-start-check/SKILL.md](../../../../../../plugins/supabase/skills/supabase-start-check/SKILL.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# Supabase 시작 점검

`/task start`가 부른다. 보고서는 프로젝트의 언어로 쓴다. 각 항목을 **통과 · 실패 · 건너뜀(이유) · 중단**으로 판정하고, 결과를 맨 아래 형식으로 돌려준다. 고치는 것은 이 스킬의 일이 아니다.

| 부분 | 출처 |
| --- | --- |
| 마이그레이션, 드리프트, 타입, 린트, DB 테스트 | Supabase CLI |
| 구현 중: SQL 과 RLS 작성 규칙 | 공식 Supabase 플러그인의 `supabase`, `supabase-postgres-best-practices` 스킬 (그대로 호출) |
| 구현 중: 문서 찾기 | Supabase MCP `search_docs` (연결돼 있으면) |

**Supabase MCP 주의:** MCP 가 실제 서비스 프로젝트에 연결돼 있으면 쓰지 않는다. 꼭 써야 하면 읽기 전용(`read_only=true`)으로, 프로젝트 하나(`project_ref`)로 범위를 좁힌 개발 프로젝트에만 쓴다. 남이 쓴 글이 담긴 테이블을 읽으면 그 글이 지시처럼 작용할 수 있다.

## 0. 해당 여부

- CLAUDE.md 에 `stack:`이 있는데 supabase 가 없으면 → "해당 없음: 스택 설정에 없음".
- `supabase/config.toml`도 없고 package.json 에 `@supabase/` 의존성도 없으면 → "해당 없음: Supabase 를 쓰는 흔적 없음".
- `@supabase/` 의존성만 있고 `supabase/` 폴더가 없으면(원격 프로젝트만 쓰는 경우) → 1~4단계를 건너뛰고 5단계와 6단계만 한다. 근거에 "로컬 Supabase 없음, 스키마를 저장소에서 관리하지 않음"이라고 적는다.

### 마이그레이션 담당

마이그레이션 점검은 플러그인 하나만 맡는다. `supabase`와 `server` 플러그인이 같은 규칙으로 정하므로, 어느 쪽이 먼저 돌아도 결과가 같다.

서버 마이그레이션 도구: `prisma/schema.prisma`, `drizzle.config.*`, TypeORM DataSource, `alembic.ini`, Django `*/migrations/`, `atlas.hcl`, Flyway `db/migration/` 또는 `flyway.conf`, Liquibase changelog, golang-migrate 폴더. 아래 규칙 중 처음 맞는 것을 적용한다.

1. 서버 마이그레이션 도구가 있고 **동시에** `supabase/migrations/`에 SQL 파일이 있다 → 스키마를 두 곳에서 관리하고 있다. "어느 쪽이 기준인가?"를 물을 것으로 돌려주고, 답을 받기 전까지는 **server** 가 맡는 것으로 본다.
2. 서버 마이그레이션 도구가 있다 → 데이터베이스가 Supabase Postgres 여도 **server** 가 맡는다.
3. `supabase/migrations/`가 있다 → **supabase** 가 맡는다.

담당을 보고서 표의 첫 줄에 적는다. 담당이 아닌 플러그인은 마이그레이션 항목을 "건너뜀: 마이그레이션은 <담당> 플러그인 담당"으로 건너뛴다.

## 1. CLI 와 로컬 스택

1. `supabase --version`. 없으면 실패로 하고 1~4단계를 건너뛴다(설치는 사용자가 한다).
2. `supabase status`. 돌고 있지 않으면 `supabase start`를 돌릴지 **묻는다**(Docker 컨테이너 여러 개를 띄운다). 거절하면 2~4단계를 "로컬 스택 꺼짐"으로 건너뛴다.
3. 출력에서 DB URL 을 적어 둔다(기본값 `postgresql://postgres:postgres@127.0.0.1:54322/postgres`). 아래 SQL 은 `psql "<DB URL>" -c "<SQL>"`로 돌린다. `psql`이 없으면 SQL 이 필요한 항목은 "psql 없음"으로 건너뛴다.

## 2. 마이그레이션 상태 (supabase 가 마이그레이션을 맡을 때만)

1. `supabase migration list --local`. `supabase/migrations/`에 있는 것 중 로컬 DB 에 적용되지 않은 것이 있으면 실패로 하고 `supabase migration up`을 제안한다.
2. 원격 프로젝트가 연결돼 있으면(`supabase/.temp/project-ref`가 있으면) `supabase migration list --linked`도 확인한다. **원격에만 있고 저장소에는 없는 마이그레이션**이 있으면 중단한다: 누군가 저장소를 거치지 않고 원격에 적용한 것이다. 로그인이나 비밀번호를 요구하거나 네트워크를 쓸 수 없으면 "원격 확인 못 함"으로 건너뛴다.

## 3. 드리프트 (supabase 가 마이그레이션을 맡을 때만)

server 가 맡으면 건너뛴다. `supabase db diff`가 서버 도구가 만든 테이블을 드리프트로 보고하기 때문이다.

`supabase db diff`를 돌린다. 출력 SQL 이 비어 있지 않으면 **중단한다**: 로컬 DB 에 마이그레이션 파일로 저장되지 않은 스키마 변경이 있다(예: 대시보드에서 직접 바꿈). 출력 SQL 을 근거에 붙이고, 마이그레이션으로 남길지(`supabase db diff -f <이름>`) 버릴지(`supabase db reset`) 사용자가 정해야 한다고 돌려준다.

## 4. 타입 파일

1. 프로젝트에서 생성된 타입 파일을 찾는다: package.json scripts 의 `supabase gen types` 줄, 또는 `Database` 타입을 내보내는 파일(`database.types.ts`, `supabase.ts`, `types/supabase.ts` 등).
2. 같은 옵션으로 임시 파일에 생성한다: `supabase gen types typescript --local > <임시 경로>` (스키마 옵션 `--schema`를 쓰고 있으면 똑같이 쓴다).
3. 기존 파일과 비교한다. 다르면 실패: 타입이 스키마보다 오래됐다. 작업 전에 갱신할지 플랜에서 묻도록 돌려준다. 여기서 기존 파일을 바꾸지 않는다.

## 5. 기준선

- `supabase db lint`의 결과(오류와 경고 개수, 대상 함수).
- `supabase/tests/`에 pgTAP 테스트가 있으면 `supabase test db`의 결과.
- 아래 SQL 두 개의 결과(목록).
  ```sql
  -- RLS 가 꺼진 public 테이블
  select c.relname from pg_class c join pg_namespace n on n.oid = c.relnamespace
  where n.nspname = 'public' and c.relkind = 'r' and not c.relrowsecurity;

  -- RLS 는 켜졌지만 정책이 하나도 없는 테이블 (아무도 읽을 수 없다)
  select t.tablename from pg_tables t
  where t.schemaname = 'public' and t.rowsecurity
    and not exists (select 1 from pg_policies p
                    where p.schemaname = 'public' and p.tablename = t.tablename);
  ```
- 이미 실패하거나 목록에 나오는 것이 있으면 **기준선**으로 기록하고 사용자에게 알린다. 작업을 막지는 않는다.

## 6. 관련 스키마 조사 (탐색 에이전트에 넘김)

이 항목과 관련된 기존 테이블, 정책, 함수와 그것을 쓰는 코드를 직접 찾지 않는다. 아래 지시문을 "탐색에 넣을 지시문"으로 돌려준다.

> 이 항목(<항목 경로>)과 관련된 Supabase 스키마를 요약하라: 관련 테이블, 컬럼, RLS 정책, DB 함수(RPC), 뷰, 스토리지 버킷이 `supabase/migrations/`에서 어떻게 정의돼 있는지, 그리고 그것을 부르는 앱 코드(`.from(`, `.rpc(`, `.channel(`, `auth.`, `storage.`)가 어디 있는지. 비슷한 기존 기능 하나를 테이블 → 정책 → 클라이언트 호출까지 끝까지 따라가고, 꼭 읽어야 할 파일 5-10개를 돌려줘라. 파일을 고치지 말고, DB 에 아무것도 돌리지 마라.

## 7. 플랜에 넣을 것

작업 설명(백로그 내용)을 읽고 작업이 스키마를 바꾸는지 판단한다. 바꾼다면 플랜에 아래를 넣어야 한다고 돌려준다.

- **마이그레이션** (supabase 가 맡을 때. server 가 맡으면 server 플러그인이 그 도구의 규칙을 돌려준다): `supabase migration new <영어_이름>`으로 파일을 만들고 SQL 로 쓴다. 대시보드에서 바꾼 뒤 나중에 diff 로 뽑지 않는다.
- **RLS**: 새 테이블마다 `alter table … enable row level security;`와 select, insert, update, delete 각각의 정책. 누가(anon, authenticated, 특정 역할) 어떤 행을 볼 수 있는지를 인수 조건의 권한 규칙에 맞춘다.
  - 정책 안의 `auth.uid()`는 `(select auth.uid())`로 감싼다(행마다 다시 계산되지 않게).
  - 정책 조건에 쓰는 컬럼(`user_id` 등)에 인덱스를 만든다.
  - update 정책은 `using`(바꿀 수 있는 행)과 `with check`(바뀐 뒤의 행)를 둘 다 쓴다.
- **뷰**: 새 뷰는 `with (security_invoker = true)`로 만든다. 그렇지 않으면 만든 사람의 권한으로 돌아 RLS 를 우회한다.
- **함수**: `security definer` 함수는 `set search_path = ''`를 두고 테이블에 스키마를 붙인다(`public.orders`).
- **스토리지**: 새 버킷에는 `storage.objects` 정책.
- 새 테이블에 대한 **타입 재생성**과 **seed**(`supabase/seed.sql`) 데이터가 필요한지.
- **키**: 클라이언트는 anon(publishable) 키만 쓴다. service role(secret) 키가 필요한 일은 서버나 Edge Function 에서 한다.
- `supabase/functions/`의 Edge Function 을 건드리면 로컬에서 확인하는 방법(`supabase functions serve <이름>`)과 필요한 시크릿 이름.

## 8. 구현 중 지킬 것 (돌려줄 것)

- Supabase 코드(마이그레이션 SQL, 정책, RPC, 클라이언트 호출)를 쓸 때는 공식 Supabase 플러그인의 `supabase` 스킬을, SQL·인덱스·정책 성능이 걸리면 `supabase-postgres-best-practices` 스킬을 부르고 그 방식을 따른다. 플러그인을 쓸 수 없으면 그렇다고 말한다.
- supabase 가 마이그레이션을 맡으면 스키마 변경은 `supabase migration new <이름>`으로 만든 파일에 SQL 로 쓴다. server 가 맡으면 서버 도구를 쓴다(server 플러그인이 규칙을 돌려준다). 대시보드에서 바꾸지 않는다.
- 정책과 RPC 는 테스트를 먼저 쓴다: `supabase/tests/`에 pgTAP 테스트가 있는 프로젝트면 거기에, 아니면 다른 사용자로 확인하는 SQL 을 `Implementation Notes`에 남긴다.
- 실제 Supabase 프로젝트를 건드리는 명령(`db push`, `--linked`로 하는 변경, `functions deploy`, `secrets set`)은 돌리지 않는다. 필요하면 사용자에게 알린다.

## 돌려줄 형식

```markdown
### supabase start check
| Item | Result | Evidence |
| --- | --- | --- |
| Migration owner | … | supabase (supabase/migrations) / server (prisma) |
| CLI and local stack | pass | supabase 2.x, status OK |
| Local migrations | … | … |
| Remote migrations | skip | not linked |
| Drift | … | no `db diff` output |
| Types file | … | src/types/database.types.ts |

#### Baseline
| Check | Result |
| --- | --- |
| `supabase db lint` | 0 errors, 1 warning |
| `supabase test db` | no tests |
| Tables with RLS off | none |
| Tables without policies | none |

#### Add to the plan
- Schema change: yes → migration, RLS policies (…), indexes (…), type regeneration

#### Exploration prompts
- Related schema research: (prompt from step 6)

#### Rules during implementation
- (the applicable ones from step 8)

#### Questions to ask
- (migration owner when both exist, outdated types, …)
```

**중단**이 있으면 표 위에 `stop: <이유>`를 먼저 적는다.
