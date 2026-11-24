# 검증: recurring_agents.md / escalation_and_multiagent_evidence.md

검증일 2026-11-20. 두 노트에서 보고서가 가장 많이 기댈 주장을 골라 인용된 공개 URL을 직접 열어 대조했다.

- "확인"은 이번 작업에서 해당 페이지를 열어 그 내용을 본 경우에만 붙였다. 검색 스니펫만 본 수치는 "확인 불가"다.
- 페이지는 WebFetch로 열었다(페이지 본문을 읽고 요청한 문장을 뽑아 주는 방식). 인용문은 그 결과에 나온 문구다.
- 403으로 막힌 페이지(The New Stack, Axios, DevOps.com)는 우회하지 않았고, 같은 사실을 다른 공개 출처에서 찾거나 "확인 불가"로 두었다.
- 파일 약칭: R = recurring_agents.md, E = escalation_and_multiagent_evidence.md

## 검증 표

| # | 주장(요약) | 파일 | 판정 | 출처가 실제로 말하는 것(다를 때) | 확인한 URL |
|---|---|---|---|---|---|
| 1 | gh-aw 기술 프리뷰, 2026-02-13, Don Syme(GitHub Next)·Peli de Halleux(MSR), "augment existing CI/CD rather than replace it" | R | 확인 | | https://github.blog/news-insights/product-news/automate-repository-tasks-with-github-agentic-workflows/ |
| 2 | `.md` + frontmatter, `gh aw compile` → `.lock.yml`, 엔진은 Copilot CLI·Claude Code·OpenAI Codex, `schedule: daily` 예시 | R | 확인 | | 위와 같음 |
| 3 | 기본 read-only, 쓰기는 safe outputs, "pull requests are never merged automatically" | R | 확인 | | 위와 같음 |
| 4 | 실행당 premium request 2개(에이전트 작업 1 + safe outputs 가드레일 검사 1) | R | 확인 | 원문은 "typically incurs two premium requests" | 위와 같음 |
| 5 | Daily repo status 샘플: `[repo status]` 접두어, `report` 라벨, 2026-02-09 샘플에 커밋 1,737, 이슈 100 닫힘/190 열림, PR 93 중 50 병합 | R | 확인 | 수치는 본문이 아니라 스크린샷 alt 텍스트에 있다. 샘플 제목은 "Daily Repo Report - February 9, 2026" | 위와 같음 |
| 6 | 에이전트는 쓰기 권한이 없고 "separate permission-controlled job"이 요청을 실행 | R | 확인 | | https://github.github.com/gh-aw/reference/safe-outputs/ |
| 7 | `create-issue`: 기본 `max: 1`, `expires`(7d, 2w), `group`(하위 이슈 최대 64), `close-older-issues`(최대 10개를 "not planned"로 닫고 새 이슈 링크, 새 이슈 생성 성공 후에만), `group-by-day`(UTC, max 슬롯 미사용), `deduplicate-by-title`(true 또는 0~100 Levenshtein), `deduplicate-by-labels`와 AND | R | 확인 | 추가로 중복 검사는 열린 이슈와 최근 30일 내 닫힌 이슈를 본다 | 위와 같음 |
| 8 | `expires`가 `agentics-maintenance.yml`을 자동 생성, 2시간~매일 주기 | R | 확인 | 만료 1일 이하: 2시간마다, 2일: 6시간, 3~4일: 12시간, 5일 이상: 매일 | 위와 같음 |
| 9 | `add-comment`의 `hide-older-comments`/`replace-older-comments`, `add-labels`의 `allowed`/`blocked`(blocked 먼저)·`create-if-missing: false`, `close-issue`의 `required-labels`/`required-title-prefix` | R | 확인 | `replace-older-comments`는 `hide-older-comments`와 함께 쓸 수 없다 | 위와 같음 |
| 10 | `noop`, `report-missing-tool`, `report-missing-data`는 항상 사용 가능. staged 모드는 부작용 없이 미리보기 | R | 확인 | `noop`의 `max` 기본값은 2. staged에서도 필터 검증용 읽기는 수행되고 쓰기만 건너뛴다 | 위와 같음 (offset 100000 구간 포함) |
| 11 | agentics 예약 샘플 목록(Daily Repo Status ~ Weekly Repository Map), Issue Monster는 `cookie` 라벨 이슈를 30분마다 Copilot에 배정 | R | 확인 | 노트에 나열한 25개 모두 README에 있음 | https://github.com/githubnext/agentics |
| 12 | 백로그 샘플 인용문: Issue Triage "labels issues and PRs and not much more", Repo Assist "multi-task backlog burner", 분석 전용 워크플로 보고서는 `/plan`으로 이슈가 된다 | R | 수정 필요 | Issue Triage 원문은 "Triage labelling of issues and pull requests and not much more". Repo Assist는 README에서 "A regular, pervasive all-tools repository assistant that triages issues…"로 시작하며 "multi-task backlog burner" 문구는 보지 못했다. `/plan`은 README에 "Plan Command"로 실려 있다. "보고서가 `/plan`으로 이슈가 된다"는 문장은 README에서 확인하지 못했다 | 위와 같음 |
| 13 | Multi-phase improvers(2026-01-13): Daily Perf Improver 3단계, Daily Backlog Burner 하루 1이슈, "maintain state across days using repo-memory" | R | 확인 | | https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-multi-phase/ |
| 14 | Peli's Agent Factory(2026-01-12): "over 100" 워크플로, 교훈 목록, "No one can read all these outputs (except, of course, another workflow)", "Longer analyses aren't always better" | R | 확인 | | https://github.github.com/gh-aw/blog/2026-01-12-welcome-to-pelis-agent-factory/ |
| 15 | Repository Quality Improver 59 discussions → 30 issues → 40 PR, 25 병합(62%), 약 20분, 60/30/10. Typist 57→22→25, 19 병합(76%). Go Module Usage Expert 58/74(78%). Functional Pragmatist 화·목 아침, 2/2 | R | 확인 | 60%는 원문에서 "custom areas" | https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-continuous-improvement/ |
| 16 | Changeset Generator 22/28(78%), CLI Consistency Checker 80/102(78%), CI Doctor 9/13(69%), CI Coach 9/9 | R | 확인 | 수치는 맞다. 노트가 인용한 블로그 인덱스 페이지에는 없고 개별 글에 있다(오른쪽 URL) | https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-operations-release/ , https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-testing-validation/ , https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-quality-hygiene/ |
| 17 | Discussion Task Miner 60/105(57%) | R | 확인 | agentics 문서에 "57% merge rate (60 merged PRs out of 105 proposed through a discussion → issue → PR causal chain)". 매일 실행, 실행당 이슈 최대 5개 | https://raw.githubusercontent.com/githubnext/agentics/main/docs/discussion-task-miner.md |
| 18 | Plan Command 514/761(67%) | R | 확인 불가 | 검색 스니펫에만 나온다. 블로그 인덱스, issue-management 글, interactive-chatops 글, agentics docs/plan.md(이건 Daily Plan 문서)에서 찾지 못했다 | https://github.github.com/gh-aw/blog/ 외 |
| 19 | Issue Arborist 77 discussion reports, 18 parent issues. Issue Monster는 "one at a time" 배정 | R | 확인 | | https://github.github.com/gh-aw/blog/2026-01-13-meet-the-workflows-issue-management/ |
| 20 | hyrax.dev: GitHub 리팩터링 에이전트 PR의 79%를 사람이 병합 | R | 확인 불가 | 페이지를 열면 제목과 태그라인만 나오고 본문을 읽을 수 없다 | https://hyrax.dev/blog/github-agents-refactor-code-humans-merged-79-percent |
| 21 | 병합률 범위 "roughly 50 to 78%"(Takeaway), "about 57–78%", 미병합 22~43% | R | 수정 필요 | 확인된 워크플로별 값의 최저는 57%, 최고는 100%(CI Coach 9/9, Functional Pragmatist 2/2, Multi-Device Docs Tester 2/2)다. "50%"를 받치는 수치는 없다. 57~78%는 표본이 큰 워크플로만 고른 범위라고 밝혀야 한다 | #15~#17 URL |
| 22a | Honk로 병합된 AI 생성 PR 1,500건 이상(2025-11) | R | 확인 | "more than 1,500 pull requests…merged". 게시일 2025-11-06 | https://engineering.atspotify.com/2025/11/spotifys-background-coding-agent-part-1 |
| 22b | Fleet Management를 2022년부터 구축 | R | 수정 필요 | 인용한 글에 2022년이 없다. 글이 말하는 것은 "Since mid-2024, around half of Spotify's pull requests have been automated by this system"과 AI 에이전트 검토를 "Last February" 시작했다는 것이다. InfoQ 글에도 시작 연도가 없다 | 위와 같음 |
| 23 | Fleetshift(대상 선정·일정·추적) / Honk(Agent SDK, Kubernetes pod), 자동 유지보수 PR 250만 건 이상(대부분 안전 검사 후 자동 병합), 월 병합 약 8,100 → 17,000(8월 기준 전년 대비), 프로덕션 서비스 약 3,000개 | R | 확인 | "more than 2.5 million", "nearly 3,000 production services" | https://www.infoq.com/news/2026/10/spotify-ai-quality-controls |
| 24 | 6월 24일 사고: 변경량이 "outpaced some verification controls", AI 작성 코드의 직접 기여는 미미, 대응으로 담당 팀 근무 시간에 자동 변경 예약, 품질·최적화 비중 27% → 31%, 재작업 증가 없음 | R | 확인 | 본문은 연도 없이 "June 24"(연결된 사고 보고서 URL이 2026). 유지보수·설정 비중은 31% → 25% | 위와 같음 |
| 25 | Stripe Minions(2026-02-09): "over a thousand pull requests merged each week", Slack에서 시작, flaky test 티켓의 버튼, 사람 리뷰, CI "often one, at most two", 예약 실행 언급 없음 | R | 확인 | | https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents |
| 26 | 2차 글은 주당 약 1,300 PR로 인용 | R | 확인 | ByteByteGo 2026-03-16, "over 1,300 pull requests" | https://blog.bytebytego.com/p/how-stripes-minions-ship-1300-prs |
| 27 | Google 마이그레이션 논문: 39개 마이그레이션, 595개 코드 변경, 74.45% LLM 생성, 약 50% 시간 절감 | R | 확인 | 3명의 개발자, 12개월. 편집 단위로는 69.46%. arXiv 페이지에 학회명은 없고 DOI 10.1145/3696630.3728542만 있다 | https://arxiv.org/abs/2504.09691 |
| 28 | GitHub(2026-04-07): Dependabot 알림을 Copilot·Claude·Codex에 배정, draft PR, 빌드·테스트 실패 분석, 같은 알림에 여러 에이전트, Code Security + coding agent 필요 | R | 확인 | | https://github.blog/changelog/2026-04-07-dependabot-alerts-are-now-assignable-to-ai-agents-for-remediation |
| 29 | Cursor Automations(2026-03-05): 트리거 목록, memory tool, 아침 테스트 커버리지 에이전트, 주간 Slack 다이제스트, 버그 트리아지, main push 보안 리뷰("skips issues already discussed in the PR"), Rippling 2시간 cron + 중복 제거, agentic codeowners(저위험 자동 승인, 최대 2명 리뷰어, 로그) | R | 확인 | Rippling 예시는 개인 비서용 대시보드다. codeowners 결정은 Slack 요약 + Notion DB 기록 | https://cursor.com/blog/automations |
| 30 | Langfuse(2026-03-13): 지원 티켓 481, GitHub 이슈 열림 53·최근 닫힘 14, 회의록 38, LLM-as-judge 3개 점수, 9회 반복·회당 약 10분, 출처 표기 1.0, 범주 3~5개 | R | 확인 | 출처 표기 1.0은 본문은 "After run 4", 표는 run 5부터다 | https://langfuse.com/blog/2026-03-13-weekly-digest-ai-skill |
| 31 | Langfuse 실패 모드: 소스 장애 시 말없이 건너뜀, 일반 링크, 6개월 된 이슈를 현재 버그로 표시, "Quick Fixes" 라벨, run 7 회귀 | R | 확인 | run 7에서 actionability 0.05, categories 0 | 위와 같음 |
| 32 | Linear Triage Intelligence: Business/Enterprise, "agentic models", 팀·프로젝트·담당자·라벨·중복/관련 제안, 속성별 표시/숨김/자동 적용, 하위 팀 상속, 가장 가까운 지침 우선, 지침은 사후에 추가, 이슈당 1~4분 | R | 확인 | | https://linear.app/docs/triage-intelligence |
| 33 | curl: 2026년 첫 21일간 AI 생성 보안 리포트 20건, 유효 0건, 6년 된 버그 바운티 종료 | R | 수정 필요 | BleepingComputer(2026-01-22)가 옮긴 Stenberg 발언은 "we now count twenty submissions done already in 2026"이고, "none of them identified a vulnerability"는 한 주에 들어온 7건에 대한 말이다. "21일", "20건 모두 AI 생성", "20건 모두 무효"는 확인한 페이지에 없다. 바운티는 2019년 4월 시작, 2026-01-31 종료(Stenberg 블로그). InfoQ(2026-02-24)는 "six-year bug bounty", "by 2025, 20% of submissions were AI-generated", 유효율 5%로 적는다 | https://www.bleepingcomputer.com/news/security/curl-ending-bug-bounty-program-after-flood-of-ai-slop-reports/ , https://daniel.haxx.se/blog/2026/01/26/the-end-of-the-curl-bug-bounty/ , https://www.infoq.com/news/2026/02/ai-floods-close-projects/ |
| 34 | Jazzband가 AI 스팸 PR·이슈를 이유로 종료 | R | 확인 | 1차 출처(2026-03-14): "Jazzband is sunsetting", "the flood of AI-generated spam PRs and issues … has made Jazzband's model of open membership and shared push access untenable". 즉시 폐쇄가 아니라 단계적 정리다. 노트가 인용한 InfoQ 글에는 Jazzband가 없다 | https://jazzband.co/news/2026/03/14/sunsetting-jazzband |
| 35 | Airflow 커미터: 실제 사용자 이슈가 스팸으로 잘못 닫힘 | R | 확인 불가 | The New Stack과 Axios는 403. InfoQ 글에는 Airflow 일화가 없다. 검색 스니펫으로는 2025년 2월 The New Stack 기사(Jarek Potiuk, 2~3건을 다시 열었다)에서 온 이야기로 보여, 2026년 사례로 쓰면 날짜가 틀릴 가능성이 있다 | https://thenewstack.io/ai-generated-code-crisis/ (403), https://www.axios.com/2026/03/10/ai-agents-spam-the-volunteers-securing-open-source-software (403) |
| 36 | Continuous AI는 단일 도구가 아닌 범주이고, 완전 자율이 아니라 사람의 감독·통제를 둔다 | R | 확인 | "an open-ended set of activities, workloads, examples, recipes, technologies and capabilities; a category, rather than any single tool", "Often these workflows are not fully autonomous…" | https://githubnext.com/projects/continuous-ai/ |
| 37 | 에이전트는 채팅 대비 토큰 약 4배, 멀티에이전트는 약 15배 | E | 확인 | 게시일 2025-06-13 | https://www.anthropic.com/engineering/multi-agent-research-system |
| 38 | 토큰 사용량이 BrowseComp 성능 분산의 80%, 세 요인으로 95% | E | 확인 | | 위와 같음 |
| 39 | Opus 4 리드 + Sonnet 4 서브에이전트가 단일 Opus 4보다 내부 리서치 평가에서 90.2% 우수, 조사 시간 최대 90% 단축 | E | 확인 | | 위와 같음 |
| 40 | 부적합 과업(공유 맥락, 의존성, 대부분의 코딩), 서브에이전트 50개 생성, 반도체 예시 중복, 동기 실행 병목 | E | 확인 | | 위와 같음 |
| 41 | 위임 규칙(1개·3~10회 / 2~4개·10~15회 / 10개 이상), 200,000토큰 잘림과 Memory, "game of telephone", 오류 지점 재개, 약 20개 질의, 0.0~1.0 + pass-fail, SEO 콘텐츠팜 | E | 확인 | | 위와 같음 |
| 42 | Cognition "Don't Build Multi-Agents"(Walden Yan, 2025-06-12): 두 원칙, Flappy Bird 예시, 단일 스레드 선형 에이전트, 압축 모델(파인튜닝 경험), Claude Code 서브에이전트 평가 | E | 확인 | | https://cognition.com/blog/dont-build-multi-agents |
| 43 | Cognition "Multi-Agents: What's Actually Working"(2026-04-22): "writes stay single-threaded", Devin Review PR당 평균 2개 버그·약 58% 심각, 깨끗한 맥락의 리뷰어, "map-reduce-and-manage", 내부 MCP, 세 실패 지점, "communication bridge", "80/20 solution", 사람은 대부분의 버그가 해결된 뒤 PR을 연다 | E | 확인 | | https://cognition.com/blog/multi-agents-working |
| 44 | "Managed Devins"라는 명칭, 그리고 "병렬 쓰기 스웜과 비정형 네트워크가 mostly a distraction" | E | 수정 필요 | 글에 "Managed Devins"라는 말은 없고 "a manager Devin", "child Devins"를 쓴다. "mostly a distraction"은 비정형 스웜("the unstructured-swarm approach, arbitrary networks of agents negotiating with each other")에 대한 말이고, 병렬 쓰기 스웜에 대해서는 "still don't see meaningful adoption"이라고 따로 적는다 | 위와 같음 |
| 45 | MAST v2(2025-04-22) 비율: 범주 41.77 / 36.94 / 21.30%, 단계 반복 17.14, 명세 불이행 10.98, 종료 조건 9.82, 추론-행동 불일치 13.98, 명확화 요청 안 함 11.65, 이탈 7.15, 조기 종료 7.82, 검증 없음 6.82, 잘못된 검증 6.66 | E | 확인 | 모두 v2 본문과 일치. 단 v2는 200개 트레이스 기준이다 | https://arxiv.org/html/2503.13657v2 |
| 46 | v3(2025-10-26)는 수치가 다르다: 단계 반복 15.7%, 명세 불이행 11.8%, 1600+ 트레이스, 7개 프레임워크, 실패율 41~86.7% | E | 확인 | v3 본문 값: FM-1.3 15.7, FM-1.1 11.8, FM-1.5 12.4, FM-2.6 13.2, FM-2.2 6.80, FM-2.3 7.40, FM-3.1 6.20, FM-3.2 8.20, FM-3.3 9.10. 트레이스 1642개, kappa 0.88. 범주 합계는 v3 본문에서 찾지 못했다(그림에만 있음) | https://arxiv.org/html/2503.13657v3 , https://arxiv.org/abs/2503.13657 |
| 47 | MAST가 NeurIPS 2025 D&B 채택 | E | 확인 불가 | arXiv 페이지의 comments는 "ArXiv v3"뿐이고 학회명이 없다 | https://arxiv.org/abs/2503.13657 |
| 48 | 역할 명세 개선으로 ChatDev +9.4%, 검증 단계 추가로 ProgramDev +15.6%, 검증자가 있어도 ChatDev 정답률 33.33% | E | 확인 | v2 기준 | https://arxiv.org/html/2503.13657v2 |
| 49 | Kim et al.(Google Research 블로그 2026-01-28): 180개 구성, 5개 구조, 4개 벤치마크, 3개 모델 계열, Finance-Agent 중앙집중형 +80.9%, PlanCraft 39~70% 하락, 오류 증폭 17.2배 대 4.4배, 16개+ 도구, R²=0.513, 87% | E | 확인 | 블로그와 arXiv v1 초록 모두 일치 | https://research.google/blog/towards-a-science-of-scaling-agent-systems-when-and-why-agent-systems-work/ , https://arxiv.org/abs/2512.08296v1 |
| 50 | "R²는 버전에 따라 0.524로도 보고됨"(링크는 v1), 그리고 최신 버전 언급 없음 | E | 수정 필요 | 0.524는 v2(2025-12-17) 초록 값이고 v1은 0.513이다. 현재 버전 v3(2026-04-08) 초록은 크게 바뀌었다: "260 configurations spanning six agentic benchmarks", R²=0.373(능력 지표 포함 0.413), "+80.8% … to -70.0%", 87%는 유지. 17.2배/4.4배는 v3 초록에 없다 | https://arxiv.org/abs/2512.08296 , https://arxiv.org/abs/2512.08296v2 |
| 51 | Anthropic 자율성 연구(2026-02-18): 자동 승인 약 20% → 40% 이상, 중단율 5% → 9%, 스스로 묻는 빈도 2배 이상, 멈추는 이유 35/21/13/12/11%, 사람이 끼어드는 이유 32/17/7/7/5%, 도구 호출 998,481건, 80%·73%·0.8%, 소프트웨어 엔지니어링 약 50%, 99.9 백분위 25분 미만 → 45분 이상, 중앙값 약 45초, 내부 성공률 2배, 개입 5.4 → 3.3회, "It's too early to mandate specific interaction patterns" | E | 확인 | 중단율 5%의 "신규"는 약 10세션 사용자, 자동 승인 20%의 "신규"는 50세션 미만으로 기준이 다르다. 99.9 백분위 기간은 본문 "Between October 2025 and January 2026", 그림 설명 "late September … early January" | https://www.anthropic.com/research/measuring-agent-autonomy |
| 52 | 사용자는 수동 권한 프롬프트의 93%를 승인, "approval fatigue" (2026-03-25) | E | 확인 | "in practice users accept 93% of them anyway" | https://www.anthropic.com/engineering/claude-code-auto-mode |
| 53 | "97%는 2차 출처의 인용이고 1차 출처는 93%" | E | 수정 필요 | Anthropic의 다른 1차 글(claude.com 블로그, 2026-08-07)이 "users approve 97% of permission prompts in Claude Code"라고 적는다. 93%(2026-03 엔지니어링 글)와 97%(2026-08 블로그) 둘 다 1차 수치다. DevOps.com은 403이라 열지 못했다 | https://claude.com/blog/auto-mode-default-in-claude-code |
| 54 | auto mode 구조: 도구 출력에 서버측 프롬프트 인젝션 탐지, 대화록 분류기(Sonnet 4.6), 사용자 메시지와 도구 호출만 봄("reasoning-blind by design"), 읽기 전용 도구와 프로젝트 내 파일 수정은 분류기 생략 | E | 확인 | | https://www.anthropic.com/engineering/claude-code-auto-mode |
| 55 | 오류율: 전체 파이프라인 오탐 0.4%, 실제 과잉행동 미탐 17%, 합성 유출 미탐 5.7%, 1단계만 8.5% / 6.6%, n=52 | E | 확인 | 5.7%와 6.6%는 본문 문장이 아니라 결과 표에 있다 | 위와 같음 |
| 56 | 연속 3회 또는 누적 20회 거부 시 정지 후 사람에게, 헤드리스(`claude -p`)는 프로세스 종료, "not a drop-in replacement for careful human review on high-stakes infrastructure", 진입 시 임의 코드 실행 권한 규칙 제거 | E | 확인 | "If a session accumulates 3 consecutive denials or 20 total, we stop the model and escalate to the human." | 위와 같음 |
| 57 | 차단 범주 4개와 사례(원격 브랜치 삭제, 다른 토큰 찾기, 이름이 비슷한 job 삭제, Gist 공유, 검증 건너뛰기 플래그, 프로덕션 DB 마이그레이션), 미탐의 주원인 | E | 확인 | 과거 사고 예시에는 엔지니어의 GitHub 인증 토큰을 내부 클러스터에 올린 건도 있다 | 위와 같음 |
| 58 | "auto mode가 8월 14일부터 일부 요금제 기본값이라는 보도는 1차 출처 미확인" | E | 수정 필요 | 1차 출처가 있다(2026-08-07): "Starting on August 14, new sessions on Pro, Max, and Team plans will run in auto mode." 다만 같은 페이지 머리말은 요금제를 "Pro, Max, Ultra, and Team"으로 적고, 2026-10-22 업데이트는 출시가 "next week"라고 해 실제 적용일이 밀렸을 수 있다 | https://claude.com/blog/auto-mode-default-in-claude-code |
| 59 | "테스터 1,053명, 사람 13.6% 대 분류기 89%는 1차 출처 미확인" | E | 수정 필요 | 같은 1차 글에 있다: "controlled experiment with 1,053 paid professional testers", 사람 검토는 위험 명령의 13.6%, auto mode는 89%를 잡았다. 실험 방법 상세는 이 글에서 확인하지 못했다 | 위와 같음 |
| 60 | Agent SDK 권한 모드 6종(`default`, `acceptEdits`, `plan`, `dontAsk`, `auto`, `bypassPermissions`)과 설명, `bypassPermissions`는 격리 환경 전용·root 불가 | E | 확인 | | https://code.claude.com/docs/en/agent-sdk/agent-loop |
| 61a | Codex 승인 정책 `on-request`, `never`, `untrusted` 폐지 | E | 확인 | 영문 공식 페이지에서 확인: "Codex and ChatGPT Work no longer support `untrusted` as a selectable approval policy." 노트의 "영문 페이지 미확인" 단서는 지워도 된다(developers.openai.com 주소는 learn.chatgpt.com으로 308 이동) | https://learn.chatgpt.com/docs/sandboxing |
| 61b | Codex `workspace-write`는 작업 디렉터리 + /tmp 쓰기, 네트워크 기본 차단 | E | 확인 불가 | 이 페이지에는 /tmp와 네트워크 기본값 설명이 없다. `workspace-write`는 "edit within the workspace, and run routine local commands inside that boundary"로만 적힌다 | 위와 같음 |
| 62 | "Habituation at the Gate"(arXiv 2606.22721, 2026-06-21, KDD 2026 워크숍): 반복 리뷰어 400명, 리뷰 11,429건, 7개월, 승인율 30.1% → 36.8%, 1 → 10분위 +14.5%p, 인라인 코멘트 22% 감소, 대기 시간 약 3.5배, 사람 PR 승인율 하락, PR 크기 중앙값 변화 없음, "reflexive habituation under growing workload" | E | 확인 | 논문 실재. 워크숍명은 "KDD 2026 Workshop on Agentic Software Engineering (SE 3.0)". 5쪽짜리 워크숍 논문이다 | https://arxiv.org/abs/2606.22721 , https://arxiv.org/html/2606.22721 |
| 63 | "Oversight Has a Capacity"(Emre Turan, arXiv 2606.08919, 2026-06-08): 125개 행동, Fleiss' kappa 0.52, 역U자형, "more human oversight can make a system less safe", 플러딩 공격, 모델링 결과 | E | 확인 | 논문 실재. 단독 저자 프리프린트이고 초록이 "modeling results that motivate a human study"라고 명시한다 | https://arxiv.org/abs/2606.08919 |
| 64 | Fitz et al. 2019(Computers in Human Behavior), 237명 무작위 현장 실험: 하루 3회 묶음이 대조군보다 스트레스·방해가 적고 더 행복, 매시간 묶음은 이득 없음, 알림 없음 집단은 불안이 높음 | E | 확인 | 초록: n = 237, 묶음 집단은 더 주의 깊고 생산적이며 기분이 좋고 스트레스·방해가 적다. "생산성 압박이 적다"가 아니라 "더 생산적이라고 느꼈다"가 맞다. 매시간 조건은 저자 요약 글에서 확인 | https://scholars.duke.edu/display/pub1402953 , https://communities.springernature.com/posts/batching-notifications-can-improve-attention-well-being-and-productivity |
| 65 | "3회 묶음 집단은 놓칠까 걱정(FOMO)이 늘었다" | E | 틀림 | 초록 기준으로 FoMO와 불안이 높아진 쪽은 알림을 아예 받지 않은 집단이다("experienced higher levels of anxiety and 'fear of missing out' (FoMO)"). 논문 전문은 읽지 못했다 | https://scholars.duke.edu/display/pub1402953 |
| 66 | Agent SDK: `max_turns`, `max_budget_usd` 기본값 제한 없음, `error_max_turns` / `error_max_budget_usd`, 예산에 서브에이전트 포함, "Budget limit reached", 백그라운드 서브에이전트 정지(v2.1.217 이상), 응답 1개 + 실행 중 서브에이전트만큼 초과 가능, "Setting a budget is a good default for production agents" | E | 확인 | 문서 전문에서 모두 확인 | https://code.claude.com/docs/en/agent-sdk/agent-loop |
| 67 | "Building effective agents"(2024-12-19): 체크포인트나 막혔을 때 사람 피드백을 위해 멈춤, 최대 반복 수 같은 중단 조건, 샌드박스 테스트와 가드레일, 가장 단순한 해법부터 | E | 확인 | | https://www.anthropic.com/research/building-effective-agents |
| 68 | "Effective context engineering"(2025-09-29): context rot, 압축 시 남길 것/버릴 것, 도구 결과 지우기, 요약 + 최근 파일 5개, NOTES.md, 서브에이전트 1,000~2,000토큰 요약, 기법별 용도 | E | 확인 | | https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents |
| 69 | "Effective harnesses for long-running agents"(2025-11-26): 두 실패 모드, init.sh·claude-progress.txt·git 커밋·200개 이상 기능 목록(모두 failing), `passes`만 변경, 테스트 삭제·수정은 "unacceptable", 브라우저 자동화, 단일 대 전문 에이전트는 미해결, JSON을 쓴 이유 | E | 확인 | | https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents |
| 70 | Agent SDK: 서브에이전트는 최종 응답만 반환, 압축과 CLAUDE.md 재주입, CLAUDE.md의 보존 지시 예시, `PreCompact`·`SubagentStart/Stop`·`Stop` 훅, 세션 재개·포크 | E | 확인 | | https://code.claude.com/docs/en/agent-sdk/agent-loop |

