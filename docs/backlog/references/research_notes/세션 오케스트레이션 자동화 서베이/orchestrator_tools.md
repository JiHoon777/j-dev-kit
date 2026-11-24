# 리드 → 워커 코딩 에이전트 오케스트레이터 서베이 (기준일 2026-11-20)

표기 규칙: [자기보고] = 만든 쪽이 직접 낸 수치나 주장, [미확인] = 1차 출처로 확인하지 못함, [2차] = 2차 출처(블로그, 기사, 애그리게이터)에만 있음. 스타 수는 각 페이지를 가져온 시점의 값이고, 출처마다 다를 수 있음.

## 1. 도구별 구조: 역할, 작업 배정, 보고, 상태 저장 위치, 머지/충돌, 사람 개입, 비용/규모, 유지 상태

### Takeaway
2026년의 오케스트레이터는 크게 세 갈래로 나뉜다. (a) **리드 에이전트가 워커를 쪼개 띄우는 계층형**: Gas Town/Gas City, Claude Code agent teams, Claude Code Projects, Devin Manage Devins/Devin Bots, Factory Missions, Cursor planner–worker, Orca 코디네이터, Paperclip, ruflo. (b) **이슈 트래커를 폴링하는 데몬형**: OpenAI Symphony, Composio Agent Orchestrator. (c) **리드 없이 사람이 여러 세션을 나란히 돌리는 병렬 러너**: Claude Squad, Conductor, Vibe Kanban, Crystal, Sculptor, Codex 앱, GitHub mission control. 어느 쪽이든 공통 기반은 "워커마다 git worktree 또는 VM/컨테이너, 결과는 브랜치/PR"이다. 그리고 1세대 병렬 러너 상당수는 2026년에 종료(Vibe Kanban), 지원 중단(Crystal), 은퇴(Gas Town)로 정리됐다.

### Cited Findings

