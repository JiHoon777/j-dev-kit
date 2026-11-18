# j-dev-kit

**한국어** | [English](README.en.md)

Claude Code용 개인 플러그인 마켓플레이스. 작업 흐름은 `/task` 스킬 하나로 두고, 스택마다 다른 점검은 스택 플러그인으로 나눴다. 켠 플러그인의 점검만 돈다.

원칙은 하나다: **단계마다 어떤 실패를 막는지 답할 수 없으면 넣지 않는다.** 작은 일은 가볍게, 큰 일만 무겁게 한다.

## 구성

| 플러그인 | 스킬 · 에이전트 | 같이 설치되는 것 |
| --- | --- | --- |
| `workflow` | `/task create`, `/task start`, `/task end` | `superpowers` |
| `frontend` (+ `workflow`) | `frontend-start-check`, `frontend-end-check` (references: svelte, react), 에이전트 `frontend-reviewer` | `typescript-lsp`, `frontend-design` |
| `server` (+ `workflow`) | `server-start-check`, `server-end-check` (references: node, python, go, jvm, supabase), 에이전트 `api-reviewer`, `rls-reviewer` | — |

Supabase 를 쓰면(프론트엔드에서 바로 부르는 경우도) `server`를 설치한다. `supabase/config.toml`이나 `@supabase/` 의존성을 보고 Supabase 점검과 `rls-reviewer`가 켜진다.

### 파일 구조

공식 스킬 구조(`SKILL.md` + 필요할 때만 읽는 `references/`)를 따른다.

```
plugins/workflow/skills/task/
  SKILL.md                 인자(create·start·end)로 reference 하나를 고른다
  references/create.md, start.md, end.md
plugins/frontend/
  agents/frontend-reviewer.md
  skills/frontend-start-check/  SKILL.md + references/svelte.md, react.md
  skills/frontend-end-check/    SKILL.md + references/svelte.md
plugins/server/
  agents/api-reviewer.md, rls-reviewer.md
  skills/server-start-check/    SKILL.md + references/node.md, python.md, go.md, jvm.md, supabase.md
  skills/server-end-check/      (같은 구조)
i18n/en/…                  영어 번역본 (Claude 는 읽지 않음)
```

- **원문은 한국어(`plugins/`), 영어 번역본은 `i18n/en/`.** 같은 경로 구조로 두고, 번역본 맨 위에 원문 링크를 단다. 원문을 고치면 번역본도 같이 고친다. 스킬이 사용자에게 하는 보고와 백로그 항목은 프로젝트 CLAUDE.md 가 정한 언어(없으면 대화 언어)로 쓴다.
- **프레임워크·언어별 내용은 references 로.** 점검 스킬이 프로젝트를 판별해 해당 reference 만 읽는다.

### 스택 플러그인이 끼어드는 방식

- `/task start`는 이름이 `-start-check`로 끝나는 스킬을, `/task end`는 `-end-check`로 끝나는 스킬을 전부 부른다. 플러그인을 끄면 그 점검도 빠진다. 프로젝트에 해당하지 않으면 "해당 없음"만 돌려준다.
- 시작 점검이 돌려주는 것: **지킬 것**(구현 중 규칙과 부를 스킬), **플랜에 넣을 것**, **물을 것**. 해당하는 것만.
- 종료 점검이 돌려주는 것: 변경이 그 영역을 건드렸을 때만 돌린 검사의 **실패**, **리뷰에 넣을 에이전트**, **고친 뒤 할 것**.
- 점검 스킬은 명령만 돌린다. diff 를 읽고 판단하는 리뷰는 리뷰 에이전트가 한다.
- 새 스택은 `plugins/<스택>/skills/<스택>-start-check`, `<스택>-end-check`를 같은 형식으로 만들고 `marketplace.json`에 등록한다. 같은 스택 안의 갈래(프레임워크, 언어)는 references 로 더한다.

## 흐름

```
/task create ──► docs/backlog/001-….md ──/task start──► 기준선·스택 점검 ──► 플랜 모드(크기에 맞게) ──► 승인 ──► w/ 브랜치에서 구현 ──► 정리·검증
                                                                                                                                │
docs/done/001-….md ◄── 머지 ◄── 검증 ◄── 수정 ◄── 🔴/🟡 고르기 ◄── 리뷰(code-review + 해당 리뷰어) ◄── 스택 종료 점검 ◄── /task end
```