## 판정 집계

| 판정 | 건수 |
|---|---|
| 확인 | 57 |
| 수정 필요 | 9 |
| 확인 불가 | 5 |
| 틀림 | 1 |
| 합계 | 72 |

지어낸 논문이나 출처는 없었다. "Habituation at the Gate"와 "Oversight Has a Capacity"는 둘 다 arXiv에 실재하고 노트의 수치가 초록·본문과 맞는다. 다만 앞의 것은 5쪽짜리 워크숍 논문이고 뒤의 것은 단독 저자의 모델링 프리프린트이므로 근거 강도를 그렇게 적어야 한다.

## 보고서에 반드시 반영할 수정

1. **Fitz 2019의 FOMO 귀속을 고친다(#65).** FoMO와 불안이 늘어난 쪽은 알림을 완전히 끈 집단이다. 하루 3회 묶음 집단에 FOMO 증가를 붙이면 안 된다. "생산성 압박이 적다"도 "더 생산적이라고 느꼈다"로 고친다(#64).
2. **curl 일화를 출처대로 다시 쓴다(#33).** 쓸 수 있는 문장은 "2026년 1월 하순까지 20건이 접수됐고, 한 주에 몰린 7건 중 취약점은 0건이었다. 2019년 4월 시작한 바운티를 2026-01-31에 끝냈다"이다. "첫 21일", "AI 생성 20건", "20건 모두 무효"는 빼거나 확인 불가로 표시한다.
3. **93% 대 97%를 둘 다 Anthropic 1차 수치로 적는다(#53).** 93%는 2026-03-25 엔지니어링 글, 97%는 2026-08-07 claude.com 블로그다. "97%는 2차 출처"라는 설명은 지운다.
4. **auto mode 기본값 전환과 1,053명 실험의 "미확인" 표시를 지우고 1차 출처를 단다(#58, #59).** 출처는 https://claude.com/blog/auto-mode-default-in-claude-code 이다. 기본값 적용일은 8월 14일로 공지됐지만 같은 페이지의 10월 22일 업데이트가 "next week"라고 하므로, 날짜를 단정하지 말고 그대로 옮긴다.
5. **Kim et al. 수치에 버전을 밝힌다(#49, #50).** 180개 구성·4개 벤치마크·+80.9%·39~70%·17.2배/4.4배·R² 0.513은 블로그와 arXiv v1 기준이다. 0.524는 v2 값이다. 현재 v3(2026-04-08)는 260개 구성·6개 벤치마크·R² 0.373·+80.8%~−70.0%로 바뀌었다.
6. **MAST 비율은 v3 값을 쓰거나 버전을 명시한다(#45, #46).** v2(200개 트레이스) 수치는 맞지만 v3(1642개 트레이스)에서 달라졌다. 특히 "명확화 요청 안 함"은 11.65% → 6.80%, "종료 조건 인지 못함"은 9.82% → 12.4%다. NeurIPS 2025 D&B 채택은 이번에 확인하지 못했다(#47).
7. **Cognition 2026 글의 용어와 인용 대상을 고친다(#44).** "Managed Devins"는 글에 없는 표현이다. "mostly a distraction"은 비정형 스웜에 대한 평가이고, 병렬 쓰기 스웜은 "still don't see meaningful adoption"이다.
8. **Spotify Fleet Management "2022년부터"를 뺀다(#22b).** 인용한 글이 받치는 것은 "2024년 중반부터 PR의 약 절반이 자동화"와 "1,500건 이상 병합"이다.
9. **gh-aw 병합률 범위를 "57~78%"로 통일하고 선별 범위임을 밝힌다(#21).** "50%"는 근거가 없고, 100%인 소규모 워크플로도 있다. Plan Command 514/761(67%)은 확인 불가로 두거나 뺀다(#18). 나머지 수치의 출처는 블로그 인덱스가 아니라 개별 글·agentics 문서로 바꾼다(#16, #17).
10. **gh-aw README 인용문을 원문대로 고친다(#12).** Issue Triage는 "Triage labelling of issues and pull requests and not much more"이다. Repo Assist의 "multi-task backlog burner"는 확인하지 못했으니 따옴표를 뗀다.
11. **Jazzband 출처를 1차 글로 바꾸고 "종료"를 "단계적 정리(sunsetting)"로 적는다(#34).** Airflow 일화는 확인 불가이고 2025년 2월 사례로 보이므로 2026년 근거로 쓰지 않는다(#35). hyrax.dev의 79%도 확인 불가다(#20).
12. **Codex 서술을 정리한다(#61a, #61b).** `untrusted` 폐지는 영문 공식 문서로 확인됐다. `/tmp` 쓰기와 네트워크 기본 차단은 이 페이지로는 확인되지 않으니 빼거나 다른 출처를 단다.
