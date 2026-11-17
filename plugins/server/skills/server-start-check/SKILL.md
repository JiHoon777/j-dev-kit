---
name: server-start-check
description: 백엔드 프로젝트의 작업 시작 전 점검. 언어·프레임워크·ORM 을 판별하고, 설치, 언어 서버(LSP) 연결, 환경변수, 로컬 의존 서비스, 마이그레이션 적용 상태, 검사 기준선, API 명세 위치를 확인해 돌려준다. workflow 의 task-start 가 부른다.
user-invocable: false
version: "0.1.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# 서버 시작 점검

`task-start`가 부른다. 각 항목을 **통과 · 실패 · 건너뜀(이유) · 중단**으로 판정하고 맨 아래 형식으로 돌려준다. 고치는 것은 이 스킬의 일이 아니다.

| 부분 | 출처 |
| --- | --- |
| 코드 진단 | Anthropic 공식 LSP 플러그인(`typescript-lsp`, `pyright-lsp`, `gopls-lsp`, `jdtls-lsp`, `kotlin-lsp` @claude-plugins-official) |
| 마이그레이션 상태 | 각 ORM·도구의 공식 CLI (아래 표) |

## 0. 해당 여부와 판별

- CLAUDE.md 에 `stack:`이 있고 server 가 없으면 → "해당 없음: stack 설정에 없음".
- 아래 중 하나도 없으면 → "해당 없음: 서버 코드 없음".

| 판별 근거 | 언어 · 프레임워크 |
| --- | --- |
| package.json 에 `express`·`@nestjs/core`·`fastify`·`hono`·`koa` | Node |
| `pyproject.toml`·`requirements*.txt`에 `fastapi`·`django`·`flask` | Python |
| `go.mod` | Go |
| `pom.xml`·`build.gradle*`에 `spring-boot` | Java/Kotlin · Spring |

| 판별 근거 | 마이그레이션 도구 |
| --- | --- |
| `prisma/schema.prisma` | Prisma |
| `drizzle.config.*` | Drizzle |
| `typeorm` 의존성 + DataSource 파일 | TypeORM |
| `alembic.ini` | Alembic |
| `manage.py` + `*/migrations/` | Django |
| `atlas.hcl` | Atlas |
| `flyway.conf`·`db/migration/` | Flyway |
| `liquibase.properties`·changelog | Liquibase |

`supabase/`만 있고 위 서버 코드가 없으면 이 스킬은 해당 없음이다(`supabase` 플러그인이 한다).

## 1. 설치와 실행 환경

- lockfile 을 바꾸지 않는 설치: Node 는 `frontend-start-check`와 같은 규칙, Python 은 `uv sync --frozen`(uv.lock) / `poetry install --sync`(poetry.lock) / `pip install -r requirements.txt`(가상환경 안에서), Go 는 `go mod download`, Java 는 `./gradlew dependencies` 또는 `./mvnw -q dependency:resolve`.
- 런타임 버전(`.nvmrc`, `.python-version`, `go.mod`의 `go`, `java -version`)이 맞는지.
- 실패하면 **중단**.

## 2. 언어 서버(LSP)

판별한 언어의 LSP 플러그인이 켜져 있고 실행 파일이 PATH 에 있는지 본다: `typescript-language-server`, `pyright-langserver`, `gopls`, `jdtls`. 플러그인이 없거나 실행 파일이 없으면 실패가 아니라 "물을 것"으로 돌려준다(설치는 사용자가 한다. 예: `npm i -g pyright`).

## 3. 환경변수와 로컬 서비스

- `.env.example`의 키와 실제 `.env`의 키를 비교해 빠진 **이름만** 적는다. 값은 출력하지 않는다.
- `docker-compose.yml`·`compose.yaml`이 있으면 `docker compose ps`로 DB·캐시 같은 서비스가 떠 있는지 본다. 꺼져 있으면 켤지 묻는다. 거절하면 DB 가 필요한 항목은 건너뛴다.

## 4. 마이그레이션 상태

판별한 도구의 명령을 돌린다. 적용 안 된 마이그레이션이 있으면 실패(적용할지 묻도록 돌려준다), 히스토리가 어긋났으면 **중단**.

