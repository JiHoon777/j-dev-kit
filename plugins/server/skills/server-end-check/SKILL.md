---
name: server-end-check
description: 백엔드 프로젝트의 작업 마무리 점검. 검사를 기준선과 비교하고, 도구로 마이그레이션 누락·순서, API 의 깨지는 변경(oasdiff), 새 환경변수를 확인하고, 서버를 띄워 바뀐 엔드포인트를 직접 호출한다. 서버 코드가 바뀌었으면 api-reviewer 에이전트를 리뷰에 넣으라고 돌려준다. workflow 의 task-end 가 부른다.
user-invocable: false
version: "0.1.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# 서버 종료 점검

`task-end`가 부른다. 각 항목을 **통과 · 실패 · 건너뜀(이유)**으로 판정하고 맨 아래 형식으로 돌려준다.

이 스킬은 **명령을 돌려 결과를 확인하는 것**만 한다. 코드를 읽고 판단하는 리뷰(권한, 입력 검증, 깨지는 변경의 영향, 로그의 비밀값, 위험한 DDL 처리)는 직접 하지 않고 `server:api-reviewer` 에이전트에 넘긴다(6번).

## 0. 해당 여부

`server-start-check`와 같은 기준. 해당 없으면 "해당 없음". 바뀐 파일에 서버 코드·마이그레이션·API 명세가 없으면 1만 하고 나머지는 "서버 변경 없음"으로 건너뛴다.

## 1. 검사 (기준선과 비교)

`### 기준선`과 같은 명령을 다시 돌린다. 새 실패가 있으면 실패. Go 에서 `govulncheck`를 쓰면 새 취약점은 실패.

## 2. 마이그레이션

| 도구 | 누락 확인 (모델은 바뀌었는데 마이그레이션이 없음) |
| --- | --- |
| Prisma | `npx --no-install prisma migrate diff --from-migrations prisma/migrations --to-schema prisma/schema.prisma --exit-code` → 2 면 실패. `npx --no-install prisma validate` |
| Drizzle | `npx --no-install drizzle-kit generate` 후 `git status --porcelain <out 폴더>`에 새 파일이 생기면 실패(생긴 파일은 지우지 말고 보고한다). `npx --no-install drizzle-kit check` |
| TypeORM | `npx --no-install typeorm migration:generate <임시경로> -d <DataSource>`가 파일을 만들면 실패(만든 임시 파일은 지운다) |
| Alembic | `alembic check` 실패면 실패 |
| Django | `python manage.py makemigrations --check` 실패면 실패 |
| Atlas | `atlas migrate validate`, `atlas migrate lint --dev-url <dev> --latest <새 파일 수>` |
| Flyway·Liquibase | 새 changeset·파일이 diff 에 있는지 확인, `flyway validate` |

이어서:

- **처음부터 적용:** 로컬·개발 DB 를 비우고 전체 마이그레이션을 다시 적용할지 **묻는다**(데이터가 지워진다). 승인하면 돌린다(예: `prisma migrate reset`, `alembic downgrade base && alembic upgrade head`, Django 는 테스트 DB 생성). 거절하면 "확인 못 함".
- **순서:** 기준 브랜치에 작업 도중 새 마이그레이션이 들어왔는지 본다. Alembic·Django 는 head 가 둘이면 실패(merge 마이그레이션 필요), 타임스탬프 방식은 새 파일이 기준 브랜치의 최신보다 늦어야 한다.
- **위험한 DDL (위치만 찾는다):** 새 마이그레이션 파일에서 `grep -niE "drop (table|column)|truncate|delete from|alter column|set not null|not null|create (unique )?index|rename"`으로 줄을 찾아 `파일:줄`만 적고 **확인 필요**로 표시한다. 어떻게 다룰지(데이터 보존, 되돌리기)는 `api-reviewer`가 판단한다.

## 3. API 계약

- OpenAPI 명세가 있으면: 기준 브랜치의 명세(`git show origin/<기준>:<명세 경로>`)와 비교한다. `oasdiff`가 있으면 `oasdiff breaking --fail-on ERR <기준 명세> <새 명세>`(깨지는 변경이 있으면 종료 코드 1). `oasdiff`가 없으면 "oasdiff 없음"으로 적고, 두 명세 경로를 `api-reviewer`에 넘겨 비교하게 한다.
- 코드에서 명세를 생성하는 프로젝트면 생성 명령을 돌려 `git diff --exit-code <명세>`로 명세가 코드와 맞는지 본다. 다르면 실패.
- 깨지는 변경이 나오면 실패가 아니라 **확인 필요**: 쓰는 쪽에 미치는 영향은 `api-reviewer`가 보고, 버전을 올릴지는 사용자가 정한다.

## 4. 환경변수

- 코드에서 새로 읽는 환경변수 이름(diff 의 새 줄에서 `process.env.`, `os.environ`, `os.getenv`, `getenv(`, `@Value("${`)을 모아 `.env.example`에 있는지 명령으로 대조한다. 없으면 실패.
- `.env`·`.env.local` 같은 값 파일이 커밋 대상에 있으면 실패.

## 5. 실제 호출

서버를 로컬에서 띄우고(테스트 설정이 있으면 그것으로) 바뀐 엔드포인트마다 수용 기준의 요청을 `curl`로 보낸다. 상태 코드와 응답 요지를 근거에 적는다. 인증이 필요한 엔드포인트는 인증 없이, 그리고 **다른 사용자의 객체 id 로** 한 번씩 보내 401·403·404 가 나오는지 본다. 띄울 수 없으면 "확인 못 함"과 이유.

## 6. 리뷰에 넣을 에이전트

서버 코드(라우트·컨트롤러·핸들러·서비스·권한 미들웨어·DB 쿼리)나 API 명세, 마이그레이션이 바뀌었으면 `server:api-reviewer`를 `task-end` 리뷰 단계에 넣으라고 돌려준다. 근거(바뀐 파일), 2번의 위험한 DDL 위치, 3번의 oasdiff 결과(없으면 두 명세 경로), 5번의 호출 결과를 같이 넘긴다.

## 돌려줄 형식

```markdown
### server 종료 점검
| 항목 | 결과 | 근거 |
| --- | --- | --- |
| 검사(기준선 비교) | … | 새 실패 0 |
| 마이그레이션 누락 | … | `prisma migrate diff … --exit-code` 0 |
| 처음부터 적용 | … | … / 확인 못 함 |
| 순서 | … | … |
| 위험한 DDL 위치 | … | … |
| API 계약 | … | oasdiff 깨지는 변경 0 / 명세 생성 일치 |
| 환경변수 | … | 새 변수 2개 모두 .env.example 에 있음 |
| 실제 호출 | … | POST /orders 201, 다른 사용자 id 로 GET 404 |

#### 실패 상세
- `파일:줄` 무엇이 문제인지, 고치는 법

#### 리뷰에 넣을 에이전트
- `server:api-reviewer` — 근거: …

#### 고친 뒤 할 것
- 고친 엔드포인트 실제 호출(5번) 다시
```
