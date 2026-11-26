# 016 AC #9 조사: `/task`가 부르는 superpowers 스킬이 사람에게 묻는 곳

확인 날짜: 2026-11-26. 읽기만 했고 이 파일 말고는 쓰지 않았다.

**표기:** **[확인]**은 원문을 열어 줄 번호까지 본 것이다. **[추론]**은 확인한 것에서 끌어낸 판단이고, 016 계획에서 확인할 가정으로 다룬다.

## 본 것

| 무엇 | 위치 |
| --- | --- |
| 설치된 superpowers 7.0.2 | `~/.claude/plugins/cache/anthropic-plugin-directory/superpowers/7.0.2-22f0b463e7a5/skills/…` (아래 `SP/`) |
| upstream main·dev | `raw.githubusercontent.com/obra/superpowers/{main,dev}/…`, GitHub API 커밋·브랜치·열린 PR 목록. 받은 파일은 스크래치에만 두었고 실행하지 않았다 |
| `/task` | `plugins/workflow/skills/task/SKILL.md`, `references/create.md`·`start.md`·`end.md` |
| 앞선 조사 | `research_notes/2026-11-26-pstack-분석과-차용/fact-check.md` B절 superpowers 표, `2026-11-26-코딩-에이전트-실무자-워크플로.md:73,90` |
| 우선순위 근거 | `SP/using-superpowers/SKILL.md:22,28-31,65`, `SP/../hooks/session-start:25,49`, 저장소 `CLAUDE.md:16-18`, `README.md:70-75`, `task/SKILL.md:59` |

## 1. upstream 변화 [확인]

- **7.0.2 이후 바뀐 것이 없다.** upstream `main`의 머리 커밋은 `22f0b46`(2026-11-03, "Release v7.0.2…")이고, 설치본 폴더 이름의 해시 `22f0b463e7a5`와 같다. `dev`(`d4b6d3b`, 2026-11-24)도 아래 여덟 스킬의 `SKILL.md`가 설치본과 바이트 단위로 같다(`diff -q`). `RELEASE-NOTES.md`도 같고, 맨 위가 v7.0.2 다.
  - 비교한 파일: brainstorming, test-driven-development, receiving-code-review, finishing-a-development-branch, using-superpowers, systematic-debugging, verification-before-completion, requesting-code-review.
- 7.0.2 에서 묻는 방식이 바뀐 것은 brainstorming 하나다(`RELEASE-NOTES.md:9-13`). 답이 만들 것을 바꾸고 다른 데서 답을 찾을 수 없을 때만 묻는다. 절차 질문은 하지 않는다. 이유(why)를 먼저 묻는다. 선택지에는 추천을 붙인다. 군더더기 질문이 41개에서 23개로 줄었다고 적혀 있다(`:13`). 나머지 세 스킬의 묻는 곳에는 7.0.x 노트에 변경이 없다.
- 머지되지 않은 열린 PR 중 묻는 곳을 바꿀 수 있는 것: #2101(obra, 새 프로젝트면 설계 발표에서 품질 도구를 묻는다, 질문이 는다), #2271(계획 넘기기 부담 줄이기), #2263(맥락 요청이 열린 질문을 닫지 않는다), #2371(finishing PR 선택 뒤 정리 안내). 지금 판에는 없다. 다음 업데이트 때 볼 것으로만 적는다.

## 2. 묻는 곳 대조 [확인]

fact-check.md 의 줄 번호는 모두 맞다. 빠진 곳을 더했다(표의 ★).

