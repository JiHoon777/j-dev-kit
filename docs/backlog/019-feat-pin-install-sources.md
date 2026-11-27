---
id: '019'
title: kit-setup 이 받는 스킬과 플러그인의 출처를 고정하거나 받은 판을 기록한다
status: To Do
labels: [feat]
priority: medium
dependencies: []
created_date: 2026-11-27
updated_date: 2026-11-27
---

## Description

`/kit-setup` 4단계는 프로젝트의 스택을 보고 공식 스킬과 플러그인을 묻지 않고 설치한다(`plugins/workflow/skills/kit-setup/SKILL.md`). 그런데 받는 내용이 고정돼 있지 않다.

- `claude plugin marketplace add <owner/repo>`는 그 저장소 기본 브랜치의 머리를 따른다. `--help`에 판을 고정하는 옵션이 없다.
- `npx -y skills@1.7.5 add <저장소>`는 CLI 의 버전만 고정한다. 스킬의 내용은 그 저장소의 머리에서 받는다.

스킬과 플러그인은 에이전트가 읽고 따르는 지시문이다. 위쪽 저장소가 바뀌면 새 지시가 묻지 않고 들어온다. 012 의 Final Summary 가 이미 기존 문제로 적었고, 묻지 않고 설치하게 되면서(2026-11-27) 무게가 커졌다. 2026-11-27 리뷰의 판정이 사람이 정할 것과 나중 후보로 표시했다(`.claude/.local/review-2026-11-27/0-판정.md` 40번. 이 파일은 커밋하지 않는다).

이번에 빼는 것: 받은 스킬의 내용을 검사하는 일, Supabase MCP 의 범위를 좁히는 일.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 `/kit-setup`이 받는 출처마다, 판을 고정할 수 있는 것은 고정한 판(커밋이나 버전)으로 받는다. 무엇이 고정할 수 있고 무엇이 없는지 실제 명령으로 확인해 `Implementation Notes`에 적는다
- [ ] #2 판을 고정할 수 없는 출처는 받은 뒤에 실제로 받은 판(저장소의 커밋이나 플러그인 버전)을 알림과 커밋 메시지에 적는다
- [ ] #3 `npx skills add`가 실제로 어디에 쓰는지(`.claude/skills/`, 그 밖의 폴더, 잠금 파일)와 비대화형에서 멈추지 않는지를 확인해, `kit-setup`의 커밋 규칙과 명령이 그것과 맞는다
- [ ] #4 `/kit-setup`을 실제 프로젝트(프런트엔드 하나, Supabase 를 쓰는 것 하나)에서 돌려 표의 명령이 도는 것을 확인하고 출력을 `Implementation Notes`에 남긴다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 번역본(`i18n/en/`)을 원문과 같이 고쳤다
- [ ] #3 `plugin.json` `version`을 올리고 README 두 개와 `marketplace.json` 설명을 맞췄다

<!-- DOD:END -->

## Implementation Plan

만들 때는 비워 둔다. `/start`가 계획을 적는다.

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

## Final Summary

`/start`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것, 그대로 둔 지적과 이유, 사용자가 바로잡은 것.
