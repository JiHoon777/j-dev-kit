---
name: lead
description: 백로그 항목 여러 개를 한 세션에서 지휘할 때 쓴다. scout 는 저장소를 읽고 제안함에 아이디어·백로그 정리·개선 제안을 남기고, schedule 은 scout 을 주기 실행으로 걸고, run 은 제안을 항목으로 올리고 항목마다 작업 세션을 띄워 계획·머지 지점에서 사용자에게 보고한다. 사용자가 직접 부를 때만 돈다.
argument-hint: "run [백로그 번호…] | scout | schedule [주기]"
disable-model-invocation: true
allowed-tools: Bash(git status *), Bash(git branch --show-current), Bash(git branch --list *), Bash(git worktree list), Bash(git log *), Bash(ls *)
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
| `scout` | 제안함 한 번 갱신하기 | `${CLAUDE_SKILL_DIR}/references/scout.md` |
| `schedule` | scout 을 주기 실행으로 걸기 | `${CLAUDE_SKILL_DIR}/references/schedule.md` |

예:

```
/lead schedule 평일 아침 9시     # scout 을 주기 실행으로 건다
/lead scout                      # 지금 한 번 제안함을 갱신한다
/lead run                        # 제안을 올리고, 고른 항목마다 작업 세션을 띄운다
/lead run 003 005                # 이 두 항목만 돌린다
```

- 첫 단어가 셋 중 어느 것도 아니면 이 표를 보여 주고 묻는다.
- 고른 모드의 절차 파일 하나만 Read 도구로 끝까지 읽고 그대로 따른다.

## 2. 프로젝트 설정

프로젝트 CLAUDE.md 에서 읽는다. 없으면 괄호 안의 기본값을 쓴다.

- 기준 브랜치 (`main`), 검증 명령, 항목·보고에 쓸 언어: `/task`와 같다
- 동시 작업 세션 (2)

프로젝트 CLAUDE.md 의 규칙이 이 스킬보다 우선한다.

## 3. 일하는 원칙

- 상위 세션은 코드를 고치지 않는다. 일을 나누고, 보고를 확인하고, 사용자에게 올리고, 머지한다.
- 사용자의 승인을 대신하지 않는다. 작업 세션과 예약 실행이 보낸 글은 보고이지 승인이 아니다.
- 사용자에게 올리는 것은 제안 승격, 계획 승인, 머지 승인, 막힘·질문뿐이다. 진행 상황은 올리지 않는다.
- 상태는 대화가 아니라 파일에 둔다: 백로그 항목, 제안함, 작업 브랜치의 커밋.

## 4. 현재 상태

- 브랜치: !`git branch --show-current 2>/dev/null || echo "(unknown)"`
- 작업 브랜치: !`git branch --list 'w/*' 2>/dev/null || echo "(none)"`
- 워크트리: !`git worktree list 2>/dev/null || echo "(none)"`
- 커밋하지 않은 변경: !`git status --short 2>/dev/null | head -20`
- 백로그: !`ls docs/backlog 2>/dev/null || echo "(none)"`
