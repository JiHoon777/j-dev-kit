---
name: react-end-check
description: React·Next.js 프로젝트의 작업 마무리 점검. react-hooks 린트와 React Doctor 점수를 기준선과 비교하고, 훅·effect·key·서버/클라이언트 경계·dangerouslySetInnerHTML 같은 React 전용 문제를 diff 에서 찾아 돌려준다. workflow 의 task-end 가 부른다.
user-invocable: false
---

# React 종료 점검

`task-end`가 부른다. 공통 프론트 점검과 브라우저 테스트는 `frontend` 플러그인이 한다.

각 항목을 **통과 · 실패 · 건너뜀(이유)**으로 판정하고 맨 아래 형식으로 돌려준다.

## 0. 해당 여부

`react-start-check`와 같은 기준. 해당 없으면 "해당 없음". 바뀐 파일에 `.jsx`·`.tsx`(와 훅을 담은 `.js`·`.ts`)가 없으면 1만 하고 나머지는 "React 변경 없음"으로 건너뛴다.

## 1. 린트 (기준선과 비교)

`### 기준선`의 린트 명령을 다시 돌린다. react-hooks 규칙(`rules-of-hooks`, `exhaustive-deps`, 컴파일러 규칙) 위반이 새로 생기면 실패. 위반을 `eslint-disable`로 끈 줄이 새로 생겼으면 이유가 있는지 보고, 없으면 실패.

## 2. React Doctor

`npx -y react-doctor@latest --verbose --no-telemetry --scope changed`를 돌린다. 기준선 점수보다 떨어졌거나 바뀐 파일에서 새 지적이 나오면 실패. 기준선이 없으면 점수만 근거에 적는다. 돌릴 수 없으면 "React Doctor 없음"으로 건너뛴다.

## 3. diff 점검 (도구가 못 잡는 것)

- **파생 상태:** 다른 상태·props 에서 계산되는 값을 `useState`에 두고 `useEffect`로 맞추는 곳.
- **effect 정리·경합:** 구독·타이머·이벤트 리스너에 정리 함수가 없는 곳, 요청 결과가 늦게 도착해 이전 응답이 덮어쓸 수 있는 곳.
- **key:** 추가·삭제·정렬되는 목록에 인덱스 key.
- **요청 폭포:** 부모가 받은 뒤 자식이 다시 요청하는 순차 요청이 새로 생김(병렬로 할 수 있는데).
- **Next 경계:** `'use client'` 파일이 서버 전용 모듈·비밀 환경변수(공개 접두어 없는 것)를 import. 서버 컴포넌트에서 클라이언트 전용 API(`window`, 훅) 사용. 서버 액션이 입력 검증·권한 확인 없이 DB 를 바꿈.
- **`dangerouslySetInnerHTML`:** 새로 쓴 곳의 값이 사용자 입력이면 실패.
- **불필요한 메모이제이션:** React Compiler 를 쓰는데 새로 넣은 `useMemo`·`useCallback`·`memo`는 근거에 적는다(실패 아님).

## 4. 빌드

Next.js 면 `next build`(프로젝트 빌드 스크립트)가 통과하는지 본다. `frontend-end-check`가 이미 돌렸으면 그 결과를 쓴다.

## 5. 리뷰에 넣을 에이전트

없음.

## 돌려줄 형식

```markdown
### react 종료 점검
| 항목 | 결과 | 근거 |
| --- | --- | --- |
| react-hooks 린트 | … | 새 위반 0 |
| React Doctor | … | 82 → 84 |
| 파생 상태 | … | … |
| effect 정리·경합 | … | … |
| key | … | … |
| 요청 폭포 | … | … |
| Next 경계 | … | … |
| dangerouslySetInnerHTML | … | … |
| 빌드 | … | … |

#### 실패 상세
- `파일:줄` 무엇이 문제인지, 고치는 법

#### 리뷰에 넣을 에이전트
- 없음

#### 고친 뒤 할 것
- 린트와 React Doctor 다시 돌리기
```
