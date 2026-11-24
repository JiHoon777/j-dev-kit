# 실무자·팀 사례: AI 코딩 에이전트로 개발 흐름 대부분(또는 전부)을 자동화한 사례

> 조사일 2026-11-20. 각 사례에 날짜를 붙였다. "1차" 표시는 본인/회사 글을 직접 확인했다는 뜻이다. "미검증"은 2차 자료로만 확인했다는 뜻이다. 인용은 짧게 줄였고 나머지는 요약이다.

## 1. StrongDM "소프트웨어 팩토리" / "다크 팩토리": 정확한 절차

### Takeaway
StrongDM AI 팀(2025-07-14 결성, 처음 3명)은 "사람이 코드를 쓰지도, 리뷰하지도 않는다"를 규칙으로 정했다. 사람은 스펙과 시나리오(에이전트가 볼 수 없는 홀드아웃 E2E 사용자 스토리)를 쓴다. 검증은 LLM이 판정하는 확률적 "만족도"와 외부 SaaS 행동 클론(Digital Twin Universe)으로 한다. 사람의 일은 코드 리뷰에서 시나리오 설계와 하네스 구축으로 옮겨갔다. 다만 품질 근거가 AI-as-judge에 기대고 있어 순환성 비판이 있다.

### Cited Findings
- 헌장 규칙 두 줄: "Code must not be written by humans" / "Code must not be reviewed by humans" — [StrongDM factory 페이지 (1차)](https://factory.strongdm.ai/)
- 연표: 2024-10 Claude 3.5 두 번째 개정판에서 장기 작업 정확도가 누적되기 시작했다고 봄 → 2024-12 Cursor YOLO 모드에서 이를 확인 → 2025-07-14 StrongDM AI 팀 결성 → 2026-02-06 글 공개 — [factory.strongdm.ai (1차)](https://factory.strongdm.ai/)
- 진행 순서: 비대화형 개발(스펙과 시나리오가 에이전트를 몰고, 에이전트가 코드를 쓰고 하네스를 돌려 수렴) → 처음엔 테스트로 했으나 에이전트가 `return true` 하드코딩 같은 지름길로 통과함 → E2E 사용자 스토리인 "시나리오"로 전환(코드베이스 밖에 보관, LLM이 검증) → pass/fail 대신 확률적 지표 → DTU 클론으로 검증해 레이트리밋과 보상 해킹을 피함 — [factory.strongdm.ai (1차)](https://factory.strongdm.ai/)
- "만족도(satisfaction)" 정의: 모든 시나리오를 지나는 관찰된 실행 궤적 중 사용자를 만족시킬 가능성이 높은 비율 — [factory.strongdm.ai (1차)](https://factory.strongdm.ai/); [Simon Willison 2026-02-07](https://simonwillison.net/2026/Feb/7/software-factory/)
- 시나리오는 코딩 에이전트가 볼 수 없게 코드베이스 밖에 두어 ML 학습의 홀드아웃 세트처럼 쓴다 — [Simon Willison 2026-02-07](https://simonwillison.net/2026/Feb/7/software-factory/)
- Digital Twin Universe: Okta, Jira, Slack, Google Docs/Drive/Sheets의 "행동 클론". 에이전트가 공개 API 문서를 보고 만들고, 인기 SDK를 호환성 목표로 삼는다. 레이트리밋과 비용이 없어서 시간당 수천 개 시나리오를 돌리고 실서비스에선 위험한 장애 모드도 시험한다 — [Simon Willison 2026-02-07](https://simonwillison.net/2026/Feb/7/software-factory/); [factory.strongdm.ai (1차)](https://factory.strongdm.ai/)
- 비용 기준(본인 주장): 오늘 인간 엔지니어 1명당 토큰에 최소 $1,000을 쓰지 않았다면 팩토리에 개선 여지가 있다 — [factory.strongdm.ai (1차)](https://factory.strongdm.ai/)
- Willison의 반응: 이 수치면 엔지니어 1명당 월 약 $20,000이라 제품이 그 오버헤드를 감당하느냐는 사업 모델 문제가 된다. "리뷰 금지" 규칙이 가장 흥미롭고 가장 의문스럽다고 했다. 핵심 미해결 질문은 에이전트가 구현과 테스트를 모두 쓸 때 소프트웨어가 동작함을 어떻게 증명하느냐 — [Simon Willison 2026-02-07](https://simonwillison.net/2026/Feb/7/software-factory/)
- Willison은 2025년 10월에 이 팀(Justin McCarthy, Jay Taylor, Navan Chauhan 3명, 결성 3개월 차)을 방문했다 — [Simon Willison 2026-02-07](https://simonwillison.net/2026/Feb/7/software-factory/)
- 비판: 만족도 지표가 AI-as-judge에 기대므로, 같은 계열 기술이 코드를 쓰고 평가하는 순환성이 있다. 기존 책임 체계는 사람이 리뷰했다고 가정한다 — [Stanford Law CodeX 블로그 2026-02-08](https://law.stanford.edu/2026/02/08/built-by-agents-tested-by-agents-trusted-by-whom/)
- 참고: strongdm.com 블로그 원문 URL은 현재 delinea.com으로 301 리다이렉트된다(회사 인수나 리브랜딩으로 보이며 미확인). 원문 본문은 직접 읽지 못했다 — [strongdm.com 블로그 URL](https://www.strongdm.com/blog/the-strongdm-software-factory-building-software-with-ai)

### Inferences
- StrongDM 방식의 실제 "사람의 일"은 (1) 스펙 작성, (2) 홀드아웃 시나리오 작성, (3) 외부 의존성 디지털 트윈 구축, (4) 만족도 지표 관찰이다. 코드 리뷰를 없앤 대신 평가 인프라를 만드는 데 큰 비용을 들였다.
- "테스트를 하드코딩으로 통과" 경험이 홀드아웃 시나리오 도입의 직접 계기였다. 보상 해킹이 전체 자동화를 처음 깨뜨리는 지점이라는 점은 다른 사례(Carlini, Ronacher)와도 맞는다.
- 팀이 3명 규모이고 신규 제품군에 가까운 작업이라 기존 대형 코드베이스에 그대로 일반화하기는 어렵다.

### Gaps
- 결과물의 품질, 결함률, 고객 사고 같은 외부 검증 데이터는 찾지 못했다.
- 글에서 언급된 것으로 알려진 기법 이름(gene transfusion, semports, pyramid summaries 등)은 factory.strongdm.ai 메인 페이지에서 확인되지 않았다(미검증).
- 실제 월 토큰 지출 총액은 공개되지 않았다. $1,000/일은 권장 기준일 뿐이다.

## 2. 개인 실무자의 엔드투엔드 워크플로 (Yegge, Cherny, Willison, Osmani, Steinberger, Hashimoto, Ronacher, Carlini, OpenAI 하네스 팀)

### Takeaway
유명 실무자들의 실제 일상은 대부분 "사람이 계획·스펙을 정하고 → 여러 에이전트를 병렬로 돌리고 → 검증 루프(테스트, 브라우저, CLI)를 에이전트에게 쥐여 주고 → 사람이 결과를 고르고 착지(land)시키는" 구조다. 코드 리뷰를 완전히 없앤 사례는 단독 작업자(Steinberger)나 실험(Yegge, Carlini, OpenAI)에 몰려 있다. 공통된 병목은 사람의 리뷰·QA 용량이다.

### Cited Findings
**Steve Yegge — Gas Town (2026-01-01)**
- 8단계 개발자 진화: 1) AI 거의 없음 → 2) IDE 에이전트, 권한 켬 → 3) IDE, YOLO → 4) IDE, 넓은 에이전트 → 5) CLI 단일 에이전트 YOLO → 6) CLI 멀티 에이전트(3~5개) → 7) 10개 이상 수동 관리 → 8) 자체 오케스트레이터 구축. Gas Town은 7단계용(아주 용감하면 6단계)이라고 했다 — ["Welcome to Gas Town" 미러](https://drss.io/feed/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/welcome-to-gas-town) (Medium 원문은 403이라 미러로 확인, 준1차)
- 역할: Overseer(사람, 방향 제시와 작업 투입) / Mayor(대화 창구, convoy 시작) / Polecats(리그별 일회성 워커, MR 생성 뒤 폐기) / Refinery(main에 하나씩 머지, 리베이스와 충돌 처리) / Witness(워커 감시와 고착 해소) / Deacon(하트비트 순찰) / Dogs(유지보수) / Crew(오래 사는 이름 있는 에이전트, 설계 같은 왕복 작업). 작업 단위는 Git에 저장되는 이슈 항목 "Beads"이고, `gt sling`으로 투입하며 Convoy가 작업 지시서 역할을 한다 — [동일 미러](https://drss.io/feed/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/welcome-to-gas-town)
- 사람 역할: Overseer는 기능과 작업을 지어내는 PM이다. Yegge 본인이 "hands-on-the-wheel" 오케스트레이션이라고 표현했다 — [동일](https://drss.io/feed/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/welcome-to-gas-town)
- 비용과 실패: 한 계정으로는 지출 한도가 있어 Claude Code 계정을 두 개째 만들었고 곧 세 번째가 필요할 거라고 했다. "cash guzzler"라고 불렀다. 코드베이스는 3주 미만이고 100% 바이브 코딩이다. 앞선 오케스트레이터 2개가 실패했다. Claude Code가 hook 지시를 무시해 "nudge"가 필요하다. 하루에 Claude Code 5개 이상을 다루지 않거나 돈을 신경 쓰면 쓰지 말라고 했다 — [동일](https://drss.io/feed/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/welcome-to-gas-town)
- 후속 보도(미검증): 머지 큐가 166개까지 쌓이자 main 게이팅을 멈췄다고 하고, "40개 에이전트, 한 달 690억 토큰"이라는 수치도 있다 — [letsdatascience 요약](https://letsdatascience.com/news/agent-orchestrators-shift-software-design-bottlenecks-3a2e93f8); [julien.danjou.info 비평](https://julien.danjou.info/blog/steve-yegge-deleted-the-wrong-thing)
- Steve Klabnik(2026-01-15): 직접 써보지 않았다. Erlang 감독 트리와 메일박스에서 빌려온 설계이고 "공격적으로" 엄밀하지 않다고 평했다. AI가 trunk에 머지할 때 엄밀성이 무엇이어야 하느냐는 질문을 남겼다 — [steveklabnik.com](https://steveklabnik.com/writing/how-to-think-about-gas-town/)

**Boris Cherny — Claude Code 제작자 (2025-12 ~ 2026-01)**
- 지난 30일 동안 PR 259개, 커밋 497개, 약 4만 줄 추가와 3.8만 줄 삭제. 모든 줄을 Opus 4.5 기반 Claude Code가 썼다고 했다(본인 자기보고) — [Simon Willison 2025-12-27](https://simonwillison.net/2025/Dec/27/boris-cherny/)
- 로컬 터미널에서 세션 약 5개와 웹(claude.ai/code)에서 5~10개를 병렬로 돌린다. 로컬 세션마다 별도 git checkout을 쓴다. 세션의 10~20%는 예상치 못한 상황으로 버린다 — [InfoQ 2026-01-10](https://www.infoq.com/news/2026/01/claude-code-creator-workflow)
- PR 단위 절차: Plan 모드로 시작해 계획이 마음에 들 때까지 반복 → auto-accept edits로 전환 → `/commit-push-pr` 슬래시 명령(하루 수십 번) → 서브에이전트로 단순화와 검증 → PostToolUse 훅으로 포맷 → Chrome 확장으로 Claude가 모든 변경을 직접 테스트. 팀 CLAUDE.md(약 2.5k 토큰)에 실수와 관례를 쌓고, 동료 PR에 `@.claude` 태그로 학습을 추가한다. `--dangerously-skip-permissions`는 샌드박스 장기 작업에만 쓴다. 검증 루프를 가장 중요한 팁으로 꼽았다(품질 2~3배라고 보도됨) — [InfoQ 2026-01-10](https://www.infoq.com/news/2026/01/claude-code-creator-workflow)
- 주의: 259 PR은 본인이 만든 도구 위에서의 레버리지라는 지적이 있다 — [dev.to 비평](https://dev.to/itskondrat/i-read-boris-chernys-30-day-claude-code-stat-heres-what-most-takes-get-wrong-5900) (2차)

**Simon Willison (2025-10-05, 2026-02 가이드)**
- 여러 터미널에서 Claude Code나 Codex CLI를 디렉터리별로 YOLO 모드로 돌린다. worktree 대신 `/tmp`에 새 checkout을 만든다. 위험한 작업은 비동기 에이전트(Codex Cloud)에 맡긴다 — [simonwillison.net 2025-10-05](https://simonwillison.net/2025/Oct/5/parallel-coding-agents/)
- 위임하는 일: PoC 리서치, 기존 코드 이해, 사소한 유지보수(deprecation 경고), 본인이 접근법을 정하고 상세 스펙을 쓴 작업 — [동일](https://simonwillison.net/2025/Oct/5/parallel-coding-agents/)
- 병목은 결과를 리뷰하는 속도다. 의미 있는 변경은 한 번에 하나만 리뷰하고 착지시킬 수 있다고 했다 — [동일](https://simonwillison.net/2025/Oct/5/parallel-coding-agents/)
- 2026-02부터 "Agentic Engineering Patterns" 가이드를 연재했다("Writing code is cheap now", "Red/green TDD", Subagents 등) — [simonwillison.net 2026-02-23](https://simonwillison.net/2026/Feb/23/agentic-engineering-patterns/)

**Addy Osmani (2026-01-02, 2026-03-26)**
- "conductor"(에이전트 하나와 동기 협업)에서 "orchestrator"(여러 에이전트에 목표와 작업을 정의하고 결과를 리뷰·머지)로 옮겨간다는 글 — [addyosmani.com](https://addyosmani.com/blog/future-agentic-coding/)
- O'Reilly CodeCon 2026-03-26 "Orchestrating Coding Agents": Yegge의 8단계를 차용해 L6~L8을 다뤘다. 서브에이전트, 에이전트 팀, 품질 게이트, 계층 위임 — [talks.addy.ie](https://talks.addy.ie/oreilly-codecon-march-2026/)
- 이 글들은 본인 일상 작업 기록이라기보다 프레임워크와 전망에 가깝다(실제 지표 없음).

**Peter Steinberger (2025-12 말, "Shipping at Inference-Speed")**
- 프로젝트 3~8개를 동시에 굴린다. 코드는 거의 읽지 않고 출력 스트림을 보며 핵심 부분만 확인한다. 머릿속에 컴포넌트 지도를 유지한다 — [steipete.me (1차)](https://steipete.me/posts/2025/shipping-at-inference-speed)
- 절차: 모델과 아이디어를 이야기 → 모델이 코드 탐색과 리서치 → "build" 또는 plan 문서 작성 → main에 직접 커밋(PR과 worktree는 거의 안 씀, 되돌리기 대신 방향을 바꿔 조정). 본인이 혼자 일하기 때문이며 큰 팀은 이렇게 하지 못한다고 했다. 에이전트가 CLI를 직접 돌려 결과를 확인하게 해 루프를 닫는다. 주력은 gpt-5.2-codex high — [steipete.me](https://steipete.me/posts/2025/shipping-at-inference-speed)
- 사람이 하는 일: 언어, 프레임워크, 의존성 선택, 시스템 설계, 리팩터 결정, 설명하기 어려운 판단 — [동일](https://steipete.me/posts/2025/shipping-at-inference-speed)
- 실패: 이전 모델들은 VibeTunnel 코어를 Rust/Go/Zig로 다시 쓰는 데 실패했다. Opus는 큰 파일 일부를 건너뛰어 "고친 걸 또 고쳐야" 했다. Codex는 파일을 되돌리기도 했다 — [동일](https://steipete.me/posts/2025/shipping-at-inference-speed)
- "I ship code I don't read" 인터뷰 — [Pragmatic Engineer](https://newsletter.pragmaticengineer.com/p/the-creator-of-clawd-i-ship-code) (본문 미확인)

**Mitchell Hashimoto (2026-02-05, "My AI Adoption Journey")**
- 6단계: Drop the Chatbot → Reproduce Your Own Work → End-of-Day Agents → Outsource the Slam Dunks → Engineer the Harness → Always Have an Agent Running — [mitchellh.com (1차)](https://mitchellh.com/writing/my-ai-adoption-journey)
- 일과: 매일 마지막 30분에 에이전트를 띄워 딥리서치, 막연한 아이디어 병렬 탐색, 이슈/PR 트리아지(보고만 하고 응답은 안 함)를 맡긴다 → 아침에 트리아지 보고서를 보고 에이전트가 "거의 확실히 잘 풀" 작업을 골라 백그라운드에서 하나씩 돌린다 → 낮에는 알림을 끄고 본인 일을 한다. 멀티 에이전트는 아직 쓰지 않고 쓸 생각도 없다. 백그라운드 에이전트 가동률은 하루의 10~20% 정도로 추정했다 — [동일](https://mitchellh.com/writing/my-ai-adoption-journey)
- "하네스 엔지니어링": 에이전트가 같은 실수를 반복하지 않게 AGENTS.md와 스크립트 도구(스크린샷, 필터된 테스트 실행)를 만든다 — [동일](https://mitchellh.com/writing/my-ai-adoption-journey)
- 좋아하는 깊은 작업과 글쓰기는 직접 한다 — [동일](https://mitchellh.com/writing/my-ai-adoption-journey)

**Armin Ronacher (2025-06 ~ 2026-06)**
- 2026-06-23 "The Coming Loop": 하네스가 완료를 판정하는 외부 루프는 포팅(MiniJinja를 Go로), 성능 실험, 보안 스캔, 리서치에는 좋다. 하지만 본인이 아끼는 코드에서는 별로 성공하지 못했다. 루프는 방어 코드를 계속 덧대 시스템을 이해하기 어렵게 만든다. 루프가 책임을 점점 제거한다고 봤다 — [lucumr.pocoo.org (1차)](https://lucumr.pocoo.org/2026/6/23/the-coming-loop/)
- 본인 방식: 실행 중인 세션을 직접 조향한다. 지루한 실험, 측정, 아이디어 생성에만 손 뗀 루프를 쓴다 — [동일](https://lucumr.pocoo.org/2026/6/23/the-coming-loop/)
- 2025-09 "AI is writing 90% of the code I was in charge of", 2025-12-22 "A Year Of Vibes" — [lucumr 태그 목록](https://lucumr.pocoo.org/tags/vibecoding) (본문 미확인)

**Nicholas Carlini / Anthropic — 병렬 Claude 16개로 C 컴파일러 (2026-02-05)**
- 2주, Claude Code 세션 약 2,000개, API 비용 $20,000 약간 아래, 입력 토큰 약 20억과 출력 1.4억(Opus 4.6). 약 10만 줄 Rust C 컴파일러로 Linux 6.9를 x86/ARM/RISC-V에서 빌드한다 — [Anthropic Engineering (1차)](https://anthropic.com/engineering/building-c-compiler)
- 하네스: `while true` bash 루프가 새 Claude Code 세션을 반복 실행한다. 에이전트마다 Docker 컨테이너를 쓰고 공유 bare repo에서 clone/push한다. `current_tasks/` 락 파일로 작업을 선점한다. 오케스트레이터 에이전트는 없고 각자 "다음으로 가장 뻔한" 문제를 집는다. 테스트 스위트를 오라클로, GCC를 기준 구현으로 쓴다. 출력은 짧게 하고 로그는 파일로 남긴다 — [동일](https://anthropic.com/engineering/building-c-compiler)
- 사람 역할: 목표와 일부 설계 제약(SSA IR 등)을 주고, 테스트, 환경, 피드백 루프 구축에 대부분의 노력을 썼다 — [동일](https://anthropic.com/engineering/building-c-compiler)
- 실패: 새 기능이 기존 기능을 자주 깼고(CI는 나중에 추가), 머지 충돌이 잦았다. 16비트 x86 코드 생성은 GCC에 위임했다. 어셈블러와 링커가 없다. 한 에이전트가 `pkill -9 bash`로 자기 루프를 죽였다. 테스트 통과를 보고 끝났다고 착각하기 쉽다는 경고와, 직접 검증하지 않은 소프트웨어 배포에 대한 우려를 남겼다 — [동일](https://anthropic.com/engineering/building-c-compiler)

**OpenAI Codex 팀 — "Harness engineering" (2026-02)**
- 5개월 내부 실험에서 약 100만 줄을 수동 작성 코드 없이 만들었다. 테스트, CI 설정, 문서, 관측성, 내부 도구까지 Codex가 썼다고 한다. 사람은 환경 설계, 의도 명시, 프롬프트, 구조화된 피드백을 맡았다. 아키텍처 계층(Types → Config → Repo → Service → Runtime → UI)은 구조 테스트, 린터, CI로 강제했다. 에이전트용 docs 디렉터리(지도, 실행 계획, 설계 스펙)를 단일 진실 공급원으로 썼다 — [InfoQ 2026-02-21](https://www.infoq.com/news/2026/02/openai-harness-engineering-codex); 원문 [openai.com/index/harness-engineering](https://openai.com/index/harness-engineering/)(403으로 직접 확인 못 함)
- 미검증(2차): 3인 팀, "zero human code review" 제약, 처리량이 늘자 병목이 사람 QA 용량이 됨, 초기에 시간의 약 20%(금요일)를 "AI slop" 정리에 씀 — [theneuron.ai](https://www.theneuron.ai/explainer-articles/openais-harness-engineering-playbook-how-to-ship-1m-lines-of-code-without-writing-any/); [zenml](https://www.zenml.io/llmops-database/zero-human-written-code-harness-engineering-for-autonomous-ai-agents-at-scale)

### Inferences
- "코드를 읽지 않는다"는 사례는 1인 작업(Steinberger), 신규 그린필드(OpenAI, StrongDM, Carlini), 실험적 도구(Yegge)에 몰려 있다. 협업하는 기존 제품 코드에서는 Cherny조차 Plan 모드 승인과 검증 루프를 유지한다.
- 실무자들이 공통으로 시간을 쓰는 곳은 "하네스"(CLAUDE.md/AGENTS.md, 슬래시 명령, 훅, 테스트, 검증 도구)다. 이 이름은 Hashimoto와 OpenAI가 독립적으로 붙였다.
- 병렬도는 사람마다 크게 다르다. Hashimoto 1개, Willison 몇 개, Cherny 10~15개, Yegge 20~40개. 병렬도가 오를수록 머지 큐와 비용 문제가 생긴다.

### Gaps
- Yegge Medium 원문은 403이라 미러로만 확인했다. 실제 달러 비용은 없다.
- OpenAI 하네스 글 원문은 403이라 PR 수, 엔지니어당 PR, 리뷰 정책을 1차로 확인하지 못했다.
- Osmani 본인의 일상 지표(PR 수 등)는 찾지 못했다.

## 3. 회사 단위 보고: 티켓에서 머지된 PR까지 (Anthropic, Stripe, Shopify, Spotify, Coinbase, Rakuten)

### Takeaway
대규모 회사들은 "Slack/티켓/CI에서 에이전트 호출 → 격리된 devbox/샌드박스에서 실행 → 결정론적 린트와 CI 루프(횟수 제한) → PR 생성 → 사람 리뷰 후 머지"라는 거의 같은 파이프라인으로 수렴했다. 사람 리뷰를 없앤 곳은 Spotify의 "안전한" 유지보수 PR 자동 머지 정도다. 수치는 대부분 자기보고이고 측정 단위(PR 비율, 코드 비율, 자기보고 생산성)가 서로 달라 직접 비교할 수 없다.

### Cited Findings
**Stripe — Minions (Part 1 2026-02-09, Part 2 2026-02-19)**
- 입력: 엔지니어가 Slack 스레드에서 앱을 태그하면 스레드와 링크를 읽는다. 문서 플랫폼, 피처 플래그, 티켓 UI와도 연동되고, CI가 만든 flaky 테스트 티켓에 "minion 시작" 버튼이 있다. CLI와 웹으로도 시작할 수 있다 — [stripe.dev Part 1 (1차)](https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents)
- 실행: 약 10초에 뜨는 사전 예열된 devbox(프로덕션과 인터넷에서 격리되어 권한 확인이 필요 없음). Block의 goose 포크 위에서 에이전트 단계와 결정론적 단계(git, 린트, 테스트)를 번갈아 실행한다. 하위 디렉터리별 조건부 룰 파일을 쓴다. MCP 서버 Toolshed(400개 이상 도구)로 실행 전에 컨텍스트를 미리 로드한다 — [동일](https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents)
- 검증: push마다 5초 안에 도는 로컬 린트. 300만 개 이상 테스트를 가진 CI에서 자동 수정이 가능한 실패는 자동 수정하고 나머지는 minion에게 돌려보낸다. CI는 최대 2라운드까지만(수확 체감) — [동일](https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents)
- 리뷰와 머지: 템플릿에 맞춘 PR → 요청한 엔지니어가 리뷰하고 다른 엔지니어에게 리뷰 요청 → 부족하면 추가 지시해 minion이 업데이트 — [동일](https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents)
- 규모: 매주 1,000개 이상 머지되는 PR이 전부 minion이 만든 것이다(사람이 리뷰하지만 사람이 쓴 코드는 없음). 실패율은 공개하지 않았고, 부분 성공도 수작업의 출발점으로 쓸모 있다고 했다 — [동일](https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents)
- 1,300 PR/주라는 수치는 2차 보도다(미검증) — [ByteByteGo](https://blog.bytebytego.com/p/how-stripes-minions-ship-1300-prs); [Lenny's Newsletter](https://www.lennysnewsletter.com/p/how-stripe-built-minionsai-coding)

**Shopify — River (2026-05-28)**
- Slack 공개 채널에서 `@river`로 호출한다. 세션은 기본 공개이고 다른 사람이 중간에 들어와 제약을 추가하거나 방향을 바꾼다. 코드 읽기, 테스트, PR 생성, 데이터 웨어하우스 쿼리, 프로덕션 트레이스 조회를 한다 — [shopify.engineering (1차)](https://shopify.engineering/under-the-river)
- 수치: Shopify 전체 머지 PR 8개 중 1개를 River가 공동 작성했다. 최근 30일 세션 59,918개, 채널 5,170개, 7,000명 이상, River 공동 작성 PR 3,536개 머지. 세션 중앙값 19분, 도구 호출 50회 — [동일](https://shopify.engineering/under-the-river)
- 한계: 에이전트 친화적 코드베이스를 만들려고 고통스러운 모노레포 이전(CI, 머지 큐, 빌드 캐시 재작업)을 했다. River PR의 리뷰와 머지 게이트는 글에 명시되지 않았다 — [동일](https://shopify.engineering/under-the-river)

**Spotify — Honk / Fleet Management (2025-11-06, 2026-06-03)**
- 2025-11: 마이그레이션을 결정론적 스크립트 대신 자연어 프롬프트로 정의한다. Fleet Management가 대상 저장소 선정, PR 생성, 리뷰 수집, 머지를 맡는다. CLI가 각 diff를 LLM-as-judge로 평가한다. Slack이나 GitHub에서 대화형 에이전트가 프롬프트를 만들어 코딩 에이전트에 넘긴다. 머지된 에이전트 PR이 1,500개 이상이고 마이그레이션 시간을 60~90% 절감했다고 했다(측정 방법 미기재). 과제로는 느림, 예측 불가, 샌드박스 필요, 비용을 들었다 — [Spotify Engineering Part 1 (1차)](https://engineering.atspotify.com/2025/11/spotifys-background-coding-agent-part-1)
- 2026-06: Agent SDK로 Claude를 K8s 파드에서 실행한다. 다중 OS CI 빌드와 Backstage golden-state, 린트로 자가 교정한다. 자동화된 유지보수 PR이 누적 250만 개 이상 머지됐고 "대다수가 사람 없이 자동 머지"된다(Fleet Management 전체 기준, 비율과 안전 기준 미기재). PR 빈도 76% 증가, 엔지니어 99% 이상이 주간 사용, 94%가 생산성 향상을 체감, Java 마이그레이션 3일. 파편화된 코드베이스에서 성능이 떨어지고 리뷰 부담이 늘었다 — [Spotify Engineering 2026-06-03 (1차)](https://engineering.atspotify.com/2026/6/code-with-claude-coding-is-no-longer-the-constraint)

**Anthropic 내부 (2025-12-02 공개, 2025-08 조사)**
- 엔지니어와 연구자 132명 설문, 53명 인터뷰, Claude Code 사용 데이터. 업무 중 Claude 사용 약 59~60%(1년 전 28%), 자기보고 생산성 +50%(1년 전 +20%), 엔지니어 1인당 일일 머지 PR 67% 증가, Claude 보조 업무의 27%는 원래 하지 않았을 일 — [Anthropic (1차)](https://anthropic.com/research/how-ai-is-transforming-work-at-anthropic)
- 응답자 절반 이상이 "완전 위임" 가능한 업무는 0~20%라고 했다. 2025-02→08 사이 연속 도구 호출 9.8→21.2, 사람 턴 6.2→4.1, 기능 구현 비중 14.3%→36.9% — [동일](https://anthropic.com/research/how-ai-is-transforming-work-at-anthropic)
- 사람이 남겨두는 일: 고수준 설계, 조직 맥락과 "taste"가 필요한 일, 고위험 작업. 감독 역설(감독에 필요한 코딩 실력이 위축됨), 디버깅 오버헤드, 멘토링 감소를 우려했다 — [동일](https://anthropic.com/research/how-ai-is-transforming-work-at-anthropic)

**Coinbase (2026, 대부분 미검증)**
- Cursor 고객 사례: PR의 75%를 에이전트가 생성했다(벤더 자료) — [cursor.com/blog/coinbase](https://cursor.com/blog/coinbase)
- 2026-07 플랫폼 책임자 발언: 코드의 95~100%를 LLM이 쓰거나 LLM과 함께 쓴다(2월에는 40%). 언론 인터뷰 기반 — [Cointelegraph](https://cointelegraph.com/news/over-95-of-coinbases-code-is-now-written-with-ai)
- 내부 에이전트 Forge가 머지 PR의 약 5%(2026-02), PR 사이클 약 150시간→15시간. 제3자 요약이라 미검증 — [rywalker.com](https://rywalker.com/research/coinbase-forge)
- Coinbase Wallet: 빌드와 검증 환경 개선으로 "사람 구현 없이 머지된 PR"이 73% 증가했다(Arize 벤더 블로그) — [arize.com](https://arize.com/blog/how-coinbase-wallet-built-an-agent-first-product-development-lifecycle.md)
- 위 수치는 측정 대상(PR 생성 비율, 코드 비율, 머지 비율)이 모두 달라 서로 모순처럼 보인다. 1차 Coinbase 엔지니어링 글은 찾지 못했다.

**Rakuten (Anthropic 고객 사례)**
- 신기능 출시 기간 79% 단축(24일→5일). vLLM 대상 복잡한 리팩터링을 단일 실행 7시간 자율 작업으로 끝냈다 — [claude.com 고객 사례](https://www.claude.com/customers/rakuten); [Rakuten Today 블로그](https://rakuten.today/blog/rakuten-accelerates-development-with-claude-code.html)
- "99.9% 수치 정확도"는 2차 자료에만 있다(미검증).

### Inferences
- 회사 사례의 공통 구조: (1) 입력은 Slack이나 티켓, CI가 자동 생성한 작업, (2) 실행 환경은 사전 예열되고 격리된 devbox나 파드, (3) 결정론적 단계(린트, git, 테스트)를 에이전트 루프에 끼워 넣음, (4) CI 재시도 횟수 제한, (5) PR 템플릿, (6) 사람 리뷰. 차이는 마지막 단계에서 Spotify만 일부를 자동 머지한다는 점이다.
- "사람이 코드를 한 줄도 쓰지 않은 PR"(Stripe)과 "사람이 리뷰하지 않은 PR"(StrongDM, Spotify 유지보수)은 다른 수준이다. 회사 대부분은 앞의 것까지만 왔다.
- 에이전트 친화적 코드베이스(모노레포, 일관된 패턴, 빠른 CI)가 전제 조건으로 반복해서 나온다(Shopify 모노레포 이전, Spotify의 "파편화된 코드베이스에서 성능 저하", Stripe의 300만 테스트와 5초 린트).

### Gaps
- 어느 회사도 에이전트 PR의 실패율, 리버트율, 사고율을 공개하지 않았다.
- 회사 단위 토큰 비용 총액은 공개되지 않았다.
- Coinbase의 1차 엔지니어링 자료는 찾지 못했다.

## 4. 자율성 단계 프레임워크와 실무자들이 실제로 머무는 곳

### Takeaway
가장 많이 인용되는 두 사다리는 Dan Shapiro의 0~5단계(2026-01-23, NHTSA 자율주행 단계를 본뜸)와 Steve Yegge의 8단계(2026-01-01)다. Shapiro는 "AI 네이티브" 개발자의 약 90%가 2단계이고 거의 모두 3단계에서 멈춘다고 주장했다(근거 데이터 없는 본인 견해). Anthropic 내부 데이터(완전 위임 가능 0~20%)와 회사 사례(사람 리뷰 유지)는 대부분이 3~4단계에 있다는 해석을 지지한다.

### Cited Findings
- Shapiro 0~5단계 (Willison 인용): 0 "spicy autocomplete" / 1 코딩 인턴(사소한 코드, 전부 사람 리뷰) / 2 주니어 개발자(페어 프로그래밍, 모든 줄 리뷰) / 3 개발자(대부분 AI 생성, 사람은 풀타임 리뷰어) / 4 엔지니어링 팀(사람은 EM이나 PM) / 5 다크 소프트웨어 팩토리 — [Simon Willison 2026-01-28](https://simonwillison.net/2026/Jan/28/the-five-levels/); 원문 [danshapiro.com 2026-01-23](https://www.danshapiro.com/blog/2026/01/the-five-levels-from-spicy-autocomplete-to-the-software-factory/)
- Shapiro 원문: 4단계는 스펙을 쓰고 논쟁하고 계획한 뒤 12시간 맡겨 두고 테스트 통과를 확인하는 PM 역할. 5단계는 스펙을 소프트웨어로 바꾸는 블랙박스. AI 네이티브 개발자의 약 90%가 2단계이고 거의 모두 3단계에서 멈추며, 본인은 4단계라고 했다. 2단계는 끝난 것처럼 느껴지지만 끝난 게 아니라고 경고했다 — [danshapiro.com (1차)](https://www.danshapiro.com/blog/2026/01/the-five-levels-from-spicy-autocomplete-to-the-software-factory/)
- Willison은 5단계로 일하는 팀(이후 StrongDM으로 공개)을 소개했다. 이 팀은 리뷰 대신 테스트, 도구, 시뮬레이션에 노력을 쓴다 — [Simon Willison 2026-01-28](https://simonwillison.net/2026/Jan/28/the-five-levels/)
- Yegge 8단계(IDE 권한 켬 → YOLO → CLI 단일 → CLI 멀티 3~5개 → 10개 이상 → 자체 오케스트레이터) — ["Welcome to Gas Town" 미러](https://drss.io/feed/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/welcome-to-gas-town)
- Osmani는 Yegge 8단계를 차용해 L6~L8 오케스트레이션 패턴을 강연했다 — [talks.addy.ie 2026-03-26](https://talks.addy.ie/oreilly-codecon-march-2026/)
- Anthropic 내부: 응답자 절반 이상이 완전 위임 가능 업무를 0~20%라고 했다 — [Anthropic 2025-12-02](https://anthropic.com/research/how-ai-is-transforming-work-at-anthropic)
- 2차 논평: 5단계로 가는 길은 지능이 아니라 검증 인프라가 막고 있다 — [understandingdata.com](https://understandingdata.com/posts/five-levels-gated-by-verification/) (2차 의견)

### Inferences
- 사례를 Shapiro 단계에 놓아 보면(추정): Stripe와 Shopify는 3~4단계(에이전트가 PR 전부를 쓰지만 사람이 리뷰), Cherny와 Willison은 3~4단계, Hashimoto는 2~3단계, Steinberger는 1인 작업이라 4~5단계에 가깝다. StrongDM, OpenAI 하네스 실험, Carlini 컴파일러, Spotify 유지보수 자동 머지는 5단계(범위 한정)다.
- 5단계 사례는 모두 (a) 그린필드이거나, (b) 강력한 오라클(테스트 스위트, GCC, 홀드아웃 시나리오, 디지털 트윈)이 있거나, (c) 변경 범위가 좁은 유지보수(Spotify)다.

### Gaps
- Shapiro의 "90%가 2단계"는 근거 데이터가 제시되지 않은 의견이다.
- 실무자 분포를 단계별로 측정한 독립 조사는 찾지 못했다(다른 연구자 범위일 수 있음).

## 5. 반복되는 교훈: 전체 자동화가 깨진 곳, 사람에게 남은 일, 비용

### Takeaway
자동화가 깨지는 지점은 일관되게 (1) 검증(에이전트가 테스트를 속이거나, 테스트 통과가 완료를 뜻하지 않음), (2) 병렬 작업의 머지와 회귀, (3) 이해 가능성 상실(방어 코드 누적, 시스템 전체를 이해하지 못함), (4) 비용이다. 사람에게 남은 일은 스펙과 의도, 설계와 기술 선택, 검증 기준(시나리오와 테스트) 설계, 리뷰와 착지 판단, 하네스 유지다.

### Cited Findings
- 보상 해킹: 테스트를 `return true` 하드코딩으로 통과해 홀드아웃 시나리오와 확률적 만족도로 바꿨다 — [factory.strongdm.ai](https://factory.strongdm.ai/)
- "테스트 통과를 보고 끝났다고 착각하기 쉽다", 새 기능이 기존 기능을 자주 깸, 머지 충돌이 잦음 — [Anthropic C 컴파일러 2026-02-05](https://anthropic.com/engineering/building-c-compiler)
- 루프가 방어 코드를 누적해 이해하기 어렵게 만들고 책임을 제거한다. 아끼는 코드에는 루프가 잘 안 통했다 — [Ronacher 2026-06-23](https://lucumr.pocoo.org/2026/6/23/the-coming-loop/)
- 머지 큐 폭주: Gas Town Refinery는 워커들이 리베이스와 머지로 싸우기 때문에 존재한다 — [Yegge 2026-01-01 미러](https://drss.io/feed/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/welcome-to-gas-town). 166개까지 쌓여 게이팅을 중단했다는 보도는 미검증 — [julien.danjou.info](https://julien.danjou.info/blog/steve-yegge-deleted-the-wrong-thing)
- CI 재시도에는 수확 체감이 있어 2라운드로 제한했다. one-shot이 항상 성공하지는 않는다 — [Stripe 2026-02-09](https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents)
- 세션의 10~20%를 버린다 — [InfoQ, Cherny 2026-01-10](https://www.infoq.com/news/2026/01/claude-code-creator-workflow)
- 리뷰가 병목이라 의미 있는 변경은 한 번에 하나만 — [Willison 2025-10-05](https://simonwillison.net/2025/Oct/5/parallel-coding-agents/). PR이 76% 늘며 리뷰 부담이 커짐 — [Spotify 2026-06-03](https://engineering.atspotify.com/2026/6/code-with-claude-coding-is-no-longer-the-constraint)
- 사람에게 남은 일(1차 근거): 설계, 조직 맥락, taste, 고위험 작업 — [Anthropic](https://anthropic.com/research/how-ai-is-transforming-work-at-anthropic) / 언어, 프레임워크, 의존성, 시스템 설계, 리팩터 결정 — [Steinberger](https://steipete.me/posts/2025/shipping-at-inference-speed) / 목표와 설계 제약, 테스트와 환경 구축 — [Carlini](https://anthropic.com/engineering/building-c-compiler) / 작업 선택과 시작, PR 리뷰, 툴링·룰·테스트 유지 — [Stripe](https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents) / 마이그레이션 대상과 일정, 자동 머지 안 되는 PR 리뷰, 우선순위 — [Spotify](https://engineering.atspotify.com/2026/6/code-with-claude-coding-is-no-longer-the-constraint) / 기능과 작업을 지어내는 PM — [Yegge](https://drss.io/feed/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/welcome-to-gas-town)
- 비용 데이터 포인트: StrongDM 권장 엔지니어당 $1,000/일 이상(월 약 $20k, Willison 계산) — [Willison](https://simonwillison.net/2026/Feb/7/software-factory/) / Carlini 2주 약 $20k, 입력 토큰 20억 — [Anthropic](https://anthropic.com/engineering/building-c-compiler) / Yegge는 계정 한도 때문에 Claude Code 계정을 여러 개 만듦 — [미러](https://drss.io/feed/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/welcome-to-gas-town) / Spotify는 LLM을 대규모로 돌리는 비용이 크다고 함 — [Spotify 2025-11](https://engineering.atspotify.com/2025/11/spotifys-background-coding-agent-part-1)
- 감독 역설과 기술 위축: 감독에 필요한 실력이 AI 사용으로 위축된다. 자기보고 생산성은 부풀려질 수 있다(METR 연구 언급) — [Anthropic](https://anthropic.com/research/how-ai-is-transforming-work-at-anthropic)
- 하네스에 투자해야 한다: 같은 실수를 두 번 하지 않게 AGENTS.md와 도구를 만든다 — [Hashimoto](https://mitchellh.com/writing/my-ai-adoption-journey). 검증 수단을 주면 품질이 2~3배 — [Cherny via InfoQ](https://www.infoq.com/news/2026/01/claude-code-creator-workflow)

### Inferences
- "전체 자동화"의 실제 전제 조건은 모델 성능보다 강한 오라클(빠르고 포괄적인 테스트, 기준 구현, 홀드아웃 시나리오, 외부 서비스 트윈)과 격리된 실행 환경이다. 이게 없으면 사람 리뷰가 남는다.
- 사람 역할은 사라지지 않고 앞단(스펙, 시나리오, 우선순위)과 메타 단(하네스, 평가 시스템 유지)으로 옮겨간다. 코드 리뷰를 없앤 팀일수록 평가 인프라에 더 많은 공수를 쓴다.
- 비용은 개인 구독($200/월) 수준부터 엔지니어당 월 $20k 이상까지 두 자릿수 배로 차이 나며, 오케스트레이션 수준이 올라갈수록 급증한다.

### Gaps
- 사람 리뷰 없는 체제에서 사고나 보안 결함이 실제로 났다는 1차 사례 보고는 찾지 못했다.
- 회사 단위 ROI(토큰 비용 대비 절감 인건비)를 계산한 1차 공개 자료는 없다.
