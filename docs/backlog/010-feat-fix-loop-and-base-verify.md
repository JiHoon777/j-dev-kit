---
id: '010'
title: 고치기 반복에 상한, 리뷰 지적은 만든 세션이 고치고 기계적인 것만 위임, 압축 뒤 절차 다시 읽기, 검증 명령은 기준 브랜치에서, 강조 대신 이유 (전문가 스킬 활용 2·6·7·8)
status: To Do
labels: [feat]
priority: medium
dependencies: []
created_date: 2026-11-23
updated_date: 2026-11-23
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
- [ ] #4 `mockup.md`(원문·번역본) 1절에 굵은 강조가 없고, 시안 수를 묻는 이유(개수에 따라 2단계를 할지가 갈린다)가 한 구절로 붙어 있다
- [ ] #5 `end.md` 5단계(원문·번역본)에 다음이 적혀 있다: 판단이 필요한 수정은 작업 세션이 직접 고친다. 위치와 고칠 내용이 정해진 기계적인 수정만 모아 에이전트 하나(`model: sonnet`, 노력 높음)에 지적 목록, 항목 파일, "동작을 바꾸면 실패하는 테스트 먼저" 규칙과 함께 넘긴다. 고친 뒤 판정은 검증 명령과 판정 에이전트(UI 는 `frontend-evaluator`)로 한다. 같은 지적이 세 번 고쳐도 남으면 멈추고 사용자에게 넘긴다. 작업 세션이 고친 판과 Sonnet 에이전트가 고친 판의 품질·비용 비교 방법과 결과(먼저 하나를 `--max-cost-usd 5`로 돌린 비용 포함)가 `Implementation Notes`에 있고, 결과가 나쁘면 위임 없이 작업 세션이 고치는 쪽으로 적혀 있다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 원문(`plugins/`)을 고친 곳은 번역본(`i18n/en/`)도 같이 고쳤다
- [ ] #3 고친 플러그인마다 `plugin.json` `version`을 올렸고, README 두 개와 `marketplace.json` 설명을 맞췄다

<!-- DOD:END -->

## Implementation Plan

만들 때는 비워 둔다. `/task start`가 승인된 계획을 적는다.

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것.
