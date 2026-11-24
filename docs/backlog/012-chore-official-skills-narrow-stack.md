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
3. **React 지원 지우기:** `frontend-start-check/references/react.md`와 번역본, `frontend-start-check/SKILL.md:20-23` 프레임워크 표의 React 줄, `frontend-end-check/SKILL.md:18`의 React 문장, `frontend-reviewer.md:35-39` React 절, description·README·`marketplace.json`·`plugin.json`의 React 언급, README "있으면 쓰는 것"의 Vercel react-best-practices 줄을 지운다. React eval 사례(`reviewer-react`, `compose-code-review`, `compose-with-stack`)도 지운다.
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

- [ ] #1 (A1) `frontend-reviewer`(원문·번역본)에 일반 접근성 항목이 없고, 코드의 UI·접근성은 `web-design-guidelines` 규칙으로 본다고 적혀 있다. XSS·상태·중복 요청·비밀 값·새 의존성 항목은 남아 있다
- [ ] #2 (A1) `design-reviewer`(원문·번역본)가 보는 것이 브라우저로 열어야 보이는 것(폭별 스크린샷, axe, 대비 측정, 키보드, 상태·콘솔, DESIGN.md 토큰)뿐이고, `frontend-reviewer`와 같은 항목을 함께 보지 않는다(재지 않고 바꾼 것이라고 `Implementation Notes`에 적혀 있다)
- [ ] #3 (A2) Svelte 기본 규칙(runes, Svelte 4 문법, autofixer, 문서 찾기)은 공식 `svelte` 스킬에서 온다. 들여오는 방법(의존 플러그인, 교차 마켓플레이스 허용, README 안내 가운데 고른 것)과, 그 방법으로 실제로 설치되고 `/task start`·`/task end` 중에 공식 스킬이 불리는지 확인한 결과가 `Implementation Notes`에 있다
- [ ] #4 (A2) `svelte.md`(start·end, 원문·번역본)와 `frontend-reviewer` Svelte 절에 남은 규칙이 SvelteKit 규칙(`$env/*/private`, `adapter-static`, `fail()`, `load` 권한, `{@html}`)과 "기준 브랜치 대비 새로 생긴 autofixer issues 만 실패"뿐이다. `$derived`·`$effect`·Svelte 4 문법 같은 Svelte 기본 규칙은 없다
- [ ] #5 (A2) `grep -rn 'svelte-file-editor' plugins i18n`의 결과가 "쓰지 않는다"는 문장뿐이거나 비어 있다
- [ ] #6 (A3) `react.md`와 번역본, `reviewer-react`·`compose-code-review`·`compose-with-stack` eval 폴더가 없다. 프레임워크 표, `frontend-end-check`, `frontend-reviewer`, frontend `plugin.json`·`marketplace.json`·README 두 개의 설명, `plugins/frontend/evals/README.md` 사례 표에 React 가 없다(감지 목록과 공개 접두사 목록은 빼는 것에 적은 대로 남는다)
- [ ] #7 (A4) `supabase-reviewer`(원문·번역본)에 로컬 DB 에서 두 사용자로 SQL 을 직접 확인하기, 원격·운영 명령 금지, RLS 전제, 공식 Supabase 스킬 규칙으로 본다는 문장이 있다. `supabase-reviewer` "볼 것" 1~11 과 `api-reviewer` 9(쿼리·인덱스)마다 지웠는지 남겼는지와 그 근거(A6 eval 결과)가 `Implementation Notes`에 목록으로 있고, 두 파일은 그 목록대로다
- [ ] #8 (A5) `config-check.sh`가 읽는 형태가 Node 형태(`process.env`, `import.meta.env`)뿐이고, `scripts/test-config-check.sh`에 다른 언어 시나리오가 없으며 테스트가 모두 통과한다
- [ ] #9 (A5) `server-start-check`·`server-end-check`(원문·번역본)의 감지와 마이그레이션 담당이 Node 도구와 Supabase CLI 만 말하고, `grep -rni 'oasdiff\|openapi' plugins i18n README.md README.en.md .claude-plugin`이 비어 있다. server `plugin.json`·`marketplace.json`·README 설명에 "any server language"와 API 스펙 검사가 없다
- [ ] #10 (A6) A1·A2·A4 마다 지금 판과 바꾼 판을 실제 사례(Svelte·UI 는 nolmeong `real-*`, Supabase 는 새로 만든 실제 사례)로 비교한 방법과 결과가 `Implementation Notes`에 있다. 새 Supabase 사례가 `plugins/server/evals/`에 커밋되어 있다. 바꾼 묶음은 비교에서 나빠지지 않은 것뿐이고, 나빠진 묶음은 바꾸지 않았다고 적혀 있다
- [ ] #11 (A7) `plugins/frontend/evals/README.md`·`plugins/workflow/evals/README.md`가 스킬을 고칠 때의 측정 방법으로 `skill-creator`를 가리키고, `skill-creator`와 겹치는 설명이 없다. 실제 사례 eval 폴더와 그 사례에만 있는 설명은 남아 있다. `skill-creator` 원문에서 무엇이 겹친다고 봤는지, `skill-creator`가 실제 사례 eval 을 대신하는지에 대한 판단과 근거가 `Implementation Notes`에 있다
- [ ] #12 (A7) `plugins/*/evals/`의 실제 사례·트리거·계획 단계·리뷰 위임 사례마다 `skill-creator` eval 가이드에 비춰 대조군, 채점 기준, 반복 수, 판별력, 채점 보정을 점검한 결과가 `Implementation Notes`에 있다. 잘못 짜였다고 본 사례는 고쳐 다시 돌린 결과가 있고, 결과가 바뀌어 다시 본 결정은 사용자의 답과 함께 적혀 있다
- [ ] #13 (B1) `design-reviewer`(원문·번역본)에 "확인한 문제만"이 없고, 찾은 문제를 모두 확인한 것과 확인 못 한 것으로 나눠 보고하고 거르기는 부른 쪽이 한다고 적혀 있다
- [ ] #14 (B2) `end.md` 3단계(원문·번역본)에 "원칙에 어긋나는 지적은 하지 않는다"가 없고, 원칙에 어긋나 보이는 지적도 부딪히는 원칙과 함께 보고한다고 적혀 있다. 4단계 판정 규칙은 그대로다
- [ ] #15 (B3) 테스트 밖 소스만 바뀌고 테스트가 없는 브랜치에서 `base-tests.sh`가 끝 값 2 로 끝나고, `src/__tests__/login.js`·`tests/login.js`를 바꾼 브랜치에서는 그 파일을 고른다. 두 경우가 `scripts/test-base-tests.sh`에 있고 통과한다
- [ ] #16 (B3) `end.md` 2단계(원문·번역본)가 테스트를 찾지 못한 결과를 사용자에게 "확인 못 함"과 이유로 보인다고 적혀 있다
- [ ] #17 (B4) `create.md`·`mockup.md`의 지금 문구와 조건판을 eval 로 비교한 방법과 결과가 `Implementation Notes`에 있고, 두 파일(원문·번역본)은 나은 쪽이다
- [ ] #18 (B5) `server-start-check` "지킬 것"의 일반 원칙 셋이 있는 판과 없는 판의 비교 방법과 결과가 `Implementation Notes`에 있고, 없어도 나빠지지 않은 것만 지워져 있다. 마이그레이션 파일 규칙과 원격 명령 금지는 남아 있다
- [ ] #19 (B6) `server-end-check` 보고 형식 예시(원문·번역본)에 "oasdiff 없음"이 없다
- [ ] #20 (B7) `frontend-end-check`(원문·번역본)가 다른 스킬의 SKILL.md 를 읽게 하지 않고, 개발 서버를 띄우는 명령과 포트 규칙을 그 자리에 적는다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 원문(`plugins/`)을 고친 곳은 번역본(`i18n/en/`)도 같이 고쳤다
- [ ] #3 고친 플러그인(workflow, frontend, server)마다 `plugin.json` `version`을 올렸고, README 두 개와 `marketplace.json` 설명을 맞췄다

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

## Final Summary
