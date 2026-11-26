# 분석가 3 보고 (회의적 관점): pstack 의 질문 방식과 j-dev-kit 비교

표기: **[직접]**은 원문을 열어 읽은 것, **[추론]**은 내 판단이다. pstack 경로는 사본 루트(`…/scratchpad/pstack/pstack/`) 기준으로 적었다.

## 1. pstack 은 언제 사람에게 묻나 (전수)

**사람에게 묻거나 멈추는 곳 [직접]**
- **되돌릴 수 없는 일:** force-push, 배포, 데이터 삭제, 바깥 메시지에서 멈춘다(`skills/poteto-mode/SKILL.md:78`, `worker.md:117`, `principle-never-block-on-the-human/SKILL.md:13`).
- **제품 방향·취향:** 실험으로 가릴 수 없는 판단만 묻는다(`principle-never-block…:15`, `playbooks/multi-phase-plan.md:6`, `autonomous-run.md:9`).
- **막다른 길:** 진짜 막혔을 때만 알린다(`autonomous-run.md:9,11`).
- **재현:** 도구로 갈 수 있는 데까지 간 뒤, 구체적 이유가 있을 때만 사용자에게 재현을 부탁한다(`bug-fix.md:7`).
- **기준선이 틀려 보일 때:** 고치지 않고 멈춰 묻는다(`visual-parity.md:6`).
- **커밋 안 된 작업이 걸린 워크트리 삭제:** 결정을 받는다(`worktree-cleanup.md:6`).
- **보안·데이터·애매한 봇 지적:** 사용자에게 넘긴다(`references/bugbot-triage.md:11`, `babysit.md:9`).
- **의도가 불분명할 때:** interrogate 가 묻는다(`interrogate/SKILL.md:13`).
- **머지:** 오너 승인을 기다리고, babysit 은 머지 권한이 없다(`babysit.md:10`). autopilot-stack 은 "verified"에서 멈추고 넘긴다(`autopilot-stack.md:5`).
- **계획:** multi-phase-plan 은 계획만 내고 "명시적 go"를 기다린다(`multi-phase-plan.md:9`). 계획을 보여 달라는 요청이 실행 허가는 아니다(`autopilot-full.md:7`).
- **긴 실행:** "a multi-hour run earns one checkpoint"(`figure-it-out/SKILL.md:23`).
- **설정 스킬:** 예산과 모델을 묻는다(`setup-pstack/SKILL.md:32,40`, `automate-me/SKILL.md:17,44`).

**질문 대신 쓰는 것 [직접]**
- 고르고 진행한 뒤 결과를 보인다. 사람은 나중에 바로잡는다(`principle-never-block…:9-14`).
- 첫 메시지에서 목표와 최소 변경을 다시 말하고 바로 진행한다(`SKILL.md:19`). 오독은 이 재진술에서 드러난다(`docs/guide/02-poteto-mode.md:67`).
- 실행해서 가릴 수 있는 갈림길은 묻지 않고 프로토타입으로 가린다(`SKILL.md:21`).
- 결정 로그(TSV)를 남기고 다른 회사 모델이 교차 검토한다(`show-me-your-work/SKILL.md:13-74`).
- 사용자가 미리 답해 두는 문구가 있다: "going to bed", "don't ask me before committing"(`SKILL.md:80`, `guide/07-overnight.md:25-34`).
- 하위 에이전트는 질문 도구를 쓰지 않는다(`worker.md:117`).

pstack 에는 계획 스킬이 일부러 없다(`guide/04-design.md:97`).

**pstack 이 의존하는 안전망 [직접]:** 프롬프트에 사용자가 쓰는 확인 가능한 끝 조건(`guide/02…:45`), PR 마다 구현하지 않은 검증자의 판정(`playbooks/shipping.md:5`), PR·CI·사람 리뷰다.

## 2. j-dev-kit 이 묻거나 승인받는 곳 (전수, 경로는 `plugins/` 기준)

