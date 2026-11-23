#!/usr/bin/env bash
# 백로그가 있는 작은 저장소. w/001 브랜치에 작업 한 커밋, src/cart.ts 에 합계 버그(수량을 안 곱함).
set -euo pipefail
git init -q -b main
git config user.name eval
git config user.email eval@example.invalid
mkdir -p src docs/backlog
cat > CLAUDE.md <<'J'
# shop

## 작업 설정
- stack: 없음
- 기준 브랜치: main
- 검증 명령: npm test
J
cat > src/cart.ts <<'J'
export interface Line { price: number; qty: number; }
export function total(lines: Line[]) {
  return lines.reduce((sum, l) => sum + l.price, 0);
}
J
cat > docs/backlog/README.md <<'J'
# 백로그

`/task create`가 항목을 만들고, `/task start`·`/task end`가 진행한다.
J
cat > docs/backlog/001-feat-coupon.md <<'J'
---
id: '001'
title: 쿠폰 적용
status: To Do
labels: [feat]
---

## Acceptance Criteria

- [ ] #1 쿠폰 코드를 넣으면 합계에서 할인된다
J
git add -A && git commit -qm base
