# 실무자가 만들어 쓰는 공개 스킬 스택 (2026-11-26 기준)

비교 대상: pstack(Lauren Tan, Cursor, 진입 스킬 /poteto-mode, 플레이북 22개, "사람을 기다리지 않는다", 머지 전 작성자가 아닌 에이전트가 검증)과 j-dev-kit(/task create·start·end, 수용 기준이 있는 백로그 항목 → 워크트리 하위 세션 구현 → 별도 판정 에이전트 리뷰 → 사용자 승인 후 머지).

조사 범위: obra/superpowers, EveryInc/compound-engineering-plugin, mattpocock/skills, addyosmani/agent-skills, humanlayer(RPI), trailofbits/skills(+claude-code-config), 추가로 garrytan/gstack. 저장소 지표는 2026-11-26 GitHub API(`api.github.com/repos/<owner>/<repo>`) 조회값이다. 원문은 raw.githubusercontent.com에서 직접 읽었다. 인용은 몇 단어 이내, 나머지는 의역이다.

## 질문 1. 누가 만들었나, 이력(1차 출처), 저장소 지표

### Takeaway
모두 이력이 1차 출처로 확인되는 개인이나 회사 팀이 만들었고, 2026년 11월에도 커밋이 이어지는 살아 있는 저장소다. 별 수로 보면 mattpocock/skills와 superpowers가 30만 개 이상으로 압도적이고, gstack과 addyosmani가 그 뒤를 잇는다. humanlayer는 회사 모노레포이고 trailofbits는 보안 전문 회사의 마켓플레이스라서 성격이 다르다.

