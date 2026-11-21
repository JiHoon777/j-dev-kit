---
id: '005'
title: 설정을 켜면 /task start 가 항목마다 워크트리를 따고 포트가 겹치지 않게
status: Done
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

- [x] #1 워크트리를 켜 둔 프로젝트에서 `/task start <번호>`를 하면 기준 브랜치에서 `.claude/worktrees/<항목 파일 이름>` 워크트리와 `w/<항목 파일 이름>` 브랜치가 생기고, 그 뒤 작업은 그 워크트리에서 한다.
- [x] #2 워크트리를 켜지 않은 프로젝트에서는 지금과 똑같이 동작한다.
- [x] #3 이미 워크트리 안(예: `/lead run`의 작업 세션)이면 새 워크트리를 만들지 않고 진행한다.
- [x] #4 워크트리 폴더가 기준 폴더의 커밋하지 않은 변경으로 잡히지 않는다(start·end·lead 의 확인에서 멈추지 않는다).
- [x] #5 두 항목을 동시에 시작해도 웹 포트(서버가 있으면 서버 포트도)가 서로 다르고 기준 폴더의 포트와도 다르다. 쓰는 포트가 항목 파일에 적혀 있고, 개발 서버를 띄우는 점검(frontend start/end-check, `/ui review`)이 그 포트를 쓴다.
- [x] #6 `/task end`가 끝나면 기준 브랜치에 머지되어 있고, 머지된 워크트리와 브랜치가 정리되어 있다.

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [x] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [x] #2 원문을 고친 곳은 번역본도 고쳤고, 고친 플러그인의 version·README 두 개·marketplace.json 설명을 맞췄다
- [x] #3 임시 저장소에서 워크트리를 켜고 두 항목을 동시에 시작해 워크트리·브랜치·포트가 갈리는 것을, 끈 상태에서 지금과 같은 것을 확인했다

<!-- DOD:END -->

## Implementation Plan

설정(CLAUDE.md `## 작업 설정`): `- 워크트리: 켜기`(기본 끄기), `- 웹 포트: <기준>`, `- 서버 포트: <기준>`(적은 것만 나눈다). 항목 포트 = 기준 포트 + 항목 번호. 포트는 워크트리 설정과 따로 동작한다(`/lead run` 작업 세션도 갈리게).

1. `task/SKILL.md` 2절 설정 목록에 워크트리·웹 포트·서버 포트.
2. `start.md` 4단계: 워크트리가 켜져 있고 워크트리 밖이면 `.claude/worktrees/`를 `.git/info/exclude`에 더하고 `git worktree add .claude/worktrees/<항목> -b w/<항목> <기준>`, `EnterWorktree`(path)로 옮긴다(도구가 없으면 그 폴더에서 이어 간다). 이미 워크트리 안이거나 꺼져 있으면 지금처럼. 포트 설정이 있으면 `Implementation Notes`의 `### 포트`에 적는다.
3. `end.md` 7단계: `.claude/worktrees/` 워크트리면 기준 폴더(`git worktree list` 첫 줄)에서 머지하고, 세션을 기준 폴더로 돌린 뒤 워크트리와 브랜치를 지운다.
4. `frontend-start-check`, `frontend-end-check`, `ui/references/review.md`: 항목의 `### 포트`가 있으면 그 포트로 개발 서버를 띄운다(포트 옵션이나 `PORT`). 서버도 띄우면 서버 포트.
5. 번역본, version(workflow 0.9.0, frontend 0.6.0, design 0.2.0), README 두 개, workflow 설명.

성공 기준: 임시 저장소에서 하위 에이전트로 켠 상태(001·002 시작 → 워크트리·브랜치·포트가 갈리고 기준 폴더 `git status` 깨끗, 001 end → 머지·정리), 끈 상태(브랜치만), 워크트리 안에서 시작(새로 안 만듦).

가정: `EnterWorktree`로 경로로 들어간 워크트리는 `ExitWorktree`가 지우지 않아 `git worktree remove`로 정리한다. `/lead run`이 작업 세션을 띄우는 곳은 바꾸지 않는다.

## Implementation Notes

### Baseline

`claude plugin validate . && bash scripts/check-repo-rules.sh` 통과(2026-11-21). 스택 점검(`-start-check`) 스킬은 이 세션에 없어 해당 없음.

### 구현

- 설정: `- 워크트리: 켜기`, `- 웹 포트`, `- 서버 포트`(task/SKILL.md 2절). workflow 0.9.0, frontend 0.6.0, design 0.2.0.
- start 4단계: 워크트리 밖 판단은 `git rev-parse --path-format=absolute --git-dir --git-common-dir`. `.git/info/exclude`에 `.claude/worktrees/`, `git worktree add`, `EnterWorktree`(없거나 거부하면 그 폴더에서), 의존성 설치. 포트는 `기준 + 번호`, 쓰이는 포트(lsof)와 다른 워크트리 항목에 적힌 포트는 1씩 올려 피한다. 명령은 저장소 루트에서.
- start 1단계: 워크트리가 켜져 있으면 다른 항목의 `w/` 브랜치는 확인에서 빼고, 이 항목의 브랜치가 워크트리에 있으면 그리로 옮겨 이어 간다.
- end 7단계: 이 줄이 finishing 스킬의 머지·정리 단계보다 우선. 기준 폴더에서 머지하고 기준 폴더로 돌아와 워크트리·브랜치를 지운다.
- 개발 서버 세 곳: 항목 포트가 launch.json 보다 먼저, 스크립트가 포트를 받는 방식을 확인하고 듣는지 확인.
- 마크다운 절차라 자동 테스트는 없다. 임시 저장소에서 하위 에이전트로 확인했다.

