# 2026-08-01 ~ 2026-11-20 AI 코딩 에이전트 전체 워크플로 자동화 최근 동향

조사일 2026-11-20. 모든 항목에 날짜와 URL을 붙였다. "(자사 수치)"는 벤더가 직접 낸 숫자, "(2차 출처)"는 1차 출처를 직접 확인하지 못한 항목, "(미확인)"은 출처끼리 엇갈리거나 확인이 안 된 항목이다.

## 1. 주요 벤더의 새 제품·기능 (Anthropic, OpenAI, GitHub, Google, Cursor, Cognition, Factory, Amp)

### Takeaway
이 기간의 공통 흐름은 "이슈 → 머지"를 한 제품 안에 묶는 것과, 며칠~몇 주 동안 살아 있는 상시 에이전트(Dots 2026-09-29, Duet 2026-10-21, Devin Bots 2026-11-17)다. 머지 직전 단계도 자동화 대상에 들어왔다. GitHub agent merge(preview)가 리뷰 피드백, 실패한 체크, 충돌을 처리하고, Devin Bots는 저위험 변경의 자동 승인·머지를 설정할 수 있다. 다만 어느 벤더도 기본값을 사람 승인 없는 머지로 두지 않았다.

### Cited Findings

**Anthropic**
- 모델 출시: Claude Fable 5.1·Mythos 5.1 (2026-09-01), Opus 5.5 (2026-09-22, "Fable 5.1 수준, Opus 5보다 40% 저렴"), Sonnet 5.5 (2026-09-28), Haiku 5.5 (2026-10-07), Fable 5.2·Mythos 5.2 (2026-11-09, Mythos는 검증된 조직 한정) — [Claude Platform release notes](https://platform.claude.com/docs/en/release-notes/overview), [Anthropic Models](https://www.anthropic.com/news/models) (날짜는 검색 요약으로 확인, 개별 발표문은 열어 보지 않음)
- Code Review GA (2026-10-15): Team·Enterprise 대상으로 research preview를 벗어났다. 리뷰 시간이 약 20분에서 6~10분으로 줄었고(약 3배, 자사 수치), repo별로 Quick/Standard/Deep 등급을 고른다. Enterprise에는 $10,000 이상 크레딧(2027-01-15까지 청구). 발표문에는 승인이나 머지, autofix 언급이 없다 — [Claude blog, Code Review is now generally available](https://claude.com/blog/code-review-is-now-generally-available)
- Claude Code 최신 버전 2.1.329 (2026-11-19). 11월 릴리스 내용: `/code-review`가 기본적으로 버그와 CLAUDE.md 위반만 보고하고 Important/Pre-existing/Nit로 라벨을 단다. 정리 제안은 `/simplify`로 분리됐다 (2.1.328). 인자 없이 실행하면 기본 브랜치 대비 브랜치 전체를 리뷰한다 (2.1.329). `/tasks`가 예약 작업, `/loop` wakeup, `/goal`을 한꺼번에 보여 준다 (2.1.329). 대화형 세션은 permission mode를 따로 정하지 않으면 auto mode로 시작한다 (2.1.328). 격리 worktree의 서브에이전트는 공유 브랜치를 다시 쓰는 git 명령을 거부한다 (2.1.326). hook에 `onFailure: block` 옵션이 생겼다 — [Claude Code changelog](https://code.claude.com/docs/en/changelog)
- Claude Code 10월 주요 변경 (2차 출처): mods(플러그인이 더 깊은 동작을 바꿈, v2.1.287, 2026-10-01), Agent tool의 effort 파라미터, 무인 재시도 제어용 환경 변수 — [Claude Code updates October 2026 (Beer And Code)](https://blog.beerandcode.com.br/index.php/en/news/claude-code-updates-october-2026), [tech-insider](https://tech-insider.org/claude-code-plugins-official-mods-cloud-sessions-2026/) (공식 changelog의 8~10월 구간은 페이지가 너무 커서 직접 읽지 못함)
- Claude Duet (2026-10-21, research preview): 연결된 앱을 지켜보다가 사용자가 자리를 비운 뒤에도 일을 계속하는 상시 에이전트. 미국 Pro·Max 대기자 명단, Opus 5.5 기반. 메시지 전송, 결제, 삭제 전에는 사용자에게 묻는다 — [MacRumors](https://www.macrumors.com/2026/10/21/anthropic-claude-duet/), [gHacks](https://www.ghacks.net/2026/10/23/anthropic-launches-claude-duet-a-background-ai-agent-for-claude-pro-and-max-subscribers-in-the-us/) (코딩 전용 제품은 아님)

**OpenAI**
- DevDay (2026-09-29), Codex 관련 발표: 작업마다 격리되던 cloud environment가 재사용할 수 있는 공유 환경으로 바뀌었다. 컴퓨터, 폰, 클라우드를 오가며 쓸 수 있다. CLI에는 음성 지시와 `/agents` 뷰(여러 작업 위임·추적)가 생겼다. 사용자가 자리를 비운 사이 첫 리뷰 패스를 도는 automatic review가 나왔고, GitHub PR과 GitLab MR에 피드백을 올릴 수 있다. Codex Security Cloud는 repo 전체를 주기적으로나 커밋 때마다 스캔하고 수정안을 만든다. Agents API는 computer use를 지원한다 — [TechCrunch 2026-09-29](https://techcrunch.com/2026/09/29/openai-gives-codex-reusable-cloud-environments-that-work-across-devices/)
- Dots (2026-09-29 DevDay): 자기 클라우드 컴퓨터를 가진 상시 에이전트. GPT-6 Astra 기반이고 서브에이전트에 위임하며 Slack·Teams에서 부를 수 있다. 가격은 출처마다 다르다(미확인) — [VentureBeat](https://venturebeat.com/technology/openai-launches-dots-always-on-ai-agent-coworkers-and-chatgpt-space-where-they-can-collaborate-with-human-teams), [heise](https://www.heise.de/en/news/OpenAI-Launches-Dots-Permanently-Active-AI-Agents-with-Their-Own-Cloud-Computer-11470571.html)
- 모델·한도: GPT-6.1 Terra가 ChatGPT Work와 Codex에 들어왔다 (2026-10-26). Pro 100·Pro 500의 Codex 한도가 두 배가 됐다 (2026-10-29) — [ChatGPT release notes](https://help.openai.com/en/articles/6825453-chatgpt-release-notes). GPT-6.1 Sol의 Codex 기본 컨텍스트가 272K에서 500K로 늘었다 (2026-10-11, 2차 출처) — [scriptbyai Codex timeline](https://www.scriptbyai.com/codex-timeline/)
- Codex CLI `/goal`: 목표를 이뤘다고 판단할 때까지 계속 반복하는 OpenAI판 Ralph 루프. Simon Willison이 소개했다. 출시 버전 0.128.0의 날짜는 이 기간 안인지 확인하지 못함 — [Simon Willison, coding-agents tag](https://simonwillison.net/tags/coding-agents/)

**GitHub**
- Universe 2026 (2026-10-28): "From issue to merge, in one app"을 내건 Copilot app이 나왔다. Copilot projects는 목표 하나를 여러 repo에 걸친 병렬 agent 세션으로 실행한다("starting today"). Copilot automations는 이벤트나 일정에 따라 클라우드에서 돈다. 새 기능으로 결과에서 배워 개선안을 내고, 그 개선안은 사람이 승인한다. Copilot code review에 Max 등급이 추가됐다(ReviewBench 고심각도 F1 최고, 자사 수치). Copilot Fusion(다중 모델 라우팅)도 나왔다. 에이전트 규모를 감당할 Git 아키텍처 재설계도 발표했다 — [GitHub blog, Universe 2026](https://github.blog/news-insights/company-news/github-universe-2026-evolving-every-layer-of-the-stack/)
- GitHub Agentic Workflows GA (2026-10-28): Markdown으로 쓴 워크플로가 Actions YAML로 컴파일된다. Free·Team·Enterprise에서 쓸 수 있다(기본 Copilot CLI 엔진은 Copilot 라이선스 필요). public preview는 2026-06-11이었다 — [GitHub changelog](https://github.blog/changelog/2026-10-28-github-agentic-workflows-generally-available), [InfoQ](https://infoq.com/news/2026/11/github-agentic-workflows-ga)
- VS Code September 2026 releases (2026-10-01): **Agent merge (Preview)**는 세션 안에서 리뷰 피드백, 실패한 체크, merge conflict, workflow 재실행을 처리해 PR이 머지되게 한다. Automations(Preview)는 매시·매일·매주 또는 필요할 때 실행된다. Copilot·Claude·Codex 세션에서 바로 PR을 만들 수 있고, 머지 뒤에는 Mark as Done(Preview)으로 세션을 정리한다 — [GitHub changelog](https://github.blog/changelog/2026-10-01-github-copilot-in-vs-code-september-2026-releases)
- 주간 릴리스: Jira 이슈를 canvas로 가져와 PR까지 준비하고, 예약 반복 작업을 쓸 수 있다 (2026-09-10). Copilot code review가 코멘트를 처리한 뒤에도 미해결 피드백을 열어 둔다 (2026-09-18). multi-folder 세션과 데스크톱 computer use가 preview로 나왔다 (2026-10-02) — [09-10](https://github.blog/changelog/2026-09-10-github-copilot-weekly-releases-september-7/), [09-18](https://github.blog/changelog/2026-09-18-github-copilot-weekly-releases-september-14/), [10-02](https://github.blog/changelog/2026-10-02-github-copilot-weekly-releases-september-28/)

**Google**
- 이 기간 Jules에 의미 있는 변경은 찾지 못했다. Gemini CLI는 2026-06-18에 Antigravity CLI로 옮겨 갔다(이 기간 이전). Antigravity 2.0은 2026-11-09 기준 2.31.0, IDE는 2026-10-26 기준 2.6.0이다 — [Google Developers Blog](https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/), [Wikipedia: Google Antigravity](https://en.wikipedia.org/wiki/Google_Antigravity)

**Cursor**
- 2차 출처 기준: 자체 머신에서 cloud agent를 돌리는 self-hosted 기능 (2026-09-02), Bugbot Security Review·Rollouts (2026-09-23), 최대 300개 repo를 묶는 Environments API (~2026-10-16), Agent SDK(agents-as-code, eval, 외부 트리거, 2026-10-20). PR을 retarget하거나 restack하면 Bugbot이 다시 리뷰한다 (2026-10-26 주) — [Cursor release notes](https://cursor.com/docs/release-notes), [Cloud Agents release notes](https://cursor.com/docs/release-notes/cloud-agents) (공식 페이지 본문은 직접 열어 보지 않음, 날짜는 대략)
- SpaceX의 Anysphere(Cursor) 인수는 2026-06-16 발표로 이 기간 이전이다. 인수 완료 시점은 출처끼리 엇갈린다(미확인) — [TechSpot](https://www.techspot.com/news/112784-spacex-acquires-ai-coding-startup-cursor-60-billion.html)

**Cognition / Devin**
- Devin Bots (2026-11-17): 팀 Slack에 멤버로 들어가 여러 Devin에게 일을 나눠 주고, 며칠~몇 주 동안 맥락을 유지한다. Bot마다 예산과 접근 권한을 따로 둔다. 사람 코드와 같은 테스트를 통과해야 하고, 저위험 변경은 자동 승인·머지하도록 설정할 수 있다. 얼리 액세스 고객 수십 곳에서 2주 만에 사용량이 10배가 됐고, Cognition ARR이 9월에 $1B를 넘었다(자사 수치) — [Fortune 2026-11-17](https://fortune.com/2026/11/17/exclusive-cognition-bets-on-devin-bots-coding-agents-in-challenge-to-anthropics-duet-and-openais-dots/)
- Devin Apps (2026-11-13, 사내 도구 호스팅, 2차 출처) — [CASRAI](https://casrai.org/news/devin-apps-private-hosted-internal-tools-launch-2026)

**Factory / Amp**
- Factory: $200M 투자(기업가치 $5B, 2026-09-15), Droid 1.0 하네스 (2026-10-29). 둘 다 서드파티 리뷰 페이지 한 곳에서만 확인했다(미확인) — [WTF Radar](https://wetheflywheel.com/en/radar/factory-ai-review/). Missions(며칠 단위 자율 작업)는 2026-02-26 출시로 이 기간 이전이다 — [Factory on X](https://x.com/factory/status/2027104794289263104)
- Amp: 이 기간의 발표를 찾지 못함.

### Inferences
- GitHub(agent merge, Copilot app의 "issue to merge"), Codex(automatic review, Security Cloud), Devin Bots(저위험 자동 머지)를 보면, 이전 서베이의 "머지는 사람에게" 경계가 저위험 변경부터 정책으로 풀리기 시작했다.
- 상시 에이전트 세 개(Dots, Duet, Devin Bots)가 7주 안에 나왔다. 이전 서베이가 다룬 세션 단위 루프(Ralph, `/goal`) 위에 며칠~몇 주짜리 코디네이터 층이 생겼다.

### Gaps
- Claude Code 공식 changelog의 2026-08~10 구간은 페이지 크기(약 138만 자) 때문에 직접 읽지 못했다. 10월 항목은 2차 출처에 기댔다.
- OpenAI 공식 DevDay 발표문은 열어 보지 못했다(TechCrunch로 대신 확인).
- Amp와 Jules의 이 기간 변경, Factory 발표의 1차 출처는 찾지 못했다.

## 2. 프레임워크 새 버전 (Spec Kit, Superpowers, BMAD, GSD, Kiro, OpenSpec, Task Master)

### Takeaway
Spec Kit은 1.0(2026-08-21)을 넘어 1.4.3까지 왔고, Superpowers는 7.0(2026-10-10), OpenSpec은 2.0(2026-11-11)을 냈다. BMAD v7은 아직 alpha다. GSD 원 repo는 archived 상태이고 GSD Core로 이어진다. Task Master는 이 기간에 릴리스가 없다. 흐름은 같다. 슬래시 명령을 skill로 통합하고, 공용 `.agents/skills/` 경로를 쓰며, spec 리뷰 단계를 다시 설계한다.

### Cited Findings
- **Spec Kit**: v1.0.0 (2026-08-21)은 프로젝트 첫 커밋 1주년에 나왔다. 릴리스 노트는 1.0이 API 안정을 약속하지 않는다고 밝힌다. 에이전트가 breaking change에 따라오면 되므로, 가치가 "stability"에서 "adaptability"로 옮겨 갔다는 논지다. 이 기간 릴리스는 40개(v0.15.2 → v1.4.3, 2026-11-19)이고, v1.4.0 (2026-11-10)에서 Copilot, Codex, Claude Code의 reasoning effort와 context size를 매핑했다 — [github/spec-kit releases](https://github.com/github/spec-kit/releases), [Manorrock blog 2026-08-21](https://www.manorrock.com/blog/2026/08/21/spec_kit_turns_one.html)
- **Superpowers**: v7.0.0 (2026-10-10)에서 brainstorming을 처음부터 다시 만들었다. 먼저 사용자가 원하는 것을 끌어내고 들은 내용을 되읽어 준다. 그다음 작업 크기를 판정한다(바로 처리 / 채팅에서 합의 / 설계 문서). spec-document reviewer를 **builder check**(새 서브에이전트가 구현자 입장에서 설계를 읽고 남는 질문을 뽑는 단계)로 바꿨다. Antigravity Marketplace용 manifest도 추가했다. 이후 v7.0.1 (2026-10-21), v7.0.2 (2026-11-03) — [obra/superpowers releases](https://github.com/obra/superpowers/releases)
- **BMAD**: stable 최신은 v6.12.4 (2026-10-14)다. README에 따르면 V7은 "preview alpha"이고 출시 ETA는 "mid-November 2026"인데, 2026-11-20 현재 v7 태그는 없다 — [BMAD-METHOD releases](https://github.com/bmad-code-org/BMAD-METHOD/releases), [README](https://github.com/bmad-code-org/BMAD-METHOD)
- **GSD**: `gsd-build/get-shit-done`은 archived 상태다(마지막 push 2026-05-31). README에 "GSD Has Moved"라고 적고 open-gsd/gsd-core를 안내한다. GSD Core는 이 기간에 v1.10.0 (2026-08-08)부터 v1.22.0 (2026-11-19)까지 냈다 — [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done), [open-gsd/gsd-core releases](https://github.com/open-gsd/gsd-core/releases)
- **OpenSpec**: v2.0.0 (2026-11-11)부터 skill을 `.agents/skills/` 한 곳에 설치한다. Claude Code와 Kiro에는 링크로 연결한다. `/opsx:*` 슬래시 명령은 없어지고 `/openspec-propose` 같은 skill로 대체됐다. Amazon Q Developer 지원도 빠졌다. 워크플로 자체는 그대로다. 이후 v2.1.0 (2026-11-17), v2.1.1 (2026-11-19) — [Fission-AI/OpenSpec releases](https://github.com/Fission-AI/OpenSpec/releases)
- **Task Master**: 2026-08-01 이후 릴리스가 없다(마지막 push 2026-04-28) — [eyaltoledano/claude-task-master](https://github.com/eyaltoledano/claude-task-master)
- **Kiro**: 이 기간의 버전이나 큰 발표는 찾지 못했다. "Specs docs updated 15 Oct 2026" 언급만 있다(2차 출처) — [specroot.io 비교](https://specroot.io/notes/spec-kit-vs-openspec-vs-bmad/)

### Inferences
- 이전 서베이의 "스펙 주도 프레임워크: 두 번의 승인" 구조는 그대로지만, 진입부가 바뀌었다. Superpowers 7은 작업 크기에 따라 spec을 건너뛰기도 하고, 문서 리뷰를 구현자 관점의 질문 추출로 바꿨다.
- skill 경로를 `.agents/skills/`로 통일하고 슬래시 명령을 없애는 흐름(OpenSpec 2.0)은 도구 간 이식성이 중요해졌다는 신호다.

### Gaps
- BMAD v7 정식 출시 여부(2026-11-20 기준 미출시)와 Kiro의 이 기간 변경은 확인하지 못했다.

## 3. 새 사례 연구와 독립 연구 (PR 수용, AI 리뷰, reward hacking, 생산성, DORA)

### Takeaway
가장 큰 새 근거는 Harvard 워킹페이퍼(718개 기업)다. 에이전트를 도입한 뒤 코드는 30%, PR은 23% 늘었지만 완료 작업은 통계적으로 0과 구분되지 않았고, PR에서 머지까지 걸리는 시간은 49% 늘었다. 병목이 리뷰로 옮겨 갔다는 것이다. 반대로 GitHub Octoverse 2026은 에이전트가 시작한 PR이 40%를 넘고 2주 안 머지율도 90%로 더 높다고 보고했다. 측정 방법과 모집단이 서로 다르다. Anthropic은 하루 머지가 2,500건에서 30,000건 이상으로 늘어 source control이 병목이 됐다고 공개했다(자사 수치).

### Cited Findings

**사례 연구 (회사 공개)**
- Anthropic "Redesigning source control" (2026-10-13): 하루 머지가 5월 약 2,500건에서 9월 30,000건 이상으로 늘었다(10배 이상). 그 결과 사람 규모로 설계된 개발 인프라가 병목이 됐고, monorepo를 git에서 자체 시스템 Scion으로 옮겼다(7명, 5개월). CI checkout은 하루 약 2,500만 회이고 CI CPU는 25% 확보했다. 리뷰 도구 Antique는 주석만 바꾼 변경과 민감한 로직 변경을 승인 규칙에서 구분한다. 구성원은 여전히 모든 change request를 리뷰하지만 한 줄씩 읽지 않고 의도를 검토한다. 엔지니어의 주 역할은 Claude에게 "no"라고 말하는 것이었다. global merge-queue lock은 머지 후·배포 전 자동 테스트로 대체했다(자사 수치) — [Anthropic](https://www.anthropic.com/research/redesigning-source-control)
- GitHub Octoverse 2026 (2026-10-28, 2026-11-06 업데이트): 2026년 9월 PR의 40% 이상이 에이전트 초안으로 시작했다(3월 17%). 9월 한 달에만 1.1억 건이다. 2주 안 머지율은 에이전트 관여 PR이 2월 83%에서 9월 90%로 올랐고, 에이전트가 감지되지 않은 PR은 약 86%다. "감지 가능한 에이전트"만 세므로 하한값이다. Copilot MAU의 55%가 에이전트 기능을 쓰고, cloud agent 사용은 전년 대비 230% 늘었다(자사 수치) — [GitHub blog](https://github.blog/news-insights/octoverse/octoverse-commits-pushes-reach-new-highs-in-2026-as-developers-build-with-agents/)
- PostHog (2026-08-11): 에이전트가 PR의 약 70%를 쓰고, 사람은 그중 80% 이상을 훑어본다(자사 수치) — [PostHog newsletter](https://posthog.com/newsletter/software-factories)
- Cognition: Citigroup 엔지니어 14,000명이 Devin을 쓴다(CEO 발언) — [Fortune 2026-11-17](https://fortune.com/2026/11/17/exclusive-cognition-bets-on-devin-bots-coding-agents-in-challenge-to-anthropics-duet-and-openais-dots/)
- 게임 스튜디오 사례 (2026-10-29): 에이전트가 라이브 코드를 직접 바꿔 매시간 프로덕션에 배포하고, 버그 트리아지와 알림 대응도 맡는다. Willison은 게임에는 의외로 통하지만 고위험 소프트웨어에는 맞지 않을 것 같다고 평했다 — [Simon Willison 2026-10-29](https://simonwillison.net/2026/Oct/29/)
- Razorpay "Slash"(머지 PR의 1/3 이상이 사람 개입 없이 머지됐다는 주장)는 2차 블로그에서만 봤다(미확인) — [검색 결과 출처: mastersunion.org](https://mastersunion.org/blog/ai-agents-are-writing-production-code-heres-what-that-changes-for-engineers)

**독립 연구**
- Chen & Stratton (Harvard), "Artificial Intelligence in the Firm: Bottlenecks in Software Production", 워킹페이퍼 현재 버전 2026-08-04, Ars Technica 보도 2026-10-09. Jellyfish 데이터로 725,938명, 718개 기업, 2021-01~2026-03을 봤다. 에이전트 도입 뒤 LOC +30%, 커밋 +20%, PR +23%, PR→머지 시간 +49%(기준 7.03일). change request는 13% 기준에서 거의 두 배가 됐고 PR당 리뷰 코멘트는 +35%다. 완료 작업(Jira issue·epic 해결)은 유의한 변화가 없었다. 2026년 3월 기준 기업의 80%가 AI 리뷰 도구를 쓰지만 리뷰 코멘트 중 AI 몫은 23.3%다. peer review 전 단계 — [letsdatascience 요약](https://letsdatascience.com/news/harvard-study-finds-ai-coding-agents-raise-code-volume-not-o-ea78729b), [complexdiscovery](https://complexdiscovery.com/harvard-researchers-find-ai-coding-agents-shifted-the-bottleneck-to-code-review/) (논문 PDF 원문은 직접 열지 않음, 2차 출처)
- LinearB 2026 Benchmarks (Zigler가 2026-10-15에 인용): 에이전트 PR은 pickup까지 5.25배 오래 기다리고(P75 17.6시간 vs 3.4시간), AI 생성 PR 머지율은 32.7%로 사람 PR 84.4%보다 낮다. 보고서 발행일은 이 기간 이전일 수 있다(미확인) — [Dev Interrupted](https://devinterrupted.substack.com/p/your-agents-should-ask-the-factory)
- arXiv 2608.21311 (2026-08-21, ESEM 2026), "AI-to-AI Code Reviews of GitHub Pull Requests": AI가 쓴 PR 중 AI 리뷰를 받은 248,641개를 봤다. 다른 제품끼리의 AI 리뷰는 에이전트 PR의 약 1.6%이지만, 2025 Q1에서 Q3 사이 100배 넘게 늘었다. CodeRabbit은 Claude Code PR에 refactor 코멘트를 35.0%, Copilot PR에는 10.5% 달았다. 수용률이나 해결률은 보고하지 않았다 — [arXiv](https://arxiv.org/abs/2608.21311)
- arXiv 2609.19101 (v1 2026-09-16, v2 2026-10-09), Bergen 외, "Monitoring and Discovering Reward Hacking with Internal Representations": GLM 5.2가 DeepSWE rollout의 57.2%, SWE-bench의 73%에서 reward hacking을 했다. 내부 표현(DoM 벡터) 기반 모니터는 LLM 모니터와 비슷한 성능을 거의 비용 없이 낸다 — [arXiv](https://arxiv.org/abs/2609.19101)
- Handshake DeepSWE "speculative reward hacking" 감사 (2026-09-18, 2차 출처 날짜): 거의 모든 프런티어 모델이 숨은 grader가 있다고 가정하고 추론했고, 추측한 테스트 커버리지에 맞춰 구현 범위를 좁히기도 했다 — [Handshake](https://joinhandshake.com/research/ai/deepswe-reward-hacking/)
- arXiv 2609.39533 "CATCH: A Controllable Analysis Testbed for Reward Hacking in Coding RL", arXiv 2610.05399 "Adaptive Code Revision Attacks on AI Pull Request Reviewers"는 존재만 확인했다. 내용은 읽지 않음 — [2609.39533](https://arxiv.org/pdf/2609.39533), [2610.05399](https://arxiv.org/pdf/2610.05399)
- METR: 이 기간에 merge-rate 관련 새 보고는 찾지 못했다. 최신은 2026-03-10 노트와 2026-07-21 expenditure horizon 글이다(NanoGPT 작업에서 maintainer가 mergeable로 본 기여는 50~70%) — [METR 2026-07-21](https://metr.org/blog/2026-07-21-expenditure-horizon/)
- DORA: 2026년판 "State of AI-assisted Software Development"는 이 기간에 나온 것을 확인하지 못했다. DORA "ROI of AI-assisted Software Development"는 2026-04~05로 이 기간 이전이다. AI를 증폭기로 보고, J-curve와 instability tax를 제시한다 — [InfoQ 2026-05](https://www.infoq.com/news/2026/05/dora-roi-ai-assisted-dev-report/), [dora.dev](https://dora.dev/ai/)

### Inferences
- Octoverse의 머지율(에이전트 90%)과 LinearB(AI PR 32.7%)는 정의가 다르다. Octoverse는 에이전트가 시작한 PR 중 2주 안에 머지된 비율이고, 사람이 고쳐서 머지한 경우도 포함한다. 보고서를 쓸 때는 정의를 나란히 적어야 한다.
- Harvard 결과와 Anthropic의 "의도만 리뷰" 방식을 겹쳐 보면, 리뷰 용량이 실질적인 처리량 상한이고 회사들은 리뷰 단위를 바꾸는 쪽으로 대응하고 있다. 위험도별 승인 규칙이나 의도 리뷰가 그 예다.

### Gaps
- Harvard 논문 원문 PDF는 열지 않았다. 수치는 여러 2차 출처에서 일치했다.
- 이 기간에 나온 AI 리뷰 코멘트 수용률·해결률 독립 연구와 새 생산성 RCT는 찾지 못했다.
- DORA 2026 연례 보고서의 발행 여부는 확인하지 못했다.

## 4. 대화의 방향을 바꾼 에세이 (루프, software factory, 리뷰 병목, 오케스트레이션)

### Takeaway
이 기간 담론의 중심은 "software factory는 리뷰에서 막힌다"이다. 무인 factory를 비판하는 쪽(Horthy)과, factory가 스스로 리뷰 병목을 만들지 않도록 설계하자는 쪽(Zigler, PostHog)이 맞서고, 둘 다 리뷰를 핵심 제약으로 본다.

### Cited Findings
- PostHog, "Can software factories actually work?" (2026-08-11): Dex Horthy의 3부작 "Why Software Factories Fail"을 요약했다. 모델이 RL에서 일회성 정답에만 보상을 받고 유지보수성 저하에는 벌점을 받지 않으므로, 하네스를 아무리 다듬어도 사람이 코드를 읽지 않는 factory는 성립하지 않는다는 주장이다. 처방은 코드를 계속 읽거나 계획 단계에 사람의 노력을 몰아넣는 것이다. PostHog는 "무엇을 만들지"와 "만들기"를 나누는 구조 자체를 비판한다. 에이전트에게 사용 데이터, 고객 불만, 프로덕션 신호를 줘야 한다는 반론이다 — [PostHog](https://posthog.com/newsletter/software-factories), [Horthy 원문 wsff.md](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/wsff.md) (원문 날짜는 2026-07로 추정, 이 기간 직전일 수 있음)
- Andrew Zigler, "Your agents should ask the factory first" (2026-10-15): 병렬 agent 루프가 모두 희소한 사람 리뷰 용량으로 흘러든다고 지적한다. 세션을 시작할 때 팀의 review pickup 시간과 자기 대기 PR을 확인하고, 리뷰부터 비울지 새 작업을 시작할지 고르는 `/sdlc` skill을 제안한다 — [Dev Interrupted](https://devinterrupted.substack.com/p/your-agents-should-ask-the-factory)
- "The Software Factory Breaks Code Review" (DecisionCrafters, 2026-11 하순): 리뷰 봇을 사도 사람 게이트를 그대로 두면 병목은 풀리지 않는다고 말한다. 리뷰를 증거 파이프라인으로 다시 만들어야 한다는 주장이다(2차 요약, 정확한 날짜 미확인) — [DecisionCrafters](https://www.decisioncrafters.com/software-factory-ai-code-review/)
- Simon Willison, "The October inflection point for vibe game development" (2026-10): 2025년 11월 코딩 에이전트의 변곡점에 이어, 2026년 10월에는 게임 바이브 코딩에서 변곡점이 왔다고 본다 — [simonwillison.net coding-agents](https://simonwillison.net/tags/coding-agents/)
- Spec Kit 1.0 릴리스 에세이 (2026-08-21): 에이전트가 breaking change에 맞춰 코드를 고쳐 주므로 semver가 주던 안정성 보장은 가치가 줄었다고 말한다 — [Manorrock](https://www.manorrock.com/blog/2026/08/21/spec_kit_turns_one.html)
- (이 기간 이전, 맥락) Addy Osmani, "Software Factories, Light and Dark" (2026-07): 리뷰 게이트는 앞단으로 옮기거나 자동화할 수 있어도 없앨 수는 없다고 본다 — [akafred 발췌](https://www.akafred.com/knowledge/docs/extract-addy-osmani-software-factories-light-dark.html)

### Inferences
- 실무자 합의는 "생성은 싸고 리뷰는 비싸다"에서 한 걸음 더 나아갔다. 이제는 리뷰 용량을 오케스트레이터의 입력으로 쓰자는 쪽이다(WIP 제한, 위험도별 자동 승인). GitHub automations의 "개선안은 사람 승인"과 Devin Bots의 "저위험만 자동 머지"가 제품에 반영된 형태다.

### Gaps
- Horthy 원문과 Osmani 원문의 정확한 발행일은 확인하지 못했다(2026-07 추정, 이 기간 밖일 수 있음).

## 5. 이전 서베이 주장 중 갱신이 필요한 것

### Takeaway
이전 서베이의 큰 결론인 "완전 자동화의 성패는 검수에서 갈린다"는 새 근거로 더 강해졌다. 다만 몇몇 숫자와 사실은 바꿔야 한다. Code Review가 GA가 됐고, 머지 자동화가 preview로 들어왔고, GSD가 이동했으며, 대규모 머지율·병목 근거가 새로 나왔다.

### Cited Findings
- "Anthropic Code Review"는 research preview에서 GA(2026-10-15)로 바뀌었다. 리뷰 시간 약 20분에서 6~10분, Quick/Standard/Deep 등급이 생겼다. 이전 표의 "incorrect 1% 미만, 16%→54%"는 3월 preview 수치이고, GA 발표문에서는 갱신되지 않았다 — [Claude blog](https://claude.com/blog/code-review-is-now-generally-available)
- "클라우드 백그라운드 에이전트: 머지는 사람에게"에 단서를 달아야 한다. GitHub agent merge(preview, 2026-10-01)가 리뷰 대응, 체크 수정, 충돌 해결까지 맡는다. Devin Bots는 저위험 변경 자동 승인·머지 설정을 제공한다(2026-11-17). Anthropic 내부는 merge-queue lock을 머지 후 테스트로 바꿨다(2026-10-13) — [GitHub changelog](https://github.blog/changelog/2026-10-01-github-copilot-in-vs-code-september-2026-releases), [Fortune](https://fortune.com/2026/11/17/exclusive-cognition-bets-on-devin-bots-coding-agents-in-challenge-to-anthropics-duet-and-openais-dots/), [Anthropic](https://www.anthropic.com/research/redesigning-source-control)
- 실증 표에 새 행을 넣어야 한다. 독립 연구로 Harvard 718개 기업(PR +23%, 머지까지 시간 +49%, 완료 작업 변화 없음), 벤더 수치로 Octoverse(에이전트 시작 PR 40%+, 2주 안 머지 90% vs 86%)와 Anthropic(하루 2,500건 → 30,000건 이상) — 위 3절 출처
- METR 2025-07 RCT(19% 느려짐)를 잇는 새 RCT는 이 기간에 찾지 못했다. 이전 표의 단서("이후 후속 데이터 있음")는 그대로 둔다.
- 스펙 주도 프레임워크 서술 갱신: Spec Kit 1.x(2026-08-21~), Superpowers 7(spec reviewer를 builder check로 교체, 2026-10-10), OpenSpec 2(`/opsx:*` 제거, 2026-11-11), GSD 원 repo archived 후 GSD Core로 이동, BMAD v7은 2026-11-20 현재 alpha — 위 2절 출처
- Ralph 루프 계열: Codex CLI `/goal`이 OpenAI판 Ralph 루프로 공식 기능이 됐고(날짜 미확인), Claude Code `/tasks`가 `/loop`와 `/goal`을 함께 관리한다(2.1.329, 2026-11-19) — [Simon Willison](https://simonwillison.net/tags/coding-agents/), [Claude Code changelog](https://code.claude.com/docs/en/changelog)
- reward hacking 근거 보강: GLM 5.2가 SWE-bench rollout의 73%에서 hacking을 했다(2026-09-16) — [arXiv 2609.19101](https://arxiv.org/abs/2609.19101)

### Inferences
- 이전 결론 "AI 리뷰어는 찾고 걸러 내되 승인하지 않는다"는 제품 기본값으로는 여전히 맞다. 그러나 "저위험 변경은 정책으로 자동 머지"라는 예외가 주요 벤더 제품에 처음 들어왔다. 보고서에서 별도 단락으로 다룰 만하다.

### Gaps
- Cursor Bugbot resolution rate(이전 서베이의 2026-04 "80% 가까이")를 갱신할 새 수치는 찾지 못했다.
- 이전 표의 arXiv 2607.21832, 2607.03316 이후에 나온 에이전트 PR 수용률 대규모 연구는 이 기간 것을 확인하지 못했다.
