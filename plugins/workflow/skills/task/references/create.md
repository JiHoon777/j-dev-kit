# task create: 백로그 항목 하나 쓰기

`docs/backlog/`에 항목 파일 하나를 만든다. 형식은 [Backlog.md](https://github.com/MrLesk/Backlog.md) 에이전트 지침을 따르고 도구는 쓰지 않는다. 끝난 항목은 `/task end`가 `docs/done/`으로 옮긴다.

만들 것: `create` 뒤의 인자.

## 0. 처음일 때

`docs/backlog/README.md`가 없으면 아래 두 파일을 만들자고 제안하고, 승인을 받아 만든다. 라벨은 사용자에게 묻는다.

- `docs/backlog/README.md`: 2단계의 규칙, 라벨 목록, "아직 항목으로 만들지 않은 메모" 섹션
- `docs/backlog/_template.md`: 아래 템플릿. `<검증 명령>`은 프로젝트의 것으로 바꾼다.

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

목적과 배경을 짧게. 구현 방법은 쓰지 않는다. 이번에 빼는 것이 있으면 적는다.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 화면이나 명령으로 확인할 수 있는 결과 한 문장
- [ ] #2 …

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `<검증 명령>` 통과
- [ ] #2 UI 가 바뀌었으면 브라우저에서 확인함

<!-- DOD:END -->

## Implementation Plan

만들 때는 비워 둔다. `/task start`가 승인된 계획을 적는다.

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것.
```

## 1. 무엇을 왜 하는지

- 요청에 목적과 결과가 있으면 바로 2단계로 간다.
- 모호하면 `superpowers:brainstorming` 스킬을 부른다. 단, 따로 설계 문서를 쓰지 않고(항목 파일이 그 문서다) 구현 계획으로 넘어가지 않는다. 질문은 정말 모르는 것만 한꺼번에 최대 3개, 나머지는 가정으로 Description 에 적는다.
- `docs/backlog/`와 `docs/done/`에 겹치는 항목이 있으면 만들지 않고 알린다.

## 2. 항목 쓰기 (Backlog.md 지침)

| 부분 | 규칙 |
| --- | --- |
| `title` | 할 일을 요약하는 짧은 제목 |
| Description | 목적과 배경. 구현 방법은 빼고, 이번에 빼는 것은 적는다 |
| Acceptance Criteria | 방법이 아니라 결과. 하나하나 확인할 수 있어야 한다. 나쁜 예: "`handleLogin()` 함수 추가" |
| 크기 | 한 번에 리뷰하고 머지할 만큼. 크면 나누고 순서를 `dependencies`에 |
| 의존성 | 번호가 더 작은 항목만 |
| Implementation Plan | 비워 둔다 |

- 번호: `docs/backlog/`와 `docs/done/`을 통틀어 가장 큰 번호 + 1, 세 자리. `README.md`와 `_`로 시작하는 파일은 항목이 아니다.
- 파일 이름: `<번호>-<라벨>-<짧은-영어-이름>.md`. `status: To Do`, 날짜는 오늘.
- 메모에서 온 요청이면 만든 뒤 `docs/backlog/README.md`의 그 줄을 지운다.

## 3. 보여 주고 승인

쓰기 전에 내용을 보여 준다. 고쳐 달라면 고쳐서 다시 보여 준다.

## 4. 저장

1. 파일을 쓰고, 프로젝트에 포맷 명령이 있으면 통과시킨다.
2. 항목 파일과 지운 메모 줄, 그리고 0단계에서 새로 만든 파일이 있으면 그것까지 커밋한다: `docs(backlog): <번호> <제목>`. 다른 변경은 넣지 않는다. 남겨 두면 `/task start`가 "커밋하지 않은 변경"에서 멈춘다. 푸시하지 않는다.
3. 경로와 번호를 알리고 `/task start <번호>`로 시작한다고 말한다.
