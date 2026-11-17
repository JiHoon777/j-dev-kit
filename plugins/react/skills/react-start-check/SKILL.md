---
name: react-start-check
description: React·Next.js 프로젝트의 작업 시작 전 점검. React·Next 버전과 React Compiler, eslint-plugin-react-hooks 설정, Next 라우터 방식을 확인하고, React Doctor 점수 기준선과 구현 중 지킬 것(Vercel react-best-practices 등)을 돌려준다. workflow 의 task-start 가 부른다.
user-invocable: false
version: "0.1.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# React 시작 점검

`task-start`가 부른다. 공통 프론트 점검(설치, 환경변수, 브라우저 테스트)은 `frontend` 플러그인이 한다. 여기서는 React 에만 해당하는 것을 한다.

각 항목을 **통과 · 실패 · 건너뜀(이유) · 중단**으로 판정하고 맨 아래 형식으로 돌려준다.

| 부분 | 출처 |
| --- | --- |
| 훅·컴파일러 규칙 | React 팀 `eslint-plugin-react-hooks` (`recommended` 프리셋) |
| 상태 점수 | React Doctor (`millionco/react-doctor`) CLI |
| 작성 규칙 | Vercel `react-best-practices` 스킬 (`vercel-labs/agent-skills`, 설치돼 있으면 그대로 호출) |

## 0. 해당 여부

- CLAUDE.md 에 `stack:`이 있고 react 가 없으면 → "해당 없음: stack 설정에 없음".
- package.json 에 `react`가 없으면 → "해당 없음: React 없음".

## 1. 버전과 구조

- `react`, `react-dom`, `next`(있으면)의 설치된 버전을 적는다.
- **React Compiler:** `babel-plugin-react-compiler`가 있거나 Next 설정에 `reactCompiler`가 켜져 있으면 "컴파일러 사용"으로 적는다. 이때 새 코드에 `useMemo`·`useCallback`·`memo`를 습관적으로 넣지 않는다는 것을 "구현 중 지킬 것"에 넣는다.
- **Next.js:** `app/`(App Router)인지 `pages/`(Pages Router)인지, 둘 다인지. App Router 면 서버 컴포넌트가 기본이고 `'use client'`가 어디에 있는지(파일 수와 대표 위치)를 적는다.
- **데이터 요청 방식:** `@tanstack/react-query`·`swr`·서버 컴포넌트 fetch·서버 액션 중 무엇을 쓰는지 적는다. 새 코드는 같은 방식을 쓴다.

## 2. eslint-plugin-react-hooks

- ESLint 설정에 `eslint-plugin-react-hooks`가 있고 `recommended`(규칙 `rules-of-hooks`, `exhaustive-deps`와 컴파일러 규칙 `purity`·`refs`·`immutability`·`set-state-in-effect`·`set-state-in-render`·`static-components` 등)가 켜져 있는지 본다.
- 없거나 일부만 켜져 있으면 실패가 아니라 "물을 것"으로 돌려준다: 추가할지는 사용자가 정한다.

## 3. 기준선

- 프로젝트의 린트 명령 결과(react-hooks 규칙 위반 개수를 따로).
- React Doctor: `npx -y react-doctor@0.9.22 --verbose --no-telemetry`의 점수(0~100)와 범주별 지적 수. 처음 돌릴 때 패키지를 내려받는다고 알린다. 실패하거나 거절하면 "React Doctor 없음"으로 건너뛴다.

## 4. 구현 중 지킬 것 (돌려줄 내용)

- `vercel-react-best-practices` 스킬이 설치돼 있으면 컴포넌트를 만들거나 고칠 때 부르고 그 규칙을 따른다(요청 폭포, 번들 크기, 서버 처리, 클라이언트 요청, 다시 그리기, 렌더링). 없으면 설치를 권할지 "물을 것"에 넣는다(`npx -y skills@1.7.5 add vercel-labs/agent-skills`).
- 훅은 컴포넌트·커스텀 훅 최상위에서만 부른다. 조건·반복 안에서 부르지 않는다.
- 다른 상태에서 계산되는 값은 상태로 두지 않고 렌더링 중에 계산한다. `useEffect`로 상태를 맞추지 않는다.
- `useEffect`에서 구독·타이머·이벤트를 만들면 정리 함수를 돌려준다. 요청은 경합을 막는다(취소 또는 무시 플래그).
- 목록의 `key`는 항목의 고유 값. 추가·삭제·정렬되는 목록에 배열 인덱스를 쓰지 않는다.
- Next App Router: `'use client'`는 상호작용이 필요한 가장 작은 컴포넌트에만 붙인다. 비밀값·서버 전용 모듈은 클라이언트 컴포넌트에서 import 하지 않는다(`server-only` 패키지가 있으면 쓴다).
- 남이 쓴 값을 `dangerouslySetInnerHTML`로 넣지 않는다.

## 돌려줄 형식

```markdown
### react 시작 점검
| 항목 | 결과 | 근거 |
| --- | --- | --- |
| 버전 | 통과 | react 19.x, next 16.x (App Router) |
| React Compiler | … | … |
| react-hooks 린트 | … | recommended 켜짐 / 없음 → 물을 것 |
| 데이터 요청 방식 | … | react-query |

#### 기준선
| 검사 | 명령 | 결과 |
| --- | --- | --- |
| 린트(react-hooks) | `pnpm lint` | 위반 0 |
| React Doctor | `npx -y react-doctor@0.9.22 --verbose --no-telemetry` | 82점 |

#### 물을 것
- …

#### 구현 중 지킬 것
- (4번 중 해당하는 것)
```
