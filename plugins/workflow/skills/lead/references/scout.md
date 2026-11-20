# lead scout: 제안함 갱신하기

제안함(`docs/backlog/_proposals.md`)은 `workflow:backlog-scout` 에이전트가 쓴다. 이 세션은 저장소를 직접 읽지 않고, 다 쓴 제안함만 읽는다.

1. `workflow:backlog-scout` 에이전트를 띄운다. 지시문에는 저장소의 절대 경로만 넣는다. 절차는 에이전트가 갖고 있다.
2. 에이전트가 끝나면 `docs/backlog/_proposals.md`를 읽고 제안을 그대로 보여 준다. 에이전트의 보고에서 새로 생긴 것과 빠진 것을 한 줄로 덧붙인다.
3. 승격과 기각은 `/lead run`에서 한다고 알린다. 여기서는 항목을 만들지 않는다.

에이전트를 쓸 수 없으면 `${CLAUDE_SKILL_DIR}/../../agents/backlog-scout.md`를 읽고 그 절차를 직접 따른 뒤 2단계부터 한다.
