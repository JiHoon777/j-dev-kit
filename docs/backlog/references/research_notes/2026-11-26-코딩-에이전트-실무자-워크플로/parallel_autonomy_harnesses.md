# 여러 코딩 에이전트를 병렬·장시간 돌리는 하네스와 사람을 부르는 시점 (2026-11-26 기준)

비교 기준
- pstack: Lauren Tan(poteto)의 Cursor 스킬 묶음. autopilot 플레이북, 새 에이전트가 PR 검증, 사람은 마지막 머지 결정 등.
- j-dev-kit: 백로그 항목 하나에 워크트리 하위 세션 하나를 열고, 하위 세션의 질문을 부모 세션이 사용자에게 전달하고, 수락 기준은 별도 에이전트가 판정하고, 머지는 사용자 승인으로만 한다.

조사 방식 메모: 공식 문서·체인지로그를 먼저 봤고, 2차 요약으로만 확인한 내용은 "(2차)"로 표시했다. 조사 예산 때문에 Claude Squad·Sculptor·Cursor Projects는 깊이 보지 못했다(각 Gaps 참고).

## 1. 누가 만들었고, 실제로 쓰이는 근거와 마지막 릴리스는 무엇인가

### Takeaway
2026년에는 모델 회사(Anthropic, OpenAI, Cursor, GitHub, Cognition, Factory)가 병렬·장시간 실행을 제품 기본 기능으로 넣었다. 독립 오케스트레이터(Conductor, Vibe Kanban, Claude Squad, Sculptor)는 "워크트리/컨테이너 + 한 화면 대시보드"로 수렴했고, Vibe Kanban은 종료(sunsetting)를 공지했다.

