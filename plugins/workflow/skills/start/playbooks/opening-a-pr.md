# Opening a PR

> 원문: `cursor/plugins`의 `pstack/skills/poteto-mode/playbooks/opening-a-pr.md` (MIT, Lauren Tan). Cursor 이름을 Claude Code 것으로 바꿨다. 원문은 모든 플레이북의 끝에서 부른다. 여기서는 `start` 절차 12단계가 PR 로 머지할 때 부른다. 그래서 원문과 다른 점이 셋 있다. 원문의 "rebase 로 정리한다"와 "커밋 전 deslop"은 뺐다. 그 일은 절차 5·6단계가 하고, 12단계에서는 검증과 리뷰를 마친 트리를 바꾸지 않는다. 뒤따르는 PR 을 앞 PR 의 브랜치에 쌓는 문장은 뺐다. `start`는 늘 기준 브랜치에서 브랜치를 따고 기준 브랜치를 대상으로 PR 을 연다. 실행에 딸린 PR 도구와 Origin CLI 갈래는 뺐다.

**언제:** 머지 방식이 PR 일 때. `merge` 설정이 `pr`이거나 사용자가 마지막 메시지에서 PR 을 골랐을 때다. 프로젝트 CLAUDE.md 에 PR 규칙이 있으면 그것이 먼저다.

기준 브랜치에서 딴 작업 브랜치(워크트리)에서 일하고, 상관없는 일을 섞지 않는다. 커밋은 일하는 동안 작고 하나씩 머지할 수 있는 단위로 쌓는다(절차 5단계). PR 을 열 때는 커밋을 다시 쓰거나 코드를 다시 정리하지 않는다. 검증과 리뷰를 마친 트리가 그대로 PR 로 나간다.

제목: `type(scope): subject`. 변경을 실어 나르는 실제 심볼이 있으면 그 이름을 쓴다. 본문: 1분 안에 읽는 브리핑이고 40줄을 넘지 않는다. `##` 제목을 이 순서로 쓰고 빈 것은 뺀다: `## Why`, `## What changed`, `## Scope`, `## Tradeoffs`(리뷰어가 물을 만한, 버린 대안만), `## Blast Radius`, `## Verification`. `## Why`는 목표로 연다.

PR 은 기준 브랜치를 대상으로, 초안이 아니라 리뷰할 수 있는 상태로 연다: `gh pr create`를 `--draft` 없이 쓴다. PR 을 열었다고 그 PR 을 지켜보는 일(CI, 리뷰 대응)을 시작하지는 않는다.
