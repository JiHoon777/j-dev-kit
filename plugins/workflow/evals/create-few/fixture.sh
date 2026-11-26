#!/usr/bin/env bash
# 합성 사례(B4). 작은 쇼핑몰 저장소. 통화는 원, 로그인 기능은 없다(누구나 손님), 화면은 SvelteKit.
set -euo pipefail
git init -q -b main
git config user.name eval
git config user.email eval@example.invalid
mkdir -p src/lib src/routes/cart docs/backlog
cat > CLAUDE.md <<'J'
# shop

작은 온라인 가게. 상품을 장바구니에 담고 주문한다. 로그인 기능은 없다(누구나 손님으로 산다). 값은 모두 원(KRW)이다.

## 작업 설정
- stack: frontend
- 기준 브랜치: main
- 검증 명령: pnpm verify
- 문서 언어: 한국어
J
cat > package.json <<'J'
{ "name": "shop", "private": true, "type": "module",
  "scripts": { "dev": "vite dev", "verify": "svelte-check && vitest run" },
  "devDependencies": { "@sveltejs/kit": "^3.4.0", "svelte": "^5.40.0", "vitest": "^4.0.0" } }
J
cat > src/lib/cart.ts <<'J'
// 장바구니 합계(원). 수량을 곱하지 않는 버그가 있다.
export interface Line { id: string; name: string; price: number; qty: number }
export function total(lines: Line[]) {
  return lines.reduce((sum, l) => sum + l.price, 0);
}
J
cat > src/routes/cart/+page.svelte <<'J'
<script lang="ts">
  import { total, type Line } from '$lib/cart';
  let lines = $state<Line[]>([{ id: 'a', name: '머그컵', price: 12000, qty: 2 }]);
</script>
<h1>장바구니</h1>
<ul>{#each lines as l (l.id)}<li>{l.name} × {l.qty} — {l.price}원</li>{/each}</ul>
<p>합계 {total(lines)}원</p>
<button disabled>주문하기 (준비 중)</button>
J
cat > DESIGN.md <<'J'
# DESIGN.md
- 색: 배경 #fffaf3, 글자 #2b2118, 강조 #d9622b
- 글꼴: Pretendard 16px, 제목 24px
- 간격: 8px 단위
J
cat > docs/backlog/README.md <<'J'
# 백로그

`/backlog`가 항목을 만든다. 형식은 `_template.md`.
J
cat > docs/backlog/_template.md <<'J'
---
id: '000'
title:
status: To Do
labels: []
---

## Description

## Acceptance Criteria

<!-- AC:BEGIN -->
<!-- AC:END -->
J
git add -A && git commit -qm base