- **`/task start`**: 검증 명령을 한 번 돌려 기준선을 남기고 스택 시작 점검을 부른다. 작은 항목은 에이전트 없이 바로 계획하고, 큰 항목만 `Explore` 에이전트를 최대 2개 띄운다. 질문은 코드로 답할 수 없는 것만 최대 3개. 구현은 테스트 먼저, 항목이 요구하는 것만. 끝에 `simplify`로 정리하고 검증을 새로 한 번 돌린다.
- **`/task end`**: `code-review`는 항상, `security-review`는 인증·입력·비밀 값 등이 바뀐 경우만, 스택 리뷰어는 해당할 때만 동시에 띄운다. 지적은 점수 없이 🔴 꼭 고칠 것 / 🟡 고려 / ⚪ 사소함(개수만)으로 보여 주고 구분별로 묻는다. 고친 뒤 검증을 한 번 돌리고 항목을 닫고 머지 방법을 고르게 한다. 요청하지 않으면 푸시하지 않는다.

### 어디서 가져왔나

검증된 흐름을 이어 붙였다. 무엇을 넣고 뺄지는 인기 레포와 공식 가이드를 비교해 정했다.

| 부분 | 출처 |
| --- | --- |
| 항목 형식, 좋은 항목, 완료 기준 | [Backlog.md](https://github.com/MrLesk/Backlog.md) 에이전트 지침 |
| 모호한 요청 구체화 | `superpowers:brainstorming` |
| 질문은 최대 3개, 나머지는 가정으로 | [github/spec-kit](https://github.com/github/spec-kit) `specify` |
| 크기에 맞춘 계획(작은 일은 에이전트 없이) | superpowers, [compound-engineering](https://github.com/EveryInc/compound-engineering-plugin) `ce-plan`·`ce-work` |
| 생각하고 코딩, 단순하게, 필요한 곳만, 목표로 검증 | [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) |
| 테스트 먼저, 완료 전 검증 한 번 | `superpowers:test-driven-development`, `verification-before-completion` |
| 구현 직후 정리 | 내장 스킬 `simplify` (공식 `code-simplifier`처럼 리뷰가 아니라 코드를 쓴 직후에) |
| 리뷰 | 내장 스킬 `code-review`, 조건부 `security-review`, 스택 리뷰 에이전트(변경에 맞는 것만, [pr-review-toolkit](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/pr-review-toolkit) 방식) |
| 지적 표시(점수 대신 구분) | Claude Code Code Review(🔴 Important / 🟡 Nit), superpowers code-reviewer(Critical / Important / Minor) |
| 지적 처리, 브랜치 마무리 | `superpowers:receiving-code-review`, `finishing-a-development-branch` |
| 새 화면 디자인 | Anthropic `frontend-design` |
| Svelte 규칙과 autofixer | 공식 Svelte 플러그인 (`svelte-code-writer`, `svelte-autofixer`) |
| React 규칙 | Vercel `react-best-practices` |
| API 리뷰 기준 | OWASP API Security Top 10 2023 |
| Supabase 규칙과 검사 | 공식 [supabase/agent-skills](https://github.com/supabase/agent-skills) 보안 체크리스트, Supabase CLI (`db diff`, `db advisors`) |
| 스킬 작성 | Anthropic [Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) |

일부러 뺀 것: 매번 띄우는 설계 에이전트 3개(feature-dev), 작업 전 스택별 기준선·의존성 설치·Lighthouse·React Doctor(인기 스택 스킬 어디에도 없다), 0–100 확신도 표시(모든 레퍼런스가 안에서 거르는 데만 쓴다), 리뷰 단계의 `simplify`.

## 설치

Claude Code 안에서 실행한다(터미널에서는 `claude plugin …`).

```
/plugin marketplace add JiHoon777/j-dev-kit
/plugin install frontend@j-dev-kit
/plugin install server@j-dev-kit
```

- 쓰는 스택만 설치한다. 스택 플러그인은 모두 `workflow`에 의존하므로 `/task`와 `superpowers`가 같이 설치된다.
- 의존 플러그인은 Claude Code 에 기본으로 들어 있는 `anthropic-plugin-directory`에서 온다. 다른 마켓플레이스를 추가할 필요가 없다.
- 저장소 하나에서만 켜려면 `--scope project`로 설치한다(아래).

### 있으면 쓰는 것 (선택)

설치돼 있으면 스킬이 불러 쓰고, 없어도 점검은 돈다.

| 플러그인 · 스킬 | 쓰는 곳 | 설치 |
| --- | --- | --- |
| Svelte 공식 플러그인 | 문서 조회, `svelte-code-writer`, autofixer MCP | `/plugin marketplace add sveltejs/ai-tools`, `/plugin install svelte@svelte` |
| Chrome DevTools | 브라우저 확인(없으면 앱 내장 브라우저) | `/plugin marketplace add ChromeDevTools/chrome-devtools-mcp`, `/plugin install chrome-devtools-mcp@chrome-devtools-plugins` |
| `modern-web-guidance` | 새 웹 기능·UI 패턴 고르기 | `/plugin marketplace add GoogleChrome/modern-web-guidance`, `/plugin install modern-web-guidance@googlechrome` |
| Vercel `react-best-practices` | React 컴포넌트 작성 | `npx -y skills@1.7.5 add vercel-labs/agent-skills` |
| 공식 Supabase 플러그인 | Supabase 코드 작성 규칙 | `/plugin install supabase@anthropic-plugin-directory` (같이 오는 MCP 서버는 읽기 전용이 아니니 `/mcp`에서 끄는 것을 권한다) |
| 언어별 LSP | 코드 진단 | `pyright-lsp`, `gopls-lsp`, `jdtls-lsp`, `typescript-lsp` (`anthropic-plugin-directory`, 실행 파일은 따로 설치) |

React 프로젝트는 `eslint-plugin-react-hooks`의 `recommended`를 켜 두고 검증 명령에 린트를 넣어 두면 `/task`가 훅 규칙을 따로 검사하지 않아도 된다.

### 프로젝트에 고정하기

```bash
claude plugin marketplace add JiHoon777/j-dev-kit --scope project
claude plugin install frontend@j-dev-kit --scope project
claude plugin install server@j-dev-kit --scope project
```

Claude Code 가 마켓플레이스와 의존 플러그인까지 `.claude/settings.json`에 적는다. 커밋하면 저장소를 연 사람에게 같은 구성이 제안된다.

```json
{
  "extraKnownMarketplaces": {
    "j-dev-kit": { "source": { "source": "github", "repo": "JiHoon777/j-dev-kit" } }
  },
  "enabledPlugins": {
    "frontend@j-dev-kit": true,
    "server@j-dev-kit": true,
    "workflow@j-dev-kit": true,
    "superpowers@anthropic-plugin-directory": true,
    "frontend-design@anthropic-plugin-directory": true,
    "typescript-lsp@anthropic-plugin-directory": true
  }
}
```

이 파일을 정리할 때 **의존 플러그인 줄을 지우지 않는다.** 지우면 그 플러그인을 쓰는 플러그인이 로드되지 않는다.

### 프로젝트 CLAUDE.md 에 적을 것

```markdown
## 작업 설정
- stack: frontend, server                   # 없으면 점검 스킬이 파일로 추정
- 기준 브랜치: main
- 검증 명령: pnpm verify                     # 린트·타입·테스트·빌드를 한 번에
- 문서 언어: 한국어                          # 백로그 항목·보고 언어

## superpowers
이 문서의 규칙이 우선이다. `/task`가 부르는 스킬(brainstorming, test-driven-development,
verification-before-completion, receiving-code-review, finishing-a-development-branch)은 따르고,
그 밖의 계획·실행 스킬(writing-plans, executing-plans, subagent-driven-development, using-git-worktrees)은
이 흐름과 겹치므로 쓰지 않는다.
```

superpowers 는 세션마다 "맞을 것 같으면 스킬을 반드시 쓰라"는 지시를 넣는다. 위 문단이 있어야 `/task start`의 계획 단계를 가로채지 않는다.

## 사용법

```
/task create 이메일·비밀번호 로그인 화면 추가   # 승인받은 뒤 docs/backlog/001-….md 를 만든다
/task start 001                                  # 계획을 세우고, 승인 뒤 w/001-… 브랜치에서 구현한다
/task end                                        # 리뷰하고, 고를 것을 고치고, 항목을 끝내고, 승인받아 머지한다
```

- 프로젝트에서 처음 `/task create`를 하면 `docs/backlog/`(README, `_template.md`)를 만들자고 제안하고 라벨을 묻는다.
- `/task start`는 커밋하지 않은 변경이나 다른 `w/` 브랜치가 있으면 먼저 멈춘다.
- 인자 없이 `/task`만 부르면 세 모드를 보여 주고 묻는다.
- `/task`는 직접 입력할 때만 실행된다(`disable-model-invocation: true`).

## 업데이트

Claude Code 는 `plugin.json`의 버전이 올라갔을 때만 플러그인을 바꾼다.

```bash
claude plugin marketplace update j-dev-kit
claude plugin update workflow@j-dev-kit --scope project    # 설치한 플러그인마다, 설치할 때의 범위로
```

그다음 Claude Code 를 다시 시작한다.

### 변경을 내보낼 때 (관리자)

1. 파일이 바뀐 플러그인마다 `plugin.json`의 `version`을 올린다.
2. `claude plugin validate .`와 `claude plugin validate plugins/<이름>`.
3. `i18n/en/` 번역본을 같이 고친다.
4. 커밋하고 푸시한다.

## 문제 해결

| 증상 | 원인과 해결 |
| --- | --- |
| `supabase@j-dev-kit`을 찾을 수 없다 / 로드되지 않는다 | 0.4.0 에서 `server`로 합쳤다. `.claude/settings.json`의 `enabledPlugins`에서 `supabase@j-dev-kit`(쓰지 않으면 `supabase@anthropic-plugin-directory`도)을 지우고 `server@j-dev-kit`을 설치한다. |
| `claude plugin list`에 `Dependency "…" is not installed` | `enabledPlugins`에서 의존 플러그인이 지워졌다. 메시지의 명령으로 같은 `--scope`로 설치한다. |
| `/task start`가 스택 점검을 하나도 안 돈다 | 스택 플러그인이 꺼져 있거나 해당하지 않는다고 판단했다(CLAUDE.md 의 `stack:` 확인). |
| superpowers 가 자기 brainstorming 이나 계획 파일을 시작한다 | 위의 superpowers 문단을 프로젝트 CLAUDE.md 에 넣는다. |
| 푸시한 변경이 업데이트해도 안 보인다 | `version`을 올리지 않았거나 Claude Code 를 다시 시작하지 않았다. |

## 알아 둘 것

- **마이그레이션 담당은 하나.** 서버 마이그레이션 도구(Prisma, Drizzle, TypeORM, Alembic, Django, Atlas, Flyway, Liquibase, golang-migrate)가 있으면 DB 가 Supabase 여도 그 도구가 담당이다. 없고 `supabase/`가 있으면 Supabase CLI 가 담당이다. 둘 다 있으면 어느 쪽이 기준인지 묻는다.
- **외부 CLI 는 버전을 고정한다.** `npx`로 내려받는 도구(`@sveltejs/mcp`, `skills`)는 공개된 지 2주 넘은 버전으로 고정했다. 프로젝트 도구(Prisma, Drizzle, TypeORM)는 `npx --no-install`로 설치된 것만 쓴다.

### Supabase MCP (선택)

Supabase 점검은 CLI 로 돈다. MCP 를 쓰고 싶으면 프로젝트 `.mcp.json`에 읽기 전용, 프로젝트 하나로 한정해 연결한다(`<ref>`는 `https://xxxx.supabase.co`의 xxxx). 연결돼 있으면 advisors 를 MCP 로도 부른다.

```json
{
  "mcpServers": {
    "local_supabase": {
      "type": "http",
      "url": "https://mcp.supabase.com/mcp?read_only=true&project_ref=<ref>"
    }
  }
}
```

### CLI 로 하는 Supabase 쓰기 막기 (선택)

Supabase CLI 와 `psql`은 원격 프로젝트에 연결돼 있으면 바꿀 수 있다. 막으려면 프로젝트 `.claude/settings.json`의 `permissions.deny`에 더한다. 로컬 작업(`supabase start`, `--linked` 없는 `supabase db reset`, `127.0.0.1`로의 `psql`)은 그대로 된다.

```json
      "Bash(supabase link*)",
      "Bash(supabase db push*)",
      "Bash(supabase db reset --linked*)",
      "Bash(supabase db reset --db-url*)",
      "Bash(supabase migration up --linked*)",
      "Bash(supabase migration up --db-url*)",
      "Bash(supabase migration repair*)",
      "Bash(supabase config push*)",
      "Bash(supabase functions deploy*)",
      "Bash(supabase functions delete*)",
      "Bash(supabase secrets*)",
      "Bash(supabase storage rm*)",
      "Bash(supabase storage mv*)",
      "Bash(supabase storage cp*)",
      "Bash(supabase branches delete*)",
      "Bash(supabase projects delete*)",
      "Bash(psql *supabase.co*)",
      "Bash(psql *supabase.com*)"
```

설정으로 막을 수 없는 것: 앱 자체. 데이터를 저장하는 브라우저 확인은 앱의 env 파일이 가리키는 프로젝트에 쓴다.
