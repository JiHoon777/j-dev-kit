---
id: '012'
title: 일반 규칙은 외부 공식 스킬(web-design-guidelines, svelte, supabase, skill-creator)에 맡기고 스택을 Svelte·Node·Supabase 로 좁히기, 리뷰·검사 규칙 다듬기 (전문가 스킬 활용 리뷰 5절)
status: To Do
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

만들 때는 비워 둔다. `/task start`가 승인된 계획을 적는다.

## Implementation Notes

## Final Summary
