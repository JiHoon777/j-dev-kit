#!/usr/bin/env bash
# 주문 앱. 항목 001(주문 취소 시 환불과 알림)은 orders, payments, notify 세 모듈에 걸친다.
# 꼭 읽을 파일: src/orders/cancel.ts, src/payments/refund.ts, src/notify/index.ts.
# 코드로 답할 수 있는 것: 환불 수수료(src/payments/policy.ts), 알림 채널(src/notify/index.ts).
set -euo pipefail
git init -q -b main
git config user.name eval
git config user.email eval@example.invalid
mkdir -p src/orders src/payments src/notify src/auth docs/backlog test
cat > CLAUDE.md <<'J'
# shop

## 작업 설정
- stack: 없음
- 기준 브랜치: main
- 검증 명령: npm test
- 문서 언어: 한국어
J
cat > package.json <<'J'
{ "name": "shop", "private": true, "type": "module", "scripts": { "test": "node --test test/" } }
J
cat > src/orders/model.ts <<'J'
export type OrderStatus = 'paid' | 'shipped' | 'delivered' | 'cancelled';
export interface Order { id: string; userId: string; amount: number; status: OrderStatus; paymentId: string; }
J
cat > src/orders/repo.ts <<'J'
import type { Order } from './model';
const orders = new Map<string, Order>();
export const findOrder = (id: string) => orders.get(id);
export const saveOrder = (o: Order) => { orders.set(o.id, o); };
J
cat > src/orders/cancel.ts <<'J'
import { findOrder, saveOrder } from './repo';

// 지금은 상태만 바꾼다. 환불과 알림이 없다.
export function cancelOrder(orderId: string, userId: string) {
  const order = findOrder(orderId);
  if (!order || order.userId !== userId) throw new Error('not found');
  if (order.status === 'shipped' || order.status === 'delivered') throw new Error('cannot cancel');
  order.status = 'cancelled';
  saveOrder(order);
  return order;
}
J
cat > src/payments/gateway.ts <<'J'
export async function gatewayRefund(paymentId: string, amount: number) {
  return { paymentId, refunded: amount };
}
J
cat > src/payments/policy.ts <<'J'
// 취소 수수료: 결제 후 24시간이 지나면 5%. 그 전에는 없다.
export const CANCEL_FEE_RATE_AFTER_24H = 0.05;
J
cat > src/payments/refund.ts <<'J'
import { gatewayRefund } from './gateway';
export async function refund(paymentId: string, amount: number) {
  if (amount <= 0) throw new Error('invalid amount');
  return gatewayRefund(paymentId, amount);
}
J
cat > src/notify/index.ts <<'J'
// 알림은 이메일 하나뿐이다. 템플릿은 templates 에 이름으로 둔다.
import { sendEmail } from './email';
export const templates = { orderPaid: '결제가 끝났습니다', orderShipped: '배송을 시작했습니다' } as const;
export function notify(userId: string, template: keyof typeof templates) {
  return sendEmail(userId, templates[template]);
}
J
cat > src/notify/email.ts <<'J'
export async function sendEmail(userId: string, body: string) { return { userId, body }; }
J
cat > src/auth/session.ts <<'J'
export function currentUserId(req: { headers: Record<string, string> }) { return req.headers['x-user-id']; }
J
cat > test/cancel.test.js <<'J'
import test from 'node:test';
test('placeholder', () => {});
J
cat > docs/backlog/README.md <<'J'
# 백로그

`/backlog`가 항목을 만들고, `/start`가 구현부터 머지까지 진행한다.
J
cat > docs/backlog/001-feat-cancel-refund.md <<'J'
---
id: '001'
title: 주문을 취소하면 환불하고 알린다
status: To Do
labels: [feat]
priority: medium
dependencies: []
created_date: 2026-11-23
updated_date: 2026-11-23
---

## Description

주문을 취소해도 지금은 상태만 바뀐다. 취소하면 결제 금액을 정책대로 환불하고 사용자에게 알린다.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 결제한(배송 전) 주문을 취소하면 정책의 수수료를 뺀 금액이 환불된다
- [ ] #2 취소하면 사용자에게 취소 알림이 간다
- [ ] #3 환불이 실패하면 주문은 취소되지 않는다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `npm test` 통과

<!-- DOD:END -->

## Implementation Plan

## Implementation Notes

## Final Summary
J
git add -A && git commit -qm base
