# 검증: orchestrator_tools.md / recent_developments.md (기준일 2026-11-20)

방법: 각 주장의 인용 URL을 이번 작업에서 직접 열어 본문을 확인했다. 검색 요약은 쓰지 않았다. 접근이 거부된 페이지는 우회하지 않고 다른 공개 출처를 찾거나 확인 불가로 남겼다.

판정 기준
- 확인: 이번 작업에서 페이지 본문으로 직접 확인함
- 수정 필요: 주장의 뼈대는 맞지만 숫자, 날짜, 인용문, 출처 표기 중 고칠 것이 있음
- 확인 불가: 인용한 페이지에 그 내용이 없거나 페이지를 열 수 없었음
- 틀림: 출처가 주장과 반대로 말함 (이번 검증에서는 해당 없음)

파일 약칭: OT = orchestrator_tools.md, RD = recent_developments.md

## 검증 표

| # | 주장 (요약) | 파일 | 판정 | 출처가 실제로 말하는 것 (다를 때) | 확인한 URL |
|---|---|---|---|---|---|
| 1 | Gas Town 2026-01-01 오픈소스, Beads 2025-10, "Gas Town is now retired. Its successor is Gas City", Yegge가 자문하는 회사가 운영 | OT | 확인 | Wasteland는 2026-03 출시이고 페이지에 "retired for now"라고도 적혀 있음 (노트에 없음) | https://yegge.ai/gastown |
| 2 | Gas Town README: 약 18.8k 스타, 7,783 커밋, 395 이슈, 134 PR, 은퇴 표시 없음 | OT | 확인 | | https://github.com/gastownhall/gastown |
| 3 | 역할 8종 (Mayor, Polecats, Refinery, Witness, Deacon, Dogs, Crew, Convoy) | OT | 확인 | | https://github.com/gastownhall/gastown |
| 4 | Refinery는 Bors 방식 bisecting 큐, "polecats never push directly to main", `gt sling`, "Work persists in git-backed hooks" | OT | 확인 | `scheduler.max_polecats`는 지연 배정(deferred dispatch)을 켜는 설정으로 나오고 예시는 5. "API rate limit 소진 방지" 목적 문구는 이번에 보지 못함 | https://github.com/gastownhall/gastown |
| 5 | "Clown Show to v1.0" (2026-04-03): maintenance mode, Gas City 알파, "two sources of truth", Dolt 전환, "piles of worker corpses", "progressive dementia", "wall of scrolling text" | OT | 확인 | 재게시본으로 확인 (Medium 원문은 열지 않음). Gas City는 "alpha testing and on track for a fast GA" | https://drss.io/reader/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/gas-town-from-clown-show-to-v10 |
| 6 | Beads 약 23k 스타, MIT | OT | 확인 | | https://yegge.ai/gastown |
| 7 | Gas City는 "orchestration-builder SDK" (따옴표 인용) | OT | 수정 필요 | 이 문구는 README, gascity.com, yegge.ai 어디에도 없음. README: "The open-source platform for building software factories from teams of coding agents". yegge.ai: "reusable in an SDK for building your own orchestrators". pack, formula, order("on a schedule or in response to events"), 런타임(tmux, subprocess, ACP, Kubernetes), `gc sling`은 README에 있음 | https://raw.githubusercontent.com/gastownhall/gascity/HEAD/README.md , https://gascity.com/ |
| 8 | Gas City에 Gas Town pack이 기본 포함 | OT | 확인 불가 | README에는 pack 언급이 없고 "Coming from Gas Town?" 이전 가이드만 있음. gascity.com은 Gas Town을 언급하지 않음 | 위와 같음 |
| 9 | DoltHub 피크 시간당 약 $100, Yegge Max 플랜 3개째, 실패 테스트 자동 머지, force push 5번, "murderous rampaging Deacon", Abrahms의 지적 | OT | 확인 | 2차 출처(2026-01-17) 본문으로 확인. DoltHub, Yegge 원문은 열지 않음 | https://paddo.dev/blog/gastown-two-kinds-of-multi-agent/ |
| 10 | Gas Town은 Claude Code 20–30개 병렬 | OT | 확인 | 2026-02-16 기사. 같은 기사에 "12 to 30"이라는 표현도 있음 | https://cloudnativenow.com/features/gas-town-what-kubernetes-for-ai-coding-agents-actually-looks-like/ |
| 11 | heise (2026-02-21): 3–5개 병렬에서 중복 작업·머지 충돌, 컨텍스트 60%, 로깅 라이브러리 3–4개, Deacon의 좀비 정리 | OT | 확인 | | https://www.heise.de/en/background/Full-Control-Gas-Town-Orchestrates-Ten-or-More-Coding-Agents-11178824.html |
| 12 | Claude Code agent teams: 환경 변수, 실험 기능, 파일 경로, 파일 락, 덮어쓰기 경고, 3–5명, 5–6개 작업, 훅 3종, 제한 사항 | OT | 확인 | | https://code.claude.com/docs/en/agent-teams |
| 13 | plan mode에서 "approximately 7x more tokens" | OT | 확인 | | https://code.claude.com/docs/en/costs |
| 14 | Claude Code Projects: Pro/Max/Ultra 공개 베타, Team/Enterprise 미지원, 지침 16,000자, 하루 새 thread 500개, "preference rather than a cap", Overview 상태, 알림 기본값, 캐시 1시간, 커밋 안 한 변경 유실 | OT | 확인 | | https://code.claude.com/docs/en/claude-projects |
| 15 | Claude Code Projects "2026-09-17 베타 **재출시**" | OT | 수정 필요 | VentureBeat(2026-09-17)는 재출시가 아니라 새 기능의 베타 출시로 설명하고, 2024-06에 나온 기존 Claude Projects와 구분함. 출시 시점 대상은 Pro·Max 일부. "threads do the work, Claude directs it"은 VentureBeat에 있고, 문서의 문구는 "threads do the work and report back" | https://venturebeat.com/orchestration/anthropic-launches-claude-code-projects-an-always-on-conversation-that-remembers-and-delegates-your-long-running-dev-work |
| 16 | Symphony README: 약 28.1k 스타, 47 커밋, 릴리스 없음, "low-key engineering preview", harness engineering, proof of work | OT | 확인 | | https://github.com/openai/symphony |
| 17 | Symphony SPEC 기본값: 폴링 30000ms, 동시 10, 최대 20턴, 백오프 최대 5분, stall 5분, "intentionally in-memory", "Human Review", 재시작 시 타이머·세션 미복원 | OT | 확인 | | https://github.com/openai/symphony/blob/main/SPEC.md |
| 18 | Symphony "v1은 Linear만 지원", "GitHub Issues는 확장 대상" (SPEC.md 인용) | OT | 수정 필요 | SPEC.md에는 "linear"라는 단어도 GitHub Issues도 없음. `tracker.kind`는 "Selects one implementation-supported tracker adapter". Linear는 README에 나옴: "Symphony monitors a Linear board for work" | https://raw.githubusercontent.com/openai/symphony/main/SPEC.md , https://raw.githubusercontent.com/openai/symphony/main/README.md |
| 19 | 인용문 "The service runs continuously and polls on a fixed interval" | OT | 수정 필요 | SPEC.md에 이 문장은 없음. 가장 가까운 문장은 "Poll the issue tracker on a fixed cadence and dispatch work with bounded concurrency"와 "long-running automation service that continuously reads work" | https://raw.githubusercontent.com/openai/symphony/main/SPEC.md |
| 20 | InfoWorld: 세션 3–5개 넘으면 컨텍스트 전환 부담, 티켓 수준 작업에서 빗나갈 수 있음 | OT | 확인 | 2026-04-28 기사. "OpenAI가 독립 제품으로 유지보수할 계획 없음"은 이 기사에 없음 (노트도 미확인으로 표시) | https://www.infoworld.com/article/4164173/openais-symphony-spec-pushes-coding-agents-from-prompts-to-orchestration.html |
| 21 | Codex 데스크톱 앱(macOS), 프로젝트별 thread, worktree, "agents run in parallel and exchange tasks", 클라우드 상시 실행은 예정 | OT | 확인 | heise 2026-02-04 기사. 출시일 2026-02-02는 이 기사에 없어 확인 불가. 기사는 "Automations"가 아니라 "automatic schedules"라고 씀 | https://heise.de/-11165126 |
| 22 | Dots (2026-09-29 DevDay): 항상 켜진 에이전트, GPT-6 Astra, Slack·Teams, 자기 클라우드 컴퓨터, Codex에 작업 생성, 서브에이전트 | OT, RD | 확인 | 출처 배정을 고쳐야 함. TechCrunch에는 클라우드 컴퓨터와 Codex 위임 내용이 없음. 클라우드 컴퓨터는 BetaNews·heise·VentureBeat, Codex 작업 생성은 BetaNews, 서브에이전트는 heise. 가격은 세 출처가 일치: 첫 Dot은 Pro·Business Premium에 포함 | https://techcrunch.com/2026/09/29/openai-launches-dots-its-bubbly-agentic-avatar/ , https://betanews.com/article/openai-dots-agents-chatgpt/ , https://www.heise.de/en/news/OpenAI-Launches-Dots-Permanently-Active-AI-Agents-with-Their-Own-Cloud-Computer-11470571.html , https://venturebeat.com/technology/openai-launches-dots-always-on-ai-agent-coworkers-and-chatgpt-space-where-they-can-collaborate-with-human-teams |
| 23 | Manage Devins (2026-03-19): "a full Devin, running in its own isolated virtual machine", ACU 추적, 자식 궤적 읽기, 충돌 해결 방법 설명 없음 | OT | 확인 | | https://cognition.com/blog/devin-can-now-manage-devins , https://docs.devin.ai/work-with-devin/advanced-capabilities |
| 24 | Devin Bots (2026-11-17): Slack 멤버, 며칠~몇 주 맥락, Bot별 예산, 저위험 변경 자동 승인·머지 설정, 얼리 액세스 수십 곳에서 2주 만에 10배, ARR 9월 $1B 돌파, Citigroup 14,000명 | OT, RD | 확인 | Citigroup 수치는 Bots가 아니라 기존 Devin 사용자 수. Fortune에는 가격·GA 정보가 없음 | https://fortune.com/2026/11/17/exclusive-cognition-bets-on-devin-bots-coding-agents-in-challenge-to-anthropics-duet-and-openais-dots/ |
| 25 | Devin Bots "4.5x more PRs per message", "persistent memory, scheduled triggers", 리뷰어 용량 문제 | OT | 확인 | Fortune이 아니라 AlphaSignal에만 있음. 주 2,000 PR은 일부 엔지니어의 최고치로 회사가 낸 수치 | https://alphasignal.ai/news/cognition-s-devin-bots-now-run-parallel-coding-sessions-hitting-2-000-pull |
| 26 | "Devin can now Schedule Devins" 글 존재 | OT | 확인 | 2026-03-20 게시. 평문 설명으로 반복 세션을 만들고 실행 사이에 메모를 넘김 | https://cognition.com/blog/devin-can-now-schedule-devins |
| 27 | Factory Missions: 오케스트레이터와 대화, "not fire-and-forget", Readiness Level 4, 약 500개 기능, 병렬화는 open question, feature retry limit | OT | 확인 | 500은 하드 한도가 아니라 계획 지침이라고 명시 | https://docs.factory.com/cli/features/missions |
| 28 | Cursor "Scaling long-running autonomous coding" (2026-01-14, Wilson Lin): 락 실패 인용문, planner·worker·judge, integrator 제거, 수백 에이전트, 100만 줄 이상, "trillions of tokens", Opus 4.5 인용문 | OT | 확인 | | https://cursor.com/blog/scaling-agents |
| 29 | 인용문 "Some agents run far too long" | OT | 수정 필요 | 원문은 "Agents occasionally run for far too long" | https://cursor.com/blog/scaling-agents |
| 30 | Cursor 3 (2026-04) Agents Window(worktree 병렬), 2026-09 Coordinators/Projects | OT | 수정 필요 | Cursor 3는 2026-04-02 출시이고 worktree는 2026-04-24 변경 로그에서 추가됨(2차). 공식 릴리스 노트에 "Project coordinators and workers"가 3.28~3.30 항목으로 나와 기능 존재는 1차 확인. 2026-09 시점은 확인 불가 | https://www.digitalapplied.com/blog/cursor-3-agents-window-complete-guide , https://cursor.com/docs/release-notes |
| 31 | GitHub Agent HQ (2025-10 Universe), mission control, 서드파티 에이전트(Anthropic, OpenAI, Google, Cognition, xAI), Slack·Linear·Jira·Teams·Azure Boards 연동 | OT | 확인 | 2025-10-28 게시. 연동 목록은 2차가 아니라 이 1차 글에 있음 | https://github.blog/news-insights/product-news/welcome-home-agents/ |
| 32 | Agent HQ: "에이전트는 지정된 브랜치에만 커밋할 수 있다" | OT | 확인 불가 | 인용한 글에 이 내용이 없음. 글은 에이전트가 만든 코드에 CI를 언제 돌릴지 정하는 branch controls만 언급함 | https://github.blog/news-insights/product-news/welcome-home-agents/ |
| 33 | mission control 가이드 (2025-12-01): 같은 파일이면 머지 충돌, 의존 작업은 순차, drift 신호, agents.md가 모호함 | OT | 확인 | | https://github.blog/ai-and-ml/github-copilot/how-to-orchestrate-agents-using-mission-control/ |
| 34 | Ruflo: "Claude Flow is now Ruflo", 약 82.1k 스타, 10,608 커밋, Queen-led, 100개 이상 에이전트, AgentDB(HNSW), 워커 12개, "1.3×–1953×" | OT | 확인 | 벤치마크는 자체 gist 기준 자기보고 | https://github.com/ruvnet/ruflo |
| 35 | Claude Squad: tmux, worktree, `--autoyes`(실험), 약 8.8k 스타 | OT | 확인 | | https://github.com/smtg-ai/claude-squad |
| 36 | Conductor: Mac 앱, Claude Code·Codex·Cursor, 최신 0.97.0 | OT | 확인 | 회사명(Melty Labs, YC)은 페이지에 없음 | https://www.conductor.build/ |
| 37 | Conductor 문서 배너 "$22m Series A" | OT | 확인 불가 | 인용한 문서 페이지에서 이 배너를 보지 못함 | https://www.conductor.build/docs/tips/multiple-processes |
| 38 | Conductor "Winding down, with cloud shutdown on November 20" (비교 글 인용) | OT | 수정 필요 | 이 문구는 글에 없음. 실제 표현은 "Conductor is winding down."이고 Conductor Cloud가 "goes read-only on November 13 and shuts down on November 20". 공식 사이트에는 오늘(11-20)도 종료 안내가 없음 | https://openalternative.co/blog/best-ai-coding-agent-orchestrators , https://www.conductor.build/ |
| 39 | Vibe Kanban: "Vibe Kanban is sunsetting.", 약 28.8k 스타, Bloop 2026-04-10 종료 발표, 커뮤니티 유지, 무료 사용자 위주 | OT | 확인 | GitHub 표기 라이선스는 Apache-2.0 | https://github.com/BloopAI/vibe-kanban , https://vibekanban.com/blog/shutdown |
| 40 | Crystal 2026-02 지원 중단, Nimbalyst로 대체 | OT | 확인 | | https://github.com/stravu/crystal |
| 41 | Orca 약 130k 스타, 코디네이터가 워커를 workspace에 띄움, 예약 automation, GitHub·Linear, 실패 체크·리뷰 코멘트 되돌리기 | OT | 확인 | 비교 글은 본문 66k, 표 117k로 자체 불일치 | https://github.com/stablyai/orca |
| 42 | Paperclip 약 115k 스타, MIT, 조직도, 단일 담당자·실행 락, 하트비트, cron/webhook routine, 예산 하드 스톱, 승인, 내장 Postgres, 외부 트래커 연동은 로드맵 | OT | 확인 | | https://github.com/paperclipai/paperclip |
| 43 | 비교 글 스냅샷: Paradev 16k, Emdash 6.2k, Paseo 23k, T3 Code 49k, Omnigent 11k, Orchestrator.inc 14k | OT | 확인 | 표 값 기준. 본문은 T3 Code 22k, Emdash 5.7k로 표와 다름. 글은 Composio를 언급하지 않고 "the renamed Agent Orchestrator project"라고만 씀 | https://openalternative.co/blog/best-ai-coding-agent-orchestrators |
| 44 | Anthropic 모델: Opus 5.5 (09-22), Sonnet 5.5 (09-28), Haiku 5.5 (10-07), Fable 5.2·Mythos 5.2 (11-09, Mythos는 검증된 조직 한정) | RD | 확인 | | https://platform.claude.com/docs/en/release-notes/overview , https://www.anthropic.com/news/models |
| 45 | Fable 5.1·Mythos 5.1 출시일 2026-09-01 | RD | 수정 필요 | 두 1차 출처의 날짜가 다름. Platform 릴리스 노트는 "September 1, 2026", anthropic.com/news/models는 "Introducing Claude Mythos and Fable 5.1"을 Sep 15, 2026으로 표시. Mythos 5.1은 Project Glasswing 참가자 한정 | 위와 같음 |
| 46 | Opus 5.5 "Fable 5.1 수준, Opus 5보다 40% 저렴" | RD | 수정 필요 | 뉴스 페이지 문구는 "costs 40% less to run than Opus 5 on typical workloads". 토큰 단가는 $4/$20 대 $5/$25로 20% 낮음. "Fable 5.1 수준"이라는 비교는 두 페이지에서 보지 못함 | 위와 같음 |
| 47 | Code Review GA (2026-10-15): Team·Enterprise, 약 20분 → 6~10분, Quick/Standard/Deep, $10,000 이상 크레딧, 승인·머지·autofix 언급 없음 | RD | 확인 | 크레딧은 2027-01-15까지 신청(claim)하고, 받은 뒤 30일 후 만료 | https://claude.com/blog/code-review-is-now-generally-available |
| 48 | Claude Code 2.1.329 (2026-11-19): `/code-review` 기본 동작·라벨, `/simplify` 분리, 기본 브랜치 대비 리뷰, `/tasks` 통합, worktree 서브에이전트 git 거부(2.1.326), `onFailure: block` | RD | 확인 | 대부분 "on most models" 단서가 붙음. `onFailure: block`은 command·HTTP 훅에 이미 있었고 2.1.328에서 `mcp_tool` 훅에 추가됨 | https://code.claude.com/docs/en/changelog |
| 49 | "대화형 세션은 permission mode를 정하지 않으면 auto mode로 시작 (2.1.328)" | RD | 수정 필요 | 2.1.328 항목은 Bedrock, Google Cloud Agent Platform, Foundry, Claude apps gateway의 Opus 4.6·Sonnet 4.6에 auto mode를 추가한 내용이고 그 범위에서 "interactive sessions with no permission mode start in it". 2.1.326은 조직 정책이 로드되지 않았을 때와 HIPAA 구성에 한정. 전체 기본값 변경으로 읽히면 안 됨 | https://code.claude.com/docs/en/changelog |
| 50 | Claude Duet (2026-10-21, research preview): 미국 Pro·Max 대기자, Opus 5.5 기반, 메시지·결제·삭제 전 승인 | RD | 확인 | | https://www.macrumors.com/2026/10/21/anthropic-claude-duet/ |
| 51 | DevDay Codex (2026-09-29): 재사용 cloud environment, 음성, `/agents` 뷰, automatic review, GitHub PR·GitLab MR 피드백, Security Cloud, Agents API computer use | RD | 확인 | 피드백은 사용자가 ChatGPT 데스크톱 앱에서 변경을 검토한 뒤 PR/MR에 공유하는 흐름으로 설명됨 | https://techcrunch.com/2026/09/29/openai-gives-codex-reusable-cloud-environments-that-work-across-devices/ |
| 52 | GPT-6.1 Terra (10-26), Pro 100·Pro 500 Codex 한도 두 배 (10-29) | RD | 확인 불가 | help.openai.com이 403. 우회하지 않음. BetaNews에서 Pro 500 요금제($500/월) 존재만 확인 | https://help.openai.com/en/articles/6825453-chatgpt-release-notes |
| 53 | Universe 2026 (2026-10-28): "From issue to merge, in one app", Copilot projects("starting today"), automations(개선안은 사람 승인), code review Max(ReviewBench), Fusion, Git 재설계 | RD | 확인 | | https://github.blog/news-insights/company-news/github-universe-2026-evolving-every-layer-of-the-stack/ |
| 54 | GitHub Agentic Workflows GA (2026-10-28): Markdown → Actions YAML, Free·Team·Enterprise, 기본 엔진은 Copilot 라이선스 필요 | RD | 확인 | | https://github.blog/changelog/2026-10-28-github-agentic-workflows-generally-available |
| 55 | Agentic Workflows public preview 2026-06-11 | RD | 확인 불가 | changelog에는 시작일이 없고 InfoQ(2026-11-11)는 "June 2026"까지만 말함 | https://infoq.com/news/2026/11/github-agentic-workflows-ga |
| 56 | VS Code September 2026 releases (2026-10-01): agent merge, automations, 세션에서 PR 생성, Mark as Done | RD | 확인 | agent merge, automations, Mark as Done은 preview. PR 생성은 preview 표시 없음 | https://github.blog/changelog/2026-10-01-github-copilot-in-vs-code-september-2026-releases |
| 57 | Gemini CLI가 2026-06-18에 Antigravity CLI로 이동 | RD | 확인 | 정확히는 그날 Google AI Pro·Ultra 요청 처리를 중단. Gemini Code Assist Standard·Enterprise 라이선스는 영향 없음. 게시일 2026-05-19 | https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/ |
| 58 | Cursor 9~10월 항목 (self-hosted, Bugbot Security Review, Environments API 300 repo, Agent SDK, retarget 재리뷰) | RD | 확인 불가 | 공식 릴리스 노트 페이지는 앞부분(11월 항목)만 읽혔고 해당 항목은 보이지 않음. self-hosted worker, Agent SDK, Environments라는 기능 자체는 11월 항목에 나옴 | https://cursor.com/docs/release-notes |
| 59 | Factory $200M·$5B (2026-09-15), Droid 1.0 (2026-10-29) | RD | 확인 불가 | 서드파티 리뷰 페이지는 노트와 같은 내용을 말함. 1차 출처는 열지 못함 | https://wetheflywheel.com/en/radar/factory-ai-review/ |
| 60 | Devin Apps (2026-11-13) | RD | 확인 | 2차 출처(2026-11-16) 본문 기준. 순차 배포 중 | https://casrai.org/news/devin-apps-private-hosted-internal-tools-launch-2026 |
| 61 | Spec Kit v1.0.0 (2026-08-21, 첫 커밋 1주년), "stability"에서 "adaptability"로, v1.4.0 (11-10) reasoning effort·context size 매핑, v1.4.3 (11-19) | RD | 확인 | 릴리스 페이지는 연도를 표시하지 않음(일·월만). 첫 커밋 2025-08-21은 Manorrock 글에서 확인. "이 기간 릴리스 40개, v0.15.2부터"는 세어 보지 못함 | https://github.com/github/spec-kit/releases , https://www.manorrock.com/blog/2026/08/21/spec_kit_turns_one.html |
| 62 | Superpowers v7.0.0 (10-10): brainstorming 재작성, builder check, Antigravity Marketplace manifest. v7.0.1 (10-21), v7.0.2 (11-03) | RD | 확인 | | https://github.com/obra/superpowers/releases |
| 63 | BMAD stable v6.12.4 (10-14), V7 "preview alpha", ETA "mid-November 2026", v7 태그 없음 | RD | 확인 | 스타 55.6k | https://github.com/bmad-code-org/BMAD-METHOD/releases , https://github.com/bmad-code-org/BMAD-METHOD |
| 64 | GSD 원 repo archived, GSD Core로 이동, GSD Core v1.22.0 (11-19) | RD | 확인 | archive 날짜는 2026-06-26으로 표시됨. "마지막 push 2026-05-31"과 v1.10.0 (08-08)은 페이지에서 보이지 않아 확인 불가 (보인 가장 오래된 릴리스는 v1.14.0, 09-14) | https://github.com/gsd-build/get-shit-done , https://github.com/open-gsd/gsd-core/releases |
| 65 | OpenSpec v2.0.0 (11-11): `.agents/skills/`, `/opsx:*` 제거, `/openspec-propose`, Amazon Q Developer 제외. v2.1.0 (11-17), v2.1.1 (11-19) | RD | 확인 | | https://github.com/Fission-AI/OpenSpec/releases |
| 66 | Task Master: 2026-08-01 이후 릴리스 없음 | RD | 확인 | 최신 릴리스는 task-master-ai@0.43.1 (03-31). "마지막 push 2026-04-28"은 확인 불가 | https://github.com/eyaltoledano/claude-task-master/releases |
| 67 | Harvard 워킹페이퍼 (Chen & Stratton): 현재 버전 2026-08-04, 725,938명, 718개 기업, 2021-01~2026-03, LOC +30%, 커밋 +20%, PR +23%, 머지까지 +49%(기준 7.03일), 코멘트 +35%, 완료 작업 변화 없음, 80%·23.3% | RD | 수정 필요 | 노트의 수치는 2026-08-04 버전 기준으로 2차 출처와 일치함. 그러나 논문 PDF의 현재 버전은 **2026-11-19**이고 수치가 바뀜: 720,542명, 655개 기업, 4.45억 이벤트, 2021-01~2026-08. 에이전트 효과는 LOC +44.0%, 커밋 +36.0%, PR +35.7%, PR 제출→머지 +56.1%(기준 3.56일), PR당 코멘트 +38.6%, Jira issue +13.7%(경계선 유의), epic +18.0%. AI 리뷰 도구 도입 79.1%(2026-07 기준), AI 코멘트 23.3%, AI 코멘트를 받은 PR 10.8% | https://fion.ac/jellyfish.pdf , https://complexdiscovery.com/harvard-researchers-find-ai-coding-agents-shifted-the-bottleneck-to-code-review/ |
| 68 | Octoverse 2026 (10-28, 11-06 업데이트): 9월 에이전트 초안 PR 40% 이상(3월 17%), 1.1억 건, 2주 안 머지 83% → 90%, 미감지 약 86%, 하한값, Copilot MAU 55%, cloud agent +230% | RD | 확인 | 1.1억 건은 에이전트가 시작한 PR 수(3월의 약 6배)이고 전체 PR 수가 아님 | https://github.blog/news-insights/octoverse/octoverse-commits-pushes-reach-new-highs-in-2026-as-developers-build-with-agents/ |
| 69 | Anthropic "Redesigning source control" (2026-10-13): 하루 약 2,500건 → 30,000건 이상, Scion, 7명·5개월, CI checkout 약 2,500만 회, CI CPU 25%, Antique, 의도 리뷰, "no" | RD | 확인 | 2026-10-15 업데이트 표시 있음 | https://www.anthropic.com/research/redesigning-source-control |
| 70 | Anthropic "global merge-queue lock을 머지 후·배포 전 테스트로 대체" | RD | 수정 필요 | 글의 설명은 업계 표준인 전역 락을 그 규모에서 재현할 수 없어서 대신 머지 후·배포 전 자동 테스트에 투자했다는 것. 있던 락을 없앤 것이 아님 | 위와 같음 |
| 71 | PostHog (2026-08-11): 에이전트가 PR 약 70% 작성, 사람은 80% 이상 훑어봄, Horthy 3부작 요약 | RD | 확인 | | https://posthog.com/newsletter/software-factories |
| 72 | LinearB 수치 (Zigler 2026-10-15 인용): pickup 5.25배, P75 17.6시간 대 3.4시간, 머지율 32.7% 대 84.4%, `/sdlc` skill | RD | 확인 | Zigler 글 본문으로 확인. LinearB 보고서 원문은 열지 않음 | https://devinterrupted.substack.com/p/your-agents-should-ask-the-factory |
| 73 | arXiv 2608.21311 (2026-08-21, ESEM 2026): 248,641개 PR, 약 1.6%, 100배 이상 증가, CodeRabbit 35.0% 대 10.5% | RD | 확인 | 초록 표현은 "more than two orders of magnitude". ESEM의 Emerging Results 트랙 | https://arxiv.org/abs/2608.21311 |
| 74 | arXiv 2609.19101 (v1 09-16, v2 10-09), Bergen 외: GLM 5.2가 DeepSWE 57.2%, SWE-bench 73%에서 reward hacking, DoM 모니터 | RD | 확인 | 대상 모델은 Kimi K3, GLM 5.2, Qwen 3.8 Max 세 개. DoM 모니터는 DeepSWE에서 Kimi K3는 3.1% 더, GLM 5.2는 7.9% 덜 잡음 | https://arxiv.org/abs/2609.19101 |
| 75 | Handshake DeepSWE "speculative reward hacking" (2026-09-18) | RD | 확인 | 거의 모든 프런티어 모델에서 rollout의 80% 이상이 숨은 grader를 추론했고, 10~25%에서 요구사항에서 벗어남 | https://joinhandshake.com/research/ai/deepswe-reward-hacking/ |
| 76 | METR 2026-07-21 expenditure horizon: mergeable 50~70% | RD | 확인 | 아이디어 기준 약 70%, 속도 향상 가중으로 Opus-4.8 약 60%, GPT-5.5 약 50% | https://metr.org/blog/2026-07-21-expenditure-horizon/ |
| 77 | 게임 스튜디오 사례 (Willison 2026-10-29): 에이전트가 라이브 코드를 바꿔 매시간 배포 | RD | 확인 | 회사는 Spawn (Jacob Sansbury 글). "Our agents change the live code directly and ship to production hourly" | https://simonwillison.net/2026/Oct/29/ |
| 78 | Willison "The October inflection point for vibe game development", Codex CLI `/goal` 소개 | RD | 확인 불가 | 10-29 페이지에는 10-28자 vibe-game-development 글로 가는 링크만 있고 제목·본문은 없음. `/goal` 내용도 이 페이지에 없음 (태그 페이지는 따로 열지 않음) | https://simonwillison.net/2026/Oct/29/ |
| 79 | Horthy "Why Software Factories Fail" 원문 (wsff.md) | RD | 확인 | 파일 존재, 부제 "harness engineering is not enough". 날짜 표시는 없음 | https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/wsff.md |

