# 코딩 에이전트를 만드는 팀이 직접 쓰는 워크플로 (2026년 11월 기준)

조사 범위: Anthropic Claude Code 팀, OpenAI Codex 쪽(하네스 엔지니어링 팀, Codex 공식 가이드, openai/codex 저장소), Cursor 팀(cloud agents 글, github.com/cursor/plugins 의 pstack 형제 플러그인), Amp(Thorsten Ball), Google(Conductor). pstack 자체는 이 노트에서 다루지 않고 비교 기준으로만 쓴다.
표기: 날짜가 2026년이 아니거나 확인 못 한 것은 따로 적었다. 2차 요약에서만 확인한 내용은 "(2차)"로 표시했다. 원문 인용은 몇 단어로 줄였다.

## 1. 누가 만들었고, 그 사람의 역할을 1차 자료로 확인할 수 있나

### Takeaway
OpenAI(Ryan Lopopolo), Anthropic(Thariq Shihipar, Addy Osmani), Cursor 블로그 저자(Jonas Nelle, Alexi Robbins)는 본인 글이나 공식 블로그에서 소속을 확인했다. Boris Cherny와 Cat Wu의 직함, Cursor 플러그인 작성자(Eric Zakariasson, Dylan Gattey)의 사내 역할은 2차 자료나 plugin.json 작성자 필드로만 확인했다.

