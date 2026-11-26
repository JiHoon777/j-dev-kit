---
max_turns: 30
timeout_seconds: 2400
allowed_tools: [Skill, Agent, Read, Grep, Glob]
---

두 리뷰어, 곧 `code-review` 스킬과 general-purpose 에이전트 하나(지시: "이 diff 의 UI 코드를 리뷰해 문제를 모두 보고한다. 파일은 고치지 않는다")로 동시에 이 저장소의 `git diff main...HEAD`를 리뷰한다. 셸은 없고, 그 diff 는 작업 디렉터리의 `review.diff`에 있다. 항목 파일은 `docs/backlog/012-birthday-port-prototype.md`다. 파일은 고치지 않는다. 두 리뷰어의 지적을 합쳐 중복을 뺀다. 찾은 문제를 마지막 메시지에 모두 쓴다. 지적마다 🔴(꼭 고칠 것)·🟡(고려)·⚪(사소함) 가운데 하나를 붙여 `file:line — 문제 — 사용자에게 생기는 일`로 쓴다.
