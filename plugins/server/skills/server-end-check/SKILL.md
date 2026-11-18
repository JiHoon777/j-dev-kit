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

- `server-start-check`와 같은 기준으로 판별하고, 같은 규칙으로 마이그레이션 담당을 정한다. 맞는 reference 를 Read 도구로 끝까지 읽는다(`${CLAUDE_SKILL_DIR}/references/` 의 `node.md`, `python.md`, `go.md`, `jvm.md`, `supabase.md`).
- `git diff --name-only <기준>...HEAD`에 서버 코드, 마이그레이션, API 스펙, `supabase/`, 설정 파일이 없으면 "서버 변경 없음"만 돌려준다.

## 1. 검사 (해당할 때만)

데이터베이스 명령은 로컬·개발 DB 에만 돌린다. 운영으로 보이면 돌리지 않고 알린다. 프로젝트 도구는 설치된 것만 쓴다(`npx --no-install` 등). 없으면 "도구 없음"으로 적는다.

- **빠진 마이그레이션**(스키마 관련 코드가 바뀌었을 때): 담당 도구의 명령(reference).
- **마이그레이션 순서**(새 마이그레이션이 있을 때): 작업하는 동안 기준 브랜치에 새 마이그레이션이 들어왔는가. 타임스탬프 파일이면 새 파일이 `origin/<기준>`의 가장 새 파일보다 늦어야 한다. head 가 여럿인 도구는 reference.
- **API 스펙**(OpenAPI 스펙이 있고 바뀌었을 때): `oasdiff`가 있으면 `oasdiff breaking --fail-on ERR <기준 스펙> <새 스펙>`(기준 스펙은 `git show origin/<기준>:<경로>`). 호환성을 깨는 변경은 실패가 아니라 리뷰어에게 넘길 근거다. 없으면 두 경로를 리뷰어에게 넘긴다. 스펙을 코드에서 생성하면 생성 후 `git diff --exit-code <스펙>`, 차이가 있으면 실패.
- **설정 키:** 추가된 줄에서 새로 읽는 환경 변수(패턴은 reference)가 `.env.example`에 없으면 실패. 이름만 비교하고 값은 읽지 않는다. `.env` 같은 값 파일이 커밋돼 있으면 실패.
- reference 의 검사.

## 2. 리뷰에 넣을 에이전트

- 서버 코드(라우트, 핸들러, 서비스, 인가, 쿼리), API 스펙, 서버 마이그레이션이 바뀌었으면 `server:api-reviewer`. 근거: 바뀐 파일, 새 마이그레이션 파일, oasdiff 결과(또는 두 스펙 경로).
- supabase.md 가 돌려주면 `server:rls-reviewer`.

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
