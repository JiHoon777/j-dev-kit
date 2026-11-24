---
id: '012'
title: 일반 규칙은 외부 공식 스킬(web-design-guidelines, svelte, supabase, skill-creator)에 맡기고 스택을 Svelte·Node·Supabase 로 좁히기, 리뷰·검사 규칙 다듬기 (전문가 스킬 활용 리뷰 5절)
status: In Progress
labels: [chore]
priority: medium
dependencies: []
created_date: 2026-11-24
updated_date: 2026-11-24
---

## Description

조사 보고서 `docs/backlog/references/2026-11-24-전문가-스킬-활용-리뷰.md`(아래 "리뷰 보고서")와 앞 서베이 `docs/backlog/references/2026-11-23-전문가-스킬-활용.md`를 근거로 한다. 사용자가 나누지 않고 한 항목으로 하기로 정했다. 범위가 커서 묶음(A1~A7, B1~B7)을 그대로 두고 AC 도 묶음마다 쓴다. 줄 번호는 main `36e3a0e` 기준이다.

목적: 모델이 이미 알거나 공식 스킬이 더 잘 관리하는 일반 규칙은 우리 플러그인에서 지우고(리뷰 보고서 공통분모 1·4), 우리에게만 있는 규칙과 안전 장치만 남긴다. 실제로 쓰는 스택(nolmeong·todak: Svelte, Node, Supabase)에 맞춰 나머지 스택 지원을 지운다. 리뷰 보고서 5.2 의 개선 후보도 함께 고친다.

### A. 외부 공식 스킬로 바꾸기

외부 스킬 원문은 사용자와 부모 세션이 직접 확인했다(URL 은 참고 자료).

1. **일반 UI·접근성 리뷰 → `web-design-guidelines`**
   - `web-design-guidelines`(vercel-labs/agent-skills)는 Web Interface Guidelines 규칙 100여 개를 커밋에 고정해 두고 코드를 리뷰해 `file:line`으로 낸다.
   - `frontend-reviewer`의 일반 UI·접근성 항목(`frontend-reviewer.md:22` "접근성")을 지우고 그 규칙으로 본다.
   - 두 리뷰어가 겹치지 않게 나눈다. 코드에서 보이는 것은 `frontend-reviewer` + `web-design-guidelines`가 본다. `design-reviewer`는 브라우저로 열어야 보이는 것만 본다: 폭별 스크린샷, axe, 대비 측정, 키보드로 따라가기, 상태·콘솔, DESIGN.md 토큰. `design-reviewer`의 범위 바꾸기는 재지 않고 바꾼다(A6).
   - `frontend-reviewer`에 남기는 것(우리에게만 있는 것): 사용자 입력 출력(XSS, `:19`), 상태(`:20`), 중복 요청(`:21`), 비밀 값(`:23`), 새 의존성(`:24`).
2. **Svelte → 공식 `svelte` 플러그인**
   - 공식 `svelte` 플러그인(sveltejs/ai-tools `plugins/claude/svelte`, 1.0.11: `svelte-code-writer`, `svelte-core-bestpractices` 스킬, `svelte-file-editor` 에이전트, MCP·LSP)에 Svelte 기본 규칙(runes, Svelte 4 문법), autofixer, 문서 찾기를 맡긴다. 들여오는 방법은 가정을 본다.
   - 우리 `svelte.md`(start·end 둘 다)와 `frontend-reviewer` Svelte 절(`frontend-reviewer.md:27-33`)에는 SvelteKit 규칙(`$env/*/private`는 서버 파일에서만, `adapter-static`, `fail()`, `load` 권한, `{@html}`)과 "기준 브랜치 대비 새로 생긴 autofixer `issues`만 실패"(`frontend-end-check/references/svelte.md:11`)만 남긴다.
   - `svelte-file-editor` 에이전트는 쓰지 않는다. 역할로 나눈 에이전트이고(공통분모 10) `acceptEdits`로 돈다.
3. **React 는 공식 스킬로 (2026-11-24 바꿈):** 처음에는 React 지원을 지우기로 했다가 사용자가 되돌렸다. 사용자의 말: "react 는 복구 해주고 react-base-practice? next-best-practice? remix 기반의 react-route-best-practice? 같은 검증된 스킬 조사해주고 검증된 것들로 검증할 수 있게 해줘"(부모 세션이 조사해 보이고 사용자가 "보내기"로 승인).
   - React 지원(감지와 프레임워크 표, `frontend-start-check`·`frontend-end-check`, `frontend-reviewer`의 React 절, README·설명)은 남긴다. 우리가 쓴 일반 React 체크리스트(`react.md`의 일반 규칙, 리뷰어의 일반 React 항목)는 되살리지 않고 공식 자료에 맡긴다: React 는 `vercel-react-best-practices`(필요하면 `vercel-composition-patterns`, vercel-labs/agent-skills, MIT), React Router 는 `react-router`(remix-run/react-router `.agents/skills/react-router`, MIT. remix-run/agent-skills 의 방식별 스킬 셋은 2026-06-18 보관되고 이것으로 옮겨졌다), Next.js 는 Next 가 만든 `AGENTS.md`와 설치된 버전의 문서(16.3 이상 `next dev`, 낮으면 `npx @next/codemod@canary agents-md`. `next-best-practices`는 더 이상 스킬이 아니다).
   - 시작·끝 점검은 package.json 을 보고 맞는 공식 자료를 돌려주고, 설치돼 있지 않으면 설치할지를 "물을 것"으로 돌려준다. `frontend-reviewer`도 같은 자료로 보고, 우리 것만 남긴다(`'use client'`에서 서버 전용 모듈·비밀 환경 변수 불러오기, 검증 없는 서버 액션·라우트 핸들러).
   - 복사하지 않는다. 설치된 스킬을 부르고, README "있으면 쓰는 것"에 `npx skills add` 설치 안내(버전 고정)를 둔다.
   - 재지 않는다. 사용자 프로젝트에 React 프로젝트가 없어 실제 사례가 없다. 지운 React eval 사례(합성)는 되살리지 않는다.
4. **Supabase → 공식 `supabase`·`supabase-postgres-best-practices`**
   - supabase/agent-skills 의 `supabase`, `supabase-postgres-best-practices`(참고 문서 34개)에 일반 규칙(RLS·정책·RPC·뷰·스토리지·키·정책 성능 같은 것)을 맡긴다.
   - `supabase-reviewer`에는 우리 것만 남긴다: 로컬 DB 에서 두 사용자로 SQL 을 직접 돌려 확인하기(`supabase-reviewer.md:31-41`), 원격·운영 명령 금지(`:9`), 브라우저에서 바로 부르는 앱은 RLS 가 모든 권한을 지킨다는 전제(`:7`).
   - `api-reviewer`의 쿼리·인덱스 항목(`api-reviewer.md:29` N+1·인덱스·전체 스캔)도 Postgres 공식 스킬과 겹치면 넘긴다.
5. **server 를 Node.js·Supabase 로 좁히기**
   - `config-check.sh`의 Python·Go·Rust·Java·Ruby·PHP·Deno·Bun 읽기 형태(`config-check.sh:38-42`)와 그 테스트 시나리오(`scripts/test-config-check.sh`의 "언어별 읽는 형태 13가지", `os.getenv` 쓰는 하위 폴더 사례)를 지운다.
   - `server-start-check`의 감지(`SKILL.md:17` "HTTP 서버 프레임워크 의존성")와 마이그레이션 담당(`:24-29`)을 Node 도구와 Supabase CLI 로 좁힌다. `server-end-check`는 `:15`에서 같은 기준을 따른다.
   - OpenAPI·oasdiff 검사를 지운다(nolmeong·todak 에 스펙이 없다): `server-end-check/SKILL.md:3, 20, 30-35, 51`, `api-reviewer.md:30`의 oasdiff 문장, `marketplace.json`·`plugin.json` server 설명의 "API contract"·"any server language".
6. **바꾸기 전에 실제 사례로 잰다(008 방식, `plugins/*/evals/README.md`):** A1·A2·A4 는 지금 판과 바꾼 판(공식 스킬을 넣은 판)을 같은 실제 사례로 비교해, 나빠지지 않을 때만 바꾼다. 나빠지면 그 묶음은 바꾸지 않고 결과를 사용자에게 보인다.
   - Svelte·UI 쪽은 nolmeong 실제 사례(`real-line`, `real-sky`, `real-birthday`)를 쓴다.
   - Supabase 쪽은 실제 사례를 새로 만든다(nolmeong·todak 에서 Supabase 변경을 리뷰로 고친 커밋, 정답은 고친 커밋이 근거).
   - 비용은 판단 기준이 아니다(사용자 메모리).
   - A3·A5 는 쓰지 않는 스택을 지우는 것이라 재지 않는다.
   - `design-reviewer`는 잴 수 없다. 실제 사례는 코드 리뷰 사례이고, eval 환경에서는 브라우저를 쓰지 못한다. 그래서 A1 의 `design-reviewer` 범위 바꾸기(브라우저로 보이는 것만)는 재지 않고 바꾼다. A1 에서 재는 것은 `frontend-reviewer` 쪽이다.
   - A4 에서 `supabase-reviewer`·`api-reviewer` 항목 가운데 무엇을 지우고 무엇을 남길지는 이 eval 결과로 정한다.
7. **스킬 측정 방법 → `skill-creator`(anthropics/skills, Anthropic 공식).** 사용자의 말: "skill-creator 도 넣고".
   - `skill-creator`는 스킬을 만들고 고치는 일, eval, 반복 측정, 블라인드 A/B, description 트리거 튜닝까지 한다. 008 에서 직접 짠 eval 절차(`plugins/frontend/evals/README.md`, `plugins/workflow/evals/README.md`)와 겹친다.
   - 스킬을 고칠 때의 측정 방법을 `skill-creator`에 맞춰, 우리 eval 문서에서 그것과 겹치는 설명(있는 판·없는 판 비교 절차, 반복 횟수, 채점 방법 같은 것)을 줄이고 `skill-creator`를 가리킨다. 무엇이 겹치는지는 원문을 읽고 정한다.
   - `claude plugin eval`로 돌리는 실제 사례 eval(`real-*`, `compose-real-*`, `trigger-real` 등 사례 폴더)과 그 사례에만 있는 설명(nolmeong 저장소 경로, 의존 플러그인을 지운 사본, Windows 에서 셸을 주지 않는 것)은 남긴다. `skill-creator`가 이 실제 사례 eval 을 대신하는지는 원문을 읽고 판단해 적는다.
   - **우리 eval 사례 점검.** 사용자의 말: "eval 가이드가 내장되어있다면 우리 eval 관련 사례들이 잘못 작성되었을 수도 있으니까 체크하고 제대로 해야하는 상황이면 다시하면 되고".
     - `skill-creator`에 든 eval 가이드(원문)에 비춰 008~010 에서 만든 `plugins/*/evals/` 사례를 점검한다. 대상은 실제 사례(`real-*`, `compose-real-*`), 트리거(`trigger-real`), 계획 단계(`start-plan`, `start-plan-real`), 리뷰 위임(`end-fix-real`)이다. 보는 것은 대조군, 채점 기준, 반복 수, 판별력, 채점 보정이다.
     - 잘못 짜인 사례는 고쳐서 다시 돌린다. 결과가 바뀌면 그 eval 로 정했던 결정(`frontend-reviewer` Svelte 절 유지, 역할 문장 삭제, `start.md`의 두 제한 삭제, `task` description 트리거 문구, 리뷰 수정 위임을 작업 세션 재량으로 둔 것 등)을 다시 보고, 바뀐 결정은 사용자에게 묻는다.

### B. 리뷰 보고서 5.2 의 개선 후보

1. **`design-reviewer`의 미리 거르기(5.2-1, 공통분모 12):** `design-reviewer.md:3` "증거로 확인한 문제를 보고한다"와 `:24` "확인한 문제만 쓴다."(번역본 `:3`, `:26`)를 다른 리뷰어 셋과 같은 "찾은 문제를 모두 보고하되, 확인한 것과 확인 못 한 것을 나눈다. 거르기는 부른 쪽의 판정이 한다."로 바꾼다. 증거(폭, 측정값)는 확인한 것에, 무엇을 보면 확인되는지는 확인 못 한 것에 붙인다.
2. **`end.md` 3단계의 미리 거르기(5.2-2):** `end.md:49`(번역본 `:51`) "원칙에 어긋나는 지적은 하지 않는다"를 "원칙에 어긋나 보이는 지적도 보고하되, 어느 원칙과 부딪히는지 함께 적는다"로 바꾼다. 4단계 판정 규칙(`:58` "원칙에 어긋나는 지적은 틀림이다")은 그대로 둔다.
3. **`base-tests.sh`가 테스트를 못 찾으면 통과하는 것(5.2-3, 공통분모 16)**
   - `base-tests.sh:45`: 테스트 밖 소스가 바뀌었는데 고른 테스트가 0개면 통과(0)가 아니라 끝 값 2(판단 못 함)다. 테스트도 소스도 안 바뀌었으면 지금처럼 0 이다.
   - `end.md:32-33`(번역본 같은 자리): 그 결과를 사용자에게 "확인 못 함 — 이 브랜치의 테스트를 찾지 못했다(이름 규칙 밖이면 파일을 붙여 다시 돌린다)"로 보인다.
   - `base-tests.sh:30` `run_re`가 `__tests__/` 아래 파일(`src/__tests__/login.js`)과 `tests/` 아래 파일(`tests/login.js`)을 고른다. Java `FooTest.java`, C# `FooTests.cs`는 스택을 Node 로 좁혔으니 넣지 않는다.
