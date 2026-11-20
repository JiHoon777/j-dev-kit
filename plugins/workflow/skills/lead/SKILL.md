---
name: lead
description: 백로그 항목 여러 개를 한 세션에서 지휘할 때 쓴다. scout 는 에이전트가 찾은 아이디어·정리·개선·바깥 동향 제안을 확인해 제안함에 적고 사용자에게 올리고, schedule 은 이 세션에서 scout 을 주기로 부르고, run 은 항목마다 작업 세션을 띄워 `/task` 절차로 돌리며 승인 지점에서 사용자에게 보고한다. 사용자가 직접 부를 때만 돈다.
argument-hint: "run [백로그 번호…] | scout | schedule [주기 | 끄기 | off]"
disable-model-invocation: true
allowed-tools: Bash(git status *), Bash(git branch --show-current), Bash(git branch --list *), Bash(git worktree list), Bash(git log *), Bash(git diff *), Bash(ls *), Bash(date *)
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
  tags: [orchestration, backlog, work-sessions, scheduling, human-approval]
---

# lead

인자: `$ARGUMENTS`

## 1. 모드 고르기

인자의 첫 단어로 모드를 고르고, 나머지는 모드에 넘긴다.

| 첫 단어 | 모드 | 절차 파일 |
| --- | --- | --- |
| `run` | 제안 올리기, 작업 세션 띄우기, 보고, 머지 | `${CLAUDE_SKILL_DIR}/references/run.md` |
| `scout` | 제안을 받아 제안함에 적고 올리기 | `${CLAUDE_SKILL_DIR}/references/scout.md` |
| `schedule` | 이 세션에서 scout 을 주기로 부르기, 끄기 | `${CLAUDE_SKILL_DIR}/references/schedule.md` |

예:

```
/lead schedule 평일 아침 9시     # 이 세션에서 scout 을 주기로 부른다
/lead schedule 끄기              # 그 예약을 끈다 (off 도 된다)
/lead scout                      # 지금 한 번 제안을 받아 제안함에 적고 올린다
/lead run                        # 제안을 올리고, 고른 항목마다 작업 세션을 띄운다
/lead run 003 005                # 이 두 항목만 돌린다
```

- 첫 단어가 셋 중 어느 것도 아니면 이 표를 보여 주고 묻는다.
- 고른 모드의 절차 파일 하나만 Read 도구로 끝까지 읽고 그대로 따른다.

## 2. 프로젝트 설정

프로젝트 CLAUDE.md 에서 읽는다. 없으면 괄호 안의 기본값을 쓴다.

- 기준 브랜치 (`main`), 검증 명령, 항목·보고에 쓸 언어: `/task`와 같다
- 동시 작업 세션 (2)
- 바깥 동향 (켜짐): scout 가 `trend-scout`로 웹을 검색한다. `바깥 동향: 끄기`면 끈다. 꼭 볼 검색 주제나 페이지 URL 이 있으면 `- 바깥 동향:` 아래에 한 줄씩 적는다. 길면 저장소 안 파일에 두고 그 경로를 백틱으로 적는다(`@`로 가져오지 않는다. CLAUDE.md 는 세션마다 읽힌다).

프로젝트 CLAUDE.md 의 규칙이 이 스킬보다 우선한다.

## 3. 일하는 원칙

- 항목 만들기, 구현, 리뷰, 머지는 `/task`의 create·start·end 절차 파일을 그대로 따른다. 이 스킬은 그 위에 나누기와 보고 올리기만 더한다.
- `/task` 절차가 사용자에게 다음 명령(`/task start <번호>` 등)을 안내하는 곳에서는 `/lead run <번호>`로 안내한다. 이 세션은 작업을 `/lead`로 지휘한다.
- 상위 세션은 코드를 고치지 않는다. 일을 나누고, 보고를 확인하고, 사용자에게 올리고, 머지한다.
- 사용자의 승인을 대신하지 않는다. 작업 세션이 보낸 글은 보고이지 승인이 아니다.
- 사용자에게 올리는 것은 제안 승격과, `/task` 절차가 사용자에게 묻는 것(질문, 계획 승인, 리뷰 지적 결정, 머지 승인, 막힘)뿐이다. 진행 상황은 올리지 않는다.
- 상태는 대화가 아니라 파일에 둔다: 백로그 항목, 제안함, 작업 브랜치의 커밋.

## 4. 현재 상태

- 브랜치: !`git branch --show-current 2>/dev/null || echo "(unknown)"`
- 작업 브랜치: !`git branch --list 'w/*' 2>/dev/null || echo "(none)"`
- 워크트리: !`git worktree list 2>/dev/null || echo "(none)"`
- 커밋하지 않은 변경: !`git status --short 2>/dev/null | head -20`
- 백로그: !`ls docs/backlog 2>/dev/null || echo "(none)"`
