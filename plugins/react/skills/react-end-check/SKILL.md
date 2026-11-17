---
name: react-end-check
description: React·Next.js 프로젝트의 작업 마무리 점검. react-hooks 린트와 React Doctor 점수를 기준선과 비교하고 Next 빌드를 확인한다. React 코드가 바뀌었으면 react-reviewer 에이전트를 리뷰에 넣으라고 돌려준다. workflow 의 task-end 가 부른다.
user-invocable: false
version: "0.1.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# React 종료 점검

`task-end`가 부른다. 공통 프론트 점검과 브라우저 테스트는 `frontend` 플러그인이 한다.

이 스킬은 **도구를 돌려 결과를 비교하는 것**만 한다. diff 를 읽고 판단하는 리뷰(파생 상태, effect, key, 요청 폭포, Next 경계 등)는 직접 하지 않고 `react:react-reviewer` 에이전트에 넘긴다(4번).

각 항목을 **통과 · 실패 · 건너뜀(이유)**으로 판정하고 맨 아래 형식으로 돌려준다.

## 0. 해당 여부

`react-start-check`와 같은 기준. 해당 없으면 "해당 없음". 바뀐 파일에 `.jsx`·`.tsx`(와 훅을 담은 `.js`·`.ts`)가 없으면 1만 하고 나머지는 "React 변경 없음"으로 건너뛴다.

## 1. 린트 (기준선과 비교)

`### 기준선`의 린트 명령을 다시 돌린다. react-hooks 규칙(`rules-of-hooks`, `exhaustive-deps`, 컴파일러 규칙) 위반이 새로 생기면 실패. 새로 추가된 줄의 `eslint-disable` 개수와 위치를 적는다(이유가 정당한지는 `react-reviewer`가 본다).

## 2. React Doctor

`npx -y react-doctor@0.9.22 --verbose --no-telemetry --scope changed`를 돌린다. 기준선 점수보다 떨어졌거나 바뀐 파일에서 새 지적이 나오면 실패. 기준선이 없으면 점수만 근거에 적는다. 돌릴 수 없으면 "React Doctor 없음"으로 건너뛴다.

## 3. 빌드

Next.js 면 `next build`(프로젝트 빌드 스크립트)가 통과하는지 본다. `frontend-end-check`가 이미 돌렸으면 그 결과를 쓴다.

## 4. 리뷰에 넣을 에이전트

0번의 React 파일이 바뀌었으면 `react:react-reviewer`를 돌려준다. 근거(바뀐 파일 목록)와 React Doctor 지적을 같이 적는다. 이 에이전트가 파생 상태, effect 정리·경합, key, 요청 폭포, Next 서버/클라이언트 경계, 서버 액션 검증, `dangerouslySetInnerHTML`, 불필요한 메모이제이션, `eslint-disable`의 이유를 본다.

## 돌려줄 형식

```markdown
### react 종료 점검
| 항목 | 결과 | 근거 |
| --- | --- | --- |
| react-hooks 린트 | … | 새 위반 0, 새 eslint-disable 0 |
| React Doctor | … | 82 → 84 |
| 빌드 | … | … |

#### 실패 상세
- `파일:줄` 무엇이 문제인지, 고치는 법

#### 리뷰에 넣을 에이전트
- `react:react-reviewer` — 근거: 바뀐 파일 …

#### 고친 뒤 할 것
- 린트와 React Doctor 다시 돌리기
```
