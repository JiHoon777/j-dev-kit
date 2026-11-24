---
max_turns: 30
timeout_seconds: 2400
allowed_tools: [Skill, Agent, Read, Grep, Glob]
---

`code-review` 스킬 하나로 이 저장소의 `git diff main...HEAD`를 리뷰한다. 셸은 없고, 그 diff 는 작업 디렉터리의 `review.diff`에 있다. 디자인 시안(`docs/design`), 하늘 자산(`static/sky`), `pnpm-lock.yaml`은 diff 에서 뺐다(저장소에는 있다). 항목 파일은 `docs/backlog/013-sky-real-sky.md`다. 파일은 고치지 않는다. 찾은 문제를 마지막 메시지에 모두 쓴다. 지적마다 🔴(꼭 고칠 것)·🟡(고려)·⚪(사소함) 가운데 하나를 붙여 `file:line — 문제 — 사용자에게 생기는 일`로 쓴다.
