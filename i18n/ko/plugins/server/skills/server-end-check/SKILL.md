---
name: server-end-check
description: 백엔드 프로젝트의 마무리 점검으로, workflow 플러그인 task 스킬의 end 모드가 부른다. 언어와 마이그레이션 도구를 판별하고, 검사 결과를 기준선과 비교하고, 도구로 빠졌거나 순서가 어긋난 마이그레이션, 호환성을 깨는 API 변경(oasdiff), 문서에 없는 설정 키를 찾고, 로컬 서버에서 바뀐 엔드포인트를 호출해 본다. 언어별 명령은 맞는 참고 파일(node.md, python.md, go.md, jvm.md)에서 가져온다. 서버 코드가 바뀌었으면 리뷰에 넣을 api-reviewer 에이전트를 돌려준다.
user-invocable: false
version: "0.3.3"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> 번역본입니다. 원문은 [plugins/server/skills/server-end-check/SKILL.md](../../../../../../plugins/server/skills/server-end-check/SKILL.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# 서버 종료 점검

`/task end`가 부른다. 백엔드 공통 점검은 여기에, 언어별·마이그레이션 도구별 명령은 `references/`에 있다.

**이 스킬은 명령을 돌리고 결과를 확인하는 것만 한다.** 코드를 읽고 판단하는 리뷰(인가, 입력 검증, 호환성을 깨는 변경의 영향, 로그 속 비밀 값, 위험한 DDL 을 다루는 법)는 `server:api-reviewer` 에이전트에 넘긴다(6단계).

각 항목을 **통과 · 실패 · 건너뜀(이유)** 중 하나로 판정하고 끝의 형식으로 돌려준다. 보고는 프로젝트의 언어로 쓴다.

## 0. 해당 여부와 언어 판별

- `server-start-check`와 같은 기준. 해당하지 않으면 → "해당 없음". 서버 코드, 마이그레이션, API 스펙 중 바뀐 것이 없으면 1단계만 하고 나머지는 "서버 변경 없음"으로 건너뛴다.
- **언어를 판별하고 그 참고 파일을 읽는다**(`server-start-check`와 같은 표). 맞는 것마다 **Read 도구로 파일을 끝까지 읽는다**:

  | 언어 | 참고 파일 |
  | --- | --- |
  | Node | `${CLAUDE_SKILL_DIR}/references/node.md` |
  | Python | `${CLAUDE_SKILL_DIR}/references/python.md` |
  | Go | `${CLAUDE_SKILL_DIR}/references/go.md` |
  | Java/Kotlin | `${CLAUDE_SKILL_DIR}/references/jvm.md` |

## 1. 검사 (기준선과 비교)

`### Baseline`과 같은 명령을 다시 돌린다. 새로 생긴 실패 → 실패. 언어별 추가 검사는 참고 파일에 있다.

## 2. 마이그레이션 (server 가 마이그레이션을 맡을 때만)

마이그레이션 담당은 `server-start-check`와 같은 규칙("마이그레이션 담당" 절)으로 정한다. supabase 가 맡으면 이 단계 전체를 "건너뜀: 마이그레이션은 supabase 플러그인 담당"으로 건너뛴다.

- **빠진 마이그레이션:** 판별한 도구에 대해 참고 파일의 명령을 돌린다(Atlas(`atlas.hcl`)는 언어와 무관하다. 있으면 어느 언어든 `references/go.md`의 Atlas 명령을 쓴다)(모델은 바뀌었는데 마이그레이션을 만들지 않았음 → 실패).
- **처음부터 다시 적용:** 로컬이나 개발 데이터베이스를 비우고 모든 마이그레이션을 다시 적용할지 **묻는다**(데이터가 사라진다). 승인하면 참고 파일의 reset 명령을 돌린다. 거절하면 → "검증 안 함".
- **순서:** 작업하는 동안 새 마이그레이션이 기준 브랜치에 들어왔는지 확인한다. head 가 둘(Alembic, Django) → 실패(merge 마이그레이션이 필요하다). 타임스탬프가 붙은 파일이라면 새 파일이 기준 브랜치의 가장 새 파일보다 늦어야 한다.
- **위험한 DDL (위치만):** 새 마이그레이션 파일에서 `grep -niE "drop (table|column)|truncate|delete from|alter column|set not null|not null|create (unique )?index|rename"`을 돌리고, `file:line`만 기록하고, **확인 필요**로 표시한다. 어떻게 다룰지(데이터 보존, 롤백)는 `api-reviewer`의 몫이다.

## 3. API 계약

- OpenAPI 스펙이 있으면: 기준 브랜치의 스펙(`git show origin/<기준>:<스펙 경로>`)과 비교한다. `oasdiff`가 설치돼 있으면 `oasdiff breaking --fail-on ERR <기준 스펙> <새 스펙>`을 돌린다(호환성을 깨는 변경이 있으면 exit 1). 없으면 "oasdiff 없음"으로 기록하고 두 스펙 경로를 `api-reviewer`에 넘겨 비교하게 한다.
- 스펙을 코드에서 생성한다면 생성 명령을 돌리고 `git diff --exit-code <스펙>`으로 코드와 맞는지 확인한다. 차이가 있음 → 실패.
- 호환성을 깨는 변경은 실패가 아니라 **확인 필요**다: 사용하는 쪽에 미치는 영향은 `api-reviewer`가, 버전을 올릴지는 사용자가 정한다.

## 4. 환경 변수

- 추가된 줄에서 새로 읽는 설정 키(읽는 패턴은 참고 파일에 있다)가 모두 `.env.example`에 이름으로 적혀 있는지 확인한다. 빠졌음 → 실패. 이름만 비교한다. 값은 절대 읽거나 출력하지 않는다.
- `.env`나 `.env.local` 같은 값 파일이 커밋하려고 스테이징돼 있으면 → 실패.

## 5. 실제 호출

서버를 로컬에서 띄우고(테스트 설정이 있으면 그것으로), 바뀐 엔드포인트마다 인수 조건의 요청을 `curl`로 보낸다. 상태 코드와 응답 요지를 기록한다. 인증이 필요한 엔드포인트는 인증 없이 한 번, **다른 사용자의 객체 id 로** 한 번 더 요청해 401, 403, 404 중 하나가 나오는지 확인한다. 서버를 띄울 수 없으면 → 이유와 함께 "검증 안 함".

## 6. 리뷰에 넣을 에이전트

서버 코드(라우트, 컨트롤러, 핸들러, 서비스, 인가 미들웨어, 데이터베이스 쿼리), API 스펙, 마이그레이션 중 바뀐 것이 있으면 `server:api-reviewer`를 돌려준다. 함께 넘길 것: 근거(바뀐 파일), 2단계의 위험한 DDL 위치(server 가 마이그레이션을 맡을 때만), 3단계의 oasdiff 결과(또는 두 스펙 경로), 5단계의 호출 결과.

## 돌려줄 형식

```markdown
### server end check
| Item | Result | Evidence |
| --- | --- | --- |
| Migration owner | … | server (prisma) / supabase |
| Checks (vs baseline) | … | 0 new failures |
| Missing migration | … | `prisma migrate diff … --exit-code` 0 |
| Apply from scratch | … | … / not verified |
| Order | … | … |
| Risky DDL locations | … | … |
| API contract | … | oasdiff 0 breaking changes / generated spec matches |
| Environment variables | … | 2 new variables, both in .env.example |
| Actual calls | … | POST /orders 201, GET with another user's id 404 |

#### Failure details
- `file:line` what the problem is, how to fix it

#### Agents to add to the review
- `server:api-reviewer` — evidence: …

#### After fixes
- Call the fixed endpoints again (step 5)
```