## 보고서에 반영할 수정 사항

1. **Harvard 논문 수치를 최신 버전으로 바꾸거나 버전을 명시한다.** 논문은 2026-11-19에 갱신됐다. 최신 수치는 720,542명, 655개 기업, 2021-01~2026-08, 에이전트 도입 후 LOC +44.0%, 커밋 +36.0%, PR +35.7%, 머지까지 +56.1%(기준 3.56일), PR당 코멘트 +38.6%다. "완료 작업은 0과 구분되지 않는다"도 약해졌다. Jira issue +13.7%(경계선 유의), epic +18.0%이고, 논문의 표현은 "코드 산출에 비해 최종 산출 효과가 훨씬 작다"다. 718개 기업, +30%/+23%/+49%를 쓰려면 "2026-08-04 버전 기준"이라고 적는다.
2. **Fable 5.1·Mythos 5.1 출시일은 두 날짜를 함께 적는다.** Platform 릴리스 노트는 2026-09-01, anthropic.com 뉴스는 2026-09-15다.
3. **Opus 5.5 가격 표현을 고친다.** "typical workloads에서 운영 비용 40% 절감"(Anthropic 표현)이고 토큰 단가는 20% 낮다($4/$20 대 $5/$25). "Fable 5.1 수준"은 뺀다.
4. **Claude Code Projects를 "재출시"라고 쓰지 않는다.** 2026-09-17 베타 출시다.
5. **만든 인용문 세 개를 원문으로 바꾼다.**
   - Gas City "orchestration-builder SDK" → README의 "The open-source platform for building software factories from teams of coding agents"
   - Symphony "The service runs continuously and polls on a fixed interval" → "Poll the issue tracker on a fixed cadence and dispatch work with bounded concurrency"
   - Cursor "Some agents run far too long" → "Agents occasionally run for far too long"