4. **"질문 최대 3개"(5.2-4, 공통분모 15):** `create.md:64`(번역본 `:66`)와 `mockup.md:7`(번역본 `:9`)의 "최대 3개"를 지금 판과 조건판("답이 항목(시안)을 바꾸는 것만 묻는다")으로 eval 비교해 나은 쪽을 남긴다. 대조군이 실패하지 않으면 그대로 둔다(008 #20 과 같은 규칙).
5. **`server-start-check`의 일반 원칙(5.2-5, 공통분모 1):** `server-start-check/SKILL.md:35, 36, 38`(인증·객체 단위 인가·입력 검증, 트랜잭션·멱등성 키, 로그에 비밀 값 안 남기기)을 있는 판과 없는 판으로 eval 비교해, 없어도 나빠지지 않으면 지운다. A4 의 공식 스킬과 겹치니 A4 와 같은 Supabase 사례로 잰다. `:37`(스키마는 마이그레이션 파일로만)과 `:39`(원격 DB·배포 명령 금지)는 이 저장소의 운영 규칙이라 남긴다(리뷰 보고서 5.2-5).
6. **`server-end-check` 예시의 "oasdiff 없음"(5.2-6):** `server-end-check/SKILL.md:63`(번역본 `:65`). A5 로 OpenAPI 를 지우면 함께 사라진다.
7. **`frontend-end-check`가 다른 스킬의 SKILL.md 를 통째로 읽는 것(5.2-7):** `frontend-end-check/SKILL.md:35`(번역본 같은 자리)가 `frontend-start-check/SKILL.md`를 읽게 하는 대신, 개발 서버 스크립트를 바로 부르는 방법을 그 자리에 적는다.

### C. 하위 세션도 공식 플랜 모드로 계획 승인 (2026-11-24 추가)

부모 세션이 "start.md 를 플랜 모드로 바꾸는 걸 새 항목으로 만들까요?"라고 묻자 사용자가 "012 에 더하기"라고 답했다. 앞서 사용자의 말: "이건 공식 플랜 모드를 쓰는게 맞아. 하위 세션 플랜 모드".

- `start.md` 3단계: 하위 세션이어도 `EnterPlanMode`로 들어가 계획을 쓰고 `ExitPlanMode`로 승인받는다. 사용자는 그 하위 세션 창의 플랜 화면에서 승인한다. 플랜 모드 대신 텍스트로 쓰라는 문장(008 에서 넣음)을 지운다.
- `SKILL.md` 2절 4: 지시문에서 "(계획은 전문)"을 빼고 계획은 플랜 모드로 승인받는다고 쓴다. 다른 질문·승인 요청은 지금처럼 마지막 메시지에 쓴다.
- `SKILL.md` 2절 5: 하위 세션이 계획 승인을 기다리면, 부모는 계획이 나왔다고 세션 링크와 함께 알리고 확인할 점만 짧게 덧붙인다. 계획을 대신 승인하지 않는다. 사용자가 하위 세션에서 승인하면 그것이 계획 승인이다.
- 이 변경은 다음 `/task start`부터 적용된다. 012 는 이미 승인된 계획대로 진행한다.

### 이번에 빼는 것

- 리뷰 보고서 5.2-8(CLAUDE.md 에 "더하기 전에 실제 실패와 뺄 것" 규칙): 사용자 메모리에 같은 규칙이 있다.
- 리뷰 보고서 5.3 의 "제안하지 않는 것" 전부.
- `config-check.sh`와 `frontend-reviewer.md:23`의 공개 접두사 목록(`NEXT_PUBLIC_`, `REACT_APP_` 등)은 그대로 둔다. 비밀 키를 막는 안전 장치이고 지워도 얻는 것이 없다.
- `frontend-start-check`·`frontend-end-check`의 "해당 여부" 감지 목록(react, next, vue 등)은 그대로 둔다. Svelte 가 아닌 프론트엔드에도 공통 검사(diff 검사, 리뷰어)는 돈다.
- `base-tests.sh`의 Python·Ruby 이름 규칙(`test_*.py`, `_spec.rb`)은 workflow 플러그인 것이라 스택 좁히기와 상관없이 그대로 둔다.

### 가정 (계획에서 정한다)

- 외부 스킬을 들여오는 방법. 지금 확인한 것: 공식 `svelte` 플러그인은 `svelte` 마켓플레이스(sveltejs/ai-tools)에 있고 `anthropic-plugin-directory`에는 없다. 그래서 의존 플러그인으로 두려면 `marketplace.json`의 `allowCrossMarketplaceDependenciesOn`에 그 마켓플레이스가 들어가야 한다. `anthropic-plugin-directory`의 `supabase`는 supabase-community/supabase-plugin(MCP)이고, supabase/agent-skills 의 두 스킬이 함께 오는지는 확인하지 않았다. `web-design-guidelines`와 Supabase 스킬을 의존 플러그인으로 둘지, README "있으면 쓰는 것"에 설치 방법으로 둘지는 계획에서 정한다.
- 라이선스: vercel-labs/agent-skills 저장소 루트에는 LICENSE 파일이 없다(부모 세션이 클론해 확인). 그래서 `web-design-guidelines` 규칙 파일은 우리 저장소에 복사하지 않고, 설치된 스킬을 부르거나 읽게 한다. 다른 외부 스킬도 파일을 복사하려면 먼저 라이선스를 확인한다.
- 리뷰 에이전트(`tools: Read, Grep, Glob, Bash`)가 공식 스킬의 규칙을 어떻게 읽을지(스킬을 부를지, 설치된 스킬의 규칙 파일을 읽을지).
- eval 실행은 의존 플러그인을 설치하지 않는다(008). 공식 스킬을 넣은 판은 사본에 그 스킬을 직접 넣어 잰다.
- `frontend-reviewer.md:25` "억지로 끈 검사"(`as any`, `@ts-ignore`, `eslint-disable`)는 남길 목록에 없어 지운다(`code-review`가 본다). 남기려면 계획에서 바꾼다.
- Supabase 실제 사례로 쓸 커밋이 nolmeong·todak 에 없으면 계획에서 사용자에게 알리고 어떻게 할지 묻는다.
- `tests/` 아래의 도우미·fixture 를 테스트로 잘못 고르지 않게 하는 방법은 계획에서 정한다.

### 참고 자료

- 리뷰 보고서 — `docs/backlog/references/2026-11-24-전문가-스킬-활용-리뷰.md`
- 앞 서베이 — `docs/backlog/references/2026-11-23-전문가-스킬-활용.md`
- web-design-guidelines, vercel-labs/agent-skills — https://github.com/vercel-labs/agent-skills/tree/main/skills/web-design-guidelines
- 공식 svelte 플러그인, sveltejs/ai-tools — https://github.com/sveltejs/ai-tools/tree/main/plugins/claude/svelte
- supabase/agent-skills(`supabase`, `supabase-postgres-best-practices`) — https://github.com/supabase/agent-skills
- skill-creator, anthropics/skills — https://github.com/anthropics/skills/tree/main/skills/skill-creator
- 인기 스킬 목록 — https://claudemarketplace.net/skills
- Trail of Bits AGENTS.md("A checker that inspects zero items must fail", "Do not tell a reviewer to pre-filter") — https://github.com/trailofbits/skills/blob/main/AGENTS.md
- obra/superpowers RELEASE-NOTES(v6.0.0 리뷰어 거르기, v7.0.2 질문 조건) — https://github.com/obra/superpowers/blob/main/RELEASE-NOTES.md
- Matt Pocock `question-limits.md` — https://github.com/mattpocock/skills/blob/main/.out-of-scope/question-limits.md
- Matt Pocock `invocation.md`(다른 스킬 파일을 가리키지 않기) — https://github.com/mattpocock/skills/blob/main/.agents/invocation.md
- Every, 개수 상한 대신 넣을지의 조건 — https://github.com/EveryInc/compound-engineering-plugin/blob/main/docs/solutions/skill-design/confirmations-filter-by-salience-not-length-caps.md
- Hamel Husain `meta-skill.md`("Cut general knowledge") — https://github.com/hamelsmu/evals-skills/blob/main/meta-skill.md

## Acceptance Criteria

<!-- AC:BEGIN -->

- [x] #1 (A1) `frontend-reviewer`와 `web-design-guidelines`를 실제 사례로 비교한 결과가 `Implementation Notes`에 있고, 비교에서 나빠졌으므로 `frontend-reviewer`(원문·번역본)의 접근성·억지로 끈 검사 항목은 그대로이며 `web-design-guidelines`를 쓰는 곳과 README 의 설치 안내가 없다. XSS·상태·중복 요청·비밀 값·새 의존성 항목은 남아 있다(2026-11-24 바꿈, 사용자의 말: "바꾸지 않기")
- [x] #2 (A1) `design-reviewer`(원문·번역본)가 보는 것이 브라우저로 열어야 보이는 것(폭별 스크린샷, axe, 대비 측정, 키보드, 상태·콘솔, DESIGN.md 토큰)뿐이고, `frontend-reviewer`와 같은 항목을 함께 보지 않는다(재지 않고 바꾼 것이라고 `Implementation Notes`에 적혀 있다)
- [x] #3 (A2) Svelte 기본 규칙(runes, Svelte 4 문법, autofixer, 문서 찾기)은 공식 `svelte` 스킬에서 온다. 들여오는 방법(의존 플러그인, 교차 마켓플레이스 허용, README 안내 가운데 고른 것)과, 그 방법으로 실제로 설치되고 `/task start`·`/task end` 중에 공식 스킬이 불리는지 확인한 결과가 `Implementation Notes`에 있다
- [x] #4 (A2) `svelte.md`(start·end, 원문·번역본)와 `frontend-reviewer` Svelte 절에 남은 규칙이 SvelteKit 규칙(`$env/*/private`, `adapter-static`, `fail()`, `load` 권한, `{@html}`)과 "기준 브랜치 대비 새로 생긴 autofixer issues 만 실패"뿐이다. `$derived`·`$effect`·Svelte 4 문법 같은 Svelte 기본 규칙은 없다
- [x] #5 (A2) `grep -rn 'svelte-file-editor' plugins i18n`의 결과가 "쓰지 않는다"는 문장뿐이거나 비어 있다
- [x] #6 (A3) `react.md`(원문·번역본)와 `frontend-reviewer` React 절에 우리가 쓴 일반 React 규칙(훅 규칙, 파생 state, 정리 함수, 인덱스 `key` 등)이 없고, React 는 `vercel-react-best-practices`(·`vercel-composition-patterns`), React Router 는 `react-router` 스킬, Next.js 는 `AGENTS.md`와 설치된 버전의 문서로 본다고 적혀 있다. 설치돼 있지 않으면 설치할지 묻는다. 리뷰어에 `'use client'`·서버 액션 안전 장치가 남아 있다. README 두 개 "있으면 쓰는 것"에 버전을 고정한 설치 명령이 있다. `reviewer-react`·`compose-code-review`·`compose-with-stack` eval 폴더는 없다(재지 않고 들였다고 `Implementation Notes`에 적혀 있다)
- [x] #7 (A4) `supabase-reviewer`(원문·번역본)에 로컬 DB 에서 두 사용자로 SQL 을 직접 확인하기, 원격·운영 명령 금지, RLS 전제, 공식 Supabase 스킬 규칙으로 본다는 문장이 있다. `supabase-reviewer` "볼 것" 1~11 과 `api-reviewer` 9(쿼리·인덱스)마다 지웠는지 남겼는지와 그 근거(A6 eval 결과)가 `Implementation Notes`에 목록으로 있고, 두 파일은 그 목록대로다
- [x] #8 (A5) `config-check.sh`가 읽는 형태가 Node 형태(`process.env`, `import.meta.env`)와 Supabase Edge Functions 의 `Deno.env.get`(승인 때 남기기로 함)뿐이고, `scripts/test-config-check.sh`에 다른 언어를 읽는 시나리오가 없으며(다른 언어 형태를 보지 않는지 확인하는 줄만 있다) 테스트가 모두 통과한다 (2026-11-24 바꿈: 승인 조건 2)
- [x] #9 (A5) `server-start-check`·`server-end-check`(원문·번역본)의 감지와 마이그레이션 담당이 Node 도구와 Supabase CLI 만 말하고, `grep -rni 'oasdiff\|openapi' plugins i18n README.md README.en.md .claude-plugin`이 비어 있다. server `plugin.json`·`marketplace.json`·README 설명에 "any server language"와 API 스펙 검사가 없다
- [x] #10 (A6) A1·A2·A4 마다 지금 판과 바꾼 판을 실제 사례(Svelte·UI 는 nolmeong `real-*`, Supabase 는 새로 만든 실제 사례)로 비교한 방법과 결과가 `Implementation Notes`에 있다. 새 Supabase 사례가 `plugins/server/evals/`에 커밋되어 있다. 바꾼 묶음은 비교에서 나빠지지 않은 것뿐이고, 나빠진 묶음은 바꾸지 않았다고 적혀 있다
- [x] #11 (A7) `plugins/frontend/evals/README.md`·`plugins/workflow/evals/README.md`가 스킬을 고칠 때의 측정 방법으로 `skill-creator`를 가리키고, `skill-creator`와 겹치는 설명이 없다. 실제 사례 eval 폴더와 그 사례에만 있는 설명은 남아 있다. `skill-creator` 원문에서 무엇이 겹친다고 봤는지, `skill-creator`가 실제 사례 eval 을 대신하는지에 대한 판단과 근거가 `Implementation Notes`에 있다
- [x] #12 (A7) `plugins/*/evals/`의 실제 사례·트리거·계획 단계·리뷰 위임 사례마다 `skill-creator` eval 가이드에 비춰 대조군, 채점 기준, 반복 수, 판별력, 채점 보정을 점검한 결과가 `Implementation Notes`에 있다. 잘못 짜였다고 본 사례는 고쳐 다시 돌린 결과가 있고, 결과가 바뀌어 다시 본 결정은 사용자의 답과 함께 적혀 있다
- [x] #13 (B1) `design-reviewer`(원문·번역본)에 "확인한 문제만"이 없고, 찾은 문제를 모두 확인한 것과 확인 못 한 것으로 나눠 보고하고 거르기는 부른 쪽이 한다고 적혀 있다
- [x] #14 (B2) `end.md` 3단계(원문·번역본)에 "원칙에 어긋나는 지적은 하지 않는다"가 없고, 원칙에 어긋나 보이는 지적도 부딪히는 원칙과 함께 보고한다고 적혀 있다. 4단계 판정 규칙은 그대로다
- [x] #15 (B3) 테스트 밖 소스만 바뀌고 테스트가 없는 브랜치에서 `base-tests.sh`가 끝 값 2 로 끝나고, `src/__tests__/login.js`·`tests/login.js`를 바꾼 브랜치에서는 그 파일을 고른다. 두 경우가 `scripts/test-base-tests.sh`에 있고 통과한다
- [x] #16 (B3) `end.md` 2단계(원문·번역본)가 테스트를 찾지 못한 결과를 사용자에게 "확인 못 함"과 이유로 보인다고 적혀 있다
- [x] #17 (B4) `create.md`·`mockup.md`의 지금 문구와 조건판을 eval 로 비교한 방법과 결과가 `Implementation Notes`에 있고, 두 파일(원문·번역본)은 나은 쪽이다
- [x] #18 (B5) `server-start-check` "지킬 것"의 일반 원칙 셋이 있는 판과 없는 판의 비교 방법과 결과가 `Implementation Notes`에 있고, 없어도 나빠지지 않은 것만 지워져 있다. 마이그레이션 파일 규칙과 원격 명령 금지는 남아 있다
- [x] #19 (B6) `server-end-check` 보고 형식 예시(원문·번역본)에 "oasdiff 없음"이 없다
- [x] #20 (B7) `frontend-end-check`(원문·번역본)가 다른 스킬의 SKILL.md 를 읽게 하지 않고, 개발 서버를 띄우는 명령과 포트 규칙을 그 자리에 적는다
- [x] #21 (C) `start.md` 3단계(원문·번역본)에 플랜 모드 대신 계획을 마지막 메시지에 쓰라는 문장이 없고, 하위 세션도 `ExitPlanMode`로 승인받는다고 적혀 있다. `SKILL.md` 2절 4(원문·번역본)의 지시문에 "(계획은 전문)"이 없고 계획은 플랜 모드로 승인받는다고 적혀 있으며, 2절 5 에 부모가 계획을 대신 승인하지 않고 링크와 확인할 점만 알린다고 적혀 있다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [x] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [x] #2 원문(`plugins/`)을 고친 곳은 번역본(`i18n/en/`)도 같이 고쳤다
- [x] #3 고친 플러그인(workflow, frontend, server)마다 `plugin.json` `version`을 올렸고, README 두 개와 `marketplace.json` 설명을 맞췄다

<!-- DOD:END -->

## Implementation Plan

### 승인 (2026-11-24)

부모 세션이 전한 사용자의 말: "그렇게 승인"(부모 세션의 질문: "012 계획을 추천안과 Supabase 확인 조건을 붙여 승인할까요?").

1. Supabase 사례: todak 002 실제 사례에 합성 사례(`supabase-seeded`)를 더한다. 합성 사례는 퀴즈처럼 쉬울 수 있으니(obra 의 경고) 리뷰어 항목을 지우는 결정은 실제 사례와 합성 사례 **모두**에서 나빠지지 않을 때만 한다. 합성 사례는 Notes 에 "합성"이라고 밝힌다.
2. `config-check.sh`의 `Deno.env.get`은 남긴다(Supabase Edge Functions).
3. B5 는 todak 010 을 계획하는 사례로 잰다.
4. `supabase@anthropic-plugin-directory`가 스킬 말고 함께 들여오는 것을 확인하고, 원격 Supabase 에 닿는 MCP 도구가 붙으면 의존 플러그인으로 두지 않고 README 안내로 둔다. 확인 결과는 Notes 의 "들여오는 방법"에 있다(원격 MCP 가 붙어서 README 안내로 정함. 계획 19 의 Supabase 부분이 바뀜).
5. start 6단계까지 마치면 보고하고 멈춘다. 중간에 결정이 필요하거나 008~010 결정을 다시 봐야 하는 결과가 나와도 멈춘다.

### 1. 무엇을 하나

일반 규칙은 공식 스킬(web-design-guidelines, svelte, supabase 두 개, skill-creator)에 맡기고, 우리 플러그인에는 우리에게만 있는 규칙과 안전 장치만 남긴다. 스택은 Svelte·Node·Supabase 로 좁힌다(React, 다른 서버 언어, OpenAPI 를 지운다). 리뷰 보고서 5.2 의 1~7 도 고친다. 재는 묶음(A1·A2·A4·B4·B5)은 eval 로 "나빠지지 않을 때만" 바꾼다.

이번에 빼는 것: 항목의 "이번에 빼는 것" 그대로. 그리고 `svelte-file-editor` 에이전트.

### 2. 도구와 단계

| 일 | 도구 |
| --- | --- |
| 스크립트 고치기(B3, A5) | bash, `scripts/test-*.sh` 테스트를 먼저 고친다(TDD) |
| 재기(A6, B4, B5, A7 재실행) | `claude plugin eval`(008 방식: 판마다 플러그인 사본, `--model opus --judge-model sonnet`, 사례마다 5회, 셸 없음, `--no-publish --threshold 0 --json`). 분석은 `skill-creator`의 방식(평균 ± 표준편차, 판별력 없는 채점, 들쭉날쭉한 사례 찾기, 채점 기준 자체 비판)을 따른다 |
| 공식 스킬 읽기 | 이미 설치된 원문을 읽는다: `svelte@svelte` 1.0.11, `supabase@anthropic-plugin-directory` 0.1.17(두 스킬 `supabase`, `supabase-postgres-best-practices`가 함께 온다. 확인함), `skill-creator`(claude-plugins-official, Apache-2.0). `web-design-guidelines`는 플러그인이 없고 `npx skills add vercel-labs/agent-skills`로만 설치된다(MIT 는 README 에만, 규칙은 스킬 폴더의 `references/command.md`에 묶여 있다). 우리 저장소에는 복사하지 않는다. eval 사본에만 넣는다(커밋하지 않음) |
| 설치·호출 확인(AC #3) | 따로 둔 설정 폴더(`CLAUDE_CONFIG_DIR`)에 이 워크트리를 로컬 마켓플레이스로 더해 설치해 보고, eval 실행 기록의 `Skill` 호출(`tool_used` 채점)로 공식 스킬이 불리는지 본다 |
| 검증 | `claude plugin validate . && bash scripts/check-repo-rules.sh` |

설치할 것: 없음(전부 설치돼 있다). `evals/nolmeong-src.local`, `plugins/server/evals/todak-src.local`(커밋 안 함)만 만든다.

### 3. 바꿀 파일과 순서

**1단계 — 재지 않는 것 먼저(eval 의 "지금 판"을 이 상태로 둔다).** 원문과 번역본을 함께 고친다.

1. B3: `scripts/test-base-tests.sh`에 사례 셋을 먼저 넣고 실패를 본다. (a) 테스트 밖 소스만 바뀜 → 끝 값 2 와 "바뀐 테스트 없음", (b) `src/__tests__/login.js`를 고른다, (c) `tests/login.js`를 고르고 `tests/helpers/x.js`·`tests/fixtures/x.js`는 고르지 않는다. 그다음 `base-tests.sh`를 고친다.
   - `run_re`에 더하는 것: `__tests__/`·`tests/`·`test/` 아래의 `.js/.mjs/.cjs/.ts/.mts/.cts/.jsx/.tsx` 파일(Jest 기본 `testMatch`, Node `--test` 기본 `test/**`에 맞춘다). 단 경로에 `fixtures?/`, `__fixtures__/`, `helpers?/`, `utils?/`, `mocks?/`, `__mocks__/`, `support/`, `testdata/`가 있거나 파일 이름이 `_`로 시작하거나 `setup`·`helper`·`util`·`fixture`를 담으면 빼서 도우미로 둔다.
   - 0개일 때: 테스트 밖 변경이 있으면 끝 값 2. 문서(`*.md`)만 바뀌었으면 지금처럼 0(가정 3).
   - `end.md` 2단계(원문·번역본): 이 경우를 "확인 못 함 — 이 브랜치의 테스트를 찾지 못했다(이름 규칙 밖이면 파일을 붙여 다시 돌린다)"로 사용자에게 보인다.
2. A5: `scripts/test-config-check.sh`에서 다른 언어 시나리오(13가지 형태, `os.getenv` 하위 폴더 사례)를 Node 형태로 바꾸고, `config-check.sh`의 `ENV_RE`를 `process.env.X`, `process.env["X"]`, `import.meta.env.X`로 줄인다(질문 2 의 답에 따라 `Deno.env.get`). `server-start-check`의 감지를 "Node HTTP 서버 의존성(express, fastify, hono, koa, @nestjs/core, SvelteKit 서버 파일)"으로, 마이그레이션 담당을 "Node 도구(prisma, drizzle-kit, knex 등)와 Supabase CLI"로 좁힌다. `server-end-check`의 OpenAPI·oasdiff 절과 설치 목록, `api-reviewer` 10 의 oasdiff 문장(B6 예시 포함)을 지운다. server `plugin.json`·`marketplace.json`·README 두 개의 설명에서 "any server language", "API contract/스펙"을 뺀다.
3. A3: `react.md`(원문·번역본), 프레임워크 표의 React 줄, `frontend-end-check:18`의 React 문장, `frontend-reviewer` React 절과 description 의 "React/Next", README 의 React 문구와 Vercel react-best-practices 줄, `marketplace.json`·`plugin.json`의 React, eval 폴더 `reviewer-react`·`compose-code-review`·`compose-with-stack`과 evals README 표의 줄을 지운다.
4. B1: `design-reviewer` description·보고 형식을 다른 리뷰어 셋의 문장으로. B2: `end.md` 3단계 3 을 "원칙에 어긋나 보이는 지적도 보고하되, 어느 원칙과 부딪히는지 함께 적는다"로. B7: `frontend-end-check` 3절이 `frontend-start-check/SKILL.md`를 읽게 하지 않고, 포트 규칙(항목 `### 포트` → `.claude/launch.json`)과 `bash ${CLAUDE_SKILL_DIR}/../frontend-start-check/scripts/dev-server.sh <포트> [명령…]`을 그 자리에 적는다(스크립트 자체는 옮기지 않는다).
5. A1 의 `design-reviewer` 범위: 브라우저로 열어야 보이는 것(폭별 스크린샷, axe, 대비 측정, 키보드로 따라가기, 상태·콘솔, DESIGN.md 토큰)만 남긴다. 재지 않고 바꾼다고 Notes 에 적는다.
6. 커밋. 검증 명령 통과.

**2단계 — eval 방법부터 바로잡기(A7).** 새 사례를 짜기 전에 한다. 새 사례가 고친 방법을 따르게 하려는 것이다.

7. `skill-creator` 원문(SKILL.md, `agents/grader.md`·`analyzer.md`·`comparator.md`, `scripts/run_eval.py`)과 우리 eval README 둘을 견줘 겹치는 것을 정한다. 지금 본 것: 겹치는 것은 비교 판 두기(옛 판 스냅숏 대 새 판), 채점 기준 쓰기와 판별력 보기, 반복과 평균 ± 표준편차, 트리거 eval 의 부를 것·부르지 않을 것(8~10 개씩, 비슷하지만 아닌 요청). 겹치지 않는 것은 `claude plugin eval`로 플러그인 에이전트·스크래치 git 저장소를 돌리는 실행, 비공개 저장소에서 꺼내는 사례, 의존 플러그인 지운 사본, Windows 셸 없음, 사람 라벨로 LLM 채점 보정. 그래서 `skill-creator`는 측정 방법의 기준이고 실제 사례 eval 을 대신하지 못한다고 본다(구현에서 원문을 다시 읽고 확정해 Notes 에 근거와 함께 적는다).
8. 두 README 를 고친다: 측정 방법(판 두기, 반복, 채점, 분석)은 `skill-creator`를 가리키고, 사례 표·nolmeong/todak 경로·사본 만들기·셸 없음·명령 예만 남긴다.
9. 점검: `real-*`, `compose-real-*`, `trigger-real`, `start-plan`, `start-plan-real`, `end-fix-real`(그리고 A2 로 재는 절이 바뀌는 `reviewer-svelte`)마다 대조군, 채점 기준, 반복 수, 판별력, 채점 보정을 표로 본다. 이미 보이는 것: `reviewer-svelte`·`start-plan`은 008 에서 모든 판이 만점(판별력 없음)이었다. `skill-creator` 분석 기준으로 "판과 상관없이 늘 통과하는 채점"이다. 잘못 짜였다고 본 사례는 고쳐 다시 돌리고, 결과가 008~010 의 결정을 바꾸면 그 결정과 새 결과를 들고 사용자에게 묻는다(이 세션이 멈춰서 묻는다).

**3단계 — 사례 만들기.**

10. Supabase 실제 사례(질문 1): `plugins/server/evals/real-todak-002/`. todak 002 리뷰 전 커밋(`a6abd0a` 무렵, 고친 커밋 `cf61e36`·`e2325f5`·`40670e5` 직전)을 `git archive`로 꺼낸다(todak 코드는 커밋하지 않는다). 정답: 고친 커밋이 근거인 Supabase 를 부르는 코드의 지적(재시도 끄기·시간 제한, 응답 모양 검사, SSR 뒤 다시 부르기)과, 010 항목이 "002 의 리뷰에서 넘어온 것"으로 적은 셋(`document`·`format_version` 제약, `service_role` 권한, `TRUNCATE`와 행 트리거). 그대로 둘 것: 공개본 `using (true)`를 🔴 로 올리지 않기.
11. (질문 1 에서 고르면) 합성 사례 `plugins/server/evals/supabase-seeded/`: todak 010 이 계획한 모양(작업본, 공개 함수, 이력 트리거, 권한)을 따라 쓰되 `supabase-reviewer` "볼 것" 1~11 과 `api-reviewer` 9 에 하나씩 실수를 심는다. 맞는 파일 하나를 함께 둬 헛지적을 본다.
12. B4 사례 둘: `create`(실제 항목에서 사용자가 정한 것이 4 개 넘게 기록된 요청 하나, 하나 이하인 요청 하나. 출처는 j-dev-kit·todak·nolmeong `docs/done`의 "사용자 결정/사용자의 말"), `mockup`(nolmeong `docs/design`의 시안 기록에서 사용자가 답한 브리프 하나). 채점: 기록된 사용자 결정을 물었는가, 코드·문서로 답할 수 있는 것을 묻지 않았는가.
13. B5 사례(질문 3): todak 010 을 계획하는 사례. `server-start-check`를 부르고 계획을 쓴다. 채점: 공개 함수의 호출자 확인·권한, 여러 쓰기(공개본 바꾸기 + 이력)를 한 트랜잭션으로, 비밀 값을 로그에 남기지 않기가 계획에 있는가.

**4단계 — 재고 바꾸기(A6, B4, B5).** 판마다 사본을 만들어 백그라운드로 돌린다(끝나는 알림을 기다린다).

14. A1: 지금 판 대 "접근성(4)·억지로 끈 검사(7)를 빼고 `web-design-guidelines` 규칙으로 본다"는 판. A2: 지금 판 대 "Svelte 절을 SvelteKit 규칙 + 새 autofixer issues 만 남기고 `svelte-core-bestpractices`·`svelte-code-writer`를 부른다"는 판. 둘 다 nolmeong `real-line`·`real-sky`·`real-birthday`, 5 회씩. 둘 다 바꾸면 합친 판을 한 번 더 재서 지금 판보다 낮지 않은지 본다.
15. A4: `supabase-reviewer` 지금 판 대 "공식 스킬 두 개를 부르고, 두 사용자 SQL·원격 명령 금지·RLS 전제만 남긴" 판. 사례 10(과 11). `api-reviewer` 9 는 사례 11 로 같은 방식. 항목마다 지움/남김과 근거를 Notes 에 목록으로 쓰고 두 파일을 그대로 맞춘다.
16. B4: 지금 문구 대 조건판. 대조군(지금 문구)이 실패하지 않으면 그대로 둔다. B5: 원칙 셋이 있는 판 대 없는 판. 없어도 낮지 않으면 지운다(37·39 줄은 남긴다).
17. 판정 규칙(008 과 같다): 바꾼 판의 세 사례(또는 그 묶음의 사례) 평균이 지금 판보다 낮지 않으면 바꾼다. 표준편차를 함께 적는다. 비용은 기록만 하고 판정에 쓰지 않는다(사용자 메모리). 대조군이 늘 만점이거나 0 인 사례는 판별력이 없다고 적고, 그 사례로는 정하지 않는다.
18. 나빠진 묶음은 바꾸지 않고, 결과를 사용자에게 보이고 Notes 에 적는다.

**5단계 — 들여오기와 마무리.**

19. 들여오는 방법(가정 1): Supabase 는 server `plugin.json`·`marketplace.json`의 `dependencies`에 `supabase@anthropic-plugin-directory`(이미 허용된 마켓플레이스). Svelte 는 의존 플러그인으로 두지 않고 README "있으면 쓰는 것"에 남긴다. `svelte` 마켓플레이스를 더하지 않은 사용자에게는 plugin.json 의존성이 "설치는 되고 플러그인이 로드되지 않는" 결과를 낸다고 문서에 있어서다. 대신 `frontend-start-check`의 svelte 참고가 공식 스킬이 없으면 설치 명령을 "물을 것"으로 돌려준다. `web-design-guidelines`는 플러그인이 없으니 README 에 `npx skills add vercel-labs/agent-skills --skill web-design-guidelines`(버전 고정)로 둔다.
20. 리뷰 에이전트가 공식 스킬을 읽는 방법(가정 2): `tools`에 `Skill`을 더하고 "`<스킬>` 스킬을 부른다. 부를 수 없으면 그 규칙으로 본 척하지 않고 '확인 못 한 것'에 적는다"로 쓴다. eval 에서 `Skill` 호출이 안 되면 설치된 스킬 파일을 Glob 으로 찾아 읽는 방식으로 바꾸고 Notes 에 적는다.
21. `skill-creator`는 저장소 개발용이라 의존 플러그인으로 두지 않는다(evals README 가 가리키기만).
22. 버전: workflow 0.13.0 → 0.14.0, frontend 0.10.0 → 0.11.0, server 0.6.0 → 0.7.0. README 두 개·`marketplace.json`·`plugin.json` 설명을 맞춘다.
23. `simplify`, 검증 명령, AC 판정 에이전트, Notes, 커밋.

### 4. 성공 기준(AC 마다 확인)

| AC | 확인 |
| --- | --- |
| #1, #2, #13, #14, #16, #19, #20 | 원문·번역본 grep(문장 있음/없음) + 판정 에이전트 |
| #3 | Notes 에 고른 방법, 격리 설정 폴더의 설치 결과, eval 기록의 `Skill` 호출 |
| #4 | grep `\$derived\|\$effect\|export let\|on:click\|<slot>\|\$app/stores`가 svelte.md 둘·frontend-reviewer Svelte 절에서 비어 있음 |
| #5 | `grep -rn 'svelte-file-editor' plugins i18n` |
| #6 | 파일·폴더 없음, `grep -rni react` 결과가 감지 목록·공개 접두사뿐 |
| #7, #10, #17, #18 | eval JSON 의 점수와 Notes 의 표, 판정 에이전트 |
| #8, #15 | `bash scripts/test-config-check.sh`, `bash scripts/test-base-tests.sh` 출력 |
| #9 | `grep -rni 'oasdiff\|openapi' plugins i18n README.md README.en.md .claude-plugin` 빈 결과 |
| #11, #12 | Notes 의 겹침 판단과 점검 표, 다시 돌린 결과, 판정 에이전트 |
| DoD | 검증 명령 출력, `check-repo-rules.sh`(번역본·설명 일치·버전) |

### 5. 스택 점검의 "플랜에 넣을 것"

없음(frontend·server 점검 모두 `stack: 없음`이라 해당 없음).

### 6. 가정과 정한 것

1. 들여오는 방법: 위 19. 근거는 공식 문서(plugins/dependencies, troubleshooting)와 설치된 플러그인 확인.
2. 리뷰 에이전트는 `Skill` 도구로 공식 스킬을 부른다(위 20). `skills:` 미리 불러오기는 없는 스킬을 디버그 로그에만 남기고 조용히 건너뛰어서 쓰지 않는다.
3. `base-tests.sh`: 문서(`*.md`)만 바뀐 브랜치는 0 으로 둔다. 테스트로 증명할 수 없는 변경이라 매번 "확인 못 함"을 보이면 소음이 된다. 그 밖의 테스트 밖 파일이 바뀌었는데 테스트를 못 찾으면 2.
4. `frontend-reviewer` 7(억지로 끈 검사)은 항목 가정대로 지운다(`code-review`가 본다). A1 판에 함께 넣어 잰다.
5. eval 은 의존 플러그인을 설치하지 않는다. 공식 스킬은 사본 `skills/`에 넣거나 사례의 `plugins:`로 설치된 플러그인 폴더를 가리킨다. 사본은 `.claude/.local/` 아래에 두고 커밋하지 않는다.
6. 판정 규칙은 008 과 같다(평균이 낮지 않으면 바꿈). 새 기준을 만들지 않는다.
7. 실행 결과(JSON, 사본)는 `.claude/.local/012/`에 두고, 방법과 결과 표만 항목 Notes 에 적는다.

## Implementation Notes

### Baseline

- 2026-11-24, `claude plugin validate . && bash scripts/check-repo-rules.sh` 종료 코드 0. 이미 실패하던 것 없음.

### 스택 점검

- frontend·server start check: CLAUDE.md `stack: 없음`이라 해당 없음.

### 들여오는 방법 (승인 조건 4)

- `supabase@anthropic-plugin-directory` 0.1.17(설치된 캐시)을 봤다. 스킬 `supabase`, `supabase-postgres-best-practices` 둘과 함께, Claude Code 용 `plugin.json`의 `mcpServers`(`agents/claude/.mcp.json`)가 원격 HTTP MCP 서버 `https://mcp.supabase.com/mcp`를 붙인다. 훅과 Claude Code 용 에이전트는 없다.
- 원격 Supabase 에 닿는 MCP 도구가 붙으므로 의존 플러그인으로 두지 않는다. Svelte, web-design-guidelines 와 같이 README "있으면 쓰는 것"에 설치 방법으로 둔다(지금 README 의 "같이 오는 MCP 는 `/mcp`에서 끈다"도 남긴다).
- `svelte@svelte`: plugin.json 의존성이 풀리지 않으면(사용자가 `svelte` 마켓플레이스를 더하지 않았으면) 설치는 되지만 우리 플러그인이 로드되지 않는다(code.claude.com/docs/en/plugins/dependencies, troubleshooting). 그래서 README 안내로 둔다.
- `web-design-guidelines`: 플러그인이 없다(vercel-labs/agent-skills 에 `.claude-plugin/` 없음, `npx skills add`로만 설치). README 안내로 둔다.

### 1단계: 재지 않는 것 (2026-11-24)

- **B3** `base-tests.sh`: 테스트를 먼저 넣고 실패를 봤다(`bash scripts/test-base-tests.sh` → "19 개 중 15 개 맞음". 새 사례 넷이 "바뀐 테스트 없음."으로 0 이 나와 틀림). 고친 뒤 "19 개 중 19 개 맞음".
  - 새 사례: 소스만 바뀌고 테스트를 못 찾음 → 2, 문서만 바뀜 → 0("문서만 바뀜. 건너뛴다."), `src/__tests__/login.js`를 고름, `tests/login.js`를 고르고 `tests/helpers/x.js`(고르면 기준에서도 통과 → 1)·`tests/fixtures/data.js`(고르면 HEAD 에서 실패 → 2)는 고르지 않음.
  - 도우미를 가르는 방법(계획 가정): `__tests__/`·`tests/`·`test/` 아래의 JS·TS 파일만 더 고르고, 그 아래라도 `fixtures`·`helpers`·`utils`·`mocks`·`support`·`testdata` 폴더와 `_`·`setup`·`helper`·`util`·`fixture`가 든 이름은 뺀다.
- **A5** `config-check.sh`: `scripts/test-config-check.sh`의 13가지 언어 사례를 Node·Vite·Deno 3가지(실패해야 함)와 다른 서버 언어 8가지(보지 않아야 함)로 바꾸고, 하위 폴더 사례를 `process.env`로 바꿨다. 고치기 전 "21 개 중 20 개 맞음"(다른 언어 8 줄이 나옴), 고친 뒤 "21 개 중 21 개 맞음". `Deno.env.get`은 승인대로 남겼다(Supabase Edge Functions).
- **A5** 문서: `server-start-check` 감지를 package.json 의 Node HTTP 서버 의존성으로, 마이그레이션 담당을 Node 도구와 Supabase CLI 로. `server-end-check`의 API 스펙 절·oasdiff 설치·근거, `api-reviewer` 10 의 oasdiff 문장을 지웠다. `grep -rni 'oasdiff\|openapi' plugins i18n README.md README.en.md .claude-plugin` 결과 없음.
- **B6**: 예시 "건너뜀: oasdiff 없음"을 지웠다(원문·번역본).
- **A3**: `react.md` 둘, eval 폴더 셋(`reviewer-react`, `compose-code-review`, `compose-with-stack`), 프레임워크 표의 줄, `frontend-end-check`의 React 문장, `frontend-reviewer` React 절과 description 의 "React/Next", README·`marketplace.json`·`plugin.json`의 React, evals README 의 두 줄을 지웠다. README 의 "Vercel react-best-practices" 줄은 같은 설치 명령(`vercel-labs/agent-skills`)의 web-design-guidelines 줄로 바꿨다(5단계에서 다시 본다). `grep -rni react plugins i18n --include=*.md`에 남은 것은 감지 목록과 공개 접두사뿐이다.
- **B1·A1(design-reviewer)**: 보고 형식을 다른 리뷰어 셋의 문장으로, 볼 것을 브라우저로 열어야 보이는 것(화면의 상태와 콘솔, 폭별 스크린샷, 화면에서 잰 DESIGN.md 토큰, axe·잰 대비·키보드·포커스)으로 좁혔다. 코드에서 보이는 것은 `frontend-reviewer`와 `web-design-guidelines`가 본다고 적었다. **재지 않고 바꿨다**(eval 환경에서 브라우저를 쓸 수 없다).
- **B2**: `end.md` 3단계 3 을 "원칙에 어긋나 보이는 지적도 보고하되, 어느 원칙과 부딪히는지 함께 적는다"로. 4단계 "원칙에 어긋나는 지적은 틀림이다"는 그대로.
- **B3** `end.md` 2단계: `바뀐 테스트 없음.` + 끝 값 2 를 4단계에서 "확인 못 함 — 이 브랜치의 테스트를 찾지 못했다(이름 규칙 밖이면 파일을 붙여 다시 돌린다)"로 보인다.
- **B7**: `frontend-end-check` 3절이 `frontend-start-check/SKILL.md`를 읽지 않고, 포트 규칙과 `dev-server.sh`를 부르는 명령을 그 자리에 적는다.
- 버전: workflow 0.14.0, frontend 0.11.0, server 0.7.0.

### A7: eval 사례 점검 (2026-11-24)

새 general-purpose 에이전트가 `skill-creator` 원문(SKILL.md, agents/grader·analyzer·comparator, references/schemas, scripts/run_eval.py)에 비춰 사례를 점검했다(파일 안 고침). 요지는 `.claude/.local/012/a7-audit.md`.

| 사례 | 판정 | 핵심 |
| --- | --- | --- |
| `reviewer-svelte` | 결정 근거로 쓰지 말 것 | 두 판 모두 1.0(008). `finds-*` 정규식은 파일·줄만 맞으면 통과 |
| `real-line`·`real-sky`·`real-birthday` | 고칠 것 | 정답 24개 중 Svelte 절에 해당하는 것 0개라 Svelte 절(008)과 A2 를 직접 재지 못한다. A1 은 접근성 정답 8개라 쓸 만하다. 008 결정 둘(Svelte 절 -0.002 로 유지, 역할 문장 +0.017 로 삭제)은 표준편차 0.03~0.17 안의 차이로 갈렸다 |
| `compose-real-*` | 고칠 것 | 리뷰어 수와 내용이 함께 바뀐다, 과정 채점이 한쪽 점수에만 들어간다, `keep-*`가 🔴 없는 형식에서 늘 통과 |
| `trigger-real` | 고칠 것(작게) | 부르지 말 것 n07~n10 이 비슷하지만 아닌 요청이 아니다. 서베이 문구는 실패한 질의 하나로 넣고 같은 질의로 확인했다 |
| `start-plan` | 결정 근거로 쓰지 말 것 | 세 판 만점 |
| `start-plan-real` | 고칠 것 | `plans-*`가 질문으로 다룬 것도 PASS 라 질문이 많을수록 점수가 오른다. 008 의 "질문 최대 3개" 삭제 쪽으로 기울어 있다 |
| `end-fix-real` | 위임 결정 근거로 쓰지 말 것 | 프롬프트가 고칠 방법을 다 적었고 9회 모두 다 고쳤다. 결정은 사용자 방침이었다 |

판단: `skill-creator`는 측정 방법(기준선, 채점 품질, 분석, 사람 검토)의 기준이고 `claude plugin eval` 실제 사례 eval 을 대신하지 못한다. 근거: 서브에이전트에 스킬 경로를 주는 실행이라 플러그인 로드·네임스페이스 에이전트·Skill 도구·의존성·훅·`allowed_tools`를 시험하지 않는다(008 의 `!` 셸 줄 실패와 의존성 미충족은 그 경로로 보이지 않는다). 재는 대상이 SKILL.md 하나이고 scaffold·`tool_used`·파일 채점·judge 모델·`costUsd`가 없다. `run_eval.py`는 파이프에 `select.select`를 써 네이티브 Windows 에서 돌지 않을 가능성이 높다(실행 확인 안 함).

### eval 진행 (2026-11-24)

- 계획과 달라진 것: A7 점검 결과를 기다리지 않고 A6 실행을 먼저 시작했다(아래). 점검이 판정 방법이나 사례를 바꾸면 다시 돌린다.
- Supabase 실제 사례 `plugins/server/evals/real-todak-002/`: todak 002 리뷰 전 `b902a6a`, 기준 `ecc333d`. 정답 셋(재시도·시간 제한, 응답 모양 검사, `document`·`format_version` 제약)과 그대로 둘 것 하나(공개 읽기 `using (true)`를 🔴 로 올리지 않기). 항목 파일에 리뷰 전부터 적혀 있던 둘(SSR 뒤 브라우저가 다시 부르기, `service_role` 권한)은 리뷰어가 옮겨 적기만 해도 맞으니 정답에서 뺐다. 지금 판 1회 시험: 0.6(제약·공개 읽기 통과, 재시도·모양 검사 놓침).
- 합성 사례(실제 리뷰 아님) `plugins/server/evals/supabase-seeded/`(볼 것 1~11 에 실수 하나씩, 12개 채점 + 맞게 쓴 `case_sources`), `api-seeded/`(api-reviewer 9 의 실수 둘). todak 010 모양을 따라 지어 썼다.
- `web-design-guidelines` 원문 두 파일(SKILL.md 2,077 바이트, `references/command.md` 8,055 바이트)을 raw.githubusercontent.com 에서 `.claude/.local/012/ext/`로 받았다(eval 사본에만 넣는다, 커밋 안 함). `command.md`의 SHA-256 이 SKILL.md 에 고정된 `d246b026…0234`와 같다.
- 실행 중: frontend 네 판(지금, A1, A2, A1+A2) × `real-*` 3 × 5회, server 두 판(지금, A4) × 사례 3 × 5회. Opus 시험, sonnet 채점(3표), `.claude/.local/012/results/`.

### C: 하위 세션 플랜 모드 (2026-11-24 추가 범위)

- `start.md` 3단계(원문·번역본): "지시문이 질문과 승인 요청을 마지막 메시지에 쓰라고 하면 … 플랜 모드 도구는 쓰지 않고, 계획 전문을 마지막 메시지에 쓰고 멈춘다"를 지우고 "띄운 세션이 지휘하는 하위 세션이어도 같다: 계획은 `ExitPlanMode`로 승인받고, 사용자는 그 세션의 플랜 화면에서 승인한다. 계획 전의 질문은 지시문대로 턴의 마지막 메시지에 쓰고 멈춘다"로.
- `SKILL.md` 2절 4(원문·번역본): 지시문 둘째 줄을 "질문과 승인 요청은 턴의 마지막 메시지에 빠짐없이 쓰고 멈춘다. 계획은 플랜 모드로 쓰고 `ExitPlanMode`로 승인받는다"로("(계획은 전문)" 지움). 2절 5 에 "하위 세션이 계획 승인(`ExitPlanMode`)을 기다리면, 계획이 나왔다고 세션 링크와 함께 알리고 확인할 점만 짧게 덧붙인다. 계획을 대신 승인하지 않는다. 사용자가 그 세션에서 승인하면 그것이 계획 승인이다"를 더했다.
- README 두 개의 "하위 세션" 줄과 workflow 설명(`plugin.json`·`marketplace.json`)에 같은 내용을 더했다.
- `grep -rn '계획은 전문\|a plan in full\|플랜 모드 도구는 쓰지 않고\|do not use the plan mode tools' plugins i18n README.md README.en.md`에 남은 것은 eval 사례 `start-plan`·`start-plan-real`의 프롬프트뿐이다. eval 은 사람이 승인할 수 없는 실행이라 그대로 둔다.

### A7: 고친 사례와 README (2026-11-24)

- `start-plan-real`: `plans-*` 여섯이 "질문으로 다룬 것"도 PASS 로 치던 것을 "정한 것이나 가정으로 둔 것. 묻기만 하고 기본안이 없으면 FAIL"로 바꿨다. 답이 계획을 바꾸지 않는 질문이 있으면 FAIL 인 `questions-change-plan`을 더했다(질문 수 대신 질문마다의 쓸모). 008 의 "질문 최대 3개" 삭제를 다시 재려고 지금 판과 그 문구를 되살린 판(`q3`)을 5회씩 돌린다.
- `trigger-real`: 합성 다섯을 더했다(라벨은 `task` description 문장 기준이고 사용자가 확인하지 않았다). 부르지 말 것: 작업 브랜치에서 "커밋하고 푸시까지"(end 와 헷갈림), "로그 보고 원인만, 항목은 안 만들어도 돼"(서베이와 헷갈림), "바로 고쳐 줘". 부를 것: 처음 보는 서베이 표현 둘. 지금 description 으로 3회씩 돌린다.
- README: frontend·workflow evals README 가 측정 방법으로 `skill-creator`를 가리키고, 겹치는 설명(판 두기, 반복, 채점, 판별력, 평균 ± 표준편차, 트리거 요청 고르기)을 지웠다. 사례 표, 저장소 경로, 사본 만들기, 셸 없음, 명령 예는 남겼다. `reviewer-svelte`·`start-plan`·`end-fix-real`은 스모크용이라고 적었다(다시 돌리지 않는다. `end-fix-real`의 위임 결정은 사용자 방침이었다). `plugins/server/evals/README.md`를 새로 썼다.
- `compose-real-*`는 README 에 약점만 적었다. 012 의 결정에 쓰지 않는다.

### B4·B5 사례 (2026-11-24)

- B4 는 실제 `create`·`mockup` 세션에서 질문과 사용자의 답이 기록된 것을 찾지 못해(세션 검색, 시안 기록 `docs/design/*/decisions.md`에는 브리프만 있다) **합성 사례**로 짰다: `plugins/workflow/evals/create-many`(사용자만 정할 결정 넷: 결제 대행사, 실결제·테스트, 결제 수단·환불, 그리고 저장소에 답이 있는 것: 통화·비회원·프레임워크), `create-few`(질문이 필요 없는 버그), `plugins/frontend/evals/mockup-cart`(시안 수, 저장소에 답이 있는 데이터·토큰). 질문으로 점수를 얻지 않게 "답이 만들 것을 바꾸는 질문인가"를 본다. 규칙상 지금 문구(대조군)가 실패하지 않으면 그대로 두니, 합성이라 쉬우면 바꾸지 않는 쪽으로만 기운다. 지금 판과 조건판을 5회씩 돌린다.
- B5 는 승인대로 todak 010 을 계획하는 사례 `plugins/server/evals/plan-todak-010`(main `b545b27`). 승인된 계획이 아직 없어 정답은 원칙 셋이 이 항목에 들어가는지(함수 입력 검사·호출 권한, 공개와 이력을 한 트랜잭션, 재시도 멱등성, 비밀 값 안 남기기)와 남기는 두 줄(마이그레이션 파일로만, 원격 명령 없음)이다. 원칙 셋이 있는 판과 없는 판을 5회씩 돌린다.

### 판정 규칙과 A2 사례 (2026-11-24, 부모 세션이 전한 사용자의 말: "추천안대로")

- 판정 규칙: 판마다 평균 ± 표준편차와 표준오차를 보고, 두 판의 차이가 표준오차 합보다 작으면 "같음". 같으면 묶음 규칙대로(A1·A2·A4·B5 는 바꾸고, B4 는 그대로). `plugins/*/evals/README.md`에 적었다.
- 008 결정에 다시 적용(결과 JSON 이 없어 008 이 적은 표준편차 0.03~0.17 로 어림, 세 사례 평균의 표준오차 판마다 약 0.026): Svelte 절 0.606 대 0.604, 역할 문장 0.606 대 0.623 은 둘 다 "같음". 역할 문장 삭제는 그대로, Svelte 절 유지는 삭제로 뒤집힌다(A2 가 다시 정한다). Explore 제한 0.733 대 0.733 "같음"(삭제 그대로), 질문 제한 0.733 대 0.783 은 이 수치로 가를 수 없어 고친 채점으로 다시 잰다. 트리거 0.95 대 0.95 "같음"(그대로).
- A2: nolmeong 의 Svelte 고유 리뷰 수정으로 실제 사례를 새로 만들어 잰다. `real-*`는 나빠지지 않는지만 본다.

### React (2026-11-24 범위 바꿈)

- 공식 자료를 원문으로 확인했다(web-fetch 에이전트): `vercel-react-best-practices`·`vercel-composition-patterns`는 frontmatter `name`이고 MIT 다. `skills` CLI 의 `--skill`은 frontmatter `name`과 맞춘다(`src/skills.ts`의 `filterSkills`). remix-run/agent-skills 는 2026-06-18 에 보관됐고 `remix-run/react-router`의 `.agents/skills/react-router` 하나로 옮겨졌다. 이 스킬이 세 방식(framework, data, declarative)을 다 다루고 "Identify the Mode" 절에서 방식을 가린다. 그래서 부모 세션이 적은 방식별 스킬 셋 대신 `react-router` 하나를 쓴다. Next.js 는 `next-best-practices`가 스킬이 아니고, 16.3 이상은 `next dev`가 `AGENTS.md`를 쓰고 문서는 `next/dist/docs/`, 낮으면 `npx @next/codemod@canary agents-md`가 `.next-docs/`로 받는다.
- 되살린 것: 프레임워크 표의 React 줄, `frontend-end-check`의 React 문장, `react.md`(공식 자료를 부르는 것과 설치를 묻는 것만), `frontend-reviewer` React 절(공식 스킬로 보기 + `'use client'`·서버 액션 안전 장치), 설명의 React. README "있으면 쓰는 것"에 `skills@1.7.5`로 고정한 설치 명령. 우리가 쓴 일반 React 규칙과 합성 React eval 사례는 되살리지 않았다. **재지 않고 들였다**(React 실제 사례가 없다).
- `frontend-reviewer`에 `Skill` 도구를 더했다(React 절과, 바꾸게 되면 A1·A2 가 쓴다).
- Supabase MCP 는 바꾸지 않는다(`supabase-reviewer`의 "Supabase MCP 는 읽기만", 사용자 확인).

### 결과: B5, B4, start-plan-real 다시 재기 (2026-11-24, Opus 시험, sonnet 채점 3표, 판마다 5회)

판정 규칙은 위 "판정 규칙과 A2 사례"의 것(차이가 표준오차 합보다 작으면 같음).

| 비교 | 지금 판 | 바꾼 판 | 판정 |
| --- | --- | --- | --- |
| B5 `plan-todak-010`: 원칙 셋 있음 / 없음 | 0.686 ± 0.156 (se 0.070) | 0.514 ± 0.078 (se 0.035) | 차이 0.172 > 0.105, 없으면 나빠짐 |
| B4 `create-many`: "최대 3개" / 조건판 | 0.720 ± 0.110 (se 0.049) | 0.600 ± 0.141 (se 0.063) | 차이 0.120 > 0.112, 조건판이 나쁨 |
| B4 `create-few` | 0.500 ± 0 | 0.500 ± 0 | 같음 |
| B4 `mockup-cart`: "최대 3개" / 조건판 | 0.667 ± 0 | 0.333 ± 0 | 조건판이 나쁨(질문을 7개까지 늘림) |
| `start-plan-real`(고친 채점): 지금(제한 없음) / "질문 최대 3개" | 0.723 ± 0.129 | 0.723 ± 0.117 | 같음 |

- **B5 채점 기준별**(있음/없음 통과 수): 공개와 이력을 한 트랜잭션 4/5 → 1/5, 비밀 값 안 남기기 5/5 → 1/5, 함수 입력 검사·호출 권한 1/5 → 2/5, 멱등성 0/5 → 0/5(판별력 없음), 마이그레이션 파일로만 4/5 → 4/5, 원격 명령 없음 5/5 → 5/5(판별력 없음). 그래서 트랜잭션·멱등성 줄과 비밀 값 줄은 남기고, 빼도 나빠지지 않은 인가·입력 검증 줄("새 엔드포인트마다 인증, 객체 단위 인가…")만 지웠다(원문·번역본). 셋을 함께 뺀 판만 쟀고 그 줄 하나만 뺀 판은 재지 않았다. 마이그레이션 파일 규칙과 원격 명령 금지는 남았다.
- **B4**: 조건판이 낫지 않아 `create.md`·`mockup.md`의 "최대 3개"를 그대로 둔다. 지금 판도 늘 실패한 채점이 있다: `create-few`는 5회 모두 라벨처럼 항목을 바꾸지 않는 질문을 했고, `mockup-cart`는 5회 모두 코드에 있는 것(주문 버튼 상태)을 물었다. 합성 사례다.
- **start-plan-real**: 고친 채점으로도 "같음"이라 008 의 "질문 최대 3개" 삭제는 그대로다(008 결정이 바뀌지 않았다). `questions-change-plan`은 지금 판 0/5, 제한 판 2/5 였다.

### 결과: A1·A2 의 `real-*` (2026-11-24, Opus 시험, sonnet 채점 3표, 판·사례마다 5회)

판: 지금(1단계 뒤 `frontend-reviewer`), A1(접근성·억지로 끈 검사 항목을 빼고 `web-design-guidelines`를 부름), A2(Svelte 절을 SvelteKit 규칙만 남기고 `svelte-core-bestpractices`를 부름), A1+A2. 사본 `skills/`에 공식 스킬을 넣었고(커밋 안 함), 실행 기록으로 보면 바꾼 판은 60회 모두 그 스킬을 Skill 도구로 불렀다.

| 사례 | 지금 | A1 | A2 | A1+A2 |
| --- | --- | --- | --- | --- |
| `real-birthday` | 0.600 ± 0.120 | 0.543 ± 0.120 | 0.600 ± 0.186 | 0.686 ± 0.064 |
| `real-line` | 0.754 ± 0.084 | 0.662 ± 0.069 | 0.738 ± 0.042 | 0.692 ± 0.094 |
| `real-sky` | 0.622 ± 0.099 | 0.556 ± 0.079 | 0.556 ± 0.079 | 0.556 ± 0.136 |
| 세 사례 평균(표준오차) | 0.659 (0.026) | 0.587 (0.024) | 0.631 (0.031) | 0.645 (0.027) |

- A1: 차이 0.072 > 표준오차 합 0.050, **나빠짐**. A1 판에서 줄어든 것: 한 줄 한글 Enter 3/5 → 0/5, 다시 읽어 주기 5/5 → 2/5, 생일 별 기다림 3/5 → 0/5, 하늘 포커스 2/5 → 0/5, 날씨 실패 5/5 → 3/5. 리뷰어가 규칙 목록 점검에 주의를 쓰고 동작 버그를 덜 본 것으로 보인다(추측, 보고 전문은 결과 JSON).
- A2: 차이 0.028 < 0.057, **같음**(`real-*`에서 나빠지지 않음). A2 는 Svelte 고유 실제 사례로 정한다(아래).
- A1+A2: 차이 0.014 < 0.053, 같음. A1 만 뺀 판이 나빠진 것과 맞지 않아 잡음이 크다고 본다. 판정은 묶음마다 따로 한 비교로 한다.
- 판별력 없는 채점(네 판 모두 0/5): 궤도 0 억 km, 이모지 반쪽, 가려진 동안 흉내, 버튼 자리 밀림. 네 판 모두 5/5: 실패 화면, 실시간 카드, 숨긴 뒤 포커스, 이름 숨기기, 그대로 둘 것 둘.

### 결과: A4 와 trigger-real (2026-11-24, Opus 시험, sonnet 채점 3표)

판: 지금(볼 것 1~11 이 있는 `supabase-reviewer`, 9 가 있는 `api-reviewer`), A4(1~11 을 지우고 `supabase`·`supabase-postgres-best-practices`를 부르는 판, `api-reviewer` 9 는 `supabase-postgres-best-practices`로). 실행 기록으로 보면 A4 판은 25회 모두 두 스킬(`api-seeded`는 하나)을 Skill 도구로 불렀다.

| 사례 | 지금 | A4 | 판정 |
| --- | --- | --- | --- |
| `real-todak-002`(실제, 10회) | 0.600 ± 0 (se 0) | 0.560 ± 0.084 (se 0.027) | 차이 0.040 > 0.027, 나빠짐 |
| `supabase-seeded`(합성, 5회) | 0.957 ± 0.039 | 0.971 ± 0.039 | 같음 |
| `api-seeded`(합성, 5회) | 0.800 ± 0.183 (se 0.082) | 0.733 ± 0.149 (se 0.067) | 같음 |

`real-todak-002`는 처음 5회에서 차이가 표준오차 합과 같아(0.040) 5회씩 더 돌렸다.

**항목마다 지웠는지 남겼는지** (승인 조건: 실제·합성 모두에서 나빠지지 않을 때만 지운다. 채점 기준별 통과 수는 지금 → A4):

| 항목 | 근거 | 결정 |
| --- | --- | --- |
| 1 RLS 와 노출 | 합성 `finds-no-rls` 5/5 → 5/5, 실제 `keep-public-read` 10/10 → 10/10 | 지움(공식 스킬) |
| 2 인가 | 합성 `finds-user-metadata` 5/5 → 5/5 | 지움 |
| 3 update | 합성 `finds-update-no-check` 4/5 → 5/5 | 지움 |
| 4 RPC | 합성 `finds-rpc-definer` 5/5 → 5/5 | 지움 |
| 5 뷰 | 합성 `finds-view-invoker` 5/5 → 5/5 | 지움 |
| 6 스토리지 | 합성 `finds-storage-upsert` 5/5 → 5/5 | 지움 |
| 7 키 | 합성 `finds-secret-in-client` 5/5 → 5/5 | 지움 |
| 8 입력과 악용 | 실제 `finds-doc-constraints` 10/10 → 8/10(나빠짐), 합성 `finds-feedback-length` 5/5 → 5/5 | **남김** |
| 9 Realtime 과 Edge Function | 합성 `finds-presence-pii` 5/5 → 5/5, `finds-edge-function` 5/5 → 5/5 | 지움 |
| 10 위험한 마이그레이션 | 합성 `finds-drop-column` 5/5 → 5/5 | 지움 |
| 11 정책 성능 | 합성 `finds-policy-perf` 3/5 → 3/5 | 지움 |
| api-reviewer 9 쿼리 | 합성 `finds-n-plus-one` 2/5 → 1/5, `finds-unbounded` 5/5 → 5/5, 사례 점수 같음 | 지움(`supabase-postgres-best-practices`로) |

- 실제 사례는 항목 8(제약)과 1(공개 읽기)만 채점한다. 2~7, 9~11 은 합성 사례로만 근거가 있다(합성은 쉬울 수 있다. 대부분 두 판 모두 5/5 라 판별력이 낮다).
- 실제 사례의 `finds-retry-timeout`·`finds-shape-check`는 두 판 모두 0/10 이라 판별력이 없다.
- 남긴 것: 두 사용자로 SQL 확인, 원격·운영 명령 금지, RLS 전제, 항목 8. `supabase-reviewer`·`api-reviewer`(원문·번역본)에 `Skill` 도구를 더했다.

**trigger-real** (지금 description, 25개 요청 × 3회): 모두 맞혔다(1.0). 새로 더한 비슷하지만 아닌 요청 셋(작업 브랜치에서 커밋·푸시, 원인만, 바로 고쳐 줘)은 부르지 않았고, 처음 보는 서베이 표현 둘은 불렀다. 008 의 description 결정은 그대로다.

### 결과: A2 의 Svelte 고유 실제 사례 (2026-11-24, Opus 시험, sonnet 채점 3표, 판·사례마다 5회)

사례: `real-svelte-001`(nolmeong 001 리뷰 전 `7dd1faf`. 정답은 고친 커밋 `1b794ec`의 시트 제목 고정 id → `$props.id()`, `{#each dexOrder()}`가 그릴 때마다 다시 계산), `real-svelte-005`(nolmeong 005 리뷰 전 `bb04515`. 정답은 `2bcea6b`의 `$derived` 객체 하나에서 꺼내 1분마다 통과 목록을 다시 만드는 것). 실제 리뷰에서 나와 고친 커밋이 근거다.

| 사례 | 지금(Svelte 절) | A2(공식 스킬) | 판정 |
| --- | --- | --- | --- |
| `real-svelte-001` | 0.333 ± 0 | 0.533 ± 0.183 (se 0.082) | 차이 0.200 > 0.082, 나아짐 |
| `real-svelte-005` | 0.500 ± 0 | 0.600 ± 0.224 (se 0.100) | 같음 |
| 두 사례 평균 | 0.417 (se 0) | 0.567 (se 0.065) | 나아짐 |

- 채점 기준별: 지금 판은 Svelte 고유 정답 셋을 15번 중 한 번도 못 찾았다(`finds-each-recompute` 0/5, `finds-props-id` 0/5, `finds-derived-rebuild` 0/5). A2 판은 2/5, 1/5, 1/5.
- `real-*`에서는 같음(위 A1·A2 표). 그래서 **A2 를 적용했다**: `frontend-reviewer` Svelte 절(원문·번역본)은 `svelte-core-bestpractices`를 부르는 줄과 SvelteKit 규칙(`$env/*/private`, `load` 권한, `fail()`, `adapter-static`)만 남겼다(`{@html}`은 공통 항목 1 에 있다). `frontend-start-check/references/svelte.md`는 공식 스킬(`svelte-code-writer`, `svelte-core-bestpractices`)을 부르는 것, 기존 코드의 autofixer 문제는 고치지 않는 것, SvelteKit 규칙, 설치를 묻는 것만 남겼다. `frontend-end-check/references/svelte.md`는 "새로 생긴 `issues`만 실패"를 그대로 두고 autofixer 를 공식 플러그인 것이라고 적었다.
- 008 의 "Svelte 절 유지"는 판별력 없는 사례(`reviewer-svelte` 만점 동률)와 Svelte 정답이 없는 `real-*`로 정한 것이었다. 이번 결과로 바뀌었다(위 판정 규칙의 재적용과도 같은 방향).
- 들여오는 방법(AC #3): 의존 플러그인으로 두지 않고 README "있으면 쓰는 것"의 `/plugin marketplace add sveltejs/ai-tools`, `/plugin install svelte@svelte`로 둔다(위 "들여오는 방법"). 이 기계에는 `svelte@svelte` 1.0.11 이 설치돼 있다(`~/.claude/plugins/installed_plugins.json`). `/task end` 쪽: 위 eval 에서 `frontend-reviewer`가 25회 모두 `svelte-core-bestpractices`를 Skill 도구로 불렀다. `/task start` 쪽: 1회용 시험(커밋 안 함, `.claude/.local/012/arms/startcheck`)에서 `frontend-start-check`를 부르고 그 "지킬 것"을 따라 nolmeong `bb04515`의 `src/routes/sky/+page.svelte`를 고치게 하자 3회 모두 `svelte-code-writer`나 `svelte-core-bestpractices`를 Skill 도구로 불렀다(`tool_used` 3/3). eval 사본에 넣은 스킬이라 이름은 `frontend:`로 붙는다.

### A1: 바꾸지 않음 (2026-11-24, 부모 세션이 전한 사용자의 말: "바꾸지 않기")

- 위 A1·A2 의 `real-*` 표대로 A1 판(접근성·억지로 끈 검사 항목을 빼고 `web-design-guidelines`를 부름)은 세 사례 평균 0.659 → 0.587 로 나빠졌다(차이 0.072 > 표준오차 합 0.050). 스킬은 15번 모두 불렀는데도 동작 버그를 덜 찾았다: 한 줄 한글 Enter 3/5 → 0/5, 다시 읽어 주기 5/5 → 2/5, 생일 별 기다림 3/5 → 0/5, 하늘 포커스 2/5 → 0/5, 날씨 실패 5/5 → 3/5.
- 그래서 `frontend-reviewer`의 접근성(4)·억지로 끈 검사(7) 항목을 그대로 두고, `web-design-guidelines`는 쓰는 곳이 없어 README 두 개의 설치 안내를 지웠다. `design-reviewer`(원문·번역본)의 "코드만 읽어도 보이는 문제는 `frontend-reviewer`와 `web-design-guidelines`가 본다"를 "`frontend-reviewer`가 본다"로 고쳤다. AC #1 을 이에 맞게 고쳤다.
- `design-reviewer`의 범위 바꾸기(브라우저로 열어야 보이는 것만)는 그대로다(재지 않고 바꿨다).

### 정리(simplify, 2026-11-24)

재사용·단순화·효율·고친 깊이 에이전트 넷의 지적을 보고 고친 것(동작은 바꾸지 않았다):

- 리뷰어 셋(`frontend-reviewer`, `api-reviewer`, `supabase-reviewer`, 원문·번역본): 줄마다 붙어 조금씩 달랐던 "스킬을 부를 수 없으면 '확인 못 한 것'에 '<스킬 이름> 없음'" 문장을 보고 형식 절에 한 번으로 모았다.
- `supabase-reviewer` 볼 것을 한 문단으로 줄이고(남긴 "입력과 악용"도 그 문단 안), 외부 스킬의 참고 문서 파일 이름 접두사(`security-*` 등)를 지웠다. `api-reviewer` 9 도 같다.
- `end.md` 2단계의 "테스트를 찾지 못함" 줄을 한 문장으로, 4단계의 같은 괄호를 지웠다. `SKILL.md` 2절 5 의 되풀이 문장과 `start.md` 3단계를 줄였다(하위 세션도 `ExitPlanMode`로 승인받는다는 뜻은 그대로).
- `react.md`·`svelte.md`(시작 점검)에서 아래 목록이 하는 말을 되풀이하던 문장을 지웠다. `server-start-check`의 "답 전까지는 서버 도구"를 "Node 도구"로 맞추고, 리뷰어가 부르는 공식 Supabase 스킬이 없으면 설치를 묻는 줄을 "물을 것"에 더했다(시작 점검 reference 의 Svelte·React 와 맞춤).
- `base-tests.sh`: 테스트를 못 찾았을 때 `$changed`를 한 번 더 돌던 루프를 지우고, 이미 구한 `sources`로 판정한다(같은 동작). 두 정규식에 따로 있던 도우미 폴더 목록을 `aux_dirs` 하나로.
- 테스트: `test-base-tests.sh`의 `__tests__/`·`tests/` 두 사례를 하나로, `test-config-check.sh`의 "보는 형태"와 "보지 않는 형태"를 한 사례로(다른 언어는 대표 둘만) 합쳤다. 합친 뒤 `bash scripts/test-config-check.sh` "20 개 중 20 개 맞음", `bash scripts/test-base-tests.sh` "18 개 중 18 개 맞음".
- eval: `create-many`와 새 `trigger-real` 다섯이 같은 fixture 를 복사하던 것을 이웃 fixture 를 부르는 한 줄로(`api-seeded`와 같은 방식). `supabase-seeded`·server README 의 "볼 것 1~11"을 주제 이름으로. 새 사례(`real-svelte-*`, `mockup-cart`, `create-*`, `plan-todak-010`)를 각 evals README 표에 더했다. workflow README 의 판정 규칙은 frontend README 를 가리킨다.

건너뛴 것:
- `frontend-end-check`의 개발 서버 절차가 `frontend-start-check`와 겹친다는 지적: AC #20 이 그 자리에 명령과 포트 규칙을 적으라고 한다. 포트 고르기를 `dev-server.sh`로 옮기는 것은 이 항목 밖이다.
- 실제 사례 fixture 를 공용 스크립트 하나로: 기존 사례(`real-*`, `compose-real-*`)까지 바꿔야 해 범위 밖이다.
- 테스트 러너에게 테스트 목록을 묻기(`vitest list` 등), 끝 값으로 "테스트 못 찾음"을 가르기: 더 큰 설계 변경이라 하지 않았다.
- 공식 스킬을 diff 종류에 따라서만 부르게 하기(효율): eval 로 잰 것은 늘 부르는 판이라, 조건을 붙이면 재지 않은 동작이 된다.
- 원칙과 부딪히는 지적을 리뷰어가 따로 묶기(효율): B2 의 뜻(판정이 거른다)과 다르다.
- evals README 의 "008 결정에 다시 적용한 것" 문단을 Notes 로만 옮기기: 부모 세션이 전한 지시가 README 와 Notes 둘 다에 적으라고 했다.
- `design-reviewer` description 줄이기: 에이전트를 고르는 데 쓰는 글이라 그대로 뒀다.

### A7: 사례마다 다섯 관점 (2026-11-24, 위 점검을 풀어 적음)

근거는 `skill-creator` 원문(SKILL.md 의 기준선·assertion·benchmark·analyst 절, `agents/grader.md`의 eval 비판, `agents/analyzer.md`의 "늘 통과하는 채점" 찾기)이다.

| 사례 | 대조군 | 채점 기준 | 반복 | 판별력 | 채점 보정 | 판정 → 한 것 |
| --- | --- | --- | --- | --- | --- | --- |
| `reviewer-svelte` | 절을 뺀 사본(옛 판 스냅숏과 같은 꼴), 맞다 | `finds-*` 정규식은 파일·줄만 맞으면 통과(겉만 맞음), `judges-*` LLM 이 보완 | 3 | 두 판 모두 1.0, 없음 | 없음 | 결정 근거로 쓰지 않음 → README 에 스모크용으로 적음(다시 돌리지 않음) |
| `real-line`·`real-sky`·`real-birthday` | 문구를 뺀 판, 맞다 | 버그마다 이진 LLM 채점, 이름이 보는 것을 드러냄. 정답에 Svelte 절 해당이 없음 | 5 | 늘 0/5 인 채점 넷(위 A1·A2 표), 판 차이가 표준편차 안 | 008 에서 40건 라벨(사람 5, Claude 35), 권장 30~50 의 사람 라벨에 못 미침 | 고칠 것 → 판정에 잡음 문턱을 넣고(사용자 결정), Svelte 절은 Svelte 고유 실제 사례 `real-svelte-*`로 따로 잼. `real-*`는 나빠지지 않는지 보는 데만 씀 |
| `compose-real-*-cr`·`-stack` | code-review 만 / + frontend-reviewer. 리뷰어 수와 내용이 함께 바뀜 | 과정 채점이 stack 에만 점수로 들어감. `keep-*`가 🔴 없는 보고 형식에서 늘 통과 | 3 | 생일은 두 판 같음 | 이 형식으로는 안 함 | 고칠 것 → 고침(아래 "compose-real 다시") |
| `trigger-real` | 옛·새 description | `tool_used Skill`, 결정적 | 3(질의당 3회와 같음) | 20개 중 19개가 두 판 같음 | 결정적이라 필요 없음, 라벨은 사용자 확인 | 고칠 것(작게) → 비슷하지만 아닌 요청 셋과 처음 보는 서베이 표현 둘을 더해 다시 돌림(25/25) |
| `start-plan` | 세 판 | `reads-*` tool_used, LLM 둘 | 3 | 세 판 만점 | 9건 재채점(비공식) | 결정 근거로 쓰지 않음 → README 에 스모크용으로 적음 |
| `start-plan-real` | 두 제한 있음 / 하나씩 뺌 / 둘 다 뺌, 맞다 | `plans-*`가 질문으로만 다뤄도 PASS(질문이 많을수록 점수↑) | 5 | 두 제한이 한 번도 걸리지 않음 | `plans-*` 라벨 없음 | 고칠 것 → 채점을 고쳐(기본안 없는 질문은 FAIL, 답이 계획을 바꾸지 않는 질문 감점) 다시 돌림(같음, 008 결정 그대로) |
| `end-fix-real` | 직접 / 위임 / Sonnet 직접 | 파일 채점은 객관적이나 프롬프트가 고칠 방법을 다 적음, `not_contains` 정규식은 겉만 맞아도 통과 | 3 | 9회 모두 다 고침, 위임판은 3회 중 1회만 위임 | `fix-exports`만 고침 | 위임 결정 근거로 쓰지 않음(결정은 사용자 방침) → README 에 스모크용으로 적음 |

공통으로 빠졌던 것(판마다 평균 ± 표준편차, 채점 기준별 늘 통과·늘 실패 따로 보기)은 012 의 모든 결과 표에 넣었다(`.claude/.local/012/summarize.py`). 사람이 출력 전체를 보는 단계와 채점자의 eval 비판 단계는 넣지 않았다(012 결정은 채점 수치와 실행 기록으로 했다).

### AC #3: 실제 svelte 플러그인으로 확인 (2026-11-24)

AC 판정 에이전트가 앞의 확인은 eval 사본 `skills/`에 넣은 복사본(`frontend:` 이름)이라 실제 플러그인 확인이 아니라고 했다. 그래서 다시 확인했다.

- 설치: 이 기계에는 README "있으면 쓰는 것"의 방법(`/plugin marketplace add sveltejs/ai-tools`, `/plugin install svelte@svelte`)으로 `svelte@svelte` 1.0.11 이 설치돼 있다(`~/.claude/plugins/installed_plugins.json`, 캐시 `~/.claude/plugins/cache/svelte/svelte/1.0.11`).
- 호출: 그 설치 폴더를 손대지 않고 eval 사본 안에 복사하고(eval 은 대상 플러그인 폴더 밖을 싣지 못한다), 사례의 `plugins: ["../..", "../../svelte-plugin"]`로 이 브랜치의 frontend 와 함께 실었다. 플러그인 이름이 `svelte`라 스킬은 `svelte:` 이름이다. 각 3회(1회용, 커밋 안 함, `.claude/.local/012/arms/realsvelte`).
  - `/task start` 쪽(`frontend-start-check`를 부르고 "지킬 것"을 따라 nolmeong `bb04515`의 `.svelte` 파일을 고침): 3/3 이 `svelte:svelte-code-writer`와 `svelte:svelte-core-bestpractices`를 불렀다.
  - `/task end` 쪽(`frontend-reviewer`로 `real-svelte-001` 리뷰): 3/3 이 `svelte:svelte-core-bestpractices`를 불렀다.
  - 전체 `/task start`·`/task end` 흐름 안에서 돌리지는 않았다. 그 흐름이 부르는 두 자리(시작 점검, 리뷰어)를 따로 돌렸다. svelte MCP 서버는 eval 이 띄우지 않았다(스킬만 확인).
- 처음 시도에서 `plugins:`에 svelte 폴더만 적었더니 시험 대상 frontend 가 실리지 않아(`plugins:`가 대상을 대신한다) 둘 다 적었다.

### A4: 최종 판 다시 재기 (2026-11-24)

AC 판정 에이전트가 "A4 묶음은 실제 사례에서 나빠졌는데 항목 단위로 나눠 바꿨고, 바꾼 최종 판은 재지 않았다"고 했다. 묶음(볼 것 1~11 을 모두 공식 스킬로)은 나빠졌으니 그대로 바꾸지 않았고, 승인 조건("리뷰어 항목을 지우는 결정은 실제·합성 모두에서 나빠지지 않을 때만")을 항목마다 적용해 나빠진 항목 8 만 남긴 판을 만들었다. 그 최종 판(지금 커밋의 `supabase-reviewer`·`api-reviewer`, 정리 뒤)을 같은 사례로 다시 쟀다.

| 사례 | 지금 판(볼 것 1~11) | 최종 판(8 만 남김) | 판정 |
| --- | --- | --- | --- |
| `real-todak-002`(실제, 10회) | 0.600 ± 0 | 0.600 ± 0 | 같음(`finds-doc-constraints` 10/10 → 10/10) |
| `supabase-seeded`(합성, 5회) | 0.957 ± 0.039 | 0.957 ± 0.039 | 같음 |
| `api-seeded`(합성, 5회) | 0.800 ± 0.183 | 0.867 ± 0.183 | 같음 |

최종 판은 두 사례 모두에서 나빠지지 않았다.

### compose-real 다시 (2026-11-24, A7 "고칠 것", Opus 시험, sonnet 채점 3표, 판·사례마다 3회)

고친 것: 과정 채점을 세 판 모두 `code-review` 호출 하나로 같게, 보고에 🔴·🟡·⚪ 를 붙이게 해 `keep-*`가 판별하게, 리뷰어 수만 늘린 대조군 `-gp`(`code-review` + 체크리스트 없는 general-purpose 리뷰어)를 더했다. 리뷰어는 지금 커밋의 `frontend-reviewer`(공식 svelte 스킬을 사본에 넣음). 실행 기록으로 `-stack`은 9회 모두 `frontend-reviewer`를, `-gp`는 9회 모두 general-purpose 에이전트를 불렀다.

| 사례 | code-review 만(`-cr`) | + 일반 리뷰어(`-gp`) | + frontend-reviewer(`-stack`) |
| --- | --- | --- | --- |
| birthday | 0.810 ± 0.082 | 0.857 ± 0 | 0.857 ± 0 |
| line | 0.590 ± 0.089 | 0.872 ± 0.089 | 0.872 ± 0.044 |
| sky | 0.556 ± 0.111 | 0.741 ± 0.128 | 0.704 ± 0.064 |
| 평균(표준오차) | 0.652 (0.032) | 0.823 (0.030) | 0.811 (0.015) |

- `-stack`과 `-gp`는 차이 0.012 < 표준오차 합 0.045 로 같음, 둘 다 `-cr`보다 낫다. 008 의 "리뷰어를 더하면 0.597 → 0.804"는 리뷰어 수 효과였고, `frontend-reviewer` 체크리스트 고유의 효과는 이 사례로는 보이지 않는다.
- 008 의 결정("`end.md` 3단계 구성은 바꾸지 않는다, 재기만")은 바뀌지 않는다(지금 구성은 대조군보다 나쁘지 않다). 다만 `frontend-reviewer`를 일반 리뷰어로 바꿀 수 있는지는 이 항목 밖의 후속 후보로 남긴다(사용자에게 알린다).
- `keep-card-not-saved`·`keep-no-list-limit`는 세 판 모두 3/3 이었다(심각도를 붙여도 🔴 로 올리지 않았다).

### AC #12: 옛 real-* 사례 (2026-11-24, 부모 세션이 전한 사용자의 답: "1" — 기록으로 마무리)

두 번째 AC 판정에서 "`real-line`·`real-sky`·`real-birthday`를 '고칠 것'으로 보고도 사례 파일은 그대로"라는 지적이 나왔다. 사용자가 기록으로 마무리하기로 했다.

- 옛 사례는 Svelte 정답이 든 새 사례(`real-svelte-001`, `real-svelte-005`)로 대신했다. 옛 사례 파일은 고치지 않았다.
- 늘 0/5 인 채점 넷(궤도 0 억 km, 이모지 반쪽, 가려진 동안 흉내, 버튼 자리 밀림)과 채점 보정 부족(사람 라벨 5건)은 남아 있다. 다만 이 넷은 비교한 판 모두 0 이라 판 사이 차이에 영향이 없고, A1 판정(바꾸지 않기)도 그대로다.
- 늘 0/5 인 채점 넷이 왜 늘 실패하는지(리뷰어가 못 찾는 어려운 문제인지, 채점 문구가 잘못된 것인지)는 확인하지 않았다. 그 사례로 다른 것을 잴 때 함께 고친다(사용자 요청: 기록만).
- 이 단서를 달아 #12 를 통과로 친다(사용자 결정).

### B5: 최종 판 다시 재기 (2026-11-24)

두 번째 AC 판정이 "실제로 지운 인가·입력 검증 줄 하나만 뺀 최종 판은 재지 않았다"고 했다. 그 최종 판(지금 커밋의 `server-start-check`, 트랜잭션·멱등성 줄과 비밀 값 줄은 남김)을 같은 사례로 5회 쟀다.

| 판 | 점수 | 판정(지금 판과) |
| --- | --- | --- |
| 지금(원칙 셋 있음) | 0.686 ± 0.156 (se 0.070) | — |
| 셋 다 뺌 | 0.514 ± 0.078 (se 0.035) | 나빠짐 |
| 최종(인가 줄만 뺌) | 0.743 ± 0.064 (se 0.029) | 같음(차이 0.057 < 0.099) |

채점 기준별(지금 → 최종): 트랜잭션 4/5 → 5/5, 비밀 값 5/5 → 5/5, 마이그레이션 파일로만 4/5 → 5/5, 원격 명령 없음 5/5 → 5/5, 멱등성 0/5 → 1/5, 함수 입력 검사·호출 권한 1/5 → 0/5. 지운 줄이 다루던 인가 채점은 1 → 0 으로 한 번 줄었지만 5회 이진 채점의 잡음 안이고, 사례 점수는 나빠지지 않았다.

### 인수인계 (2026-11-24)

다른 컴퓨터의 새 세션이 이 절만 읽고 `/task end`를 할 수 있게 적는다.

**브랜치와 상태**
- 작업 브랜치: `w/012-chore-official-skills-narrow-stack`(origin 에 푸시함). 기준 브랜치 `main`. 마지막 커밋은 이 절을 더한 커밋이다.
- start 6단계(정리, 검증, AC 판정, 체크와 커밋)까지 끝났다. 남은 일은 `/task end` 하나다: 리뷰(`code-review`, 필요하면 `security-review`, 스택 리뷰어), 판정, 고치기, Final Summary, 항목 닫기, 머지.
- 다른 컴퓨터에서 시작하는 법: `git fetch origin && git switch w/012-chore-official-skills-narrow-stack`(워크트리를 쓰면 `git worktree add <경로> w/012-chore-official-skills-narrow-stack`) 뒤 그 폴더에서 `/task end`.
- 검증 명령 `claude plugin validate . && bash scripts/check-repo-rules.sh`: 마지막 커밋 직전 상태에서 통과. 바뀐 스크립트의 짝 테스트(`test-base-tests.sh`가 10분 가까이 걸린다)를 돌리므로, eval 을 함께 돌리는 등 기계가 바쁘면 시간 제한(540초)을 넘을 수 있다. 그때는 `CHECK_TESTS_TIMEOUT=3000`을 앞에 붙여 다시 돌린다.

**AC 상태**
- AC #1~#21, DoD #1~#3 모두 체크했다. 체크 근거는 위 Notes 와 두 차례의 AC 판정(구현 세션이 아닌 general-purpose 판정 에이전트, 항목 파일과 `git diff main...HEAD`만 받음)이다.
  - 첫 판정의 실패 넷(#3, #8, #10, #12)과 두 번째 판정의 실패 셋(#11, #12, #18)은 이렇게 정리했다. #3 은 실제 `svelte@svelte` 플러그인을 실어 다시 확인했다. #8 은 승인 결정(`Deno.env.get` 남김)대로 AC 문구를 고쳤다. #10·#18 은 최종 판을 다시 재서 나빠지지 않음을 확인했다. #11 은 README 의 겹치는 설명을 지웠다. #12 는 사용자 결정으로 기록과 단서를 달아 통과로 쳤다.
  - DoD #1 은 판정 에이전트 대신 이 세션이 돌렸다. 검증 명령은 마지막 커밋에서 통과했다(아래 "브랜치와 상태").
- 단서가 붙은 통과:
  - #2: 키보드·포커스는 두 리뷰어가 보는 방법만 달리해 본다(`frontend-reviewer`는 코드, `design-reviewer`는 브라우저).
  - #3: 전체 `/task start`·`/task end` 흐름이 아니라 그 흐름이 부르는 두 자리를 따로 돌려 확인했다.
  - #6: Next.js 문서 받기 명령은 `@next/codemod@canary`라 버전이 고정되지 않았다(Next 공식 안내 그대로).
  - #10: A4 의 항목 2~7, 9~11 은 근거가 합성 사례뿐이다.
  - #12: 옛 `real-*`의 늘 0/5 인 채점 넷과 사람 라벨 부족이 남아 있다.

**바뀐 것과 버전(머지 전까지 GitHub main 에 없다)**
- workflow 0.13.0 → 0.14.0: 하위 세션도 플랜 모드(`ExitPlanMode`)로 계획 승인, `end.md` 원칙 지적 보고, `base-tests.sh`의 "테스트를 못 찾으면 끝 값 2"와 `__tests__/`·`tests/` 고르기.
- frontend 0.10.0 → 0.11.0: Svelte 기본 규칙은 공식 svelte 스킬로(리뷰어·시작 점검), React 는 공식 Vercel·React Router 스킬과 Next `AGENTS.md`로, `design-reviewer`는 브라우저로 열어야 보이는 것만·찾은 문제를 모두 보고, `frontend-end-check`가 다른 스킬 문서를 읽지 않음. `frontend-reviewer`의 접근성 항목은 그대로(A1 은 비교에서 나빠져 바꾸지 않음).
- server 0.6.0 → 0.7.0: Node·Supabase 로 좁힘(다른 서버 언어·OpenAPI·oasdiff 지움), `supabase-reviewer`·`api-reviewer`의 일반 규칙은 공식 Supabase 스킬로(입력과 악용만 남김), `server-start-check`의 인가 줄 삭제.
- 다른 컴퓨터에 설치된 플러그인은 마켓플레이스(GitHub main)의 옛 버전이다. 머지하고 푸시하기 전까지 그 컴퓨터의 `/task end`는 **옛 workflow 0.13.0 절차**로 돈다. 이 브랜치의 새 절차로 리뷰하려면 그 컴퓨터에서 이 브랜치 폴더를 로컬 마켓플레이스로 더하거나(`/plugin marketplace add <브랜치 폴더>`) 머지 뒤에 업데이트한다. 옛 절차로 해도 리뷰·머지에는 문제없다.

**다른 컴퓨터에서 쓰려면 설치할 외부 스킬(README "있으면 쓰는 것")**
- 공식 Svelte: `/plugin marketplace add sveltejs/ai-tools`, `/plugin install svelte@svelte`
- 공식 Supabase(스킬 `supabase`, `supabase-postgres-best-practices`): `/plugin install supabase@anthropic-plugin-directory`(같이 오는 원격 MCP 는 `/mcp`에서 끈다)
- React(Vercel): `npx -y skills@1.7.5 add vercel-labs/agent-skills --skill vercel-react-best-practices --skill vercel-composition-patterns -a claude-code`
- React Router: `npx -y skills@1.7.5 add https://github.com/remix-run/react-router --skill react-router -a claude-code`
- Next.js: 16.3 이상은 `next dev`가 `AGENTS.md`를 만든다. 낮으면 `npx @next/codemod@canary agents-md`
- 리뷰어는 이 스킬이 없으면 "확인 못 한 것"에 "<스킬 이름> 없음"이라고 적는다(리뷰가 멈추지는 않는다).

**이 기계에만 있는 것(커밋하지 않음)**
- `.claude/.local/012/`: eval 판 사본(`arms/`), 결과 JSON(`results/*.json`, Notes 의 표가 이것으로 만든 것), 정리 스크립트 `summarize.py`, A7 점검 요지 `a7-audit.md`, 받은 `web-design-guidelines` 원문(`ext/`). 다른 컴퓨터에는 없다. Notes 의 표가 결과를 다 담고 있어 `/task end`에는 필요 없다.
- eval 의 실행 기록(trace)은 `%LOCALAPPDATA%\Temp\claude-eval-*`에 남아 있다(`--keep-temp`). 지워도 된다.
- 실제 사례의 원본 저장소: nolmeong(`real-*`, `real-svelte-*`, `compose-real-*`, `start-plan-real`, `end-fix-real`), todak(`real-todak-002`, `plan-todak-010`). 경로는 커밋하지 않는 `plugins/{frontend,workflow}/evals/nolmeong-src.local`, `plugins/server/evals/todak-src.local`에 한 줄로 쓴다. 이 기계의 값은 `/c/Users/user/Documents/jihoons/nolmeong`, `/c/Users/user/Documents/jihoons/todak`이다. 다른 컴퓨터에서 eval 을 다시 돌리려면 그 컴퓨터의 경로로 이 파일을 만든다.

**eval 다시 돌리는 법**(`/task end`에는 필요 없다. 리뷰 지적으로 리뷰어 문구를 다시 재야 할 때만)
- 플러그인 폴더를 판마다 복사하고, 사본 `.claude-plugin/plugin.json`의 `dependencies`(workflow 는 `hooks/`도)를 지운다. 공식 스킬이 필요한 판은 그 스킬 폴더를 사본 `skills/`에 넣는다. 실제 다른 플러그인을 실으려면 사본 안에 복사하고 사례 프롬프트 머리에 `plugins: ["../..", "../../<폴더>"]`를 적는다(`plugins:`가 대상을 대신하므로 `../..`도 적는다).
- `claude plugin eval <사본 경로> --ablation none --scaffold --trust-plugin --model opus --judge-model sonnet --runs 5 --tag <태그> --no-publish --threshold 0 -j 2 --json <결과>.json`. 대상은 반드시 경로로 준다(`frontend`처럼 이름만 주면 설치된 플러그인이 돈다). Edit·Write 가 필요한 사례는 `--allow-tools Edit Write`. 셸은 주지 않는다(Windows).
- 판정 규칙은 `plugins/frontend/evals/README.md`의 "판정"(평균 차이가 두 표준오차 합보다 작으면 같음).

**후속 후보(이 항목 밖, 사용자에게 알림)**
- `compose-real` 다시 재기에서 `code-review` + 일반 리뷰어가 `code-review` + `frontend-reviewer`와 같았다(0.823 대 0.811). `frontend-reviewer` 체크리스트의 고유 효과가 이 사례로는 보이지 않는다.
- 옛 실제 사례(`real-line`·`real-sky`·`real-birthday`)에서 늘 0/5 인 채점 기준 넷이 왜 늘 실패하는지는 확인하지 않았다. 리뷰어가 못 찾는 어려운 문제인지, 채점 문구가 잘못된 것인지는 사례를 열어 봐야 안다. 그 사례로 다른 것을 잴 때 함께 고친다.
- `simplify`에서 건너뛴 것: 실제 사례 fixture 를 공용 스크립트로 모으기, 포트 고르기를 `dev-server.sh`로 옮기기, 테스트 러너에게 테스트 목록 묻기.

## Final Summary