#### Gas Town (Steve Yegge) → Gas City
- 2026-01-01 오픈소스 공개. Beads는 2025-10에 먼저 나왔다. yegge.ai 페이지는 "Gas Town is now retired. Its successor is Gas City."라고 하고, Gas City는 Yegge가 자문하는 회사가 운영한다고 적혀 있다. — [yegge.ai/gastown](https://yegge.ai/gastown)
- 상태 정보가 서로 다르다. GitHub README에는 은퇴 표시가 없고, 7,783 커밋, 395 오픈 이슈, 134 오픈 PR, 약 18.8k 스타다. Yegge의 "From Clown Show to v1.0"(2026-04-03)은 Dolt 이전이 끝난 뒤로 Gas Town이 "maintenance mode"이고, Gas City는 알파이며 GA가 곧 나온다고 썼다. — [gastownhall/gastown](https://github.com/gastownhall/gastown); [Clown Show to v1.0 재게시본](https://drss.io/reader/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/gas-town-from-clown-show-to-v10)
- **역할** (README 기준):
  - Mayor: "primary AI coordinator"
  - Polecats: "persistent identity but ephemeral sessions"를 가진 워커
  - Refinery: rig별 머지 큐
  - Witness: rig별 생명주기 관리. polecat을 감시하고 멈춘 에이전트를 찾아낸다.
  - Deacon: 모든 rig를 순찰 주기(patrol)로 도는 백그라운드 감독자
  - Dogs: Deacon이 보내는 인프라 정비 워커
  - Crew: 사람이 직접 작업하는 공간
  - Convoy: bead 묶음 단위의 작업 추적
  — [gastownhall/gastown](https://github.com/gastownhall/gastown)
- **배정**: 사람이나 Mayor가 `gt sling <bead-id> <rig>`로 bead를 에이전트에게 배정하고, 작업은 에이전트의 hook(git worktree 기반 저장소)으로 전달된다. README: "Work persists in git-backed hooks." — [gastownhall/gastown](https://github.com/gastownhall/gastown)
- **상태 저장**: Beads 원장(git으로 버전 관리되는 이슈 트래커/DB)과 git worktree hook. 세션이 죽으면 다음 세션이 bead에서 이어받는다. Beads는 약 23k 스타, MIT. — [yegge.ai/gastown](https://yegge.ai/gastown)
- Beads v0.x는 SQLite + JSONL 양방향 동기화였고 "two sources of truth", 경쟁 조건, 잦은 머지 충돌, last-write-wins 문제가 있었다. v1.0에서는 내장 Dolt(서버 모드 지원)로 바꾸고 동기화/머지 로직을 걷어냈다. [자기보고] — [Clown Show to v1.0](https://drss.io/reader/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/gas-town-from-clown-show-to-v10)
- **머지**: Refinery는 Bors 방식의 이분 탐색(bisecting) 큐다. polecat이 `gt done`을 하면 Refinery가 MR을 묶고 검증 게이트를 돌리며, 실패하면 이분 탐색으로 원인을 찾는다. README: "polecats never push directly to main." — [gastownhall/gastown](https://github.com/gastownhall/gastown)
- **사람 개입**: 사람(Overseer)이 Mayor에게 할 일을 말하고, `gt convoy list`, `gt agents`, `gt feed`로 지켜본다. 에스컬레이션은 `gt escalate`로 받는다. — [gastownhall/gastown](https://github.com/gastownhall/gastown); 사람은 직접 고치지 않고 Mayor에게 수정 작업을 만들게 한다 — [heise, 2026-02-21](https://www.heise.de/en/background/Full-Control-Gas-Town-Orchestrates-Ten-or-More-Coding-Agents-11178824.html)
- **규모/비용**: Claude Code 인스턴스 20–30개를 병렬로 돌린다고 소개됐다 [2차] — [Cloud Native Now](https://cloudnativenow.com/features/gas-town-what-kubernetes-for-ai-coding-agents-actually-looks-like/). 스케줄러에 `max_polecats` 한도가 있고, API rate limit 소진을 막는 것이 목적이다 — [README](https://github.com/gastownhall/gastown). DoltHub는 피크 때 시간당 약 $100 토큰을 태웠다고 했고, Yegge는 Max 플랜 두 개의 주간 한도를 다 쓰고 세 번째를 쓰고 있다고 했다. [자기보고/2차] — [paddo.dev, 2026-01-17](https://paddo.dev/blog/gastown-two-kinds-of-multi-agent/)
- **Gas City**: "orchestration-builder SDK"다. 선언형 `city.toml`, pack(에이전트, formula, order 묶음), formula를 그래프로 실행, order로 일정이나 이벤트에 따라 formula 실행. Beads(Dolt)에 저장하고 런타임으로 tmux, subprocess, ACP, Kubernetes를 쓰며 Claude Code, Codex, Gemini 등을 지원한다. `gc sling`으로 작업을 넣는다. Gas Town pack이 기본으로 들어 있어 기존 Gas Town을 그대로 대체할 수 있다고 한다 [2차]. — [gascity README](https://raw.githubusercontent.com/gastownhall/gascity/HEAD/README.md); [gascity.com](https://gascity.com/)

#### Claude Code agent teams (Anthropic, 실험 기능)
- 기본은 꺼져 있고 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`로 켠다. 대화형 세션에서만 동작하고, `-p`/Agent SDK에서는 팀원을 띄우지 않는다. — [agent teams 문서](https://code.claude.com/docs/en/agent-teams)
- **역할**: Team lead(평생 고정, 넘길 수 없음), Teammates(각자 별도 Claude Code 인스턴스와 별도 컨텍스트), 공유 Task list, Mailbox. 중첩 팀은 없고 세션당 팀은 하나다. — [agent teams 문서](https://code.claude.com/docs/en/agent-teams)
- **배정**: 리드가 직접 배정하거나, 팀원이 끝난 뒤 다음 미배정·미차단 작업을 스스로 가져간다. 작업 상태는 pending, in progress, completed 세 가지이고 의존성이 있으면 blocked로 표시된다. "Task claiming uses file locking to prevent race conditions." — [agent teams 문서](https://code.claude.com/docs/en/agent-teams)
- **상태 저장(파일)**: mailbox는 `~/.claude/teams/{team}/inboxes/{agent}.json`, team config는 `~/.claude/teams/{team}/config.json`(세션이 끝나면 삭제), task list는 `~/.claude/tasks/{team}/`(남음). — [agent teams 문서](https://code.claude.com/docs/en/agent-teams)
- **보고**: 메시지는 자동으로 전달되고, 팀원이 멈추면 최종 답을 담은 idle 알림이 리드에게 간다. API 에러로 끝나면 실패 알림이 간다. 품질 게이트용 훅으로 `TeammateIdle`, `TaskCreated`, `TaskCompleted`가 있다(exit 2로 막을 수 있음). — [agent teams 문서](https://code.claude.com/docs/en/agent-teams)
- **충돌**: 머지 기능은 없다. "Two teammates editing the same file leads to overwrites. Break the work so each teammate owns a different set of files." — [agent teams 문서](https://code.claude.com/docs/en/agent-teams)
- **사람 개입**: 팀원의 권한 프롬프트가 리드 세션으로 올라온다("Too many permission prompts" 트러블슈팅 항목이 따로 있음). 사람이 어느 팀원에게든 직접 메시지를 보낼 수 있다. — [agent teams 문서](https://code.claude.com/docs/en/agent-teams)
- **비용/규모**: 팀원 3–5명, 팀원당 작업 5–6개를 권장한다. 토큰은 팀원 수에 비례해 선형으로 늘어난다. plan mode에서는 "approximately 7x more tokens than standard sessions"다. — [agent teams 문서](https://code.claude.com/docs/en/agent-teams); [costs 문서](https://code.claude.com/docs/en/costs)

#### Claude Code Projects (Anthropic, 2026-09-17 베타 재출시)
- 하나의 계속 이어지는 대화를 코디네이터로 두고, 작업마다 thread(대부분 클라우드 세션)를 연다. "threads do the work, Claude directs it." — [VentureBeat, 2026-09-17](https://venturebeat.com/orchestration/anthropic-launches-claude-code-projects-an-always-on-conversation-that-remembers-and-delegates-your-long-running-dev-work); [Projects 문서](https://code.claude.com/docs/en/claude-projects)
- 현재 Pro/Max/Ultra 공개 베타이고 순차 배포 중이다. Team/Enterprise는 아직 지원하지 않는다. Remote Control로 내 컴퓨터에서 thread를 돌릴 수도 있다. — [Projects 문서](https://code.claude.com/docs/en/claude-projects)
- **상태 저장**: 프로젝트 메모리(파일, 각 thread가 시작할 때 `MEMORY.md` 인덱스를 읽음), 프로젝트 지침(최대 16,000자), 파일 라이브러리, 레포별 `CLAUDE.md`. 코디네이터는 전체 기록 대신 최근 메시지, 최근 thread, 메모리를 바탕으로 일하므로 컨텍스트를 사람이 관리할 필요가 없다고 한다. — [Projects 문서](https://code.claude.com/docs/en/claude-projects)
- **보고/머지**: thread는 자기 브랜치에서 일하고 필요하면 PR을 연다. auto-fix가 켜진 상태로 PR을 지켜보다가 CI가 실패하거나 리뷰 코멘트가 달리면 깨어나 수정한다. Overview 패널은 thread를 Ready for review, Waiting on you, Landing, Resolved 등 상태별로 보여준다. 겹치는 변경으로 생긴 머지 충돌은 일반 PR처럼 해결한다. — [Projects 문서](https://code.claude.com/docs/en/claude-projects); [VentureBeat](https://venturebeat.com/orchestration/anthropic-launches-claude-code-projects-an-always-on-conversation-that-remembers-and-delegates-your-long-running-dev-work)
- **사람 개입**: 데스크톱 기본 알림은 Claude가 대화에 글을 올릴 때, thread 에러, 입력 필요 시 세 가지이고 thread 턴마다 받도록 설정할 수 있다. Pause/Archive로 멈출 수 있다. 사람이 준 thread 수 제한은 "preference rather than a cap"이고 강제 한도는 하루 새 thread 500개다. — [Projects 문서](https://code.claude.com/docs/en/claude-projects) (2차 출처의 "하루 200개"는 문서와 다름 — [daleseo 등 검색 결과](https://code.claude.com/docs/en/claude-projects))

#### OpenAI Symphony (오픈소스 스펙 + Elixir 레퍼런스)
- README: "Symphony is a low-key engineering preview for testing in trusted environments." 약 28.1k 스타, 47 커밋, 릴리스 없음. "harness engineering"을 갖춘 코드베이스에서 가장 잘 동작한다고 한다. — [openai/symphony](https://github.com/openai/symphony)
- **구조**: 리드 LLM이 없다. 데몬이 트래커(v1은 Linear)를 기본 30초(`polling.interval_ms`)마다 폴링하고, `active_states`에 있는 이슈를 우선순위, 생성일 순으로 배정한다. 동시 실행 한도는 `max_concurrent_agents` 기본 10이고 상태별 한도도 둘 수 있다. 이슈마다 workspace 디렉터리를 만들고 lifecycle hook을 붙인다. 워커당 최대 20턴. 실패하면 지수 백오프(최대 5분), stall 타임아웃(기본 5분)이 지나면 죽이고 재시도한다. — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
- **상태 저장**: 스케줄러 상태는 "intentionally in-memory"다. 재시작 뒤에는 트래커와 파일시스템으로 복구하고 DB는 없다. 트래커가 이슈 상태의 원본이다. — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
- **보고**: 오케스트레이터는 트래커에 쓰지 않는다. 에이전트가 도구로 상태 전환, 코멘트, PR 링크를 남긴다. 성공한 실행은 "Human Review" 같은 handoff 상태에서 끝날 수 있다. workflow는 레포 안의 `WORKFLOW.md`(YAML front matter + 프롬프트)로 정의한다. — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md); [agentpatterns.ai](https://www.agentpatterns.ai/standards/symphony-orchestration-spec/)
- 데모에서는 CI 상태, PR 리뷰 피드백, 복잡도 분석, 워크스루 영상을 "proof of work"로 제출하고, 승인되면 PR을 머지한다. — [openai/symphony](https://github.com/openai/symphony)
- 동기: 엔지니어가 세션 3–5개 넘게 관리하면 컨텍스트 전환이 괴로워진다는 점 [2차]. OpenAI가 독립 제품으로 유지보수할 계획은 없다고 전해진다 [2차, 미확인]. — [InfoWorld](https://www.infoworld.com/article/4164173/openais-symphony-spec-pushes-coding-agents-from-prompts-to-orchestration.html); [betterstack](https://betterstack.com/community/guides/ai/openai-symphony/)

#### OpenAI Codex 앱 / Dots
- Codex 데스크톱 앱(macOS)은 2026-02-02 출시. 프로젝트별 thread, 에이전트마다 worktree, diff 리뷰, Automations(일정에 따른 백그라운드 작업. OpenAI 내부에서 매일 이슈 트리아지, CI 실패 요약, 릴리스 브리핑에 쓴다). 클라우드 트리거로 계속 실행하는 기능은 "예정"이라고 했다. — [heise, 2026-02-04](https://heise.de/-11165126); [OpenAI 발표(직접 가져오기 403, 검색 요약으로만 확인)](https://openai.com/index/introducing-the-codex-app/). Windows판은 2026-03 [2차] — [AlternativeTo](https://alternativeto.net/news/2026/3/openai-s-ai-coding-app-codex-launches-on-windows-with-multi-agent-management-and-sandboxing)
- 정해진 리드/오케스트레이터 에이전트는 문서에 없다. "agents run in parallel and exchange tasks." — [heise](https://heise.de/-11165126)
- Dots(2026-09-29, DevDay): 자기 클라우드 컴퓨터를 가진 항상 켜진 ChatGPT 에이전트로, 필요하면 Codex에 일을 넘긴다. 코딩 전용 오케스트레이터는 아니다. — [TechCrunch](https://techcrunch.com/2026/09/29/openai-launches-dots-its-bubbly-agentic-avatar/); [BetaNews](https://betanews.com/article/openai-dots-agents-chatgpt/)

#### Devin: Manage Devins (2026-03-19) → Devin Bots (2026-11-17)
- 메인 Devin이 작업을 쪼개 managed Devin에게 배정하고, 지켜보며 충돌을 해결하고 결과를 모은다. 자식마다 "a full Devin, running in its own isolated virtual machine." 자식은 스스로 검증한 뒤 보고하고, 코디네이터는 자식의 전체 궤적을 읽어 다음 분해 방식을 개선한다. 자식별 ACU 소비를 추적하고, 사람은 세션 링크로 들여다보거나 메시지, 일시정지, 종료를 할 수 있다. 충돌 해결 방법은 설명이 없다. — [Cognition 블로그](https://cognition.com/blog/devin-can-now-manage-devins); [Devin 문서](https://docs.devin.ai/work-with-devin/advanced-capabilities)
- Devin Bots: 영속 메모리, 예약 트리거, 세션별 VM을 가진 영속 코디네이터. 목표를 작업으로 나누고, 세션을 띄우고 추적하며, 사람 승인이 필요한 결정은 에스컬레이션한다. 베타 사용자가 "4.5x more PRs per message"를 머지했다고 하나 [자기보고, 기준선/표본 없음], 가격과 GA는 미정이다. — [Fortune, 2026-11-17](https://fortune.com/2026/11/17/exclusive-cognition-bets-on-devin-bots-coding-agents-in-challenge-to-anthropics-duet-and-openais-dots/); [AlphaSignal](https://alphasignal.ai/news/cognition-s-devin-bots-now-run-parallel-coding-sessions-hitting-2-000-pull); [digg 요약](https://digg.com/ai/l3h088z7). Cognition 자체 Bots 페이지는 찾지 못함 [미확인].
- "Devin can now Schedule Devins" 글도 있다(내용은 가져오지 않음). — [Cognition 블로그](https://cognition.com/blog/devin-can-now-schedule-devins)

#### Factory Missions (Droids)
- 오케스트레이터 Droid와 사람이 대화하며 계획(마일스톤, 성공 기준, 스킬)을 세우고, 사람이 승인하면 Mission Control이 워커 실행을 관리한다. "The orchestrator is an agent, and you can talk to it." "not fire-and-forget." Agent Readiness Level 4 이상과 스크립트로 앱을 돌려볼 QA 수단이 필요하다. 기능 약 500개가 넘으면 미션을 나누라고 한다. 병렬화가 순차보다 나은지는 "open question"이라고 적혀 있다. — [Factory 문서](https://docs.factory.com/cli/features/missions)
- 검증자 역할이 따로 있고, 충돌을 막으려고 기능은 순차로, 읽기만 병렬로 실행한다 [2차/토크 요약]. 미션 중앙값 약 2시간, 14%가 하루 이상, 최장 40일 [자기보고]. 다른 토크 요약은 최장 16일이라고 해서 서로 다르다. — [36kr](https://eu.36kr.com/en/p/3704948816556163); [AI Engineer 토크](https://ai.engineer/talks/ow1we5PzK-o-production-multi-agent-architecture); [ThinkStack](https://thinkstack.com/talk/ow1we5PzK-o)

#### Cursor (planner–worker–judge 연구 → 제품)
- 2026-01-14 Wilson Lin 글. 공유 파일과 락으로 하는 자율 조율은 실패했다("Twenty agents would slow down to the effective throughput of two or three"). 위계가 없으면 에이전트가 어려운 일을 피했다. 그래서 planner(sub-planner를 재귀로 띄움), worker(서로 조율하지 않고 push), 사이클마다 judge 구조로 바꿨다. 충돌 해결용 integrator 역할은 병목이 돼서 없앴고, 워커가 충돌을 직접 처리한다. 에이전트 수백 개, 1주에 100만 줄 이상(브라우저), 총 수조 토큰 [자기보고]. 남은 문제로 재계획 부재, 너무 오래 도는 에이전트, drift를 막으려면 주기적으로 새로 시작해야 한다는 점을 들었다. — [cursor.com/blog/scaling-agents](https://cursor.com/blog/scaling-agents)
- 제품: Cursor 3(2026-04) Agents Window(worktree 병렬). 2026-09 Coordinators/Projects에서 코디네이터가 에이전트를 만들고 관리한다고 전해진다 [2차, 미확인]. — [digitalapplied](https://www.digitalapplied.com/blog/cursor-3-agents-window-complete-guide); [DEV](https://dev.to/aiengillustrated/how-cursor-got-thousands-of-ai-agents-to-build-one-browser-3loh)

#### GitHub Agent HQ / mission control
- 2025-10 Universe에서 발표. mission control은 여러 에이전트(Copilot과 Anthropic, OpenAI, Google, Cognition, xAI 등 서드파티)에 일을 맡기고 조정하고 추적하는 단일 화면이다. 에이전트는 지정된 브랜치에만 커밋할 수 있다. — [GitHub 블로그](https://github.blog/news-insights/product-news/welcome-home-agents/)
- 2025-12-01 가이드: 결과는 PR과 실시간 세션 로그로 나온다. 같은 파일을 건드리면 머지 충돌이 나므로 작업을 나누고 의존 작업은 순차로 하라고 한다. drift 신호(범위 확장, 순환 재시도 등)도 정리돼 있다. 리드 에이전트는 없고 사람이 디스패처다. — [GitHub 블로그](https://github.blog/ai-and-ml/github-copilot/how-to-orchestrate-agents-using-mission-control/)
- 2026년 업데이트는 찾지 못함 (Gaps 참고).

#### claude-flow → Ruflo (ruvnet)
- "Claude Flow is now Ruflo." 약 82.1k 스타, 10,608 커밋. "Queen-led hierarchy"(Raft/Byzantine/Gossip 합의), 에이전트 100개 이상, 메모리는 AgentDB(HNSW), 자동 트리거되는 백그라운드 워커 12개, `ruflo-loop-workers`(타이머), `ruflo-autopilot`(루프). 벤치마크는 "1.3×–1953×" 우위라고 하나 [자기보고]. 연합(federation)은 로드맵 이슈로만 연결돼 있어 일부는 미구현일 수 있다. — [ruvnet/ruflo](https://github.com/ruvnet/ruflo)

#### Claude Squad / Conductor / Vibe Kanban / Crystal / Sculptor (리드 없는 병렬 러너)
- Claude Squad: tmux 세션과 에이전트별 git worktree, TUI. `--autoyes`(실험)로 자동 수락. 리드 에이전트와 머지 기능은 없고, 브랜치를 커밋/push해서 사람이 리뷰한다. 약 8.8k 스타. — [smtg-ai/claude-squad](https://github.com/smtg-ai/claude-squad)
- Conductor(Melty Labs, YC): Mac 앱. Claude Code, Codex, Cursor 에이전트를 격리된 workspace에서 돌리고 사람이 리뷰/머지한다. 최신 0.97.0. — [conductor.build](https://www.conductor.build/). 문서 배너에 "$22m Series A"가 있다 — [Conductor 문서](https://www.conductor.build/docs/tips/multiple-processes). 한 비교 글은 "Winding down, with cloud shutdown on November 20"이라고 하나 공식 페이지에서는 확인되지 않음 [미확인, 충돌] — [openalternative.co (2026-11-06 갱신)](https://openalternative.co/blog/best-ai-coding-agent-orchestrators)
- Vibe Kanban(BloopAI): 칸반 이슈마다 workspace(브랜치, 터미널, dev 서버)를 주고, diff에 인라인 코멘트를 달면 에이전트에게 간다. 결과는 PR. README 첫 줄이 "Vibe Kanban is sunsetting." 회사 Bloop은 2026-04-10에 종료를 발표했고 커뮤니티 유지 오픈소스로 남는다. 약 28.8k 스타. — [BloopAI/vibe-kanban](https://github.com/BloopAI/vibe-kanban); [종료 공지](https://vibekanban.com/blog/shutdown) (라이선스가 Apache-2.0인지 ELv2인지 출처마다 다름 — [superset 비교](https://superset.sh/compare/superset-vs-vibe-kanban))
- Crystal(stravu): 2026-02 지원 중단, Nimbalyst로 대체. — [stravu/crystal](https://github.com/stravu/crystal)
- Sculptor(Imbue): 에이전트마다 Docker 컨테이너, Pairing Mode로 IDE와 동기화. 2026-06 기준 베타·무료라고 하나 그 뒤 상태는 미확인. — [rywalker 리서치](https://rywalker.com/research/sculptor); [docs.imbue.com](https://docs.imbue.com/features/containers)

#### 2026년에 많이 쓰이는 기타 오케스트레이터 (스타 기준)
- **Orca (stablyai)**: 약 130k 스타(페이지 가져온 시점). 코디네이터 에이전트가 큰 작업을 쪼개 워커를 각자 workspace(worktree)에 띄우고 결과를 돌려받는다. 예약 automation(야간 의존성 업데이트, 주간 트리아지), GitHub/Linear 이슈에서 workspace 시작, 실패한 체크나 PR 리뷰 코멘트를 에이전트에게 되돌려 보내는 기능이 있다. 머지 처리는 설명이 없다. — [stablyai/orca](https://github.com/stablyai/orca). 스타 수가 출처마다 45k, 66k, 95k, 117k로 크게 다르다 — [openalternative](https://openalternative.co/blog/best-ai-coding-agent-orchestrators); [coddykit](https://www.coddykit.com/pages/blog-detail?id=5129989&slug=github-trending-october-2026-from-a-95k-star-agent-fleet-orchestrator-to-a-10k-s)
- **Paperclip (paperclipai)**: 약 115k 스타, MIT. 에이전트를 조직도(CEO/CTO/엔지니어)로 "고용"한다. 티켓(이슈) 기반으로 원자적 체크아웃, 단일 담당자, 실행 락을 쓴다. 하트비트(타이머로 깨움), cron/webhook routine(실행마다 이슈 생성), 회사/에이전트/프로젝트 예산과 하드 스톱(기록된 지출 기준이라 멈추는 데 지연이 있을 수 있음), 이사회(board) 승인 워크플로가 있다. 내장 Postgres에 저장. — [paperclipai/paperclip](https://github.com/paperclipai/paperclip)
- **Composio Agent Orchestrator (`ao`)**: 2026-02 공개. 에이전트마다 worktree, 브랜치, PR. 트래커는 GitHub/Linear. CI 실패와 리뷰 코멘트를 해당 워커에게 되돌려 보낸다. 2026-06 무렵 AgentWrapper 계정으로 옮겨졌다는 말이 있고 [2차, 미확인], 비교 글은 "Orchestrator.inc"로 이름이 바뀌었다고 한다(14k). — [rywalker 리서치](https://rywalker.com/research/agent-orchestrator); [openalternative](https://openalternative.co/blog/best-ai-coding-agent-orchestrators); [awesome.ecosyste.ms](https://awesome.ecosyste.ms/projects/github.com%2Fcomposiohq%2Fagent-orchestrator)
- 같은 비교 글(2026-11 스냅샷)에 Paradev(옛 Superset, 16k, 예약 automation), Emdash(6.2k, 예약 반복 실행), Paseo(23k, 데몬 우선), T3 Code(49k), Omnigent(11k, 지출 한도와 정책 거버넌스), Jean(예약 GitHub 이슈 순회)이 나온다. 전부 [2차]. — [openalternative.co](https://openalternative.co/blog/best-ai-coding-agent-orchestrators)

### Inferences
- "리드"의 실체는 세 가지로 나뉜다: LLM 코디네이터(Mayor, Claude Projects, Devin, Factory, Cursor planner, Orca), 결정론적 데몬(Symphony, Gas Town의 Refinery/Witness/Deacon 같은 순찰 루프), 사람(Squad, Conductor, mission control). Gas Town은 LLM 리드와 결정론적 순찰 역할을 섞은 하이브리드다.
- 상태 저장 위치는 로컬 JSON 파일(agent teams)에서 git 버전 관리 DB(Beads/Dolt), 외부 트래커(Symphony/Linear), Postgres(Paperclip), 클라우드 메모리 파일(Claude Projects)로 옮겨가고 있다. 공통점은 "세션이 죽어도 원장에서 이어받기"다.
- 머지는 대부분 "브랜치/PR + 사람 리뷰 + CI"에 맡긴다. 직렬화 머지 큐를 직접 구현한 곳은 Gas Town Refinery 정도이고, Cursor는 integrator를 없애고 워커가 직접 처리하게 했다. 접근이 정반대다.

### Gaps
- Gas Town의 공식 상태가 서로 맞지 않는다. yegge.ai는 "retired", Yegge 글은 "maintenance mode", README는 은퇴 표시 없이 활동 중으로 보인다. 마지막 커밋 날짜는 확인하지 못했다.
- Yegge의 Medium 글(Welcome to Gas City 등)은 403이라 직접 읽지 못했다.
- Conductor의 2026-11-20 클라우드 종료 주장은 공식 출처에서 확인되지 않았다.
- GitHub Agent HQ/mission control의 2026년 변경 사항은 찾지 못했다.
- Cursor 2026-09 "Coordinators/Projects"의 1차 출처(cursor.com 체인지로그)는 확인하지 못했다.
- Devin Bots의 Cognition 1차 페이지, 가격, 동작 세부는 확인하지 못했다.
- OpenAI Codex 앱 발표 페이지는 403이었다. Symphony를 OpenAI가 계속 유지보수하는지도 미확인이다.

## 2. 일정에 따라 또는 계속 돌아가는 것 (요청할 때만이 아닌 것)

### Takeaway
"켜두면 알아서 도는" 쪽은 Symphony(30초 폴링 데몬), Gas Town(Deacon 순찰, Witness), Gas City(order: 일정·이벤트), Claude Code Projects(always-on 코디네이터 + 클라우드 예약 작업 + PR 감시), Devin Bots(예약 트리거), Paperclip(하트비트/cron routine), Orca, Codex 앱 Automations, ruflo 루프 워커다. Claude Code agent teams, Claude Squad, Conductor, mission control은 요청할 때만 돈다.

### Cited Findings
- Symphony: "The service runs continuously and polls on a fixed interval", 기본 `polling.interval_ms` 30000. — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
- Gas Town Deacon: "Background supervisor running continuous patrol cycles across all rigs." — [gastownhall/gastown](https://github.com/gastownhall/gastown); Beads로 만든 "molecule"이 순찰, 릴리스 같은 결정론적 단계를 실행한다 [2차] — [dark-factory-kb](https://dark-factory-kb.pages.dev/steve-yegge-beads.html)
- Gas City: orders가 formula를 "on a schedule or in response to events" 실행한다. — [gascity README](https://raw.githubusercontent.com/gastownhall/gascity/HEAD/README.md)
- Claude Code Projects: 코디네이터가 "always on"이고, 사람이 체크인 빈도, 새 thread 생성 빈도, 업데이트 상세도를 정한다 — [VentureBeat](https://venturebeat.com/orchestration/anthropic-launches-claude-code-projects-an-always-on-conversation-that-remembers-and-delegates-your-long-running-dev-work). 프로젝트 안에서 예약 작업을 요청하면 cloud scheduled task(routine)로 만들어져 thread로 실행된다. PR을 지켜보는 idle thread는 CI 실패나 리뷰 코멘트가 오면 깨어난다. 사용량 한도로 멈춘 thread는 한도가 리셋되면 기본으로 다시 이어간다. — [Projects 문서](https://code.claude.com/docs/en/claude-projects)
- Devin Bots: "persistent memory, scheduled triggers"; 별도로 "Devin can now Schedule Devins". — [AlphaSignal](https://alphasignal.ai/news/cognition-s-devin-bots-now-run-parallel-coding-sessions-hitting-2-000-pull); [Cognition 블로그](https://cognition.com/blog/devin-can-now-schedule-devins)
- Factory: Droid Computers는 노트북을 닫아도 미션을 계속 돌린다(Plus $100/월) [2차]. — [검색 요약: factory.com 뉴스](https://factory.com/news/droids-now-have-a-fleet-of-sandboxes)
- Paperclip: 에이전트는 배정된 일, 후속 메시지, 타이머 일정에 맞춰 깨어난다. Routine은 cron, webhook, API로 실행되고 실행마다 이슈가 생긴다. — [paperclipai/paperclip](https://github.com/paperclipai/paperclip)
- Orca: 어느 레포에서든 프롬프트를 예약 실행(야간 의존성 업데이트, 주간 트리아지). — [stablyai/orca](https://github.com/stablyai/orca)
- Codex 앱 Automations: 일정에 따른 백그라운드 실행. 클라우드 트리거로 계속 실행하는 기능은 2026-02 시점에 "예정"이었다. — [heise](https://heise.de/-11165126)
- Ruflo: `ruflo-loop-workers`(타이머), `ruflo-autopilot`(루프), 자동 트리거 백그라운드 워커 12개. — [ruvnet/ruflo](https://github.com/ruvnet/ruflo)
- Agent teams는 대화형 세션에서만 팀원을 띄운다(`-p`/SDK 불가). 팀원의 백그라운드 서브에이전트는 리드 프로세스보다 오래 살 수 없다. — [agent teams 문서](https://code.claude.com/docs/en/agent-teams)
- Cursor 연구 하네스는 사이클마다 judge가 계속할지 정하고 새로 시작하는 루프로 몇 주씩 돌았다. — [cursor.com/blog/scaling-agents](https://cursor.com/blog/scaling-agents)

### Inferences
- 계속 돌리는 방식은 셋으로 갈린다: ① 결정론적 폴링/순찰 루프(Symphony, Deacon), ② cron이나 이벤트 트리거로 새 세션 띄우기(Projects routines, Paperclip, Orca, Codex Automations, Gas City orders), ③ 영속 LLM 코디네이터(Projects 코디네이터, Devin Bots). ①과 ②는 idle일 때 비용이 거의 없고, ③은 깨어날 때마다 컨텍스트를 다시 읽는 비용이 든다(Projects 문서의 캐시 1시간 경고 참고).

### Gaps
- Gas Town Deacon 순찰 주기의 기본값과 순찰 한 번당 비용은 찾지 못했다.
- Devin Bots 예약 트리거의 형식(cron인지 이벤트인지)은 확인하지 못했다.

## 3. 이슈 트래커/백로그를 조율 매체로 쓰는 것

### Takeaway
트래커를 원본으로 쓰는 쪽은 Gas Town/Gas City(Beads, git 버전 관리 이슈 DB), Symphony(Linear 상태 머신, GitHub Issues는 확장 대상), Paperclip(자체 티켓), Composio AO(GitHub/Linear), Vibe Kanban(자체 칸반)이다. Orca와 mission control은 트래커 이슈에서 작업을 시작할 수 있지만 조율 원장으로 쓰지는 않는다. Claude Code agent teams는 파일 기반 task list(의존성 있음)이고 외부 트래커는 아니다.

### Cited Findings
- Beads: 각 작업, 수정, MR, 에이전트 메모가 "bead"다. 세션이 죽어도 다음 세션이 bead에서 이어받는다. — [yegge.ai/gastown](https://yegge.ai/gastown). Beads 자체는 Gas Town을 모르는 독립 제품이다 [2차] — [dark-factory-kb](https://dark-factory-kb.pages.dev/steve-yegge-beads.html). Wasteland(2026-03): 여러 Gas Town이 공유 "wanted board"의 작업을 가져간다 — [yegge.ai/gastown](https://yegge.ai/gastown)
- Symphony: 트래커가 원본이다. `active_states`/`terminal_states`/`required_labels`로 배정하고, 에이전트가 상태 전환과 코멘트로 보고하며, "Human Review" 같은 handoff 상태가 있다. v1은 Linear만 지원한다. — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md); [agentpatterns.ai](https://www.agentpatterns.ai/standards/symphony-orchestration-spec/)
- Paperclip: 이슈가 프로젝트, 목표, 부모 작업과 연결되고 원자적 체크아웃과 단일 담당자를 쓴다. 외부 트래커 연동(bring-your-own-ticket-system)은 아직 없다. — [paperclipai/paperclip](https://github.com/paperclipai/paperclip)
- Composio AO: 트래커는 github|linear, SCM은 github(GitLab 옵션) [2차]. — [rywalker 리서치](https://rywalker.com/research/agent-orchestrator)
- Orca: GitHub, Linear 작업을 한곳에서 보고 이슈에서 workspace를 시작한다. — [stablyai/orca](https://github.com/stablyai/orca)
- Vibe Kanban: 칸반 보드에서 이슈를 만들고 배정한 뒤 workspace를 만든다. — [BloopAI/vibe-kanban](https://github.com/BloopAI/vibe-kanban)
- mission control은 Slack, Linear, Jira, Teams, Azure Boards와 연동된다 [2차]. — [GitHub 블로그](https://github.blog/news-insights/product-news/welcome-home-agents/)
- Claude Code agent teams의 task list는 `~/.claude/tasks/{team}/`에 있고, 의존성과 blocked 상태, 파일 락으로 가져가기를 지원한다. — [agent teams 문서](https://code.claude.com/docs/en/agent-teams)
- Claude Code Projects는 트래커 대신 Overview(thread 상태)와 프로젝트 메모리 파일을 쓴다. — [Projects 문서](https://code.claude.com/docs/en/claude-projects)

### Inferences
- 트래커 중심 설계(Symphony, Beads)의 장점은 재시작 복구(스케줄러를 메모리에만 둬도 됨)와 사람이 읽을 수 있는 감사 기록이다. 단점은 트래커와 git 상태가 따로 놀 수 있다는 것(Beads v0.x의 "two sources of truth" 문제)이다.

### Gaps
- Symphony의 GitHub Issues 어댑터가 공식으로 구현됐는지는 확인하지 못했다. 스펙에는 확장 대상으로만 나온다.

## 4. 저자와 사용자가 보고한 문제 (비용 폭주, 머지 충돌, 서로 밟기, 리드 컨텍스트 상실, 알림 과부하)

### Takeaway
반복해서 나오는 문제는 다섯 가지다. ① 토큰/한도 소진(팀원 수만큼 선형 증가, plan mode 약 7배, Gas Town 피크 시간당 $100), ② 같은 파일 덮어쓰기와 머지 충돌, 중복 작업, ③ 상태 원장이 깨지거나 거짓 상태(작업 완료 표시 누락, Beads 동기화 경쟁), ④ drift와 컨텍스트 열화, 리드가 일찍 멈추거나 직접 구현해 버림, ⑤ 권한 프롬프트와 감독 부담("hands-off가 아님"). 알림 과부하는 Claude Squad류의 "스크롤 벽"과 권한 프롬프트 폭주로 간접적으로만 언급된다.

### Cited Findings
- **비용**:
  - agent teams는 "approximately 7x more tokens than standard sessions when teammates run in plan mode", 토큰은 팀 크기에 대략 비례 — [costs 문서](https://code.claude.com/docs/en/costs)
  - Projects는 "uses them faster", Pro는 한도에 더 일찍 닿는다. PR을 지켜보는 idle thread도 깨어날 때 사용량을 쓴다. 1시간 넘게 쉰 thread는 다시 깨어날 때 대화 전체를 다시 읽는다 — [Projects 문서](https://code.claude.com/docs/en/claude-projects)
  - DoltHub는 Gas Town 피크에 시간당 약 $100, Yegge는 Max 플랜 3개째 [자기보고/2차] — [paddo.dev](https://paddo.dev/blog/gastown-two-kinds-of-multi-agent/)
  - Cursor 실험은 "trillions of tokens" [자기보고] — [cursor.com](https://cursor.com/blog/scaling-agents)
  - Paperclip 예산 하드 스톱은 기록된 지출 기준이라 진행 중 작업 때문에 멈추는 게 늦어질 수 있다 — [paperclip](https://github.com/paperclipai/paperclip)
  - 실행이 멈춰도 비용을 막으려고 Factory는 "feature retry limit"을 둔다 — [Factory 문서](https://docs.factory.com/cli/features/missions)
- **머지 충돌과 서로 밟기**:
  - "Two teammates editing the same file leads to overwrites." — [agent teams 문서](https://code.claude.com/docs/en/agent-teams)
  - mission control 가이드: 같은 파일을 건드리면 머지 충돌이 나므로 의존 작업은 순차로 — [GitHub 블로그](https://github.blog/ai-and-ml/github-copilot/how-to-orchestrate-agents-using-mission-control/)
  - heise: 에이전트 3–5개 병렬에서 중복 작업과 풀리지 않은 머지 충돌 — [heise](https://www.heise.de/en/background/Full-Control-Gas-Town-Orchestrates-Ten-or-More-Coding-Agents-11178824.html)
  - DoltHub: 실패한 테스트가 main에 자동 머지됐고 복구에 force push 5번 — [paddo.dev](https://paddo.dev/blog/gastown-two-kinds-of-multi-agent/)
  - Cursor: 공유 파일 락이 너무 오래 잡혀 "Twenty agents would slow down to the effective throughput of two or three"; integrator는 병목이라 제거 — [cursor.com](https://cursor.com/blog/scaling-agents)
  - Factory는 충돌을 피하려고 기능을 순차 실행 [2차] — [36kr](https://eu.36kr.com/en/p/3704948816556163)
- **원장/상태 오류**:
  - "Task status can lag: teammates sometimes fail to mark tasks as completed, which blocks dependent tasks." 리드는 `/resume` 뒤 사라진 팀원에게 메시지를 보낼 수 있다 — [agent teams 문서](https://code.claude.com/docs/en/agent-teams)
  - Beads v0.x는 경쟁 조건, last-write-wins, 몇 주 동안 이어진 대량 데이터 손실("Clown Show") [자기보고] — [Clown Show to v1.0](https://drss.io/reader/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/gas-town-from-clown-show-to-v10)
  - Projects 클라우드 샌드박스가 다시 열리지 않으면 새 클론에서 이어가므로 커밋하지 않은 변경이 사라질 수 있다 — [Projects 문서](https://code.claude.com/docs/en/claude-projects)
  - Symphony는 재시작하면 재시도 타이머와 라이브 세션이 복원되지 않는다 — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
- **폭주/좀비 에이전트**:
  - 초기 Gas Town은 작업 도중 워커를 죽였다("piles of worker corpses") [자기보고] — [Clown Show to v1.0](https://drss.io/reader/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/gas-town-from-clown-show-to-v10)
  - DoltHub: "murderous rampaging Deacon"이 코드를 지웠다 — [paddo.dev](https://paddo.dev/blog/gastown-two-kinds-of-multi-agent/)
  - Deacon이 좀비 프로세스를 정리하고 멈춘 세션을 재시작해야 한다 — [heise](https://www.heise.de/en/background/Full-Control-Gas-Town-Orchestrates-Ten-or-More-Coding-Agents-11178824.html)
  - Factory 실패 유형: 멈춤, 느린 워커, 마일스톤 정지, QA 실패 — [Factory 문서](https://docs.factory.com/cli/features/missions)
  - Cursor: "Some agents run far too long" — [cursor.com](https://cursor.com/blog/scaling-agents)
- **리드/컨텍스트 문제**:
  - 리드가 팀원을 기다리지 않고 직접 구현하거나, 일이 다 끝나기 전에 끝났다고 판단한다 — [agent teams 문서](https://code.claude.com/docs/en/agent-teams)
  - 컨텍스트가 60% 정도 찼을 때부터 품질 저하가 눈에 띈다 [2차] — [heise](https://www.heise.de/en/background/Full-Control-Gas-Town-Orchestrates-Ten-or-More-Coding-Agents-11178824.html)
  - 에이전트 기억력 부족("progressive dementia") [자기보고] — [Clown Show](https://drss.io/reader/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/gas-town-from-clown-show-to-v10)
  - Cursor: planner가 재계획하지 않음, drift를 막으려면 주기적으로 새로 시작해야 함. Opus 4.5는 "stop earlier and take shortcuts" — [cursor.com](https://cursor.com/blog/scaling-agents)
  - Projects는 코디네이터가 전체 기록이 아니라 최근 내용과 메모리로 일하므로, 잊으면 안 되는 것은 메모리에 넣으라고 한다 — [Projects 문서](https://code.claude.com/docs/en/claude-projects)
- **사람 부담/알림**:
  - 팀원 권한 프롬프트가 리드에게 몰린다("Too many permission prompts") — [agent teams 문서](https://code.claude.com/docs/en/agent-teams)
  - Gas Town은 hands-off가 아니고 계속 조종해야 한다(Justin Abrahms) — [paddo.dev](https://paddo.dev/blog/gastown-two-kinds-of-multi-agent/)
  - Claude Code 출력이 "wall of scrolling text"라는 불만 — [Clown Show](https://drss.io/reader/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/gas-town-from-clown-show-to-v10)
  - Dots는 출시 때 권한을 자주 요청했다 [2차] — [검색 요약: Quartz/BetaNews](https://betanews.com/article/openai-dots-agents-chatgpt/)
  - Devin Bots에 대해서는 리뷰어 처리 용량 문제가 남아 있다고 지적됐다 — [AlphaSignal](https://alphasignal.ai/news/cognition-s-devin-bots-now-run-parallel-coding-sessions-hitting-2-000-pull)
  - Projects는 데스크톱 알림 기본값을 게시, 에러, 입력 필요 세 가지로 좁혀 두었다 — [Projects 문서](https://code.claude.com/docs/en/claude-projects)
- **품질/기술 부채**: 한 코드베이스에 로깅 라이브러리가 3–4개 생기는 식의 일관성 없는 설계, 리뷰만 하게 된 개발자의 만족도 하락 [2차] — [heise](https://www.heise.de/en/background/Full-Control-Gas-Town-Orchestrates-Ten-or-More-Coding-Agents-11178824.html). 대부분의 `agents.md`는 너무 모호하다 — [GitHub 블로그](https://github.blog/ai-and-ml/github-copilot/how-to-orchestrate-agents-using-mission-control/). OpenAI는 티켓 수준 작업에서 에이전트가 빗나갈 수 있다고 인정했다 [2차] — [InfoWorld](https://www.infoworld.com/article/4164173/openais-symphony-spec-pushes-coding-agents-from-prompts-to-orchestration.html)
- **지속성**: 1세대 병렬 러너가 2026년에 줄줄이 정리됐다. Vibe Kanban은 회사 종료(2026-04-10, 무료 사용자 위주라 수익 모델 부재) — [종료 공지](https://vibekanban.com/blog/shutdown); [issoh.co.jp](https://www.issoh.co.jp/tech/details/10075/). Crystal은 2026-02 지원 중단 — [stravu/crystal](https://github.com/stravu/crystal). Gas Town은 은퇴 또는 유지보수 모드 — [yegge.ai](https://yegge.ai/gastown).

### Inferences
- 문제의 근원은 대부분 "공유 가변 상태"(같은 파일, 같은 조율 파일, 이중 원장)다. 해결책도 비슷하게 모인다: 파일/모듈 소유권 분할, 워커마다 worktree/VM, 직렬화 머지 큐 또는 PR+CI, 결정론적 감시자(Witness/stall timeout), 하드 예산.
- 비용은 대부분 "동시 실행 수 × 세션 길이 × 깨어나는 횟수"로 늘어난다. 예약/상시 실행 설계라면 idle 웨이크업(PR 감시, 체크인, 순찰)이 숨은 비용이 된다는 점이 문서에 반복해서 나온다(Projects 캐시 경고, costs 문서의 goal check-in/예약 작업 항목 — [costs 문서](https://code.claude.com/docs/en/costs)).

### Gaps
- 오케스트레이터별로 독립 측정한 비용 비교 데이터는 찾지 못했다. 수치는 전부 자기보고이거나 일화다.
- 알림 과부하를 정면으로 다룬 1차 출처 사용자 보고는 찾지 못했다.
- HN/Reddit 1차 사용자 보고는 이번 범위에서 따로 수집하지 않았다.
