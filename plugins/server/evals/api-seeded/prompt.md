---
max_turns: 15
timeout_seconds: 1800
allowed_tools: [Agent, Read, Grep, Glob, Skill]
---

`server:api-reviewer` 에이전트 하나로 이 저장소의 `git diff main...HEAD`를 리뷰한다. 셸은 없고, 그 diff 는 작업 디렉터리의 `review.diff`에 있다. 지시문에 범위(`review.diff`, 곧 `git diff main...HEAD`), 항목 파일 `docs/backlog/010-feat-working-copy-publish.md`, CLAUDE.md, 점검이 넘긴 근거(바뀐 파일 `src/routes/admin/cases/+page.server.ts`, `supabase/migrations/20261120000000_working_copy.sql`)를 넣는다. 에이전트의 보고를 그대로 마지막 메시지에 옮겨 쓰고 다른 말은 덧붙이지 않는다.
