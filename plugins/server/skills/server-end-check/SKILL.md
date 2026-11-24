---
name: server-end-check
description: 백엔드·Supabase 프로젝트의 마무리 점검. workflow 플러그인 task 스킬의 end 모드가 부른다. 서버 코드나 Supabase 가 바뀌었을 때만 빠진 마이그레이션, 마이그레이션 순서, API 스펙 호환성(oasdiff), 문서에 없는 설정 키, Supabase 검사(db diff, advisors, 타입, 키)를 확인하고, 리뷰에 넣을 api-reviewer·supabase-reviewer 를 돌려준다.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# 서버 마무리 점검

`/task end`가 부른다. 명령을 돌리고 결과만 돌려준다. 코드를 읽고 판단하는 리뷰는 `server:api-reviewer`, `server:supabase-reviewer`가 한다. 보고는 프로젝트의 언어로.

## 0. 해당 여부

- `server-start-check`와 같은 기준으로 판별하고, 같은 규칙으로 마이그레이션 담당을 정한다.
- `git diff --name-only <기준>...HEAD`에 서버 코드, 마이그레이션, API 스펙, `supabase/`, 설정 파일이 없고, 추가된 줄에 Supabase 를 부르는 코드(`.from(`, `.rpc(`, `.channel(`, `auth.`, `storage.`)도 없으면 "서버 변경 없음"만 돌려준다. 브라우저 코드에서 Supabase 를 부르는 변경도 이 점검의 대상이다.

## 1. 검사 (해당할 때만)

데이터베이스 명령은 로컬·개발 DB 에만 돌린다. 운영으로 보이면 돌리지 않고 알린다. 필요한 검사 도구가 없으면 설치해 쓴다. 버전을 고정하고, 프로젝트 파일과 전역 설치를 바꾸지 않는 방식으로. 설치해도 되는 것은 이 문서가 이름을 적은 도구(oasdiff: `go run github.com/oasdiff/oasdiff@<버전>` 또는 `docker run --rm tufin/oasdiff:<태그>`, Supabase CLI: `npx -y supabase@<버전>`)와 프로젝트가 이미 의존성으로 적은 도구뿐이다. 그 밖의 도구는 설치하기 전에 사용자에게 이름과 출처를 보여 주고 묻는다. 설치할 수 없으면 "도구 없음"으로 적는다.

### 빠진 마이그레이션과 순서

스키마를 바꾸면 마이그레이션이 같이 있어야 한다. 스키마 관련 코드가 바뀌었으면:

- **빠진 마이그레이션:** 프로젝트가 정한 확인 방법(CLAUDE.md, package.json·Makefile 스크립트)을 쓴다. 없으면 담당 도구의 드리프트 확인 명령을 쓴다. DB 와 비교하는 도구는 먼저 로컬 DB 에 마이그레이션을 적용한 뒤 돌린다(아니면 빠진 게 없어도 차이가 나온다). 차이를 보고하면 실패. 확인할 방법이 없으면 "확인 못 함"으로 적고 리뷰어에게 넘긴다.
- **Supabase CLI 가 담당이면:** `supabase migration up`으로 로컬에 적용한 뒤 `supabase db diff`. 출력이 비어 있어야 통과, SQL 이 나오면 실패(마이그레이션 파일에 없는 변경, 출력을 근거로).
- **순서:** 작업하는 동안 기준 브랜치에 새 마이그레이션이 들어왔으면, 새 파일의 타임스탬프·번호가 기준 브랜치의 가장 새 파일보다 뒤여야 한다. 아니면 실패.

### API 스펙

OpenAPI 스펙이 있고 바뀌었을 때:

- `oasdiff breaking --fail-on ERR <기준 스펙> <새 스펙>`(기준 스펙은 `git show origin/<기준>:<경로>`). 호환성을 깨는 변경은 실패가 아니라 리뷰어에게 넘길 근거다. 설치할 수 없으면 두 경로를 리뷰어에게 넘긴다.
- 스펙을 코드에서 생성하면 생성 후 `git diff --exit-code <스펙>`. 차이가 있으면 실패.

### 설정 키·값 파일·키

`bash ${CLAUDE_SKILL_DIR}/scripts/config-check.sh <기준>`을 돌린다. 출력한 줄이 실패다: 추가된 줄에서 새로 읽는 환경 변수가 `.env.example`에 없음, 커밋된 `.env` 같은 값 파일, 추가된 줄의 키(`sb_secret_`, role 이 anon 이 아닌 JWT, 공개 접두사 환경 변수의 비밀 키 이름). 스크립트는 이름만 비교하고 키는 파일 이름만 쓴다. 키 값이 대화에 들어오지 않게, 근거에도 그 출력만 쓴다.

### Supabase

`supabase/` 아래나 Supabase 를 부르는 코드(`.from(`, `.rpc(`, `.channel(`, `auth.`, `storage.`)가 바뀌었을 때만. DB 가 필요한 검사는 로컬 스택이 돌 때만(`supabase status`, 꺼져 있으면 켤지 묻는다).

- **advisors:** `supabase db advisors`. 이 변경으로 새로 생긴 지적이 있으면 실패.
- **타입**(생성된 타입 파일이 있을 때): 같은 옵션으로 임시 파일에 `supabase gen types typescript --local`을 만들어 비교. 다르면 실패(다시 생성해 커밋).
- **키:** 클라이언트 코드가 비밀 키를 쓰는지는 `server:supabase-reviewer`가 본다(키 패턴은 위 스크립트가 본다).

## 2. 리뷰에 넣을 에이전트

- 서버 코드(라우트, 핸들러, 서비스, 인가, 쿼리), API 스펙, 서버 마이그레이션이 바뀌었으면 `server:api-reviewer`. 근거: 바뀐 파일, 새 마이그레이션 파일, oasdiff 결과(또는 두 스펙 경로).
- 위 Supabase 범위가 바뀌었으면 `server:supabase-reviewer`. 근거: 바뀐 파일, 새 마이그레이션 파일, advisors 지적, 로컬 스택이 도는지.

## 3. 고친 뒤 할 것

마이그레이션이나 스펙을 고쳤으면 1단계의 해당 검사를 다시 돌린다.

## 돌려줄 형식

```markdown
### server end check
마이그레이션 담당: prisma
검사: 실패 1건 (나머지 통과, 건너뜀: oasdiff 없음)
- src/orders/webhook.ts:12 — 새 환경 변수 STRIPE_WEBHOOK_SECRET 이 .env.example 에 없음

#### 리뷰에 넣을 에이전트
- `server:api-reviewer` — 근거: src/orders/*.ts, prisma/migrations/2026…/migration.sql

#### 고친 뒤 할 것
- …
```

실패가 없으면 "검사: 모두 통과"라고 한 줄로 쓴다.
