---
id: '010'
title: 고치기 반복에 상한, 리뷰 지적은 만든 세션이 고치고 기계적인 것만 위임, 압축 뒤 절차 다시 읽기, 검증 명령은 기준 브랜치에서, 강조 대신 이유 (전문가 스킬 활용 2·6·7·8)
status: Done
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

6. **하위 세션의 모델과 노력(사용자가 start 중에 더함, 2026-11-24):** 사용자의 말은 "지금 start, create 로 하위 세션 띄울때 Fable 은 한 버전 아래의 최신 Opus 높음 으로 띄어지도록 하고, 그 아래는 똑같이 띄어지도록" → "010에 더해"다. 대상은 `task` `SKILL.md` 2절 3 과 번역본이다. 이 세션이 Fable 이면 `start_session`에 `model`을 한 단계 낮은 최신 모델로, `effort`를 `high`로 준다. Opus 이하면 둘 다 주지 않아 이어받는다. `end.md` 3단계 리뷰 모델 규칙과 같은 말투로 쓴다. `start_session`은 노력을 이 세션과 같거나 낮게만 받는다. 그래서 Fable 세션의 노력이 `high`보다 낮으면 이어받게 두고 그렇다고 알린다.

7. **Stop 훅 시간 제한(사용자가 start 중에 더함, 2026-11-24):** 사용자의 말은 "그렇게 하기"다. 부모 세션이 "011 리뷰를 시작하고, 훅 시간 제한은 010 에 더할까요?"라고 물은 데 대한 답이다. command 훅의 기본 timeout 은 600초이고, 닿으면 훅이 취소된다. 011 이 머지되면 검증 명령이 바뀐 스크립트의 짝 테스트까지 돌린다. 011 이 잰 값으로 test-base-tests 하나가 284초이고, 여러 스크립트를 함께 고치면 600초를 넘을 수 있다. 그래서 `plugins/workflow/hooks/hooks.json` Stop 훅에 `timeout`을 넣는다.

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

- [x] #1 `frontend-start-check`과 `frontend-end-check`(원문·번역본)에서 "실패"를 고치고 다시 넘기는 자리마다, 같은 기준이 세 번 고쳐도 실패하면 멈추고 실패한 기준과 시도한 것을 사용자에게 알린다고 적혀 있다
- [x] #2 `/compact` 뒤 `task` 세션이 절차 파일 내용을 아직 따르는지 확인한 방법과 결과가 `Implementation Notes`에 있다. 내용이 사라졌으면 `task` `SKILL.md`(원문·번역본)에 "대화가 압축된 뒤에는 고른 절차 파일을 다시 읽고 지금 단계부터 이어 간다"는 뜻의 한 줄이 있고, 사라지지 않았으면 `SKILL.md`는 그대로다
- [x] #3 작업 브랜치에서 CLAUDE.md 의 검증 명령을 바꾸고 DoD 를 체크하면, Stop 훅이 기준 브랜치 CLAUDE.md 의 명령을 돌리고 검증 명령이 바뀌었다고 알린다. `scripts/test-verify-on-stop.sh`에 이 경우와 "기준 브랜치에 검증 명령이 없으면 작업 트리의 것"인 경우의 테스트가 있고 통과한다
- [x] #4 `mockup.md`(원문·번역본) 1절에 굵은 강조가 없고, 시안 수를 묻는 이유(개수에 따라 2단계를 할지가 갈린다)가 한 구절로 붙어 있다. 3절의 "**멈춘다.**"도 굵은 강조 없이 이유(사용자가 캔버스에서 직접 고르게 하려고)와 함께 적혀 있다(start 계획에서 사용자가 더함)
- [x] #5 `end.md` 5단계(원문·번역본)에 다음이 적혀 있다: 판단이 필요한 수정은 작업 세션이 직접 고친다. 위치와 고칠 내용이 정해진 기계적인 수정은 모아 에이전트 하나(`model: sonnet`, 노력 높음)에 지적 목록, 항목 파일, "동작을 바꾸면 실패하는 테스트 먼저" 규칙과 함께 맡길 수 있고, 맡길지는 작업 세션이 정한다(예: 수가 적거나 같은 파일을 함께 고쳐야 하면 직접). 고친 뒤 판정은 검증 명령과 판정 에이전트(UI 는 `frontend-evaluator`)로 한다. 같은 지적이 세 번 고쳐도 남으면 멈추고 사용자에게 넘긴다. 작업 세션이 고친 판과 Sonnet 이 고친 판의 비교 방법과 결과(먼저 하나를 `--max-cost-usd 5`로 돌린 것 포함)가 `Implementation Notes`에 있다(start 중 사용자 결정으로 "결과가 나쁘면 위임 없이"를 "맡길지는 작업 세션 재량"으로 바꿈)
- [x] #6 `start.md` 6단계 4(원문·번역본)의 "실패는 고치고 다시 판정받는다"에, 같은 AC 가 세 번 고쳐도 실패하면 멈추고 실패한 AC 와 시도한 것을 사용자에게 알린다고 적혀 있다(start 계획에서 사용자가 더함)
- [x] #7 `task` `SKILL.md`(원문·번역본) 2절 3 에 하위 세션의 모델·노력 규칙이 있다: 이 세션이 Fable 이면 한 단계 낮은 최신 모델과 `effort: high`를 준다. 노력이 `high`보다 낮은 세션이면 이어받게 두고 알린다. Opus 이하면 둘 다 이어받는다(start 중에 사용자가 더함)
- [x] #8 `plugins/workflow/hooks/hooks.json`의 Stop 훅에 `timeout`(초)이 기본값 600보다 크게(1800) 있고, 값과 이유가 `Implementation Notes`에 있다(start 중에 사용자가 더함)

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [x] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [x] #2 원문(`plugins/`)을 고친 곳은 번역본(`i18n/en/`)도 같이 고쳤다
- [x] #3 고친 플러그인마다 `plugin.json` `version`을 올렸고, README 두 개와 `marketplace.json` 설명을 맞췄다

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

