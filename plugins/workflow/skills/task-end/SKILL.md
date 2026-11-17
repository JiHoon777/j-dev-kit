---
name: task-end
description: 작업을 마무리할 때 쓴다. 변경 사항을 점검하고 백로그를 갱신한 뒤, 프로젝트 스택(frontend/supabase/server)에 맞는 마무리 점검을 한다.
---

# 작업 종료

## 1. 스택 판별

프로젝트 CLAUDE.md의 `stack:` 줄을 먼저 본다. 없으면 다음으로 추정한다.

- `supabase/` 폴더가 있다 → supabase
- package.json에 react, next, vue 등 프론트 프레임워크가 있다 → frontend
- 서버 프레임워크(express, nest, fastapi 등)가 있다 → server

**여러 개에 해당하면 해당하는 섹션을 전부 적용한다.**

## 2. 공통 절차 (항상, 한 번만)

<!-- TODO: 기존 작업 종료 절차를 옮긴다. 예: 변경 사항 요약, 백로그 항목 완료 처리 -->

## 3. 스택별 점검 (해당하는 것 전부)

### frontend

<!-- TODO -->

### supabase

<!-- TODO -->

### server

<!-- TODO -->