| 위치 | 내용 | 판단 | 이유 |
|---|---|---|---|
| `workflow/skills/task/SKILL.md:24` | 모드 불명 | 계속 | 드물다 |
| `SKILL.md:44,47` | 하위 세션 계획을 `ExitPlanMode`로 승인, 부모가 전달 | 없앰 | 사용자 결정. 그 밖의 질문 전달은 유지 |
| `SKILL.md:52` | 검증 명령이 없을 때 | 계속 | 사용자만 아는 값 |
| `create.md:9` | 처음 쓸 때 README·템플릿 승인, 라벨 질문 | 줄임 | 되돌릴 수 있다. 기본값으로 만들고 알린다 |
| `create.md:64` | brainstorming 호출(질문 최대 3개) | 줄임 | 아래 충돌 참고 |
| `create.md:83-85` | 항목(AC) 보여 주고 승인 | **계속** | 계획 승인을 없애도 되는 근거 자체다(3절) |
| `create.md:118` | 서베이 후보 고르기 | 계속 | 제품 방향 |
| `create.md:119` | 고른 뒤 항목 내용을 다시 한 번 승인 | 줄임 | 118과 합친다. 후보 표에 AC 초안을 넣는다 |
| `start.md:16,17` | 커밋 안 된 변경, 다른 브랜치(버리기 포함) | 계속 | 데이터 손실 위험. pstack 도 같다(`worktree-cleanup.md:6`) |
| `start.md:20` | 항목 고르기 | 계속 | 모호할 때만 묻는다 |
| `start.md:32,45` | 스택 점검 "물을 것"과 계획 질문을 한꺼번에 | 계속 | 유일한 구현 전 정지점으로 둔다 |
| `start.md:36,49,58` | 플랜 모드와 승인 | 없앰 | 사용자 결정 |
| `start.md:47` | 갈리는 설계 두 안과 추천 | 줄임 | 되돌리기 비싼 것만 45의 질문에 합친다. 나머지는 실행(eval)으로 정하고 가정으로 적는다(`SKILL.md:21`) |
| `start.md:76` | 테스트가 틀린 것 같으면 멈춤 | 계속 | 테스트를 약하게 고쳐 통과시키는 것을 막는다. pstack `visual-parity.md:6`과 같다 |
| `start.md:77` | 다른 일을 항목으로 만들지 동의 | 줄임 | Notes 에 적고 끝 보고에서 한 번에 묻는다 |
| `start.md:78` | 범위가 커지면 멈춤 | 계속 | 기준을 명확히 할 것 |
| `start.md:83,85` | simplify 를 돌릴지 묻고, 고칠 것을 또 묻는다 | **없앰 또는 end 로 합침** | 같은 일로 두 번 묻는다. end 의 code-review 와도 겹친다 |
| `start.md:89,94` | 브라우저 도구 없음, 3회 실패 | 계속 | 막다른 길(`autonomous-run.md:11`과 같다) |
| `end.md:108-111` | 시작 조건 | 계속 | 스스로 버리지 않는다 |
| `end.md:156` | 검증 명령 변경을 보여 줌 | 계속 | 판정 장치의 무결성 |
| `end.md:169` | 🟡·🔁 처리 질문 | 줄임 | 머지 방식과 한 메시지로 합친다(아래 위험 참고) |
| `end.md:182` | 나중 항목 내용 승인 | 없앰 | 사용자가 이미 골랐다. 되돌릴 수 있다 |
| `end.md:187,190` | 새 실패, 닫기 조건 미충족 | 계속 | 자동 판정 결과다 |
| `end.md:206` | finishing 메뉴(머지 승인) | 계속 | pstack 도 머지는 사람이 한다(`babysit.md:10`) |
| `frontend/skills/frontend-start-check/SKILL.md:16,29,42` | 모노레포, 새 색·글꼴, DESIGN.md | 계속(16·29), 줄임(42) | 16·29는 start 질문 묶음에 합친다. 42는 한 번 정해 CLAUDE.md 에 남긴다(이미 그렇다) |
| `frontend-start-check/references/react.md:15-16`, `references/svelte.md:15-16` | 플러그인 설치, 문서 받기, svelte 4 이하 | 계속, 묶음 | 사용자 환경 밖을 바꾸는 일이다 |
| `frontend/skills/ui-design/references/mockup.md:7` | 시안 수를 "늘 묻는다" | 줄임 | 기본 3개(`:10`)로 진행 |
| `mockup.md:16` | 방향 표 확인 | 없앰 | 어차피 캔버스에서 고른다 |
| `mockup.md:30` | 시안 고르기 | 계속 | 취향 |
| `ui-design/SKILL.md:27`, `references/system.md:16,28` | 쓰기 전 승인과 커밋 전 승인 | 줄임 | 같은 것을 두 번 승인한다 |
| `system.md:9,13,14` | 토큰, 톤, 충돌 값 | 계속 | 사용자만 아는 값 |
| `server/skills/server-end-check/SKILL.md:20` | 이름 없는 도구 설치 | 계속 | 공급망 |
| `server-end-check/SKILL.md:36` | 로컬 Supabase 를 켤지 | 줄임 | 로컬이고 되돌릴 수 있다 |
| `server/skills/server-start-check/SKILL.md:20,26,44,45` | 서비스, 마이그레이션 담당, 공식 스킬 설치 | 계속, 묶음 | |

