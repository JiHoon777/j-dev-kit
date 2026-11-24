# 백로그

`/task create`가 항목을 만들고, `/task start`·`/task end`가 진행한다. 끝난 항목은 `docs/done/`으로 옮긴다.

## 규칙

| 부분 | 규칙 |
| --- | --- |
| `title` | 할 일을 요약하는 짧은 제목 |
| Description | 목적과 배경. 구현 방법은 빼고, 이번에 빼는 것은 적는다 |
| Acceptance Criteria | 방법이 아니라 결과. 하나하나 확인할 수 있어야 한다 |
| 크기 | 한 번에 리뷰하고 머지할 만큼. 크면 나누고 순서를 `dependencies`에 |
| 의존성 | 번호가 더 작은 항목만 |
| Implementation Plan | 만들 때는 비워 둔다 |

- 번호: `docs/backlog/`와 `docs/done/`을 통틀어 가장 큰 번호 + 1, 세 자리. 이 파일과 `_`로 시작하는 파일은 항목이 아니다.
- 파일 이름: `<번호>-<라벨>-<짧은-영어-이름>.md`. 형식은 `_template.md`.
- 근거 자료: 항목이 근거로 삼는 조사 보고서와 리서치 노트는 [`references/`](references/)에 둔다. 항목이 아니다.

## 라벨

- `feat`: 새 기능
- `fix`: 고치기
- `docs`: 문서만
- `chore`: 설정, 정리
