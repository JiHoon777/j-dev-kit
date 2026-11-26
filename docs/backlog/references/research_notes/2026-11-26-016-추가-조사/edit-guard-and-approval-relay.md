# 플랜 모드 없이 "답 전에 고치지 않기"와 승인 중계 (Claude Code 공식 문서)

2026-11-26. claude-code-guide 에이전트가 code.claude.com/docs 를 읽고 보고한 원문을 옮겼다. 문서에서 확인하지 못한 것은 "확인 못 함"으로 남겼다.

## 1. 답 전 편집 금지를 도구 차원에서 강제하는 장치

- 권한 모드 plan: 승인 전까지 편집을 막는다. dontAsk 는 프롬프트가 필요한 것을 거부한다. https://code.claude.com/docs/en/permission-modes.md
- 모드 전환은 사용자가 Shift+Tab, 플래그, `permissions.defaultMode` 로 한다. 스킬 frontmatter 에 모드를 바꾸는 키는 없다. https://code.claude.com/docs/en/skills.md 플러그인 settings 로 모드를 배포할 수 있는지는 확인 못 함.
- PreToolUse 훅: `permissionDecision: "deny"` 또는 exit 2 로 도구 호출을 막는다. Edit, Write, Bash 매처를 쓸 수 있다. 플러그인 `hooks/hooks.json` 은 플러그인이 켜져 있으면 적용되고 서브에이전트 안에서도 발화한다. https://code.claude.com/docs/en/hooks.md
- 플래그 파일 방식은 입력의 `session_id` 로 세션을 가려 막을 수 있다. `${CLAUDE_PROJECT_DIR}` 는 워크트리를 따라가지 않고 cwd 만 따라간다. https://code.claude.com/docs/en/worktrees.md
- SDK·데스크톱에서 플러그인 훅이 로드되는지는 확인 못 함. 문서는 같은 훅 이벤트가 데스크톱과 클라우드에서도 발화한다고만 적는다.
- 스킬 frontmatter: `allowed-tools` 는 허용만 하고 제한하지 않는다. `disallowed-tools` 는 스킬이 활성인 동안 도구를 뺀다(해제는 다음 메시지 때). 스킬 hooks 도 가능하다. https://code.claude.com/docs/en/skills.md
- 서브에이전트: `tools` 허용 목록과 `disallowedTools` 로 제한한다. 플러그인 서브에이전트는 hooks 와 permissionMode 를 무시한다. https://code.claude.com/docs/en/sub-agents.md
- 워크트리 세션은 본체 체크아웃에 대한 Edit·Write 를 막는다. https://code.claude.com/docs/en/worktrees.md

## 2. ExitPlanMode 는 사용자 승인을 요구하나

- 도구 표에서 ExitPlanMode 는 Permission required "Yes"다. https://code.claude.com/docs/en/tools-reference.md
- 승인해야 편집이 시작된다. https://code.claude.com/docs/en/permission-modes.md
- 예외: agent teams 의 팀원 플랜은 리드 검토 없이 자동 승인될 수 있다(사람의 승인이 아니다). https://code.claude.com/docs/en/agent-teams.md
- 서브에이전트에서는 permissionMode 가 plan 이 아니면 ExitPlanMode 가 없다. https://code.claude.com/docs/en/sub-agents.md

## 3. 승인 중계의 한계

- 팀원은 권한 프롬프트나 동의를 사람 대신 줄 수 없고, 거부된 행동을 다른 팀원에게 전해 우회할 수 없다. 같은 규칙이 다른 세션의 메시지에도 적용된다. https://code.claude.com/docs/en/agent-teams.md#messages-between-agents
- 세션 간 메시지는 승인·동의가 되지 않고 권한 프롬프트는 그대로 뜬다. https://code.claude.com/docs/en/cross-session-messaging.md#how-a-session-treats-an-incoming-message
- 자동 모드에서는 분류기가 중계된 승인 주장을 신뢰할 수 없는 입력으로 본다. (agent-teams 같은 절)
- 결론: 부모가 받은 "머지해"를 SendMessage 로 넘겨도 하위 세션은 그것을 승인으로 쓸 수 없다. 머지는 사용자가 직접 답한 세션에서 하거나, 하위 세션의 권한 프롬프트에 사람이 답해야 한다. 중계를 금지하는 한 문장은 찾지 못했다.

## 4. AskUserQuestion 은 블로킹인가

- 기본값으로 답할 때까지 질문이 열려 있다. https://code.claude.com/docs/en/tools-reference.md#askuserquestion-tool-behavior
- 답 전에 다른 도구 호출을 막는다는 명시 문장은 확인 못 함.
- `askUserQuestionTimeout` 을 60s·5m·10m 으로 두면 답 없이 스스로 판단해 진행한다. https://code.claude.com/docs/en/settings-reference#askuserquestiontimeout
- 서브에이전트는 AskUserQuestion 을 쓸 수 없다. 질문은 메인 세션에서 한다. https://code.claude.com/docs/en/sub-agents.md

## 5. 추천과 한계

- 추천: 착수 전 질문을 부모(메인) 세션에서 묻고, 답을 받은 뒤에만 워크트리·브랜치·하위 세션을 만든다. 답 전에는 고칠 워크트리가 없다. 앞선 서베이의 구조적 추론과 문서가 맞는다.
- 이것은 순서에 의한 보장이지 도구 차단이 아니다. 하드 보장이 필요하면 플러그인 `hooks.json` 에 PreToolUse(Edit|Write|NotebookEdit|Bash) 훅을 두고, `session_id` 로 키를 잡은 플래그 파일이 있으면 deny, 답하면 지운다.
- 한계: 플래그가 남으면 막힌다. 훅 경로는 cwd 기준이다. SDK 에서의 훅 로드와 자동 모드와의 상호작용은 확인 못 함. `askUserQuestionTimeout` 은 스킬이 통제하지 못한다.