**superpowers 스킬 안의 숨은 정지점 [직접]**
- brainstorming 은 "Ask one at a time"이다(`.../superpowers/7.0.2-22f0b463e7a5/skills/brainstorming/SKILL.md:106`). 접근 고르기와 설계 문서 승인을 거쳐 writing-plans 로 넘어간다(`:26-31`). create.md:64 의 "한꺼번에 최대 3개", CLAUDE.md 의 writing-plans 금지와 부딪혀 질문이 여러 번 오갈 수 있다 [추론].
- TDD 는 설정 파일, 생성 코드, 프로토타입이면 "ask your human partner"다(`test-driven-development/SKILL.md:24-27`). 이 저장소는 대부분 마크다운과 설정이라 해당될 수 있다 [추론].
- receiving-code-review 는 불명확하거나 이전 결정과 충돌하면 묻는다(`:44-45,82-83,174`).
- finishing 은 기준 브랜치 확인과 메뉴가 있다(`:50-51,74-81`). end.md:208 이 기준 브랜치는 미리 답한다.

## 3. 계획 승인을 없애려면

**대신할 장치**
1. **create 의 AC 승인을 유일한 계약 게이트로 명시한다**(`create.md:83`). pstack 의 "프롬프트의 done check"(`guide/02…:45`)에 해당한다.
2. **start 질문 묶음을 유일한 구현 전 정지점으로 둔다**(`start.md:45`). 플랜 모드는 도구 차원에서 편집을 막았지만 앞으로는 지시문뿐이다. 그래서 "질문이 있으면 턴을 끝내고 멈춘다. 답 전에는 브랜치도 파일도 만들지 않는다"를 명시해야 한다 [추론].
3. **pstack 식 재진술:** 목표, 최소 변경, 가정을 3~5줄로 말하고 진행한다(`SKILL.md:19`). 계획은 그대로 `Implementation Plan`에 커밋한다(`start.md:68`). 사용자가 언제든 읽고 끼어들 수 있다.
4. **사후 안전망:** 바깥 판정자의 AC 판정(`start.md:90-92`), end 리뷰와 판정(`end.md:151`), 기준 브랜치 명령으로 도는 Stop 훅(`hooks/verify-on-stop.sh:31-59`). 이미 있다.
5. **큰 항목 대비:** create 의 크기 규칙(`create.md:74`)으로 쪼갠다. pstack 도 큰 일에는 체크포인트를 남긴다(`figure-it-out:23`, `multi-phase-plan:9`). 큰 항목이 생기지 않게 하는 것이 결정을 뒤집지 않는 대응이다 [추론].

**함께 고쳐야 할 곳 [직접]**
- `start.md:3,34-36,49,58`, `SKILL.md:44,47`와 i18n 사본, 버전, README.
- `docs/review-principles.md:8`의 "승인된 계획·AC… 계획 때 사용자가 정한 것"을 AC 와 기록된 가정 기준으로 바꿔야 한다.
- eval 사례 `start-plan`(`docs/done/012…:316`).

