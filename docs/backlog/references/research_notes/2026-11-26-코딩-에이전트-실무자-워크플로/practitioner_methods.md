# 코딩 에이전트 실무자 워크플로 (방법 중심, 2026-11 기준)

조사일: 2026-11-26. 비교 대상: pstack(Lauren Tan, Cursor 스킬 묶음 — /poteto-mode, "사람에게 막히지 않기", 코드로 하는 계획, 작성자가 아닌 에이전트의 검증)과 j-dev-kit(/task create·start·end — 수용 기준이 있는 백로그 항목 → 워크트리 하위 세션 구현 → 별도 판정 에이전트 리뷰 → 사용자 승인 후 머지).

표기: [1차]는 본인 글·발표·저장소, [2차]는 제3자 요약·진행자 요약. 2026 이전 자료는 날짜를 붙였다. 인용은 몇 단어만 하고 나머지는 풀어 썼다.

## 1. 누구이고, 어떤 글·발표가 워크플로를 설명하나 (날짜)

### Takeaway
열 명 모두 공개 글이나 발표에서 방법을 밝혔지만, 2026년에 새로 낸 구체적 워크플로 글이 있는 사람은 Hashimoto(2026-02), Willison(2026, 가이드), Eugene Yan(2026-05), Shrivu Shankar(2026-06·08), Lauren Tan(2026-09 발표)이다. Huntley·Steinberger·Reed·Beck의 핵심 글은 2025년 것이고, 2026년 자료는 짧은 글·팟캐스트·유료 글이라 일부만 확인됐다.

