---
max_turns: 30
timeout_seconds: 1500
allowed_tools: [Skill, Agent, Read, Grep, Glob]
---

이 저장소의 `git diff main...HEAD`를 두 리뷰어로 동시에 리뷰한다: `code-review` 스킬, 그리고 `frontend:frontend-reviewer` 에이전트(근거: 바뀐 UI 파일 `app/cart/*.tsx`, `app/cart/actions.ts`, 프레임워크 React 19 / Next.js App Router). 셸은 없고, 그 diff 는 작업 디렉터리의 `review.diff`에 있다. 항목 파일은 `docs/backlog/001-feat-cart.md`다. 파일은 고치지 않는다. 두 리뷰어의 지적을 합쳐 중복을 빼고, 마지막 메시지에 `file:line — 문제` 형식으로 모두 쓴다.
