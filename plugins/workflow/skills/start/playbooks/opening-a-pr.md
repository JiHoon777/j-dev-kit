# Opening a PR

> 원문: `cursor/plugins`의 `pstack/skills/poteto-mode/playbooks/opening-a-pr.md` (MIT, Lauren Tan). Cursor 이름을 Claude Code 것으로 바꿨다. 원문은 모든 플레이북의 끝에서 부른다. 여기서는 `start` 절차 12단계가 PR 로 머지할 때 부른다. 원문의 "rebase 로 정리한다"는 아직 푸시하지 않은 커밋에만 쓴다. 절차가 강제 푸시를 막기 때문이다.

**언제:** 머지 방식이 PR 일 때. `merge` 설정이 `pr`이거나 사용자가 마지막 메시지에서 PR 을 골랐을 때다. 프로젝트 CLAUDE.md 에 PR 규칙이 있으면 그것이 먼저다.

기준 브랜치에서 딴 작업 브랜치(워크트리)에서 일하고, 상관없는 일을 섞지 않는다. 아직 푸시하지 않은 커밋은 작고 하나씩 머지할 수 있는 단위로 정리한다(rebase). 푸시한 커밋은 다시 쓰지 않는다. 커밋 전에 diff 에 `deslop` 스킬을 따른다.

제목: `type(scope): subject`. 변경을 실어 나르는 실제 심볼이 있으면 그 이름을 쓴다. 본문: 1분 안에 읽는 브리핑이고 40줄을 넘지 않는다. `##` 제목을 이 순서로 쓰고 빈 것은 뺀다: `## Why`, `## What changed`, `## Scope`, `## Tradeoffs`(리뷰어가 물을 만한, 버린 대안만), `## Blast Radius`, `## Verification`.

뒤따르는 PR 은 앞 PR 의 브랜치를 base 로 잡아 쌓는다. PR 은 초안이 아니라 리뷰할 수 있는 상태로 연다: `gh pr create`를 `--draft` 없이 쓴다. PR 을 열었다고 그 PR 을 지켜보는 일(CI, 리뷰 대응)을 시작하지는 않는다.
