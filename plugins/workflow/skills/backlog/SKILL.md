---
name: backlog
description: 백로그 항목을 만들 때 쓴다. 사용자가 할 일을 백로그 항목으로 만들자고 하면 부른다. 자료(로그, 이슈 등)나 목표를 보고 고칠 것을 항목으로 뽑자고 하면 --survey 로 부른다. 항목을 구현하는 일은 start 스킬이 한다. 항목 이야기 없이 바로 고쳐 달라는 요청에는 쓰지 않는다.
argument-hint: "<한두 문장> [--here] | --survey <목표> [자료…] [--internal] [--here]"
allowed-tools: Bash(git status *), Bash(git branch --show-current), Bash(git branch --list *), Bash(git log *), Bash(git diff *), Bash(ls *)
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# backlog

인자: `$ARGUMENTS`

`docs/backlog/`에 항목 파일 하나를 만든다. 형식은 [Backlog.md](https://github.com/MrLesk/Backlog.md) 에이전트 지침을 따르고 도구는 쓰지 않는다. 항목을 구현하고 끝내는 일은 `start` 스킬이 한다. 끝난 항목은 `start`가 `docs/done/`으로 옮긴다.

만들 것: 인자. `--survey`로 시작하면 `${CLAUDE_SKILL_DIR}/references/survey.md`를 Read 도구로 끝까지 읽고 따른다.

## 어디서 하나

- **인자에 `--here`가 있으면:** 떼어 내고 이 세션에서 한다.
- **그 밖:** 하위 세션을 띄운다.
  1. 사용자가 열어 보고 직접 대화할 수 있는 세션을 새로 시작하는 도구(예: 데스크톱 앱의 `start_session`)가 없으면, 이 세션에서 한다고 한 줄 알리고 절차를 따른다.
  2. 이 세션이 기준 폴더의 기준 브랜치에 있을 때만 띄운다. 워크트리 안이거나(`git rev-parse --path-format=absolute --git-dir --git-common-dir`의 두 줄이 다르면) 다른 브랜치면 이 세션에서 하고, 항목 커밋이 지금 브랜치에 들어간다고 알린다. 같은 폴더를 두 세션이 함께 쓰면 커밋과 인덱스가 섞인다.
  3. 세션 하나를 이 폴더 그대로(워크트리 없이) 띄운다. 사용자가 시킨 일이니 제안으로 올리지 않고 바로 시작한다. 모델과 노력은 `start` 스킬과 같다: 이 세션이 Fable 이면 `model`을 한 단계 낮은 최신 모델(지금은 Opus, `claude-opus-5-5`)로, `effort`를 `high`로 준다. 이 세션의 노력이 `high`보다 낮으면 `effort`는 주지 않는다. Opus 이하면 둘 다 주지 않는다.
  4. 그 세션은 이 대화를 볼 수 없다. 지시문은 "`backlog` 스킬을 `<인자> --here`로 불러 그 절차를 따른다", "질문과 승인 요청은 턴의 마지막 메시지에 빠짐없이 쓰고 멈춘다" 두 줄과, 이 대화에서 사용자가 말한 배경이나 정한 것(있을 때만)이다.
  5. 세션 링크를 알린다. 그 일은 이 세션에서 하지 않고, 이 세션이 지휘한다. 하위 세션이 턴을 끝내면 질문과 승인 요청은 빠짐없이 사용자에게 보여 주고 답을 사용자의 말 그대로 전한다. 결과(커밋, 바뀐 파일)는 직접 확인해 보고한다. 사용자가 하위 세션에서 직접 답했으면 그것을 받아들인다.

프로젝트 CLAUDE.md 에서 기준 브랜치(없으면 `main`)와 항목에 쓸 언어(없으면 대화의 언어)를 읽는다. 프로젝트 CLAUDE.md 의 규칙이 이 스킬보다 우선한다.

## 묻는 기준

`${CLAUDE_SKILL_DIR}/../start/SKILL.md`의 "묻는 기준"을 따른다. 이 스킬에서 묻는 것은 넷뿐이다: 처음일 때 라벨, 모호할 때의 질문(1단계), 항목 승인(3단계), 서베이 후보 고르기. 그 밖은 정하고 Description 에 가정으로 적는다.

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

만들 때는 비워 둔다. `/start`가 계획을 적는다.

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

## Final Summary

`/start`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것, 그대로 둔 지적과 이유, 사용자가 바로잡은 것.
```

## 1. 무엇을 왜 하는지

- 요청에 목적과 결과가 있으면 바로 2단계로 간다.
- 모호하면 묻는다. 질문 규칙:
  - 답이 항목(목적, 결과, 범위)을 바꾸고 저장소나 문서로 답할 수 없는 것만 묻는다. 한꺼번에, 최대 3개.
  - 왜 하려는지를 모르면 그것을 먼저 묻는다.
  - 고를 수 있는 선택이면 선택지와 추천을 붙인다.
  - 파일 위치, 라벨, 형식 같은 절차는 묻지 않는다. 정하고 Description 에 가정으로 적는다.
  - 방법(접근)은 묻지 않는다. 항목에는 방법을 쓰지 않는다.
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
| 글 | `${CLAUDE_SKILL_DIR}/../unslop/SKILL.md`와 `${CLAUDE_SKILL_DIR}/../technical-writing/SKILL.md`를 따른다 |

- 번호: `docs/backlog/`와 `docs/done/`을 통틀어 가장 큰 번호 + 1, 세 자리. `README.md`와 `_`로 시작하는 파일은 항목이 아니다.
- 파일 이름: `<번호>-<라벨>-<짧은-영어-이름>.md`. `status: To Do`, 날짜는 오늘.
- 다른 세션이 동시에 항목을 만들 수 있다. 4단계에서 파일을 쓰기 직전에 번호를 다시 세고, 그새 같은 번호가 생겼으면 다음 번호로 바꿔 알린다.
- 메모에서 온 요청이면 만든 뒤 `docs/backlog/README.md`의 그 줄을 지운다.

## 3. 보여 주고 승인

쓰기 전에 Description 과 Acceptance Criteria 전문을 보여 주고 승인받는다. 계획 승인이 없으니 이것이 구현 전에 사람이 확인하는 유일한 계약이다. 고쳐 달라면 고쳐서 다시 보여 준다.

AC 초안을 이미 보였고 사용자가 고른 항목은 다시 승인받지 않는다: 서베이 모드의 후보 표에서 고른 것, `start`의 마지막 메시지에서 "나중"으로 고른 것.

## 4. 저장

1. 파일을 쓰고, 프로젝트에 포맷 명령이 있으면 통과시킨다.
2. 항목 파일과 지운 메모 줄, 그리고 0단계에서 새로 만든 파일이 있으면 그것까지 커밋한다: `docs(backlog): <번호> <제목>`. 서베이 모드의 첫 항목이면 보고서도 넣는다. 다른 변경은 넣지 않는다. 남겨 두면 `/start`가 "커밋하지 않은 변경"에서 멈춘다. 푸시하지 않는다.
3. 경로와 번호를 알리고, 시작하려면 `/start <번호>`(또는 "시작해 줘")라고 말한다.
