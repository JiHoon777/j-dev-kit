---
id: '008'
title: 역할 대신 전문가의 도구·단계로, 판정은 만든 세션 밖에서 (Felix Rieseberg 대담 1~7)
status: To Do
labels: [feat]
priority: medium
dependencies: []
created_date: 2026-11-23
updated_date: 2026-11-23
---

## Description

Felix Rieseberg 대담(영상 youtu.be/D-SVFneJ_Nk, 정리 글 maily.so/josh/posts/8mo5m6gkz9p)과 j-dev-kit 을 대조한 보고서 `.claude/.local/reports/2026-11-23-felix-rieseberg-대담-비교.md`(커밋하지 않음)의 개선 후보 1~6과, 보고서가 제안하지 않았던 컨베이어 벨트를 바꾼 7을 한 항목으로 한다. 사용자가 나누지 않기로 정했다. 대담의 타임스탬프 근거는 보고서에 있다.

1. **전문가의 도구와 단계(가장 중요):** "넌 뛰어난 X야"라는 역할 문장은 어휘만 따라 하게 한다. 대신 그 분야 최고 실무자가 쓰는 도구와 밟는 단계를 묻고 그대로 쓰게 한다(8:52, 25:28). 지금 `start.md` 3단계에는 이 단계가 없고 도구는 스택 점검에 고정돼 있다. 리뷰 에이전트 5개는 "너는 X 리뷰어다/평가자다"로 시작한다. `server-end-check`의 "새로 내려받지 않는다"와 `api-reviewer`의 curl 재현을 "돌리지는 않는다"는 모델이 소프트웨어를 설치하고 직접 돌리는 방식(22:24)과 반대다. `supabase-reviewer`의 "테스트 사용자 둘로 로컬 DB 에 확인"은 이미 이 방식이다.
2. **지적 판정을 만든 세션 밖으로:** `end.md` 4단계에서 작업 세션이 틀린 지적을 직접 뺀다. 지금 세션이 자기 일을 판정하지 않게(14:55, 26:24) 판정을 따로 하고, 만든 쪽이 가려 반영하는 5단계(`receiving-code-review`)는 그대로 둔다.
3. **사용자 피드백을 원칙으로:** Final Summary 에 "그대로 둔 지적과 이유"가 없어 피드백이 쌓이지 않는다. 모으고, 원칙으로 압축하고, 이후 리뷰의 입력으로 쓴다(28:45). 예: 006 에서 "리뷰용 개발 서버를 끄지 않는다(포트는 항목마다 다르다)"를 그대로 두기로 한 것.
4. **UI 가 아닌 AC 판정:** `start.md` 6단계 4에서 구현 세션이 AC 를 스스로 체크한다. 바깥에서 판정하는 건 UI 의 `frontend-evaluator`뿐이다. `docs/backlog/_proposals.md`의 홀드아웃 아이디어와 같은 문제다.
5. **eval 로 덜어내기:** 고정 체크리스트(`frontend-reviewer`의 Svelte·React 항목, `start.md`의 Explore 최대 2개·질문 최대 3개 등)가 지금 모델에 도움이 되는지 잰 적이 없다(21:49). 있을 때와 없을 때를 비교하고 근거 있는 것만 지운다.
6. **리뷰 모델 한 단계 낮추기:** 적대적 검토는 한 단계 낮은 모델로도 된다(13:47). 비용을 줄인다.
7. **컨베이어 벨트 대신 서베이:** 크래시를 하나씩 골라 Claude 앞에 놓지 말고, 데이터 전부와 목표를 넘기고 무엇을 고칠지는 Claude 가 정하게 한다. 확인 수단도 함께 준다(22:49). 보고서에서는 "제안하지 않는 것"이었는데, 사용자가 `task create`에 서베이 인자를 넣는 모양으로 넣기로 했다. 지운 `/lead`(여러 항목 지휘)를 되살리는 게 아니라 `create`의 한 모드다. 인자가 없으면 지금처럼 항목 하나를 쓴다.

가정: 판정 방법(에이전트, 다른 세션 등), 원칙을 둘 파일, eval 방식과 eval 을 저장소에 남길지, 모델을 정하는 위치는 `/task start` 계획에서 정한다.