| 도구 | 적용 상태 | 모델과 마이그레이션 차이(누락) |
| --- | --- | --- |
| Prisma | `npx --no-install prisma migrate status` (적용 안 됨·어긋남이면 종료 코드 1) | `npx --no-install prisma migrate diff --from-migrations prisma/migrations --to-schema prisma/schema.prisma --exit-code` (차이 있으면 2). Prisma 7 은 `prisma.config.ts`의 데이터소스를 쓴다 |
| Drizzle | 상태 명령이 없다. `drizzle.__drizzle_migrations` 테이블과 마이그레이션 폴더를 비교 | `npx --no-install drizzle-kit check`(히스토리 충돌만 본다). 누락은 `drizzle-kit generate` 후 출력 폴더에 새 파일이 생기는지로 본다(시작 점검에서는 돌리지 않는다) |
| TypeORM | `npx --no-install typeorm migration:show -d <DataSource>` (`[ ]`가 적용 안 됨) | `migration:generate`는 변경이 없으면 종료 코드 1 (시작 점검에서는 돌리지 않는다) |
| Alembic | `alembic current --check-heads`(1.17.1+), 이전 버전은 `alembic current`와 `alembic heads` 비교 | `alembic check` (1.9+) |
| Django | `python manage.py migrate --check` | `python manage.py makemigrations --check` |
| Atlas | `atlas migrate status --url <url> --dir <dir>` | `atlas migrate validate` |
| Flyway | `flyway info` (pending 확인) | — |
| Liquibase | `liquibase status --verbose` | — |

`npx --no-install` 은 프로젝트에 설치된 도구만 쓰고 내려받지 않는다. 설치돼 있지 않으면 설치하지 말고 "도구 없음"으로 알린다.

DB 에 닿는 명령은 **로컬·개발 DB 에만** 돌린다. 연결 주소가 운영으로 보이면 돌리지 않고 **중단**한다.

## 5. 기준선

프로젝트 CLAUDE.md 의 검증 명령, 없으면 언어별로 찾는다.

- Node: package.json 의 `lint`·`typecheck`(없으면 `tsc --noEmit`)·`test`.
- Python: `ruff check`·`mypy`·`pytest`(설정 파일에 있는 것만).
- Go: `go vet ./...`, `go test ./...`. `govulncheck`가 있으면 `govulncheck ./...`.
- Java: `./gradlew check` 또는 `./mvnw -q verify`.

명령, 종료 코드, 실패 개수, 실패 이름(많으면 앞 10개)을 적는다. 이미 실패하는 것은 **기준선**이다.

## 6. API 명세와 쓰는 쪽 (탐색 에이전트에 넘긴다)

OpenAPI 명세 파일(`openapi.*`, `swagger.*`)이 있는지만 명령으로 확인해 적는다. 이번 항목이 바꿀 API 와 그것을 쓰는 쪽은 직접 찾지 않고 아래 지시문을 "탐색에 넣을 지시문"으로 돌려준다.

> 이 항목(<항목 경로>)이 건드릴 API 를 찾아 정리하라: 라우트 정의 위치, 컨트롤러·핸들러·서비스·쿼리까지의 흐름, 인증·권한 미들웨어가 어디서 걸리는지, 요청·응답 형식이 정의된 곳(DTO·스키마·명세, 명세를 코드에서 생성하면 그 명령). 그리고 그 API 를 쓰는 쪽(같은 저장소의 프론트 코드, 다른 서비스, 테스트)을 찾아라. 꼭 읽어야 할 파일 5~10개를 돌려줘라. 파일을 고치지 마라.

## 7. 구현 중 지킬 것 (돌려줄 내용)

- 새 엔드포인트마다: 인증 확인, **객체 단위 권한 확인**(요청한 사용자가 이 객체의 주인인지), 입력 검증(스키마: zod·class-validator·pydantic·Bean Validation), 받을 수 있는 필드만 받기(mass assignment 방지), 목록은 페이지 크기 상한.
- 여러 쓰기를 묶는 작업은 트랜잭션으로 묶는다. 재시도될 수 있는 생성 요청(결제, 주문)은 멱등 키를 둔다.
- 스키마 변경은 마이그레이션 파일로 만든다(도구의 생성 명령). 손으로 DB 를 바꾸지 않는다.
- 로그에 비밀번호·토큰·세션·키·연결 문자열을 남기지 않고, 개인정보는 가린다.
- 계산·검증 로직과 권한 규칙은 테스트를 먼저 쓴다.

## 돌려줄 형식

```markdown
### server 시작 점검
| 항목 | 결과 | 근거 |
| --- | --- | --- |
| 판별 | 통과 | Node · NestJS, Prisma |
| 설치 | … | … |
| LSP | … | typescript-lsp 켜짐 / pyright 없음 → 물을 것 |
| 환경변수 | … | 빠진 키: … |
| 로컬 서비스 | … | docker compose: db 실행 중 |
| 마이그레이션 상태 | … | `prisma migrate status` 종료 0 |

#### 기준선
| 검사 | 명령 | 결과 |
| --- | --- | --- |

#### 탐색에 넣을 지시문
- API 와 쓰는 쪽: (6번 지시문)

#### 플랜에 넣을 것
- 마이그레이션: …

#### 물을 것
- …

#### 구현 중 지킬 것
- (7번)
```

**중단**이 있으면 표 위에 `중단: <이유>`를 먼저 쓴다.
