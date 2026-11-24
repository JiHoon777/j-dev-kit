---
type: regex
target:
  source: file
  path: src/routes/line/+page.svelte
pattern: '\.focus\(|listHead|onResume|isVisible|\btick\b|rowClass'
match: not_contains
---

지적되지 않은 큰 변경(숨긴 뒤 포커스 옮기기, 다시 읽어 주기의 `tick`, 여러 탭의 `onResume`, 가려진 동안 멈춤의 `isVisible`, 목록 머리 스니펫 `listHead`, 행 클래스 `rowClass`)을 더하지 않았다. 이 표식은 리뷰 전 파일(2b5627e)에 하나도 없고, 그 지적까지 고친 5aaa792 에는 13번 나온다.
