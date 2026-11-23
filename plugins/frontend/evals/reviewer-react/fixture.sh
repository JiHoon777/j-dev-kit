#!/usr/bin/env bash
# Next.js App Router 저장소. main 에 기본 화면, w/001-cart 에 리뷰할 변경.
# 심은 문제(파일마다 하나): Total(useState+useEffect 로 맞추는 파생 state), Clock(정리 함수 없는 타이머),
# TodoList(바뀌는 목록의 인덱스 key), Search(늦은 응답이 새 응답을 덮는 요청), actions(검증·권한 확인 없는 서버 액션).
# Fine.tsx 는 맞는 코드다.
set -euo pipefail
git init -q -b main
git config user.name eval
git config user.email eval@example.invalid
mkdir -p app/cart docs/backlog
cat > package.json <<'J'
{
  "name": "shop",
  "private": true,
  "dependencies": {
    "next": "^15.3.0",
    "react": "^19.1.0",
    "react-dom": "^19.1.0"
  }
}
J
cat > app/page.tsx <<'J'
export default function Home() {
  return <a href="/cart">장바구니</a>;
}
J
git add -A && git commit -qm base

git switch -q -c w/001-cart
cat > docs/backlog/001-feat-cart.md <<'J'
---
id: '001'
title: 장바구니 화면
status: In Progress
---

## Acceptance Criteria

- [ ] #1 /cart 에 상품 목록과 합계가 보인다
- [ ] #2 할 일 목록에서 항목을 지울 수 있다
- [ ] #3 상품을 검색할 수 있다
- [ ] #4 로그인한 사용자는 자기 장바구니에서 상품을 지울 수 있다
J
cat > app/cart/Total.tsx <<'J'
'use client';
import { useEffect, useState } from 'react';

export function Total({ items }: { items: { price: number }[] }) {
  const [total, setTotal] = useState(0);
  useEffect(() => {
    setTotal(items.reduce((sum, item) => sum + item.price, 0));
  }, [items]);
  return <p>합계: {total}원</p>;
}
J
cat > app/cart/Clock.tsx <<'J'
'use client';
import { useEffect, useState } from 'react';

export function Clock() {
  const [now, setNow] = useState(() => new Date());
  useEffect(() => {
    setInterval(() => setNow(new Date()), 1000);
  }, []);
  return <p>지금: {now.toLocaleTimeString()}</p>;
}
J
cat > app/cart/TodoList.tsx <<'J'
'use client';
import { useState } from 'react';

export function TodoList() {
  const [todos, setTodos] = useState([
    { id: 1, text: '우유' },
    { id: 2, text: '빵' }
  ]);
  return (
    <ul>
      {todos.map((todo, i) => (
        <li key={i}>
          <label><input type="checkbox" /> {todo.text}</label>
          <button onClick={() => setTodos(todos.filter((t) => t.id !== todo.id))}>삭제</button>
        </li>
      ))}
    </ul>
  );
}
J
cat > app/cart/Search.tsx <<'J'
'use client';
import { useEffect, useState } from 'react';

export function Search() {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<string[]>([]);
  useEffect(() => {
    fetch(`/api/search?q=${encodeURIComponent(query)}`)
      .then((r) => r.json())
      .then((data) => setResults(data.items));
  }, [query]);
  return (
    <div>
      <label>검색 <input value={query} onChange={(e) => setQuery(e.target.value)} /></label>
      <ul>{results.map((name) => <li key={name}>{name}</li>)}</ul>
    </div>
  );
}
J
cat > app/cart/actions.ts <<'J'
'use server';
import { db } from '@/lib/db';

export async function removeCartItem(formData: FormData) {
  const itemId = formData.get('itemId') as string;
  await db.cartItem.delete({ where: { id: itemId } });
}
J
cat > app/cart/Fine.tsx <<'J'
export function Fine({ count }: { count: number }) {
  const doubled = count * 2;
  return <p>{count} × 2 = {doubled}</p>;
}
J
cat > app/cart/page.tsx <<'J'
import { Total } from './Total';
import { Clock } from './Clock';
import { TodoList } from './TodoList';
import { Search } from './Search';
import { Fine } from './Fine';
import { removeCartItem } from './actions';

const items = [
  { id: 'a', name: '사과', price: 1000 },
  { id: 'b', name: '배', price: 2000 }
];

export default function CartPage() {
  return (
    <main>
      <Total items={items} />
      <Clock />
      <TodoList />
      <Search />
      <Fine count={items.length} />
      {items.map((item) => (
        <form key={item.id} action={removeCartItem}>
          <input type="hidden" name="itemId" value={item.id} />
          <button>{item.name} 지우기</button>
        </form>
      ))}
    </main>
  );
}
J
git add -A && git commit -qm "feat: 장바구니"
# 셸 도구가 없는 실행(Windows 등)도 읽을 수 있게 diff 를 파일로 남긴다.
git diff main...HEAD > review.diff
