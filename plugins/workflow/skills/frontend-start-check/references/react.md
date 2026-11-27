# React / Next.js / React Router: 시작 점검

package.json 에 `react`가 있을 때 `frontend-start-check`가 읽는다. 아래를 그 스킬의 "지킬 것"에 더한다.

## 지킬 것

- 컴포넌트를 만들거나 바꿀 때 `vercel-react-best-practices` 스킬을 부르고 따른다. 컴포넌트의 짜임(합성, props 설계)을 바꾸면 `vercel-composition-patterns`도.
- `react-router`가 있으면 `react-router` 스킬을 부르고 따른다.
- 위 스킬이 설치돼 있지 않으면 설치하지 않는다. 아래 규칙만으로 가고, "<스킬 이름> 없음. `/kit-setup`을 돌리면 설치된다"를 지킬 것에 적어 돌려준다(`start`가 마지막 메시지에 알린다). CLAUDE.md `## 작업 설정`의 `- 공식 스킬 설치 안 함:` 줄에 그 이름(`react`, `react-router`)이 있으면 그 말은 적지 않는다.
- `next`가 있으면 Next 가 만든 `AGENTS.md`와 그것이 가리키는 설치된 버전의 문서를 API 의 기준으로 읽는다. 모르는 API 는 추측하지 않는다.
- 클라이언트 컴포넌트(`'use client'`)에서 비밀 값이나 서버 전용 모듈을 import 하지 않는다. 서버 액션과 라우트 핸들러는 입력 검증과 권한 확인을 한다.
- 다른 사람이 쓴 값을 `dangerouslySetInnerHTML`로 넣지 않는다.

## 물을 것

- Next 가 16.3 보다 낮고 `.next-docs/`가 없으면 `npx @next/codemod@canary agents-md`로 문서를 받을지 묻는다.