| 스킬 | 묻는 곳 (파일:줄, 인용) | fact-check 와 |
| --- | --- | --- |
| brainstorming | `:26-33` 구현 전 순서: 접근을 고르게 하고, 설계 문서 승인, writing-plans 호출 | ★ 빠짐 |
| | `:67-68` 이유를 안 말했으면 "ask about that: one open question" | ★ |
| | `:74-76` "ask them to approve it. Their approval covers the approach and the design" | 맞음 |
| | `:90-95` 요청이 brainstorming 이 아니면 "Or if you'd rather I just dive in, say so." | ★ |
| | `:101-106` "Ask a question only when the answer would change what gets built" … "Ask one at a time." | 맞음(:106) |
| | `:156-167` 접근 2~3개를 따로 한 메시지로, "ask which way they want to go" | ★ |
| | `:199-200` 되짚기 덩어리마다 "End each chunk by asking what's wrong or missing." | ★ |
| | `:250-266` 큰 일이면 builder check 후 "theirs" 질문을 한 메시지로 | ★ |
| | `:269-283` HARD-GATE "Nothing gets built until your human partner approves the design doc", 다음은 "invoke superpowers:writing-plans and no other skill" | 맞음(:270). writing-plans 지시는 ★ |
| | `:302-306` 시각 도우미 제안은 따로 한 메시지 | ★ |
| test-driven-development | `:24-27` "Exceptions (ask your human partner):" 버릴 시제품, 생성 코드, 설정 파일 | 맞음. **문서 파일은 목록에 없다** |
| | `:312` 테스트 방법을 모르면 "Ask your human partner." | 맞음 |
| | `:330` "No exceptions without your human partner's permission." | 맞음 |
| receiving-code-review | `:20` "Restate requirement in own words (or ask)" | ★ |
| | `:43-45` "IF any item is unclear: STOP … ASK for clarification" | 맞음 |
| | `:63` 사람의 지적이어도 "Still ask if scope unclear" | ★ |
| | `:79-80` "I can't verify this without [X]. Should I [investigate/ask/proceed]?" | ★ |
| | `:82-83` "conflicts with your human partner's prior decisions: Stop and discuss" | 맞음 |
| | `:94` "Remove it (YAGNI)?", `:127` 구조 문제면 "Involve your human partner" | ★ |
| | `:174` "Can't verify, proceed anyway → State limitation, ask for direction" | 맞음 |
| finishing-a-development-branch | `:48-51` 기준 브랜치를 모르면 "ask: This branch split from <guess> - is that correct?" | 맞음 |
| | `:78-82` 메뉴를 그대로 보이고 "Wait for their answer; the integration decision is theirs." | ★ (머지 승인 자체) |
| | `:132-146` 버리기는 사용자가 먼저 요청할 때만, "Type 'discard' to confirm." | 맞음(:143). **7.0.2 메뉴에는 버리기가 없다**(`:55-65`) |
| | `:177-196` 워크트리 삭제가 거부되면 "Never `--force` on your own initiative" 후 세 갈래 질문 | 맞음(:222) |
| | `:216` "Tests passed earlier this session" 은 핑계라고 적음(묻기는 아님, 다시 돌림) | ★ |
| | `:224` "The base branch is obviously main → Confirm the fork point or ask." | 맞음 |
| | `:225` 강제 푸시는 사람이 분명히 요청할 때만 | ★ |
| verification-before-completion | 묻는 곳 없음 | 맞음 |

## 3. `/task`가 부르는 곳 [확인]

| 스킬 | 부르는 곳 | 부르는 쪽이 이미 정한 것 |
| --- | --- | --- |
| brainstorming | `create.md:64` "모호하면 `superpowers:brainstorming` 스킬을 부른다" | 설계 문서를 쓰지 않는다, 구현 계획으로 넘어가지 않는다, 질문은 한꺼번에 최대 3개 |
| | 직접 부르지 않지만 끼어든다: `start.md:36` `EnterPlanMode` 직전. 부트스트랩이 "Before entering plan mode … invoke the brainstorming skill first"(`using-superpowers:22`)라고 한다. `README.md:75`도 superpowers 문단이 없으면 계획 단계를 가로챈다고 적는다 | 없음 |
| test-driven-development | `start.md:73` "부르고 따른다" | 없음. `start.md:76`은 테스트가 틀렸다고 보면 묻는다(이건 `/task` 자신의 질문) |
| receiving-code-review | `end.md:80` "부르고 따른다(지적을 코드에서 확인하고…)" | 사용자가 4단계에서 고칠 것을 이미 골랐다(`end.md:74-76`) |
| finishing-a-development-branch | `end.md:111-118` | 검증은 방금 통과(`:113`), 기준 브랜치는 프로젝트 설정의 것(`:113`), 워크트리면 머지·정리는 이 줄이 우선(`:115`), 푸시는 요청할 때만(`:118`). 메뉴 답이 머지 승인이라고 적는다(`:111`) |
| verification-before-completion | `start.md:88` | 묻는 곳이 없어 넘길 것도 없다 |
| systematic-debugging | 부르지 않는다. 부트스트랩의 "Fix this bug → systematic-debugging first"(`using-superpowers:31`)로 `start.md:88`(새 실패를 고친다)이나 `end.md` 5단계에서 끼어들 수 있다 | — |
| requesting-code-review | 부르지 않는다. `end.md:40`은 Claude Code 의 `code-review` 스킬을 쓴다 | — |
| using-git-worktrees | 부르지 않는다. 저장소 `CLAUDE.md:17-18`이 쓰지 말라고 막는다 | — |

