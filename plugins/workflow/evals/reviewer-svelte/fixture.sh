#!/usr/bin/env bash
# Svelte 5 저장소. main 에 기본 화면, w/001-cart 에 리뷰할 변경.
# 심은 문제(파일마다 하나): Total($effect 로 만든 파생 값), Title(새 코드의 export let),
# Theme(최상위 localStorage), Coupon(서버 파일 밖 $env/static/private), TodoList(바뀌는 목록의 키 없는 each).
# Fine.svelte 는 맞는 코드다.
set -euo pipefail
git init -q -b main
git config user.name eval
git config user.email eval@example.invalid
mkdir -p src/routes src/lib docs/backlog
cat > package.json <<'EOF'
{
  "name": "shop",
  "private": true,
  "type": "module",
  "devDependencies": {
    "@sveltejs/adapter-auto": "^6.0.0",
    "@sveltejs/kit": "^2.20.0",
    "svelte": "^5.30.0",
    "vite": "^6.3.0"
  }
}
EOF
cat > src/routes/+page.svelte <<'EOF'
<h1>가게</h1>
<a href="/cart">장바구니</a>
EOF
git add -A && git commit -qm base

git switch -q -c w/001-cart
cat > docs/backlog/001-feat-cart.md <<'EOF'
---
id: '001'
title: 장바구니 화면
status: In Progress
---

## Acceptance Criteria

- [ ] #1 /cart 에 상품 목록과 합계가 보인다
- [ ] #2 할 일 목록에서 항목을 지울 수 있다
- [ ] #3 테마를 바꾸면 새로고침해도 유지된다
- [ ] #4 쿠폰 코드를 적용할 수 있다
EOF
cat > src/lib/Total.svelte <<'EOF'
<script>
  let { items } = $props();
  let total = $state(0);
  $effect(() => {
    total = items.reduce((sum, item) => sum + item.price, 0);
  });
</script>

<p>합계: {total}원</p>
EOF
cat > src/lib/Title.svelte <<'EOF'
<script>
  export let title = '장바구니';
</script>

<h1>{title}</h1>
EOF
cat > src/lib/Theme.svelte <<'EOF'
<script>
  let theme = $state(localStorage.getItem('theme') ?? 'light');
  function toggle() {
    theme = theme === 'light' ? 'dark' : 'light';
    localStorage.setItem('theme', theme);
  }
</script>

<button onclick={toggle}>테마: {theme}</button>
EOF
cat > src/lib/Coupon.svelte <<'EOF'
<script>
  import { COUPON_SERVICE_KEY } from '$env/static/private';
  let code = $state('');
  let applied = $derived(code.length > 0 && COUPON_SERVICE_KEY.length > 0);
</script>

<label>쿠폰 코드 <input bind:value={code} /></label>
{#if applied}<p>쿠폰을 확인합니다</p>{/if}
EOF
cat > src/lib/TodoList.svelte <<'EOF'
<script>
  let todos = $state([
    { id: 1, text: '우유' },
    { id: 2, text: '빵' }
  ]);
  function remove(id) {
    todos = todos.filter((t) => t.id !== id);
  }
</script>

<ul>
  {#each todos as todo}
    <li>
      <label><input type="checkbox" /> {todo.text}</label>
      <button onclick={() => remove(todo.id)}>삭제</button>
    </li>
  {/each}
</ul>
EOF
cat > src/lib/Fine.svelte <<'EOF'
<script>
  let { count = 0 } = $props();
  let doubled = $derived(count * 2);
</script>

<p>{count} × 2 = {doubled}</p>
EOF
mkdir -p src/routes/cart
cat > src/routes/cart/+page.svelte <<'EOF'
<script>
  import Title from '$lib/Title.svelte';
  import Total from '$lib/Total.svelte';
  import Theme from '$lib/Theme.svelte';
  import Coupon from '$lib/Coupon.svelte';
  import TodoList from '$lib/TodoList.svelte';
  import Fine from '$lib/Fine.svelte';

  const items = [
    { name: '사과', price: 1000 },
    { name: '배', price: 2000 }
  ];
</script>

<Title />
<Total {items} />
<Theme />
<Coupon />
<TodoList />
<Fine count={items.length} />
EOF
git add -A && git commit -qm "feat: 장바구니"
# 셸 도구가 없는 실행(Windows 등)도 읽을 수 있게 diff 를 파일로 남긴다.
git diff main...HEAD > review.diff
