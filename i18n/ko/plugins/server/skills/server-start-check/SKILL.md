---
name: server-start-check
description: 백엔드 프로젝트의 작업 전 점검으로, workflow 플러그인 task 스킬의 start 모드가 부른다. 언어, 프레임워크, 마이그레이션 도구를 판별한 뒤 공통 점검(환경 변수, 로컬 서비스)과 맞는 참고 파일(node.md, python.md, go.md, jvm.md. 설치, LSP, 마이그레이션 상태, 기준선)의 언어별 점검을 돌린다. 기준선, API 와 그 사용처에 대한 탐색 지시문, 물을 것, 구현 중 지킬 것을 돌려준다.
user-invocable: false
version: "0.3.2"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> 번역본입니다. 원문은 [plugins/server/skills/server-start-check/SKILL.md](../../../../../../plugins/server/skills/server-start-check/SKILL.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# 서버 시작 점검

`/task start`가 부른다. 백엔드 공통 점검은 여기에, 언어별·마이그레이션 도구별 점검은 `references/`에 있다.

**이 스킬은 상태를 확인하는 명령만 돌린다.** 코드를 찾아 읽는 정보 취합은 `Explore` 에이전트용 **탐색에 넣을 지시문**으로 돌려주고, `/task start`가 자기 탐색 에이전트와 함께 띄운다.

각 항목을 **통과 · 실패 · 건너뜀(이유) · 중단**으로 판정하고 끝의 형식으로 돌려준다. 고치는 것은 이 스킬의 일이 아니다. 보고는 프로젝트의 언어로 쓴다.

| 부분 | 출처 |
| --- | --- |
| 코드 진단 | 기본으로 들어 있는 `anthropic-plugin-directory`의 Anthropic LSP 플러그인(`typescript-lsp`, `pyright-lsp`, `gopls-lsp`, `jdtls-lsp`) |
| 마이그레이션 상태 | 각 ORM 이나 도구의 공식 CLI (references 에 있음) |
| 구현 중 지킬 것 | OWASP API Security Top 10 2023, OWASP Logging Cheat Sheet |

## 0. 해당 여부와 언어 판별

- CLAUDE.md 에 `stack:` 줄이 있는데 server 가 없으면 → "해당 없음: 스택 설정에 없음".
- 프로젝트에 `supabase/`만 있고 아래의 서버 코드가 없으면 이 스킬은 해당하지 않는다(`supabase` 플러그인이 맡는다).
- **언어를 판별하고 그 참고 파일을 읽는다.** 맞는 것마다 **Read 도구로 파일을 끝까지 읽고 그 점검도 돌린다**. 맞는 게 없으면 → "해당 없음: 서버 코드 없음".

  | 판별 근거 | 언어 | 참고 파일 |
  | --- | --- | --- |
  | package.json(dependencies 또는 devDependencies)에 `express`, `@nestjs/core`, `fastify`, `hono`, `koa` 중 하나 | Node | `${CLAUDE_SKILL_DIR}/references/node.md` |
  | `pyproject.toml`이나 `requirements*.txt`에 `fastapi`, `django`, `flask` 중 하나 | Python | `${CLAUDE_SKILL_DIR}/references/python.md` |
  | `go.mod` | Go | `${CLAUDE_SKILL_DIR}/references/go.md` |
  | `pom.xml`이나 `build.gradle*`에 `spring-boot` | Java/Kotlin | `${CLAUDE_SKILL_DIR}/references/jvm.md` |

  모노레포라면 이 항목이 어느 서비스를 건드리는지 정하고 그 디렉터리에서 작업한다. 분명하지 않으면 질문으로 돌려준다.

### 마이그레이션 담당

마이그레이션 점검은 플러그인 하나만 맡는다. `supabase`와 `server` 플러그인이 같은 규칙으로 정하므로, 어느 쪽이 먼저 돌아도 결과가 같다.

서버 마이그레이션 도구: `prisma/schema.prisma`, `drizzle.config.*`, TypeORM DataSource, `alembic.ini`, Django(`manage.py`와 앱의 `*/migrations/`. `supabase/migrations/`는 해당하지 않는다), `atlas.hcl`, Flyway `db/migration/` 또는 `flyway.conf`, Liquibase changelog, golang-migrate 폴더. 아래 규칙 중 처음 맞는 것을 적용한다.

1. 서버 마이그레이션 도구가 있고 **동시에** `supabase/migrations/`에 SQL 파일이 있다 → 스키마를 두 곳에서 관리하고 있다. "어느 쪽이 기준인가?"를 물을 것으로 돌려주고, 답을 받기 전까지는 **server** 가 맡는 것으로 본다.
2. 서버 마이그레이션 도구가 있다 → 데이터베이스가 Supabase Postgres 여도 **server** 가 맡는다.
3. `supabase/migrations/`가 있거나, 그것 없이 `supabase/config.toml`이 있다(아직 마이그레이션 없음) → **supabase** 가 맡는다. 첫 스키마 변경이 `supabase/migrations/`를 만든다.
4. 위 어느 것에도 해당하지 않는다 → 이 저장소에는 마이그레이션이 없다. 마이그레이션 항목은 "해당 없음"이다.

담당을 보고서 표의 첫 줄에 적는다. 담당이 아닌 플러그인은 마이그레이션 항목을 "건너뜀: 마이그레이션은 <담당> 플러그인 담당"으로 건너뛴다.

## 1. 환경 변수와 로컬 서비스

- `.env.example`의 키와 실제 `.env`의 키를 비교해 빠진 **이름**만 나열한다. 값은 절대 출력하지 않는다.
- `docker-compose.yml`이나 `compose.yaml`이 있으면 `docker compose ps`로 데이터베이스, 캐시 같은 서비스가 돌고 있는지 확인한다. 멈춰 있으면 띄울지 묻는다. 사용자가 거절하면 데이터베이스가 필요한 항목은 건너뛴다.

## 2. 언어별 점검 (참고 파일에서)

참고 파일의 설치, 런타임 버전, LSP, 마이그레이션 상태, 기준선 점검을 돌린다. Atlas(`atlas.hcl`)는 언어와 무관하다. 있으면 언어가 무엇이든 `references/go.md`의 Atlas 명령을 쓴다. **마이그레이션 상태 점검은 server 가 마이그레이션을 맡을 때만 돌린다.** 아니면 "건너뜀: 마이그레이션은 supabase 플러그인 담당"으로 건너뛴다. 데이터베이스를 건드리는 명령은 **로컬이나 개발 데이터베이스에만** 돌린다. 연결이 운영 환경으로 보이면 돌리지 않고 **중단한다**.

`npx --no-install`은 프로젝트에 설치된 도구만 쓰고 절대 내려받지 않는다. 도구가 설치돼 있지 않으면 설치하지 말고 "도구 설치 안 됨"으로 보고한다.

## 3. API 스펙과 사용처 (탐색 에이전트에 넘김)

OpenAPI 스펙 파일(`openapi.*`, `swagger.*`)이 있는지만 명령으로 확인한다. 이 항목이 바꿀 API 와 그 사용처를 직접 찾지 않는다. 아래 지시문을 탐색에 넣을 지시문으로 돌려준다.

> 이 항목(<항목 경로>)이 건드릴 API 를 찾아 요약하라: 라우트가 정의된 곳, 컨트롤러·핸들러·서비스·쿼리로 이어지는 흐름, 인증·인가 미들웨어가 적용되는 곳, 요청·응답 형식이 정의된 곳(DTO, 스키마, 스펙, 그리고 스펙을 코드에서 생성한다면 그 명령). 그다음 그 API 를 쓰는 쪽(같은 저장소의 프론트엔드 코드, 다른 서비스, 테스트)을 찾아라. 꼭 읽어야 할 파일 5–10개를 돌려줘라. 파일을 고치지 마라.

## 4. 구현 중 지킬 것 (돌려줄 것)

- 새 엔드포인트마다: 인증, **객체 단위 인가**(요청한 사용자가 이 객체의 주인인가), 입력 검증(스키마: zod, class-validator, pydantic, Bean Validation), 허용한 필드만 받기(mass assignment 금지), 목록의 페이지 크기 상한.
- 여러 쓰기는 한 트랜잭션으로 묶는다. 재시도될 수 있는 생성 요청(결제, 주문)에는 멱등성 키를 둔다.
- 스키마 변경은 마이그레이션 파일로 한다(도구의 생성 명령). 데이터베이스를 손으로 절대 바꾸지 않는다.
- 비밀번호, 토큰, 세션, 키, 연결 문자열은 절대 로그에 남기지 않는다. 개인 정보는 가린다.
- 계산·검증 로직과 인가 규칙은 테스트를 먼저 쓴다.
- 0단계에서 읽은 참고 파일의 언어별 규칙을 더한다.

## 돌려줄 형식

```markdown
### server start check
| Item | Result | Evidence |
| --- | --- | --- |
| Migration owner | … | server (prisma) / supabase (supabase/migrations) |
| Detection | pass | Node · NestJS, Prisma (references/node.md read) |
| Environment variables | … | missing keys: … |
| Local services | … | docker compose: db running |
| (language rows from the reference: install, runtime, LSP, migration status) | … | … |

#### Baseline
| Check | Command | Result |
| --- | --- | --- |

#### Exploration prompts
- API and consumers: (the step 3 prompt, filled in)

#### Add to the plan
- Migration: …

#### Questions to ask
- …

#### Rules during implementation
- (step 4, plus language rules)
```

**중단**이 하나라도 있으면 표 위에 `stop: <이유>`를 먼저 적는다.
