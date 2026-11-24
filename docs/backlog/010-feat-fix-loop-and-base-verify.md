---
id: '010'
title: 고치기 반복에 상한, 리뷰 지적은 만든 세션이 고치고 기계적인 것만 위임, 압축 뒤 절차 다시 읽기, 검증 명령은 기준 브랜치에서, 강조 대신 이유 (전문가 스킬 활용 2·6·7·8)
status: In Progress
labels: [feat]
priority: medium
dependencies: []
created_date: 2026-11-23
updated_date: 2026-11-24
---

## Description

최고 실무자들이 Claude Code 스킬을 어떻게 쓰는지 조사한 보고서 `docs/backlog/references/2026-11-23-전문가-스킬-활용.md`의 5절 새 후보 2·6·7·8과, 이 항목을 만들며 사용자가 더한 리뷰 지적 수정 설계(5)를 한 항목으로 한다. 사용자가 나누지 않기로 정했다. 보고서의 후보 1·3·5는 008, 후보 4는 009 에 넣었다. 아래 A·E·P 번호는 보고서의 출처 번호이고, 원문 URL 은 맨 끝 참고 자료에 있다.

1. **고치고 다시 확인하는 반복에 상한(보고서 후보 2):** 검사가 세 번 고쳐도 실패하면 멈추고 사람을 부른다(E3). 세 회차 뒤에는 접근을 다시 생각한다(E4). 자동 이어 가기는 두세 번에서 멈춘다(A10). obra 는 "다섯 번까지" 제한이 압축으로 잘리자 한 작업에서 18번 고친 사례를 적었다(P2 v7.0.1). 보고서 공통분모 14 다. 지금 `frontend-start-check`(`SKILL.md:35` "실패는 고치고 다시 넘긴다")와 `frontend-end-check`(`SKILL.md:39` "실패는 다시 고친다")는 실패가 이어지면 끝없이 고치고 다시 넘길 수 있다. `verify-on-stop.sh`는 이미 같은 내용으로는 한 번만 되돌려 보내니 그대로 둔다.
2. **압축 뒤 절차 파일 다시 읽기(보고서 후보 6):** 스킬은 한 번 들어오면 다시 읽히지 않고, 압축 뒤에는 불러온 스킬마다 앞 5,000토큰만 다시 붙는다(A1, E13). 그래서 중요한 지시는 위에 두고 긴 스킬은 줄이라고 한다(공통분모 8, A1·E13·P2 v7.0.1). `task` 스킬은 `SKILL.md:25`에서 절차 파일(`start.md` 83줄, `end.md` 98줄)을 Read 도구로 읽게 하는데, Read 로 읽은 파일이 압축 뒤 다시 붙는다는 말은 문서에 없다. 긴 `start` 세션에서 6단계 규칙이 흐려질 수 있다. **근거가 약하다: 이것은 문서에서 읽은 추론이고 직접 재지 않았다(보고서 6절 "추론").** 그래서 먼저 압축 뒤 절차 파일 내용이 정말 사라지는지 확인하고, 사라질 때만 고친다.
3. **검증 명령을 기준 브랜치의 CLAUDE.md 에서 읽기(보고서 후보 7):** "If a change can modify the check that judges it, the check is broken."(E3) 지금 `verify-on-stop.sh:25-27`은 작업 트리의 `CLAUDE.md`에서 검증 명령을 읽어, 작업 브랜치가 검증 명령을 바꾸면 Stop 훅도 바뀐 명령을 돌린다. **근거가 약하다: 공통분모가 아니다.** 비슷한 생각은 Simon 의 Showboat(에이전트가 꾸밀 수 없게 실제 출력을 기록, P6)뿐이다(보고서 후보 7).
   - 기준 브랜치에서 검증 명령 자체를 바꾸는 항목: 훅은 그래도 기준 브랜치의 명령으로 판정하고, 작업 트리의 명령이 다르면 되돌려 보내는 메시지에 "이 브랜치가 검증 명령을 바꿨다, 바뀐 명령은 머지 뒤부터 쓰인다"고 함께 알린다. 바뀐 명령은 `/task end`가 사람의 리뷰와 함께 본다. 기준 브랜치에 CLAUDE.md 나 검증 명령 줄이 없을 때(첫 설정)만 작업 트리의 것을 쓴다.