### Cited Findings
- **Geoffrey Huntley** — 본인 소개 페이지가 그를 Ralph Wiggum Loop를 만든 사람으로 소개하고, 지금은 교육 플랫폼 Latent Patterns에 집중한다고 적는다 [1차] — [ghuntley.com/bio](https://ghuntley.com/bio). 핵심 글은 "Ralph" (2025-07-14) [1차] — [ghuntley.com/ralph](https://ghuntley.com/ralph/). 2026년 글 "nobody should type code by hand anymore"(날짜 미표기, 유료 구독 본문)는 Josh Wulf와 루프 엔지니어링을 다룬 4회 대담이다 [1차, 발췌만] — [ghuntley.com/agency](https://ghuntley.com/agency/). AI Engineer World's Fair 2026에서 루프 찬성 쪽으로 토론에 나섰다 [2차] — [Latent Space wiki](https://latent.space/wiki/geoffrey-huntley/).
- **Peter Steinberger** — 핵심 글 "Just Talk To It" (2025-10-14) [1차] — [steipete.me](https://steipete.me/posts/just-talk-to-it), "Shipping at Inference-Speed" (2025-12-28) [1차] — [steipete.me](https://steipete.me/posts/2025/shipping-at-inference-speed). 2026-02-14 글에서 OpenAI 합류와 OpenClaw 재단 이관을 알렸다 [1차] — [steipete.me/posts/2026/openclaw](https://steipete.me/posts/2026/openclaw). PSPDFKit 창업, Clawdbot→OpenClaw 제작, 1월 한 달 6,600+ 커밋은 진행자 요약 [2차] — [Pragmatic Engineer, 2026-01-28](https://newsletter.pragmaticengineer.com/p/the-creator-of-clawd-i-ship-code). 2026-06-07 "에이전트에 프롬프트하지 말고 루프를 설계하라"는 취지의 트윗이 널리 인용됐다는 것은 검색 요약으로만 확인 [2차] — [Addy Osmani, Loop Engineering](https://addyosmani.com/blog/loop-engineering/).
- **Mitchell Hashimoto** — "My AI Adoption Journey" (2026-02-05) [1차] — [mitchellh.com](https://mitchellh.com/writing/my-ai-adoption-journey). 앞선 사례 글 "Vibing a Non-Trivial Ghostty Feature"(페이지에서 날짜 미확인, 2025년 글로 알려짐) [1차] — [mitchellh.com](https://mitchellh.com/writing/non-trivial-vibing). Ghostty 저장소의 AI_POLICY.md(AI 사용 공개, 사람이 검증) [1차, 검색 발췌] — [AI_POLICY.md](https://raw.githubusercontent.com/ghostty-org/ghostty/main/AI_POLICY.md).
- **Armin Ronacher** — 2026 글 "The Coming Loop" (2026-06-23) [1차] — [lucumr.pocoo.org](https://lucumr.pocoo.org/2026/6/23/the-coming-loop/). 그 밖의 2026 글 "Astra for Coding"(2026-09-07), "What is Codemode"(2026-10-06), "Better Models: Worse Tools"(2026-07-04)는 제목·요약만 확인 [1차 목록] — [lucumr.pocoo.org](https://lucumr.pocoo.org/), [page 2](https://lucumr.pocoo.org/page/2/).
- **Simon Willison** — "Agentic Engineering Patterns" 가이드(원칙·에이전트와 일하기·테스트와 QA·코드 이해·주석 단 프롬프트·부록) [1차]. 장별 날짜는 페이지에 없고, 소개가 2026-02-23 글로 연결된다 — [guide](https://simonwillison.net/guides/agentic-engineering-patterns/).
- **Harper Reed** — 핵심 글 "My LLM codegen workflow atm" (2025-02-16)과 "An LLM Codegen Hero's Journey" (2025-04-17), "Basic Claude Code" (2025-05-08) [1차] — [Willison 링크 요약](https://simonwillison.net/2025/Feb/21/my-llm-codegen-workflow-atm/), [harper.blog](https://harper.blog/2025/04/17/an-llm-codegen-heros-journey/), [harper.blog](https://harper.blog/2025/05/08/basic-claude-code/). 2026 글은 "Remote Claude Code"(2026-01-05, 제목만 확인), "Why Don't My Agents Break Containment?"(2026-09-22) [1차] — [harper.blog 목록](https://harper.blog/posts/), [break-away](https://harper.blog/2026/09/22/break-away/). 회사 2389의 코드 약 80%를 AI가 만든다는 것은 인터뷰 요약 [2차] — [TWiT](https://twit.tv/posts/tech/ai-coding-partner). 2026-07-09 Startupfest 세션 "Building a Dark Factory Code Generator" 목록만 확인 [2차] — [startupfest](https://startupfest.com/session/2033/life-in-the-fast-lane-building-a-dark-factory-code-generator).
- **Kent Beck** — "Augmented Coding: Beyond the Vibes" (2025-06-25) [1차] — [newsletter.kentbeck.com](https://newsletter.kentbeck.com/p/augmented-coding-beyond-the-vibes). 2026 글 "Is Source Code Going Away?"(2026-02-06), "Smalltalk Genie"(2026-06-21) 등은 유료라 제목·미리보기만 확인 [1차, 발췌] — [newsletter.kentbeck.com/t/genies](https://newsletter.kentbeck.com/t/genies).
- **Eugene Yan** — "How to Work and Compound with AI" (2026-05-03) [1차] — [eugeneyan.com](https://eugeneyan.com/writing/working-with-ai/). 2025-10 "Advice for New Principal Tech ICs"에서 Amazon 경력을 언급 [1차 목록] — [eugeneyan.com/writing](https://eugeneyan.com/writing/).
- **Shrivu Shankar** — "How I use AI in 2026" (2026-08-17) [1차] — [blog.sshh.io](https://blog.sshh.io/p/how-i-use-ai-in-2026-coding-writing), "Designing Software for Software Factories" (2026-06-13) [1차] — [blog.sshh.io](https://blog.sshh.io/p/designing-software-for-software-factories). 회사 블로그에 "Our Design Docs Write Themselves"(2026-03-02, 마크다운·Zoom 봇·Claude Code SDK로 설계 리뷰 대체)를 썼다(제목·요약만) — [blog.sshh.io/archive](https://blog.sshh.io/archive).
- **Lauren Tan** — AI Engineer 연사 페이지: React Compiler 코어 팀, Netflix 약 4년, Meta에서 RSC 프로토타입, React Compiler 1.0 공동 발표(2025-10), Grok Bot·Dune(Electron 클라이언트 프레임워크), pstack은 2026-05 Cursor 공개 플러그인 모음에 추가. 소속은 "SpaceX Super Intelligence"로 표기 [1차에 가까운 행사 페이지] — [ai.engineer](https://ai.engineer/speakers/lauren-tan). 발표 "how i shipped 2,500 PRs last month to production"(2026-09, X 영상 약 38분, 원래 Cursor Compile London용) — [X 게시물](https://x.com/poteto/status/2102050467505430555), 요약은 [2차] [redreamality](https://redreamality.com/blog/lauren-tan-poteto-trust-before-parallel/). Matt Pocock 인터뷰 "Poteto on shipping 1,000 PRs a month"(2026-10-03)와 본인 가이드 Part 1·2(2026-08-31, 2026-09-10)는 제3자 글에서 언급만 확인 [2차] — [barnabyrobson.org](https://barnabyrobson.org/on-pstack/). 또 다른 발표 "All Code Is Slop (Except Mine)"(17분, 날짜 미표기) — [ai.engineer](https://ai.engineer/speakers/lauren-tan).

### Inferences
- 2026년의 공통 주제는 "루프"(Huntley, Steinberger 트윗, Ronacher, Shrivu)와 "검증이 자율을 산다"(Hashimoto, Yan, Tan, Willison)다.
- 2026년 글이 얇은 사람(Reed, Beck, Huntley)은 2025년 방법이 아직 대표 방법으로 인용된다. 비교할 때는 2025년 방법임을 표시해야 한다.

### Gaps
- Ronacher·Willison·Beck·Hashimoto의 경력(Flask·Sentry, Django·Datasette, XP·TDD, HashiCorp·Ghostty)은 이번 조사에서 1차 소개 페이지를 따로 열어 확인하지 않았다. 널리 알려진 사실이지만 출처를 붙이려면 각자의 about 페이지를 확인해야 한다.
- Eugene Yan의 현재 소속은 글에 나오지 않는다.
- Ronacher의 2025-06 "Agentic Coding Recommendations"와 Pi 하네스 관련 글은 열어 보지 못했다.
- Lauren Tan의 PR 수(2,500 / 약 2,000 / 1,000)는 출처마다 다르고 감사된 수치가 아니다 [2차].

## 2. 흐름: 시작, 스펙·계획과 사람의 승인, 위임·병렬, 검증·리뷰·머지

### Takeaway
"계획을 사람이 승인하고 그다음은 길게 혼자 돌린다"(Shrivu, Huntley, Reed, Yan)와 "대화로 조금씩 키우고 계속 조종한다"(Steinberger, Ronacher, Beck, Hashimoto 초기)로 갈린다. 리뷰는 사람이 diff를 읽는 쪽(Willison, Beck, Ronacher, Hashimoto)과 검증 도구·에이전트가 대신하고 사람은 결과·하이라이트만 보는 쪽(Tan, Shrivu, Steinberger)으로 갈린다.

### Cited Findings
- **Huntley (2025-07)**: 요구사항을 에이전트와 길게 대화한 뒤 스펙을 파일 하나에 하나씩 `specs/`에 쓰게 하고, 우선순위 TODO를 `fix_plan.md`에 둔다. 루프마다 가장 중요한 항목 하나만 한다. 메인 컨텍스트는 스케줄러이고 검색·쓰기는 서브에이전트가 병렬로 하되 빌드·테스트는 하나만 돌린다. 테스트가 통과하면 계획을 갱신하고 커밋·푸시하고 태그를 단다. 사람은 루프를 지켜보다 나쁜 패턴이 보이면 프롬프트에 "signs"를 더하고, 망가지면 `git reset --hard` 후 재시작한다. 그린필드용이며 시니어의 지도가 필요하다고 한다 — [ghuntley.com/ralph](https://ghuntley.com/ralph/). 2026 발췌: 처방은 "Delete your skill packs, put the whole system under test" — [ghuntley.com/agency](https://ghuntley.com/agency/).
- **Steinberger (2025-10)**: 3x3 터미널 격자에 3~8개 에이전트를 같은 폴더에서 돌린다. 워크트리·PR을 써 봤지만 같은 폴더가 가장 빠르다며 돌아왔다. 변경 크기("blast radius")를 파일 수·시간으로 가늠해 작게 유지하고, 에이전트는 자기가 고친 파일만 커밋한다. 대부분 대화 후 바로 만들고, 까다로운 기능만 스펙을 쓰게 해 다른 모델로 검토한다. 큰 사전 스펙에서 멀어졌다. 리뷰는 GitHub 리뷰 봇 위주, `/automerge`·`/massageprs` 명령을 쓴다. 시간의 약 20%는 에이전트로 리팩터링하는 날 — [Just Talk To It](https://steipete.me/posts/just-talk-to-it). (2025-12) main에 바로 커밋하고 워크트리를 피하며, 대부분의 코드를 읽지 않고 출력 흐름을 본다. 계획은 대화로 만들고 "build"라고 하거나 docs에 계획을 쓰게 한다. plan mode는 옛 모델용 우회책으로 본다. CLI를 실행해 출력 확인으로 "closes the loop" — [Shipping at Inference-Speed](https://steipete.me/posts/2025/shipping-at-inference-speed). 2026-01 진행자 요약: 5~10개 병렬, 코드 리뷰 대신 아키텍처 토론, PR을 "prompt requests"로 본다 [2차] — [Pragmatic Engineer](https://newsletter.pragmaticengineer.com/p/the-creator-of-clawd-i-ship-code).
- **Hashimoto (2026-02)**: 아침에 전날 밤 트리아지 에이전트 보고서를 보고 에이전트가 잘 풀 이슈를 골라 백그라운드로 돌린다. 막연한 요청은 계획 세션과 실행 세션을 나눈다. 하루 마지막 30분에 에이전트를 띄우기 시작했고, 목표는 늘 에이전트 하나가 도는 것(하루의 10~20% 달성). 여러 개를 동시에 돌리는 건 원치 않고 느리고 신중한 모델을 선호한다. 트리아지 에이전트는 보고서만 쓰고 GitHub에 답하지 못한다 — [my-ai-adoption-journey](https://mitchellh.com/writing/my-ai-adoption-journey). (2025) 직접 쓴 대략의 계획 → 코드 없이 "Create a plan" 세션 → `spec.md` 저장 → 작은 범위 구현 → "anti-slop" 정리 세션 → 마지막에 무엇이 빠졌는지 묻는 세션 → 꼼꼼한 수동 리뷰. "not shipping code I don't understand" — [non-trivial-vibing](https://mitchellh.com/writing/non-trivial-vibing).
- **Ronacher (2026-06)**: 에이전트 루프(모델이 끝났다고 할 때까지)와 하네스 루프(하네스가 끝을 정함)를 나누고, 오래 남을 코드에는 후자를 회의적으로 본다. 실험·측정·성능 튜닝·보안 스캔·기계적 변환·포팅(MiniJinja→Go 성공)에는 루프를 쓴다. 보통 작업 중에 계속 조종하고, 모델이 끝났다고 하면 리뷰한다 — [The Coming Loop](https://lucumr.pocoo.org/2026/6/23/the-coming-loop/).
- **Willison (2026 가이드)**: "Use red/green TDD" 한 줄로 테스트 먼저 쓰고 실패를 확인한 뒤 구현하게 한다 — [red-green-tdd](https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/). 자동 테스트 외에 에이전트가 직접 실행해 보는 "agentic manual testing"(python -c, curl, Playwright, 본인 도구 Rodney), 여기서 찾은 버그는 red/green TDD로 영구 테스트화 — [agentic-manual-testing](https://simonwillison.net/guides/agentic-engineering-patterns/agentic-manual-testing/). 첫 리뷰는 본인 몫이고, 검토 안 한 PR을 동료에게 넘기는 것을 반패턴으로 꼽는다. 작은 PR 여러 개가 큰 PR 하나보다 낫다 — [anti-patterns](https://simonwillison.net/guides/agentic-engineering-patterns/anti-patterns/). 가이드 목차에 "Parallel subagents", "compound engineering loop" 절이 있다(본문 미확인) — [guide](https://simonwillison.net/guides/agentic-engineering-patterns/).
- **Reed (2025-02~04)**: 대화형 LLM으로 스펙 브레인스토밍 → 계획 → 작은 단계로 실행, 계획과 실행을 다른 컨텍스트로 나눈다. "spec is the godhead"라는 요지는 2차 요약으로 확인 — [Willison 링크](https://simonwillison.net/2025/Feb/21/my-llm-codegen-workflow-atm/), [검색 요약 기반](https://harper.blog/2025/04/17/an-llm-codegen-heros-journey/). 2026-09 글은 턴 제한 없는 자기수정 에이전트 실험이며 Firecracker VM "observatory"로 행동을 감사한다 — [break-away](https://harper.blog/2026/09/22/break-away/).
- **Beck (2025-06)**: `plan.md`에 테스트를 순서대로 적고, "go"라고 하면 다음 미표시 테스트 하나를 구현하고 통과할 만큼만 코드를 쓴다. 시스템 프롬프트로 TDD와 Tidy First(구조 변경과 동작 변경을 한 커밋에 섞지 않음), 모든 테스트 통과 시에만 커밋을 지시. 중간 결과를 지켜보다 개입하고 다음 테스트를 직접 제안한다. 코드 자체(복잡도·테스트·커버리지)를 본다 — [Beyond the Vibes](https://newsletter.kentbeck.com/p/augmented-coding-beyond-the-vibes).
- **Eugene Yan (2026-05)**: 의도·제약·성공 기준을 먼저 정하고 에이전트가 끝까지 돌게 한다. "You can't delegate what you can't verify". 3~6개 세션을 동시에 돌리고 같은 저장소면 git worktree를 쓴다. 새 컨텍스트의 두 번째 세션이 실행 이탈을 자주, 방향 이탈을 가끔 점검("models watch models") — [working-with-ai](https://eugeneyan.com/writing/working-with-ai/).
- **Shrivu (2026-08)**: 손으로 한 문단짜리 CONCEPT.md(가상의 HN 제목, 논지, 느슨한 제약) → 모델이 빈틈을 찾고 질문하며 확장 → TECH_PLAN.md(예산·호스팅·키 포함) → "Build and verify TECH_PLAN.md" 한 번. 승인은 빌드 전에만 하고, 4~48시간 auto 모드로 중간 체크포인트 없이 돌린다. 오전 7시·오후 9시쯤 1~10개 터미널을 띄운다. 결과가 틀리면 버리고 CONCEPT.md에 제약을 더한다. 리뷰는 파일 트리·진입점 정도, 핵심 알고리즘은 .html 설명을 요청, "cheating"이 의심될 때만 코드를 판다. 커스텀 스킬·플러그인 없이 바닐라 Codex·Claude Code — [How I use AI in 2026](https://blog.sshh.io/p/how-i-use-ai-in-2026-coding-writing). (2026-06, 팀 차원) 원 요청·버그 리포트를 바로 받는 "소프트웨어 팩토리", 여러 요청 동시 처리, 테스트를 에이전트가 오르는 보상 함수로 취급, 사람은 원시 diff가 아니라 계약·테스트 산출물에서 뽑은 하이라이트를 리뷰, 서브에이전트가 계약 준수를 먼저 승인, PR이 핵심 사람 체크포인트 — [software factories](https://blog.sshh.io/p/designing-software-for-software-factories).
- **Lauren Tan (2026-09 발표·글)**: 처리량은 에이전트 수가 아니라 신뢰에서 나오며, 신뢰 없이 여러 개를 열면 쓰레기 PR 더미가 된다. 처음엔 대화 1~5개만 지켜봤다 [2차 요약] — [redreamality](https://redreamality.com/blog/lauren-tan-poteto-trust-before-parallel/). "I do plan, but... through code", 긴 추상 계획은 "illusion of progress". "executive chef"가 "cooks" 서브에이전트에 위임. fuzz 스웜이 통과하면 봇이 알리고 리베이스한 뒤 1시간 뒤 자동 머지(그녀가 변경을 요청하지 않으면). 리뷰는 머지 뒤 아침 커밋 읽기와 되돌리기로 한다는 해석 [2차] — [barnabyrobson](https://barnabyrobson.org/on-pstack/). 검증 스킬은 재현 가능한 CLI와 저장소의 "feature map"으로 앱을 띄워 직접 확인한다(정확성은 증명하지만 성능·코드 품질은 아님) [2차] — [redreamality](https://redreamality.com/blog/lauren-tan-poteto-trust-before-parallel/), [ai.engineer](https://ai.engineer/speakers/lauren-tan).

### Inferences
- j-dev-kit의 "항목 작성(수용 기준) → 구현 → 별도 판정 → 사용자 승인 머지"는 Shrivu(계획 승인 후 장시간 자율)와 Yan(성공 기준 먼저, 다른 세션이 점검)에 가장 가깝다. Tan은 머지 승인마저 시간 지연 자동 머지로 바꿨고, Steinberger는 워크트리·PR 없이 main에 바로 넣는다.
- 워크트리 사용은 갈린다: Yan은 쓰고, Steinberger는 버렸다(같은 폴더 + 작은 blast radius + 자기 파일만 커밋으로 충돌 관리).
- 계획 형태도 갈린다: 문서 계획(Huntley specs/fix_plan, Hashimoto spec.md, Beck plan.md, Shrivu TECH_PLAN.md) 대 코드로 계획(Tan 프로토타입·README 먼저, Steinberger 대화).

### Gaps
- Willison의 병렬 서브에이전트·compound engineering 절, "First run the tests" 본문은 읽지 못했다.
- Reed의 2026년 코딩 흐름이 2025년 스펙→계획→실행에서 바뀌었는지 1차 자료로 확인하지 못했다(dark factory 세션은 목록만).
- Huntley 2026 글은 유료라 스펙·계획 구조의 변화를 확인하지 못했다.

## 3. 언제 에이전트가 물어야 하나, 묻지 않게 하려고 무엇을 하나

### Takeaway
대부분 "질문은 계획 단계에 몰아서, 실행 중엔 묻지 않게"다. 그 수단은 사전 답변이 든 계획 문서(Shrivu, Huntley), 되돌릴 수 있는 일은 진행하라는 원칙(Tan), 알림을 끄고 사람이 확인 시점을 정하기(Hashimoto), 자동 검증(모두)이다. 반대로 Beck·Ronacher는 사람이 계속 지켜보고 개입하는 것을 방법으로 삼는다.

### Cited Findings
- **Shrivu**: 질문은 CONCEPT.md를 확장하는 계획 단계에서 "ask me questions"로 받는다. 빌드는 계획이 충분히 명확해 체크포인트가 필요 없게 하고, 중간 산출물을 함께 보는 것을 반패턴으로 본다. 원격 제어도 잘 안 쓴다 — [blog.sshh.io](https://blog.sshh.io/p/how-i-use-ai-in-2026-coding-writing). 팀 팩토리에서 사람을 부르는 곳은 루프 중단(off-ramp)·수동 개발 전환, 머지 전·컴플라이언스 리뷰, 계약 설계뿐이고, 테스트 배포에 사람을 끼우지 말라고 한다 — [software factories](https://blog.sshh.io/p/designing-software-for-software-factories).
- **Lauren Tan**: pstack 원칙은 되돌릴 수 있는 일에서 "should I do X?"를 묻고 싶을 때 진행하고 결과를 보여 준 뒤 사람이 고치게 하라는 것 [2차, 카탈로그 요약] — [barnabyrobson](https://barnabyrobson.org/on-pstack/). 시작 전에 에이전트가 문제를 쉬운 말로 다시 말하게 한다("Restate in your own words") — 같은 출처. 반복 실수는 코드 검사로 바꿔 에이전트가 리뷰어보다 먼저 오류를 받게 한다(Dune의 의존성 검사) — [ai.engineer](https://ai.engineer/speakers/lauren-tan).
- **Steinberger**: "let's discuss", "give me options"라고 쓰면 모델이 승인을 기다린다. 자리를 비울 땐 "continue" 메시지를 큐에 넣는다. 멈출 땐 Esc 후 상태를 묻는다 — [Just Talk To It](https://steipete.me/posts/just-talk-to-it). 장시간 작업에 Codex를 고르는 이유로 Claude Code가 확인 질문으로 멈추는 것이 산만하다고 한 것은 진행자 요약 [2차] — [Pragmatic Engineer](https://newsletter.pragmaticengineer.com/p/the-creator-of-clawd-i-ship-code). 막히면 모델이 스스로 GPT-5 Pro "oracle" CLI를 부르기도 한다 — [Shipping at Inference-Speed](https://steipete.me/posts/2025/shipping-at-inference-speed).
- **Hashimoto**: 데스크톱 알림을 꺼서 언제 끼어들지 본인이 정하고, 자연스러운 쉬는 틈에 확인한다 — [my-ai-adoption-journey](https://mitchellh.com/writing/my-ai-adoption-journey).
- **Eugene Yan**: Stop 훅 소리·tmux 상태 이모지·상태 줄로 어떤 세션이 주의가 필요한지 보고, 휴대폰 원격 제어는 급할 때만. 전역 CLAUDE.md에 확신 없으면 추측 말고 말하라, 내 접근에 문제 있으면 반박하라고 적는다 — [working-with-ai](https://eugeneyan.com/writing/working-with-ai/).
- **Huntley (2025-07)**: 사람이 묻는 대상이 아니라 루프를 관찰하는 조율자다. 묻지 않게 하는 장치는 스펙 파일, 프롬프트의 "signs", 백프레셔(빌드·테스트·타입 검사·정적 분석)다 — [ghuntley.com/ralph](https://ghuntley.com/ralph/).
- **Beck (2025-06)**: 오히려 지켜보다 루프, 요청 안 한 기능, 테스트 삭제·비활성화 같은 속임수가 보이면 끼어든다 — [Beyond the Vibes](https://newsletter.kentbeck.com/p/augmented-coding-beyond-the-vibes).
- **Ronacher**: 아끼는 코드에는 계속 관여하고 이해를 유지하길 원하며, 루프가 사람의 책임을 깎는 것을 "very uneasy"하게 본다 — [The Coming Loop](https://lucumr.pocoo.org/2026/6/23/the-coming-loop/).
- **Reed (2026-09)**: 턴 제한을 없앴고(토큰이 귀했을 때의 장치라고 봄), 대신 자기 하드웨어·격리 VM과 감사용 observatory로 가둔다. SSH 키 포워딩 실수로 다른 머신에 닿을 수 있었다는 사례를 든다 — [break-away](https://harper.blog/2026/09/22/break-away/).

### Inferences
- j-dev-kit 백로그 016("사람에게 묻는 곳을 꼭 필요한 것만 남기고 계획 승인을 없앤다")과 가장 가까운 근거는 Shrivu(사람 체크포인트를 계약 설계·머지 전 리뷰·중단으로 제한)와 Tan(되돌릴 수 있으면 진행)이다. 단 Shrivu는 계획 승인을 없애지 않고 빌드 전 한 번으로 몰았다는 점이 다르다.
- "질문을 계획 단계로 몰기"는 항목 작성(create) 때 질문을 다 받고 start 이후엔 묻지 않는 구조로 옮길 수 있다.

### Gaps
- Willison 가이드에서 에이전트가 언제 물어야 하는지 다룬 부분은 찾지 못했다.
- Tan의 "never block on the human"을 본인이 발표에서 어떻게 말했는지는 2차 요약으로만 확인했다.

## 4. 결정과 진행을 어디에 남기나

### Takeaway
공통 기록 장소는 저장소 안의 마크다운(AGENTS.md/CLAUDE.md, specs, plan, docs/)이다. 실수가 생길 때마다 AGENTS.md나 도구를 고치는 "harness engineering"(Hashimoto), "scar tissue"(Steinberger), 실수를 코드 검사로 승격(Tan)이 같은 생각이다. Tan과 Huntley는 계획을 일회용으로 보고 지운다.

### Cited Findings
- **Hashimoto**: 에이전트가 실수할 때마다 AGENTS.md를 고치거나 도구를 만들어 재발을 막는다("harness engineering"). 스크린샷 스크립트·필터한 테스트 러너처럼 스스로 확인할 수단을 준다 — [my-ai-adoption-journey](https://mitchellh.com/writing/my-ai-adoption-journey). 세션 사이엔 `spec.md`, 에이전트가 읽을 코드 문서, Amp 세션 스레드에 의존 — [non-trivial-vibing](https://mitchellh.com/writing/non-trivial-vibing).
- **Steinberger**: 약 800줄 AGENTS.md를 모델이 썼고 "organizational scar tissue"라 부른다(git 규칙, 제품 맥락, 이름·API 패턴, 마이그레이션, 테스트, ast-grep 규칙, 텍스트 디자인 시스템). 대문자 명령은 피한다 — [Just Talk To It](https://steipete.me/posts/just-talk-to-it). 프로젝트마다 docs 폴더, 전역 AGENTS 파일과 docs 목록 스크립트로 관련 문서를 읽게 하고, "write docs to docs/*.md"로 남긴다 — [Shipping at Inference-Speed](https://steipete.me/posts/2025/shipping-at-inference-speed).
- **Huntley (2025-07)**: `specs/`(파일당 스펙 하나), `fix_plan.md`(자주 지우고 다시 생성), `AGENT.md`(빌드·실행 방법과 짧은 교훈을 Ralph가 갱신), 테스트에 목적을 적어 다음 루프가 이유를 알게 함, 커밋과 git 태그 — [ghuntley.com/ralph](https://ghuntley.com/ralph/). 2026 발췌: 첫 루프 개념은 파일시스템을 상태로 쓰는 것 — [ghuntley.com/agency](https://ghuntley.com/agency/).
- **Beck**: `plan.md`의 테스트 목록에 표시하며 진행, 작은 커밋과 구조·동작 커밋 분리 — [Beyond the Vibes](https://newsletter.kentbeck.com/p/augmented-coding-beyond-the-vibes).
- **Willison**: Showboat로 테스트 세션을 마크다운으로 남긴다. `note`·`exec`·`image` 세 명령 중 `exec`가 실제 실행과 출력을 기록해 바라는 결과를 지어내기 어렵게 한다. PR에 수동 테스트 방법 메모·스크린샷·영상을 증거로 붙이라고 한다 — [agentic-manual-testing](https://simonwillison.net/guides/agentic-engineering-patterns/agentic-manual-testing/), [anti-patterns](https://simonwillison.net/guides/agentic-engineering-patterns/anti-patterns/).
- **Eugene Yan**: 프로젝트별 `INDEX.md`(관련 문서·채널, 담당자, 언제 읽을지), 신입 온보딩 문서 같은 프로젝트 CLAUDE.md, 전역 `~/.claude/CLAUDE.md`는 "behavioral contract". 너무 길면 쪼개고 `@import` 대신 필요할 때 읽게 한다. 결정은 공유 문서·PR·작업 로그 채널에, 큰 작업 뒤 갱신. 세션 기록에서 교정 표현을 캐서 CLAUDE.md·스킬·검증의 빈틈을 찾고, 규칙은 한 곳에만 있게 주기적으로 정리. 주 1회 이상 하는 일은 스킬로 만들고 SKILL.md를 직접 고치기보다 세션 교정으로 다듬는다 — [working-with-ai](https://eugeneyan.com/writing/working-with-ai/).
- **Shrivu**: 제약은 CONCEPT.md에 쌓이고, 각 프로젝트의 이력이 새 모델을 재는 eval이 된다 — [How I use AI in 2026](https://blog.sshh.io/p/how-i-use-ai-in-2026-coding-writing). 팀 차원에선 방향·검증 방법·검증 못 하는 것을 적은 안정적인 마크다운 계약(AGENTS.md 등), 리뷰 지적은 묶어서 계약과 코드에 되먹임 — [software factories](https://blog.sshh.io/p/designing-software-for-software-factories).
- **Lauren Tan**: "The best rules are in your code" — 교정 순서는 아키텍처·타입 → 린트·테스트 → diff 리뷰 순. `/show-me-your-work`가 리뷰어가 볼 로그에 행을 추가하고, 계획은 작업이 들어가면 지운다(해석 포함) [2차] — [barnabyrobson](https://barnabyrobson.org/on-pstack/). 교정을 강한 층(코드베이스·정적 분석)에 넣을수록 누가 프롬프트를 기억할 필요가 줄어든다 [2차] — [redreamality](https://redreamality.com/blog/lauren-tan-poteto-trust-before-parallel/).

### Inferences
- j-dev-kit의 백로그 항목 파일은 Huntley의 `specs/`+`fix_plan.md`, Beck의 `plan.md`와 같은 역할이지만, 이들은 진행 표시를 같은 파일에 계속 갱신한다. 항목에 진행·결정 로그 줄을 남기는 방식(Tan의 `/show-me-your-work`, Willison의 Showboat)이 리뷰어 판정의 근거가 될 수 있다.
- "실수 → 규칙 파일 갱신"은 모두 하지만, Tan·Hashimoto는 가능하면 도구·검사로 승격하라고 한다. 리뷰 지적이 반복되면 CLAUDE.md보다 검증 스크립트(check-repo-rules.sh 같은)로 옮기는 게 이들의 순서와 맞다.

### Gaps
- Ronacher·Reed의 결정 기록 방식은 이번 자료에 없다.

## 5. 무엇이 독특하고, 백로그 항목 기반 Claude Code 플러그인이 무엇을 빌릴 수 있나

### Takeaway
빌릴 만한 것은 (1) 질문을 항목 작성 때 몰아 받고 실행은 길게 혼자 돌리기(Shrivu), (2) 항목마다 "증명 방법"과 실행 기록을 남기게 하기(Tan, Willison Showboat), (3) 반복 지적을 규칙이 아닌 검사로 승격(Tan, Hashimoto), (4) 루프마다 한 항목만, 백프레셔로 거르기(Huntley), (5) 판정은 새 컨텍스트 세션이 하기(Yan "models watch models"), (6) red/green TDD 한 줄 지시(Willison, Beck)다. 반대 증거도 있다: Steinberger는 워크트리·PR·사전 스펙을 버렸고, Ronacher는 아끼는 코드에 루프를 쓰지 않는다.

### Cited Findings
- **Huntley 고유점**: 순수 bash 루프 + 한 루프 한 항목 + 백프레셔 + 사람이 "signs"로 튜닝(기타 조율에 비유) — [ghuntley.com/ralph](https://ghuntley.com/ralph/). 빌릴 것: 구현 세션을 "가장 중요한 수용 기준 하나 → 검증 → 커밋"으로 반복, 구현 전 "이미 있는지 먼저 검색" 지시(같은 출처).
- **Steinberger 고유점**: 같은 폴더 다중 에이전트, blast radius 관리, 자기 파일만 커밋, MCP 대신 CLI(GitHub MCP가 "23k tokens"를 먹었다), 서브에이전트 대신 별도 창, 리팩터링 데이 — [Just Talk To It](https://steipete.me/posts/just-talk-to-it). 빌릴 것: 항목 크기를 blast radius로 잡기, 큐에 다음 지시 넣기.
- **Hashimoto 고유점**: 트리아지 에이전트(보고만, 쓰기 권한 없음)가 밤에 이슈를 걸러 아침에 사람이 고르는 흐름, "anti-slop" 정리 세션, 마지막 "무엇이 빠졌나" 세션 — [my-ai-adoption-journey](https://mitchellh.com/writing/my-ai-adoption-journey), [non-trivial-vibing](https://mitchellh.com/writing/non-trivial-vibing). 빌릴 것: `create --survey`에 해당하는 읽기 전용 트리아지, end 전에 "빠진 것 찾기" 단계.
- **Ronacher 고유점**: 루프를 쓸 곳(실험·측정·포팅·보안 스캔·기계적 변환)과 쓰지 않을 곳(오래 남는 핵심 코드)을 나눈다 — [The Coming Loop](https://lucumr.pocoo.org/2026/6/23/the-coming-loop/). 빌릴 것: 항목 유형에 따라 자율 수준을 다르게.
- **Willison 고유점**: 패턴을 짧은 지시어로 만들어 재사용("Use red/green TDD"), 에이전트 수동 테스트 + Showboat 증거, 리뷰 안 한 PR 금지 — [red-green-tdd](https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/), [agentic-manual-testing](https://simonwillison.net/guides/agentic-engineering-patterns/agentic-manual-testing/), [anti-patterns](https://simonwillison.net/guides/agentic-engineering-patterns/anti-patterns/). 빌릴 것: 구현 세션이 실행 명령·출력을 기록한 증거 파일을 남기고 판정 에이전트가 그걸 본다.
- **Reed 고유점 (2025)**: 스펙→계획→실행을 별도 컨텍스트로 — [Willison 링크](https://simonwillison.net/2025/Feb/21/my-llm-codegen-workflow-atm/). (2026) 턴 제한 없는 자율 + 격리·감사 — [break-away](https://harper.blog/2026/09/22/break-away/).
- **Beck 고유점 (2025)**: `plan.md` 테스트 목록 + "go", 구조/동작 커밋 분리, 경고 신호 3가지(루프, 요청 안 한 기능, 테스트 속임수) — [Beyond the Vibes](https://newsletter.kentbeck.com/p/augmented-coding-beyond-the-vibes). 빌릴 것: 판정 에이전트 점검표에 "요청 안 한 기능", "테스트 삭제·비활성화" 넣기.
- **Eugene Yan 고유점**: 검증 사다리(쓰기 시점 포맷·린트 훅 → eval·LLM 리뷰), 세션 기록에서 교정 표현 채굴, 디렉터리 단위 규칙 범위 — [working-with-ai](https://eugeneyan.com/writing/working-with-ai/). 빌릴 것: 항목에 성공 기준이 없으면 위임하지 않기, 판정은 새 컨텍스트로.
- **Shrivu 고유점**: CONCEPT.md → TECH_PLAN.md → 한 번의 "Build and verify", 사용자에게 보이는 단어 수 상한 같은 임의 제약, 틀리면 버리고 제약 추가, 핵심 알고리즘은 .html 설명으로 리뷰 — [How I use AI in 2026](https://blog.sshh.io/p/how-i-use-ai-in-2026-coding-writing). 팀 단위: 계약을 시험하려고 로드맵 다음 몇 항목을 조종 없이 만들게 해 본다, 사람은 diff 대신 하이라이트 리뷰 — [software factories](https://blog.sshh.io/p/designing-software-for-software-factories). 빌릴 것: end에서 사람에게 원시 diff 대신 수용 기준별 요약·증거를 보여 주기, 실패한 항목은 고치기보다 항목(제약)을 고쳐 다시 돌리기.
- **Lauren Tan 고유점 (pstack 밖)**: 신뢰를 먼저 쌓고 병렬은 나중, 교정을 강한 층에 넣는 순서, 저장소의 feature map + CLI로 하는 검증, fuzz 스웜 통과 후 1시간 지연 자동 머지, "Restate in your own words" [2차 위주] — [redreamality](https://redreamality.com/blog/lauren-tan-poteto-trust-before-parallel/), [barnabyrobson](https://barnabyrobson.org/on-pstack/). 첫 자동 운전 밤은 "very scary"였다는 말도 전해진다 — 같은 출처.

### Inferences
- pstack과 j-dev-kit의 공통점(작성자 아닌 에이전트의 검증)은 Yan·Shrivu·Tan이 뒷받침한다. 차이점(j-dev-kit의 사용자 승인 머지)은 Willison·Beck·Ronacher·Hashimoto 쪽이 뒷받침하고, Tan·Steinberger·Shrivu 개인 작업은 반대쪽이다.
- j-dev-kit이 빌리기 쉬운 순서: 판정 점검표 보강(Beck 경고 신호), 실행 증거 파일(Willison), 반복 지적의 검사 승격(Tan·Hashimoto), 질문을 create 단계로 몰기(Shrivu). 워크트리를 버리는 Steinberger 방식은 j-dev-kit 구조와 맞지 않는다.
- "계획 승인을 없앤다"(016)에 대해: Shrivu는 계획 승인을 유지하되 빌드 전 한 번으로 줄였고, Tan은 계획을 코드로 대신했고, Steinberger는 대화 중 "build" 한마디가 승인이다. 완전히 없앤 사례는 Tan(되돌릴 수 있는 일 한정)과 Huntley 루프(사람이 스펙만 씀) 정도다.

### Gaps
- Tan의 1차 글(가이드 Part 1·2)과 발표 원문을 직접 읽지 못해 "never block on the human"의 본인 표현과 예외 조건을 확인하지 못했다.
- Steinberger의 2026-06 루프 트윗 원문과 OpenAI 합류 뒤 방법 변화는 확인하지 못했다.
- 추가 실무자(Addy Osmani "My LLM coding workflow going into 2026", 2026-01-04 등)는 경력 확인과 본문 검토를 하지 않아 넣지 않았다 — [addyosmani.com](https://addyosmani.com/blog/ai-coding-workflow/).