**위험 [직접 근거]**
- 계획 승인은 매번 형식적이지 않았다.
  - 010·011 은 "추천안대로 승인"이었다(`docs/done/010…:99`, `011…:49`).
  - 008 은 승인 때 AC #9 를 바꾸고 범위를 더했다(`008…:114-119`). 012 는 Supabase 조건을 붙였다(`012…:157`).
  - 이런 수정은 이제 구현 뒤 end 에서 들어와 재작업이 된다.
- 이틀 전 사용자가 직접 "하위 세션도 공식 플랜 모드"를 넣었다(`012…:72-78`, 2026-11-24). 번복 이유를 항목에 적어 두지 않으면 리뷰 원칙과 충돌한다.

## 4. 가져올 것 / 보류 / 가져오지 않을 것

**가져올 것**
- **되돌릴 수 없는 것만 멈춘다는 목록을 task `SKILL.md` 4절에 한 줄로.** 근거: `worker.md:117`, `SKILL.md:76-78`. 우리도 이미 같은 목록을 쓴 적이 있다(`git show 219f092:plugins/workflow/skills/until-done/SKILL.md:58-67`).
- **고르고 진행한 뒤 보이고, 정한 것은 적어 한 번에 보고.** 근거: `principle-never-block…:11`, `autonomous-run.md:9`. 004 시험에서 create→end 전체가 질문 1개로 끝났다(`004…:92-93`).
- **실행으로 가릴 수 있으면 묻지 않는다.** 근거: `SKILL.md:21`. 우리는 eval 로 이미 그렇게 해 왔다(008·012·013).
- **재진술로 시작.** 근거: `SKILL.md:19`.

**보류**
- show-me-your-work TSV, 대화 기록 대조, 교차 모델 검토. Implementation Notes 와 Final Summary 로 충분하고, 다른 회사 모델은 Claude Code 에서 못 쓴다(`docs/harness/claude-code.md:36`, **CC 불가**).
- 세션 오버라이드 문구("자러 간다")와 `/loop` 자율 실행. `/goal`이 있고, `/until-done`은 안 써서 지웠다(`006…:14`).
- "No is an acceptable answer"(`SKILL.md:82`). 질문 수와는 무관하다.

**가져오지 않을 것**
- 플레이북 22개, 원칙 leaf 스킬 24개. 원칙을 쓸 때마다 leaf 를 읽게 한다(`SKILL.md:15,33`). "공통분모만"과 맞지 않는다.
- 역할별 모델 라우팅과 Fable·Gemini 패널(`SKILL.md:88-96`). Gemini 는 **CC 불가**.
- 구현은 반드시 하위 에이전트에(`feature.md:12`). 우리는 맥락을 가진 세션이 고친다(`end.md:177`). 분리는 판정자로 이미 한다.
- `worker.md:117`의 질문 도구 금지를 하위 세션에 적용하는 것. 우리 하위 세션은 사용자가 직접 대화하는 세션이다(`SKILL.md:31-32`).
- PR 중심 shipping·babysit, Bugbot, cloud agent, Automations, cursor-team-kit `/deslop`·`control-ui`. 모두 **CC 불가 또는 Cursor 전용**(`harness/claude-code.md:59-68`, `SKILL.md:24-25`).

## 5. 진입 스킬

**만들지 않는 편이 낫다고 본다 [추론, 근거는 직접].**
- **선례:** 거의 같은 것(`/until-done`: 묻지 않고 정한 것을 `Ruling:`으로 남기고, 되돌릴 수 없는 일만 모아 묻는 스킬)을 004 에서 만들었다(`git show 219f092:...until-done/SKILL.md:40-67`). 그리고 006 에서 "쓰지 않는 것이 많다"며 지웠다(`006…:14`). 따로 켜는 모드는 안 쓰였다. 질문 줄이기는 `/task`의 기본 동작이어야 한다.
- **규칙이 두 군데에 생긴다:** 원문과 번역본, 그리고 drift 관리가 늘어난다(CLAUDE.md 저장소 규칙).
- **Stop 훅이 지켜 주지 않는다:** 훅은 `w/` 브랜치와 항목 파일이 있을 때만 돈다(`verify-on-stop.sh:11-23`). 항목 없이 바로 하는 일에는 이 안전망이 없다.
- **유지 방식 차이:** pstack 은 Cursor Custom Mode 로 매 턴 스킬을 붙들어 둔다(`guide/02…:22`). Claude Code 에서 슬래시 스킬이 압축 뒤에도 유지되는지는 확인하지 못했다.