4. **`mockup.md`의 굵은 강조를 이유로(보고서 후보 8):** 강조·대문자·MUST 를 더하지 말고 목표와 제약을 이유와 함께 담백하게 쓴다(공통분모 9, A2·A7·A8·E1·E5·E15·P1. 반례는 A4 의 "MUST filter" 한 줄). 저장소에 남은 강조는 `ui-design/references/mockup.md:7`의 "**시안 수는 꼭 묻는다.**" 하나다. 붙일 이유는 사용자가 확인했다: 개수에 따라 2단계(방향)를 할지가 갈리기 때문. 중요도는 낮다.
5. **리뷰 지적은 만든 세션이 고치고, 기계적인 수정만 작은 모델에 위임(사용자가 더함, 대상 `end.md` 5단계와 번역본):**
   - **기본은 만든 세션이 고친다.** 판정을 거친 지적을 작업 세션이 `receiving-code-review`로 가리고, 판단이 필요한 수정(설계 변경, 여러 파일에 걸친 수정)은 직접 한다. 근거: 타당한 피드백은 만든 Claude 에게 돌아가고 그 Claude 가 가려 반영한다(Felix 대담 [15:19](https://www.youtube.com/watch?v=D-SVFneJ_Nk&t=919s)–15:27). 역할로 나눈 서브에이전트는 안 된다(보고서 2.1, 공통분모 10: HumanLayer P12·P13, Boris E7, Sarkis E10). 서브에이전트는 더 똑똑하지 않다(A2).
   - **기계적인 수정만 수정 에이전트에 넘긴다.** 지적이 위치와 고칠 내용을 정확히 말해 판단이 남지 않는 것이다. 이런 수정을 모아 에이전트 하나(Agent 도구 `model: sonnet`, 노력 높음)에 넘긴다. 넘기는 것은 지적 목록, 항목 파일, "동작을 바꾸면 실패하는 테스트 먼저" 규칙이다. 근거: 정해진 흐름이 되면 작은 모델로(나델라 [48:18](https://www.youtube.com/watch?v=0NE89Nzfk20&t=2898s)), 단순한 서브에이전트 일은 작은 모델(A2), 일마다 모델을 고른다(A11). **노력 수준(높음)에 대한 자료는 없다. 사용자가 정한 것이다.**
   - **고친 뒤 판정은 고친 쪽의 보고가 아니라** 검증 명령과 판정 에이전트(UI 는 `frontend-evaluator`)로 한다(공통분모 11).
   - **같은 지적이 세 번 고쳐도 남으면 멈추고 사용자에게 넘긴다**(공통분모 14). 1의 상한과 같은 규칙으로 맞춘다.
   - **Sonnet 위임은 가설이다.** 같은 기계적 지적 사례를 작업 세션이 고친 판과 Sonnet 에이전트가 고친 판으로 비교해 품질과 비용을 재고, 나빠지지 않을 때만 기본으로 둔다(공통분모 3, 나델라 [50:57](https://www.youtube.com/watch?v=0NE89Nzfk20&t=3057s)). eval 은 008 이 만드는 `plugins/*/evals/` 방식을 따르고, 먼저 하나를 `--max-cost-usd 5`로 돌려 비용을 보고한다.

008·009 와 겹치는 곳(묶지 않는다. 함께 돌리고 충돌은 머지 때 푼다):

- `end.md`: 008 이 3단계 리뷰 모델(한 단계 낮추기)과 4단계 판정(작업 세션 밖으로)을 고친다. 이 항목의 5는 그 판정을 거친 지적을 5단계에서 누가 고치는지다. 009 도 4단계 선택지("자동 검사로 막기")와 5단계("나중"처럼 새 항목 만들기), 기준 브랜치에서 테스트 확인을 더한다. eval 방식은 008 #8 을 따른다.
- `frontend-start-check`·`frontend-end-check`: 009 가 같은 "브라우저 확인"·"고친 뒤 할 것" 목록의 개발 서버 문단을 스크립트로 바꾼다. 이 항목은 바로 옆 "실패" 줄을 고친다.
- `task` `SKILL.md`: 008 이 `argument-hint`(서베이)와 2절 5(하위 세션 지휘)를 고친다. 이 항목은 1절 마지막 줄(절차 파일 읽기)을 고친다.
- `verify-on-stop.sh`, `scripts/test-verify-on-stop.sh`, `mockup.md`는 008·009 가 고치지 않는다.

가정:
- 상한 "세 번"은 E3 의 숫자다. 무엇을 "같은 기준"으로 셀지(AC 하나, 리뷰 지적 하나)는 `/task start` 계획에서 정한다.
- 압축 뒤 확인은 `/compact`로 한다. 확인 방법과 결과는 `Implementation Notes`에 적는다.
- 훅이 기준 브랜치 이름을 어디서 읽을지(작업 트리 CLAUDE.md 의 "기준 브랜치:" 줄, 없으면 `main`)는 계획에서 정한다.
- 기계적인 지적을 어떻게 가려낼지, 비교에 쓸 사례는 계획에서 정한다.

이번에 빼는 것: `verify-on-stop.sh`의 "한 번만" 규칙. 보고서 5절 후보 1·3·4·5(008·009).

참고 자료:

- A1 Extend Claude with skills, Claude Code 문서(열람 2026-11-23) — https://code.claude.com/docs/en/skills
- A2 Best practices for Claude Code, Claude Code 문서 — https://code.claude.com/docs/en/best-practices
- A4 Skill authoring best practices, Claude Platform 문서 — https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
- A7 skill-creator SKILL.md, anthropics/skills — https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md
- A8 Prompting best practices, Claude Platform 문서 — https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices
- A10 Prompting Claude Opus 5.5, Claude Platform 문서 — https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5-5
- A11 code-review 명령, anthropics/claude-plugins-official — https://github.com/anthropics/claude-plugins-official/blob/main/plugins/code-review/commands/code-review.md
- E1 Lessons from building Claude Code: How we use skills, Thariq Shihipar — https://claude.com/blog/lessons-from-building-claude-code-how-we-use-skills
- E3 How the Claude Code team thinks about verification, Addy Osmani — https://claude.dev/blog/how-the-claude-code-team-thinks-about-verification/
- E4 How the Claude Code team does code review, Addy Osmani 외 — https://claude.dev/blog/solving-code-review-at-anthropic/
- E5 Building Claude Code(YC Startup School 자동 자막), Boris Cherny — https://podscripts.co/podcasts/y-combinator-startup-podcast/boris-cherny-building-claude-code
- E7 AI & I 팟캐스트 대본, Boris Cherny·Cat Wu — https://every.to/podcast/transcript-how-to-use-claude-code-like-the-people-who-built-it
- E10 Building agents: When to fold subagents into your main agent loop, Diane Sarkis — https://claude.com/resources/articles/building-agents-when-to-fold-subagents-into-your-main-agent-loop
- E13 Steering Claude Code: when to use CLAUDE.md, skills, hooks, and subagents, Michael Segner — https://claude.com/resources/articles/steering-claude-code-skills-hooks-rules-subagents-and-more
- E15 Cat & Thariq 대담(Simon Willison 정리) — https://simonwillison.net/2026/Jul/21/cat-and-thariq/
- P1 writing-skills SKILL.md, Jesse Vincent(obra) — https://github.com/obra/superpowers/blob/main/skills/writing-skills/SKILL.md
- P2 superpowers RELEASE-NOTES.md(v7.0.1), Jesse Vincent — https://github.com/obra/superpowers/blob/main/RELEASE-NOTES.md
- P6 Agentic Engineering Patterns, Simon Willison — https://simonwillison.net/guides/agentic-engineering-patterns/
- P12 Skill Issue: Harness Engineering for Coding Agents, Kyle Mistele(HumanLayer) — https://www.humanlayer.dev/blog/skill-issue-harness-engineering-for-coding-agents
- P13 Context-efficient backpressure, Dex Horthy(HumanLayer) — https://www.humanlayer.dev/blog/context-efficient-backpressure
- Felix Rieseberg 대담(15:19) — https://www.youtube.com/watch?v=D-SVFneJ_Nk&t=919s
- 나델라 영상 「Software engineering after code becomes cheap with Satya Nadella」, The Pragmatic Engineer(48:18) — https://www.youtube.com/watch?v=0NE89Nzfk20&t=2898s , (50:57) — https://www.youtube.com/watch?v=0NE89Nzfk20&t=3057s

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 `frontend-start-check`과 `frontend-end-check`(원문·번역본)에서 "실패"를 고치고 다시 넘기는 자리마다, 같은 기준이 세 번 고쳐도 실패하면 멈추고 실패한 기준과 시도한 것을 사용자에게 알린다고 적혀 있다
- [ ] #2 `/compact` 뒤 `task` 세션이 절차 파일 내용을 아직 따르는지 확인한 방법과 결과가 `Implementation Notes`에 있다. 내용이 사라졌으면 `task` `SKILL.md`(원문·번역본)에 "대화가 압축된 뒤에는 고른 절차 파일을 다시 읽고 지금 단계부터 이어 간다"는 뜻의 한 줄이 있고, 사라지지 않았으면 `SKILL.md`는 그대로다
- [ ] #3 작업 브랜치에서 CLAUDE.md 의 검증 명령을 바꾸고 DoD 를 체크하면, Stop 훅이 기준 브랜치 CLAUDE.md 의 명령을 돌리고 검증 명령이 바뀌었다고 알린다. `scripts/test-verify-on-stop.sh`에 이 경우와 "기준 브랜치에 검증 명령이 없으면 작업 트리의 것"인 경우의 테스트가 있고 통과한다
- [ ] #4 `mockup.md`(원문·번역본) 1절에 굵은 강조가 없고, 시안 수를 묻는 이유(개수에 따라 2단계를 할지가 갈린다)가 한 구절로 붙어 있다. 3절의 "**멈춘다.**"도 굵은 강조 없이 이유(사용자가 캔버스에서 직접 고르게 하려고)와 함께 적혀 있다(start 계획에서 사용자가 더함)
- [ ] #5 `end.md` 5단계(원문·번역본)에 다음이 적혀 있다: 판단이 필요한 수정은 작업 세션이 직접 고친다. 위치와 고칠 내용이 정해진 기계적인 수정만 모아 에이전트 하나(`model: sonnet`, 노력 높음)에 지적 목록, 항목 파일, "동작을 바꾸면 실패하는 테스트 먼저" 규칙과 함께 넘긴다. 고친 뒤 판정은 검증 명령과 판정 에이전트(UI 는 `frontend-evaluator`)로 한다. 같은 지적이 세 번 고쳐도 남으면 멈추고 사용자에게 넘긴다. 작업 세션이 고친 판과 Sonnet 에이전트가 고친 판의 품질·비용 비교 방법과 결과(먼저 하나를 `--max-cost-usd 5`로 돌린 비용 포함)가 `Implementation Notes`에 있고, 결과가 나쁘면 위임 없이 작업 세션이 고치는 쪽으로 적혀 있다
- [ ] #6 `start.md` 6단계 4(원문·번역본)의 "실패는 고치고 다시 판정받는다"에, 같은 AC 가 세 번 고쳐도 실패하면 멈추고 실패한 AC 와 시도한 것을 사용자에게 알린다고 적혀 있다(start 계획에서 사용자가 더함)

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 원문(`plugins/`)을 고친 곳은 번역본(`i18n/en/`)도 같이 고쳤다
- [ ] #3 고친 플러그인마다 `plugin.json` `version`을 올렸고, README 두 개와 `marketplace.json` 설명을 맞췄다

<!-- DOD:END -->

## Implementation Plan

승인: 2026-11-24, 사용자 "추천안대로 승인"(부모 세션이 전함). 두 질문 모두 추천안대로 했다. AC #6(`start.md` 6단계 4 상한)을 더했고 AC #4 를 3절까지 넓혔다.

**무엇을 하나.** frontend 점검 두 곳과 `start.md` 6단계 4, `end.md` 5단계의 고치기 반복에 "세 번이면 멈춤"을 넣는다. 압축 뒤 절차 파일이 남는지 재 보고, 사라질 때만 `SKILL.md`에 한 줄을 더한다. Stop 훅은 기준 브랜치 CLAUDE.md 의 검증 명령으로 판정한다. `mockup.md`의 굵은 강조 둘은 이유로 바꾼다. 기계적인 리뷰 수정을 Sonnet 에 맡기는 안은 실제 사례 eval 로 잰 뒤에 정한다. 빼는 것: 훅의 "한 번만" 규칙, 보고서 후보 1·3·4·5.

**항목을 만들 때와 달라진 자리(main 2dba1aa).**
- `frontend-end-check`의 "실패" 줄은 39 → 38 이다. 009 가 개발 서버 문단을 줄였다.
- `verify-on-stop.sh`의 검증 명령 읽기는 25-27 → 25-34 다.
- `end.md` 5단계는 77-83 이다. 009 의 "나중/막기" 줄이 있다. UI 가 아닌 수정을 고친 뒤 판정하는 에이전트는 없다.
- `start.md`는 91줄, `end.md`는 115줄이다.
- 항목의 "강조는 `mockup.md:7` 하나"는 틀렸다. `mockup.md:30`에 "**멈춘다.**"가 또 있다.

**도구와 단계.**
- 원문과 번역본을 같이 고친다.
- 훅은 bash 로 고친다. 테스트 `scripts/test-verify-on-stop.sh`를 먼저 쓴다.
- 압축 확인은 헤드리스 `claude -p`, `--resume`, `/compact`와 세션 JSONL 로 한다.
- eval 은 `claude plugin eval`(2.1.330)로 008 방식을 따른다: 판마다 사본, Opus 로 시험, `--judge-model sonnet`으로 채점, `--allow-tools Edit Write`, 셸 없음.
  - 채점이 Edit 결과를 보는지는 문서에 없다. 파일럿에서 확인하고, 안 보이면 trace 를 llm 채점으로 본다.

**순서와 파일.**
1. AC #3. 먼저 테스트를 쓴다. `out_has:` 단계를 더하고 시나리오 셋을 더한다.
   - 작업 브랜치가 명령을 `true`로 바꿨는데 기준 명령이 실패하면 2 이고 알림이 있다.
   - 같은 경우에 기준 명령이 통과하면 0 이고 알림이 있다.
   - 기준 브랜치 CLAUDE.md 에 검증 명령이 없으면 작업 트리의 명령이 돈다.

   다음으로 훅을 고친다.
   - 명령 뽑기를 함수로 만든다.
   - 기준 브랜치 이름은 작업 트리 CLAUDE.md 의 `기준 브랜치:`/`base branch:` 줄에서 읽는다. 없으면 `main`이다.
   - `git show <기준>:CLAUDE.md`에서 명령을 읽는다. 브랜치나 파일, 줄이 없으면 작업 트리의 명령을 쓴다.
   - 두 명령이 다르면 기준 명령을 돌린다. 실패하면 되돌려 보내는 메시지에, 통과하면 `systemMessage`로 바뀌었다고 알린다.

   README 두 개의 훅 설명도 고친다.
2. AC #1·#6. `frontend-start-check:35`, `frontend-end-check:38`, `start.md` 6단계 4 에 "같은 AC(지적)가 세 번 고쳐도 실패하면 멈추고 실패한 것과 시도한 것을 알린다"와 이유 한 구절을 넣는다. 번역본도 고친다.
3. AC #4. `mockup.md:7`은 "시안 수는 늘 묻는다. 개수에 따라 2단계(방향)를 할지가 갈린다."로 바꾸고, 1절 목록의 굵은 글씨를 푼다. `mockup.md:30`은 이유와 함께 담백하게 쓴다. 번역본도 고친다.
4. AC #2.
   - scratchpad 에 가짜 저장소와 항목 001 을 만든다. 이 워크트리의 workflow 를 `--plugin-dir`로 싣는다.
   - `claude -p`로 `start 001 --here`를 계획까지 돌린다.
   - `--resume`으로 `/compact`한다.
   - 확인은 둘이다. (a) JSONL 에서 압축 경계 뒤에 `start.md` 고유 문장이 있는지 본다. (b) Read 없이 6단계 4 를 맞게 옮기는지 본다.
   - 헤드리스로 안 되면 대화형 절차를 적고 멈춘다.
   - 사라졌으면 `SKILL.md` 1절 끝에 "대화가 압축된 뒤에는 고른 절차 파일을 다시 읽고 지금 단계부터 이어 간다"를 넣는다(번역본 포함).
5. AC #5.
   - 사례는 `plugins/workflow/evals/end-fix-real/`이다. 저장소는 nolmeong 002 의 리뷰 전 `300f562`이고, 정답은 고친 커밋 `3d1649b`·`5aaa792`다.
   - 기계적 지적 12개(1·2·3·7·9·10·14·15·20·21·24·26)를 `file:line — 문제 — 고칠 방법` 꼴로 적는다.
   - 위임판(새 5단계: Agent `model: sonnet`, 노력 높음)과 대조판(작업 세션이 고침)을 둔다.
   - 채점은 둘이다. 지적마다 고친 커밋과 같은 뜻인지 본다. 범위 밖을 바꾸지 않았는지, 2·24 는 테스트를 먼저 썼는지, 위임판은 sonnet 에이전트를 불렀는지도 본다.
   - 파일럿 1회를 `--max-cost-usd 5`로 돌린 뒤 판마다 3회 돌린다.
   - 위임판 점수가 낮지 않고 비용이 대조판 이하일 때만 위임을 기본으로 둔다. 아니면 작업 세션이 고친다고 쓴다.
   - `end.md` 5단계(원문·번역본)에 쓸 것:
     - 판단이 필요한 수정은 작업 세션이 고친다.
     - 결과가 좋으면 기계적 수정을 위임한다.
     - 고친 뒤 판정은 검증 명령과 판정 에이전트로 한다. UI 는 `frontend-evaluator`, 그 밖은 새 판정 에이전트에 항목 파일·지적 목록·diff 만 준다.
     - 같은 지적이 세 번이면 멈춘다.
   - `evals/README.md` 표를 고친다.
6. 버전을 올린다(frontend 0.9.0 → 0.10.0, workflow 0.12.0 → 0.13.0). workflow 설명(`plugin.json`·`marketplace.json`)과 README 두 개를 맞춘다.
7. `simplify` → 검증 → 판정 에이전트 → 커밋.

**성공 기준.**
- #1·#6: grep 출력과 판정 에이전트
- #2: 방법과 결과(JSONL 발췌, 답 원문)
- #3: 테스트 출력
- #4: `**` grep 과 판정 에이전트
- #5: 점수·비용 표와 판정 에이전트
- DoD: 검증 명령 출력

**가정과 정한 것.**
- "같은 기준"은 AC 하나 또는 고친 지적 하나다. 세 번째로 고친 뒤에도 실패하면 멈춘다.
- 브랜치가 기준 브랜치 이름까지 바꾸는 경우는 막지 않는다.
- 통과할 때도 알린다. 이때 Claude 를 막지는 않는다.
- eval 에는 기계적 지적만 넣는다.
- 셸이 없으니 "테스트 먼저"는 trace 순서로만 본다.
- 예상 비용은 약 $20~35 다. 압축 확인 $1~3, 파일럿 상한 $5, 본 실행 2판 × 3회에 회당 $2~4 를 잡았다.
- 파일럿이 회당 $8 를 넘으면 멈추고 묻는다. 두 판이 모두 만점이면 두 번째 사례(nolmeong 013)를 더할지 묻는다.

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

### Baseline

- `claude plugin validate . && bash scripts/check-repo-rules.sh`: 통과(2026-11-24, main 2dba1aa). 이미 실패하는 것 없음.

### AC #3 Stop 훅

- 테스트를 먼저 썼다. 고치기 전에는 `14 개 중 12 개 맞음`이었다. 틀린 둘은 "브랜치가 검증 명령을 바꿈 → … 알림" 두 시나리오로, 바뀐 `true`가 돌아 알림이 없었다. "기준 브랜치에 검증 명령 없음" 시나리오는 지금 동작을 지키는 것이라 처음부터 맞았다.
- 고친 뒤 `bash scripts/test-verify-on-stop.sh`: `14 개 중 14 개 맞음`.
- 통과 때 내는 `{"systemMessage": …}`에 따옴표·역슬래시가 든 명령(`true "q\z"`)을 넣어 JSON 으로 읽히는지 따로 확인했다(python `json.load` 성공).

### AC #2 압축 뒤 절차 파일

방법(2026-11-24, Claude Code 2.1.330, Opus 5.5, 헤드리스):

1. scratchpad 에 가짜 저장소를 만들었다. 항목 `001-feat-hello`, 검증 명령 `bash test.sh`, `stack: 없음`이다.
2. 이 브랜치의 workflow 플러그인 사본(`dependencies`·hooks·evals 를 뺐다. 의존성이 있으면 `--plugin-dir`로 불러지지 않았다)을 `--plugin-dir`로 실었다.
3. `claude -p "task 스킬을 start 001 --here 로 불러 …"`를 돌렸다. 스킬이 불렸고 `references/start.md`를 Read 한 뒤 계획을 쓰고 멈췄다($0.33, 11턴).
4. 같은 세션을 `--resume`으로 이어 `/compact`했다(Git Bash 가 `/compact`를 경로로 바꾸지 않게 `MSYS_NO_PATHCONV=1`).
5. 세션 JSONL 을 봤다. `compact_boundary`(124번 줄) 뒤에 요약(126)과 함께 파일 첨부 세 개가 다시 붙었다: `test.sh`, 항목 파일, `references/start.md`(132).
   - `start.md` 첨부는 `numLines 92 / totalLines 92`, 5194자로 원본과 글자까지 같았다. 6단계 4 "구현 세션이 아닌 판정자", 5단계 "통과시키려고 기존 테스트를 지우거나", 이번에 더한 "세 번 고쳐도"가 모두 들어 있었다.
   - 다시 붙은 스킬 내용(SKILL.md)은 `skill_listing`(목록)뿐이었다.
6. `--tools ""`로 도구를 모두 막고 "6단계 4 의 규칙을 지금 맥락에 있는 그대로 옮겨 쓰라"고 했다. "압축이 끝난 뒤 다시 붙은 `references/start.md` 읽기 결과(86–90행)"라고 출처를 대고 원문과 같게 옮겼다($1.02).

결과: 이 세션에서는 압축 뒤에도 절차 파일 내용이 사라지지 않았다. Claude Code 가 압축 뒤 Read 했던 파일을 다시 붙이기 때문이다. AC #2 대로 `task` `SKILL.md`는 고치지 않았다.

한계: 이 세션은 Read 한 파일이 셋뿐이었다. 다시 붙는 파일 수나 크기에 상한이 있다면, 절차 파일 뒤에 많은 파일을 읽은 긴 세션에서는 빠질 수 있다. 그 상한은 문서에서 확인하지 못했고 재지도 않았다. 압축 확인에 든 비용은 처음 실패한 두 번을 합쳐 약 $2.4 다(의존성 때문에 스킬을 못 부른 실행 $0.23, `/compact`가 경로로 바뀐 실행 $0.39).

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것.
