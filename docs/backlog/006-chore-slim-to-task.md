---
id: '006'
title: /task 하나로 줄이고 create·start 는 하위 세션에서, Claude 가 알아서 부르게
status: In Progress
labels: [chore]
priority: medium
dependencies: []
created_date: 2026-11-23
updated_date: 2026-11-23
---

## Description

쓰지 않는 것이 많다. `architecture`(`/arch`), `design`(`/ui`), `/lead`(run·scout·schedule), `/until-done`, 그리고 `/lead`만 쓰는 `backlog-scout`·`trend-scout`를 지우고 `/task create | start | end`만 남긴다. `design-reviewer`는 workflow 에이전트로 옮겨 `/task end` 리뷰에서 UI 가 바뀌었을 때 쓴다.

`/lead run`의 "항목마다 세션"은 `/task` 안으로 옮긴다. `create`와 `start`는 기본으로 사용자가 열어 직접 대화하는 하위 세션을 띄워 그 세션에서 절차를 따른다. `end`는 작업한 세션에서 부르니 그대로다. 세션 도구가 없거나 `--here`면 지금처럼 이 세션에서 한다. 하위 세션의 워크트리는 도구가 만드니 `워크트리: 켜기` 설정과 손으로 따는 워크트리 절차는 지운다.

지금은 사용자가 `/task`를 쳐야만 돈다. Claude 가 요청을 보고 알아서 부르게 한다.

이번에 빼는 것: 검증 Stop 훅, 포트 나누기, frontend·server 플러그인의 동작은 바꾸지 않는다(가리키는 문구만 맞춘다).

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 `architecture`, `design` 플러그인, `lead`·`until-done` 스킬, `backlog-scout`·`trend-scout` 에이전트가 원문·번역본·marketplace·README·`.claude/settings.json`에서 모두 없어졌다
- [ ] #2 `design-reviewer`가 frontend 에이전트로 있고, 화면이 바뀌었을 때 `frontend-end-check`가 `/task end` 리뷰에 넣으라고 돌려준다
- [ ] #7 frontend 에 `ui-design` 스킬(DESIGN.md 만들기·갱신, 캔버스 시안)이 있고, `frontend-start-check`가 새 화면·다시 디자인하는 항목이면 계획 전에 시안을, DESIGN.md 가 없거나 토큰이 바뀌면 DESIGN.md 를 돌려준다. 사용자가 따로 부르지 않아도 된다
- [ ] #3 `/task create <내용>`과 `/task start <번호>`는 세션 도구가 있으면 하위 세션을 띄우고 링크만 알린다(start 는 워크트리, `w/<항목>` 브랜치). 그 세션이 절차를 따른다
- [ ] #4 `--here`를 붙이거나 세션 도구가 없으면 지금 세션에서 절차를 따른다
- [ ] #5 `task` 스킬에 `disable-model-invocation`이 없고, description 이 언제 쓰는지 말한다. 절차 안의 "Skill 도구로 부르지 않는다" 우회가 없다
- [ ] #6 저장소 어디에도 지운 것(`/lead`, `/until-done`, `/arch`, `/ui`, `워크트리: 켜기`)을 쓰라는 안내가 남지 않았다(`docs/done/`, `.claude/.local/`, 그때 상태를 적은 인수인계 메모 `docs/backlog/_handoff-app-autopilot.md` 제외)

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 원문을 고친 곳은 번역본도 고쳤고, 고친 플러그인의 version·README 두 개·marketplace.json 설명을 맞췄다

<!-- DOD:END -->

## Implementation Plan

사용자가 대화에서 승인한 계획(2026-11-23).

1. 지우기: `plugins/architecture/`, `plugins/design/`(리뷰어는 옮김), `workflow/skills/lead/`, `workflow/skills/until-done/`, `workflow/agents/{backlog,trend}-scout.md`와 각 번역본.
2. `plugins/design/agents/design-reviewer.md` → `plugins/workflow/agents/design-reviewer.md`(번역본도). `/ui review`가 아니라 `/task end`가 부른다고 고친다.
3. `task/SKILL.md`: `disable-model-invocation` 지우고 description 을 언제 쓰는지로. 1절에 "어디서 하나"(하위 세션 / `--here`). 2절에서 워크트리 설정 지움.
4. `create.md`·`start.md`: 하위 세션을 띄우는 단계와 그 세션에 줄 지시문. `start.md` 4단계의 손으로 하는 워크트리 절차 지움. 번호는 쓰기 직전에 다시 확인.
5. `end.md`: 3단계 리뷰에 UI 가 바뀌면 `workflow:design-reviewer`. 5단계 "나중"은 `task` 스킬을 `create --here`로. 7단계의 워크트리 문구를 도구가 딴 워크트리에 맞춤.
6. frontend 의 가리키는 문구(`/ui review`, `/lead`), README 두 개, marketplace.json, plugin.json(workflow 0.10.0, frontend 올림), `.claude/settings.json`, backlog README.
7. 검증 명령, 지운 것을 가리키는 곳 grep.

## Implementation Notes

### Baseline

`claude plugin validate . && bash scripts/check-repo-rules.sh` 통과(실패 없음).

### 리뷰 반영

`code-review`의 지적 중 확인한 4건을 고쳤다(원문·번역본·README).

- 워크트리면 의존성을 기준선보다 먼저 설치한다(`start.md` 2단계 0). 설치 전에 잰 기준선은 진짜 실패를 가린다.
- 이 항목의 `w/` 브랜치가 있는데 일하던 세션이 없으면 이 세션에서 그 브랜치를 이어 간다(워크트리에 있으면 그리로, 아니면 `git switch`).
- "막 딴 워크트리" 판단에 워크트리 안인지 확인을 더했다. 기준 폴더의 커밋 없는 브랜치 이름을 바꾸지 않게.
- `create` 하위 세션은 기준 폴더의 기준 브랜치에서만 띄운다. 작업 브랜치·워크트리에서는 이 세션에서 한다.

미룸 없음. 리뷰용 개발 서버를 끄지 않는 것(🟡)은 사용자가 그대로 두기로 했다(포트는 항목마다 다르다).

### 디자인을 frontend 로 (사용자 결정, 2026-11-23)

- `design-reviewer`를 workflow 에서 frontend 로 옮겼다. `frontend-end-check`가 화면이 바뀌면 리뷰에 넣으라고 돌려주고, `end.md`의 따로 둔 줄은 지웠다. workflow 는 다시 스택과 무관하다.
- 지운 `/ui`의 system·mockup 절차를 frontend `ui-design` 스킬로 되살렸다(Claude 가 알아서 부를 수 있다). `/ui review`는 되살리지 않았다.
- 시안 기록은 저장소에 파일로 남기지 않고 계획과 항목에 적는다(`docs/design/`, `decisions.md` 없음). 캔버스가 원본이다.
- `frontend-start-check`: 새 화면·다시 디자인이면 "계획 전에 할 것"으로 시안, DESIGN.md 가 없으면 만들지 묻기(`- DESIGN.md: 안 씀`으로 끄기), 토큰을 바꾸면 DESIGN.md 갱신을 플랜에. `start.md` 2단계에 "계획 전에 할 것"을 더했다(플랜 모드에서는 캔버스를 만들 수 없어서).
- frontend 0.7.0.

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것.