### Cited Findings
- Anthropic: Boris Cherny를 Claude Code를 만든 사람(creator)이자 Anthropic 소속으로 소개한다. 2026-01-10 기사이고 내용 다수가 그의 X 스레드로 링크된다 (2차) — [InfoQ](https://www.infoq.com/news/2026/01/claude-code-creator-workflow)
- Anthropic: Boris가 2026년 6월 Claude Code GA 1주년 대담을 Cat Wu와 했다고 본인 X에 썼다(1차). Cat Wu를 "Head of Product for Claude Code"라고 적은 것은 2차 기사다 — [Boris Cherny X](https://x.com/bcherny/status/2064034799711588805), [The Neuron 2026-06-09](https://www.theneuron.ai/explainer-articles/claude-code-creators-boris-cherny-and-cat-wu-explain-how-to-use-agent-loops/)
- Anthropic: Thariq Shihipar는 Anthropic의 MTS로 Claude Code를 맡고 있다. 2026-06-03 claude.dev 글 "How we use skills"에 나온다 — [claude.dev](https://claude.dev/blog/lessons-from-building-claude-code-how-we-use-skills/)
- Anthropic: Addy Osmani는 본인 사이트에 Anthropic MTS로 Claude Code를 맡는다고 적었다. AI Engineer 연사 페이지는 "Director of Engineering · Independent"라고 해서 서로 다르다. 본인 사이트가 1차 자료다 — [addyosmani.com](https://addyosmani.com/); 반대 자료 [ai.engineer](https://www.ai.engineer/speakers/addy-osmani)
- OpenAI: "Harness engineering"(2026-02-11)의 저자는 Ryan Lopopolo, Member of the Technical Staff이다 — [OpenAI](https://openai.com/index/harness-engineering/)
- Cursor: "Cursor agents can now control their own computers"(2026-02-24)의 저자는 Jonas Nelle과 Alexi Robbins이다. Robbins를 "co-head of engineering for asynchronous agents"라고 적은 것은 2차 기사다 — [Cursor blog](https://cursor.com/blog/agent-computer-use), [DevOps.com](https://devops.com/cursor-cloud-agents-get-their-own-computers-and-35-of-internal-prs-to-prove-it)
- Cursor 플러그인 작성자: plugin.json 기준으로 cursor-team-kit과 continual-learning은 "Eric Zakariasson", dyl-stack은 "Dylan Gattey", orchestrate·ralph-loop·thermos·advisor는 "Cursor", pstack은 Lauren Tan이다. cursor-team-kit 설명에 "Internal engineering team workflows"라고 적혀 있다 — [cursor/plugins](https://github.com/cursor/plugins), [cursor-team-kit/plugin.json](https://github.com/cursor/plugins/blob/main/cursor-team-kit/.cursor-plugin/plugin.json), [dyl-stack/plugin.json](https://github.com/cursor/plugins/blob/main/dyl-stack/.cursor-plugin/plugin.json)
- Amp: Thorsten Ball의 "How Thorsten Ball Uses Amp" 페이지는 2026-09-23에 갱신됐다. 공식 Amp 문서이고 "our codebase/our team"이라고 쓰지만 직함은 없다 — [ampcode.com](https://ampcode.com/docs/using-amp/thorsten)
- Google: Conductor는 2025-12-17 Google Developers Blog에서 Gemini CLI 프리뷰 확장으로 발표됐다(2026년 이전). 2026-07-16 글에서 Antigravity 등을 지원하는 플러그인으로 바뀌었다. README는 Keith Ballinger의 `.conductor` 프로젝트를 출발점으로 밝힌다 — [Google Dev Blog 2025-12](https://developers.googleblog.com/conductor-introducing-context-driven-development-for-gemini-cli/), [Google Dev Blog 2026-07](https://developers.googleblog.com/evolving-spec-driven-development-conductor-now-supports-antigravity/), [conductor README](https://github.com/gemini-cli-extensions/conductor)

### Inferences
- Conductor는 Google 팀이 "이렇게 일한다"고 밝힌 사내 워크플로가 아니라 외부 사용자에게 내놓은 제품형 프로토콜이다. "자기 팀의 실제 방식"으로 비교할 때는 무게를 낮춰야 한다.
- Cursor 형제 플러그인은 pstack처럼 개인 이름이 붙은 스택(dyl-stack)과 회사 이름의 공용 도구(orchestrate, ralph-loop)가 섞여 있다. 사내 사용을 직접 보여 주는 것은 cursor-team-kit의 "internal" 문구 정도다.

### Gaps
- Eric Zakariasson과 Dylan Gattey의 Cursor 내 직함은 1차 자료로 확인하지 못했다.
- Cat Wu의 직함을 Anthropic 공식 페이지에서 확인하지 못했다.
- Google Jules 팀이 자기 팀의 구체적인 작업 흐름을 공개한 1차 자료는 찾지 못했다. Gemini CLI 팀의 사내 흐름도 마찬가지다.

## 2. 실제로 쓰고 있다는 증거(저장소 활동, 사용량 수치, 발표)

### Takeaway
수치가 가장 구체적인 것은 OpenAI 하네스 팀이다(5개월, PR 약 1,500건, 엔지니어 1인당 하루 약 3.5건). 다음은 Cursor(머지된 PR의 30% 이상을 클라우드 에이전트가 만듦)와 Anthropic(사내 스킬 "수백 개", Codex는 OpenAI PR을 100% 리뷰)이다. cursor/plugins 저장소는 오늘까지 커밋이 이어지고 있다.

### Cited Findings
- OpenAI 하네스 팀: 2025년 8월 말 첫 커밋 이후 약 5개월 동안 PR 약 1,500건을 열고 머지했다. 엔지니어당 하루 약 3.5건이고, 인원은 3명에서 7명으로 늘었다. 코드 약 100만 줄을 사람이 한 줄도 쓰지 않았다고 한다 — [OpenAI](https://openai.com/index/harness-engineering/)
- OpenAI: Codex 공식 가이드에 "At OpenAI, Codex reviews 100% of PRs"라는 문장이 있다(페이지 날짜 없음) — [Codex best practices](https://learn.chatgpt.com/guides/best-practices)
- OpenAI의 openai/codex 저장소는 2026-09-30 커밋(#49713)에서 루트 `AGENTS.md`, `.codex/skills/`, `.codex/environments/environment.toml`을 지웠다. 커밋 메시지에 이유는 없다 — [openai/codex commit 1813127](https://github.com/openai/codex/commit/18131270fe82ef947830840eb5d6923d4b82609f)
- Cursor: "More than 30% of the PRs we merge"를 클라우드 샌드박스의 자율 에이전트가 만든다고 밝혔다(2026-02-24). 2차 기사에는 35%라는 수치와 엔지니어가 동시에 10~20개 작업을 돌린다는 발언도 있다 — [Cursor blog](https://cursor.com/blog/agent-computer-use), [DevOps.com](https://devops.com/cursor-cloud-agents-get-their-own-computers-and-35-of-internal-prs-to-prove-it)
- cursor/plugins: 커밋 852개, 별 19.6k, 2026-11-25에도 커밋이 있다. cursor-team-kit은 1.2.0, orchestrate는 1.1.0, dyl-stack은 0.1.0이다. orchestrate에는 `scripts/__tests__/` 아래 테스트 파일이 20개 넘게 있다 — [cursor/plugins](https://github.com/cursor/plugins), [GitHub API commits](https://api.github.com/repos/cursor/plugins/commits)
- Anthropic: 사내에서 쓰는 스킬이 "hundreds"이고 9개 범주로 나뉜다. 스킬 사용량은 PreToolUse 훅으로 회사 전체에서 기록한다 — [claude.dev 2026-06-03](https://claude.dev/blog/lessons-from-building-claude-code-how-we-use-skills/)
- Anthropic: Boris는 로컬 세션 약 5개와 웹 세션 5~10개를 함께 돌리고, 원격 세션의 10~20%는 버린다고 했다(2026-01). 하루 PR 22~27건이라는 수치는 2차 요약에만 있고 확인하지 못했다 — [InfoQ](https://www.infoq.com/news/2026/01/claude-code-creator-workflow)
- Anthropic: 2026-06 대담에서 Boris는 엔지니어링의 약 절반을 Remote Control로 휴대폰에서 한다고 했다(2차) — [The Neuron](https://www.theneuron.ai/explainer-articles/claude-code-creators-boris-cherny-and-cat-wu-explain-how-to-use-agent-loops/)
- Amp: Thorsten Ball은 약 8주 동안 로컬에서 코드를 쓰지 않았다고 했다(2026-09 갱신 페이지). 2026년 10월 발표 "How Thorsten Ball Uses Amp"도 있다 — [ampcode.com](https://ampcode.com/docs/using-amp/thorsten), [Amp Chronicle](https://ampcode.com/time-capsules/6)
- Conductor: GitHub 저장소 별 약 3.8k, 마지막 push는 2026-09-01이다 — [GitHub API](https://api.github.com/repos/gemini-cli-extensions/conductor)

### Inferences
- OpenAI가 공개 저장소(openai/codex)에서 AGENTS.md와 스킬을 지운 것은 "저장소 안 에이전트 지침" 관행이 바뀌었다는 신호일 수 있다. 다만 사내 다른 곳으로 옮겼을 가능성도 있어 결론을 내릴 수 없다.

### Gaps
- Codex 공식 가이드의 "100% of PRs" 문장에는 날짜가 없다.
- "How OpenAI uses Codex" PDF는 내용을 직접 읽지 못했고 발행일도 확인하지 못했다. 2025년 자료로 추정되며, 검색 요약에서만 봤다.
- Amp가 PR 없이 main에 바로 push한다는 말은 검색 요약에만 있다. Amp 1차 페이지에는 PR 언급이 없다.

## 3. 흐름: 진입점, 문서 계획과 승인자, 구현 주체, 검증 방법과 검증자, 리뷰, 머지

### Takeaway
2026년 흐름은 대체로 이렇다. 사람은 의도와 수용 기준을 주고, 에이전트가 구현과 자기 검증을 하고, 다른 에이전트가 리뷰하고, 머지는 사람이 하거나 게이트를 최소로 둔다. 무거운 문서 계획은 큰 작업에만 쓴다. OpenAI는 exec-plan, Conductor는 spec.md와 plan.md를 쓴다. Boris는 plan mode를 그만 썼다고 밝혔다. 검증자를 작성자와 분리하는 규칙이 가장 엄격한 곳은 Cursor orchestrate의 verifier다.

### Cited Findings
**Anthropic / Claude Code 팀**
- 2026-01 Boris: PR마다 Plan mode에서 계획을 다듬은 뒤 auto-accept로 바꿨다. 구현은 대개 "1-shot"이라고 했다. Claude Chrome 확장으로 모든 변경을 브라우저에서 직접 시험했고, 피드백 루프가 있으면 품질이 2~3배 좋아진다고 했다. `.claude/commands/`의 `/commit-push-pr`을 하루 수십 번 쓰고, 커밋·PR·단순화·검증에 서브에이전트를 쓴다 — [InfoQ](https://www.infoq.com/news/2026/01/claude-code-creator-workflow)
- 2026-06 Boris: plan mode 대신 auto mode를 쓴다고 본인 X에 썼다. 새 모델은 "less explicit planning"으로도 된다는 이유다(2차). 검증 기준은 "can the agent run the thing?"이다(2차) — [Boris X](https://x.com/bcherny/status/2064034799711588805), [The Neuron](https://www.theneuron.ai/explainer-articles/claude-code-creators-boris-cherny-and-cat-wu-explain-how-to-use-agent-loops/)
- 공식 best-practices 문서: 명세가 흐릿하면 Claude에게 인터뷰를 시켜 `SPEC.md`를 쓰게 한 뒤 새 세션에서 구현하라고 한다. 완료 조건은 세 가지로 강제한다. `/goal`(별도 모델이 매 턴 조건 충족을 확인), `Stop` 훅(exit 2면 작업으로 되돌림), "someone who didn't write the code"(`/code-review`는 대화를 보지 않은 새 서브에이전트가 리뷰)다 — [code.claude.com best practices](https://code.claude.com/docs/en/best-practices)
- 같은 문서: SPEC.md를 기준으로 리뷰를 시킬 때 프롬프트에 "skip style"을 넣으라고 한다. 지적을 다 고치면 쓸데없는 추상화가 생긴다는 경고다. 리뷰어 서브에이전트에 `tools: Read, Grep, Glob`만 주면 편집할 수 없다는 점을 하네스가 강제한다 — [code.claude.com best practices](https://code.claude.com/docs/en/best-practices)
- 같은 문서: 병렬 작업은 `claude -w`(worktree), 데스크톱 병렬 세션, 클라우드 세션으로 한다. `/batch`는 작업을 5~30개 단위로 나누고 계획을 보여 준 뒤, 승인되면 단위마다 worktree를 만들고 PR을 연다 — [code.claude.com best practices](https://code.claude.com/docs/en/best-practices)
- Thariq(2026-06): 리뷰는 `adversarial-review`로 한다. 새 눈의 서브에이전트를 띄워 지적이 "nitpicks"로 줄어들 때까지 반복한다. 머지는 `babysit-pr`이 PR 감시, flaky CI 재시도, 충돌 해결, auto-merge 켜기까지 맡는다. 배포는 `deploy-<service>`가 점진 롤아웃과 회귀 시 자동 롤백을 한다 — [claude.dev](https://claude.dev/blog/lessons-from-building-claude-code-how-we-use-skills/)
- Thariq(2026-09): 명세를 주고 빠진 것을 인터뷰받은 뒤, 낮은 effort로 구현하고 높은 effort로 검증·시험한다 — [claude.dev Spending your effort](https://claude.dev/blog/spending-your-effort/)
- routine(클라우드 예약 에이전트) 사례(2차): 버그 리포트·이슈를 감시하다가 수정 PR을 올리고 PR 주인에게 알린다. 약 5시간 방치된 버그 중 검증이 쉬운 것을 고치면 Boris가 머지한다 — [The Neuron](https://www.theneuron.ai/explainer-articles/claude-code-creators-boris-cherny-and-cat-wu-explain-how-to-use-agent-loops/)

**OpenAI**
- 하네스 팀: 엔지니어가 작업을 프롬프트로 주면 에이전트가 PR을 연다. 작은 변경은 일회성 계획으로 하고, 복잡한 작업은 진행 로그와 결정 로그가 든 exec-plan을 `docs/exec-plans/`(active/completed)에 체크인한다 — [OpenAI](https://openai.com/index/harness-engineering/)
- 같은 글: 검증은 이렇게 한다. Chrome DevTools Protocol로 DOM 스냅샷과 스크린샷을 얻는다. worktree마다 앱 인스턴스와 일회용 관측 스택(LogQL/PromQL)을 띄운다. 실패와 수정 장면을 영상으로 남긴다. 구조 테스트와 커스텀 린터로 아키텍처를 강제한다 — [OpenAI](https://openai.com/index/harness-engineering/)
- 같은 글: 리뷰는 Codex가 로컬에서 자기 변경을 리뷰하고, 로컬과 클라우드에 에이전트 리뷰를 따로 요청해 리뷰어가 만족할 때까지 반복한다("Ralph Wiggum Loop"). 사람 리뷰는 필수가 아니다. 에이전트가 직접 squash-merge하는 일이 많고, 머지 게이트는 최소다. flaky 테스트는 다시 돌리는 것으로 처리한다 — [OpenAI](https://openai.com/index/harness-engineering/)
- Codex 공식 가이드: 복잡하거나 모호한 작업은 Plan mode(`/plan`)로 하거나, 인터뷰로 명세를 만들거나, 긴 작업은 `PLANS.md` 템플릿을 쓴다. Codex가 테스트 작성, 검사 실행, 자기 diff 리뷰까지 하고 사람이 수락 전에 리뷰한다. `/review`는 base branch·커밋·미커밋 변경을 대상으로 하고, GitHub에서는 자동 리뷰나 @Codex 멘션으로 리뷰한다 — [Codex best practices](https://learn.chatgpt.com/guides/best-practices)

**Cursor**
- 사내: 클라우드 에이전트마다 VM과 전체 개발 환경이 있다. 에이전트가 자기가 바꾼 UI를 직접 조작하고 영상·스크린샷·로그를 PR에 붙인다. rebase, 충돌 해결, 한 커밋으로 squash까지 한다. 진입점은 웹, 모바일, 데스크톱, Slack, GitHub이다. 개발자의 역할은 "deciding what ships"이다 — [Cursor blog](https://cursor.com/blog/agent-computer-use)
- cursor-team-kit `review-and-ship`: base 대비 diff 수집, 관련 테스트 실행(없으면 추가하거나 공백을 기록), 정확성·회귀·보안·의도 적합 리뷰(diff가 크면 병렬 서브에이전트), 치명적 문제 수정, 선택 커밋, PR 열기 순서다. 스타일보다 정확성을 우선한다 — [review-and-ship SKILL.md](https://github.com/cursor/plugins/blob/main/cursor-team-kit/skills/review-and-ship/SKILL.md)
- cursor-team-kit `verify-this`: 주장을 반증 가능한 형태(조건, 지표, 임계값)로 다시 쓴다. baseline(머지 베이스 등)과 treatment를 같은 조건으로 잡고, 원자료를 비교해 `VERIFIED`, `NOT VERIFIED`, `INCONCLUSIVE` 중 하나로 판정한다. 산출물은 `/tmp/verify-this/<slug>/`에 claim, timeline, baseline, treatment, diff, verdict로 남긴다 — [verify-this SKILL.md](https://github.com/cursor/plugins/blob/main/cursor-team-kit/skills/verify-this/SKILL.md)
- cursor-team-kit `loop-on-ci` 와 `ci-watcher` 에이전트(model: fast, background): `gh pr checks`를 기준으로 초록이 될 때까지 고친다. `--no-verify` 금지, flaky는 한 번만 재시도하고 증거를 보고한다 — [loop-on-ci SKILL.md](https://github.com/cursor/plugins/blob/main/cursor-team-kit/skills/loop-on-ci/SKILL.md), [ci-watcher.md](https://github.com/cursor/plugins/blob/main/cursor-team-kit/agents/ci-watcher.md)
- orchestrate: `/orchestrate <goal>`로 명시적으로 부를 때만 동작한다(`disable-model-invocation: true`). 로컬 dispatcher가 클라우드 root planner를 띄운다. planner는 `plan.json`(작업 그래프, `scopedGoal`, `pathsAllowed`, `acceptance`, `verify`)만 쓰고 코딩하지 않는다. worker는 작업 하나와 저장소 클론 하나를 맡고 서로 통신하지 않으며 handoff 하나로 끝낸다. "Merges are tasks"이고 기본값은 verifier를 붙이는 것이다 — [orchestrate SKILL.md](https://github.com/cursor/plugins/blob/main/orchestrate/skills/orchestrate/SKILL.md), [planner.md](https://github.com/cursor/plugins/blob/main/orchestrate/skills/orchestrate/references/planner.md)
- orchestrate verifier 프롬프트: "Reading the diff is not verification"이라고 못 박고 코드를 실행해야 한다. 대상 소스를 고치지 못하고 merge·rebase·PR도 못 한다. 판정은 `live-ui-verified | unit-test-verified | type-check-only | verifier-blocked | verifier-failed` 중 하나다. 환경 실패를 얇은 검증처럼 포장하지 말고 `verifier-blocked`로 적으라고 한다. AC마다 증거를 적는다 — [verifier.md](https://github.com/cursor/plugins/blob/main/orchestrate/skills/orchestrate/prompts/verifier.md)
- dyl-stack: pstack `poteto-mode` 위에 얹은 얇은 라우터다. todolist 1번 항목은 pstack Principles 읽기다. playbook 단계를 todolist에 복사하고, 건너뛴 단계는 `skip: <reason>`으로 적는다. `/dyl-ready-pr`은 🟢가 될 때까지 deep review, ready 표시, 충돌 해결, CI 관리를 하되 머지는 하지 않는다 — [dyl-mode SKILL.md](https://github.com/cursor/plugins/blob/main/dyl-stack/skills/dyl-mode/SKILL.md), [dyl-stack README](https://github.com/cursor/plugins/blob/main/dyl-stack/README.md)
- ralph-loop: `stop` 훅이 같은 프롬프트를 `followup_message`로 다시 넣는다. `<promise>` 완료 문구가 나오거나 `--max-iterations`에 닿으면 멈추고, 상태는 `.cursor/ralph/scratchpad.md`에 둔다. 사람 판단이 필요하거나 목표가 모호한 작업에는 맞지 않는다고 스스로 밝힌다 — [ralph-loop README](https://github.com/cursor/plugins/blob/main/ralph-loop/README.md), [ralph-loop SKILL.md](https://github.com/cursor/plugins/blob/main/ralph-loop/skills/ralph-loop/SKILL.md)

**Amp**
- Thorsten Ball(2026-09): 진입점은 웹, macOS 앱, iOS 앱, Slack 순이다. 오케스트레이터 "Puck"으로 thread를 관리한다. 구현은 원격 격리 환경 "orb"에서 하고, orb가 다른 orb를 띄운다. 검증은 에이전트에게 끝에서 끝까지 시험해 "irrefutable proof"를 내라고 한다. 변경은 feature flag 뒤에 넣어 prod에 배포하고, 플래그를 본인에게 켜서 시험한 뒤 사내에 켠다. 코드는 핵심 부분만 읽는다. 에이전트가 push, CI 확인, 배포 대기, 트래픽 모니터링까지 한다 — [ampcode.com](https://ampcode.com/docs/using-amp/thorsten)

**Google Conductor**
- `/conductor:conductor-setup`이 product.md, tech-stack.md, workflow.md, tracks.md를 만든다. `/conductor:conductor-new-track`이 track마다 `spec.md`, `plan.md`, `metadata.json`을 만든다. 사람이 계획을 승인한 뒤 `/conductor:conductor-implement`가 plan.md의 체크박스를 채워 간다. `/conductor:conductor-review`는 가이드라인과 계획을 기준으로 감사하고 테스트를 돌린 뒤 plan.md에 "Review Fixes" 단계를 덧붙인다. `/conductor:conductor-revert`는 track, phase, task 단위로 git을 되돌린다 — [conductor README](https://github.com/gemini-cli-extensions/conductor)

### Inferences
- 계획 승인 단계는 약해지는 쪽이다. Boris는 plan mode를 그만 썼다. OpenAI는 큰 작업에만 exec-plan을 쓴다. Claude Code 문서는 `/batch`처럼 큰 기계적 변경에만 계획 승인을 둔다. 계획을 꼭 사람이 승인받는 곳은 Conductor뿐이다. j-dev-kit이 최근(백로그 016) 계획 승인을 없앤 방향과 맞는다.
- 검증자 분리는 강도에 따라 세 단계로 나눌 수 있다. (a) 같은 세션이 실행해서 증명한다: Boris의 Chrome, Amp의 proof, OpenAI의 CDP 영상. (b) 대화를 보지 않은 리뷰어가 본다: `/code-review`, adversarial-review, Codex 리뷰. (c) 수정 권한이 없는 별도 verifier가 실행해서 판정한다: orchestrate. pstack의 "non-author agent"와 j-dev-kit의 judge 에이전트는 (b)와 (c) 사이에 있다. j-dev-kit judge가 "실행 증거"를 요구하는지에 따라 위치가 갈린다.
- 머지 권한은 팀마다 극단적으로 다르다. OpenAI 하네스 팀은 에이전트가 직접 머지하고, Amp는 에이전트가 배포까지 한다. 반대로 dyl-stack은 같은 턴 안의 사람 허락이 있어야 머지하고, Boris는 routine이 고친 쉬운 버그를 자기가 머지한다. j-dev-kit의 "사용자 승인 후 머지"는 dyl-stack 쪽에 가깝다.

### Gaps
- Anthropic 팀 공통의 "표준 흐름"을 적은 1차 문서는 없다. 개인 발언과 스킬 예시를 모아 재구성했다.
- Cursor 사내 코드 리뷰 절차(사람 리뷰가 필수인지)는 블로그에 나오지 않는다.
- Amp의 PR 사용 여부는 1차 자료로 확인하지 못했다.

## 4. 언제 사람에게 묻나(자율 기준), 묻는 대신 무엇을 하나

### Takeaway
공통 원칙은 "판단이 필요할 때만 사람에게 올린다"이다. 묻는 대신 쓰는 장치는 다섯 가지다. 분류기(auto mode), 실행 가능한 완료 조건(/goal, Stop 훅, promise), 상태를 나타내는 handoff 값(blocked, verifier-blocked), 전체 정지 신호(Andon), feature flag다.

### Cited Findings
- OpenAI 하네스 팀: 사람은 우선순위를 정하고, 사용자 피드백을 수용 기준으로 바꾸고, 결과를 검증한다. 에이전트는 판단이 필요할 때만 사람에게 올린다. 에이전트가 막히면 사람은 빠진 도구, 가드레일, 문서를 찾아 Codex에게 만들게 한다 — [OpenAI](https://openai.com/index/harness-engineering/)
- Claude Code 문서: 새 세션의 기본값은 auto mode이고, 분류기가 위험한 행동만 막는다. 연속 3회 또는 누적 20회 막히면 다시 사람에게 묻는 모드로 돌아간다. "don't push until I've reviewed" 같은 말은 차단 신호로 처리되지만, 중요한 것은 deny 규칙으로 두라고 한다. 무인 실행 전에 확인할 다섯 가지 질문(완료 정의, 자기 검증 수단, 건드릴 수 있는 범위 등)이 있다 — [code.claude.com best practices](https://code.claude.com/docs/en/best-practices)
- Cat Wu(2차): 사람이 권한 프롬프트의 "99%"를 수락하면 그 확인은 의미가 없어진다고 했다. 그래서 auto mode를 만들었다. routine은 판단이 필요한 곳에서만 사람에게 올린다 — [The Neuron](https://www.theneuron.ai/explainer-articles/claude-code-creators-boris-cherny-and-cat-wu-explain-how-to-use-agent-loops/)
- Thariq: effort가 낮으면 사람과 오가며 일하고, max이면 "operate fully autonomously"이다. effort가 높을수록 Claude가 사용자 대신 가정을 더 많이 세운다 — [claude.dev Spending your effort](https://claude.dev/blog/spending-your-effort/)
- orchestrate Andon: 트리 전체에서 새 spawn을 멈추는 신호다. 상위 산출물이 틀렸거나, verifier 연쇄로 수용 기준이 틀렸음이 드러났거나, 인증이나 인프라가 복구 불가일 때 "concrete evidence"가 있어야만 올린다. 개별 작업이 막힌 것은 `Status: blocked` handoff로 처리한다. Slack `:rotating_light:` 반응으로도 올릴 수 있다 — [andon-block.md](https://github.com/cursor/plugins/blob/main/orchestrate/skills/orchestrate/prompts/andon-block.md), [planner.md](https://github.com/cursor/plugins/blob/main/orchestrate/skills/orchestrate/references/planner.md)
- dyl-stack: 머지와 auto-merge는 "current turn"의 허락이 있어야 하고, 허락은 다음 턴으로 넘어가지 않는다. 사용자가 계획 변경, 중단, 되돌리기를 말하면 바로 멈춘다. "roll that back" 같은 취향 거부는 따른다. 리뷰는 사람이 명시적으로 요청하지 않으면 초안만 쓴다 — [dyl-mode SKILL.md](https://github.com/cursor/plugins/blob/main/dyl-stack/skills/dyl-mode/SKILL.md)
- cursor-team-kit `workflow-from-chats`: 증거가 서로 엇갈리면("Contradicted") 파일을 쓰기 전에 사용자에게 묻는다. `verify-this`는 "the code is cleaner"처럼 모호한 주장을 받으면 측정 가능한 주장부터 요구한다 — [workflow-from-chats SKILL.md](https://github.com/cursor/plugins/blob/main/cursor-team-kit/skills/workflow-from-chats/SKILL.md), [verify-this SKILL.md](https://github.com/cursor/plugins/blob/main/cursor-team-kit/skills/verify-this/SKILL.md)
- ralph-loop: 사람에게 묻지 않고 같은 프롬프트를 되풀이한다. 완료 문구는 "completely and genuinely true"일 때만 출력하게 한다 — [ralph-loop SKILL.md](https://github.com/cursor/plugins/blob/main/ralph-loop/skills/ralph-loop/SKILL.md)
- Amp: 사람에게 묻는 대신 feature flag로 본인에게만 먼저 켜서 시험한다. 글과 Slack 메시지는 직접 쓴다. Slack에 자동 게시하던 automation은 껐다 — [ampcode.com](https://ampcode.com/docs/using-amp/thorsten)
- Codex 가이드: 따로 정한 "묻기 규칙"은 없다. 모호하면 계획부터 세우고 Plan mode의 확인 질문을 쓰며, 흐름이 익숙해질 때까지 승인과 샌드박스를 보수적으로 두라고 한다 — [Codex best practices](https://learn.chatgpt.com/guides/best-practices)
- Conductor: 계획 승인 뒤에 구현하는 것이 기본이다("keeping you firmly in the loop"). 터미널에서는 선택지를 `[1] Option A` 같은 번호 메뉴로 보여 준다 — [conductor README](https://github.com/gemini-cli-extensions/conductor)

### Inferences
- pstack의 "never block on the human"과 가장 가까운 것은 OpenAI 하네스 팀과 Amp다. j-dev-kit처럼 머지 직전에 사람 승인 게이트를 두는 쪽은 dyl-stack과 Boris의 routine 머지가 대응한다.
- j-dev-kit이 빌려 올 만한 것은 orchestrate의 구분이다. 작업 단위의 `blocked`(작업 하나가 막힘, 계속 진행)와 전체 Andon(근거가 있을 때 전체 정지)을 나누면, "사람에게 묻는 곳을 꼭 필요한 것만 남긴다"는 백로그 016을 기준으로 정리할 수 있다.

### Gaps
- Amp와 OpenAI가 "판단이 필요한 경우"를 구체적으로 어떻게 정의하는지는 공개 자료에 없다.

## 5. 결정과 진행을 어디에 기록하나(파일, 로그, PR, 메모리)

### Takeaway
기록은 저장소 안 문서가 진실의 원천이 되는 쪽(OpenAI `docs/`, Conductor `conductor/tracks/`, orchestrate의 `plan.json`·`state.json`·`handoffs/`)과, 대화 기록에서 규칙을 뽑아 AGENTS.md나 CLAUDE.md에 쌓는 쪽(continual-learning, Boris의 PR 태그, Codex의 "같은 실수 두 번이면 회고")으로 나뉜다.

### Cited Findings
- OpenAI: `AGENTS.md`(약 100줄)는 목차 역할이고, `docs/`가 기록 시스템이다. 하위에 `design-docs/`(검증 상태 색인), `product-specs/`, `exec-plans/active|completed`, `tech-debt-tracker.md`, `QUALITY_SCORE.md`(도메인별 등급을 시간에 따라 기록)가 있다. 린터와 CI가 문서의 최신성과 교차 링크를 검사한다. doc-gardening 에이전트가 낡은 문서를 찾아 PR을 연다. 금요일마다 하던 정리(주의 약 20%)는 "golden principles"와 주기적인 백그라운드 Codex 작업으로 바꿨다 — [OpenAI](https://openai.com/index/harness-engineering/)
- Codex 가이드: 같은 실수가 두 번 나오면 회고를 시키고 AGENTS.md를 고친다. 리뷰 기준은 `code_review.md`로 따로 두고 AGENTS.md에서 참조한다. "skills define the method and scheduled tasks define the schedule"이라고 정리한다 — [Codex best practices](https://learn.chatgpt.com/guides/best-practices), [Custom code review rules](https://developers.openai.com/blog/custom-code-review-rules-for-codex)
- Anthropic: 팀마다 `CLAUDE.md`를 git에 두고 실수와 관행을 적는다. Boris는 동료 PR에 Claude를 태그해 배운 것을 CLAUDE.md에 넣고, 크기는 약 2.5k 토큰이다(2026-01, 2차가 X를 링크) — [InfoQ](https://www.infoq.com/news/2026/01/claude-code-creator-workflow)
- Anthropic 스킬: `standup-post`는 `standups.log`를 남겨 다음 실행 때 "reads its own history"한다. 설정은 `config.json`에 두고, 플러그인 데이터는 `${CLAUDE_PLUGIN_DATA}`에 둔다. 스킬에서 가장 신호가 큰 부분은 gotcha 섹션이다 — [claude.dev](https://claude.dev/blog/lessons-from-building-claude-code-how-we-use-skills/)
- orchestrate: git과 디스크가 기반이다. `plan.json`은 작업 그래프, `state.json`은 상태와 브랜치, `handoffs/*.md`는 worker와 verifier 산출물, `attention.log`는 운영자가 볼 실패와 결정이다. Slack은 사람이 보는 미러일 뿐이고, Slack이 죽어도 정확성은 변하지 않는다 — [planner.md](https://github.com/cursor/plugins/blob/main/orchestrate/skills/orchestrate/references/planner.md)
- continual-learning: `stop` 훅이 최소 10턴, 120분 간격, transcript mtime 변화를 조건으로 학습을 띄운다(trial 모드는 3턴, 15분). `agents-memory-updater` 서브에이전트가 새로 생기거나 바뀐 transcript만 읽어 `AGENTS.md`의 `## Learned User Preferences`, `## Learned Workspace Facts`에 평문 bullet로 반영한다. 각 섹션은 최대 12개이고 같은 뜻은 합친다. 증거나 확신도 태그는 쓰지 않는다 — [continual-learning README](https://github.com/cursor/plugins/blob/main/continual-learning/README.md), [agents-memory-updater.md](https://github.com/cursor/plugins/blob/main/continual-learning/agents/agents-memory-updater.md)
- cursor-team-kit `workflow-from-chats`: 최근 7일 대화에서 선호를 "preference atoms"(trigger, 단계, 결정 규칙, 품질 기준, 멈춤 조건, 증거, 확신도)로 뽑는다. 결과물로 skill, rule, workflow doc, 또는 아무것도 만들지 않는 것 중 하나를 고른다. `what-did-i-get-done`과 `weekly-review`는 커밋에서 진행 요약을 만든다 — [workflow-from-chats SKILL.md](https://github.com/cursor/plugins/blob/main/cursor-team-kit/skills/workflow-from-chats/SKILL.md), [cursor-team-kit README](https://github.com/cursor/plugins/blob/main/cursor-team-kit/README.md)
- Amp: thread가 팀 기억이고 AGENTS.md가 공유 문맥이다. 에이전트가 다른 orb의 thread를 읽고 비교한다 — [ampcode.com](https://ampcode.com/docs/using-amp/thorsten)
- Conductor: 전체 상태는 `conductor/tracks.md`에, 작업별 상태는 `tracks/<id>/plan.md` 체크박스에 둔다. 완료되면 프로젝트 문맥 파일을 동기화하고, 리뷰 지적은 plan.md의 "Review Fixes" 단계로 남긴다 — [conductor README](https://github.com/gemini-cli-extensions/conductor)
- verify-this: 검증 기록을 claim.md, timeline.md, baseline/, treatment/, diff/, verdict.md로 남긴다. 민감한 내용이면 디스크에 쓰지 않는다 — [verify-this SKILL.md](https://github.com/cursor/plugins/blob/main/cursor-team-kit/skills/verify-this/SKILL.md)

### Inferences
- j-dev-kit의 백로그 항목은 OpenAI exec-plan(active/completed, 진행·결정 로그)과 Conductor track(spec.md와 plan.md)의 중간쯤이다. 항목 안에 "결정 로그"와 "진행 체크리스트" 칸을 두면 두 방식의 장점을 함께 얻을 수 있다.

### Gaps
- OpenAI exec-plan 파일의 실제 양식(템플릿)은 공개 글에 없다.

## 6. 무엇이 독특하고, 백로그 항목 기반 Claude Code 플러그인(j-dev-kit)이 빌려 올 것은 무엇인가

### Takeaway
빌려 올 가치가 가장 큰 것은 다섯 가지다. (1) orchestrate verifier의 "실행 증거 강도" 판정 값과 수정 권한 박탈, (2) verify-this의 baseline/treatment 판정, (3) Claude Code 문서의 "spec 대비 리뷰, skip style"과 읽기 전용 리뷰어, (4) OpenAI의 exec-plan과 결정 로그, 주기적 정리 에이전트, (5) continual-learning식 학습 반영과 Conductor의 리뷰 지적을 계획에 덧붙이는 방식이다.

### Cited Findings
- 팀별로 독특한 점은 다음과 같다.
  - OpenAI: 사람이 코드를 쓰지 않는다는 제약 아래에서 환경, 의도, 피드백 루프를 설계하는 일을 "harness engineering"이라고 부른다. 짧은 AGENTS.md가 목차가 된다 — [OpenAI](https://openai.com/index/harness-engineering/)
  - Anthropic: 검증 스킬이 품질에 "most measurable impact"를 준다. 엔지니어 한 명이 일주일을 검증 스킬에만 쓰라고 권한다. 스킬은 Slack에 공유되다가 쓰임이 생기면 PR로 마켓플레이스에 들어간다 — [claude.dev](https://claude.dev/blog/lessons-from-building-claude-code-how-we-use-skills/)
  - Anthropic: routine이 사람보다 먼저 버그를 고친다(2차) — [The Neuron](https://www.theneuron.ai/explainer-articles/claude-code-creators-boris-cherny-and-cat-wu-explain-how-to-use-agent-loops/)
  - Cursor orchestrate: 오래 도는 에이전트 상태 대신 스크립트와 JSON 상태 파일로 수렴시킨다("Long-running agent loops drift"). 형제 사이 통신 없이 handoff로만 위로 전달한다 — [orchestrate SKILL.md](https://github.com/cursor/plugins/blob/main/orchestrate/skills/orchestrate/SKILL.md)
  - dyl-stack: 실패가 나면 고치기 전에 `Root cause: <X> because <Y>` todo를 채운다. null guard, retry, `.skip`, 스냅샷 갱신 등은 그 줄로 정당화되기 전까지 증상 수정으로 본다 — [dyl-mode SKILL.md](https://github.com/cursor/plugins/blob/main/dyl-stack/skills/dyl-mode/SKILL.md)
  - Amp: orb 여러 개에 변경을 모르는 같은 작업을 시켜 "evals for how agent-friendly the codebase is"로 쓴다 — [ampcode.com](https://ampcode.com/docs/using-amp/thorsten)
  - Conductor: 커밋 해시가 아니라 논리 단위(track, phase, task)로 되돌린다 — [conductor README](https://github.com/gemini-cli-extensions/conductor)
  - Addy Osmani의 "keep the maker away from the checker"(2차 기사의 요약 인용) — [The Neuron](https://www.theneuron.ai/explainer-articles/claude-code-creators-boris-cherny-and-cat-wu-explain-how-to-use-agent-loops/)

### Inferences
j-dev-kit(`/task create·start·end`)에 맞춘 차용 후보:
1. judge 보고서에 검증 강도 값을 넣는다. orchestrate의 `live-ui-verified / unit-test-verified / type-check-only / verifier-blocked / verifier-failed`와 AC별 `met / not met / n/a` 증거를 쓴다. "diff만 읽은 판정"은 판정으로 치지 않고, 환경 실패는 `blocked`로 따로 적는다. judge 에이전트에서 Edit/Write를 빼는 것은 Claude Code 문서가 권하는 대로 하네스가 강제하게 한다.
2. 리뷰 프롬프트에 "AC와 spec 대비 빠진 것만, skip style"을 넣어 지적을 모두 고치다 생기는 과잉 수정을 막는다. Anthropic `adversarial-review`의 "지적이 nitpick으로 떨어질 때까지 반복"을 종료 조건으로 쓴다.
3. 버그 항목의 AC를 verify-this식 반증 가능한 주장(조건, 지표, 임계값)으로 쓰게 하고, end에서 baseline과 treatment를 비교한다.
4. start 세션에서 AC를 `/goal` 조건이나 Stop 훅으로 걸어, 하위 세션이 AC를 남긴 채 끝나지 못하게 한다. ralph-loop의 "거짓 promise 금지"와 같은 취지다.
5. 백로그 항목을 OpenAI exec-plan처럼 진행 로그와 결정 로그가 남는 살아 있는 문서로 만든다. 완료되면 completed로 옮긴다. end의 리뷰 지적은 Conductor처럼 항목 안 "리뷰 수정" 단계로 덧붙인다.
6. continual-learning처럼 end 뒤나 Stop 훅 주기에 transcript에서 배운 것을 CLAUDE.md 학습 섹션(개수 상한, 같은 뜻 병합)에 반영한다. OpenAI처럼 낡은 문서와 규칙 위반을 찾는 정리 작업(예약 실행)을 따로 둔다.
7. 사람에게 묻는 지점은 작업 단위의 `blocked` 보고와 전체 Andon식 정지로 나눈다. 머지 허락은 dyl-stack처럼 "현재 턴에서만 유효"로 명시한다.
8. 실패 수정 항목에는 dyl-stack의 `Root cause: X because Y` 줄을 필수로 둔다.

pstack과 비교한 위치:
- pstack(사람을 막지 않음, 작성자가 아닌 에이전트가 검증한 뒤 머지)은 OpenAI 하네스 팀과 Cursor 사내 흐름에 가깝다. dyl-stack은 그 위에 머지 게이트를 다시 세운 변형이다.
- j-dev-kit은 계획 승인을 없앤 점에서 2026년 흐름(Boris, OpenAI)과 맞는다. 사용자 승인 후 머지하는 점은 dyl-stack과 같다. 별도 judge를 두는 점은 orchestrate verifier와 같지만, 실행 증거를 의무화하지 않으면 그보다 약하다.

### Gaps
- 각 팀이 쓰는 백로그나 이슈 형식(수용 기준 작성 방식)은 OpenAI의 "사용자 피드백을 수용 기준으로" 한 줄 말고는 공개 자료가 없다.
- Gemini CLI와 Jules 팀이 자기 저장소를 어떻게 운영하는지는 이번 조사에서 1차 자료를 찾지 못했다.