### 시나리오 확인

1회차(켠 저장소 `on`, 끈 저장소 `off`):
- A 기준 폴더에서 001: 워크트리 `.claude/worktrees/001-…`, 브랜치 `w/001-…`, 포트 5174/3001, 기준 폴더 status 깨끗. (AC #1, #4)
- B 001 진행 중 002: 확인에서 막히지 않고 두 번째 워크트리, 포트 5175/3002. (AC #5)
- C lead 식 워크트리(detached) 안에서 003: 새 워크트리 없이 `git switch -c`. (AC #3)
- D 끈 저장소: 같은 폴더에서 `git switch -c`, 포트 절 없음. (AC #2)
- E 001 머지: 기준 폴더에서 fast-forward.
- 나온 결함: 하위 폴더에서 워크트리 밖 판단이 틀림(직접 재현), 진행 중 항목을 다시 고르면 `git switch` 실패, 새 워크트리에 의존성 없음, finishing 스킬과 정리 규칙 충돌, 세션 종류별 정리 빠짐 → 012b14b 에서 고침.
- 사용자 요청: 프로젝트마다 기준 포트를 다르게 → 쓰이는 포트 피하기, README 에 1000씩 띄우는 안내.

2회차(새 저장소 `on2`, 5001 을 일부러 점유):
- F 하위 폴더 `docs/`에서 001: 워크트리 밖으로 맞게 판단, 웹 5001 을 피해 5002, 서버 6001.
- G 기준 폴더에서 001 다시: 브랜치를 바꾸지 않고 그 워크트리로 옮겨 이어 감.
- H 001 끝: 기준 폴더에서 머지, 워크트리·브랜치 지움, 기준 폴더 status 깨끗. (AC #6)
- 나온 것: 명령을 어디서 돌릴지, 다른 워크트리에 적힌 포트 → a493aa3·번역본 커밋에서 고침.

3회차(개발 서버): 항목 `### 포트`가 5007 인 저장소에서 frontend-start-check 의 줄대로 띄움 → 5007 에서 200. 예시만 따르면 위치 인자를 받는 스크립트에서 틀린다는 지적 → 스크립트에서 받는 방식을 확인하고 듣는지 확인, launch.json 보다 항목 포트가 먼저(83534ae). (AC #5)

### 남은 것

- 진행 중 항목이 기준 폴더에서는 `status: To Do`로 보인다(start 커밋이 `w/` 브랜치에만 있다). 워크트리 전부터 있던 동작이라 이번에 바꾸지 않았다.
- 이어 갈 때 의존성과 포트를 다시 확인하지 않는다.
- `git worktree remove` 뒤 빈 `.claude/worktrees/` 폴더가 남는다(exclude 로 보이지 않는다).

### 리뷰

- security-review: 확인된 문제 없음.
- code-review 10건, 모두 고침(700dd85). 사용자가 "머지·푸시까지"를 요청해 🟡도 묻지 않고 같이 고쳤다.
  - end: 머지 전에 기준 폴더가 기준 브랜치이고 깨끗한지 확인. 정리는 로컬 머지일 때만(PR·그대로 두기면 워크트리를 남김).
  - start: exclude 경로를 `git rev-parse --git-path info/exclude`로. 대체 경로(세션이 기준 폴더에 남음)면 Stop 훅이 돌지 않으니 검증을 워크트리에서. 검사 도구가 `.claude/worktrees/`를 읽으면 알림(README 에도). lsof 가 없으면 `nc -z`, 확인할 수 없으면 알림. 진행 중 항목의 포트와 그 항목들의 기본 포트도 피함, `docs/done`은 보지 않음. 포트를 정하자마자 항목에 적음.
  - 개발 서버 세 곳: launch.json 은 고치지 않고 다르면 개발 명령을 직접. 웹이 백엔드 주소를 받는 곳도 서버 포트로(파일을 고치지 않고).
- 리뷰 반영 뒤 시나리오는 다시 돌리지 않았다. 바뀐 것은 문장과 확인 단계다.

## Final Summary

- 바뀐 것: CLAUDE.md `## 작업 설정`의 `- 워크트리: 켜기`, `- 웹 포트`, `- 서버 포트`. 켜면 `/task start`가 `.claude/worktrees/<항목>` 워크트리와 `w/<항목>` 브랜치를 따 옮겨 일하고, `/task end`가 기준 폴더에서 머지하고 정리한다. 포트는 `기준 + 번호`에 쓰이는 포트·다른 항목 포트를 피해 항목에 적고, 개발 서버를 띄우는 세 곳이 그 포트를 쓴다. workflow 0.9.0, frontend 0.6.0, design 0.2.0.
- 리뷰에서 고친 것: 위 "리뷰" 10건, 시나리오 시험에서 나온 결함 7건.
- 미룬 것: 진행 중 항목이 기준 폴더에서 `To Do`로 보이는 것, 이어 갈 때 의존성·포트 재확인, 빈 `.claude/worktrees/` 폴더. 새 항목은 만들지 않았다.
