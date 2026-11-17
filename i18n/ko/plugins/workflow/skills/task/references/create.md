> 번역본입니다. 원문은 [plugins/workflow/skills/task/references/create.md](../../../../../../../plugins/workflow/skills/task/references/create.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# task create: 백로그 항목 하나 쓰기

`docs/backlog/`에 항목 파일 하나를 만든다. 형식과 규칙은 [Backlog.md](https://github.com/MrLesk/Backlog.md) 에이전트 지침에서 가져온다. 형식만 쓰고 도구는 쓰지 않는다. 끝난 항목은 `docs/done/`으로 옮긴다(`/task end`가 한다).

이 모드는 검증된 흐름을 이어 붙인 것이다. 출처의 방식을 바꾸지 않는다.

| 단계 | 출처 |
| --- | --- |
| 1 | `superpowers:brainstorming` (그대로 호출) |
| 2 | Backlog.md 에이전트 지침 (항목 형식, 좋은 항목) |

만들 것: `create` 뒤의 인자.

## 0. 프로젝트에서 처음일 때: 폴더 만들기

`docs/backlog/`가 없으면 아래 세 파일을 만들자고 제안하고, 승인을 받은 뒤 만든다. 있는 파일은 절대 덮어쓰지 않는다.

- `docs/backlog/README.md`: 항목 파일 규칙(2단계의 표), 라벨 목록, 그리고 "아직 항목으로 만들지 않은 메모" 섹션.
- `docs/backlog/_template.md`: 아래 템플릿. Definition of Done 의 검증 명령은 프로젝트 CLAUDE.md 에 있는 것으로 바꾼다. 없으면 물어본다.
- `docs/done/README.md`: "`/task end`로 끝낸 항목이 여기로 옮겨진다. 새 번호를 정할 때 이 폴더의 번호도 본다."

라벨은 사용자에게 묻는다. 지어내지 않는다. 파일은 프로젝트의 언어로 쓴다(스킬의 프로젝트 설정 참고).

```markdown
---
id: '000'
title: Short description of what to do
status: To Do
labels: [common]
priority: medium
dependencies: []
created_date: YYYY-MM-DD
updated_date: YYYY-MM-DD
---

## Description

Purpose and context of this work, briefly. No implementation details. If something is deliberately left out this time, say so here.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 A sentence whose result can be seen on screen or checked with a command
- [ ] #2 …

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 <검증 명령> passes
- [ ] #2 If the UI changed, it was checked in a browser by hand
- [ ] #3 If something new was decided, the docs were updated

<!-- DOD:END -->

## Implementation Plan

Leave empty when creating the item. `/task start` writes the approved plan here.

## Implementation Notes

What was learned while working and what changed from the plan.

## Final Summary

Written when `/task end` finishes: what changed, what was fixed in review, and what was deferred.
```

## 1. 무엇을 왜 하는지 분명히 하기

- 요청에 목적과 결과가 이미 있으면 2단계로 간다.
- 빠진 게 있으면 `superpowers:brainstorming` 스킬을 호출해 그 방식대로 묻는다. 단, 이 모드에서는:
  - 따로 설계 문서를 쓰지 않는다. **백로그 항목 파일이 그 문서다.**
  - 구현 계획으로 넘어가지 않는다(`superpowers:writing-plans`를 호출하지 않는다). 계획은 `/task start`가 만든다.
  - superpowers 가 설치돼 있지 않으면 그렇다고 말하고, 목적, 결과, 이번에 빼는 것, 인수 조건을 직접 묻는다.
- `docs/backlog/`와 `docs/done/`에서 겹치는 항목을 찾는다. 있으면 새로 만들지 않고 사용자에게 알린다.
- 요청이 `docs/backlog/README.md`의 "아직 항목으로 만들지 않은 메모"에서 왔으면, 항목을 만든 뒤 그 줄을 지운다.

## 2. 항목 쓰기 (Backlog.md 지침)

`docs/backlog/_template.md`를 따른다.

| 부분 | 규칙 (원문) |
| --- | --- |
| `title` | "Use a clear brief title that summarizes the task." |
| `Description` | "Provide a concise summary of the task purpose and its goal. Explains the context without implementation details." 이번에 빼는 것도 적는다 |
| `Acceptance Criteria` | "Outcome-Oriented: Focus on the result, not the method." "Testable/Verifiable: Each criterion should be objectively testable". 형식: `- [ ] #1 문장`. 나쁜 예: "Add a `handleLogin()` function" |
| 크기 | "Tasks must be atomic and testable or verifiable" — 한 번에 리뷰하고 머지할 만큼 작게. 더 크면 나누고 순서를 `dependencies`에 적는다 |
| 의존성 | "Never reference future tasks (only tasks with id < current task id)" |
| `Implementation Plan` | "Do NOT include an Implementation Plan when creating a task." 비워 둔다 |

- `id`와 파일 이름의 번호는 `docs/backlog/`와 `docs/done/`을 통틀어 가장 큰 번호에 1을 더한 것이다. 세 자리로 쓴다.
- 파일 이름: `<번호>-<라벨>-<짧은-영어-이름>.md`
- `status: To Do`, `labels`는 `docs/backlog/README.md`의 목록에서, `created_date`와 `updated_date`는 오늘로.
- 템플릿의 Definition of Done 줄은 그대로 둔다. 이 항목에만 필요한 줄을 더한다.
- 작업이 프로젝트 CLAUDE.md 의 원칙과 어긋나면 만들지 않고 사용자에게 알린다.

## 3. 보여 주고 승인 받기

파일을 쓰기 전에 항목 내용을 사용자에게 보여 준다. 여러 항목으로 나눴으면 전부 보여 준다. 고쳐 달라고 하면 고쳐서 다시 보여 준다.

## 4. 저장

1. 파일을 쓴다.
2. 프로젝트에 린트나 포맷 명령이 있으면 통과하게 한다. 포맷이 실패하면 자동 수정 명령을 쓴다.
3. 커밋: `docs(backlog): <번호> <제목>`. 항목 파일(과 지운 메모 줄)만 넣는다. 다른 변경이 있으면 그 파일들만 스테이징한다.
   - 커밋하지 않고 두면 `/task start`가 "커밋하지 않은 변경"에서 멈춘다.
   - 푸시하지 않는다.
4. 사용자에게 파일 경로와 번호를 알리고, `/task start <번호>`로 시작한다고 말한다.
