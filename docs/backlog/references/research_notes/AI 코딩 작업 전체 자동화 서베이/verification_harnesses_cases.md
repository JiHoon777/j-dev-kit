# 검증: autonomous_harnesses.md · practitioner_cases.md

검증일 2026-11-20. 각 주장은 이번 작업에서 출처 페이지를 WebFetch로 직접 열어 확인했다. 검색 결과 스니펫만으로는 "확인"을 주지 않았다. 파일 표기: H = autonomous_harnesses.md, P = practitioner_cases.md.

판정: 확인 / 수정 필요(대체로 맞지만 세부가 다름) / 확인 불가(출처를 열 수 없거나 페이지에 없음) / 틀림.

## 표

| # | 주장 (요약) | 파일 | 판정 | 출처가 실제로 말하는 것 (다를 때) | 확인한 URL |
|---|---|---|---|---|---|
| 1 | "Effective harnesses…" Justin Young, 2025-11-26, Claude Agent SDK에서 Opus 4.5 | H | 확인 | | https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents |
| 2 | 초기화 에이전트: init.sh, claude-progress.txt, 첫 커밋, 기능 200개 이상(전부 failing), JSON이 Markdown보다 덮어쓰기 덜 당함, 예시 기능 단계 5개, `feature_list.json`는 트랜스크립트에만 나옴 | H | 확인 | | 위와 같음 |
| 3 | 세션 시작: pwd → git log(`--oneline -20`)와 진행 파일 → 기능 목록 → init.sh → 기본 E2E 테스트. passes 필드만 수정 가능, 테스트 삭제·수정 금지 | H | 확인 | 원문 표현은 "It is unacceptable to remove or edit tests". `git log --oneline -20`과 init.sh 실행은 예시 트랜스크립트에 나옴 | 위와 같음 |
| 4 | 따옴표 인용 "greatly improved", "clean, mergeable" | H | 수정 필요 | 원문은 "dramatically improved performance". "clean, mergeable"이라는 표현은 없고, clean state를 "the kind of code that would be appropriate for merging to a main branch"로 설명 | 위와 같음 |
| 5 | 두 "에이전트"는 시스템 프롬프트·도구·하네스가 같고 첫 사용자 프롬프트만 다름. 전문 에이전트(테스트, QA, 정리)가 열린 질문 | H | 확인 | | 위와 같음 |
| 6 | C 컴파일러: Carlini, 2026-02-05, Opus 4.6, 2주 동안 세션 약 2,000개, 입력 20억·출력 1.4억 토큰, $20k 약간 아래, Rust 약 10만 줄, x86/ARM/RISC-V에서 Linux 6.9 빌드, 대부분 스위트 99%, QEMU/FFmpeg/SQLite/Postgres/Redis | H, P | 확인 | | https://www.anthropic.com/engineering/building-c-compiler |
| 7 | 에이전트 16개, Docker, bare repo, `current_tasks/parse_if_statement.txt` 락, AGENT_PROMPT.md, 오케스트레이터 없음, GCC 오라클과 delta debugging, SSA IR 제약 | H, P | 확인 | | 위와 같음 |
| 8 | `--fast`는 1% 또는 10% 무작위 샘플, 에이전트별로 결정적이고 에이전트 간에는 다름 | H | 확인 | 원문은 "deterministic per-agent but random across VMs" (에이전트 간이 아니라 VM 간) | 위와 같음 |
| 9 | 한계: 회귀가 잦음, 16비트 x86 없음(GCC 사용), 자체 어셈블러·링커 없음, -O0 GCC보다 느림, `pkill -9 bash` 사고 | H, P | 확인 | 어셈블러·링커는 "the very last bits that Claude started automating"이고 아직 버그가 있으며, 데모는 GCC 것을 썼다 | 위와 같음 |
| 10 | 하네스 설계: Prithvi Rajasekaran, 2026-03-24. 레트로 게임 메이커 단독 20분/$9, 전체 하네스 6시간/$200. DAW 3시간 50분/$124.70, 빌드 1라운드 2시간 7분, QA 라운드 각 10분 미만 | H | 확인 | | https://www.anthropic.com/engineering/harness-design-long-running-apps |
| 11 | DAW 실행은 "V2 하네스, Opus 4.6" | H | 수정 필요 | 페이지가 DAW 실행 모델을 명시하지 않음. 앞뒤 문맥으로 Opus 4.6을 짐작할 뿐 | 위와 같음 |
| 12 | Sonnet 4.5가 "context anxiety"를 보였고, Opus 4.5에서 거의 사라져 리셋을 버리고 자동 compaction 사용. 플래너는 1~4문장 프롬프트, 스택 React/Vite/FastAPI/SQLite(이후 Postgres), 평가자는 Playwright(MCP), "inclined to be generous" | H | 확인 | | 위와 같음 |
| 13 | 프런트엔드 디자인 변형: 5~15회 반복, 최대 4시간 | H | 확인 | | 위와 같음 |
| 14 | ralph-loop은 `anthropics/claude-plugins-official`에 있음: `/ralph-loop "<prompt>" --max-iterations N --completion-promise "<text>"`, `/cancel-ralph`, `hooks/stop-hook.sh`, `<promise>COMPLETE</promise>` 정확히 일치, max-iterations 기본값 무제한이고 "primary safety mechanism" | H | 확인 | 원문은 "same session"이 아니라 "inside your current session" | https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/plugins/ralph-loop/README.md |
| 15 | README: 명확한 성공 기준이 있는 작업용이고 판단·설계 결정이 필요한 작업용이 아님. Windows에서 `bash`가 WSL bash로 잡힐 수 있음 | H | 확인 | | 위와 같음 |
| 16 | 옛 경로 `anthropics/claude-code/plugins/ralph-wiggum`은 404 | H | 확인 | | https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum |
| 17 | Stop 훅: exit 2면 stderr가 계속할 이유가 됨, `{"decision":"block","reason"}`, `continue:false`가 exit 2보다 우선, Stop/SubagentStop에 `last_assistant_message` 있음 | H | 확인 | | https://code.claude.com/docs/en/hooks |
| 18 | "문서 예제가 `npm test` 실패 중 종료를 막는다" | H | 틀림 | `npm test` 차단 예제는 **TaskCompleted** 훅 절에 있다. Stop 절의 예시는 `additionalContext` "Please run the test suite before finishing"이다. 또 Stop 절에는 노트가 Gap으로 남긴 `stop_hook_active`가 있고(`true`면 이미 Stop 훅 때문에 계속 중), **8회 연속 continuation 상한**이 있다(`CLAUDE_CODE_STOP_HOOK_BLOCK_CAP`로 조정). 내장 `/goal` 명령이 세션 범위 프롬프트 기반 Stop 훅의 단축이라는 팁도 있다 | 위와 같음 (offset 200000 부근 Stop 절) |
| 19 | GitHub Actions: `anthropics/claude-code-action@v1`, Agent SDK 기반, `prompt` 유무로 대화형/자동화 모드, 쓰기 권한 확인, `allowed_bots` "keeps bots from triggering Claude in a loop", 기본 `GITHUB_TOKEN` 커밋은 CI를 안 띄움, `--max-turns`, "review Claude's changes before merging" | H | 확인 | | https://code.claude.com/docs/en/github-actions |
| 20 | Huntley Ralph: 2025-07-14, `while :; do cat PROMPT.md \| claude-code ; done`, PROMPT.md/specs/fix_plan.md/AGENT.md, "one item per loop", 예시 프롬프트는 "most important 10 things", 도구 호출·사용량 상한 없는 도구면 됨 | H | 확인 | | https://ghuntley.com/ralph/ |
| 21 | 서브에이전트 500~1,000개 병렬, 빌드·테스트는 1개. 컨텍스트 약 170k. "under baked, baked, or baked with unspecified latent behaviours" | H | 확인 | 500은 빌드 프롬프트, 1,000은 CURSED 표준 라이브러리 작성 프롬프트에 나옴 | 위와 같음 |
| 22 | CURSED는 약 3개월에 걸쳐 만듦 | H | 확인 불가 | 인용한 페이지에는 기간이 없다("it was only a month in that I noticed"만 있음). 3개월 수치는 다른 글에서 확인해야 한다 | 위와 같음 |
| 23 | Amp로 $50k 계약을 $297에, YC 해커톤 "6 repos overnight" (일화) | H | 확인 | 일화로서 페이지와 README에 둘 다 있음. 독립 검증은 아님 | ghuntley.com/ralph, ralph-loop README |
| 24 | Huntley: 그린필드용이고 기존 코드베이스용이 아님 | H | 확인 | "There's no way in heck would I use Ralph in an existing code base", 그린필드에서 "90% done" 기대 | ghuntley.com/ralph |
| 25 | OpenAI "Harness engineering" 원문은 403 | H, P | 확인 | 이번에도 403 | https://openai.com/index/harness-engineering/ |
| 26 | 원문은 Ryan Lopopolo, 2026-02-11 | H | 확인 불가 | InfoQ는 Lopopolo를 인용하지만 저자·날짜는 밝히지 않음. 날짜는 검색 스니펫에만 있음 | https://www.infoq.com/news/2026/02/openai-harness-engineering-codex |
| 27 | InfoQ(2026-02-21): 5개월, 약 100만 줄, 수동 작성 코드 없음, Types→Config→Repo→Service→Runtime→UI를 구조 테스트로 강제, docs 디렉터리가 진실 공급원, 사람은 환경 설계·의도 명시·피드백 | H, P | 확인 | InfoQ에는 팀 규모·PR 수가 없음 | 위와 같음 |
| 28 | ZenML(Latent Space 기반): PR 1,500개 이상, 7인 팀, 1인당 에이전트 10~50개, 2025-12 말 엔지니어당 하루 3.5 PR → GPT-5.2 후 5~10, 하루 10억 토큰 이상·$2~3k, 첫 1.5개월 "10배 느림", P2 초과 미표시, `$land`, Vector/VictoriaMetrics/Grafana | H | 확인 | 2차 자료로서 페이지에 있음 | https://www.zenml.io/llmops-database/extreme-harness-engineering-building-production-systems-with-zero-human-written-code |
| 29 | 팀 규모 3명 vs 7명 충돌, 처리량 단위 | H, P | 수정 필요 | ignorance.ai(Charlie Guo, 2026-02-22)는 3인 팀이고 팀이 커지며 처리량이 늘었다고 함. ZenML은 7인. 3명으로 시작해 7명으로 늘었다는 해석이 가장 그럴듯하지만 원문 미확인. 또 다른 ZenML 항목(강연 기반)은 3.5 PR을 엔지니어당 **주** 단위로, GPT-5.5에서 주 70개로 적어 단위가 서로 충돌 | https://www.ignorance.ai/p/the-emerging-harness-engineering ; https://www.zenml.io/llmops-database/zero-human-written-code-harness-engineering-for-autonomous-ai-agents-at-scale |
| 30 | Copilot: Actions 기반 세션 59분 상한, 클라우드/Actions/원격 환경, 작업당 브랜치 1개·PR 1개, 룰셋 우회, Watch and fix, Automations, 로그가 리뷰를 대체하지 않음. 기본적으로 워크플로 실행에 승인 필요, 배정 후 댓글 무시, @copilot은 쓰기 권한자만, 배정자에게 리뷰 요청 | H | 확인 | | https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent ; https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/use-cloud-agent-on-github |
| 31 | Devin: "if you can do it in three hours, Devin can most likely do it", draft PR | H | 확인 | 소개 페이지 입력 경로는 Slack/Teams, 웹, CLI `/handoff`, API. Linear/Jira는 이번에 확인한 내용에 없음 | https://docs.devin.ai/get-started/devin-intro |
| 32 | StrongDM 헌장 두 줄, 연표(2024-10, 2024-12, 2025-07-14, 2026-02-06 공개), "$1,000 on tokens today", 만족도 정의, DTU(Okta/Jira/Slack/Google Docs·Drive·Sheets), `return true` | P | 확인 | gene transfusion 등은 페이지에 없음(노트의 Gap이 맞음) | https://factory.strongdm.ai/ |
| 33 | Willison 2026-02-07: 2025-10 방문, 결성 약 3개월, McCarthy/Taylor/Chauhan, 월 약 $20k 계산, "리뷰 금지"가 가장 흥미롭고 의문스러움, 시간당 수천 시나리오 | P | 확인 | | https://simonwillison.net/2026/Feb/7/software-factory/ |
| 34 | Stanford CodeX 2026-02-08 순환성 비판, 기존 책임 체계는 사람 리뷰를 가정 | P | 확인 | 저자는 Eran Kahana | https://law.stanford.edu/2026/02/08/built-by-agents-tested-by-agents-trusted-by-whom/ |
| 35 | Gas Town 2026-01-01: 8단계, 7단계용(용감하면 6), 역할, Beads/`gt sling`/Convoy, 두 번째 계정·세 번째 예상, "cash guzzler", 3주 미만·100% 바이브 코딩, 앞선 오케스트레이터 2개 실패, 하루 Claude Code 5개 미만이면 쓰지 말 것 | P | 확인 | 미러 기준(Medium 원문 아님) | https://drss.io/feed/npub1na2ppcvpx7m7dg4d2rqelpq4xdj9z40cxu3avh4qcdq8dtupdcmqahmfge/welcome-to-gas-town |
| 36 | 후속 보도: 머지 큐 166개에서 main 게이팅 중단, "40개 에이전트, 한 달 690억 토큰" | P | 수정 필요 | danjou 글(2026-08-18)이 Yegge의 후속 에세이 "The Continuous Thunderdome"을 인용해 166개와 게이팅 중단("Land Rush"), MMO Wyvern에 "about forty agents"를 적음. **690억 토큰은 어느 출처에도 없음.** letsdatascience(2026-01-23)에는 이 수치들이 하나도 없으므로 인용에서 빼야 함 | https://julien.danjou.info/blog/steve-yegge-deleted-the-wrong-thing ; https://letsdatascience.com/news/agent-orchestrators-shift-software-design-bottlenecks-3a2e93f8 |
| 37 | Klabnik 2026-01-15: 직접 안 써 봄, Erlang 감독 트리·메일박스, "aggressively not rigorous", trunk 머지 엄밀성 질문 | P | 확인 | | https://steveklabnik.com/writing/how-to-think-about-gas-town/ |
| 38 | Cherny: 30일 동안 PR 259개, 커밋 497개, +4만/-3.8만 줄, 전부 Claude Code + Opus 4.5 (Willison 2025-12-27) | P | 확인 | | https://simonwillison.net/2025/Dec/27/boris-cherny/ |
| 39 | Cherny 워크플로(InfoQ 2026-01-10): 로컬 5개 + 웹 5~10개, "세션의" 10~20% 버림, CLAUDE.md 약 2.5k 토큰, `/commit-push-pr` 하루 수십 번, Chrome 확장 테스트, `@.claude`, skip-permissions는 샌드박스 장기 작업에만, 품질 2~3배 | P | 수정 필요 | 10~20%는 전체 세션이 아니라 **원격(웹) 세션**에 대한 수치 | https://www.infoq.com/news/2026/01/claude-code-creator-workflow |
| 40 | Willison 2025-10-05: 여러 터미널 YOLO, `/tmp` 새 checkout, 위험 작업은 Codex Cloud, 리뷰가 병목, 의미 있는 변경은 한 번에 하나 | P | 확인 | | https://simonwillison.net/2025/Oct/5/parallel-coding-agents/ |
| 41 | Steinberger: 프로젝트 3~8개, main에 직접 커밋, 1인이라 가능, gpt-5.2-codex high, "이전 모델들은 VibeTunnel 코어를 Rust/Go/Zig로 다시 쓰는 데 실패" | P | 수정 필요 | 이전 모델이 실패한 것은 Rust와 Go 시도다. **Zig 전환은 Codex가 한 번에(5시간 넘게) 성공**했다. 글에 날짜 표기가 없고 2025-12 말은 추정 | https://steipete.me/posts/2025/shipping-at-inference-speed |
| 42 | Hashimoto 2026-02-05: 6단계 이름, 하루 마지막 30분, 트리아지는 보고만, 백그라운드 가동 10~20%, 멀티 에이전트 안 씀, AGENTS.md와 스크립트 도구 | P | 확인 | | https://mitchellh.com/writing/my-ai-adoption-journey |
| 43 | Ronacher "The Coming Loop" 2026-06-23: 포팅(MiniJinja→Go)·성능·보안 스캔·리서치에 좋음, 아끼는 코드에는 별로, 방어 코드 누적, "removes responsibility" | P | 확인 | | https://lucumr.pocoo.org/2026/6/23/the-coming-loop/ |
| 44 | Stripe Minions Part 1 (2026-02-09): 10초 devbox, goose 포크, Toolshed MCP 도구 400개 이상, 로컬 린트 5초 미만, 테스트 300만 개 이상, CI 최대 2라운드, 매주 1,000개 이상 머지, 사람이 쓴 코드 없음·사람 리뷰 | P | 확인 | | https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents |
| 45 | "1,300 PR/주는 2차 보도(미검증)" | P | 수정 필요 | **1차 확인됨.** Part 2(2026-02-19, Alistair Gray): "Over 1,300 Stripe pull requests (up from 1,000 as of Part 1) merged each week are completely minion-produced" | https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents-part-2 |
| 46 | Shopify River 2026-05-28: 머지 PR 8개 중 1개, 30일 세션 59,918개·채널 5,170개·7,000명 이상·PR 3,536개, 중앙값 19분·도구 호출 50회, 모노레포 이전, 리뷰 게이트 미기재 | P | 확인 | 저자 Burke Libbey, Javier Moreno. 모노레포 전환은 2024년 봄 | https://shopify.engineering/under-the-river |
| 47 | Spotify Part 1 2025-11-06: Honk, 머지 PR 1,500개 이상, 60~90% 절감, LLM-as-judge, 과제(느림, 예측 불가, 샌드박스, 비용) | P | 확인 | | https://engineering.atspotify.com/2025/11/spotifys-background-coding-agent-part-1 |
| 48 | Spotify 2026-06-03: 유지보수 PR 250만 개 이상 "대다수 자동 머지", PR 빈도 +76%, 99% 이상 주간 사용, 94% 생산성 체감, Java 마이그레이션 3일, Agent SDK·K8s 파드, 파편화된 코드베이스에서 성능 저하 | P | 확인 | 원문 "the vast majority auto-merged with no human in the loop" | https://engineering.atspotify.com/2026/6/code-with-claude-coding-is-no-longer-the-constraint |
| 49 | Anthropic 내부 2025-12-02: 설문 132명, 인터뷰 53명, 2025-08 조사, 사용 59~60%(28%), 생산성 +50%(+20%), 일일 머지 PR +67%, 27%는 원래 안 했을 일, 완전 위임 0~20%, 도구 호출 9.8→21.2, 사람 턴 6.2→4.1, 기능 구현 14.3%→36.9% | P | 확인 | | https://anthropic.com/research/how-ai-is-transforming-work-at-anthropic |
| 50 | Coinbase: Cursor 사례 PR 75% 에이전트 생성, Cointelegraph 2026-07 코드 95~100%(2월 40%) | P | 확인 | Cursor 글 2026-06-23. Cointelegraph 2026-07-14, Rob Witoff(플랫폼 책임자) | https://cursor.com/blog/coinbase ; https://cointelegraph.com/news/over-95-of-coinbases-code-is-now-written-with-ai |
| 51 | Rakuten: 79% 단축(24일→5일), vLLM 7시간 단일 실행. "99.9% 수치 정확도는 2차 자료에만 있다" | P | 틀림 | 79%(24 **영업일**→5일)와 7시간은 맞음. **99.9%는 claude.com 고객 사례 페이지 자체에 있다**(본문 "99.9% numerical accuracy compared to the reference method", 요약 목록은 "99.9% accuracy on complex code modifications"로 서로 다름). 7시간 작업도 본문은 activation vector 추출 구현, 요약은 "refactoring"으로 다름 | https://www.claude.com/customers/rakuten |
| 52 | Shapiro 2026-01-23: NHTSA 비유, AI 네이티브 개발자 90%가 2단계, 거의 모두 3단계에서 멈춤, 본인 4단계, 4단계는 "12시간 자리 비움", 5단계는 스펙→소프트웨어 블랙박스, "But you are not done" | P | 확인 | 3단계 원문은 "almost everyone tops out here" | https://www.danshapiro.com/blog/2026/01/the-five-levels-from-spicy-autocomplete-to-the-software-factory/ |
| 53 | Willison 2026-01-28: 0~5단계 요약, 5단계 팀(이후 StrongDM으로 공개), 리뷰 대신 테스트·도구·시뮬레이션 | P | 확인 | StrongDM 이름은 2026-02-07 업데이트로 추가 | https://simonwillison.net/2026/Jan/28/the-five-levels/ |
| 54 | OpenAI 하네스 미검증 항목: "3인 팀, zero human code review, 병목이 사람 QA 용량, 초기에 시간 약 20%(금요일)를 AI slop 정리" | P | 수정 필요 | theneuron: 팀 규모 없음, "every Friday cleaning up AI slop"은 있으나 20% 없음. ZenML(강연): "zero human code reviews"는 있음, 병목은 QA 용량이 아니라 "the capacity to schedule prompts", 금요일 garbage collection 있으나 20% 없음. QA 병목과 20%는 두 출처 어디에도 없음 | https://www.theneuron.ai/explainer-articles/openais-harness-engineering-playbook-how-to-ship-1m-lines-of-code-without-writing-any/ ; https://www.zenml.io/llmops-database/zero-human-written-code-harness-engineering-for-autonomous-ai-agents-at-scale |

