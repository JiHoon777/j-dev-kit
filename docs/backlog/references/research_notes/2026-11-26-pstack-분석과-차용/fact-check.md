# pstack 보고서 사실 검증 결과

대상 보고서: `docs/backlog/references/2026-11-26-pstack-분석과-차용.md` (검증 당시 위치는 `.claude/.local/reports/`, 7절을 더하기 전 판). 파일은 만들거나 고치지 않았다.

## A. 틀리거나 부분적으로만 맞는 주장 (중요한 순서)

| # | 보고서 주장 (줄) | 판정 | 근거 |
|---|---|---|---|
| 1 | 4절 "이 중 어느 것이 계획 승인 화면에서 나왔는지는 기록으로 가리지 못했다" (130) | **틀림** | `docs/done/008-…md:114` "### 계획 승인 때 바뀐 것"에 AC #9 리뷰 모델("Opus 면 Opus 모델 그대로, Fable 일 때만…")이 있다. 보고서가 예로 든 "리뷰 모델"이 바로 계획 승인 때 나왔다. `012-…md:644`에도 "계획은 추천안에 Supabase 확인 조건을 붙여 승인했다"가 있다 |
| 2 | 4절 "바로잡은 것은 모두 갈리는 선택이었다" (130) | **부분적으로 맞음** | 갈리는 선택이 아닌 것도 있다. 008:342 "eval 은 Windows 의 eval 환경에서도 돌게 한다", 011:154 "Stop 훅 시간 제한은 짐작하지 말고 공식 문서로 확인하라", 013:237 "eval 러너 로그인 — 사용자가 `claude auth login`을 했다". 또 009:276, 010:397, 012:640 에도 같은 절이 있는데 008·011·013 만 골랐다. 010 의 것(위임 재량, "비용을 들먹이지 말 것", 한국어 보고)도 갈리는 선택이 아니다 |
| 3 | 4절 계획 승인을 "012 에서 사용자가 직접 정한 것이다" (122) | **부분적으로 맞음** | 012:72-79(C절)이 정한 것은 "하위 세션도 `EnterPlanMode`/`ExitPlanMode`로 승인받는다"는 방식이다. 항목마다 계획 승인을 받는 것은 그 전부터 있었다. 001:23·003:25 "바꾸려면 계획 승인 때 말한다", 004:14 "묻는 곳(계획 승인, 머지 승인…)", 008:114. 인용한 줄 범위 72-77 과 날짜 2026-11-24 는 맞다 |
| 4 | "막기는 011·012·013 세 번 모두 고르지 않으셨다" (108, 181) | **맞지만 빠진 것이 있음** | 011:110, 012:586·625, 013:198 이 확인된다. 하지만 010:328·403 "🔁 막기는 고르지 않는다"도 있다. 막기가 009 에서 들어온 뒤 열린 end 는 010~013 네 번이고, 네 번 모두 고르지 않았다 |
| 5 | 읽은 범위의 "스킬 24개: architect, …, create-verification-skill" (14) | **틀림** | 나열한 이름은 19개다. 또 recall 이 직접 읽은 목록(14)과 "요약만 본 것" 목록(17, "recall 외 이해 스킬") 양쪽에 나와 서로 어긋난다 |
| 6 | "UI 항목 하나 … 약 8~11번" (117) | **부분적으로 맞음** | 아래 D 참고. 11 은 DESIGN.md 질문을 계획 질문과 따로 셌다. 그런데 start.md:45 는 스택 점검의 "물을 것"을 계획 질문과 "한꺼번에" 묻는다. 보고서 표 7행도 같은 말을 한다. 하한 8 은 높고, DESIGN.md 를 새로 만드는 경우의 질문은 빠졌다 |
| 7 | "도구 스킬 약 30개" (36) | 부분적으로 맞음 | 사본의 skills 는 원칙 24개를 빼면 35개, poteto-mode 를 빼면 34개다. 여기에 cursor-team-kit 3개가 바깥에 있다 |
| 8 | "원칙 24개 — 한 줄 규칙 하나씩" (35) | 부분적으로 맞음 | 24개는 맞다. 한 줄인 것은 poteto-mode 색인(SKILL.md:37-72)이다. 원칙 파일 자체는 여러 줄이다. 예: never-block 은 문단 하나와 글머리 5개 |
| 9 | "모든 코드 플레이북은 Opening a PR 로 끝난다" (34) | 대체로 맞음 | bug-fix:13, feature:17, perf-issue:21, hillclimb:19, refactoring:14, visual-parity:9, authoring-a-skill:8 이 그렇다. autonomous-run 에는 그 단계가 없다 |

## B. "전수"라고 한 목록에서 빠진 묻는 지점

### pstack (2절 표, `docs/harness` 제외)

