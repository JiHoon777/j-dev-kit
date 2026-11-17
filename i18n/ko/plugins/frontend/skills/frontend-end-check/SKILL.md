---
name: frontend-end-check
description: 프론트엔드 프로젝트의 마무리 점검. workflow 플러그인 task 스킬의 end 모드가 부른다. 프레임워크를 감지하고, 점검 결과를 기준선과 비교하고, 남은 디버그 표시를 세고, Chrome DevTools로 콘솔·네트워크·Lighthouse를 확인하고, 해당 reference 파일(svelte.md, react.md)의 프레임워크 도구를 실행한다. 리뷰에 넣을 에이전트(ui-reviewer, svelte-reviewer, react-reviewer)와 고친 뒤 할 브라우저 테스트를 돌려준다.
user-invocable: false
version: "0.3.3"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> 번역본입니다. 원문은 [plugins/frontend/skills/frontend-end-check/SKILL.md](../../../../../../plugins/frontend/skills/frontend-end-check/SKILL.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# 프론트엔드 마무리 점검

`/task end`가 부른다. 프론트엔드 공통 점검은 여기에 있고, 프레임워크별 점검은 `references/`에 있다.

**이 스킬은 명령과 도구를 실행하고 결과를 비교하기만 한다.** diff를 읽고 판단하는 리뷰는 여기서 하지 않는다. 그 일은 리뷰 에이전트(`frontend:ui-reviewer`, 그리고 레퍼런스에 적힌 프레임워크 리뷰어)에게 넘기고, `/task end`가 다른 리뷰 에이전트와 함께 병렬로 띄운다.

각 항목을 **통과 · 실패 · 건너뜀(이유)** 중 하나로 판정하고, 끝에 있는 형식으로 돌려준다. `/task end`는 실패를 발견 사항 목록에 넣고, 고친 뒤 이 스킬을 다시 부른다. 보고서는 프로젝트의 언어로 쓴다.

## 0. 적용 여부와 프레임워크 감지

- `frontend-start-check`와 같은 기준이다. 해당 없으면 → "해당 없음: <이유>". 바뀐 프론트엔드 코드가 없으면 1단계만 하고 나머지는 "프론트엔드 변경 없음"으로 건너뛴다.
- **프레임워크를 감지하고 그 레퍼런스를 읽는다.** 맞는 것마다 **Read 도구로 파일 전체를 읽고 그 점검도 실행한다**:

  | package.json에서 감지(dependencies 또는 devDependencies) | 레퍼런스 |
  | --- | --- |
  | `svelte` | `${CLAUDE_SKILL_DIR}/references/svelte.md` |
  | `react` | `${CLAUDE_SKILL_DIR}/references/react.md` |

## 1. 점검(기준선과 비교)

항목의 `Implementation Notes`에 있는 `### Baseline`과 같은 명령을 실행한다.

- 기준선에 없는 실패 → 실패. 기준선 실패가 그대로면 통과지만, 근거에 "기존 실패 N개 그대로"라고 쓴다. 사라진 실패도 적는다.
- 빌드를 실행한다. 개발 서버가 아니라 빌드에서만 드러나는 문제(서버 렌더링 중 `window`/`document` 접근, 정적 생성 실패, 빌드 시점에 빠진 환경 변수)를 잡는다.
- `typescript-lsp`가 켜져 있으면 편집하는 동안 진단이 나왔을 수 있지만, 그것이 타입 체크 명령을 대신하지는 않는다. 실행한다.

## 2. 남은 표시(명령으로 셈)

`git diff <기준>...HEAD -U0`에서 **추가된 줄**만 센다. 개수와 위치만 기록한다. 각각이 괜찮은지 정하는 것은 `ui-reviewer`의 일이다.

- `console.log`, `debugger`, `.only(`, `.skip(` → 하나라도 있으면 실패.
- `any`, `as any`, `@ts-ignore`, `@ts-expect-error`, `eslint-disable` → 개수와 위치를 기록한다. 이유가 타당한지는 `ui-reviewer`가 본다.
- `package.json` 의존성은 바뀌었는데 lockfile은 바뀌지 않았으면 → 실패.

## 3. 브라우저 도구 점검

`chrome-devtools` 스킬을 호출하고 개발 서버를 띄운 뒤, 바뀐 화면마다:

- 콘솔 오류(`list_console_messages`)와 실패한 요청(`list_network_requests`의 4xx/5xx). 있으면 → 실패. 없는 URL을 일부러 열어서 나온 404는 괜찮다.
- `lighthouse_audit` 접근성 점수와 발견 사항. 바뀐 화면에 새 발견 사항이 있으면 → 실패. 점수는 근거로 기록한다.
- 화면이 무거워졌으면(큰 목록, 애니메이션, 이미지) 성능 트레이스(`performance_start_trace` → `performance_stop_trace`)에서 LCP, INP, CLS를 기록한다.

도구를 쓸 수 없으면 이 항목을 "브라우저 도구 없음"으로 건너뛰되, `/task end`가 아래 4단계의 브라우저 테스트를 다른 방법으로 해야 한다고 말한다.

## 4. 고친 뒤 할 것(돌려줄 것): 브라우저 테스트

`frontend-start-check` 7단계 절차를 그대로 돌려준다. 그리고:

- 리뷰 발견 사항을 고쳤으면 각각이 설명하는 상황을 다시 만들어 이제 괜찮은지 확인한다.
- 고친 것이 없어도 병합 전에 한 번은 한다.

## 5. 리뷰에 넣을 에이전트

UI 코드(컴포넌트, 페이지, 스타일, 클라이언트 로직)가 바뀌었으면 근거(바뀐 UI 파일 목록과 2단계 표시 위치)와 함께 `frontend:ui-reviewer`를 돌려준다. 이 에이전트는 사용자 입력의 출력, 로딩·빈 결과·오류 상태, 중복 요청, 접근성, 공개 환경 변수, 의존성, 2단계에서 센 표시의 이유를 리뷰한다. 0단계에서 읽은 레퍼런스에 적힌 프레임워크 리뷰어도 돌려준다.

## 돌려줄 형식

```markdown
### frontend end check
| Item | Result | Evidence |
| --- | --- | --- |
| Checks (vs baseline) | … | 0 new failures (0 existing) |
| Build | … | … |
| Leftover markers | … | console.log 0, @ts-ignore 1 (src/a.ts:12) |
| Console and network | … | … |
| Lighthouse accessibility | … | score …, new findings … |
| (framework rows from the reference) | … | … |

#### Failure details
- `file:line` what the problem is, how to fix it

#### Agents to add to the review
- `frontend:ui-reviewer` — evidence: changed UI files …
- (framework reviewers from the reference)

#### After fixes
- Browser test: …
- (framework items from the reference)
```