### AC #5 리뷰 수정 위임 eval

사례: `plugins/workflow/evals/end-fix-real/`.
- 저장소는 nolmeong 002 리뷰 직전 상태다. main 이 `47d77ea`, 작업 브랜치는 main 을 합친 `2b5627e`다.
  - `300f562`에는 `tap-target` 유틸리티가 없어서, 그것이 들어온 머지 커밋을 썼다.
- 27개 지적 가운데 위치와 고칠 내용이 정해진 12개를 `file:line — 문제 — 고칠 방법`으로 넘긴다.
  - 12개는 1·2·3·7·9·10·14·15·20·21·24·26 번이다.
  - 근거는 실제로 고친 커밋 `3d1649b`, `5aaa792`다.
- 채점은 처음 llm 15개와 regex 1개였다. 정리하며 결정적으로 볼 수 있는 것을 regex 로 바꿔, 지금 커밋된 것은 llm 10개, regex 6개, tool_used 1개다. 아래 표의 점수는 바꾸기 전 채점으로 낸 것이고, 바꾼 뒤 다시 돌리지는 않았다.
  - llm 15개: 지적마다 고친 파일 내용을 sonnet 이 본다(`focus: {source: file, path}`). 테스트 먼저 쓰기 2개도 여기에 든다.
  - regex 1개(`keeps-scope`): 지적 밖 변경을 하지 않았는지 본다.
  - 위임판에만 `used-sonnet`(Agent `model: sonnet` 호출)을 둔다.
- 사본은 scratchpad 에 둔다(커밋하지 않는다).
  - 위임판: 새 5단계 그대로
  - 대조판: 위임 줄을 "기계적인 수정도 이 세션이 직접 고친다"로 바꾼 판
  - 둘 다 `dependencies`·hooks 를 뺐다.

채점 대상 문법은 문서에 없었다. 그래서 설치된 Claude Code 2.1.330 의 스키마에서 확인했다.
- llm 은 `focus`, regex 는 `target`을 쓰고, 값으로 `{source: file, path}`를 받는다.
- 파일럿에서 Edit 로 고친 기존 파일 내용이 채점에 그대로 들어가는 것을 확인했다.

