#!/usr/bin/env bash
# 백로그가 있는 작은 저장소. 001 은 To Do, 002 는 In Progress(w/002 브랜치에 작업 커밋 하나).
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
cat > package.json <<'J'
{ "name": "shop", "private": true, "scripts": { "test": "node --test" } }
J
cat > README.md <<'J'
# shop

장바구니 예제. 자세한 설명은 아직 없다.
J
cat > src/cart.ts <<'J'
export interface Line { price: number; qty: number; }
export function total(lines: Line[]) {
  return lines.reduce((sum, l) => sum + l.price, 0);
}
J
cat > docs/backlog/README.md <<'J'
# 백로그

`/backlog`가 항목을 만들고, `/start`가 구현부터 머지까지 진행한다.
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
cat > docs/backlog/002-fix-qty-total.md <<'J'
---
id: '002'
title: 수량을 합계에 반영
status: In Progress
labels: [fix]
---

## Acceptance Criteria

- [ ] #1 수량이 2 이면 합계가 두 배가 된다
J
git add -A && git commit -qm base
git switch -q -c w/002-fix-qty-total
sed 's/sum + l.price/sum + l.price * l.qty/' src/cart.ts > src/cart.ts.new && mv src/cart.ts.new src/cart.ts # GNU·BSD sed 둘 다
git commit -qam "fix: 합계에 수량 곱하기"
git switch -q main
