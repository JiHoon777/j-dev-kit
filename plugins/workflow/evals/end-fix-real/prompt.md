---
max_turns: 80
timeout_seconds: 2400
allowed_tools: [Skill, Agent, Read, Grep, Glob, Edit, Write]
---

`start` 스킬을 `002 --here`로 불러 그 절차의 9단계(판정하고 고치기)의 "고치는 법"만 따른다. 1~8단계는 끝났다. 판정 에이전트가 아래 지적을 타당하다고 했고, 7단계 스택 점검이 돌려준 "고친 뒤 할 것"은 없다. 이 실행에는 셸이 없어 git, 테스트, 검증 명령을 돌릴 수 없다. 그래서 9단계 가운데 고친 뒤 판정, Implementation Notes 기록, 커밋은 하지 않는다. 고치고 나면 지적마다 무엇을 했는지 한 줄씩 마지막 메시지에 쓰고 멈춘다. 항목 파일은 `docs/backlog/002-line-port-prototype.md`다.

🔴 꼭 고칠 것
- src/routes/line/Compose.svelte:24 — Safari 는 한글 조합을 마치는 Enter 를 `isComposing=false`, `keyCode 229`로 보내서, 조합 중인 글이 보내질 수 있다 — `event.keyCode === 229`일 때도 보내지 않는다.
- src/lib/core/line.ts:172 — `isTime`이 Date 범위(절댓값 8.64e15) 밖의 저장된 시각도 받아서, 그 시각으로 Date 를 만들면 `toISOString()` 등이 던져 화면이 멈춘다 — `isTime`이 절댓값 8.64e15 이하만 받게 하고, `line.test.ts`의 `parseLineState`에 범위 밖 시각을 버리는 테스트를 먼저 쓴다.
- src/lib/core/line.ts:91 — `normalizeLine`이 60자(UTF-16)에서 자를 때 이모지 같은 두 칸 글자의 반쪽(짝 없는 상위 서로게이트)이 남을 수 있다 — 자른 끝이 상위 서로게이트(0xD800~0xDBFF)면 그 한 칸을 더 뺀다. `line.test.ts`의 `normalizeLine`에 테스트를 먼저 쓴다.
- src/routes/line/+page.svelte:115 — 숨기기 버튼의 읽는 이름이 모두 "이 한 줄 숨기기"로 같고, 보이는 글자("숨기기")로 시작하지 않는다 — `aria-label="숨기기: {EXAMPLES[item.id].text}"`로 바꾼다.
- src/routes/line/+page.svelte:116 — 숨기기 버튼의 누르는 영역이 작다(약 40×27px) — 버튼 클래스에 `tap-target`(44px, `src/routes/layout.css`에 있는 유틸리티)을 더한다.

🟡 고려
- src/lib/core/line.ts:13 — `MINUTE`를 `time.ts`와 따로 다시 정의했다 — `time.ts`가 `MINUTE`·`HOUR`·`DAY`를 내보내고, `line.ts`는 `./time.js`에서 `MINUTE`를 가져다 쓴다.
- src/lib/core/line.ts:157 — 처음 화면 위젯의 "12분 전"(받은 때)이 카드의 "34분 전에 씀"(쓴 때)과 헷갈린다 — `lastReceived`의 meta 를 "<지역> · 12분 전에 받음", 방금이면 "<지역> · 방금 받음"으로 바꾼다. 주석과 `line.test.ts`의 기대값도 맞춘다.
- src/lib/core/line.ts:15 — `Example`·`Received`·`Sent` 타입은 이 파일 밖에서 쓰지 않는데 export 돼 있다 — 세 타입의 `export`를 지운다.
- src/routes/line/+page.svelte:112 — 숨기기 버튼을 감싼 `span`은 그리드 자리 클래스만 갖고 있다 — `span`을 지우고 그 클래스(`col-start-2 row-span-2 row-start-1 self-center`)를 버튼에 바로 준다.
- src/routes/line/+page.svelte:74 — 카드를 다시 그리려고 `card.key` 카운터를 두지만, 보낼 때마다 `card`가 새 객체라 필요 없다 — `{#key card}`로 바꾸고 `key` 필드와 카운터(25·49줄)를 지운다.
- src/routes/line/Compose.svelte:22 — 주석은 "Shift+Enter는 줄바꿈"이라고 하지만, 보낼 때 줄바꿈은 공백 한 칸이 된다(`normalizeLine`) — 주석을 실제 동작대로 고친다.
- src/lib/core/time.ts:3 — 공용 파일의 머리 주석에 다른 항목(005)의 계획이 적혀 있다 — 그 두 줄(3~4줄)을 지운다.