파일럿(위임판 1회, `--max-cost-usd 5`, Opus 시험·sonnet 채점):
- 비용은 $0.96(실행 $0.61, 채점 $0.35), 28턴, 173초다.
- 실행 기록의 `modelUsage`에는 `claude-opus-5-5`만 있었다. 이번에는 서브에이전트가 없어서, 서브에이전트 비용이 합쳐지는지는 아직 모른다.
- 점수는 0.88(17개 중 15개)이다. 지적 12개와 테스트 2개는 모두 PASS 였다.
- **Opus 는 위임하지 않았다**(`used-sonnet` FAIL). 마지막 메시지에 이유를 적었다: "수정이 몇 개 안 되고, 제가 고치던 `line.ts`, `+page.svelte`와 같은 파일을 건드려 동시에 고치면 서로 부딪힐 수 있어서".
- `keeps-scope`(처음엔 llm 채점)는 3/3 FAIL 이었다. 그러나 diff 를 보니 바뀐 것은 지적한 네 곳뿐이었다. 채점이 원래 있던 `aria-live`·스니펫을 새로 생긴 것으로 본 오판이다.
  - 리뷰 전 파일에 없고 실제 수정(5aaa792)에는 13번 나오는 표식(`.focus(`, `tick`, `onResume`, `isVisible`, `listHead`, `rowClass`)을 보는 regex `not_contains`로 바꿨다.
- 위임판이 위임하지 않아 두 판 비교만으로는 Sonnet 이 고친 품질을 잴 수 없다. 그래서 판을 하나 더했다: C. 대조판 사본을 `--model sonnet`으로 돌려 Sonnet 이 직접 고친 품질과 비용을 본다. 에이전트로 부를 때의 근사다.

본 실행(사례마다 3회, `-j 3`, sonnet 채점, 2026-11-24, 채점 포함 합계 $11.66):

| 판 | 시험 모델 | 점수(eval) | 점수(채점 잡음 보정) | 위임 | 회당 실행 비용(채점 제외) |
| --- | --- | --- | --- | --- | --- |
| A 대조판: 작업 세션이 직접 | Opus | 1.0, 0.94, 1.0 | 1.0, 1.0, 1.0 | 없음 | $0.63, $0.63, $0.56 |
| B 위임판: 새 5단계 그대로 | Opus | 1.0, 0.88, 0.94 | 1.0, 1.0, 1.0(`used-sonnet` 제외) | 3회 중 1회 | $0.69, $0.60, $0.58 |
| C 대조판을 Sonnet 으로 | Sonnet | 1.0, 1.0, 1.0 | 1.0, 1.0, 1.0 | 없음 | $0.31, $0.26, $0.26 |

- eval 점수가 깎인 것은 `fix-exports` 두 번(A 1회, B 1회, 판정 FFF)과 B 의 `used-sonnet` 두 번이었다.
  - `fix-exports` 실패의 근거 파일을 보니 세 타입의 `export`를 지웠고 타입은 남아 있었다. PASS 한 실행과 같은 내용이라 채점 잡음이다.
  - 아홉 실행 모두의 근거 파일에 regex(`export\s+type\s+(Example|Received|Sent)\b`가 없고 세 타입 정의는 있음)를 대니 모두 PASS 였다. 이 채점은 regex 로 바꿨다.
- 비용은 eval 의 `costUsd`에서 `judgeCostUsd`를 뺀 것이다(파일럿 실행 기록의 `total_cost_usd`와 맞았다). 위임한 B 1회($0.69)에 서브에이전트 비용이 들었는지는, 이번 실행에서 기록을 남기지 않아(`--keep-temp` 없음) 확인하지 못했다.
- 결론:
  - 기계적 지적 12개는 Opus·Sonnet·위임 모두 9회 전부 고쳤다. 품질로는 판별력이 없다.
  - Sonnet 이 직접 고친 비용은 Opus 의 약 45%다.
  - 위임 지시는 Opus 가 3회 중 1회만 따랐다. 따르지 않은 두 번도 파일럿과 같은 이유였다(수가 적고 같은 파일이라 부딪힌다).