부트스트랩이 들어오는 경로 [확인]: superpowers 의 SessionStart 훅이 `using-superpowers/SKILL.md` 전문을 `<EXTREMELY_IMPORTANT>`로 감싸 넣는다(`hooks/session-start:25,49`). `start`가 띄우는 하위 세션은 서브에이전트가 아니라 새 세션이라 `<SUBAGENT-STOP>`(`using-superpowers:6-8`)에 걸리지 않는다 [추론].

## 4. "스킬 본문이 사람에게 물으라고 할 때 부르는 쪽 지시가 이기나"

확인한 것:

- `using-superpowers:65`: "User instructions (CLAUDE.md, AGENTS.md, …, direct requests) take precedence over skills". 순서는 사용자 지시 > 스킬 > 기본 동작이다. **스킬끼리의 순서는 정하지 않는다.** `:28`의 "process skills come first"는 어느 스킬을 먼저 부르나의 규칙이지 충돌 해소 규칙이 아니다.
- `/task`(SKILL.md·절차 파일)는 스킬이다. 사용자 지시가 아니다.
- `task/SKILL.md:59`: "프로젝트 CLAUDE.md 의 규칙이 이 스킬과 superpowers 보다 우선한다." CLAUDE.md 가 위라고만 하고, `/task`가 superpowers 위라고는 하지 않는다.
- 저장소 `CLAUDE.md:16-18`(README `:70-75`가 모든 사용자에게 같은 문단을 적으라고 한다): "이 문서의 규칙이 우선이다. `/task`가 부르는 스킬만 따르고, writing-plans, executing-plans, subagent-driven-development, using-git-worktrees 는 쓰지 않는다." 이 문단이 막는 것은 **어느 스킬을 쓰나**이고, 부른 스킬 안의 질문을 `/task`가 대신 답해도 된다는 말은 없다.
- 스킬 본문 안에도 미리 답할 자리가 있다. brainstorming: 묻기를 빼 달라고 하면 스킬이 끝난다(`:38-40, :276`), 절차는 스스로 정한다(`:104-105`), 결과를 말하는 사람은 방법을 맡긴 것이다(`:125-127`). finishing: 기준 브랜치가 "named in the plan, the conversation"이면 묻지 않는다(`:48-50`). TDD 는 예외에 사람의 허락을 요구할 뿐 허락을 받는 시점을 정하지 않는다(`:24, :330`).

판단 [추론]:

1. **(가) 미리 답해 넘기기는 "스킬 대 스킬"이라 보장이 약하다.** 넘긴 문장이 이기는 근거는 위의 "스킬 안의 빈자리"뿐이다. 빈자리가 있는 곳(finishing 기준 브랜치, TDD 허락, brainstorming 절차 질문)은 이길 가능성이 높다. 빈자리가 없고 강한 말("HARD-GATE", "Present the menu exactly as written", "Only the typed word `discard`")로 막힌 곳은 넘긴 문장이 진다고 보는 편이 안전하다.
2. **(나) 부르지 않기는 사용자 지시 층이 받쳐 준다.** CLAUDE.md 의 "`/task`가 부르는 스킬만 따르고"가 있으면, `/task`가 부르지 않는 스킬은 사용자 지시로 빠진다(`using-superpowers:65`가 사용자 지시를 스킬 위에 둔다). 그래서 부르지 않기로 한 스킬은 부트스트랩으로 다시 끼어드는 것도 함께 막힌다. 단, CLAUDE.md 에 그 문단이 없는 프로젝트에서는 이 받침이 없다.
3. (가)를 더 세게 하려면 넘길 답을 사용자 지시 층에 올린다. README 의 CLAUDE.md 문단에 "`/task`가 부른 스킬에 넘긴 지시는 그 스킬 본문보다 우선한다" 한 줄을 더하는 방법이다. 사용자 CLAUDE.md 를 고치는 일이니 016 기준("프로젝트 밖·공유 설정을 바꾸는 일")으로 README 에 적어 두고 사용자가 넣게 한다. 저장소 자신의 `CLAUDE.md`를 바꿀지는 사람에게 묻는다.
4. Skill 도구의 `args`로 넘긴 글이 superpowers 스킬 본문에 어떻게 붙는지는 확인하지 못했다(이 스킬들은 `$ARGUMENTS`를 쓰지 않는다). 그래서 넘길 문장은 `args`에 기대지 말고 **절차 파일의 부르는 줄 바로 앞뒤**에 적어 같은 맥락에서 읽히게 한다.

## 5. 스킬별 선택

