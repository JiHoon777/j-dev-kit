# 인수인계: 008 전문가의 도구·단계, 만든 세션 밖 판정

작성: 2026-11-23 · 브랜치: `w/008-feat-expert-steps-outside-judge` (origin 에 푸시함) · 항목: [008](008-feat-expert-steps-outside-judge.md)

## 상태

- `task start` 는 끝났다. AC #1–#21, DoD #1–#3 모두 체크했고, 판정 에이전트가 AC 를 판정했다(#21 실패 → 고치고 체크).
- 검증 명령(`claude plugin validate . && bash scripts/check-repo-rules.sh`) 통과, `test-check-repo-rules.sh` 30/30, `test-verify-on-stop.sh` 11/11.
- `task end` 는 아직 돌리지 않았다. 리뷰, 판정, 수정, 항목 닫기, 머지가 남았다.

## 이어서 할 것

1. 집에서 저장소를 받는다: `git fetch origin && git switch w/008-feat-expert-steps-outside-judge`
2. 그 브랜치에서 `/task end` 를 부른다. 이 세션이 Opus 면 리뷰 에이전트에 `model` 을 주지 않는다(Fable 이면 `opus`).
3. 4단계에서 판정된 지적을 보고 고칠 것을 정한다. 7단계에서 머지 방식을 고른다.
4. 항목을 닫을 때 이 문서(`docs/backlog/_handoff-008.md`)를 지운다.
5. 그다음 009, 010 을 시작할 예정이다.

## 바뀐 것 (요약)

- `workflow` (task 스킬): 계획에 "도구와 단계(설치할 것 포함)", AC 는 바깥 증거나 구현하지 않은 판정 에이전트로만 체크(start 6.4), end 에 판정 에이전트(4단계)와 리뷰 모델 규칙, Final Summary 에 그대로 둔 지적·사용자가 바로잡은 것, `docs/review-principles.md`, `create --survey`, 하위 세션 지휘. SKILL.md 의 셸 주입 줄(`!` 줄)을 지웠다.
- `frontend`, `server` 리뷰어·평가 에이전트: 역할 문장을 빼고 도구와 단계로. 확인한 것과 확인 못 한 것을 나눠 모두 보고. `server-end-check` 는 설치 도구 버전 고정.
- `scripts/check-repo-rules.sh`: eval 사례는 번역본 검사에서 빼고, 스킬 마크다운의 셸 주입 줄을 실패로(규칙 5).
- eval 사례: `plugins/frontend/evals/`, `plugins/workflow/evals/` (README 에 돌리는 법).

## 이 컴퓨터에만 있는 것

- `.claude/.local/evals/008/`: eval 결과 JSON, 라벨, 재채점 결과. 커밋하지 않았다. 결과 요약은 항목 Notes 에 있다.
- 실제 사례 eval(`real-*`, `start-plan-real`, `trigger-real`)의 scaffold 는 이 컴퓨터의 nolmeong 로컬 저장소에서 코드를 꺼낸다. 다른 컴퓨터에서는 그 사례가 돌지 않는다. nolmeong 은 읽기만 한다(`git archive`·`git show`).

## 지킬 것

- 운영 DB·원격 Supabase 명령을 막는 규칙은 바꾸지 않는다.
- 푸시는 사용자가 요청할 때만. 조사 보고서·노트는 `.claude/.local/`.
- 채점 규칙(사용자 결정): 사용자에게 미치는 영향을 말하고 문제라고 단정해야 찾은 것. 원인만, "확인 필요"만이면 못 찾은 것.
