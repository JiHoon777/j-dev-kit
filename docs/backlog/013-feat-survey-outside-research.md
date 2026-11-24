---
id: '013'
title: 서베이 모드가 바깥을 기본으로 조사하고 보고서를 남긴다
status: To Do
labels: [feat]
priority: high
dependencies: []
created_date: 2026-11-25
updated_date: 2026-11-25
---

## Description

`/task create --survey`(`plugins/workflow/skills/task/references/create.md` 서베이 절)는 자료를 주지 않으면 저장소 안(오류 로그, 백로그, `gh issue list`, 사용 데이터)만 읽고, 바깥 자료는 사용자가 URL 을 줄 때만 본다. 후보는 한 세션이 한 번에 고르고, 후보 목록은 대화에만 남는다. 사용자는 "내부 자료만 보고 하는 게 별로고, URL 을 줄 순 있지만 기본적으로 알아서 검색해서 해야지"라고 했다.

바깥 실무자(Anthropic Research, Hamel Husain·Shreya Shankar 오류 분석, Teresa Torres, Claude Code `/dedupe`, GitHub Agentic Workflows, AI Goalie)를 조사한 결과, 공통으로 하는 것은 목표를 조사 질문으로 쪼개기, 바깥을 기본으로 찾기(1차 출처 우선), 각도별 병렬 수집, 자료별 메모 → 범주 → 세기 → 포화에서 멈추기, 다른 쪽이 거짓 양성 거르기, 조사 결과물을 남기기다. 서베이 모드가 이것을 하게 한다.

근거: `docs/backlog/references/2026-11-25-서베이-모드-전문가-조사.md`

가정:
- 바깥 조사는 기본으로 켠다. 빼는 것은 사용자가 그렇게 말할 때만이다(플래그 이름은 계획에서 정한다).
- 조사 질문과 각도는 보여 주기만 하고 승인을 기다리지 않는다.

이번에 빼는 것: 정기 실행, 서베이 결과로 `start`·세션 띄우기(008 에서 뺀 범위 그대로), 후보 수 상한, 점수 공식.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 `create.md` 서베이 절에, 자료를 주지 않아도 안쪽(저장소)과 바깥(쓰는 도구의 공식 문서·변경 기록·이슈, 같은 일을 하는 도구와 선례, 그 분야 실무자의 글)을 모두 찾는다고 적혀 있다. 사용자가 준 자료·URL 은 출발점이고 범위를 좁히지 않으며, 바깥을 빼는 것은 사용자가 그렇게 말할 때만이다
- [ ] #2 수집 전에 목표를 결과 한 문장과 조사 질문으로 쪼개고 질문마다 각도(안쪽·바깥)를 정해 사용자에게 보이며, 승인을 기다리지 않고 진행한다고 적혀 있다
- [ ] #3 각도마다 하위 에이전트가 병렬로 수집하고, 그 지시문에 목표·출력 형식·쓸 출처·경계가 들어가며, 원문 메모(짧은 인용, 위치·URL, 읽은 날짜, 직접 읽었는지 검색 요약만 봤는지)를 파일로 남긴다고 적혀 있다. 후보의 근거로 쓰는 주장은 메인 세션이 원문을 다시 열어 확인한다고 적혀 있다
- [ ] #4 후보 고르기가 자료별 메모 → 범주로 묶기 → 범주마다 근거 수 세기 순서이고, 새 자료가 범주를 더하지 않으면 수집을 멈춘다고 적혀 있다. 후보는 문제·필요로 적고 크기(근거 수)와 목표에 닿는 정도를 붙인다. 같은 원인 묶기와 버그 재현 규칙은 그대로 있다
- [ ] #5 후보를 사용자에게 보이기 전에 메인 세션이 아닌 판정 에이전트가 후보마다 근거가 주장을 받치는지, 이미 있는 항목·이미 고쳐진 것과 겹치는지, 출처가 1차인지를 보고, 떨어진 후보는 이유와 함께 "제안하지 않는 것"에 남는다고 적혀 있다
- [ ] #6 서베이가 보고서 파일(확인 날짜, 결론 요약, 후보 표, 제안하지 않는 것과 이유, 읽지 못한 것)을 쓰고, 고른 후보가 있으면 `docs/backlog/references/`에 두어 첫 항목 커밋에 넣고 각 항목이 그 경로를 적으며, 고른 것이 없으면 `.claude/.local/reports/`에 둔다고 적혀 있다
- [ ] #7 URL 없이 목표만 준 서베이 사례의 동작 eval 이 `plugins/workflow/evals/`에 커밋돼 있다. 바깥 검색을 했는지, 보고서에 출처와 직접·검색 표시가 있는지, 이미 있는 항목과 겹치는 후보를 걸렀는지를 본다. 지금 판과 고친 판의 점수·비용 비교와 다시 돌리는 명령이 `Implementation Notes`에 있고, 고친 판이 낮으면 사용자에게 물어 정한 것이 적혀 있다
- [ ] #8 서베이 모드는 여전히 항목을 만들기만 하고 `start`를 부르거나 세션을 띄우지 않으며, 후보 수 상한이 없다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 번역본(`i18n/en/plugins/workflow/skills/task/references/create.md`, 필요하면 `SKILL.md`)을 같이 고쳤다
- [ ] #3 workflow `plugin.json` `version`을 올리고 README 두 개와 `marketplace.json` 설명을 맞췄다

<!-- DOD:END -->

## Implementation Plan

만들 때는 비워 둔다. `/task start`가 승인된 계획을 적는다.

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것, 그대로 둔 지적과 이유, 사용자가 바로잡은 것.