| 스킬 | 묻는 곳 | upstream 변화 | /task 가 부르는 곳 | 선택 | 넘길 문장 초안 (또는 `/task`에 둘 것) | 위험 |
| --- | --- | --- | --- | --- | --- | --- |
| brainstorming | `:26-33` 접근 고르기·문서 승인; `:74-76` "ask them to approve it"; `:106` "Ask one at a time."; `:156-167` 접근 고르기; `:199-200` 덩어리마다; `:269-283` HARD-GATE·writing-plans | 7.0.2 이후 없음. 7.0.2 가 질문 조건을 바꿈(`RELEASE-NOTES:9-13`). 열린 PR #2101 은 질문을 늘림 | `create.md:64`. 부트스트랩으로 `start.md:36` 플랜 모드 직전에 끼어듦(`using-superpowers:22`) | **(나)** | `create.md` 1단계에 둔다: "모호하면 묻는다. 답이 항목(목적·결과·범위)을 바꾸고 저장소·문서로 답할 수 없는 것만, 한꺼번에 최대 3개. 이유를 모르면 그것을 먼저 묻는다. 고를 수 있는 선택이면 선택지와 추천을 붙인다. 파일 위치·라벨·형식 같은 절차는 묻지 않고 정해 Description 에 적는다. 방법(접근)은 묻지 않는다. 항목에는 방법을 쓰지 않는다(`create.md:72`)." 그리고 `superpowers:brainstorming`을 부르지 않는다 | (1) 012 eval 에서 "답이 바꾸는 것만" 조건판이 "최대 3개"보다 나빴다(`docs/done/012-…md:350-356`, mockup-cart 는 질문이 7개까지 늘었다). 7.0.2 규칙을 **더하되 "최대 3개, 한꺼번에"는 남긴다.** (2) upstream 개선을 따라가지 못한다. (3) CLAUDE.md 문단이 없는 프로젝트에서는 부트스트랩이 여전히 brainstorming 을 부르고, 그 HARD-GATE 가 writing-plans 로 보낸다. 016 이 플랜 모드를 없애면 `using-superpowers:22` 경로는 사라지지만 `:30` "Let's build X" 경로는 남는다 |
| test-driven-development | `:24` "Exceptions (ask your human partner)"; `:312` "Ask your human partner."; `:330` "No exceptions without … permission." | 없음 | `start.md:73` | **(가)** | `start.md:73` 바로 뒤: "TDD 예외는 사용자가 미리 허락한 것으로 한다: 설정 파일, 생성 코드, 버릴 시안, 그리고 실행되지 않는 문서(마크다운 스킬·README 포함). 예외로 둔 파일과 대신 쓴 확인(명령·grep·eval)을 `Implementation Notes`에 적는다. 테스트할 방법을 모르면 묻지 말고 바깥 증거로 확인할 방법을 정해 적는다. 기존 테스트가 틀렸다고 보면 고치지 말고 멈추고 묻는다(`start.md:76`)." | (1) `:330`의 "permission"을 스킬 글이 대신 준 것이 사용자 허락인지 모델이 의심할 수 있다. CLAUDE.md 문단에 올리면 단단해진다(4절 3). (2) 예외를 넓히면 테스트로 막을 수 있던 동작 변경이 빠질 수 있다. "동작을 바꾸는 코드는 예외가 아니다"를 함께 적는다. (3) AC #9 문구 "설정·문서 파일 예외"는 원문과 다르다. 원문 예외는 버릴 시제품·생성 코드·설정 파일이고 문서는 없다 |
| receiving-code-review | `:44-45` 불분명하면 멈추고 묻기; `:63` "Still ask if scope unclear"; `:79-80` 확인 못 하면 방향 묻기; `:82-83` 이전 결정과 부딪히면 논의; `:94`, `:127` | 없음 | `end.md:80` | **(가)**, 질문은 앞으로 당김 | `end.md` 4단계 판정 에이전트 지시에 더한다: "고칠 방법이 둘 이상으로 갈리거나 AC·사용자가 답한 것과 부딪히는 지적은 '사람이 정할 것'으로 따로 표시한다." 그 표시는 4단계의 한 번 묻기에 넣는다. 5단계 부르는 줄 뒤: "이 지적들은 사용자가 4단계에서 이미 골랐고 판정 에이전트가 코드에서 확인했다. 불분명한 것과 이전 결정과 부딪히는 것은 4단계에서 이미 물었다. 그래서 여기서는 다시 묻지 않는다. 해석이 필요하면 코드에 맞는 쪽으로 정해 고치고 그 해석을 `Implementation Notes`에 적는다. 확인할 수 없는 지적은 고치지 않고 '확인 못 함'으로 Final Summary 의 그대로 둔 지적에 적는다." | (1) `:44-45`는 "STOP"이라 강하다. 5단계 중간에 새 모호함이 생기면 모델이 멈출 수 있다. 그때 멈추는 것은 016 기준에서도 틀리지 않다(정말 갈리면 사람의 일). (2) 판정 에이전트가 "사람이 정할 것"을 놓치면 해석을 Claude 가 정한다. 그 해석은 end 머지 전 질문에 "정한 것"으로 다시 보인다(016 AC #6). (3) 대안 (나): end 가 이미 판정·재판정을 하고 `end.md:80-81`에 핵심 두 줄이 있어 스킬을 빼도 잃는 것이 적다. 그러면 CLAUDE.md 문단이 끼어들기도 막는다 |
| finishing-a-development-branch | `:48-51` 기준 브랜치 확인; `:78-82` 메뉴와 기다림; `:143` "Type 'discard' to confirm."; `:179-196` `--force` 전 질문; `:224` | 없음. 열린 PR #2371(정리 안내)뿐 | `end.md:111-118` | **(나)** 추천, 대안 (가) | (나): `end.md` 4단계의 한 번 묻기에 머지 방식(로컬 머지 / PR / 그대로)을 넣고(016 AC #6), 7단계는 스킬 없이 `end.md:115-118`대로 한다. 버리기는 메뉴에 넣지 않는다. 사용자가 먼저 버리자고 할 때만 지울 브랜치·커밋·워크트리를 보이고 확인받는다(되돌릴 수 없는 일). (가)라면 7단계 부르는 줄 뒤: "기준 브랜치는 `<기준>`이다(프로젝트 설정). 이미 알려져 있으니 3단계에서 묻지 않는다. 사용자는 4단계에서 `<방식>`을 골랐다. 그 답이 4단계 메뉴의 답이다." | (나): 스킬이 지키던 것(머지 결과 테스트 `:98-104`, 거부된 푸시에 강제 푸시 금지 `:225`, 기준 브랜치 `git pull`)을 `end.md`로 옮겨야 한다. 지금도 `end.md:115`가 머지 위치·정리를 덮어쓰고 있어 옮길 것은 적다. (가): `:78` "Present the menu exactly as written"과 `:217` "They obviously want it merged → Present the menu and wait"가 넘긴 답을 이길 수 있다. 그러면 메뉴가 한 번 더 뜬다. 또 Step 6 의 정리 조건 "under `.worktrees/` or `worktrees/`"(`:169`)가 `.claude/worktrees/…`에 맞는다고 읽히면 세션이 들어 있는 워크트리를 지우려 할 수 있다(`end.md:115`가 막고 있다) |
| verification-before-completion | 없음 | 없음 | `start.md:88` | **(다)** | 없음 | 없음. finishing 을 (가)로 두면 `:16`·`:216` 때문에 검증이 한 번 더 돈다(묻기는 아니다) |
| systematic-debugging | `:165` "Ask for help"; `:196` "DON'T attempt Fix #4 without architectural discussion"; `:210` "Discuss with your human partner before attempting more fixes" | 없음 | 부르지 않음. 부트스트랩으로 `start.md:88`·`end.md` 5단계에서 끼어들 수 있음 | **(다)** | 넘기지 않는다. 세 번 실패하면 멈추는 것은 `/task` 자신의 규칙(`start.md:94`, `end.md:85`)과 같고 016 기준("무엇을 할지 고르기")에도 맞다 | `:165` "Ask for help"는 "코드로 답할 수 있는 건 묻지 않는다"(`task/SKILL.md:63`)와 부딪힌다. CLAUDE.md 문단이 있으면 `/task`가 부르지 않으니 빠진다. 디버깅 규율을 원하면 `start.md:88`에서 부르고 "세 번 실패 멈춤은 `/task`의 것과 같다"를 넘긴다 |
| requesting-code-review | 없음 | 없음 | 부르지 않음(`end.md:40`은 `code-review`) | **(다)** | 없음 | 없음 |
| using-git-worktrees | `:41-45` 워크트리 동의; `:130,156` 기준선 실패면 묻기 | 없음 | 부르지 않음. CLAUDE.md 가 막음 | **(다)** | 없음 | CLAUDE.md 문단이 없는 프로젝트에서 `start --here`의 브랜치 만들기 때 끼어들 수 있다 |

## 6. 놀라운 것

1. **upstream 은 설치본 그대로다.** main 과 dev 모두 7.0.2 와 같아, 이번 016 은 7.0.2 원문만 맞추면 된다.
2. **CLAUDE.md 문단이 (나)를 받쳐 준다.** "`/task`가 부르는 스킬만 따르고"는 사용자 지시 층이라, 부르지 않기로 한 스킬은 부트스트랩 끼어들기까지 함께 빠진다. 반대로 (가)는 스킬 대 스킬이고, using-superpowers 에는 스킬끼리의 우선순위 규칙이 없다.
3. **지금 `start`의 플랜 모드가 brainstorming 을 부를 수 있다.** 부트스트랩의 `using-superpowers:22`가 플랜 모드 전에 brainstorming 을 먼저 부르라고 한다. brainstorming 은 `/task`가 부르는 스킬이라 CLAUDE.md 문단으로도 start 에서 확실히 빠지지 않는다. 그 HARD-GATE(`:281-282`)는 CLAUDE.md 가 금지한 writing-plans 로 보낸다. brainstorming 을 (나)로 빼면 이 모호함도 사라진다.
4. **TDD 원문 예외에 "문서 파일"은 없다.** AC #9 의 "설정·문서 파일 예외"는 원문(버릴 시제품·생성 코드·설정 파일)과 다르다. 마크다운만 바꾸는 j-dev-kit 같은 저장소에서는 TDD 적용 여부가 모호해 `:330` 허락 질문이 나올 수 있다.
5. **7.0.2 finishing 메뉴에는 버리기가 없다.** 사용자가 먼저 요청할 때만 `discard` 입력을 받는다. `/task`가 버리기를 묻지 않으므로 이 질문은 평소에는 나오지 않는다.
6. **7.0.2 식 질문 조건만으로는 012 eval 에서 나빠졌다.** brainstorming 규칙을 `create`로 옮길 때 "최대 3개, 한꺼번에"를 지우면 안 된다.
