> 번역본입니다. 원문은 [plugins/frontend/skills/frontend-start-check/references/react.md](../../../../../../../plugins/frontend/skills/frontend-start-check/references/react.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# React / Next.js: 시작 점검

package.json `dependencies`나 `devDependencies`에 `react`가 있을 때 `frontend-start-check`가 읽는다. 아래 행, 기준선 줄, 지시문, 질문, 규칙을 그 스킬의 보고서에 더한다.

| 부분 | 출처 |
| --- | --- |
| 훅과 컴파일러 규칙 | React 팀의 `eslint-plugin-react-hooks` (`recommended` 프리셋) |
| 건강 점수 | React Doctor (`millionco/react-doctor`) CLI |
| 작성 규칙 | Vercel `react-best-practices` 스킬(`vercel-labs/agent-skills`), 설치되어 있으면 그대로 호출 |

## 1. 버전과 구조

- 설치된 `react`, `react-dom`, `next`(있으면)의 버전을 기록한다.
- **React Compiler:** `babel-plugin-react-compiler`가 설치되어 있거나 Next 설정에서 `reactCompiler`가 켜져 있으면 "컴파일러 사용 중"으로 기록하고, 새 코드에서 습관처럼 `useMemo`, `useCallback`, `memo`를 쓰지 않는다는 것을 구현 중 지킬 것에 더한다.
- **Next.js:** `app/`(App Router), `pages/`(Pages Router), 또는 둘 다. `'use client'`가 있는 파일 수를 센다(개수만 센다. 어디에 왜 있는지는 탐색에 넣을 지시문으로 넘긴다).
- **데이터 가져오기:** `@tanstack/react-query`, `swr`, `@apollo/client`가 의존성에 있는지만 기록한다. 실제로 데이터를 어떻게 불러오는지는 여기서 조사하지 않는다. 그것은 탐색에 넣을 지시문으로 넘긴다.

## 2. eslint-plugin-react-hooks

- ESLint 설정에 `eslint-plugin-react-hooks`가 들어 있고 `recommended`가 켜져 있는지 확인한다(규칙 `rules-of-hooks`, `exhaustive-deps`, 그리고 `purity`, `refs`, `immutability`, `set-state-in-effect`, `set-state-in-render`, `static-components` 같은 컴파일러 규칙).
- 없거나 일부만 켜져 있어도 실패가 아니다. 질문으로 돌려준다. 추가할지는 사용자가 정한다.

## 3. 기준선

- 프로젝트의 lint 결과(react-hooks 위반은 따로 센다).
- React Doctor: `npx -y react-doctor@0.9.22 --verbose --no-telemetry`의 점수(0–100)와 카테고리별 발견 사항. 처음 실행할 때 패키지를 내려받는다고 사용자에게 알린다. 실패하거나 사용자가 거절하면 "React Doctor 없음"으로 건너뛴다.

## 4. 탐색에 넣을 지시문(돌려줄 것)

> 이 React 코드베이스가 데이터를 어떻게 불러오고 바꾸는지 요약한다: 쿼리 라이브러리(react-query, swr, …)와 쿼리 키·API 클라이언트가 있는 곳, 서버 컴포넌트 fetch, 서버 액션, 라우트 핸들러. App Router면 `'use client'` 경계가 어디에 있고 왜 거기 있는지. 이 항목(<항목 경로>)과 비슷한 기존 기능 하나를 끝까지 따라가 보고, 꼭 읽어야 할 파일 5–10개를 돌려준다. 파일을 고치지 않는다.

## 5. 구현 중 지킬 것(돌려줄 것)

- `vercel-react-best-practices` 스킬이 설치되어 있으면 컴포넌트를 만들거나 바꿀 때 호출하고 그 규칙(요청 워터폴, 번들 크기, 서버 작업, 클라이언트 fetch, 리렌더, 렌더링)을 따른다. 없으면 설치할지 묻는 질문을 더한다(`npx -y skills@1.7.5 add vercel-labs/agent-skills`).
- 훅은 컴포넌트와 커스텀 훅의 최상위에서만 부른다. 조건문이나 반복문 안에서 부르지 않는다.
- 다른 state로 계산한 값을 state에 두지 않는다. 렌더링 중에 계산한다. `useEffect`로 state를 맞추지 않는다.
- `useEffect`가 구독, 타이머, 이벤트 리스너를 만들면 정리 함수를 반환한다. 요청은 경쟁에 대비한다(취소나 무시 플래그).
- 목록의 `key`는 각 항목의 고유한 값이다. 추가·삭제되거나 순서가 바뀌는 목록에는 배열 인덱스를 절대 쓰지 않는다.
- Next App Router: `'use client'`는 상호작용이 필요한 가장 작은 컴포넌트에만 둔다. 클라이언트 컴포넌트에서 시크릿이나 서버 전용 모듈을 절대 import하지 않는다(`server-only` 패키지가 있으면 쓴다).
- 다른 사람이 쓴 값을 `dangerouslySetInnerHTML`로 절대 넣지 않는다.

## 더할 행

```markdown
| React versions | pass | react 19.x, next 16.x (App Router, 'use client' 12 files) |
| React Compiler | … | … |
| react-hooks lint | … | recommended on / missing → question |
| Data fetching | … | @tanstack/react-query in dependencies |
```

기준선 줄: `| Lint (react-hooks) | pnpm lint | 0 violations |`, `| React Doctor | npx -y react-doctor@0.9.22 --verbose --no-telemetry | 82 |`