- 부모 세션 규칙("두 판이 모두 만점이면 두 번째 사례를 더할지 묻는다")대로 여기서 멈추고 묻는다. `end.md` 5단계는 지금 위임판 문구 그대로다. 결정 전이라 AC #5 는 체크하지 않는다.

결정(2026-11-24, 부모 세션이 전함):
- 사용자의 말: "그대로 둬도되자나 어짭히 지가 알아서 판단해서 맡겨도 되면 맡기고 지가 하겠다하면 지가 하는거자나"
- 두 번째 사례는 더하지 않고, 위임판도 다시 재지 않는다.
- `end.md` 5단계의 위임 줄은 "맡길 수 있다, 맡길지는 이 세션이 정한다(예: 수가 적거나 판단이 필요한 수정과 같은 파일을 함께 고쳐야 하면 직접)"로 썼다(원문·번역본).
  - 예로 든 경우는 eval 에서 Opus 가 위임하지 않은 두 번에 댄 이유다.
  - 판단이 필요한 수정은 직접, 고친 뒤 판정은 바깥에서, 세 번이면 멈춤은 계획대로 두었다.
- AC #5 의 "결과가 나쁘면 위임 없이"는 이 결정에 맞게 "맡길지는 작업 세션 재량"으로 고쳤다.
- 사용자는 비용을 판단 축으로 삼지 말라고 했다("왜 계속 비용을 들먹여 얼마 나오지도 않는데"). 위 비용 열은 AC 가 요구한 기록으로만 둔다.

### AC #7 하위 세션의 모델과 노력 (start 중에 더함)

- 범위에 더함: 2026-11-24, 사용자 "010에 더해"(부모 세션이 전함).
- `start_session` 도구 설명을 확인했다. `model`은 "Same family or cheaper than yours; anything higher is ignored. Omit to inherit yours."이고, `effort`는 "reasoning effort at or below yours. Omit to inherit."이다.
- 그 설명대로 `SKILL.md` 2절 3 표 아래에 규칙을 넣었다(원문·번역본). `model`에는 id 를 받으니 `claude-opus-5-5`를 함께 적었다.
- 이 세션은 Opus 5.5 로 돌고 있어 Fable 세션에서 실제로 띄워 보지는 못했다.

### AC #8 Stop 훅 시간 제한 (start 중에 더함)