### Cited Findings
- **obra/superpowers**: 별 326,931, 포크 29,000, 생성 2025-10-09, 마지막 push 2026-11-26, 최신 릴리스 v7.0.2(2026-11-03) — [GitHub API](https://api.github.com/repos/obra/superpowers); [RELEASE-NOTES](https://raw.githubusercontent.com/obra/superpowers/main/RELEASE-NOTES.md)
- Jesse Vincent: Request Tracker를 만들었고(1996), Perl 5 프로젝트 리드로 5.12·5.14를 냈다(2009–2011). K-9 Mail을 만들었고(2008, 이후 Mozilla가 넘겨받아 Thunderbird for Android가 됨), Keyboardio를 공동 창업했다. 지금은 Prime Radiant(2025) 창업자 겸 CEO다. 같은 소개 페이지 안에서 superpowers 설치 수가 "50만 이상"과 "100만 이상"으로 엇갈린다 — [blog.fsck.com/about](https://blog.fsck.com/about/)
- README는 만든 이를 Jesse Vincent와 Prime Radiant 사람들로 적고 기업용 상용 지원도 안내한다 — [README](https://raw.githubusercontent.com/obra/superpowers/main/README.md)
- **EveryInc/compound-engineering-plugin**: 별 26,240, 포크 2,057, 생성 2025-10-09, 마지막 커밋 2026-11-23, plugin.json 버전 3.38.3 — [GitHub API](https://api.github.com/repos/EveryInc/compound-engineering-plugin); [plugin.json](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/.claude-plugin/plugin.json)
- 관리자는 Kieran Klaassen과 Trevin Chow다. 스킬 38개를 14개 에이전트 호스트에서 돌린다 — [README](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/README.md)
- Kieran은 Every의 Cora(이메일 제품) GM이다(2025-12-11 기사 기준). Every는 사내 제품 다섯 개를 각각 주로 한 사람이 만들고 운영한다 — [every.to 기사(2025-12-11)](https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents). GitHub 프로필에는 현재 "Compound Engineer - Frontier Team @ Every"로 적혀 있고 Ruby/Rails 젬도 여럿 있다 — [github.com/kieranklaassen](https://github.com/kieranklaassen)
- **mattpocock/skills**: 별 333,150, 포크 28,019, 생성 2026-02-03, 마지막 커밋 2026-11-25 — [GitHub API](https://api.github.com/repos/mattpocock/skills)
- Matt Pocock: Total TypeScript를 만들었고 Vercel과 Stately 출신이며 AI Hero(aihero.dev)를 운영한다. 팔로워 57.2k, ts-reset(약 8.7k★)과 sandcastle(샌드박스 코딩 에이전트 오케스트레이션, 약 9.3k★)이 있다 — [github.com/mattpocock](https://github.com/mattpocock). README에는 뉴스레터 구독자가 약 6만 명이라고 적혀 있다 — [README](https://raw.githubusercontent.com/mattpocock/skills/main/README.md)
- **addyosmani/agent-skills**: 별 120,500, 포크 12,536, 생성 2026-02-15, 마지막 커밋 2026-11-24 — [GitHub API](https://api.github.com/repos/addyosmani/agent-skills)
- Addy Osmani: Google에 약 14년(2012–2026) 있으면서 Chrome DevEx 팀(DevTools, Lighthouse, Puppeteer 등)을 이끌었고, 2024년 12월부터는 Google Cloud AI DevEx 디렉터였다. 2026년에 Google을 떠나 Anthropic Member of Technical Staff로 Claude Code를 맡고 있다. 책으로 *Learning JavaScript Design Patterns*, *Beyond Vibe Coding*(2025) 등이 있다 — [addyosmani.com/bio](https://addyosmani.com/bio/)
- **humanlayer/humanlayer**: 별 12,962, 포크 1,096, 생성 2024-08-05, 마지막 커밋 2026-11-23. 지금은 에이전트 세션을 팀 단위로 조종하는 앱·데몬·클라우드를 담은 Turborepo 모노레포이고, RPI 스킬은 `apps/riptide-rpi-claude-plugin`(plugin.json 이름 `rpi`, 버전 0.50.0)에 있다 — [GitHub API](https://api.github.com/repos/humanlayer/humanlayer); [README](https://raw.githubusercontent.com/humanlayer/humanlayer/main/README.md); [RPI plugin.json](https://raw.githubusercontent.com/humanlayer/humanlayer/main/apps/riptide-rpi-claude-plugin/.claude-plugin/plugin.json)
- Dex Horthy 쪽: humanlayer.dev 블로그에 "Dex"가 쓴 글로 "12 Factor Agents"(2025-04-03), "Advanced Context Engineering for Coding Agents"(2025-08-29), "Open sourcing HumanLayer"(2026-10-23)가 있고, "HumanLayer is joining Factory"(2026-11-04, Dex & Kyle)라는 글도 목록에 있다. 블로그 목록에는 성 없이 "Dex"로만 적혀 있다 — [humanlayer.dev/blog](https://www.humanlayer.dev/blog)
- 2026-10-23에 HumanLayer 코어(데스크톱·웹 앱, 데몬, 클라우드 API, RPI 스킬, Linear CLI)를 Apache 2.0으로 공개했다 — [Open sourcing HumanLayer](https://www.humanlayer.dev/blog/open-sourcing-humanlayer)
- ACE-FCA 원문 저장소: 별 2,853, 생성 2025-08-29 — [GitHub API](https://api.github.com/repos/humanlayer/advanced-context-engineering-for-coding-agents)
- **trailofbits/skills**: 별 8,440, 포크 734, 생성 2026-01-14, 마지막 커밋 2026-11-12(push 2026-11-25). 보안 감사 회사 Trail of Bits가 만들었고 라이선스는 CC BY-SA 4.0이다 — [GitHub API](https://api.github.com/repos/trailofbits/skills); [README](https://raw.githubusercontent.com/trailofbits/skills/main/README.md)
- 자매 저장소 trailofbits/claude-code-config: 별 2,155, 생성 2026-02-04, 마지막 push 2026-08-24. 사내에서 쓰는 Claude Code 기본 설정, 훅, 명령을 담았다 — [GitHub API](https://api.github.com/repos/trailofbits/claude-code-config); [README](https://raw.githubusercontent.com/trailofbits/claude-code-config/main/README.md)
- **garrytan/gstack**(추가): 별 142,696, 포크 21,051, 생성 2026-03-11, 마지막 push 2026-11-26. 저자 Garry Tan은 README에서 자신을 Y Combinator President & CEO로 소개하고, 매일 쓰는 "software factory"라고 설명한다 — [GitHub API](https://api.github.com/repos/garrytan/gstack); [README](https://raw.githubusercontent.com/garrytan/gstack/main/README.md)
- 제외: gsd-build/get-shit-done(별 64,120, 마지막 push 2026-05-31)은 저자를 "TÂCHES"라는 이름으로만 밝혀 실명 이력을 1차 출처로 확인하지 못했다 — [GitHub API](https://api.github.com/repos/gsd-build/get-shit-done)

### Inferences
- 별 수는 실사용을 그대로 보여 주지 않는다. mattpocock/skills와 superpowers는 공식 Claude 플러그인 마켓플레이스에 올라가 있어 노출 효과가 크다.
- humanlayer는 2026년에 "명령 몇 개"에서 "팀용 제품 + RPI 플러그인"으로 바뀌었다. 예전에 많이 인용되던 `.claude/commands/`(research_codebase, create_plan, implement_plan)는 지금 트리에 없고, `.claude/skills/`와 별도 플러그인으로 옮겨졌다.

### Gaps
- 레이트 리밋 때문에 addyosmani, humanlayer, trailofbits, gstack의 PR·이슈 총수는 세지 못했다.
- "HumanLayer is joining Factory"(2026-11-04)는 본문 URL이 404여서 제목과 날짜만 확인했다. RPI 플러그인이 앞으로 어떻게 될지는 모른다.
- Dex의 성(Horthy)은 블로그 목록에서 확인되지 않았다. 내 배경지식과 2차 요약에 기댄 것이다.
- QRSPI(Question-Research-Spec-Plan-Implement)가 Dex의 2026년 개정이라는 설명은 2차 요약에만 있다([cussid-huaz 요약](https://cussid-huaz.github.io/agent-brain/concepts/ai/qrspi/)). humanlayer.dev 글 목록에서는 그런 제목을 찾지 못했다.

## 질문 2. 실사용 증거 (사용자 이슈·PR, 사용자 보고로 바뀐 릴리스)

### Takeaway
superpowers와 compound-engineering은 릴리스 노트와 changelog가 사용자 이슈 번호로 채워져 있어 실사용 증거가 가장 강하다. superpowers는 v7.0.1에서 브레인스토밍 질문이 귀찮다는 사용자 피드백(#2530)을 받고 블라인드 평가로 다시 다듬었다. gstack은 자기 스택이 버그 수정률을 올리지 않는다는 자체 실험 결과를 README에 적은 점이 눈에 띈다.

### Cited Findings
- superpowers PR은 약 1,400건, 열린 이슈는 372건이다. v7.0.2 노트의 거의 모든 항목이 "Thanks @… for the report" 형식으로 사용자 이슈 번호를 단다(예: Windows PowerShell 훅 #2189, Pi 캐시 문제 #2394) — [RELEASE-NOTES](https://raw.githubusercontent.com/obra/superpowers/main/RELEASE-NOTES.md); PR 수는 GitHub API pulls 페이지네이션으로 셈
- v7.0.1(2026-10-21)은 v7.0.0의 새 브레인스토밍 질문이 "annoying fast"하고 판에 박혔다는 사용자 보고(#2530)를 받아 다시 조정했다. v7.0.2는 블라인드 채점 대화에서 군더더기 질문이 41개에서 23개로 줄었다고 보고한다 — [RELEASE-NOTES](https://raw.githubusercontent.com/obra/superpowers/main/RELEASE-NOTES.md)
- 한 사용자 세션에서 컴팩션 후 스킬이 20,000자에서 잘려 SDD의 5라운드 제한이 사라졌고 수정이 18라운드까지 돌았다(#2481). 그래서 SKILL.md를 references/로 나누고 20,000바이트 크기 테스트를 넣었다 — 같은 출처
- 기여 정책: 메인테이너가 요청하지 않았는데 남의 이슈를 고치는 에이전트 작성 PR은 받지 않는다. 이슈·PR 템플릿에 사람이 쓴 200단어 이하 요약을 요구한다(v7.0.1, #2569) — 같은 출처
- compound-engineering PR은 약 1,582건, 열린 이슈는 83건이다. CHANGELOG 항목마다 이슈·PR 번호가 붙는다(예: proof 스킬의 HITL 리뷰 루프를 단방향 게시로 바꿈 #957, 2026-06-17) — [CHANGELOG](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/CHANGELOG.md)
- Every는 자기 제품(Cora 등)을 이 방식으로 만든다고 밝힌다(2025-12-11) — [every.to](https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents)
- mattpocock/skills PR은 약 225건, 열린 이슈는 253건이다. 저자는 `.agents` 디렉터리에서 그대로 가져온, 매일 쓰는 스킬이라고 설명한다 — [GitHub API](https://api.github.com/repos/mattpocock/skills); [README](https://raw.githubusercontent.com/mattpocock/skills/main/README.md)
- addyosmani/agent-skills: 열린 이슈 117건이다. README가 사용자 이슈 #361(스킬 하나만 설치하면 공용 references/가 빠지는 문제)을 직접 언급한다 — [README](https://raw.githubusercontent.com/addyosmani/agent-skills/main/README.md)
- trailofbits/skills: 열린 이슈 175건이다. "Trophy Case"에 이 스킬로 찾은 실제 버그(RustCrypto ML-DSA 서명 타이밍 사이드채널, constant-time-analysis 스킬)가 올라 있다 — [README](https://raw.githubusercontent.com/trailofbits/skills/main/README.md)
- trailofbits/claude-code-config는 명령(review-pr, fix-issue, merge-dependabot)을 `/insights`에 반복해서 나타난 수작업 흐름에서 뽑아냈다고 쓴다 — [README](https://raw.githubusercontent.com/trailofbits/claude-code-config/main/README.md)
- gstack: 2026년 11월 일상적인 GitHub 버그·기능 100개 실험에서 Claude Opus 5.5가 gstack을 깔았을 때 58개, 안 깔았을 때 99개 중 61개를 고쳐 이득이 없었다. 보안 수정 60개에서는 둘 다 29개였다 — [README](https://raw.githubusercontent.com/garrytan/gstack/main/README.md)
- ACE-FCA(2025-08 무렵): BAML(Rust 30만 줄) 버그 수정 PR을 약 1시간 만에 올려 다음 날 승인받았다. 3명 팀이 Opus에 월 평균 약 1.2만 달러를 쓴다. parquet-java 시도처럼 실패한 사례도 적었다 — [ace-fca.md](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/ace-fca.md)

### Inferences
- 사용자 보고를 반영하는 문화는 superpowers가 가장 체계적이다(이슈 번호, 감사 표기, 재현 시나리오 수치). j-dev-kit이 릴리스 노트에 "어떤 실패 보고 → 어떤 변경 → 측정 결과"를 적는 형식을 빌려 올 만하다.
- gstack의 "효과 없음" 공개는 스킬 스택이 모델의 원래 능력보다 프로세스, 증거, 안전장치 쪽에서 값을 낸다는 신호로 읽힌다.

### Gaps
- mattpocock, addyosmani, humanlayer RPI 플러그인의 릴리스 노트나 changelog 파일은 트리에서 찾지 못했다(addyosmani 트리에 CHANGELOG 없음). 사용자 보고가 어떻게 변경으로 이어지는지 추적하지 못했다.
- 실제 설치 수는 superpowers 저자 페이지의 엇갈린 수치 말고는 1차 출처가 없다.

## 질문 3. 흐름: 진입점, 계획·스펙과 승인 주체, 구현 주체, 검증·판정 주체, 리뷰, 머지

### Takeaway
공통 골격은 "의도 끌어내기 → 문서화된 설계·계획 → 하위 에이전트 구현 → 작성자가 아닌 에이전트의 리뷰 → 머지 선택"이다. 갈리는 지점은 세 가지다. 승인을 몇 번 받는지(superpowers는 설계 1회, addy `/build auto`는 계획 1회, CE `/lfg`는 브레인스토밍만, TOB fix-issue는 0회), 리뷰어를 하나로 둘지 여럿으로 둘지, 머지를 누가 하는지다. 머지를 에이전트가 직접 하는 스택은 드물다. 대부분 PR까지만 가거나 사용자에게 선택지를 내민다.

### Cited Findings
- **superpowers**: 스킬이 자동으로 걸린다. brainstorming(설계 문서를 쓰고 사람이 승인) → using-git-worktrees → writing-plans(2–5분짜리 작업, 정확한 경로·코드·검증 단계) → subagent-driven-development(작업마다 새 구현 하위 에이전트, 작업마다 리뷰) 또는 executing-plans(인라인 구현, 끝에 한 번 리뷰) → TDD → requesting-code-review → finishing-a-development-branch(머지/PR/유지/폐기 중 선택) — [README](https://raw.githubusercontent.com/obra/superpowers/main/README.md)
- 설계 문서는 `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`에 커밋하고, 사람이 승인하기 전에는 아무것도 만들지 않는다. v7.0.0부터 새 하위 에이전트가 "빌더 체크"를 맡아, 만들 사람 입장에서 아직 물어야 할 것을 뽑는다(스펙 리뷰어를 대체) — [brainstorming SKILL.md](https://raw.githubusercontent.com/obra/superpowers/main/skills/brainstorming/SKILL.md); [RELEASE-NOTES v7.0.0](https://raw.githubusercontent.com/obra/superpowers/main/RELEASE-NOTES.md)
- 계획은 `docs/superpowers/plans/YYYY-MM-DD-<feature>.md`에 저장하고, 사람에게 검토와 실행 방식 선택을 묻는다 — [writing-plans SKILL.md](https://raw.githubusercontent.com/obra/superpowers/main/skills/writing-plans/SKILL.md)
- v6.0.0(2026-06-16)의 SDD 판정 구조: 작업마다 리뷰어 하나가 diff를 한 번 읽고 스펙 준수와 품질 두 판정을 낸다. diff만으로는 확인할 수 없는 요구는 "can't verify from the diff"로 따로 표시한다. 마지막에 가장 강한 모델로 브랜치 전체를 한 번 리뷰한다. 리뷰어는 읽기만 하고, 컨트롤러가 리뷰어에게 무엇을 무시하라고 지시하는 것은 금지다. 모든 디스패치는 모델을 명시해야 한다 — [RELEASE-NOTES v6.0.0](https://raw.githubusercontent.com/obra/superpowers/main/RELEASE-NOTES.md)
- finishing은 정해진 선택지 3개(로컬 머지 / PR / 유지·폐기 계열)를 문구 그대로 내민다. 로컬 머지 뒤에는 머지 결과에서 테스트를 다시 돌리고, 실패하면 워크트리를 남겨 둔다 — [finishing SKILL.md](https://raw.githubusercontent.com/obra/superpowers/main/skills/finishing-a-development-branch/SKILL.md)
- **compound-engineering**: 기본 루프는 `/ce-brainstorm` → `/ce-plan` → `/ce-work` → `/ce-compound`다. 하나의 계획 산출물이 요구사항에서 구현 계획으로 자라며, 기본 위치는 `docs/plans/`다. `/ce-work`는 PR을 열기 전에 스스로 단순화와 리뷰를 거친다 — [README](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/README.md)
- `/lfg`(자율 모드)는 요청 종류로 경로를 고른다(계획 / ce-debug / ce-pov / ce-brainstorm 등). 순서는 작업원(work source) 확인 → ce-work(return-to-caller) → ce-simplify-code → ce-code-review(mode:agent, 계획 대비 검증) → 리뷰 수정 커밋 → 남은 지적을 PR 본문에 기록 → 필요할 때만 ce-compound → ce-test-browser → commit-push-pr → ce-babysit-pr로 CI 감시다. 머지는 허락이 없으면 하지 않는다 — [lfg SKILL.md](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/skills/lfg/SKILL.md); [README](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/README.md)
- ce-work에서는 호스트 오케스트레이터가 실제 변경을 확인하고, 권위 있는 검증과 정식 커밋을 직접 맡는다. 워커는 경계가 정해진 단위만 받는다. 다른 모델(cross-model)에게 구현을 맡기는 경로도 있다 — [ce-work SKILL.md](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/skills/ce-work/SKILL.md)
- ce-code-review는 변경의 위험에 맞춰 페르소나 리뷰어를 고르고 한꺼번에 병렬로 띄운다. 적대적 교차 모델 리뷰를 붙일 수 있고, 기본은 보고만 하며 push하지 않는다. 2025년 기사 시점에는 리뷰 하위 에이전트가 12개였다 — [ce-code-review SKILL.md](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/skills/ce-code-review/SKILL.md); [every.to](https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents)
- **mattpocock/skills**: `/grill-me`·`/grill-with-docs`(정렬 인터뷰) → `/to-spec`(대화를 스펙으로 만들어 이슈 트래커에 올림) → `/to-tickets`(막히는 관계가 있는 트레이서 불릿 티켓) → `/implement` 또는 `/implement-spec` → `/code-review`. 처음에 `/setup-matt-pocock-skills`로 이슈 트래커(GitHub/GitLab/로컬 파일)를 정한다 — [README](https://raw.githubusercontent.com/mattpocock/skills/main/README.md)
- implement-spec은 티켓을 작업 그래프로 보고, 준비된 프론티어마다 새 컨텍스트의 구현 하위 에이전트를 띄운다(각자 워크트리, `tdd` 스킬 호출). 끝난 작업은 "merger 하위 에이전트"가 통합 브랜치에 머지하고, 마지막에 `code-review` 지적을 새 구현 하위 에이전트 하나가 한꺼번에 고친다. 하위 에이전트끼리는 "context pointers"로만 소통한다 — [implement-spec SKILL.md](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/implement-spec/SKILL.md)
- code-review는 Standards 축(저장소 규칙 + Fowler 냄새 기준선)과 Spec 축(원래 이슈·스펙 준수)을 서로 다른 병렬 하위 에이전트로 나눠, 서로 컨텍스트를 오염시키지 않게 한다 — [code-review SKILL.md](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/code-review/SKILL.md)
- **addyosmani/agent-skills**: 수명주기 명령은 `/spec` → `/plan` → `/build` → `/test` → `/review` → `/ship`에 `/constraints`, `/webperf`, `/a11y`, `/code-simplify`를 더해 10개다 — [README](https://raw.githubusercontent.com/addyosmani/agent-skills/main/README.md)
- spec-driven-development은 `SPEC.md`를 쓰고 사람에게 승인을 요청한 뒤 그 턴을 즉시 끝낸다. 계획은 다음 턴에 승인된 뒤에야 시작한다. 계획은 `tasks/plan.md`, 할 일은 `tasks/todo.md`에 둔다 — [spec-driven-development SKILL.md](https://raw.githubusercontent.com/addyosmani/agent-skills/main/skills/spec-driven-development/SKILL.md)
- `/build auto`: 스펙이 있어야 하고, 깨끗한 기준선을 확인하고, 계획을 만든 다음 계획 승인 한 번을 유일한 사람 관문으로 둔다. "looks reasonable" 같은 애매한 답은 승인으로 치지 않는다. 그 뒤로는 작업마다 RED→GREEN→회귀→빌드→커밋을 반복한다 — [build.md](https://raw.githubusercontent.com/addyosmani/agent-skills/main/.claude/commands/build.md)
- `/ship`은 code-reviewer, security-auditor, test-engineer 세 페르소나를 한 턴에 병렬로 띄우고, 메인 에이전트가 GO/NO-GO와 롤백 계획으로 합친다 — [ship.md](https://raw.githubusercontent.com/addyosmani/agent-skills/main/.claude/commands/ship.md)
- **humanlayer RPI(2026 플러그인)**: 스킬은 create-research-questions → create-research → create-design-discussion → create-structure-outline → create-plan → implement-plan이고, 각 단계에 iterate-* 짝과 describe-pr, ci-commit, setup-worktree가 있다. 모든 스킬이 "사용자가 이름으로 부를 때만" 쓰인다 — [RPI 플러그인 트리·SKILL.md](https://raw.githubusercontent.com/humanlayer/humanlayer/main/apps/riptide-rpi-claude-plugin/skills/create-plan/SKILL.md); [README](https://raw.githubusercontent.com/humanlayer/humanlayer/main/apps/riptide-rpi-claude-plugin/README.md)
- create-research는 티켓 파일을 읽지 못하게 막는다. 연구가 만들 것에 끌려가지 않고 현재 코드베이스를 객관적으로 보게 하려는 것이고, 연구 질문 문서만 입력으로 받는다. 비슷한 질문끼리 묶어 2–6개 하위 에이전트로 나눈다 — [create-research SKILL.md](https://raw.githubusercontent.com/humanlayer/humanlayer/main/apps/riptide-rpi-claude-plugin/skills/create-research/SKILL.md)
- 산출물 사이 우선순위는 plan > structure outline > design discussion > research > ticket이다 — [create-plan SKILL.md](https://raw.githubusercontent.com/humanlayer/humanlayer/main/apps/riptide-rpi-claude-plugin/skills/create-plan/SKILL.md)
- implement-plan은 `implementer-agent` 하위 에이전트에게 Phase 하나씩 맡기고 자동 검증 후 멈추게 한다. 그 다음 사람에게 보고하고, 사람이 할 수동 확인 목록을 준 뒤 확인을 기다린다 — [implement-plan SKILL.md](https://raw.githubusercontent.com/humanlayer/humanlayer/main/apps/riptide-rpi-claude-plugin/skills/implement-plan/SKILL.md)
- ACE-FCA(2025-08): 사람은 연구와 계획을 읽는다. 저자는 계획 200줄은 읽어도 Go 코드 2,000줄은 매일 못 읽는다고 하고, 코드는 다 읽지 않되 테스트는 꼼꼼히 읽는다. 컨텍스트 사용률은 40–60%로 유지한다 — [ace-fca.md](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/ace-fca.md)
- **trailofbits**: 스킬 저장소는 대부분 보안 분석 도구(감사, 정적 분석, 변종 분석, 퍼징, 패치 검증)다. 종단 개발 흐름은 claude-code-config의 `/fix-issue`가 맡는다. 이슈 읽기 → (필요하면 Exa로 조사) → `plan-issue-N.md` 작성 → 브랜치 → 구현·테스트 → PR → 병렬 에이전트 자기 리뷰 → 지적 수정 → 이슈에 코멘트 순서다 — [fix-issue.md](https://raw.githubusercontent.com/trailofbits/claude-code-config/main/commands/fix-issue.md); [config README](https://raw.githubusercontent.com/trailofbits/claude-code-config/main/README.md)
- TOB `code-improver`: 꽂아 쓰는 리뷰어(아무 스킬·에이전트)와 자체 fixer 에이전트를 번갈아 돌리고, 치명·주요 지적이 0개인 리뷰가 나와야 끝난다. 라운드 상한에 닿으면 "capped, NOT converged"로 시끄럽게 끝내고, 리뷰받지 않은 수정을 완료로 내놓지 않는다 — [code-improver README](https://raw.githubusercontent.com/trailofbits/skills/main/plugins/code-improver/README.md)
- **gstack**: Think → Plan → Build → Review → Test → Ship → Reflect. `/office-hours`(설계 문서) → `/plan-ceo-review` → `/plan-eng-review`(테스트 계획) → 구현 → `/review`(뻔한 것은 자동 수정, 나머지는 질문) → `/qa`(실제 브라우저) → `/gstack-ship`(테스트·리뷰 결과를 PR 본문에 첨부) → `/land-and-deploy`(머지와 배포 검증) 순서다. `/autoplan`은 CEO → 디자인 → DX → 엔지니어링 리뷰를 몰아서 돌리고, 엔지니어링 리뷰를 늘 마지막에 둔다 — [README](https://raw.githubusercontent.com/garrytan/gstack/main/README.md)
- gstack `/captain`(Capy 전용): 여러 레인 에이전트는 머지하지 않고 READY 블록만 보낸다. 컨트롤러가 기대 head를 확인하며 머지 트레인으로 머지한다 — 같은 출처

### Inferences
- "작성자가 아닌 판정자"는 이제 사실상 표준이다(superpowers 작업 리뷰어, CE 페르소나+교차 모델, Matt 두 축 하위 에이전트, addy 세 페르소나, TOB 꽂아 쓰는 리뷰어). 차이는 판정자를 몇 명 두느냐와 리뷰어 프롬프트를 오염시키지 않는 장치(superpowers의 무시 지시 금지, Matt의 컨텍스트 분리, HL의 티켓 읽기 금지)에 있다.
- j-dev-kit의 "백로그 항목 = 수용 기준"은 Matt의 Spec 축 리뷰, superpowers의 스펙 준수 판정, CE의 "계획 대비 검증"과 같은 자리를 차지한다. HL의 "연구 단계는 티켓을 못 본다"는 j-dev-kit의 서베이·조사 단계에 그대로 옮길 수 있는 장치다.
- 머지를 자동으로 하는 경우는 gstack `/land-and-deploy`, `/captain`과 Matt의 통합 브랜치(merger 하위 에이전트)뿐이다. 나머지는 PR까지만 가거나 사람에게 고르게 한다. j-dev-kit의 "사용자 승인 후 머지"는 주류에 속한다.

### Gaps
- pstack의 원문(22개 플레이북)은 이번 범위가 아니어서 직접 대조하지 않았다.
- CE `ce-plan`의 계획 승인 방식(사람이 승인하는지)은 SKILL.md 앞부분만 읽어 확인하지 못했다. 다만 README상 `/ce-work`가 계획을 다시 협상하지 않고 실행한다는 점은 확인했다.

## 질문 4. 언제 사람에게 묻고, 묻지 않을 때는 무엇을 하나 (명시적 자율 규칙)

### Takeaway
2026년 스택들은 "실행 중에는 멈추지 않고, 판단을 기록하고 계속 간다"로 모였다. 멈추는 사유는 되돌릴 수 없는 일, 보안, 공유 상태에 대한 부작용(머지, push, 게시), 계획이 무너진 경우로 좁게 적혀 있다. 사람의 질문은 맨 앞(의도와 설계)에 몰아 둔다. superpowers의 "Rulings, not stalls"는 pstack의 "never block on the human"과 거의 같은 규칙이다.

### Cited Findings
- superpowers SDD: 작업 사이에 사람에게 확인하려고 멈추지 않는다. "Should I continue?"나 진행 요약은 시간 낭비로 본다. 충돌, 모호함, 계획 결함, 상한 초과 요청은 직접 판정하고 ledger에 `Ruling: <결정> — <이유> — <틀렸을 때 비용>`으로 남긴 뒤 계속한다. 멈추는 사유는 넷뿐이다: 되돌릴 수 없거나 파괴적인 작업, 보안에 민감한 작업, 워크트리 밖의 부작용(머지, 공유 브랜치 push, 게시), 모든 길이 추측일 만큼 망가진 계획 — [SDD SKILL.md](https://raw.githubusercontent.com/obra/superpowers/main/skills/subagent-driven-development/SKILL.md)
- superpowers brainstorming v7.0.2: 답이 만들 것을 바꾸고 다른 데서 답을 찾을 수 없을 때만 묻는다. 아니면 결정을 제안으로 말하고 사용자가 고칠 수 있게 한다. 문서 작성, 파일 위치 같은 프로세스 질문은 하지 않는다. 선택지가 있으면 추천을 붙여 내민다 — [RELEASE-NOTES v7.0.2](https://raw.githubusercontent.com/obra/superpowers/main/RELEASE-NOTES.md)
- superpowers v6.0.0: 계획을 시작하기 전에 "pre-flight read"로 내부 충돌을 찾아 한 번에 묻는다. 실행 중에 하나씩 부딪히지 않게 하려는 것이다 — 같은 출처
- CE `/lfg`: 사람에게는 ce-brainstorm을 통해서만, 그것도 사람이 있을 때만 묻는다. 되돌릴 수 있는 일은 하고 나서 보여 주고 나중에 고치게 한다. 허락받지 않은 머지, force-push, 데이터 삭제처럼 되돌릴 수 없는 일만 멈춘다. 스케줄러, 루프, 중첩 오케스트레이터에서도 돌아간다. 작업원을 만들 수 없을 때, 하위 반환이 증거와 함께 완료되지 않았을 때, 확정된 결정이 무효가 됐을 때는 이유를 말하고 멈춘다. 멈출 때 새로 push한 것은 남기지 않는다 — [lfg SKILL.md](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/skills/lfg/SKILL.md)
- CE ce-compound 비대화형 모드는 어느 단계에서도 막는 질문을 하지 않고, 파싱할 수 있는 종료 신호로 끝난다 — [ce-compound SKILL.md](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/skills/ce-compound/SKILL.md)
- CE ce-work: 사용자가 내놓지 않은 것은 커밋하거나 게시하지 않는다. 이미 더러운 파일이 필요하면 단독 모드에서는 한 번 묻고, 호출자 반환 모드에서는 묻지 않고 blocked로 돌려준다 — [ce-work SKILL.md](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/skills/ce-work/SKILL.md)
- addy `/build auto`: 계획 승인 한 번이 유일한 사람 관문이다. 다만 테스트를 통과시킬 수 없을 때, 스펙이 모호할 때, 스펙이 다루지 않는 결정이 필요할 때, 고위험·되돌릴 수 없는 작업(인증, 파괴적 마이그레이션, 결제, 삭제, 배포, 비밀, `git revert`로 못 되돌리는 것)일 때는 멈추고 묻는다. 해결 뒤 다시 부르면 다음 작업부터 이어 간다 — [build.md](https://raw.githubusercontent.com/addyosmani/agent-skills/main/.claude/commands/build.md)
- Matt Pocock: 처음에는 grilling으로 집요하게 묻고, 기준점이나 스펙 위치를 모르면 묻는다. 자율 규칙은 따로 적혀 있지 않다. 대신 `to-questionnaire`(혼자 답할 수 없는 결정을 답할 사람에게 보낼 비동기 질문지로 만듦)와 `wizard`(사람만 할 수 있는 단계를 bash 마법사로 만듦)가 있다 — [README](https://raw.githubusercontent.com/mattpocock/skills/main/README.md)
- humanlayer RPI: 단계마다 사람이 산출물을 읽고 다음 스킬을 부른다. implement-plan은 Phase가 끝날 때마다 사람의 확인을 기다린다. 이 표의 스택 가운데 사람 개입이 가장 많은 설계다 — [implement-plan SKILL.md](https://raw.githubusercontent.com/humanlayer/humanlayer/main/apps/riptide-rpi-claude-plugin/skills/implement-plan/SKILL.md)
- TOB `/fix-issue`: 모든 단계를 차례로 실행하고, 어느 단계에서도 멈추거나 확인을 구하지 않는다 — [fix-issue.md](https://raw.githubusercontent.com/trailofbits/claude-code-config/main/commands/fix-issue.md). 반면 trailofbits/skills의 `ask-questions-if-underspecified`는 덜 정해진 요청이면 시작 전에 1–5개를 묻는다 — [config README](https://raw.githubusercontent.com/trailofbits/claude-code-config/main/README.md)
- TOB는 훅을 "guardrails, not walls"로 둔다. `rm -rf`나 main으로의 push를 막고, Stop 훅으로 미완성 작업을 합리화하는 응답을 다시 일하게 만든다 — [config README](https://raw.githubusercontent.com/trailofbits/claude-code-config/main/README.md)
- gstack `/autoplan`: 정해진 결정 원칙으로 리뷰를 몰아서 돌리고, 취향에 관한 결정만 사람 승인에 올린다. `/review`는 뻔한 것만 자동으로 고치고 나머지는 묻는다. 약해진 테스트, timeout, 스냅샷, 억제는 이름을 붙여 사람에게 보고한다. `/careful`은 파괴적 명령을 경고하고, 기본 브랜치 force-push는 무조건 거부한다 — [README](https://raw.githubusercontent.com/garrytan/gstack/main/README.md)

### Inferences
- 자율 규칙의 공통형은 "질문은 앞에 모아 한 번에, 실행 중에는 판정 기록, 멈춤 사유는 열거형"이다. j-dev-kit이 백로그 016("사람에게 묻는 곳을 꼭 필요한 것만 남기고 계획 승인을 없앤다")에서 고려하는 방향은 superpowers SDD와 CE `/lfg`의 실제 규칙과 맞는다. 다만 addy는 계획 승인 한 번을 남기는 쪽이라 반대 사례로 함께 적어 둘 만하다.
- "약해진 테스트·억제는 반드시 사람에게"(gstack)와 "리뷰어에게 무시를 지시하지 말 것"(superpowers)은 자율 실행이 판정을 속이는 길을 막는 장치다.

### Gaps
- Matt Pocock 스택에는 실행 중 자율과 멈춤에 대한 명시 규칙이 없다(SKILL.md가 짧다). 일부러 그렇게 둔 것인지는 1차 출처에서 확인하지 못했다.

## 질문 5. 결정·진행·학습을 어떻게 기록하나

### Takeaway
계획과 스펙은 모두 저장소 안 마크다운 파일이다. 진행은 superpowers처럼 ledger 파일, 이슈 트래커(Matt), PR 본문(CE, gstack)에 남긴다. 학습을 쌓는 장치는 CE의 `docs/solutions/` + `/ce-compound`가 가장 정교하고, gstack(`/learn`, GBrain), Matt(`GLOSSARY.md`·ADR), TOB(`/insights` 주간 회고)도 각자 방식으로 갖고 있다.

### Cited Findings
- superpowers: 설계는 `docs/superpowers/specs/`(커밋), 계획은 `docs/superpowers/plans/`에 둔다. SDD 작업공간 `<repo-root>/.superpowers/sdd/`에 ledger(`progress.md`), 브리프, 리포트, 리뷰 패키지를 모아, 컨텍스트를 잃은 컨트롤러가 이어서 할 수 있게 한다. Ruling 줄도 ledger에 남긴다 — [SDD SKILL.md](https://raw.githubusercontent.com/obra/superpowers/main/skills/subagent-driven-development/SKILL.md); [RELEASE-NOTES v6.0.0·v7.0.0](https://raw.githubusercontent.com/obra/superpowers/main/RELEASE-NOTES.md)
- superpowers 계획에는 Global Constraints 블록(모든 작업에 걸리는 규칙을 문자 그대로 복사)과 작업별 Interfaces 블록이 들어간다 — [RELEASE-NOTES v6.0.0](https://raw.githubusercontent.com/obra/superpowers/main/RELEASE-NOTES.md)
- superpowers `diagnosing-superpowers`: 세션 기록을 읽어 무엇이 잘못됐는지 줄 단위 증거로 보고하고, 민감 정보를 지운 번들을 만든다 — [README](https://raw.githubusercontent.com/obra/superpowers/main/README.md)
- CE: 계획은 `docs/plans/`, 학습은 `docs/solutions/`에 둔다(`docs_root`로 위치를 바꿀 수 있음). `/ce-compound`가 쓴 학습을 다음 `/ce-plan`이 근거로 읽는다. README 데모는 18일 뒤 다른 작업에서 그 학습이 계획에 반영되는 장면이다 — [README](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/README.md)
- ce-compound의 기록 기준: 해결되고 검증된 문제만 다룬다. 코드, 테스트, 문서에서 다시 알아낼 수 없고 잃으면 재발할 교훈만 남긴다(반사실 검사). 실행 한 번에 학습 하나만 남기고, 형태는 가장 싼 것으로 고른다(테스트 하나, lint 규칙, `CODING_STANDARDS.md` 조건, 학습 문서 하나). 기존 학습이 틀렸으면 새로 만들지 않고 갱신한다. `mode:refresh`는 기존 학습을 코드와 대조해 지우거나 고친다 — [ce-compound SKILL.md](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/skills/ce-compound/SKILL.md)
- CE `/lfg`: 적용하지 못한 리뷰 지적과 확정 결정 충돌은 PR 본문에, PR이 없으면 티켓이나 DONE 보고에 남긴다. 이것이 끝나야 완료를 선언한다 — [lfg SKILL.md](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/skills/lfg/SKILL.md)
- CE "Compound Packs"(실험적): 여러 저장소에 걸친 규칙 폴더다. 계획이 근거로 삼고 리뷰가 강제하며, 쓸 때마다 규칙 파일을 인용한다 — [README](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/README.md)
- Matt Pocock: 스펙과 티켓은 이슈 트래커(GitHub, GitLab, 로컬 파일 중 선택)에 둔다. `GLOSSARY.md`(공유 언어)와 ADR은 grill-with-docs와 domain-modeling이 그때그때 갱신한다. `/retro`는 세션 뒤 환경(탐색, 자동 검사, 규칙, 스티어링 파일) 개선안을 심각한 순으로 낸다. `/handoff`는 대화를 인계 문서로 압축한다 — [README](https://raw.githubusercontent.com/mattpocock/skills/main/README.md)
- addy: `SPEC.md`(변경분은 `SPEC-<change>.md` 델타 스펙), `tasks/plan.md`(맨 위에 `Source spec:` 줄), `tasks/todo.md`를 쓰고, 작업마다 개별 커밋한다. documentation-and-adrs 스킬이 있다 — [build.md](https://raw.githubusercontent.com/addyosmani/agent-skills/main/.claude/commands/build.md); [spec-driven-development SKILL.md](https://raw.githubusercontent.com/addyosmani/agent-skills/main/skills/spec-driven-development/SKILL.md)
- humanlayer: 작업마다 `.humanlayer/tasks/<ENG-XXXX-slug>/` 아래에 번호를 붙인 산출물(`01-research-questions-…`, `03-design-discussion-…`, `04-structure-outline-…`, `NN-plan-…`)을 둔다. 이 디렉터리는 다른 저장소로 가는 심링크라서 커밋하지 않는다. 문서를 쓰면 훅이 클라우드 퍼머링크를 돌려준다 — [create-research-questions](https://raw.githubusercontent.com/humanlayer/humanlayer/main/apps/riptide-rpi-claude-plugin/skills/create-research-questions/SKILL.md); [implement-plan](https://raw.githubusercontent.com/humanlayer/humanlayer/main/apps/riptide-rpi-claude-plugin/skills/implement-plan/SKILL.md); [create-structure-outline](https://raw.githubusercontent.com/humanlayer/humanlayer/main/apps/riptide-rpi-claude-plugin/skills/create-structure-outline/SKILL.md)
- ACE-FCA(2025-08): `thoughts/shared/research/`, `thoughts/shared/plans/`에 두고, 검증된 Phase마다 상태를 계획 파일에 다시 압축해 넣는다("frequent intentional compaction") — [ace-fca.md](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/ace-fca.md)
- TOB `/fix-issue`는 `plan-issue-N.md`를 저장소 루트에 쓴다. `code-improver`는 지적마다 고정 id와 판정(`fixed`/`rejected: 이유`/`deferred`)을 단 findings ledger를 라운드 사이 기억으로 쓴다. 리뷰어는 수정을 믿지 않고 검증하며, 기각된 지적은 새 증거 없이 다시 올리지 못한다. 라운드마다 상태를 먼저 저장한다 — [fix-issue.md](https://raw.githubusercontent.com/trailofbits/claude-code-config/main/commands/fix-issue.md); [code-improver README](https://raw.githubusercontent.com/trailofbits/skills/main/plugins/code-improver/README.md)
- TOB: 매주 `/insights`를 돌려 CLAUDE.md 규칙, 훅, 스킬로 반영하라고 권한다 — [config README](https://raw.githubusercontent.com/trailofbits/claude-code-config/main/README.md)
- gstack: 앞 단계 산출물을 다음 단계가 읽는다(설계 문서 → CEO 리뷰, eng 리뷰 테스트 계획 → `/qa`, `/review` 지적 → `/gstack-ship`이 해결 여부 확인). `/learn`은 세션을 넘어 패턴, 함정, 선호를 관리한다. GBrain은 세션 사이 지식 베이스다. review·evidence ledger CLI가 따로 있다 — [README](https://raw.githubusercontent.com/garrytan/gstack/main/README.md)

### Inferences
- j-dev-kit의 백로그 항목은 superpowers의 spec+plan과 HL의 번호 붙은 산출물을 합친 자리에 있다. 진행 ledger(Ruling 줄 포함)와 리뷰 findings ledger(고정 id와 판정)는 j-dev-kit에 아직 명시적으로 없을 수 있는 부분이라 빌려 올 후보다.
- CE의 "학습은 가장 싼 형태로(가능하면 테스트나 lint로), 한 번에 하나, 반사실 검사"는 문서가 쌓이기만 하는 문제를 막는 규칙이다. j-dev-kit이 `/task end`에서 학습을 남긴다면 이 기준을 그대로 쓸 만하다.

### Gaps
- gstack의 learnings 저장 위치(`$GSTACK_STATE_…` 등)와 형식은 README에서 일부만 보여서 확인하지 못했다.

## 질문 6. 무엇이 독특하고, 백로그 항목 기반 Claude Code 플러그인이 무엇을 빌려 올 수 있나

### Takeaway
스택마다 독특한 지점은 하나씩이다. superpowers는 판정 구조의 정직성(무시 지시 금지, 확인 불가 판정, Ruling 기록), CE는 학습 복리, Matt는 공유 언어와 두 축 리뷰, addy는 승인 한 번짜리 자율 빌드와 GO/NO-GO, HL은 연구 객관성과 단계별 산출물, TOB는 수렴해야 끝나는 리뷰 루프와 훅 가드레일, gstack은 역할별 리뷰와 PR에 증거 첨부다. j-dev-kit은 이미 "항목 → 워크트리 구현 → 별도 판정 → 승인 머지" 골격이 있으니, 판정의 정직성과 기록 장치를 빌려 오는 편이 가장 이득이 크다.

### Cited Findings
- superpowers 고유: 컨트롤러가 리뷰어의 지적을 줄이거나 심각도를 미리 매기는 것을 금지한다. 계획이 강제한 결함도 보고하게 한다. "can't verify from the diff" 판정, 리뷰어 읽기 전용, 디스패치마다 모델 명시(이전에 한 실행에서 리뷰어 26개가 모두 최상위 모델로 갔다), diff와 작업 텍스트를 파일로 넘김 — [RELEASE-NOTES v6.0.0](https://raw.githubusercontent.com/obra/superpowers/main/RELEASE-NOTES.md)
- superpowers 고유: 스킬 크기 테스트(SKILL.md 20,000바이트 미만, 컴팩션 뒤 잘림 방지), 행동 회귀 블라인드 평가(예: Ctrl+K 충돌 시나리오에서 8번 중 8번 선택지와 추천을 냄) — [RELEASE-NOTES v7.0.1·v7.0.2](https://raw.githubusercontent.com/obra/superpowers/main/RELEASE-NOTES.md)
- CE 고유: `/lfg`가 요청 종류로 하위 스킬을 고르고, 하위 반환을 `status`로 파싱하는 파이프라인 계약이 있다(`mode:return-to-caller`, `mode:pipeline`, `<promise>DONE</promise>`). 리뷰가 "확정 결정 충돌"(settled_conflict)을 따로 잡는다 — [lfg SKILL.md](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/skills/lfg/SKILL.md)
- CE 고유: 80%는 계획과 리뷰, 20%는 실행에 쓴다는 원칙 — [README](https://raw.githubusercontent.com/EveryInc/compound-engineering-plugin/main/README.md)
- Matt 고유: GSD, BMAD, Spec-Kit처럼 프로세스를 소유하는 접근을 비판하고 작고 조합 가능한 스킬을 지향한다. user-invoked 스킬(오케스트레이션)과 model-invoked 스킬(재사용 규율)을 나누고, user-invoked 스킬이 다른 user-invoked 스킬을 부르지 못하게 한다 — [README](https://raw.githubusercontent.com/mattpocock/skills/main/README.md)
- Matt 고유: `/pr` 스킬이 PR 본문에 머지 위험(one-way/two-way door, 영향 범위)을 판단해 적게 한다 — 같은 출처
- addy 고유: "hedged" 답을 승인으로 치지 않고, `git revert`로 되돌릴 수 있는지를 멈춤 기준으로 쓴다. 사용자가 `.claude/agents/`에 만든 같은 이름의 페르소나가 플러그인 것보다 우선한다 — [build.md](https://raw.githubusercontent.com/addyosmani/agent-skills/main/.claude/commands/build.md); [ship.md](https://raw.githubusercontent.com/addyosmani/agent-skills/main/.claude/commands/ship.md)
- HL 고유: 연구 단계가 티켓을 못 보게 해서 객관성을 지키고, 질문 생성과 답 조사를 서로 다른 스킬로 나눈다. 산출물 우선순위 사슬이 있다 — [create-research SKILL.md](https://raw.githubusercontent.com/humanlayer/humanlayer/main/apps/riptide-rpi-claude-plugin/skills/create-research/SKILL.md); [create-plan SKILL.md](https://raw.githubusercontent.com/humanlayer/humanlayer/main/apps/riptide-rpi-claude-plugin/skills/create-plan/SKILL.md)
- TOB 고유: 깨끗한 리뷰가 나와야 끝나고 아니면 "NOT converged"로 끝낸다. 마무리 단계의 자기 편집도 범위와 회귀를 다시 검사한다(버전이 정확히 1 증가했는지까지). 진동을 감지한다 — [code-improver README](https://raw.githubusercontent.com/trailofbits/skills/main/plugins/code-improver/README.md)
- TOB 고유: 독립 2차 의견용 `second-opinion`(Codex나 Antigravity로 리뷰), 머지 증거를 모으고 자기 삭제 권고를 반박해 보는 `git-cleanup` — [README](https://raw.githubusercontent.com/trailofbits/skills/main/README.md)
- gstack 고유: 실행 증거(실행한 테스트, 리뷰 결과)를 PR 본문에 넣는다. 테스트가 덮지 않는 변경을 green이라 부르지 않는다(`/build-check`). `/codex`·`/claude-code`로 교차 하네스 2차 의견을 받는다. 자기 스택의 효과를 측정해 공개한다(이득 없음) — [README](https://raw.githubusercontent.com/garrytan/gstack/main/README.md)

### Inferences
j-dev-kit(백로그 항목 기반)이 빌려 올 후보. 근거는 위 인용이다.
1. **Ruling 기록**(superpowers): 하위 세션이 사람을 기다리지 않고 판정하되, 항목이나 ledger에 `결정 — 이유 — 틀렸을 때 비용`을 남긴다. pstack의 "never block"을 기록으로 받쳐 주는 형식이다.
2. **멈춤 사유 열거**(superpowers SDD, CE lfg, addy build auto): 되돌릴 수 없음, 보안, 워크트리 밖 부작용, 계획 붕괴로 좁혀 적고, 그 밖에는 묻지 않는다. addy의 "`git revert`로 되돌릴 수 있나"는 판정하기 쉬운 기준이다.
3. **판정 정직성 장치**(superpowers v6): 판정자에게 무엇을 무시하라는 지시 금지, "diff로는 확인 불가" 판정, 판정자 읽기 전용, 수용 기준마다 파일·줄 근거.
4. **두 축 분리 리뷰**(Matt): 수용 기준 준수 판정자와 코드 규칙·냄새 판정자를 컨텍스트가 섞이지 않게 나눈다.
5. **findings ledger와 수렴 조건**(TOB code-improver): 지적마다 고정 id와 판정, 기각된 지적은 새 증거 없이 다시 올리지 못함, 라운드 상한에서는 "NOT converged"로 정직하게 끝낸다.
6. **연구 객관성**(HL): `create --survey`나 조사 단계가 "만들고 싶은 것"(항목 본문)을 보지 않고 현재 상태만 조사하게 하는 선택지.
7. **학습 복리 기준**(CE ce-compound): `/task end`에서 해결되고 검증된 교훈 하나만, 가능하면 테스트나 lint 같은 가장 싼 형태로 남긴다. 다음 `/task create`나 `start`가 그것을 근거로 읽는다. 반사실 검사로 쌓이기만 하는 문서를 막는다.
8. **PR·머지 요청에 증거 첨부**(gstack, Matt `/pr`): 실행한 검증 명령과 결과, 판정 요약, 머지 위험(one-way/two-way door)을 사용자 승인 화면에 함께 올린다.
9. **스킬 크기·행동 회귀 테스트**(superpowers): SKILL.md 크기 상한 테스트, 시나리오 블라인드 평가로 질문 수나 승인 전 구현 같은 행동 지표를 잰다. j-dev-kit의 `check-repo-rules.sh`에 크기 검사를 넣을 수 있다.
- 반대로 빌려 오지 말 것: HL 방식의 Phase마다 사람 확인은 j-dev-kit 016의 방향(묻는 곳 최소화)과 맞지 않는다. gstack 같은 역할 페르소나 수십 개는 "공통분모만" 원칙과 충돌한다. gstack 자체 실험에서도 수정률 이득이 없었다.

### Gaps
- 위 차용 후보의 효과를 보여 주는 독립 측정은 superpowers 자체 평가(토큰 약 50% 감소, 약 2배 속도, v6.0.0)와 gstack의 무효과 실험 말고는 찾지 못했다. 둘 다 저자의 자체 측정이다.
- pstack과 이 스택들을 직접 비교한 1차 자료는 찾지 못했다.
