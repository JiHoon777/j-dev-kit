---
name: task-start
description: 작업을 시작할 때 쓴다. 백로그 항목을 확인하고 브랜치를 만든 뒤, 프로젝트 스택(frontend/supabase/server)에 맞는 사전 점검을 한다.
---

# 작업 시작

## 1. 스택 판별

프로젝트 CLAUDE.md의 `stack:` 줄을 먼저 본다. 없으면 다음으로 추정한다.

- `supabase/` 폴더가 있다 → supabase
- package.json에 react, next, vue 등 프론트 프레임워크가 있다 → frontend
- 서버 프레임워크(express, nest, fastapi 등)가 있다 → server

**여러 개에 해당하면 해당하는 섹션을 전부 적용한다.** 판별 결과를 사용자에게 한 줄로 알린다.

## 2. 공통 절차 (항상, 한 번만)

<!-- TODO: 기존 작업 시작 절차를 옮긴다. 예: 백로그 항목 확인, 브랜치 생성 -->

## 3. 스택별 점검 (해당하는 것 전부)

### frontend

<!-- TODO -->

### supabase

<!-- TODO -->

### server

<!-- TODO -->