6. **Symphony의 Linear 근거는 README로 옮긴다.** SPEC.md는 특정 트래커를 지정하지 않는다. "v1은 Linear만", "GitHub Issues는 확장 대상"은 스펙에 없으므로 "레퍼런스 구현은 Linear 보드를 감시한다" 정도로 쓴다.
7. **Claude Code auto mode 서술을 좁힌다.** 2.1.328은 서드파티 클라우드의 Opus 4.6·Sonnet 4.6에 auto mode를 추가한 것이고, 모든 대화형 세션의 기본값이 바뀌었다는 근거는 아니다.
8. **Anthropic merge-queue 서술을 고친다.** "락을 대체했다"가 아니라 "전역 락을 재현할 수 없어 머지 후·배포 전 테스트에 투자했다"다.
9. **출처 배정을 고친다.** Devin Bots "4.5x more PRs per message"는 AlphaSignal에만 있다. Dots의 클라우드 컴퓨터와 Codex 작업 생성은 BetaNews·heise·VentureBeat에 있고 TechCrunch에는 없다. Dots 가격은 "첫 Dot은 Pro·Business Premium에 포함"으로 세 출처가 일치하므로 "출처마다 다름"을 지운다.
10. **근거가 없는 항목은 빼거나 미확인으로 표시한다.** Agent HQ "지정된 브랜치에만 커밋", Conductor "$22m Series A" 배너, Gas City의 Gas Town pack 기본 포함, Agentic Workflows preview 시작일 "06-11"(확인된 것은 "2026년 6월"), GSD "마지막 push 05-31"(확인된 것은 archive 2026-06-26), GSD Core v1.10.0 날짜, GPT-6.1 Terra와 Pro 한도 두 배, Cursor 9~10월 항목, Factory 투자·Droid 1.0.
11. **Conductor 종료 건은 문구를 고치고 미확인으로 둔다.** 비교 글의 실제 표현은 Conductor Cloud가 11-13 읽기 전용, 11-20 종료다. 공식 사이트에는 안내가 없다.
12. **작은 보정.** Octoverse의 1.1억 건은 에이전트가 시작한 PR 수다. Cursor worktree는 Cursor 3 출시(04-02)가 아니라 04-24 변경 로그에서 추가됐다. Code Review 크레딧은 2027-01-15까지 신청이다. Citigroup 14,000명은 Devin Bots가 아니라 Devin 사용자다.

## 판정 집계

- 확인: 59
- 수정 필요: 12
- 확인 불가: 8
- 틀림: 0
- 합계: 79

지어낸 제품이나 논문은 발견하지 못했다. Claude Code Projects, Devin Bots, Dots, Claude Duet, GitHub agent merge, Agentic Workflows GA, Copilot app, Code Review GA, arXiv 2608.21311, arXiv 2609.19101은 모두 1차 출처나 주요 매체 본문에서 확인됐다. Devin Bots는 Cognition 자체 페이지가 아니라 Fortune 단독 보도와 AlphaSignal로만 확인했다.