| 위치 | 내용 |
|---|---|
| `poteto-mode/references/bugbot-triage.md:11` | 새롭거나 심각하거나 보안·데이터 관련이거나 애매한 봇 지적은 "Ask the user instead of guessing" |
| `playbooks/babysit.md:9-10` | billing·data·auth·security 는 escalate한다. "Owner approval is a wait. Babysitting never authorizes merging" |
| `playbooks/autopilot-stack.md:5` | 넘긴 뒤에는 "nobody pushes without the operator's go" |
| `playbooks/autopilot-full.md:7` | 운영자가 자기 것이라고 한 항목은 merge-ready 에서 멈춘다. 표에는 같은 줄의 "계획을 말하라는 요청은 가가 아니다"만 들어갔다 |
| `create-verification-skill:13`, `create-formal-verification-skill:13` | 코드로 관찰할 수 없는 것만 사용자에게 묻는다 |
| `maintain-verification-skill:25` | 후보가 여럿이면 어느 것인지 묻는다 |
| `poteto-help/SKILL.md:31` | 모델 규칙이 없으면 역할별 모델을 고를지 대화당 한 번 묻는다 |
| `make-bot-ui:20,98` | 확인 카드가 뜨면 사용자 확인을 기다린다. 기기 승인은 사용자가 브라우저에서 한다 |
| `correct:26` | 예외에는 사람의 승인이 필요하다 |
| `automations/benny/skills/setup-benny:21,29,95,168,185` | 어느 저장소인지, 소유가 애매하면 멈추고 묻기, automate 초안 승인 |
| `docs/guide/04-design.md:80`, `02-poteto-mode.md:48` | 사용자가 거는 관문 "let me review before proceeding". 가이드 07 의 미리 허락과 반대 방향인데 표에 없다 |

### j-dev-kit (3절 표 19행)

| 위치 | 내용 |
|---|---|
| `task/SKILL.md:24` | 첫 단어가 create/start/end 가 아니면 표를 보여 주고 묻는다 |
| `task/SKILL.md:52` | 검증 명령이 없으면 묻는다 |
| `start.md:77` | 필요해 보이는 다른 일은 알리고, **동의하면** 새 항목을 만든다 (구현 중에 묻는 곳) |
| `start.md:89` | 브라우저 도구가 없으면 멈춰서 알린다 |
| `end.md:87` | "나중"·"막기"로 새 항목을 만들 때 create 3단계 승인을 "항목 내용만 보여 주고 받는다". 고른 항목마다 승인이 하나씩 더 생긴다 |
| `end.md:71` | ⚪ "보려면 말씀해 주세요" |
| `end.md:92,95`, `end.md:115` | 기준선에 없던 실패, 닫기 조건이 빠짐, 기준 폴더가 깨끗하지 않음이면 멈추고 알린다 |
| `frontend-start-check/SKILL.md:29` | 색과 글꼴을 "새로 더하려면 먼저 묻는다" (구현 중) |
| `frontend-start-check/SKILL.md:42` | DESIGN.md 를 안 쓰기로 하면 CLAUDE.md 에 `- DESIGN.md: 안 씀`을 적자고 제안한다 |
| `frontend-start-check/references/svelte.md:16` | svelte 4 이하이면 어떻게 할지 묻는다 (7행에 없음) |
| `ui-design/references/mockup.md:7` | 브리프 질문(코드로 알 수 없는 것, 최대 3개). 16행에는 시안 수만 있다 |
| `mockup.md:38` | 사용자가 "됐다"고 하면 기록한다 (다듬기 뒤 멈춤) |
| `ui-design/references/system.md:13` | 톤·원칙·Do's and Don'ts 는 묻는다. 17행 "값만 묻는다"에 이것이 빠졌다 |
| `ui-design/SKILL.md:21` | 모드가 불분명하면 묻는다 |
| `server-end-check/SKILL.md:20` | 운영 DB 로 보이면 돌리지 않고 알린다 |
| `frontend/agents/design-reviewer.md:9` | 브라우저가 없으면 멈추고 보고한다 |

### superpowers (보고서 91줄은 "불러 쓰는 스킬이 묻는 것도 넣었다"고 했으나 2행 brainstorming, 15행 finishing 만 있다)

| 스킬 (task 가 부르는 곳) | 빠진 묻는 지점 |
|---|---|
| brainstorming (create 1) | 접근과 설계를 보여 주고 승인받는다(:74-76, :270). create.md:64 가 설계 문서를 막아도 접근 승인 단계는 남을 수 있다. 질문은 "one at a time"(:106)이라, create 의 "한꺼번에 최대 3개"와 어긋난다 |
| test-driven-development (start 5) | 예외는 "ask your human partner"(:24, :312, :330) |
| receiving-code-review (end 5) | 불분명한 지적은 멈추고 묻는다(:44-45). 이전 결정과 부딪히면 먼저 논의한다(:82-83). 확인할 수 없으면 방향을 묻는다(:174) |
| finishing-a-development-branch (end 7) | 기준 브랜치가 맞는지 확인한다(:50-51, :224). 버리기는 'discard'를 직접 쳐야 한다(:143). `--force` 제거 전에 묻는다(:222) |
| verification-before-completion (start 6-2) | 묻는 지점 없음 |

## C. 확인된 주장 (맞음)

