---
name: server-start-check
description: 백엔드·Supabase 프로젝트의 작업 전 점검. workflow 플러그인의 start 스킬이 부른다. 서버 코드와 Supabase 사용, 마이그레이션 담당을 판별하고, 구현 중 지킬 것과 플랜에 넣을 것을 돌려준다.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# 서버 시작 점검

`start` 스킬이 부른다. 고치지 않는다. 이 항목에 맞는 것만 돌려준다. 보고는 프로젝트의 언어로.

## 0. 해당 여부와 판별

CLAUDE.md 에 server 가 빠진 `stack:` 줄이 있으면 "해당 없음". 아래 중 하나도 없어도 "해당 없음".

- **서버 코드:** package.json 의 Node HTTP 서버 의존성(express, fastify, hono, koa, @nestjs/core 등)이나 서버 진입점(라우트·핸들러)
- **Supabase:** `supabase/config.toml`, 또는 package.json 에 `@supabase/` 패키지

모노레포면 이 항목이 건드리는 서비스를 정한다. 분명하지 않으면 물을 것으로.

### 마이그레이션 담당

스키마 변경을 어느 도구로 할지 하나로 정한다. 처음 맞는 것을 쓴다.

1. Node 마이그레이션 도구(prisma, drizzle-kit, knex 등의 설정 파일이나 마이그레이션 폴더)와 `supabase/migrations/`가 둘 다 있다 → "어느 쪽이 기준인가?"를 물을 것으로. 답 전까지는 Node 도구.
2. Node 마이그레이션 도구가 있다 → 그 도구(DB 가 Supabase 여도).
3. `supabase/` 폴더가 있다 → Supabase CLI.
4. 없다 → 마이그레이션 없음.

## 1. 지킬 것

이 항목에 해당하는 것만 돌려준다.

- 여러 쓰기는 한 트랜잭션으로. 재시도될 수 있는 생성 요청(결제, 주문)에는 멱등성 키.
- 스키마 변경은 담당 도구의 마이그레이션 파일로만. DB 를 손으로 바꾸지 않는다.
- 비밀번호, 토큰, 키, 연결 문자열을 로그와 오류 응답에 남기지 않는다.
- 실제(원격) 데이터베이스나 배포 환경을 바꾸는 명령(`supabase db push`, `--linked` 변경 등)은 돌리지 않는다. 필요하면 사용자에게 알린다.
- Supabase 를 쓰는데 리뷰어가 부르는 공식 Supabase 스킬(`supabase`, `supabase-postgres-best-practices`)을 부를 수 없으면 설치하지 않는다. 지킬 것에 한 줄 적어 돌려준다(`start`가 마지막 메시지에 알린다). 설치돼 있지 않으면 "공식 Supabase 스킬 없음. `/kit-setup`을 돌리면 설치된다", 설치돼 있는데 꺼져 있으면(`claude plugin list`에 꺼짐으로 나온다) "공식 Supabase 플러그인이 꺼져 있다. `/plugin`에서 켠다", 켜져 있는데 이 세션에서 부를 수 없으면 "공식 Supabase 스킬은 새 세션부터 쓰인다"다. CLAUDE.md `## 작업 설정`의 `- 공식 스킬 설치 안 함:` 줄에 `supabase`가 있으면 그 말은 적지 않는다.

## 2. 플랜에 넣을 것 / 물을 것

- 항목이 스키마를 바꾸면: 담당 도구의 생성 명령으로 마이그레이션 만들기, 필요하면 타입 재생성.
- 항목이 API 요청·응답 형식을 바꾸면: 그 API 를 쓰는 쪽(프론트엔드, 다른 서비스)도 바꾸는지.
- 마이그레이션 담당이 둘이거나 모노레포 서비스가 분명하지 않으면 물을 것으로.

## 돌려줄 형식

```markdown
### server start check
감지: Node · NestJS, Supabase. 마이그레이션 담당: prisma

#### 지킬 것
- …

#### 플랜에 넣을 것
- …

#### 물을 것
- …
```

내용이 없는 섹션은 빼고 돌려준다.
