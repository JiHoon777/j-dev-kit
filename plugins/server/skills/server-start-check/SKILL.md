---
name: server-start-check
description: 백엔드·Supabase 프로젝트의 작업 전 점검. workflow 플러그인 task 스킬의 start 모드가 부른다. 언어(Node, Python, Go, Java/Kotlin)와 Supabase 사용, 마이그레이션 담당을 판별하고, 구현 중 지킬 것과 플랜에 넣을 것을 돌려준다. 언어·Supabase 별 내용은 references 에 있다.
user-invocable: false
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# 서버 시작 점검

`/task start`가 부른다. 고치지 않는다. 이 항목에 맞는 것만 돌려준다. 보고는 프로젝트의 언어로.

## 0. 해당 여부와 판별

CLAUDE.md 에 server 가 빠진 `stack:` 줄이 있으면 "해당 없음". 아니면 맞는 reference 를 모두 Read 도구로 끝까지 읽는다. 하나도 맞지 않으면 "해당 없음".

| 판별 근거 | reference |
| --- | --- |
| package.json 에 `express`, `@nestjs/core`, `fastify`, `hono`, `koa` | `${CLAUDE_SKILL_DIR}/references/node.md` |
| `pyproject.toml`·`requirements*.txt`에 `fastapi`, `django`, `flask` | `${CLAUDE_SKILL_DIR}/references/python.md` |
| `go.mod` | `${CLAUDE_SKILL_DIR}/references/go.md` |
| `pom.xml`·`build.gradle*`에 `spring-boot` | `${CLAUDE_SKILL_DIR}/references/jvm.md` |
| `supabase/config.toml`, 또는 package.json 에 `@supabase/` 패키지 | `${CLAUDE_SKILL_DIR}/references/supabase.md` |

모노레포면 이 항목이 건드리는 서비스를 정한다. 분명하지 않으면 물을 것으로.

### 마이그레이션 담당

스키마 변경을 어느 도구로 할지 하나로 정한다. 처음 맞는 것을 쓴다.

1. 서버 마이그레이션 도구(`prisma/schema.prisma`, `drizzle.config.*`, TypeORM DataSource, `alembic.ini`, Django `*/migrations/`, `atlas.hcl`, Flyway, Liquibase, golang-migrate 폴더)와 `supabase/migrations/`가 둘 다 있다 → "어느 쪽이 기준인가?"를 물을 것으로. 답 전까지는 서버 도구.
2. 서버 마이그레이션 도구가 있다 → 서버 도구(DB 가 Supabase 여도).
3. `supabase/` 폴더가 있다 → Supabase CLI.
4. 없다 → 마이그레이션 없음.

## 1. 지킬 것

이 항목에 해당하는 것만 돌려준다.

- 새 엔드포인트마다 인증, 객체 단위 인가(요청한 사용자가 이 객체에 접근할 수 있는가), 입력 스키마 검증, 허용한 필드만 받기.
- 여러 쓰기는 한 트랜잭션으로. 재시도될 수 있는 생성 요청(결제, 주문)에는 멱등성 키.
- 스키마 변경은 담당 도구의 마이그레이션 파일로만. DB 를 손으로 바꾸지 않는다.
- 비밀번호, 토큰, 키, 연결 문자열을 로그와 오류 응답에 남기지 않는다.
- 실제(원격) 데이터베이스나 배포 환경을 바꾸는 명령은 돌리지 않는다. 필요하면 사용자에게 알린다.
- reference 의 규칙.

## 2. 플랜에 넣을 것 / 물을 것

- 항목이 스키마를 바꾸면: 담당 도구로 마이그레이션 만들기(reference 의 명령), 필요하면 타입 재생성.
- 항목이 API 요청·응답 형식을 바꾸면: 그 API 를 쓰는 쪽(프론트엔드, 다른 서비스)도 바꾸는지.
- 마이그레이션 담당이 둘이거나 모노레포 서비스가 분명하지 않으면 물을 것으로.

## 돌려줄 형식

```markdown
### server start check
감지: Node · NestJS, Supabase (references/node.md, supabase.md 읽음). 마이그레이션 담당: prisma

#### 지킬 것
- …

#### 플랜에 넣을 것
- …

#### 물을 것
- …
```

내용이 없는 섹션은 빼고 돌려준다.
