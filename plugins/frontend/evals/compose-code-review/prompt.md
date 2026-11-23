---
max_turns: 30
timeout_seconds: 1500
allowed_tools: [Skill, Agent, Read, Grep, Glob]
---

`code-review` 스킬로 이 저장소의 `git diff main...HEAD`를 리뷰한다. 셸은 없고, 그 diff 는 작업 디렉터리의 `review.diff`에 있다. 항목 파일은 `docs/backlog/001-feat-cart.md`다. 파일은 고치지 않는다. 찾은 문제를 마지막 메시지에 `file:line — 문제` 형식으로 모두 쓴다.
