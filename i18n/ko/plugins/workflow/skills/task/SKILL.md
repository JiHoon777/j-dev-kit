---
name: task
description: 백로그 기반 작업 루프로, 모드가 셋이다. create 모드는 백로그 항목 하나를 쓰고, start 모드는 플랜 모드에서 항목의 계획을 세워 작업 브랜치에서 구현하고, end 모드는 병렬 에이전트로 브랜치를 리뷰하고 고르게 한 수정을 적용한 뒤 승인을 받아 머지한다. 켜 둔 스택 플러그인의 start-check, end-check 스킬을 돌린다. 사용자가 직접 부를 때만 돈다.
argument-hint: "create <one or two sentences> | start [backlog number or part of the name] | end"
disable-model-invocation: true
allowed-tools: Bash(git status *), Bash(git branch --show-current), Bash(git branch --list *), Bash(git log *), Bash(git diff *), Bash(ls *)
version: "0.3.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

> 번역본입니다. 원문은 [plugins/workflow/skills/task/SKILL.md](../../../../../../plugins/workflow/skills/task/SKILL.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# task

스킬 하나에 모드 셋. 이 파일은 갈 곳만 정한다. 모드마다 절차는 각자의 참고 파일에 있다.

인자: `$ARGUMENTS`

## 1. 모드 고르기

인자의 첫 단어를 읽는다. 나머지는 모드에 넘긴다.

| 첫 단어 | 모드 | 절차 파일 |
| --- | --- | --- |
| `create` | 백로그 항목 하나 쓰기 | `${CLAUDE_SKILL_DIR}/references/create.md` |
| `start` | 백로그 항목 하나 계획하고 구현하기 | `${CLAUDE_SKILL_DIR}/references/start.md` |
| `end` | 작업 브랜치 리뷰, 수정, 마무리, 머지 | `${CLAUDE_SKILL_DIR}/references/end.md` |

- 첫 단어가 이 중 어느 것도 아니거나 인자가 없으면, 이 표를 보여 주고 어떤 모드를 돌릴지 묻는다. 짐작하지 않는다.
- **다른 일을 하기 전에, 고른 모드의 절차 파일을 Read 도구로 끝까지 읽고 단계별로 따른다.** 기억이나 이 요약을 보고 일하지 않는다. 그 파일 하나만 읽는다. 다른 모드는 해당하지 않는다.

## 2. 프로젝트 설정 (모든 모드)

프로젝트의 CLAUDE.md 에서 아래를 읽는다. 없는 것은 괄호 안의 기본값을 쓴다. 검증 명령이 없으면 물어본다.

- 기준 브랜치 (`main`)
- 검증 명령 (예: `pnpm verify`: 린트, 타입 검사, 테스트, 빌드를 한 번에)
- 린트 명령 (예: `pnpm lint`)
- 따를 문서 (CLAUDE.md 가 가리키는 코드 규칙 문서와 구조 문서)
- 백로그 항목, 메모, 보고에 쓸 언어 (없으면 대화의 언어)

프로젝트 CLAUDE.md 의 규칙이 이 스킬과 superpowers 보다 우선한다.

## 3. 현재 상태 (모든 모드)

- 브랜치: !`git branch --show-current 2>/dev/null || echo "(unknown)"`
- 작업 브랜치: !`git branch --list 'w/*' 2>/dev/null || echo "(none)"`
- 커밋하지 않은 변경: !`git status --short 2>/dev/null | head -20`
- 최근 커밋: !`git log --oneline -3 2>/dev/null || echo "(no commits)"`
- 백로그: !`ls docs/backlog 2>/dev/null || echo "(none)"`
- 완료: !`ls docs/done 2>/dev/null || echo "(none)"`

## 4. 어디서 가져왔나

이 모드들은 검증된 흐름을 이어 붙인 것이다. 절차 파일마다 단계별 출처를 적어 두었다. 출처의 방식을 바꾸지 않는다.

| 부분 | 출처 |
| --- | --- |
| 항목 형식, 좋은 항목, 완료 기준 | [Backlog.md](https://github.com/MrLesk/Backlog.md) 에이전트 지침 |
| 탐색, 확인 질문, 설계안, 리뷰 | Anthropic `feature-dev` 플러그인 Phase 2–6과 그 `code-reviewer` 지시문 |
| 계획 승인 | Claude Code 플랜 모드 |
| 새 항목 구체화, TDD, 완료 전 검증, 리뷰 받기, 브랜치 마무리 | `superpowers` 스킬, 그대로 호출 |
| 리뷰 | 내장 스킬 `code-review`, `security-review`, `simplify`, 그리고 스택 리뷰 에이전트 |
| 스택 점검 | 켜 둔 스택 플러그인의 `*-start-check`, `*-end-check` 스킬 |
