---
max_turns: 15
timeout_seconds: 900
allowed_tools: [Agent, Read, Grep, Glob]
---

`frontend:frontend-reviewer` 에이전트 하나로 이 저장소의 `git diff main...HEAD`를 리뷰한다. 셸은 없고, 그 diff 는 작업 디렉터리의 `review.diff`에 있다. 지시문에 범위(`review.diff`, 곧 `git diff main...HEAD`), 항목 파일 `docs/backlog/001-feat-cart.md`, 근거(바뀐 UI 파일 `app/cart/*.tsx`, `app/cart/actions.ts`, 프레임워크 React 19 / Next.js App Router)를 넣는다. 에이전트의 보고를 그대로 마지막 메시지에 옮겨 쓰고 다른 말은 덧붙이지 않는다.