이번에 빼는 것: 서베이로 만든 항목을 이어서 시작하거나 여러 항목을 차례로 돌리는 것(`/lead run`). 운영 DB·원격 Supabase 에 닿는 명령을 막는 규칙은 바꾸지 않는다.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 `start.md` 3단계에 "이 항목의 일을 그 분야 최고 실무자는 어떤 도구와 단계로 하나"를 정하는 단계가 있고, 계획(`ExitPlanMode`)에 넣을 것에 그 도구·단계가 들어가며, 5단계 구현이 그것을 따른다고 적혀 있다
- [ ] #2 리뷰 에이전트 5개(`design-reviewer`, `frontend-evaluator`, `frontend-reviewer`, `api-reviewer`, `supabase-reviewer`)가 역할 문장으로 시작하지 않고, 그 분야 최고 실무자가 쓰는 도구와 단계를 말한다(`grep -n '^너는' plugins/*/agents/*.md`와 `grep -n '^You are' i18n/en/plugins/*/agents/*.md`가 비어 있다)
- [ ] #3 `server-end-check`에 "새로 내려받지 않는다"가 없고 필요한 검사 도구를 설치해 쓸 수 있으며, `api-reviewer`에 "돌리지는 않는다"가 없고 로컬·개발 환경에서는 재현 요청을 직접 돌려 그 결과를 근거로 쓴다(운영·원격 금지는 그대로)
- [ ] #4 `end.md` 4단계에서 지적이 타당한지는 작업 세션이 아닌 쪽이 판정하고, 사용자에게는 타당하다고 판정된 지적만 보인다. 5단계의 `receiving-code-review`는 그대로다
- [ ] #5 Final Summary 형식(`end.md` 6단계, `create.md` 템플릿, `docs/backlog/_template.md`)에 "그대로 둔 지적과 이유"가 있다
- [ ] #6 그대로 둔 지적을 원칙으로 모아 두는 곳이 정해져 있고, `end.md` 3단계 리뷰 지시문이 그 원칙을 입력으로 넣는다. 이 저장소의 그곳에 006 의 포트 지적이 원칙 하나로 적혀 있다
- [ ] #7 `start.md` 6단계에서 UI 가 아닌 AC 도 구현 세션이 스스로 판정해 체크하지 않는다. 바깥 증거(명령 출력 등)나 구현 세션이 아닌 판정자가 확인한 것만 체크한다고 적혀 있다
- [ ] #8 고정 체크리스트(`frontend-reviewer`의 Svelte·React 항목, `start.md`의 Explore 최대 2개·질문 최대 3개, 그 밖에 계획에서 고른 것)마다 있을 때와 없을 때를 비교한 방법과 결과가 `Implementation Notes`에 있고, 지운 것은 비교에서 없어도 나빠지지 않은 것뿐이다
- [ ] #9 `/task end` 3단계의 리뷰 에이전트가 작업 세션보다 한 단계 낮은 모델로 돌고, 그 모델을 정하는 곳이 `end.md`나 에이전트 frontmatter 에 보인다
- [ ] #10 `task` 스킬의 `argument-hint`와 `create.md`에 서베이 형식 `create --survey <목표> [자료…]`가 있다. 자료는 파일·폴더 경로, 명령, URL 이고, 주지 않으면 Claude 가 저장소에서 찾는다(오류 로그, 기존 백로그와 제안함, 사용 데이터 등). `--survey`가 없으면 지금처럼 항목 하나를 쓴다
- [ ] #11 서베이 모드에서는 Claude 가 날것의 자료를 직접 읽고 목표에 맞는 항목 후보를 스스로 고른다. 사용자에게는 후보마다 제목, 고른 근거(자료의 위치), 됐는지 확인할 수단을 한 목록으로 한 번에 보여 준다. 개수는 정해 두지 않고 근거가 있는 것만 올린다
- [ ] #12 사용자가 목록에서 고른 후보만 2단계 규칙대로 항목으로 쓰고 항목마다 따로 커밋한다(`docs(backlog): <번호> <제목>`). 각 항목의 AC 에는 그 확인 수단이 들어간다. 고르지 않은 후보는 쓰지 않는다
- [ ] #13 서베이 모드는 항목을 만들기만 하고 `start`를 부르거나 세션을 띄우지 않는다. `/lead`를 쓰라는 안내가 저장소에 다시 생기지 않았다

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
