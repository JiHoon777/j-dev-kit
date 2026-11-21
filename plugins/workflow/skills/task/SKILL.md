---
name: task
description: 백로그 기반 작업 루프. create 는 백로그 항목 하나를 쓰고, start 는 항목을 계획해 작업 브랜치에서 구현하고, end 는 브랜치를 리뷰하고 고칠 것을 고친 뒤 승인을 받아 머지한다. 켜 둔 스택 플러그인의 start-check, end-check 스킬을 부른다. 사용자가 직접 부를 때만 돈다.
argument-hint: "create <한두 문장> | start [백로그 번호나 이름 일부] | end"
disable-model-invocation: true
allowed-tools: Bash(git status *), Bash(git branch --show-current), Bash(git branch --list *), Bash(git log *), Bash(git diff *), Bash(ls *)
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# task

인자: `$ARGUMENTS`

## 1. 모드 고르기

인자의 첫 단어로 모드를 고르고, 나머지는 모드에 넘긴다.

| 첫 단어 | 모드 | 절차 파일 |
| --- | --- | --- |
| `create` | 백로그 항목 하나 쓰기 | `${CLAUDE_SKILL_DIR}/references/create.md` |
| `start` | 항목 하나 계획하고 구현하기 | `${CLAUDE_SKILL_DIR}/references/start.md` |
| `end` | 리뷰, 수정, 마무리, 머지 | `${CLAUDE_SKILL_DIR}/references/end.md` |

- 첫 단어가 셋 중 어느 것도 아니면 이 표를 보여 주고 묻는다.
- 고른 모드의 절차 파일 하나만 Read 도구로 끝까지 읽고 그대로 따른다.

## 2. 프로젝트 설정

프로젝트 CLAUDE.md 에서 읽는다. 없으면 괄호 안의 기본값을 쓰고, 검증 명령이 없으면 묻는다.

- 기준 브랜치 (`main`)
- 검증 명령 (예: `pnpm verify` — 린트, 타입, 테스트, 빌드)
- 항목·보고에 쓸 언어 (대화의 언어)
- 워크트리 (끄기): `켜기`면 `/task start`가 항목마다 `.claude/worktrees/` 아래 워크트리를 딴다
- 웹 포트, 서버 포트 (없음): 적은 것만 항목마다 `기준 포트 + 항목 번호`로 나눈다

프로젝트 CLAUDE.md 의 규칙이 이 스킬과 superpowers 보다 우선한다.

## 3. 일하는 원칙

- 모르는 것은 가정하지 말고 말한다. 코드와 문서로 답할 수 있는 것은 묻지 않는다.
- 항목이 요구하는 것만 한다. 바뀐 줄은 모두 항목으로 거슬러 올라갈 수 있어야 한다.
- "됐다"고 하기 전에 검증을 새로 돌리고 그 결과를 보여 준다.

## 4. 현재 상태

- 브랜치: !`git branch --show-current 2>/dev/null || echo "(unknown)"`
- 작업 브랜치: !`git branch --list 'w/*' 2>/dev/null || echo "(none)"`
- 커밋하지 않은 변경: !`git status --short 2>/dev/null | head -20`
- 최근 커밋: !`git log --oneline -3 2>/dev/null || echo "(no commits)"`
- 백로그: !`ls docs/backlog 2>/dev/null || echo "(none)"`
- 완료: !`ls docs/done 2>/dev/null || echo "(none)"`
- 이 브랜치의 커밋(`main` 대비): !`git log --oneline main..HEAD 2>/dev/null | head -30`
- `main` 대비 바뀐 파일: !`git diff --stat main...HEAD 2>/dev/null | tail -30`
