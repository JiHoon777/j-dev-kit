---
name: server-end-check
description: 백엔드·Supabase 프로젝트의 마무리 점검. workflow 플러그인 task 스킬의 end 모드가 부른다. 서버 코드나 Supabase 가 바뀌었을 때만 빠진 마이그레이션, 마이그레이션 순서, API 스펙 호환성(oasdiff), 문서에 없는 설정 키, Supabase 검사(db diff, advisors, 타입, 키)를 확인하고, 리뷰에 넣을 api-reviewer·rls-reviewer 를 돌려준다.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# 서버 마무리 점검

`/task end`가 부른다. 명령을 돌리고 결과만 돌려준다. 코드를 읽고 판단하는 리뷰는 `server:api-reviewer`, `server:rls-reviewer`가 한다. 보고는 프로젝트의 언어로.

## 0. 해당 여부

- `server-start-check`와 같은 기준으로 판별하고, 같은 규칙으로 마이그레이션 담당을 정한다.
- `git diff --name-only <기준>...HEAD`에 서버 코드, 마이그레이션, API 스펙, `supabase/`, 설정 파일이 없으면 "서버 변경 없음"만 돌려준다.

## 1. 검사 (해당할 때만)

데이터베이스 명령은 로컬·개발 DB 에만 돌린다. 운영으로 보이면 돌리지 않고 알린다. 프로젝트 도구는 설치된 것만 쓴다(`npx --no-install` 등). 없으면 "도구 없음"으로 적는다.

### 빠진 마이그레이션과 순서

스키마를 바꾸면 마이그레이션이 같이 있어야 한다. 스키마 관련 코드가 바뀌었으면 담당 도구의 확인 명령을 돌리고, 차이를 보고하면 실패다. 새 마이그레이션이 있으면 순서도 본다.

| 도구 | 빠진 마이그레이션 | 순서 |
| --- | --- | --- |
| Prisma | `npx --no-install prisma migrate diff --from-migrations prisma/migrations --to-schema prisma/schema.prisma --exit-code` → 종료 코드 2 면 실패(0 은 차이 없음, 1 은 오류) | 타임스탬프 |
| Drizzle | `npx --no-install drizzle-kit generate` 뒤 `git status --porcelain <출력 폴더>`에 새 파일이 있으면 실패(생성된 파일은 지우지 말고 보고) | 타임스탬프 |
| TypeORM | `npx --no-install typeorm migration:generate <임시 경로> -d <DataSource>`가 파일을 만들면 실패(임시 파일은 지운다) | 타임스탬프 |
| Alembic | `alembic check` 실패 → 실패 | `alembic heads`가 두 줄 이상 → 실패(merge revision 필요) |
| Django | `python manage.py makemigrations --check` 실패 → 실패 | 같은 명령이 conflicting leaf node 를 보고 → 실패(`makemigrations --merge`) |
| Atlas | `atlas migrate validate` | 타임스탬프 |
| golang-migrate | 확인 도구가 없다. 스키마 변경에 새 up/down 파일 쌍이 있는지 본다 | 번호 |
| Flyway / Liquibase | 스키마 변경에 새 마이그레이션 파일·changeset 이 있는지 본 뒤 `flyway validate` / `liquibase validate` | 버전 번호 |
| Supabase CLI | `supabase db diff` 출력이 비어 있어야 통과. SQL 이 나오면 실패(로컬 DB 에는 있지만 마이그레이션 파일에 없는 변경, 출력을 근거로) | 타임스탬프 |

**순서(타임스탬프·번호):** 작업하는 동안 기준 브랜치에 새 마이그레이션이 들어왔으면, 새 파일의 타임스탬프·번호가 `origin/<기준>`의 가장 새 파일보다 뒤여야 한다. 아니면 실패.

### API 스펙

OpenAPI 스펙이 있고 바뀌었을 때:

- `oasdiff`가 있으면 `oasdiff breaking --fail-on ERR <기준 스펙> <새 스펙>`(기준 스펙은 `git show origin/<기준>:<경로>`). 호환성을 깨는 변경은 실패가 아니라 리뷰어에게 넘길 근거다. 없으면 두 경로를 리뷰어에게 넘긴다.
- 스펙을 코드에서 생성하면 생성 후 `git diff --exit-code <스펙>`. 차이가 있으면 실패.

### 설정 키

- 추가된 줄에서 새로 읽는 환경 변수가 `.env.example`에 없으면 실패. 이름만 비교하고 값은 읽지 않는다.
- `.env` 같은 값 파일이 커밋돼 있으면 실패.

### Supabase

`supabase/` 아래나 Supabase 를 부르는 코드(`.from(`, `.rpc(`, `.channel(`, `auth.`, `storage.`)가 바뀌었을 때만. DB 가 필요한 검사는 로컬 스택이 돌 때만(`supabase status`, 꺼져 있으면 켤지 묻는다).

- **advisors:** `supabase db advisors`. 이 변경으로 새로 생긴 지적이 있으면 실패.
- **타입**(생성된 타입 파일이 있을 때): 같은 옵션으로 임시 파일에 `supabase gen types typescript --local`을 만들어 비교. 다르면 실패(다시 생성해 커밋).
- **키:** `grep -rnE "sb_secret_|service_role|SERVICE_ROLE|eyJ[A-Za-z0-9_-]{20,}" --exclude-dir=node_modules --exclude-dir=build --exclude-dir=.next --exclude-dir=.svelte-kit .` 값은 옮겨 적지 않는다. `eyJ` 토큰은 가운데 부분을 디코드해 `role`이 `anon`이면 괜찮다. 클라이언트 코드나 공개 접두사 환경 변수에 비밀 키가 있거나, 코드·마이그레이션·seed 에 키가 박혀 있거나, `supabase/functions/.env` 같은 시크릿 파일이 커밋돼 있으면 실패.

## 2. 리뷰에 넣을 에이전트

- 서버 코드(라우트, 핸들러, 서비스, 인가, 쿼리), API 스펙, 서버 마이그레이션이 바뀌었으면 `server:api-reviewer`. 근거: 바뀐 파일, 새 마이그레이션 파일, oasdiff 결과(또는 두 스펙 경로).
- 위 Supabase 범위가 바뀌었으면 `server:rls-reviewer`. 근거: 바뀐 파일, 새 마이그레이션 파일, advisors 지적, 로컬 스택이 도는지.

## 3. 고친 뒤 할 것

마이그레이션이나 스펙을 고쳤으면 1단계의 해당 검사를 다시 돌린다.

## 돌려줄 형식

```markdown
### server end check
마이그레이션 담당: prisma
검사: 실패 1건 (나머지 통과, 건너뜀: oasdiff 없음)
- .env.example — 새 키 STRIPE_WEBHOOK_SECRET 없음

#### 리뷰에 넣을 에이전트
- `server:api-reviewer` — 근거: src/orders/*.ts, prisma/migrations/2026…/migration.sql

#### 고친 뒤 할 것
- …
```

실패가 없으면 "검사: 모두 통과"라고 한 줄로 쓴다.
