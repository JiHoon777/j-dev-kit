---
name: server-end-check
description: 백엔드 프로젝트의 작업 마무리 점검. 검사를 기준선과 비교하고, 모델 변경이 마이그레이션에 다 담겼는지, 위험한 DDL, API 의 깨지는 변경(oasdiff), 새 환경변수, 로그의 비밀값을 확인하고, 서버를 띄워 바뀐 엔드포인트를 직접 호출한다. API 가 바뀌었으면 api-reviewer 를 리뷰에 넣으라고 돌려준다. workflow 의 task-end 가 부른다.
user-invocable: false
version: "0.1.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# 서버 종료 점검

`task-end`가 부른다. 각 항목을 **통과 · 실패 · 건너뜀(이유)**으로 판정하고 맨 아래 형식으로 돌려준다.

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
- **위험한 DDL:** `drop table`·`drop column`·`truncate`, 형 변환, 기존 열에 `not null` 추가(기본값·채우기 없이), 큰 테이블의 잠금 걸리는 인덱스 생성, 이름 변경. 있으면 **확인 필요**로 표시하고 데이터 보존·되돌리기 방법을 PR 설명에 쓰도록 돌려준다.

## 3. API 계약

- OpenAPI 명세가 있으면: 기준 브랜치의 명세와 비교한다. `oasdiff`가 있으면 `oasdiff breaking --fail-on ERR <기준 명세> <새 명세>`(깨지는 변경이 있으면 종료 코드 1). 없으면 직접 본다: 지운·이름 바꾼 필드, 형·기본값 변경, 새 필수 요청 필드, 지운 엔드포인트, 바뀐 상태 코드.
- 코드에서 명세를 생성하는 프로젝트면 생성 명령을 돌려 명세가 코드와 맞는지 본다.
- 새 엔드포인트가 명세에 없으면 실패(문서화되지 않은 API).
- 깨지는 변경이 있으면 실패가 아니라 **확인 필요**: 쓰는 쪽이 같이 바뀌었는지, 버전을 올릴지 사용자가 정한다.

## 4. 설정과 로그

- 새 환경변수가 `.env.example`과 설정 문서에 이름만 들어갔는지. 값이 커밋됐으면 실패.
- 바뀐 코드의 로그·에러 응답에 비밀번호·토큰·세션·키·연결 문자열·스택 트레이스가 나가는지. 있으면 실패.

## 5. 실제 호출

서버를 로컬에서 띄우고(테스트 설정이 있으면 그것으로) 바뀐 엔드포인트마다 수용 기준의 요청을 `curl`로 보낸다. 상태 코드와 응답 요지를 근거에 적는다. 인증이 필요한 엔드포인트는 인증 없이, 그리고 **다른 사용자의 객체 id 로** 한 번씩 보내 401·403·404 가 나오는지 본다. 띄울 수 없으면 "확인 못 함"과 이유.

## 6. 리뷰에 넣을 에이전트

라우트·컨트롤러·핸들러·API 명세·권한 미들웨어·DB 쿼리가 바뀌었으면 `server:api-reviewer`를 `task-end` 리뷰 단계에 넣으라고 돌려준다. 근거(바뀐 파일)를 같이 적는다.

## 돌려줄 형식

```markdown
### server 종료 점검
| 항목 | 결과 | 근거 |
| --- | --- | --- |
| 검사(기준선 비교) | … | 새 실패 0 |
| 마이그레이션 누락 | … | `prisma migrate diff … --exit-code` 0 |
| 처음부터 적용 | … | … / 확인 못 함 |
| 순서 | … | … |
| 위험한 DDL | … | … |
| API 계약 | … | oasdiff 깨지는 변경 0 |
| 설정·로그 | … | … |
| 실제 호출 | … | POST /orders 201, 다른 사용자 id 로 GET 404 |

#### 실패 상세
- `파일:줄` 무엇이 문제인지, 고치는 법

#### 리뷰에 넣을 에이전트
- `server:api-reviewer` — 근거: …

#### 고친 뒤 할 것
- 고친 엔드포인트 실제 호출(5번) 다시
```