**그래도 만든다면 담을 것:** 얇은 라우터 하나(`disable-model-invocation: true`).
- 재진술.
- 백로그 일이면 `/task` 모드로 넘긴다.
- 바로 하는 일도 같은 정지 목록과 "검증을 새로 돌리고 보인다"(`SKILL.md:65`)를 따른다.
- 정한 것은 끝 보고에 모은다.

**뺄 것:** 원칙 색인, 플레이북, 모델 라우팅, 결정 로그 형식, 자체 승인 규칙.

## 6. 가장 중요한 세 가지

1. **계획 승인은 없애도 되지만 AC 승인과 바깥 판정은 남겨야 한다.** pstack 이 묻지 않아도 되는 이유는 사용자가 쓰는 끝 조건과, 구현하지 않은 검증자 때문이다(`guide/02…:45`, `shipping.md:5`). 우리에게 그 자리는 `create.md:83`과 `start.md:90-92`, Stop 훅이다. 이 셋을 줄이면 pstack 의 겉모습만 들여오고 안전망은 잃는다.
2. **모드를 새로 만들지 말고 기본값을 바꿔라.** 같은 시도(`/until-done`)가 이미 실패했다(`006…:14`).
3. **"쓸데없는 확인"은 개별 질문보다 겹친 게이트에서 나온다 [추론].**
   - 지금 겹친 것: 하위 세션 전달, 플랜 모드, simplify 두 번, ui-design 승인 두 번, 서베이 고르기 뒤 재승인, brainstorming·TDD·finishing 의 자체 게이트.
   - 한 바퀴에 5~7번 멈추던 것을 2~4번으로 줄일 수 있다(create AC 승인, start 질문 묶음은 필요할 때만, end 판단과 머지). 횟수는 절차를 세어 본 추정이다.
   - superpowers 스킬은 따로 일러 주지 않으면 자기 게이트를 다시 연다. end 의 🟡 질문을 머지 메뉴와 합치려면 finishing 이 "테스트 통과 뒤 메뉴"를 고집하는 것(`finishing…:18`)과 맞춰야 한다.

**j-dev-kit 이 pstack 보다 나은 점 [직접]**
- 결정적 Stop 훅이 기준 브랜치의 명령을 돌린다(`verify-on-stop.sh:31-59`). 작업 브랜치가 판정할 명령을 바꿔 스스로 통과시킬 수 없다.
- 기준 소스에 테스트를 대어 그 테스트가 고친 것을 증명하는지 본다(`end.md:123-129`).
- 사용자가 바로잡은 것을 리뷰 원칙으로 쌓는다(`end.md:189`).
- 커밋되는 AC 계약이 있다.
- Claude Code 전용으로 만들어져 매핑 문서가 필요 없다.
- 규모가 작다: 절차 파일 약 400줄. pstack 은 플레이북 22개와 원칙 24개다.

**읽지 못한 것**
- pstack: 원칙 leaf 스킬 중 never-block 하나만 전문을 읽었다. 나머지 원칙과 플레이북 12개, 그 밖의 스킬은 키워드 검색으로만 봤다.
- pstack 스크립트(log.sh, watch-pr)는 사본에 없어 확인하지 않았다. 웹 확인도 하지 않았다.
- `~/.claude/rules/` 자동 로드(`harness/claude-code.md:38,43`)는 검증하지 않았다.
- j-dev-kit 의 `evals/`, `i18n/`, `_proposals.md` 전문은 읽지 않았다.
