---
name: backlog-create
description: 백로그 항목을 만든다. 사용자가 할 일을 백로그에 넣어 달라고 하거나, /backlog-create 로 부르거나, 나중에 하기로 한 일을 기록해 달라고 할 때 쓴다.
argument-hint: '[만들 항목을 한두 문장으로]'
allowed-tools: Bash(ls *), Bash(git status *), Bash(git branch --show-current)
---

# backlog-create: 백로그 항목 만들기

`docs/backlog/`에 항목 파일을 하나 만든다. 형식과 규칙은 [Backlog.md](https://github.com/MrLesk/Backlog.md) 에이전트 지침의 것이다. 도구는 쓰지 않고 형식만 쓴다. 끝난 항목은 `docs/done/`으로 옮긴다(`task-end`가 한다).

이 스킬은 검증된 흐름을 이어 붙인 것이다. 출처의 방식을 바꾸지 않는다.

| 단계 | 출처 |
| --- | --- |
| 1 | `superpowers:brainstorming` (그대로 호출) |
| 2 | Backlog.md 에이전트 지침 (항목 형식, 좋은 항목) |

만들 것: `$ARGUMENTS`

## 지금 상태

- 백로그: !`ls docs/backlog 2>/dev/null || echo "(없음)"`
- 끝난 일: !`ls docs/done 2>/dev/null || echo "(없음)"`
- 브랜치: !`git branch --show-current 2>/dev/null || echo "(알 수 없음)"`

## 0. 처음 쓰는 프로젝트면 폴더를 만든다

`docs/backlog/`가 없으면 아래 세 파일을 만들자고 제안하고, 승인받으면 만든다. 이미 있는 파일은 덮어쓰지 않는다.

- `docs/backlog/README.md`: 항목 파일 규칙(아래 2번의 표), 라벨 목록, "아직 항목으로 만들지 않은 메모" 섹션.
- `docs/backlog/_template.md`: 아래 템플릿. Definition of Done 의 검증 명령은 프로젝트 CLAUDE.md 에 적힌 것으로 바꾼다. 없으면 무엇인지 묻는다.
- `docs/done/README.md`: "`task-end`로 끝난 항목이 이 폴더로 옮겨진다. 새 번호를 정할 때 이 폴더의 번호도 같이 본다."

라벨은 사용자에게 묻는다. 지어내지 않는다.

```markdown
---
id: '000'
title: 무엇을 하는지 짧게
status: To Do
labels: [common]
priority: medium
dependencies: []
created_date: YYYY-MM-DD
updated_date: YYYY-MM-DD
---

## Description

이 일의 목적과 맥락을 짧게 적는다. 구현 방법은 적지 않는다. 이번에 일부러 빼는 것이 있으면 여기에 같이 적는다.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 결과를 눈으로 보거나 명령으로 확인할 수 있는 문장
- [ ] #2 …

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 <검증 명령>이 통과한다
- [ ] #2 화면이 바뀌었으면 브라우저에서 직접 확인했다
- [ ] #3 새로 정한 것이 있으면 문서를 고쳤다

<!-- DOD:END -->

## Implementation Plan

항목을 만들 때는 비워 둔다. `task-start`가 승인받은 계획을 적는다.

## Implementation Notes

작업하면서 알게 된 것, 계획과 달라진 것을 적는다.

## Final Summary

`task-end`가 끝날 때 적는다: 무엇이 바뀌었는지, 리뷰에서 고친 것과 미룬 것.
```

## 1. 무엇을 왜 하는지 분명히 한다

- 요청에 목적과 결과가 다 들어 있으면 바로 2번으로 간다.
- 빠진 것이 있으면 `superpowers:brainstorming` 스킬을 불러 그 방식대로 묻는다. 다만 이 스킬에서는:
  - 설계 문서를 따로 쓰지 않는다. **백로그 항목 파일이 그 문서다.**
  - 구현 계획으로 넘어가지 않는다(`superpowers:writing-plans`를 부르지 않는다). 계획은 `task-start`가 세운다.
  - superpowers 가 설치돼 있지 않으면 그 사실을 알리고, 목적·결과·범위 밖·완료 기준을 직접 묻는다.
- 이미 있는 항목과 겹치는지 `docs/backlog/`와 `docs/done/`을 확인한다. 겹치면 새로 만들지 말고 알린다.
- `docs/backlog/README.md`의 "아직 항목으로 만들지 않은 메모"에 있던 것이면, 항목을 만든 뒤 그 줄을 지운다.

## 2. 항목을 쓴다 (Backlog.md 지침)

`docs/backlog/_template.md`를 따른다.

| 부분 | 규칙 (원문) |
| --- | --- |
| `title` | "Use a clear brief title that summarizes the task." |
| `Description` | "Provide a concise summary of the task purpose and its goal. Explains the context without implementation details." 이번에 빼는 것도 여기 적는다 |
| `Acceptance Criteria` | "Outcome-Oriented: Focus on the result, not the method." "Testable/Verifiable: Each criterion should be objectively testable". 형식은 `- [ ] #1 문장`. 나쁜 예: "`handleLogin()` 함수를 추가한다" |
| 크기 | "Tasks must be atomic and testable or verifiable" — 한 번에 리뷰하고 머지할 수 있는 크기. 크면 항목을 나누고 순서를 `dependencies`에 적는다 |
| 의존 | "Never reference future tasks (only tasks with id < current task id)" |
| `Implementation Plan` | "Do NOT include an Implementation Plan when creating a task." 비워 둔다 |

- `id`와 파일 이름의 번호는 `docs/backlog/`와 `docs/done/`을 통틀어 가장 큰 번호 다음이다. 세 자리로 쓴다.
- 파일 이름: `<번호>-<라벨>-<짧은-영어-이름>.md`
- `status: To Do`, `labels`는 `docs/backlog/README.md`의 목록에서, `created_date`와 `updated_date`는 오늘.
- `Definition of Done`은 템플릿의 줄을 그대로 둔다. 이 항목에만 필요한 것이 있으면 더한다.
- 프로젝트 CLAUDE.md 의 원칙에 어긋나는 일이면 만들지 말고 알린다.

## 3. 보여 주고 승인받는다

파일을 쓰기 전에 항목 내용을 사용자에게 보여 준다. 여러 개로 나눴으면 전부 보여 준다. 고쳐 달라고 하면 고쳐서 다시 보여 준다.

## 4. 저장한다

1. 파일을 쓴다.
2. 프로젝트에 린트·포맷 명령이 있으면 통과하는지 확인한다. 포맷 때문에 실패하면 자동 수정 명령을 쓴다.
3. 커밋한다: `docs(backlog): <번호> <제목>`. 항목 파일(과 메모에서 지운 줄)만 담는다. 다른 변경이 섞여 있으면 그 파일들만 골라 담는다.
   - 커밋하지 않고 두면 `task-start`가 "커밋하지 않은 변경"에 걸려 시작하지 못한다.
   - 푸시하지 않는다.
4. 만든 파일의 경로와 번호를 알리고, 시작하려면 `/task-start <번호>`라고 알린다.