이번에 확인하지 않은 것: Osmani 글과 강연, Pragmatic Engineer 인터뷰, rywalker Coinbase Forge, arize, understandingdata, dev.to 비평, Ronacher 태그 목록, Jules/Cursor/Codex cloud/Factory 문서, Lenny's Newsletter.

## 보고서가 반드시 적용할 수정

1. **Stop 훅 예제(H):** "문서 예제가 `npm test` 실패 중 종료를 막는다"를 지운다. 그 예제는 TaskCompleted 훅 것이다. 대신 Stop 절의 사실을 쓴다: `stop_hook_active` 입력, **8회 연속 continuation 상한**(`CLAUDE_CODE_STOP_HOOK_BLOCK_CAP`), 테스트 실행 안내에는 `additionalContext`, 내장 `/goal` 명령.
2. **Stripe 1,300 PR/주(P):** 미검증이 아니다. Part 2(2026-02-19)의 1차 수치다(Part 1의 1,000개에서 증가).
3. **Rakuten 99.9%(P):** claude.com 고객 사례에 있다. 다만 페이지 안에서도 정의가 둘로 갈리므로 쓰려면 그 점을 밝힌다. 24일은 영업일이다.
4. **Steinberger(P):** Rust/Go 재작성은 실패했고 Zig 전환은 Codex가 한 번에 성공했다. "Rust/Go/Zig 모두 실패"는 틀린 요약이다.
5. **Gas Town 후속 수치(P):** 166개 머지 큐와 게이팅 중단, 에이전트 약 40개는 Yegge 후속 에세이를 인용한 danjou(2026-08-18)를 출처로 단다. "한 달 690억 토큰"은 삭제한다. letsdatascience 인용도 뺀다.
6. **OpenAI 팀 규모(H, P):** "3명 vs 7명 충돌"보다는 "3명으로 시작해 7명으로 늘었다는 2차 보도(원문 403, 미확인)"로 쓴다. 엔지니어당 3.5 PR의 단위(하루 vs 주)도 2차 출처끼리 충돌한다고 밝힌다. "QA 용량 병목"과 "시간의 20%"는 출처가 없으니 뺀다. 금요일 정리와 "zero human code reviews"는 2차 출처로 남겨도 된다.
7. **OpenAI 원문 날짜·저자(H):** 2026-02-11과 Lopopolo 저자는 이번에 페이지에서 확인하지 못했다. 쓰려면 미확인으로 표시한다.
8. **CURSED 3개월(H):** 인용한 ghuntley.com/ralph에는 기간이 없다. 다른 출처를 달거나 삭제한다.
9. **DAW 모델(H):** "Opus 4.6"은 원문이 명시하지 않는다. "문맥상 Opus 4.6"으로 쓴다.
10. **경미한 표현:** Cherny의 10~20%는 원격(웹) 세션 수치다. Anthropic 하네스 인용은 "dramatically improved"가 맞고, "clean, mergeable"은 따옴표를 빼고 풀어 쓴다. C 컴파일러 `--fast`는 VM 간에 무작위다.
