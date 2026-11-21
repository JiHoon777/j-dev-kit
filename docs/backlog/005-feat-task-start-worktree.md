---
id: '005'
title: 설정을 켜면 /task start 가 항목마다 워크트리를 따고 포트가 겹치지 않게
status: To Do
labels: [feat]
priority: medium
dependencies: []
created_date: 2026-11-21
updated_date: 2026-11-21
---

## Description

지금 `/task start`는 현재 폴더에서 브랜치만 바꾼다(`git switch -c w/<항목>`). 한 폴더에서 한 항목만 할 수 있고, 여러 항목을 같이 돌리면 개발 서버가 같은 포트를 잡아 부딪친다.

프로젝트 CLAUDE.md 의 `## 작업 설정`에 워크트리를 켜 두었을 때만:

- `/task start`가 기준 브랜치에서 항목 이름의 워크트리(`.claude/worktrees/<항목 파일 이름>`)와 브랜치(`w/<항목 파일 이름>`)를 따고, 세션을 그 워크트리로 옮겨 작업한다.
- 웹 포트와, 서버가 있으면 서버 포트를 항목마다 규칙(예: 기준 포트 + 항목 번호)으로 정해 겹치지 않게 하고 항목에 적는다. 기준 포트도 `## 작업 설정`에 적는다.
- `/task end`는 그 워크트리에서 리뷰하고 기준 브랜치에 머지한 뒤 워크트리를 정리한다.

켜지 않으면 지금과 같다.

알아 둘 것: Claude Code 의 `EnterWorktree`는 `.claude/worktrees/` 아래 워크트리로 세션을 옮긴다(경로로 이미 있는 워크트리에도 들어간다). `/lead run`의 작업 세션은 이미 자기 워크트리에서 돈다.

이번에 빼는 것: Supabase·데이터베이스 등 웹·서버 밖의 포트와 데이터 나누기.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 워크트리를 켜 둔 프로젝트에서 `/task start <번호>`를 하면 기준 브랜치에서 `.claude/worktrees/<항목 파일 이름>` 워크트리와 `w/<항목 파일 이름>` 브랜치가 생기고, 그 뒤 작업은 그 워크트리에서 한다.
- [ ] #2 워크트리를 켜지 않은 프로젝트에서는 지금과 똑같이 동작한다.
- [ ] #3 이미 워크트리 안(예: `/lead run`의 작업 세션)이면 새 워크트리를 만들지 않고 진행한다.
- [ ] #4 워크트리 폴더가 기준 폴더의 커밋하지 않은 변경으로 잡히지 않는다(start·end·lead 의 확인에서 멈추지 않는다).
- [ ] #5 두 항목을 동시에 시작해도 웹 포트(서버가 있으면 서버 포트도)가 서로 다르고 기준 폴더의 포트와도 다르다. 쓰는 포트가 항목 파일에 적혀 있고, 개발 서버를 띄우는 점검(frontend start/end-check, `/ui review`)이 그 포트를 쓴다.
- [ ] #6 `/task end`가 끝나면 기준 브랜치에 머지되어 있고, 머지된 워크트리와 브랜치가 정리되어 있다.

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 원문을 고친 곳은 번역본도 고쳤고, 고친 플러그인의 version·README 두 개·marketplace.json 설명을 맞췄다
- [ ] #3 임시 저장소에서 워크트리를 켜고 두 항목을 동시에 시작해 워크트리·브랜치·포트가 갈리는 것을, 끈 상태에서 지금과 같은 것을 확인했다

<!-- DOD:END -->

## Implementation Plan

만들 때는 비워 둔다. `/task start`가 승인된 계획을 적는다.

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것.