- 범위에 더함: 2026-11-24, 사용자 "그렇게 하기"(부모 세션이 전함).
- 문서 확인(https://code.claude.com/docs/en/hooks, claude-code-guide 에이전트가 읽음):
  - 공통 필드 표에 "`timeout` | no | Seconds before canceling."이 있고, 기본값은 "600 for `command`"다.
  - 닿으면 "cancels a `command` … hook that reaches its `timeout`, discarding the hook's output"이다.
  - 일반 command 훅의 상한은 문서에 없다.
  - Stop 훅이 시간 초과로 취소될 때 Claude 를 막는지는 문서에 없다. exit 2 가 아니니 막지 않고 멈출 것으로 본다(추론, 재지 않음).
- 값은 1800초(30분)로 정했다.
  - 011 이 잰 test-base-tests 284초에, 스크립트 테스트를 모두 돌리면 약 700초 이상이 든다. 그 두 배를 넘게 잡았다.
  - 너무 길면 실패한 검증이 멈추지 않는 동안 세션이 묶이지만, 훅은 DoD 를 체크한 `w/` 브랜치에서 내용이 바뀌었을 때만 돈다.
- `hooks.json`의 `description`도 "the base branch's verify command … (waiting up to 30 minutes)"로 맞췄다. README 두 개의 검증 훅 설명에 한 구절을 더했다.
- 훅 테스트(`scripts/test-verify-on-stop.sh`)는 스크립트만 돌리고 hooks.json 은 읽지 않는다. 그래서 확인은 JSON 을 읽어 값을 꺼낸 출력(`timeout = 1800`)과 판정 에이전트로 한다.

### 정리(simplify)

에이전트 넷(재사용·단순화·효율·고친 깊이)이 리뷰했다.

고친 것:
- 훅
  - 검증 명령을 고르는 계산을 "이미 통과/되돌림" 확인 뒤로 옮겼다. 같은 내용으로 다시 멈출 때 Windows 에서 약 1.1초가 줄어든다(효율 에이전트가 잼).
  - `setting()`을 파이프 하나로 줄였다.
  - CLAUDE.md 를 한 번만 읽는다.
  - 바뀐 명령 조건을 `cmd`로 줄였다.
  - JSON 이스케이프를 bash 치환으로 바꿨다.
- 테스트 도우미 `change_verify_cmd`를 sed 치환으로 바꿨다.
- eval 채점 넷(`fix-minute-line`, `fix-minute-time`, `fix-tap-target`, `fix-time-comment`)을 regex 로 바꿨다. 각 표식이 리뷰 전 파일과 실제 수정 커밋에서 기대대로 나오는 것을 확인했다.

건너뛴 것과 이유:
- 상한 문구를 한곳에 모으기, `end.md` 81·82 줄 합치기, `mockup.md` 이유 문장 지우기: AC #1·#4·#5·#6 이 그 자리마다 그 문구를 요구한다.
- sed 의 `I` 플래그: macOS sed 에 없다.
- fixture 를 `git apply`로 바꾸기: 다른 사례 11개의 관례(`git archive`)와 달라진다.

`/task end` 리뷰 후보(동작이나 범위가 바뀌어 정리에서 하지 않음):
- 훅이 `origin/<기준>`을 찾지 않는다. `diff-check.sh`·`base-tests.sh`·`check-repo-rules.sh`는 찾는다.
- 기준 브랜치 이름을 작업 트리 CLAUDE.md 에서 읽는다(계획에서 막지 않기로 했다).
- 세션이 직접 돌리는 검증(`start.md` 6단계 2, `end.md` 6단계 1)은 여전히 작업 트리의 명령을 쓴다.
- 훅 메시지가 말하는 "/task end 리뷰에서 바뀐 명령을 본다"에 해당하는 단계가 `end.md`에 따로 없다.
- 판정 에이전트 정의가 세 곳(`start.md` 6단계 4, `end.md` 4·5단계)에 따로 있다.
- "Fable 이면 한 단계 낮은 최신 모델" 규칙이 두 곳(`SKILL.md` 2절, `end.md` 3단계)에 다른 표기(`claude-opus-5-5`, `opus`)로 있다.

### AC 판정

- 구현 세션이 아닌 판정 에이전트(general-purpose)에 항목 파일 경로와 `git diff main...HEAD`만 넘겼다.
- AC #1~#7, DoD #1~#3 은 모두 통과였다. 판정은 HEAD `468c8d8`에서 했다.
  - 근거는 `file:line`과 명령 출력이다: `test-verify-on-stop.sh` 14/14, 검증 명령 종료 0, `mockup.md`의 `**` grep 0건, `SKILL.md:42`, `end.md:81-84`, `start.md:90`.
- AC #8 은 그 판정 에이전트가 같은 HEAD 에서 `hooks.json:10`의 `"timeout": 1800`과 이 Notes 를 확인했다. JSON 을 읽어 낸 `timeout = 1800` 출력도 있다.
- 판정 에이전트가 짚은 기록 불일치(채점 개수)는 위 AC #5 절에서 고쳤다.
- 판정 에이전트가 확인하지 않은 것도 그대로 적는다.
  - Fable 세션에서 하위 세션을 실제로 띄워 본 일
  - 긴 세션에서의 압축 뒤 확인
  - 바꾼 채점으로 eval 을 다시 돌리는 일

### /task end 리뷰 (2026-11-24)

- 스택 점검: frontend·server 모두 해당 없음(`stack: 없음`).
- 테스트 확인: `base-tests.sh main 'bash {}'` → `기준에서 실패: scripts/test-verify-on-stop.sh`. 고친 것을 증명한다.
- 리뷰: `code-review`(정리 단계에서 남긴 후보 여섯 개를 범위에 넣음)와 `security-review`(보안 취약점 없음). 판정 에이전트가 가렸다.
  - 결과: 🔴 0, 🟡 6, ⚪ 4, 판정에서 뺀 것 2, 기존 문제 1.
- 사용자 결정("그렇게 고치기", 부모 세션이 전함):
  - 🟡 6건과 기존 문제 1건(CLAUDE.md 삭제)은 지금 고친다.
  - 🔁 "막기"는 고르지 않는다.
  - ⚪ 는 그대로 둔다.
- 고친 것:
  - 훅. 시나리오 다섯 개를 먼저 썼다. 리뷰 전 훅(`a85f446`)에서는 14/19, 고친 뒤 19/19 였다.
    - 기준 브랜치를 로컬에 없으면 `origin`에서 찾는다. 못 찾으면 작업 트리 명령으로 판정하되 그렇다고 알린다.
    - "이 브랜치가 바꿨다"는 merge-base 판의 명령과 비교해 정한다.
    - 통과·되돌림 표시의 키를 `내용(tree) + 명령`으로 바꾸고 주석을 고쳤다.
    - 작업 트리에 CLAUDE.md 가 없어도 기준 명령으로 판정한다.
  - `end.md`(원문·번역본):
    - 4단계에 "CLAUDE.md 의 검증 명령 줄이 바뀌었으면 따로 보인다"를 넣었다.
    - 5단계 고친 뒤 판정에 `git diff HEAD`와 `git status --short`를 넘기고, "파일을 고치지 않는다", "애매하면 고쳐짐으로 두지 않는다"를 넣었다.
  - README 두 개의 검증 훅 설명에 `origin`·못 찾을 때를 더했다.
- 고친 것 판정(새 판정 에이전트, `git diff HEAD`와 `git status --short`만 넘김):
  - 1차: 7건 중 6건이 고쳐졌다. 판정에서 떨어진 것은 7번(CLAUDE.md 삭제)이다.
    - 기준이 `main`이면 고쳐졌다.
    - 기준이 `develop`처럼 다른 이름이면 그 이름도 지운 CLAUDE.md 에 있어 기준을 못 찾았다. 그러면 알림 없이 건너뛰었다(scratchpad 재현: exit 0, 출력 없음).
  - 2차 수정: 기준 브랜치 이름을 작업 트리 CLAUDE.md 에서 읽고, 지웠으면 지우기 전 판에서 읽는다(커밋 안 했으면 `HEAD`, 커밋했으면 지운 커밋의 부모). 그래도 없으면 `main`이다.
    - 시나리오 둘을 먼저 썼다(19/21 → 21/21).
    - 판정이 짚은 사소한 것 둘(번역본 문장의 빠진 동사, 훅 머리 주석)도 고쳤다.
  - 2차 판정: 세 건 모두 고쳐짐. 판정 에이전트가 훅의 해당 줄을 일부러 지워 보니 시나리오가 틀렸다. 두 경로 모두 테스트가 지킨다.
- 원칙: "기준 판을 구하지 못하면 조용히 넘어가지 말고 알린다"를 `docs/review-principles.md`에 더했다(009·010 되풀이). 011 이 목록 끝에 더한 줄과 머지 때 겹치지 않게 목록 맨 앞에 넣었다.

## Final Summary

**바뀐 것**
- 고치기 반복에 상한: frontend 점검 두 곳, `start.md` 6단계 4, `end.md` 5단계에서 같은 기준(AC, 지적)이 세 번 고쳐도 실패하면 멈추고 알린다.
- 검증 Stop 훅은 기준 브랜치 CLAUDE.md 의 검증 명령으로 판정한다.
  - 기준 브랜치는 로컬, 없으면 `origin`에서 찾는다. 못 찾으면 작업 트리의 명령으로 판정하고 알린다.
  - 브랜치가 명령을 바꿨으면(merge-base 판과 비교) 알린다.
  - CLAUDE.md 를 지워도 기준 명령으로 판정한다.
  - 표시의 키는 내용과 명령이다.
  - Stop 훅 `timeout`은 1800초다.
- `end.md`:
  - 4단계에서 바뀐 검증 명령을 따로 보인다.
  - 5단계에서 판단이 필요한 수정은 작업 세션이 하고, 기계적 수정은 작업 세션이 정하면 Sonnet 에이전트(`effort: high`)에 맡긴다.
  - 고친 뒤 판정은 검증 명령과 판정 에이전트(`git diff HEAD`, `git status --short`)로 한다.
- `task` `SKILL.md`: 하위 세션은 Fable 이면 한 단계 낮은 최신 모델과 `high`, 그 아래는 이어받는다.
- `mockup.md`: 굵은 강조 둘을 이유로 바꿨다.
- 압축 뒤 절차 파일 확인: 다시 붙는 것을 확인해 `SKILL.md`는 그대로 뒀다.
- eval `end-fix-real`(리뷰 수정 위임 비교)을 더했다.
- 버전: workflow 0.13.0, frontend 0.10.0.

**리뷰에서 고친 것**
- 훅
  - `origin/<기준>` 찾기와 못 찾을 때 알림
  - merge-base 기준의 "바꿨다" 판정
  - 표시 키에 명령 넣기
  - CLAUDE.md 를 지워도 판정(기준이 main 이 아닐 때까지, 두 번째에 고침)
- `end.md`
  - 고친 뒤 판정에 추적 안 된 파일까지 넘기기
  - 판정 지시문의 금지 문장
  - 4단계의 바뀐 검증 명령 보이기
- 같은 종류의 되풀이(🔁, 막기는 고르지 않음):
  - 기준 판을 못 구한 채 조용히 판정(009)
  - 표시의 키가 모자람(004)
  - 에이전트 지시문에서 금지 문장이 빠짐(008)

**미룬 것**
- 없다. 새 항목도 없다.

**그대로 둔 지적과 이유**
- ⚪ `systemMessage`에 탭 같은 제어 문자가 들어가면 JSON 이 깨질 수 있다: 명령 줄에 탭을 쓸 일이 드물고, 실패할 때의 알림(stderr)은 그대로 나간다.
- ⚪ `-`로 시작하는 기준 브랜치 이름: CLAUDE.md 를 쓰는 사람은 이미 `eval`로 무엇이든 돌릴 수 있어 새로 얻는 것이 없다.
- ⚪ 세션이 직접 돌리는 검증은 작업 트리의 명령을 쓴다: 같은 `w/` 세션이 멈출 때마다 Stop 훅이 기준 명령으로 다시 판정하고, `end.md` 4단계가 바뀐 명령을 사람에게 보인다.
- ⚪ `fix-tap-target` 채점이 파일 어디에든 있으면 통과: 리뷰 전 파일의 `<button>`이 하나뿐이다.
- 판정에서 뺀 것
  - 기준 브랜치 이름을 작업 트리에서 읽음: 계획에서 막지 않기로 정했고, 검증 명령이 작업 트리의 스크립트를 돌리니 막아도 길이 남는다.
  - 모델 표기 차이(`claude-opus-5-5`, `opus`): `start_session`은 id, Agent 도구는 별칭을 받는다.

**사용자가 바로잡은 것**
- start 질문 둘을 추천안대로 정했다. `start.md` 6단계 4 에도 상한(AC #6)을 넣고, `mockup.md` 3절 강조도 바꿨다(AC #4).
- start 중에 범위를 더했다: 하위 세션의 모델·노력(AC #7), Stop 훅 시간 제한(AC #8).
- AC #5: eval 결과로 위임을 강제하지 않고 작업 세션 재량으로 둔다("지가 알아서 판단해서 맡겨도 되면 맡기고").
- 비용을 판단·보고의 축으로 삼지 않는다("왜 계속 비용을 들먹여").
- 사용자에게 보이는 글과 부모 세션에 보내는 보고는 한국어로 쓴다(영어로 쓴 짧은 보고를 바로잡음).
- 리뷰: 🟡 와 기존 문제를 지금 고치고, 🔁 막기는 고르지 않는다.