### Cited Findings
**Claude Code (Anthropic)**
- 공식 문서는 병렬 작업 방식을 다섯 가지로 나눈다: subagents, agent view(`claude agents`, research preview), agent teams(실험 기능, 기본 꺼짐), dynamic workflows, Projects(Pro/Max/Ultra 공개 베타) — [Run agents in parallel](https://code.claude.com/docs/en/agents.md)
- agent view 문서에 v2.1.248~v2.1.323 사이 기능 변경이 적혀 있다. 날짜는 문서에 없다 — [Agent view](https://code.claude.com/docs/en/agent-view.md)
- `/goal`은 v2.1.139 이상 필요(번역본 문서 기준, 2차 검색 요약). check-in은 v2.1.234+, idle check-in 상한은 v2.1.246에 생겼다 — [/goal 문서](https://code.claude.com/docs/en/goal.md)
- Projects는 Team/Enterprise에는 아직 없고, 클라우드 세션을 써 본 계정부터 차례로 열리고 있다 — [Projects 문서](https://code.claude.com/docs/en/claude-projects.md)

**OpenAI Codex cloud**
- 공식 문서 주소가 developers.openai.com/codex/cloud에서 learn.chatgpt.com/docs/cloud로 옮겨졌다(308 리다이렉트). 페이지에 2026 날짜는 없다 — [Codex cloud 문서](https://learn.chatgpt.com/docs/cloud)

**Cursor (Anysphere)**
- Automations 출시: 2026-03-05 체인지로그. 트리거와 지시로 도는 "always-on" 에이전트 — [Cursor changelog 03-05-26](https://cursor.com/changelog/03-05-26); 트리거 예(코드 추가, Slack 메시지, 타이머)는 [TechCrunch 2026-03-05](https://techcrunch.com/2026/03/05/cursor-is-rolling-out-a-new-system-for-agentic-coding)
- 2026-05-20(Cursor 3.5): Automations가 Agents Window로 들어가고, 여러 저장소나 저장소 없이도 만들 수 있게 됨 — [Cursor changelog 05-20-26](https://cursor.com/changelog/05-20-26) (검색 요약으로 확인)
- 2026-08-19 "Cloud agents and Cursor harness improvements": Subscriptions, Custom Modes, 자체 머신에서 도는 서브에이전트, `/goal`, Steering — [Cursor changelog 08-19-26](https://cursor.com/changelog/08-19-26)
- Background Agents의 첫 출시 시점은 2차 자료끼리 어긋난다(2025-08 v0.50 vs 2025-11~2026-05) — [ClickUp 요약](https://clickup.com/learn/topic/ai/tools/cursor/news/) (2차, 신뢰도 낮음)

**pstack (Lauren Tan)**
- Cursor 플러그인. 스킬·원칙·플레이북 묶음이고 SKILL.md는 Claude Code·Codex에서도 로드된다. 24개 워크플로 스킬, 23개 원칙, 22개 플레이북, 2개 서브에이전트 — [Flavio Copes, "A deep dive into pstack" (2026-08-21, 2026-09-29 갱신)](https://flaviocopes.com/pstack.md)
- 사용량: Cursor 페이지 제목은 "10,000 agent runs", Copes 글은 한 주 9,000회라고 적어 숫자가 다르다 — [Cursor lp-team/lauren](https://cursor.com/es/lp-team/lauren); [Copes](https://flaviocopes.com/pstack.md)
- 소속도 자료마다 다르다(Cursor 엔지니어 vs. SpaceXAI Grok 팀, 2차 검색 요약) — 검색 결과 요약 기준, 원문 미확인

**Conductor (Melty Labs)**
- 이용약관상 Melty Labs, Inc., 개인정보 고지상 Melty, Inc. YC S24. Mac 앱으로 Claude Code·Codex·Cursor·OpenCode 에이전트를 병렬로 돌린다. Conductor Cloud와 Slack 연동도 있다 — [Conductor llms-full.txt](https://www.conductor.build/llms-full.txt)
- 최신 버전·날짜는 확인하지 못했다(문서 내 "2026-11-03"은 법률 문서 날짜) — 같은 출처

**Vibe Kanban (BloopAI)**
- Apache-2.0 오픈소스. GitHub에 28.8k 스타, 3.1k 포크. 저장소 상단에 "Vibe Kanban is sunsetting" 공지가 있다. 릴리스 섹션은 비어 있다 — [GitHub BloopAI/vibe-kanban](https://github.com/BloopAI/vibe-kanban)
- 실사용 평: VirtusLab 블로그가 에이전트끼리 파일을 덮어쓰는 문제를 푼다고 평가(마케팅 아닌 제3자) — [VirtusLab](https://virtuslab.com/blog/ai/vibe-kanban/)

**Claude Squad (smtg-ai)**
- 오픈소스 Go CLI(`cs`), Homebrew 설치. README가 백그라운드 실행과 "yolo / auto-accept mode"를 내세운다 — [README](https://raw.githubusercontent.com/smtg-ai/claude-squad/main/README.md)
- 마지막 릴리스 날짜는 확인하지 못했다.

**Sculptor (Imbue)**
- Imbue가 만든 Claude Code용 데스크톱 UI. 에이전트마다 Docker 컨테이너. 창업자가 "4-6 agents" 병렬이 흔하다고 말했다 — [Imbue Sculptor](https://imbue.com/sculptor/); [HN Show HN](https://hn.svelte.dev/item/45427697) (날짜 미확인, 2025년 출시로 추정)
- 2026 비교 글은 Claude Code와 Imbue 자체 Pi 하네스를 중심으로 한다고 적는다 — [Superset vs Sculptor (2026)](https://superset.sh/compare/superset-vs-sculptor) (경쟁사 글이라 2차)

**Devin (Cognition)**
- 2026 릴리스 노트가 11월까지 촘촘하다. 2026-11-19 "Devin Bots": 세션 여러 개를 각자 클라우드 머신에서 병렬로 돌려 PR이 준비될 때까지 일한다. 2026-10-23 "Playbooks are becoming Skills" — [Devin release notes 2026](https://docs.devin.ai/release-notes/2026)

**Factory (droids)**
- Missions 발표: 페이지 기준 2026-02-26, Enterprise·Max 플랜에 CLI·IDE 확장으로 배포. 모델 표에 Opus 4.6, GPT-5.3-Codex가 있다 — [Factory "Missions"](https://factory.com/news/missions). 검색 요약은 이를 2025-02-26로 적었는데, 모델 이름을 보면 2026이 맞다(검색 요약 오류로 판단).
- 2026-06: Missions가 Factory Desktop에 들어감, 노트북을 닫아도 도는 "Droid Computers" — [AlphaSignal](https://alphasignal.ai/news/factory-s-missions-let-droids-build-code-autonomously-for-two-weeks) (2차)
- 2026-06-15 "Factory 2.0" 글은 자율성을 단계로 본다 — 검색 요약 기준, 원문 미확인 ([factory.ai/news/software-factory](https://factory.ai/news/software-factory))

**GitHub Copilot coding agent / Agent HQ (GitHub)**
- Agent HQ와 Mission Control은 Universe 2025(2025-10) 발표. 여러 에이전트(Claude, Codex, Copilot 등)에 일을 맡기고 추적하는 대시보드 — [GitHub blog](https://github.blog/news-insights/company-news/welcome-home-agents/) (2025)
- 2026-10-28부터 새 "Copilot in the cloud" 경험이 유료 플랜에 열림 — [GitHub Docs: About coding agent](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)

### Inferences
- 독립 오케스트레이터 시장은 플랫폼 기본 기능(agent view, Projects, Cursor cloud agents, Agent HQ)에 잠식되고 있다. Vibe Kanban 종료 공지가 한 신호다.
- Claude Code에 이미 agent view·Projects·`/goal`·agent teams가 있으므로, j-dev-kit은 "백로그 항목 → 세션" 규칙과 사람 질문 전달·판정·머지 정책에 집중하는 편이 겹침이 적다.

### Gaps
- Claude Squad, Sculptor, Conductor의 2026 최신 릴리스 번호·날짜는 확인하지 못했다.
- Cursor "Projects"라는 기능은 이번 조사에서 1차 자료를 찾지 못했다.
- Vibe Kanban 종료 공지의 날짜·사유는 링크된 공지를 읽지 못해 모른다.
- Codex cloud의 2026 변경 이력(best-of-N, code review 등)은 해당 페이지에 없어 확인하지 못했다.

## 2. 작업 단위와 격리 방식은 무엇인가

### Takeaway
작업 단위는 대부분 "작업(task) 하나 = 브랜치 하나 = PR 하나"이고, 격리는 로컬 도구가 git worktree, 클라우드 도구가 컨테이너·VM(작업별 머신)이다. 예외로 Claude Code agent teams는 팀원끼리 워크트리를 나누지 않는다.

### Cited Findings
- **Claude Code agent view**: 백그라운드 세션 하나가 완전한 대화 하나다. 디스패치된 세션은 파일을 고치기 전에 `.claude/worktrees/` 아래 자기 워크트리로 옮겨 간다. `worktree.bgIsolation: "none"`으로 끌 수 있다 — [Agent view](https://code.claude.com/docs/en/agent-view.md)
- **Claude Code agent teams**: 리드 1 + 팀원 N, 공유 작업 목록(pending/in progress/completed, 의존성으로 blocked), 메일박스(`~/.claude/teams/{team}/inboxes/{agent}.json`). 팀원을 워크트리로 격리하지 않으므로 파일 소유를 나눠야 한다. 팀원은 다른 팀원을 만들 수 없다 — [Agent teams](https://code.claude.com/docs/en/agent-teams.md); [Run agents in parallel](https://code.claude.com/docs/en/agents.md)
- **Claude Code `/batch`**: 큰 변경 하나를 5~30개의 워크트리 격리 서브에이전트로 쪼갠다 — [Run agents in parallel](https://code.claude.com/docs/en/agents.md)
- **Claude Code Projects**: 대화 하나가 코디네이터, 작업마다 "thread"(보통 클라우드 세션, 요청하면 Remote Control로 내 컴퓨터) — [Projects](https://code.claude.com/docs/en/claude-projects.md)
- **Codex cloud**: 작업마다 자기 workspace, 컴퓨터가 잠들어도 계속 돈다. 환경(저장소, 설치 스크립트, start skill, 네트워크 허용 범위)을 정의해 재사용 — [Codex cloud](https://learn.chatgpt.com/docs/cloud). 컨테이너라는 말은 페이지에 없다.
- **Cursor**: Automations는 트리거 시 클라우드 샌드박스를 띄운다 — [Tessl](https://tessl.io/blog/cursor-launches-automations-for-always-on-coding-agents/) (2차). 2026-08-19부터 서브에이전트도 "자기 머신"(프로젝트 복사본, 깨끗한 컨텍스트)에서 돈다 — [Cursor changelog 08-19-26](https://cursor.com/changelog/08-19-26)
- **pstack**: Autopilot-full은 "독립 PR 큐", Autopilot-stack은 Graphite 스택 하나, Orchestrate는 여러 날짜 프로젝트에서 상주 코디네이터가 에이전트 무리를 지휘 — [Copes](https://flaviocopes.com/pstack.md)
- **Conductor**: workspace마다 브랜치·git worktree·실행 환경·공유 컨텍스트 폴더. 생성 시 setup script 실행. 에이전트는 샌드박스 없이 사용자 권한으로 돈다(별도 머신·VM 권장) — [Conductor docs](https://www.conductor.build/llms-full.txt)
- **Vibe Kanban**: 칸반 이슈 → workspace(브랜치, 터미널, dev 서버). 워크트리 정리 설정이 있다 — [GitHub](https://github.com/BloopAI/vibe-kanban)
- **Claude Squad**: tmux 세션 + git worktree로 인스턴스마다 격리 — [README](https://raw.githubusercontent.com/smtg-ai/claude-squad/main/README.md) (README 내용은 검색 요약으로만 확인)
- **Sculptor**: 에이전트마다 Docker 컨테이너. "Pairing Mode"가 에이전트 브랜치를 로컬로 체크아웃하고 컨테이너 파일을 내 에디터로 미러링 — [Imbue docs: containers](https://docs.imbue.com/features/containers); [Imbue Sculptor](https://imbue.com/sculptor/)
- **Devin**: 세션마다 클라우드 머신, 부모-자식 세션 구조(2026-11-06 "Reveal child sessions") — [Devin release notes 2026](https://docs.devin.ai/release-notes/2026)
- **Factory Missions**: 오케스트레이터가 마일스톤으로 쪼개고, 기능마다 새 worker 세션(깨끗한 컨텍스트), 인계는 git으로("Git is the source of truth") — [Factory Missions](https://factory.com/news/missions)
- **Copilot coding agent**: GitHub Actions 환경, 저장소 하나·브랜치 하나, 작업당 PR 하나, 세션 59분 제한 — [GitHub Docs](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)

### Inferences
- j-dev-kit의 "백로그 항목 = 워크트리 하위 세션"은 업계 기본형(작업=브랜치=PR, 워크트리 격리)과 같다. 다른 점은 단위를 백로그 파일로 고정한다는 것뿐이다.
- 작업 단위 안에서 "fresh context worker"(Factory)와 "fresh agent verifier"(pstack)를 쓰는 흐름이 강하다. 같은 세션에 구현과 판정을 맡기지 않는다는 점에서 j-dev-kit의 별도 판정 에이전트와 방향이 같다.

### Gaps
- Codex cloud의 격리 기술(컨테이너/VM)과 병렬 시도 수는 이번에 읽은 페이지에 없다.
- Claude Squad 격리 세부는 README 원문을 직접 읽지 못했다.

## 3. 사람에게는 언제, 어떻게 묻는가 (무엇은 묻지 않고 진행하는가)

### Takeaway
공통 패턴은 "도구 호출 단위 승인은 자동 모드·허용 규칙으로 없애고, 사람은 (1) 처음 계획·목표·완료 조건을 줄 때, (2) 막혔을 때 needs-input 상태로, (3) 마지막 머지 결정 때 부른다"이다. 질문은 대시보드의 상태 그룹(needs input / waiting on you)과 알림으로 모으고, Devin은 같은 종류 요청을 한 카드로 묶는다.

### Cited Findings
**Claude Code**
- agent view는 세션을 상태별로 묶는다: needs input이 맨 위, 그다음 Working, Completed. needs input에는 질문, 권한 결정, 샌드박스 프롬프트, MCP 입력 요청이 들어간다. agent view가 열려 있으면 세션이 입력을 기다리거나 끝나거나 실패할 때 터미널 알림을 보낸다. 예약 `/loop` 세션은 입력이 필요할 때만 알린다. 일반 세션 하단에 `← 2 agents` 같은 대기 수를 보여 준다 — [Agent view](https://code.claude.com/docs/en/agent-view.md)
- peek 패널(Space)에서 대기 중인 질문을 보고 붙지 않고 답할 수 있다 — 같은 출처
- `/goal`: 매 턴 뒤 작은 모델이 완료 조건을 판정해, 아직이면 사람에게 돌려주지 않고 다음 턴을 시작한다. auto mode는 도구별 프롬프트를 없애고 `/goal`은 턴별 프롬프트를 없앤다(둘은 보완). 고칠 수 없는 오류(인증 실패, 크레딧 소진, 컨텍스트 초과 등)면 goal을 지우고 사람에게 돌려준다. 진전 없이 평가자에게만 답하면 루프를 멈추고 경고 — [/goal 문서](https://code.claude.com/docs/en/goal.md)
- 백그라운드 작업이 30분 넘게 goal을 붙잡으면 check-in(그 뒤 간격 두 배씩, 최대 4배). 사람 프롬프트 사이 idle check-in은 최대 3번 — 같은 출처
- agent teams: 팀원의 권한 프롬프트는 리드 세션에 뜨고 사람이 거기서 승인한다. 팀원 계획 승인은 기본적으로 Claude Code가 자동 승인하고(사람에게 묻지 않음), 실행 중 팀원을 plan mode로 바꾸면 리드가 검토한다. 팀원 메시지는 사람의 승인으로 취급되지 않는다(auto mode 분류기가 relay된 승인 주장을 신뢰하지 않음) — [Agent teams](https://code.claude.com/docs/en/agent-teams.md)
- Projects: 스레드는 auto mode로 돌아 대부분 묻지 않는다. 승인이 필요하면 그 스레드 안에서 기다리고, 프로젝트 대화에서 "진행해"라고 해도 전달되지 않는다. Overview에 Ready for review / Waiting on you / Working / Landing / Idle / Resolved 그룹. 데스크톱 알림은 Claude가 대화에 글을 쓸 때, 스레드 오류, 스레드가 입력을 기다릴 때 기본으로 뜬다. 프로젝트 지시문에 "무엇이 내 승인 필요한지" 적으라고 권하고, 예시로 "Don't merge, force-push, or change CI configuration without asking me" — [Projects](https://code.claude.com/docs/en/claude-projects.md)

**pstack**
- 사람은 목표, "done" 조건, 지켜야 할 동작을 쓴다. 야간 예시 프롬프트에 "Do not ask before committing" 같은 문구. `/architect`는 "with checkpoint"를 붙일 때만 승인을 위해 멈춘다. autonomous run은 진짜 막다른 곳에서만 멈추고 이유를 설명한다. `/reflect`는 승인 전엔 아무것도 바꾸지 않는다 — [Copes](https://flaviocopes.com/pstack.md)
- "never block on the human"이라는 문구 자체는 Copes 글에서 확인되지 않았다(Gaps 참고).

**Cursor**
- 2026-08-19: Steering — 작업 중 보낸 후속 메시지는 진행 중 동작을 끊지 않고 다음 도구 호출 때 반영. Subscriptions — 에이전트가 PR·Slack 스레드·스케줄을 구독해 일이 생기면 깨어남. 자기가 만든 PR을 자동 구독해 CI 수정과 봇 코멘트 처리까지 끝냄 — [Cursor changelog 08-19-26](https://cursor.com/changelog/08-19-26)
- Automations는 사람 개입 없이 트리거로 시작 — [Cursor changelog 03-05-26](https://cursor.com/changelog/03-05-26)

**Devin (2026 릴리스 노트)**
- 2026-11-12: 같은 종류의 요청 여러 개를 카드 하나로 묶어 보여 준다. 2026-11-09: Slack 권한 카드에 Deny 버튼. 2026-11-23: MCP 도구 승인 카드에 "Allow for this session". 2026-11-06: 비밀값 요청 카드에 단계별 안내. 2026-11-11: Devin이 스스로 미래에 깨어날 리마인더 설정 — [Devin release notes 2026](https://docs.devin.ai/release-notes/2026)

**Factory Missions**
- `/enter-mission` 뒤 Droid가 명확화 질문과 계획 반복으로 범위를 잡고, 사람이 계획을 승인하면 실행. "The planning phase is where most of the value comes from." 그 뒤 사람은 프로젝트 매니저처럼 모니터링하고 막힌 worker를 풀어 준다 — [Factory Missions](https://factory.com/news/missions)
- 자율성 지표: "autonomy percentage"(완전 자율 변경 비율), "autonomy ratio"(중단 전 사람 대 AI 행동 비율). Factory 자체 코드베이스는 약 15~20% 자율, 비율 80%대 후반 — [ZenML LLMOps DB](https://www.zenml.io/llmops-database/building-autonomous-software-engineering-agents-for-enterprise-with-forward-deployed-engineering) (2차)

**독립 오케스트레이터**
- Claude Squad: `--autoyes`(실험) 플래그로 모든 인스턴스가 Claude Code·Aider 프롬프트를 자동 수락 — [README](https://raw.githubusercontent.com/smtg-ai/claude-squad/main/README.md) (검색 요약 기준)
- Conductor: 에이전트는 사용자 계정 권한으로 파일 읽기·쓰기, 셸 실행. 입력 요청 알림 방식은 이번에 확인 못 함 — [Conductor docs](https://www.conductor.build/llms-full.txt)
- Vibe Kanban: diff에 인라인 코멘트를 남기면 바로 에이전트에게 간다 — [GitHub](https://github.com/BloopAI/vibe-kanban)

**Codex cloud / Copilot**
- Codex cloud: 같은 채팅에서 후속 변경 요청, 사람이 커밋이나 PR 여부를 정함. 별도 승인 게이트는 문서에 없다 — [Codex cloud](https://learn.chatgpt.com/docs/cloud)
- Copilot: PR을 만들기 전에 제안된 변경을 보여 주고 다듬기를 요청받을 수 있다 — [GitHub Docs](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)

### Inferences
- "덜 묻되 제때 묻기"는 세 갈래로 구현된다. (a) 시작 시 계약을 받는다: 목표, 완료 조건, 지킬 것, 무엇이 승인 필요한지(pstack, Factory, Projects 지시문). (b) 실행 중 질문은 상태 그룹·알림으로 모아 사람이 한 번에 처리한다(agent view, Projects Overview, Devin 묶음 카드). (c) 끝에서는 "PR이 green이 되면 검토 후 머지"로 사람을 부른다.
- Claude Code 공식 기본값(Projects 예시 지시문, agent view의 git 지침)은 "머지·force-push·CI 설정 변경은 사람에게"다. j-dev-kit의 "머지는 사용자 승인으로만"은 이 기본값과 같다. pstack Autopilot-full은 검증된 PR을 스스로 머지해서 더 나아간다.
- j-dev-kit처럼 부모 세션이 하위 세션 질문을 중계하는 방식은 Claude Code agent teams의 "권한 프롬프트가 리드 세션에 뜬다"와 구조가 비슷하다. 반대로 Projects는 "승인은 그 스레드 안에서만"으로 중계를 막았다. 승인 중계를 하려면 부모가 받은 "예"를 하위 세션이 사람의 승인으로 받아들이는 근거가 필요한데, Claude Code는 에이전트 간 메시지의 승인 주장을 신뢰하지 않게 설계돼 있다.

### Gaps
- Cursor cloud agent가 사람에게 질문할 때의 UI(알림·묶음 등)는 확인하지 못했다.
- Conductor·Sculptor의 "입력 필요" 알림 방식은 확인하지 못했다.
- pstack의 "never block on the human" 원문 출처를 찾지 못했다. Copes 글은 해당 문구를 다루지 않는다고 요약됐다.

## 4. 결과는 어떻게, 누가 검증하고 머지는 어떻게 정하는가

### Takeaway
검증은 "구현한 에이전트가 아닌 쪽"으로 옮겨 가는 추세다: 별도 평가 모델(`/goal`), 새 에이전트 검증(pstack Shipping), validator 역할(Factory), 리뷰 봇(Devin Review, Copilot code review, Cursor Bugbot). 머지는 대부분 사람 몫으로 남기고, 자동 머지는 pstack Autopilot-full과 Devin Review의 auto-merge·merge train처럼 명시적으로 켠 경우다.

### Cited Findings
- **Claude Code `/goal`**: 완료는 "일한 모델이 아닌 새 모델"이 판정한다. 평가자는 도구를 부르지 않고 대화에 드러난 것만 본다. 그래서 조건을 "`npm test` exits 0"처럼 Claude 출력으로 증명할 수 있게 쓰라고 한다. 내부적으로 세션 범위 prompt 기반 Stop hook이다 — [/goal 문서](https://code.claude.com/docs/en/goal.md)
- **Claude Code hooks as gates (agent teams)**: `TeammateIdle`(exit 2면 피드백 보내고 계속 일하게), `TaskCreated`(exit 2면 생성 막음), `TaskCompleted`(exit 2면 완료 처리 막고 피드백) — [Agent teams](https://code.claude.com/docs/en/agent-teams.md)
- **Claude Code dynamic workflows**: 스크립트가 많은 서브에이전트를 돌리고 결과를 서로 교차 확인 — [Run agents in parallel](https://code.claude.com/docs/en/agents.md)
- **Claude Code agent view 머지**: Claude는 워크트리에서 커밋·푸시하고 적절하면 draft PR을 열되, main/master 푸시·force-push·머지는 하지 않도록 지시받는다. 행의 `#N` 라벨 색(노랑=체크/리뷰 대기, 초록=통과, 보라=머지됨)을 보고 "초록이 되면 검토 후 머지"하라고 안내 — [Agent view](https://code.claude.com/docs/en/agent-view.md)
- **Claude Code Projects**: Landing 그룹 = PR 승인 또는 머지 대기. 머지 같은 마지막 단계를 사람이 하면 Claude가 스레드를 Resolved로 표시 — [Projects](https://code.claude.com/docs/en/claude-projects.md)
- **pstack**: Shipping은 PR마다 새 에이전트가 검증하고, 이전 판정을 현재 커밋 기준으로 다시 확인하고, 스택에서 연속으로 검증된 부분만 랜딩. Autopilot-full은 검증된 PR을 머지, Autopilot-stack은 랜딩을 사람에게 남김. "green PR = 네 머지 결정 준비 완료". 리뷰 패널은 여러 모델(Opus 5.5, Sol, Grok). `/swarm`의 병렬 워커는 PASS/ISSUES/BLOCKED로 보고 — [Copes](https://flaviocopes.com/pstack.md)
- **Factory Missions**: 마일스톤마다 validation 단계. 테스트, 회귀, 통합 확인, 앱을 띄워 흐름을 클릭해 봄. 문제가 나오면 오케스트레이터가 후속 작업을 만든 뒤 넘어간다. validator는 다른 모델(GPT-5.3-Codex) — [Factory Missions](https://factory.com/news/missions)
- **Devin Review (2026)**: PR마다 라운드당 보고서 하나를 갱신(11-04), 푸시마다 계속 리뷰(10-23), 리뷰 지적을 Devin이 고칠지 별도 설정(11-12), GitLab merge train 추가(11-13), `m` 키로 auto-merge(11-13), 권한 있는 사용자는 막힌 PR 직접 머지(10-21) — [Devin release notes 2026](https://docs.devin.ai/release-notes/2026)
- **Cursor**: 클라우드 에이전트가 자기 PR을 구독해 CI 수정·봇 코멘트 처리까지 — [Cursor changelog 08-19-26](https://cursor.com/changelog/08-19-26)
- **Copilot**: 코딩 에이전트 흐름에 코드 리뷰 단계를 넣어 사람이 보기 전에 1차 리뷰·수정 — [SD Times 등 Agent HQ 보도](https://sdtimes.com/ai/github-unveils-agent-hq-the-next-evolution-of-its-platform-that-focuses-on-agent-based-development/) (2025, 2차). 공식 문서는 세션 로그가 사람의 리뷰·테스트를 대신하지 않는다고 적는다 — [GitHub Docs](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)
- **Conductor**: Diff Viewer(Cmd+Shift+D), Checks 탭(git 상태, CI, 배포, 코멘트, todo), PR 만들고 준비되면 머지 후 workspace 보관 — [Conductor docs](https://www.conductor.build/llms-full.txt)
- **Vibe Kanban**: diff 검토 후 AI가 쓴 설명으로 PR을 열거나 머지 — [GitHub](https://github.com/BloopAI/vibe-kanban)

### Inferences
- j-dev-kit의 "수락 기준을 별도 에이전트가 판정"은 `/goal`의 별도 평가자, pstack Shipping의 새 에이전트 검증, Factory validator와 같은 줄기다. pstack에서 더 가져올 만한 것: (1) 판정을 현재 커밋 기준으로 다시 확인(재작업 뒤 낡은 판정 막기), (2) 여러 모델로 이뤄진 리뷰 패널, (3) PASS/ISSUES/BLOCKED 세 값 보고.
- `/goal` 문서의 "평가자는 대화에 드러난 것만 본다"는 제약은, 판정 에이전트에게 실행 증거(명령 출력)를 반드시 넘겨야 한다는 뜻이다.

### Gaps
- Cursor Bugbot의 2026 동작(자동 수정, 머지 차단)은 확인하지 못했다.
- Codex code review 기능 페이지는 읽지 못했다.

## 5. 진행과 결정은 어떻게 기록되어 사람이 나중에 감사하거나 새 에이전트가 이어받는가

### Takeaway
기록 방식은 세 가지다: 트랜스크립트·세션 로그(Claude Code, Copilot, Devin), 파일로 남기는 결정 로그·메모리(pstack TSV 결정 로그, Claude Projects 메모리 파일, 팀 작업 목록 디렉터리), git 자체(Factory "Git is the source of truth"). 재개는 세션 resume + 목표/메모 파일 복원이 기본이다.

### Cited Findings
- **pstack**: 결정 로그는 TSV 파일, 행마다 시간·단계·결정·이유·증거·결과. 기본은 로컬, 큰 프로젝트에선 리뷰어를 위해 커밋 가능(`show-me-your-work`가 유지). `/interrogate`는 버린 항목을 이유와 함께 "dismissed" 칸에 남긴다. 세션 이어받기는 트랜스크립트·브랜치·결정 로그를 읽고, 안전하게 멈출 때 resume 노트를 쓴다. Benny는 PR에 전후 증거를 붙인다 — [Copes](https://flaviocopes.com/pstack.md)
- **Claude Code `/goal`**: 평가 판정마다 트랜스크립트에 남고(Ctrl+O로 이유), 달성/실패 항목 기록. resume하면 활성 goal을 복원하되 턴 수·타이머·토큰 기준은 초기화 — [/goal 문서](https://code.claude.com/docs/en/goal.md)
- **Claude Code agent view**: 세션은 끝날 때 무엇을 했고 결과가 어디 있는지 보고서를 남긴다. 한 시간쯤 방치된 세션은 프로세스가 멈출 수 있지만 대화는 디스크에 남는다. `claude --resume <id> --bg` — [Agent view](https://code.claude.com/docs/en/agent-view.md)
- **Claude Code agent teams**: 작업 목록은 `~/.claude/tasks/{team}/`에 세션 뒤에도 남는다(팀 설정은 지워짐). 단, in-process 팀원은 `/resume`으로 복원되지 않는다 — [Agent teams](https://code.claude.com/docs/en/agent-teams.md)
- **Claude Code Projects**: 프로젝트 메모리는 파일(요구사항, 결정, 함정), 스레드는 시작 시 `MEMORY.md` 인덱스를 읽는다. 프로젝트 지시문 최대 16,000자. 스레드를 고쳐 줬으면 "기억해"라고 말해 다음 스레드가 그 교정으로 시작하게 하라고 권한다 — [Projects](https://code.claude.com/docs/en/claude-projects.md)
- **Factory Missions**: 인계는 git으로, 모든 행동 로그, OpenTelemetry 텔레메트리 — [Factory Missions](https://factory.com/news/missions)
- **Copilot**: 세션 로그가 작업과 도구 사용을 보여 주고 28일 보관 — [GitHub Docs](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)
- **Devin**: Knowledge(조직 공통 맥락)와 Playbooks(반복 작업 절차)를 함께 쓰라고 권장(2024-06) — [Cognition June '24 update](https://www.cognition.ai/blog/june-24-product-update). 2025년부터 세션 중 Devin이 지식 항목을 스스로 추가 — [Devin release notes 2025](https://docs.devin.ai/release-notes/2025). 2026-10-23 Playbooks → Skills 전환, 2026-11-17 Knowledge에서 옮겨진 스킬을 관리자가 유지 — [Devin release notes 2026](https://docs.devin.ai/release-notes/2026)

### Inferences
- j-dev-kit의 백로그 파일은 이미 "작업 단위의 영구 기록" 역할을 한다. pstack 결정 로그(시간·결정·이유·증거)를 백로그 항목 안이나 옆에 두면, 사람이 나중에 감사하고 새 세션이 이어받는 데 같은 파일을 쓸 수 있다.
- "사람이 고쳐 준 것을 다음 작업이 기억"하는 흐름(Projects 메모리, Devin 지식 자동 추가)은 사람 질문 횟수를 줄이는 장치다. 한 번 답한 질문을 다시 묻지 않게 한다.

### Gaps
- Conductor·Vibe Kanban·Claude Squad·Sculptor가 세션 기록을 어떻게 남기고 재개하는지는 확인하지 못했다.
- Cursor 클라우드 에이전트의 기록·재개 방식은 확인하지 못했다.

## 6. 백로그 항목 기반 Claude Code 플러그인(하위 세션 방식)이 가져올 만한 것 — 특히 "덜 묻되 제때 묻기"

### Takeaway
가장 근거가 많은 패턴은 "시작할 때 계약을 한 번 받고(목표·완료 조건·승인 필요 행동), 중간 질문은 막혔을 때만 상태로 모아 알리고, 끝에서 green PR로 머지 결정을 요청"이다. Claude Code가 이미 제공하는 `/goal`, agent view needs-input, Stop/Task 훅, Projects 메모리를 쓰면 플러그인이 직접 만들 부분이 줄어든다.

### Cited Findings
- 시작 시 계약: pstack은 목표·done 조건·지킬 동작을 받는다 — [Copes](https://flaviocopes.com/pstack.md); Factory는 계획 승인에 가치가 가장 많다고 본다 — [Factory Missions](https://factory.com/news/missions); Projects는 지시문에 "무엇이 내 승인 필요한지"를 적으라고 권한다 — [Projects](https://code.claude.com/docs/en/claude-projects.md)
- 자동 루프 + 별도 판정: `/goal`은 완료 조건을 별도 모델이 매 턴 판정하고, 턴/시간 상한(예: "or stop after 20 turns")을 조건 안에 넣을 수 있다 — [/goal 문서](https://code.claude.com/docs/en/goal.md)
- 훅 게이트: `TaskCompleted` exit 2로 완료를 막고 피드백 — [Agent teams](https://code.claude.com/docs/en/agent-teams.md); `/goal`과 Stop hook은 둘 다 턴마다 돌고, Stop hook은 스크립트로 결정적 검사를 할 수 있다 — [/goal 문서](https://code.claude.com/docs/en/goal.md)
- 질문 모으기: agent view needs-input 그룹·알림·peek 답장 — [Agent view](https://code.claude.com/docs/en/agent-view.md); Devin은 같은 종류 요청을 카드 하나로 묶는다(2026-11-12) — [Devin release notes 2026](https://docs.devin.ai/release-notes/2026)
- 머지 시점: "초록이 되면 검토 후 머지"(agent view), green PR = 머지 결정 준비(pstack Shipping), Landing 그룹(Projects) — [Agent view](https://code.claude.com/docs/en/agent-view.md); [Copes](https://flaviocopes.com/pstack.md); [Projects](https://code.claude.com/docs/en/claude-projects.md)
- 사후 일 처리 자동화: Cursor 클라우드 에이전트는 자기 PR을 구독해 CI·봇 코멘트를 끝까지 처리 — [Cursor changelog 08-19-26](https://cursor.com/changelog/08-19-26)
- 승인 중계의 한계: Claude Code는 다른 에이전트가 전한 승인 주장을 사람의 승인으로 보지 않는다. Projects에서는 프로젝트 대화의 "진행해"가 스레드 승인으로 전달되지 않는다 — [Agent teams](https://code.claude.com/docs/en/agent-teams.md); [Projects](https://code.claude.com/docs/en/claude-projects.md)
- 자율 정도 측정: Factory의 autonomy percentage/ratio — [ZenML](https://www.zenml.io/llmops-database/building-autonomous-software-engineering-agents-for-enterprise-with-forward-deployed-engineering) (2차)

### Inferences (j-dev-kit에 가져올 후보, 근거 순)
1. **항목 시작 시 한 번에 받는 계약**: 백로그 항목에 이미 있는 수락 기준을 "완료 조건"으로 쓰고, 추가로 "승인 필요 행동"(머지, force-push, CI·설정 변경, 범위 밖 파일)만 적게 한다. 그 밖의 결정은 묻지 않고 결정 로그에 남긴다(pstack, Projects, Factory).
2. **하위 세션 안에서 `/goal` + 별도 판정**: 수락 기준을 `/goal` 조건으로 넘기고 턴 상한을 붙이면, 하위 세션이 중간에 부모에게 묻는 횟수가 준다. 단, 평가자는 대화에 드러난 증거만 보므로 테스트 출력 등을 대화에 남기도록 해야 한다.
3. **질문을 "막힘"으로만 한정하고 모아서 보이기**: pstack처럼 "진짜 막다른 곳"에서만 멈추게 하고, 부모 세션이 여러 하위 세션의 질문을 한 번에 정리해 사용자에게 보인다(agent view needs-input, Devin 묶음 카드). 같은 종류 질문은 하나로 묶는다.
4. **답을 기억시키기**: 사용자가 답한 결정은 백로그 항목이나 프로젝트 메모리에 남겨 다른 하위 세션이 다시 묻지 않게 한다(Projects 메모리, Devin 지식).
5. **판정은 현재 커밋 기준으로 다시**: 재작업 뒤 이전 판정을 재사용하지 않고, 머지 요청 직전에 마지막 커밋 기준으로 다시 판정한다(pstack Shipping).
6. **머지 요청은 green일 때 한 번**: 사람을 부르는 마지막 시점을 "모든 판정·CI 통과" 상태로 고정하고, 그 전엔 부르지 않는다(agent view, pstack, Projects Landing).
7. **결정 로그 파일**: 시간·결정·이유·증거·결과를 항목별로 남겨 사람 감사와 새 세션 재개에 같이 쓴다(pstack TSV).
8. **승인 중계 설계 주의**: 부모가 받은 사용자 승인을 하위 세션에 전할 때, Claude Code의 에이전트 간 메시지는 승인으로 취급되지 않는다. 권한 프롬프트 자체는 하위 세션에서 사용자가 직접 답하게 두거나, 미리 허용 규칙으로 줄이는 쪽이 플랫폼 설계와 맞는다.

### Gaps
- "덜 묻기"가 실제로 품질을 해치지 않는다는 독립 측정 자료는 찾지 못했다. Factory 자율성 수치와 pstack 사용 횟수는 모두 만든 쪽의 자기 보고다.
- 이름 있는 실무 엔지니어의 독립 사용기(마케팅 제외)는 이번 조사에서 VirtusLab 블로그 정도만 확인했다.
