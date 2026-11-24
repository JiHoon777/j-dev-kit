# claude_code_capabilities.md 사실 검증 (2026-11-20)

대상: `claude_code_capabilities.md`. 설계가 기대는 주장 47개를 골라 공식 페이지를 직접 열어 대조했다.
"확인"은 이번 작업에서 해당 페이지 본문에서 직접 본 것만이다. 검색 요약은 쓰지 않았다.
최신 릴리스는 v2.1.329 (2026-11-19T22:14:41Z) 로 노트와 일치한다 (https://api.github.com/repos/anthropics/claude-code/releases/latest).

## 판정 집계

| 판정 | 개수 |
|---|---|
| 확인 | 38 |
| 수정 필요 | 8 |
| 확인 불가 | 1 |
| 틀림 | 0 |

지어낸 것으로 보이는 명령·플래그·도구·환경변수·한도는 없었다. 확인한 식별자는 모두 공식 페이지에 그대로 있다.

## 검증 표

### 백그라운드 세션 (agent view)

| # | 주장 | 판정 | 출처가 실제로 말하는 것 (다를 때) | 확인한 URL |
|---|---|---|---|---|
| 1 | `claude --bg "<prompt>"` 로 백그라운드 세션 시작. `--name`, `--agent`, `--resume <id> --bg`, `--exec` 지원 | 확인 | `--background` 가 긴 이름. `--exec` 는 모델 없이 셸 작업만 돌리고 출력은 어느 세션에도 가지 않는다 | https://code.claude.com/docs/en/agent-view.md |
| 2 | `/bg`(`/background`), 빈 프롬프트에서 `←` 로 현재 세션을 백그라운드로 | 확인 | `←` 한 번은 v2.1.196 부터 | https://code.claude.com/docs/en/agent-view.md |
| 3 | `/fork` 는 대화를 새 백그라운드 세션으로 복사, 포크 서브에이전트는 `/subtask` (v2.1.212). agent view 를 끄면 `/fork` 가 포크 서브에이전트, `/subtask` 없음 | 확인 | | https://code.claude.com/docs/en/agent-view.md , https://code.claude.com/docs/en/sub-agents.md , https://code.claude.com/docs/en/agents.md |
| 4 | `claude agents --json [--all]` 로 스크립트에서 상태 조회 | 확인 | `--cwd <path>` 도 있다. 각 항목의 `state`, `status`, `waitingFor` 를 읽으라고 안내한다 | https://code.claude.com/docs/en/agent-view.md |
| 5 | `claude attach\|logs\|respawn\|stop\|rm <id>`, `claude daemon status\|stop` | 수정 필요 | 문서 표의 명령은 `claude daemon stop --any` 이다. `--keep-workers` 를 주면 세션은 남긴다. `attach`/`logs` 는 이름도 받는다 (v2.1.290+) | https://code.claude.com/docs/en/agent-view.md |
| 6 | 터미널을 닫아도, 절전에도 살아남고 재부팅에는 죽는다. 48시간 안이면 failed 로 보이고 attach 하면 저장된 대화에서 다시 시작 | 확인 | "Shutting down or restarting your machine stops running background sessions." 48시간이 지나면 stopped 로 표시 | https://code.claude.com/docs/en/agent-view.md |
| 7 | 약 1시간 방치된 유휴 세션은 프로세스가 "일시정지" 된다. Ctrl+T 로 고정 | 수정 필요 | 일시정지가 아니라 프로세스를 멈춘다 ("the supervisor stops the process to free resources"). attach 하면 새 프로세스가 이어서 시작한다. 작업 중이거나 권한 대기 중이거나 고정된 세션은 해당 없음 | https://code.claude.com/docs/en/agent-view.md |
| 8 | 편집 전에 `.claude/worktrees/` 아래 자기 워크트리로 이동. `worktree.bgIsolation: "none"` 으로 끔 | 확인 | | https://code.claude.com/docs/en/agent-view.md |
| 9 | 끝나면 커밋·푸시하고 draft PR 을 연다 (v2.1.198) | 수정 필요 | 인용문은 v2.1.198 버전 기록 문장이다. 현재 본문은 조건부다: 푸시는 "when the repository has a remote", draft PR 은 "when the task calls for it". 작업·CLAUDE.md·메모리의 git 지시가 우선한다. `main`/`master` 푸시, force-push, merge 는 절대 안 함. 스스로 격리하지 않은 체크아웃에서는 커밋 전에 묻는다 | https://code.claude.com/docs/en/agent-view.md |
| 10 | `claude --bg` 는 `-p` 와 함께 못 쓴다. 스크립트에서 신뢰 안 된 폴더면 `Workspace not trusted` (v2.1.281) | 확인 | | https://code.claude.com/docs/en/agent-view.md , https://code.claude.com/docs/en/headless.md |
| 11 | 세션 10개면 쿼터도 약 10배. `disableAgentView` / `CLAUDE_CODE_DISABLE_AGENT_VIEW` 로 끔 | 확인 | research preview 상태도 그대로 | https://code.claude.com/docs/en/agent-view.md |
| 12 | `Notification` 훅이 `agent_needs_input` / `agent_completed` 로 발화한다 | 수정 필요 | 훅 발화는 agent view 알림에 묶여 있고, 그 알림은 "While agent view is open" 일 때만 간다. agent view 가 닫힌 상태에서도 훅이 뜨는지는 문서에 없다. 무인 에스컬레이션 수단으로 단정하면 안 된다 | https://code.claude.com/docs/en/agent-view.md , https://code.claude.com/docs/en/hooks.md |

### 세션 간 메시지

| # | 주장 | 판정 | 출처가 실제로 말하는 것 (다를 때) | 확인한 URL |
|---|---|---|---|---|
| 13 | `ListAgents` 로 찾고 `SendMessage` 로 보낸다. v2.1.224+ (macOS/Linux/WSL 2), v2.1.234+ (네이티브 Windows). 켤 것 없음. `/list-agents`(`/peers`) | 확인 | 서드파티 제공자나 feature flag 를 끈 환경의 같은 기기 메시지는 v2.1.248+. v2.1.328 부터 `/list-agents` 출력은 사용자에게만 보인다 | https://code.claude.com/docs/en/cross-session-messaging.md , https://code.claude.com/docs/en/tools-reference.md |
| 14 | 같은 기기는 세션별 소켓/네임드 파이프, Anthropic 서버를 거치지 않음. 다른 기기·클라우드는 Remote Control + claude.ai 로그인 필요. 컨테이너와 호스트는 서로 못 닿음 | 확인 | WSL 2 세션과 네이티브 Windows 세션도 서로 못 닿는다 | https://code.claude.com/docs/en/cross-session-messaging.md |
| 15 | 수신 측이 바쁘면 도구 호출 사이에 읽고, 유휴면 새 턴을 시작. 들어온 메시지는 승인 불가, 설정 변경 불가, 명령 실행 안 됨 | 확인 | 전달된 메시지는 프롬프트처럼 사용량에 잡힌다 | https://code.claude.com/docs/en/cross-session-messaging.md |
| 16 | `notify_when_idle`: 같은 기기, 양쪽 v2.1.236+, 12시간 뒤 구독 폐기, 메인 대화만 구독 가능, 감시 대상 토큰 0 | 확인 | 토큰 0 은 메시지 없이 구독만 할 때다. 팀메이트·서브에이전트·다른 기기 대상이면 호출 전체가 거부된다 | https://code.claude.com/docs/en/cross-session-messaging.md |
| 17 | `crossSessionInbound` = `accept`/`hold`/`refuse`, `isolatePeerMachines`, `dialogExpiry` 기본 5분. 기본값은 "bypass 권한 발신자의 메시지를 보류" | 수정 필요 | 기본 규칙은 양방향이다. 수신 측이 권한을 묻는 세션이면 발신자가 bypass 일 때만 보류한다. 수신 측이 bypass 세션이면 모든 메시지를 보류하고, 발신자도 bypass 일 때만 전달한다. `-p`·VS Code·Desktop 은 대화상자를 못 띄워 기한 뒤 버린다. 보류는 최대 100개 | https://code.claude.com/docs/en/cross-session-messaging.md |
| 18 | `claude -p` 세션도 inbox 소켓을 열어 메시지를 받는다. `--settings` 로 `crossSessionInbound: accept`. `--bare` 는 소켓 없음 | 확인 | | https://code.claude.com/docs/en/cross-session-messaging.md |
| 19 | 한도: 평문만, 약 100만 자, 연속 발송 거부, 수락 메시지 큐 50개. `CLAUDE_CODE_MESSAGING_SOCKET` / `CLAUDE_CODE_MESSAGING_TOKEN` (Windows 는 토큰 필수) | 확인 | 100만 자 한도는 같은 기기 메시지 기준. 스크립트 연결은 30초 안에 한 줄을 보내야 한다 | https://code.claude.com/docs/en/cross-session-messaging.md |

### 서브에이전트와 agent teams

| # | 주장 | 판정 | 출처가 실제로 말하는 것 (다를 때) | 확인한 URL |
|---|---|---|---|---|
| 20 | 중첩은 메인 대화 아래 3단계 (`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH`, `1` 이면 중첩 끔) | 확인 | 한도에서는 포크를 뺀 서브에이전트에게 `Agent` 도구를 주지 않는다 | https://code.claude.com/docs/en/sub-agents.md |
| 21 | 동시 서브에이전트 20개 (`CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS`), ultracode 는 예외, 세션 총량 제한 없음 | 확인 | 초과하면 `Concurrent subagent limit reached` 로 실패. 워크플로 에이전트와 팀메이트는 각자 한도를 따른다 | https://code.claude.com/docs/en/sub-agents.md |
| 22 | 메인 대화가 띄운 서브에이전트는 기본이 백그라운드. 결과는 나중 턴의 완료 알림. 권한 프롬프트는 메인 세션에 뜬다 | 확인 | | https://code.claude.com/docs/en/sub-agents.md |
| 23 | `-p`/SDK 에서 서브에이전트는 포그라운드 중첩만 기다렸으나 v2.1.328 에서 기본으로 기다리게 바뀜 | 수정 필요 | CHANGELOG 2.1.328 문장은 맞다. 다만 sub-agents.md 본문은 아직 옛 동작("waits only for a foreground nested subagent")을 적고 있어 두 공식 출처가 어긋난다. 어느 쪽에도 기대지 않게 설계할 것 | https://code.claude.com/docs/en/sub-agents.md , https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md |
| 24 | 플러그인 에이전트는 `permissionMode`, `hooks`, `mcpServers`, `initialPrompt` 를 무시. `isolation` 은 `"worktree"` 만 | 확인 | 지원 필드 목록도 노트와 일치 | https://code.claude.com/docs/en/plugins/components.md , https://code.claude.com/docs/en/sub-agents.md |
| 25 | 완료된 서브에이전트는 `SendMessage` 로 재개 (agent teams 불필요). 사용자가 멈춘 것은 자동 재개 안 됨 | 확인 | | https://code.claude.com/docs/en/sub-agents.md |
| 26 | agent teams 는 실험 기능, 기본 꺼짐, `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. `-p`/SDK 에서는 팀메이트를 띄우지 않음 | 확인 | 켜 두면 Claude 가 이름 붙인 서브에이전트가 확인 없이 팀메이트로 뜬다 | https://code.claude.com/docs/en/agent-teams.md |
| 27 | 제한: 세션당 팀 1개, 중첩 팀 없음, 리드 고정, `/resume`·`/rewind` 로 in-process 팀메이트 복원 안 됨, in-process 팀메이트는 백그라운드 서브에이전트 못 씀, 3-5명 권장 | 확인 | 팀메이트 수의 hard limit 은 없다. 저장 경로(`~/.claude/teams/...`, `~/.claude/tasks/...`)도 일치 | https://code.claude.com/docs/en/agent-teams.md |

### 스케줄링

| # | 주장 | 판정 | 출처가 실제로 말하는 것 (다를 때) | 확인한 URL |
|---|---|---|---|---|
| 28 | `/loop 5m <prompt>` 는 고정 주기, 주기 없으면 1분~1시간 자율 (`ScheduleWakeup`, `stop: true`), 맨 `/loop` 는 내장 프롬프트 또는 `loop.md` | 확인 | 최소 간격 1분 | https://code.claude.com/docs/en/scheduled-tasks.md , https://code.claude.com/docs/en/tools-reference.md |
| 29 | `CronCreate`/`CronList`/`CronDelete`. 세션당 최대 50개, 반복 작업은 7일 뒤 만료, 로컬 시간, 턴 사이에만 발화, 지터는 간격의 절반·최대 30분, 놓친 발화는 몰아서 실행 안 함 | 확인 | `*/5 * * * *` 는 지연 없이 15초 일찍. 정시·30분 one-shot 은 최대 90초 일찍 | https://code.claude.com/docs/en/scheduled-tasks.md |
| 30 | 터미널을 닫으면 멈춤, `/bg` 는 `/loop` 작업을 가져감, `--resume` 은 `CronCreate` 작업만 복원 (자율 루프와 "Exit and stop tasks" 는 제외), `CLAUDE_CODE_DISABLE_CRON=1` | 확인 | 세션을 백그라운드로 보낼 때 실행 중인 monitor 는 멈추고, 워크플로는 Claude 가 다시 띄워야 이어진다 (agent-view.md) | https://code.claude.com/docs/en/scheduled-tasks.md , https://code.claude.com/docs/en/agent-view.md |
| 31 | Desktop 예약 작업: 1.1.5368+, `~/.claude/scheduled-tasks/<task-name>/SKILL.md`, 일정·폴더·활성 상태는 다른 곳, 앱이 열려 있고 컴퓨터가 깨어 있을 때만, 매번 새 세션, 7일 안 놓친 것 중 최근 1회만 보충 실행, `update_scheduled_task` | 확인 | 폼에서는 시간당 1회가 최소, Claude 에게 시키면 그 제한이 없다. 삭제는 상세 페이지 버튼으로만 | https://code.claude.com/docs/en/desktop-scheduled-tasks.md |
| 32 | 클라우드 예약 작업은 예전 routines. research preview, Pro/Max/Ultra/Team/Enterprise, `claude.ai/code/routines`·Desktop·`/schedule`(`/routines`), 최소 1시간, cron 은 UTC (`CRON_TZ=` 접두 가능), 일회 실행 지원 | 확인 | 이름 변경 날짜는 공식 페이지에 없다 | https://code.claude.com/docs/en/routines.md |
| 33 | 한도: 예약 실행 계정당 100/h, Run now + API fire 작업당 30/h, API fire 계정당 100/h | 확인 | Run now 도 계정당 100/h (API fire 와 따로 센다). 이 시간당 한도에는 초과 과금이 없다. GitHub 이벤트 초과분은 버려진다 | https://code.claude.com/docs/en/routines.md |
| 34 | API 트리거: `POST https://api.anthropic.com/v1/claude_code/routines/<trig_id>/fire`, 베타 헤더 `experimental-cc-routine-2026-04-01`, `<routine-fire-payload>`, 응답에 `claude_code_session_id`/`_url`. API 트리거는 웹에서만 관리 | 확인 | | https://code.claude.com/docs/en/routines.md |
| 35 | `RemoteTrigger` 가 `/schedule` 의 뒤에 있고, Bedrock/Vertex/Foundry 에서는 못 쓴다. `/schedule` 은 claude.ai 구독 로그인 필요, 클라우드 세션 안에서는 불가 | 확인 | | https://code.claude.com/docs/en/tools-reference.md , https://code.claude.com/docs/en/routines.md |

### 워크플로, Monitor, /goal

| # | 주장 | 판정 | 출처가 실제로 말하는 것 (다를 때) | 확인한 URL |
|---|---|---|---|---|
| 36 | Workflow 한도: 동시 16 (`CLAUDE_CODE_WORKFLOW_MAX_CONCURRENT_AGENTS` 1~256, v2.1.269+), `parallel`/`pipeline` 당 4,096개, 실행당 에이전트 1,000개, 25개 또는 약 150만 토큰 넘으면 `Large workflow` 경고, 크기 가이드 기본 medium | 수정 필요 | 숫자는 모두 맞다. 다만 기본 가이드는 Pro (v2.1.271+) 에서 `small` 이다. 동시 16 은 CPU 가 적으면 더 줄어든다 | https://code.claude.com/docs/en/workflows.md |
| 37 | 플러그인 `workflows/` 디렉터리(또는 `workflows` 매니페스트 필드), `/<plugin>:<meta.name>` 으로 실행. `.claude/workflows/`, `~/.claude/workflows/` 에 저장. 세션을 나가거나 백그라운드로 보내면 저절로 이어지지 않음 | 확인 | `-p`/SDK 에서는 `Workflow` 허용 규칙 등이 있어야 시작한다. 2026-05-28 발표, GA (블로그) | https://code.claude.com/docs/en/workflows.md , https://code.claude.com/docs/en/plugins/components.md , https://claude.com/blog/introducing-dynamic-workflows-in-claude-code |
| 38 | Monitor: 기본 5분, 최대 30분, `-p` 에서는 최대 10분, WebSocket 가능, Windows 는 Git Bash 필요. 플러그인 monitor 는 `monitors/monitors.json`(또는 `experimental.monitors`), 세션 시작 때 또는 `when` 으로 시작, `-p` 에서 시작 안 함, `${user_config.*}` 불가, 샌드박스 밖 | 확인 | 플러그인을 세션 중에 꺼도 이미 도는 monitor 는 세션이 끝날 때까지 돈다 | https://code.claude.com/docs/en/tools-reference.md , https://code.claude.com/docs/en/plugins/components.md |
| 39 | `/goal`: 세션 범위 prompt 기반 Stop 훅의 래퍼, 작은 빠른 모델이 판정, `-p`·Desktop·Remote Control 에서 동작, 세션당 1개, resume 때 복원, 백그라운드 작업 중에는 평가 보류, 30분 체크인 (`CLAUDE_CODE_GOAL_CHECKIN_MINUTES`), `disableAllHooks` 면 불가 | 확인 | `allowManagedHooksOnly` 가 설정돼도 불가. 유휴 체크인은 프롬프트 사이 최대 3회 | https://code.claude.com/docs/en/goal.md |

### 알림, 훅, 채널, 헤드리스, 플러그인

| # | 주장 | 판정 | 출처가 실제로 말하는 것 (다를 때) | 확인한 URL |
|---|---|---|---|---|
| 40 | `PushNotification`: 로컬 세션은 데스크톱 알림, Remote Control 또는 클라우드 세션이면 폰 푸시. Bedrock/Vertex/Foundry 불가 | 확인 | | https://code.claude.com/docs/en/tools-reference.md |
| 41 | `Notification` 매처 14개 목록, `SessionStart` 매처에 `fork` | 확인 | 노트의 목록과 글자 그대로 일치 | https://code.claude.com/docs/en/hooks.md |
| 42 | 훅 이벤트 33개 목록 (Stop, SubagentStop, TaskCreated, TaskCompleted, TeammateIdle 포함). `asyncRewake: true` 는 백그라운드로 돌다가 exit 2 에 Claude 를 깨움. Stop/SubagentStop 입력에 `background_tasks`, `session_crons` | 확인 | `async` 는 `type: "command"` 훅에서만. `TaskCompleted` 는 `TaskUpdate` 로 완료 표시할 때 또는 팀메이트가 진행 중 작업을 남기고 턴을 끝낼 때 발화 | https://code.claude.com/docs/en/hooks.md |
| 43 | 채널: research preview, `claude --channels plugin:<name>@<marketplace>`, 세션이 열려 있을 때만 이벤트 도착, 허용 목록에 있는 플러그인만, 직접 만든 것은 `--dangerously-load-development-channels`, Team/Enterprise 는 `channelsEnabled` | 확인 | | https://code.claude.com/docs/en/channels.md |
| 44 | `claude -p` 는 백그라운드 작업을 최대 10분 기다린다 (`CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS`), `--bg` 거부, MCP 백그라운드 작업은 안 기다림, v2.1.302 부터 기본 Manual 모드 | 수정 필요 | 10분은 연속 유휴 대기 기준이고 예외가 있다. 메인 대화가 띄운 백그라운드 명령이 도는 동안에는 상한이 적용되지 않고, 대기 중인 `/loop` 웨이크업도 10분을 넘겨 기다린다 | https://code.claude.com/docs/en/headless.md |
| 45 | 플러그인이 실을 수 있는 것: skills, commands, agents, hooks, MCP, LSP, monitors, output styles, themes, workflows, channels, `bin/`, `userConfig`, mods. 루트 `CLAUDE.md` 는 로드 안 됨. 플러그인 훅은 플러그인 로드 시 등록되어 항상 발화 | 확인 | claude.ai·Cowork 는 최상위 `bin/` 이 있는 플러그인을 설치하지 않는다 | https://code.claude.com/docs/en/plugins/components.md |
| 46 | Task 도구(`TaskCreate` 등)는 Opus 4.7, Sonnet 4.6, Haiku 4.5 이하 모델에서만 기본 제공 (v2.1.268+). 백그라운드·클라우드 세션은 항상 제공 | 확인 | | https://code.claude.com/docs/en/tools-reference.md |
| 47 | 백그라운드 서브에이전트가 유지하는 내장 도구의 정확한 목록, 프런트매터 `skills` 최대 32개 | 확인 불가 | 도구 세트가 더 작다는 문장만 확인했다. 정확한 목록과 32개 한도는 이번에 읽은 범위에서 보지 못했다 (페이지가 길어 잘림) | https://code.claude.com/docs/en/sub-agents.md |

확인하지 않은 구역: GitHub Actions(Q2 후반), Agent SDK 세션 API(Q5), 버전별 날짜 보간(Q7). 릴리스 날짜는 v2.1.139 = 2026-05-11, v2.1.224 = 2026-08-07, v2.1.329 = 2026-11-19 세 개만 릴리스 API 로 확인했다.

## 보고서가 반영해야 할 수정

1. draft PR 은 무조건이 아니다. 워크트리로 격리된 백그라운드 세션은 묻지 않고 커밋하고 원격이 있으면 푸시하지만, draft PR 은 "작업이 요구할 때"만 연다. 사용자의 git 지시가 우선한다. PR 이 꼭 필요하면 프롬프트에 명시해야 한다.
2. 세션 간 메시지의 기본 보류 규칙은 양방향이다. bypass 권한으로 도는 워커는 일반 세션이 보낸 메시지를 전부 보류한다. 무인 워커는 `crossSessionInbound: accept` 를 명시해야 메시지를 받는다. `-p` 워커는 보류된 메시지를 5분 뒤 버린다.
3. `agent_needs_input` / `agent_completed` 훅은 agent view 알림에 묶여 있고, 그 알림은 agent view 가 열려 있을 때만 간다. 닫힌 상태의 발화 여부는 문서에 없으니 유일한 에스컬레이션 경로로 쓰지 말 것.
4. 중첩 서브에이전트의 대기 동작은 공식 문서 본문과 CHANGELOG 2.1.328 이 어긋난다. `-p`/SDK 에서 부모가 백그라운드 자식을 기다리는지에 설계가 기대면 안 된다.
5. `claude daemon stop` 은 문서상 `claude daemon stop --any` 이고, `--keep-workers` 없이 쓰면 호스팅 중인 백그라운드 세션도 함께 멈춘다.
6. 유휴 1시간 뒤에는 프로세스가 "일시정지" 가 아니라 종료된다. 상태는 디스크에 남고 attach 하면 새 프로세스가 이어받는다.
7. 워크플로 크기 가이드 기본값은 Pro 에서 `small` (5개 미만) 이다. 동시 실행 16 은 CPU 수에 따라 더 낮아진다.
8. `-p` 의 10분 상한에는 예외가 있다. 메인 대화가 띄운 백그라운드 명령과 대기 중인 `/loop` 웨이크업은 10분을 넘겨도 기다린다.

## 노트에 없지만 설계에 걸리는 사실 (같은 페이지에서 확인)

- 세션을 백그라운드로 보내면 실행 중인 monitor 는 멈추고, 워크플로는 Claude 가 다시 띄워야 이어진다. 백그라운드 셸 명령, 백그라운드 서브에이전트, `/loop` 작업만 넘어간다 (https://code.claude.com/docs/en/agent-view.md).
- `TaskCreated`/`TaskCompleted` 훅은 Task 도구 호출에 걸린다. Task 도구는 최신 모델의 일반 세션에서 기본으로 빠져 있으므로, 이 훅은 그런 세션에서 발화할 계기가 없다 (앞 문장은 문서 사실, 뒤 문장은 추론). 백그라운드 세션과 클라우드 세션에서는 모델과 상관없이 Task 도구가 제공된다 (https://code.claude.com/docs/en/hooks.md , https://code.claude.com/docs/en/tools-reference.md).