| 주장 | 근거 |
|---|---|
| poteto-mode 는 `disable-model-invocation: true`이고 필수 규칙·원칙 색인·Autonomy·모델 기본값·답 쓰기·플레이북 목록을 담는다 | SKILL.md:4, 13-110 |
| worker.md 의 내용(지시문 기준이 전부, 묻는 도구 금지, 되돌릴 수 있으면 정하고 이유, 멈춤 4가지, PR 형식) | worker.md:4-10 |
| 플레이북 22개, 원칙 24개, 가이드 01~10 | 파일 수와 SKILL.md:110 |
| 답에 원칙과 그것이 바꾼 선택을 적는다. 적용할 때 원문을 읽는다 | SKILL.md:15, 33 |
| 첫 답에서 목표와 가장 작은 변경을 되짚는다. 맞는 플레이북이 없으면 figure-it-out | SKILL.md:19, 108 |
| 구현은 위임하고 메인은 설계·리뷰·검증 | feature.md:3, 12 |
| 머지에는 코드를 쓰지 않은 검증자의 판정이 필요하다 | shipping.md:5 |
| "plan through code", 계획 스킬 없음, 글로 된 계획은 여러 PR 에 걸친 일에만 | guide 04:5, 97, 123 |
| 가이드 02 "What goes in a prompt" | 02:40 |
| 2절 표 10행의 위치와 내용 | Autonomy:78, worker:7, never-block:13, multi-phase-plan:6·9, autonomous-run:9, autopilot-full:7, sharpen:16, interrogate:13, bug-fix:7, visual-parity:6, worktree-cleanup:6, reflect:15, no-comments:23, automate-me:42, setup-pstack:32·40, figure-it-out:23 |
| 장치 1~6 | SKILL.md:21; show-me-your-work:13-22·65-74; ketchup:17·19·25·31; guide 07:25·31·34; SKILL.md:104; SKILL.md:82 |
| tdd 의 "비싼 테스트는 억지로 쓰지 않는다", arena 의 cross-judge·Gemini 패널, investigation 은 읽기만 | tdd:3·11·26, arena:17·28, investigation:5 |
| j-dev-kit 표의 1~19행 위치와 내용 | create.md:9·64·83·118·119, start.md:16·17·20·45·36·76·78·83·85·94, end.md:13-15·74·85·111, frontend-end-check:38, frontend-start-check:35, react.md:15-16, svelte.md:15, server-start-check:26·44·45, frontend-start-check:42, mockup.md:7·16·30, system.md:9·14·16·24·28, server-end-check:20·36, SKILL.md:44 |
| main `c8bb91b`, 백로그 014·015 | git log, docs/backlog |
| start 3 "큰 항목(여러 모듈, 새 구조)", "두 안의 차이와 추천" | start.md:41, 47 |
| CLAUDE.md 가 superpowers 를 /task 가 부르는 것으로 제한한다. Fable 이면 한 단계 낮춘다 | CLAUDE.md:17-18, SKILL.md:42, end.md:44 |
| 006·009 에 실제 프로젝트에서 돌린 기록이 없다. 정기 실행은 006 에서 지웠다 | 006:87, 009:277, 006:14 |
| review-principles 013 줄 | review-principles.md:9. 원문은 인용이 아니라 "숨겨 사용자가 고르지 못한다"로 바꿔 쓴 것이다 |

**확인 못 함:** 원본 출처(`cursor/plugins`, 받은 날짜). cursor-team-kit(control-ui·control-cli·deslop)은 사본에 없다. 무엇을 어디까지 읽었는지는 세션 기록이 없어 확인하지 못했다.

## D. 묻는 횟수를 다시 셌다

**방법:** 하위 세션에서 새 화면 UI 항목 하나를 create → start → end 로 끝낸다고 두었다. 절차 파일을 따라가며 사용자가 답해야 진행되는 멈춤을 셌다. 한 메시지에 함께 묻는 것은 하나로 셌다(start.md:45).

| | 항상 | 조건부 | 합계 |
|---|---|---|---|
| **지금** | 항목 승인, 시안 수(브리프 질문 포함), 캔버스 고르기, 계획 승인, simplify 할지, 머지 = 6. 🟡 가 있으면 +1 | 계획 질문과 DESIGN.md 를 합쳐 +1, 방향 표 +1, simplify 고르기 +1, 시안 "됐다" +1, 새 색·글꼴 +1, 기준 브랜치 확인 +1 | **약 6~10**. DESIGN.md 를 새로 만들면 system 단계에서 톤 질문, 쓰기, `@DESIGN.md`, 커밋으로 +4 가 붙어 **최대 약 14** |
| **바꾸면** (보고서 제안 기준) | 시안 고르기, 🟡·머지를 묶은 한 번 = 2 | 계획 질문 +1, (나)에서 큰 항목이면 계획 승인 +1 | **2~4** 로 보고서와 같다. 다만 DESIGN.md 를 만드는 항목은 17행 "값만 묻는다"(+ 톤·원칙)가 남아 **최대 약 5~6** |

정리하면 보고서의 2~4 는 맞다. 8~11 은 하한이 높고, 상한 11 은 DESIGN.md 질문을 두 번 셌다. DESIGN.md 를 새로 만드는 경우의 질문 4개쯤은 빠졌다.
