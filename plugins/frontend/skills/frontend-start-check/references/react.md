# React / Next.js: 시작 점검

package.json 에 `react`가 있을 때 `frontend-start-check`가 읽는다. 아래를 그 스킬의 "지킬 것"에 더한다.

## 지킬 것

- 컴포넌트를 만들거나 바꿀 때 `vercel-react-best-practices` 스킬이 있으면 부르고 따른다.
- 훅은 컴포넌트와 커스텀 훅의 최상위에서만 부른다.
- 다른 state 나 props 로 계산할 수 있는 값은 state 에 두지 않고 렌더링 중에 계산한다. `useEffect`로 state 를 맞추지 않는다.
- `useEffect`가 구독, 타이머, 리스너를 만들면 정리 함수를 반환한다. 요청은 늦게 온 응답이 새 응답을 덮지 않게 취소하거나 무시한다.
- 추가·삭제·순서 변경이 있는 목록의 `key`에 배열 인덱스를 쓰지 않는다.
- React Compiler(`babel-plugin-react-compiler`, Next `reactCompiler`)를 쓰면 습관적으로 `useMemo`, `useCallback`, `memo`를 더하지 않는다.
- Next App Router: `'use client'`는 상호작용이 필요한 가장 작은 컴포넌트에만. 클라이언트 컴포넌트에서 비밀 값이나 서버 전용 모듈을 import 하지 않는다. 서버 액션은 입력 검증과 권한 확인을 한다.
- 다른 사람이 쓴 값을 `dangerouslySetInnerHTML`로 넣지 않는다.
