# j-dev-kit

[English](README.md) | **한국어**

Claude Code용 개인 플러그인 마켓플레이스. 작업 흐름은 `/task` 스킬 하나로 두고, 스택마다 다른 점검은 스택 플러그인으로 나눴다. 켠 플러그인의 점검만 돈다. 여러 개를 같이 켜도 충돌하지 않는다.

## 구성

| 플러그인 | 스킬 · 에이전트 | 같이 설치되는 것 |
| --- | --- | --- |
| `workflow` | `/task create`, `/task start`, `/task end` | `superpowers` |
| `frontend` (+ `workflow`) | `frontend-start-check`, `frontend-end-check` (references: svelte, react), 에이전트 `ui-reviewer`, `svelte-reviewer`, `react-reviewer` | `chrome-devtools-mcp`, `typescript-lsp`, `frontend-design`, `modern-web-guidance` |
| `supabase` (+ `workflow`) | `supabase-start-check`, `supabase-end-check`, 에이전트 `rls-reviewer` | `supabase` (공식: 스킬, MCP) |
| `server` (+ `workflow`) | `server-start-check`, `server-end-check` (references: node, python, go, jvm), 에이전트 `api-reviewer` | — |

### 파일 구조

공식 스킬 구조(`SKILL.md` + 필요할 때만 읽는 `references/`)를 따른다.

```
plugins/workflow/skills/task/
  SKILL.md                 인자(create·start·end)를 보고 해당 reference 하나만 읽게 하는 안내
  references/create.md, start.md, end.md
plugins/frontend/
  agents/                  ui-reviewer, svelte-reviewer, react-reviewer
  skills/frontend-start-check/  SKILL.md(공통) + references/svelte.md, react.md
  skills/frontend-end-check/    SKILL.md(공통) + references/svelte.md, react.md
plugins/server/
  agents/api-reviewer.md
  skills/server-start-check/    SKILL.md(공통) + references/node.md, python.md, go.md, jvm.md
  skills/server-end-check/      (같은 구조)
plugins/supabase/
  agents/rls-reviewer.md, skills/supabase-start-check, supabase-end-check
i18n/ko/plugins/…          한국어 번역본 (Claude 는 읽지 않음)
```

- **원문은 영어, 번역본은 `i18n/ko/`.** 같은 경로 구조로 두고, 번역본 맨 위에 원문 링크를 단다. 원문을 고치면 번역본도 같이 고친다. 스킬이 사용자에게 하는 보고와 백로그 항목은 프로젝트 CLAUDE.md 가 정한 언어(없으면 대화 언어)로 쓴다.
- **프레임워크·언어별 내용은 references 로.** 점검 스킬이 프로젝트를 판별해(package.json 의 `svelte`·`react`, `go.mod`, `pyproject.toml` 등) 해당 reference 만 **반드시 끝까지 읽고** 그 점검을 같이 돌린다. 여러 개에 해당하면 전부 읽는다.

### 스택 플러그인이 끼어드는 방식

- `/task start`는 쓸 수 있는 스킬 중 이름이 **`-start-check`**로 끝나는 것을 전부 부른다. `/task end`는 **`-end-check`**로 끝나는 것을 전부 부른다.
- 플러그인을 끄면 그 스킬이 목록에서 빠지므로 그 점검도 빠진다. 켜져 있어도 프로젝트에 해당하지 않으면 "해당 없음"만 돌려준다.
- **점검 스킬은 명령만 돌린다.** 코드를 찾아 읽는 정보 취합은 `Explore` 에이전트 지시문으로, diff 를 읽고 판단하는 리뷰는 플러그인의 리뷰 에이전트로 돌려준다. `/task start`·`/task end`가 그 에이전트들을 기본 에이전트와 함께 동시에 띄운다. 메인 대화에서 직접 찾아다니거나 리뷰하지 않는다.
- 점검 스킬이 돌려주는 것:
  - 시작: 결과 표, **기준선**, **탐색에 넣을 지시문**, 플랜에 넣을 것, 물을 것, **구현 중 지킬 것**, **끝내기 전 할 것**
  - 종료: 결과 표(기준선과 비교해 새로 생긴 실패만), **리뷰에 넣을 에이전트**, **고친 뒤 할 것**
- 새 스택을 더하려면 `plugins/<스택>/skills/<스택>-start-check`, `<스택>-end-check`를 같은 형식으로 만들고 `marketplace.json`에 등록한다. 같은 스택 안의 갈래(프레임워크, 언어)는 플러그인을 나누지 않고 references 로 더한다.

## 흐름

```
/task create ──► docs/backlog/001-….md ──/task start──► 스택 시작 점검 ──► 플랜 모드(탐색·질문·설계) ──► 승인 ──► w/ 브랜치에서 구현
                                                                                                                       │
docs/done/001-….md ◄── 머지 ◄── 승인 ◄── 수정 ◄── 사용자 선택 ◄── 리뷰 에이전트 동시 실행 ◄── 스택 종료 점검 ◄── /task end
```

### 어디서 가져왔나

새로 지은 절차가 아니라 검증된 흐름을 이어 붙인 것이다. 출처의 방식을 바꾸지 않는다.

| 단계 | 출처 | 방식 |
| --- | --- | --- |
| 항목 형식, 좋은 항목, 완료 기준 | [Backlog.md](https://github.com/MrLesk/Backlog.md) 에이전트 지침 | 형식과 규칙을 가져옴 |
| `/task create`에서 무엇을 왜 하는지 묻기 | `superpowers:brainstorming` | 그대로 호출 |
| `/task start` 탐색, 질문, 설계안 | Anthropic `feature-dev` 플러그인 Phase 2~4 | 구조를 그대로 옮김 |
| `/task start` 계획 승인 | Claude Code 플랜 모드, `feature-dev` Phase 5 | 그대로 |
| `/task start` 구현과 완료 확인 | `superpowers:test-driven-development`, `verification-before-completion` | 그대로 호출 |
| 화면을 새로 만들거나 다시 디자인할 때 | Anthropic `frontend-design` | 그대로 호출 (frontend) |
| 브라우저 테스트 | Chrome DevTools 플러그인의 `chrome-devtools` 스킬 | 그대로 호출 (frontend) |
| Svelte 자동 교정과 문서 | Svelte 공식 플러그인 (`svelte-autofixer`, 문서 MCP) | 있으면 그대로 호출, 없으면 버전 고정 CLI (frontend/svelte) |
| React 규칙 | `eslint-plugin-react-hooks`, React Doctor, Vercel `react-best-practices` | 도구 실행·스킬 호출 (frontend/react) |
| `/task end` 리뷰 | 내장 스킬 `code-review`, `security-review`, `simplify` + 스택 리뷰 에이전트 | 에이전트마다 하나씩 그대로 호출 |
| `/task end` 리뷰를 돌리고 모으는 방식, 보고 기준 | `feature-dev` Phase 6과 `code-reviewer` 지시문 (80점 컷만 없앰) | 구조와 지시문을 그대로 옮김 |
| `/task end` 지적 처리 | `superpowers:receiving-code-review` | 그대로 호출 |
| `/task end` 승인과 머지 | `superpowers:finishing-a-development-branch` | 그대로 호출 |
| API 리뷰 기준 | OWASP API Security Top 10 2023, OWASP Logging Cheat Sheet, Google AIP-180 | 체크 항목으로 옮김 |

비교해 보고 쓰지 않은 것: Compound Engineering(스킬 38개, 흐름 전체를 바꿈), superpowers 의 계획·실행 스킬(`writing-plans`, `executing-plans`, `subagent-driven-development`, `using-git-worktrees` — 이 흐름과 겹침), `vercel-plugin`(React 규칙만 필요한데 세션 훅·텔레메트리·배포 스킬이 같이 옴).

## 설치

Claude Code 안에서 실행한다(터미널에서는 `claude plugin …`). 마켓플레이스를 먼저 추가한다. 스택 플러그인의 의존 플러그인이 거기서 온다.

```
/plugin marketplace add JiHoon777/j-dev-kit
/plugin marketplace add GoogleChrome/modern-web-guidance   # frontend 에 필요
/plugin marketplace add ChromeDevTools/chrome-devtools-mcp  # frontend 에 필요
/plugin install frontend@j-dev-kit
/plugin install supabase@j-dev-kit
/plugin install server@j-dev-kit
```

- 쓰는 스택만 설치한다. 스택 플러그인은 모두 `workflow`에 의존하므로, 어느 것을 설치해도 `/task`와 `superpowers`가 같이 설치되고 켜진다.
- `anthropic-plugin-directory`(superpowers, frontend-design, typescript-lsp, supabase)는 Claude Code 에 기본으로 들어 있어서 따로 추가할 것이 없다.
- `/plugin install`은 기본이 사용자 범위(모든 프로젝트)다. 저장소 하나에서만 켜려면 `claude plugin install <이름>@j-dev-kit --scope project`를 쓴다(아래).

Svelte 프로젝트면 공식 Svelte 플러그인도 권한다(없어도 점검은 버전 고정 CLI 로 돈다).

```
/plugin marketplace add sveltejs/ai-tools
/plugin install svelte@svelte
```

### 프로젝트에 고정하기

저장소에서 `--scope project`로 설치한다. Claude Code 가 마켓플레이스와 **의존 플러그인까지 포함한** 모든 플러그인을 `.claude/settings.json`에 적는다. 이 파일을 커밋하면 저장소를 연 사람에게 같은 구성이 제안되고, 각자 같은 명령으로 한 번 설치한다.

```bash
claude plugin marketplace add JiHoon777/j-dev-kit --scope project
claude plugin marketplace add GoogleChrome/modern-web-guidance --scope project
claude plugin marketplace add ChromeDevTools/chrome-devtools-mcp --scope project
claude plugin install frontend@j-dev-kit --scope project
claude plugin install supabase@j-dev-kit --scope project
```

결과는 이렇게 된다(frontend + supabase + Svelte):

```json
{
  "extraKnownMarketplaces": {
    "j-dev-kit": { "source": { "source": "github", "repo": "JiHoon777/j-dev-kit" } },
    "chrome-devtools-plugins": { "source": { "source": "github", "repo": "ChromeDevTools/chrome-devtools-mcp" } },
    "googlechrome": { "source": { "source": "github", "repo": "GoogleChrome/modern-web-guidance" } },
    "svelte": { "source": { "source": "github", "repo": "sveltejs/ai-tools" } }
  },
  "enabledPlugins": {
    "frontend@j-dev-kit": true,
    "supabase@j-dev-kit": true,
    "workflow@j-dev-kit": true,
    "superpowers@anthropic-plugin-directory": true,
    "frontend-design@anthropic-plugin-directory": true,
    "typescript-lsp@anthropic-plugin-directory": true,
    "chrome-devtools-mcp@chrome-devtools-plugins": true,
    "modern-web-guidance@googlechrome": true,
    "supabase@anthropic-plugin-directory": true,
    "svelte@svelte": true
  }
}
```

이 파일을 정리할 때 **의존 플러그인 줄을 지우지 않는다.** 의존 플러그인이 꺼져 있으면 그 플러그인이 로드되지 않고(`Dependency "workflow@j-dev-kit" is not installed`), 설치를 다시 돌려도 의존 플러그인이 전부 돌아오지는 않는다.

### 프로젝트 CLAUDE.md 에 적을 것

```markdown
## 작업 설정
- stack: frontend, supabase                 # 없으면 점검 스킬이 파일로 추정
- 기준 브랜치: main
- 검증 명령: pnpm verify                     # 린트·타입·테스트·빌드를 한 번에
- 린트 명령: pnpm lint
- 문서 언어: 한국어                          # 백로그 항목·보고 언어

## superpowers
이 문서의 규칙이 우선이다. `/task`가 부르는 스킬(brainstorming, test-driven-development,
verification-before-completion, receiving-code-review, finishing-a-development-branch)은 그대로 따르고,
그 밖의 계획·실행 스킬(writing-plans, executing-plans, subagent-driven-development, using-git-worktrees)은
이 흐름과 겹치므로 쓰지 않는다.
```

superpowers 는 세션을 시작할 때마다 "맞을 것 같으면 스킬을 반드시 쓰라"는 지시를 넣는다. 끄는 설정이 없어서, 위 문단으로 CLAUDE.md 가 우선이라고 적어 둬야 `/task start`의 플랜 단계를 가로채지 않는다.

### 서버 언어별 LSP (선택)

`server` 플러그인은 언어를 판별해 해당 LSP 가 없으면 설치를 권한다. 기본으로 들어 있는 `anthropic-plugin-directory`의 `pyright-lsp`, `gopls-lsp`, `jdtls-lsp`, `typescript-lsp`. 실행 파일(`pyright-langserver`, `gopls` 등)은 따로 설치해야 한다.

## 사용법

```
/task create 이메일·비밀번호 로그인 화면 추가   # 승인받은 뒤 docs/backlog/001-….md 를 만든다
/task start 001                                  # 플랜 모드에서 계획을 세우고, 승인 뒤 w/001-… 브랜치에서 구현한다
/task end                                        # 리뷰하고, 고를 것을 고치고, 항목을 끝내고, 승인받아 머지한다
```

- **프로젝트에서 처음 `/task create`를 하면** `docs/backlog/`(README, `_template.md`)와 `docs/done/`을 만들자고 제안하고 라벨을 묻는다.
- **`/task start`**는 커밋하지 않은 변경이나 다른 `w/` 브랜치가 있으면 먼저 멈춘다. 스택 시작 점검을 돌린 뒤, 플랜 모드에서 에이전트들로 코드를 동시에 탐색하고, 질문을 한꺼번에 묻고, 설계안 세 개와 추천을 보여 주고, 승인받은 뒤에 브랜치를 만든다. 구현은 메인 대화에서 테스트 먼저, 단계마다 커밋하며 한다.
- **`/task end`**는 스택 종료 점검과 리뷰 에이전트들을 동시에 돌리고, 지적을 확신도와 함께 전부 보여 준 뒤 지적마다 지금 고칠지, 나중에 고칠지(새 백로그 항목), 그대로 둘지 묻는다. 고친 뒤 다시 테스트하고, 항목을 `docs/done/`으로 옮기고, 머지 방법을 고르게 한다. 요청하지 않으면 푸시하지 않는다.
- **인자 없이** `/task`만 부르면 세 모드를 보여 주고 무엇을 할지 묻는다.

## 업데이트

업데이트는 **버전 단위**다. Claude Code 는 설치한 플러그인을 버전별 폴더(`~/.claude/plugins/cache/j-dev-kit/<플러그인>/<버전>/`)에 두고, `plugin.json`의 버전이 올라갔을 때만 바꾼다. 버전은 그대로이고 커밋만 새로 생기면 무시한다("already at the latest version").

새 릴리스를 받으려면:

```bash
claude plugin marketplace update j-dev-kit
claude plugin update workflow@j-dev-kit --scope project    # 설치한 플러그인마다, 설치할 때의 범위로 반복
```

그다음 **Claude Code 를 다시 시작한다.** 실행 중인 세션은 예전 스킬 내용을 그대로 쓴다.

### 변경을 내보낼 때 (관리자)

1. **파일이 바뀐 플러그인마다** `plugin.json`의 `version`을 올린다(그 플러그인 SKILL.md frontmatter 의 `version`도). 올리지 않으면 아무도 변경을 받지 못한다.
2. `claude plugin validate .`와 `claude plugin validate plugins/<이름>`.
3. 커밋하고 푸시한다.

## 문제 해결

| 증상 | 원인과 해결 |
| --- | --- |
| 설치 중 `Dependency "…" not found. Is the "…" marketplace added?` | 메시지에 나온 마켓플레이스를 추가하고(설치 절 참고) 다시 설치한다. |
| `claude plugin list`에 `Dependency "…" is not installed` | `enabledPlugins`에서 의존 플러그인이 지워졌다. 메시지의 명령으로 빠진 플러그인을 같은 `--scope`로 설치한다. |
| `/task start`가 스택 점검을 하나도 안 돈다 | 이 프로젝트에서 스택 플러그인이 꺼져 있거나, 이 프로젝트에 해당하지 않는다고 판단했다(CLAUDE.md 의 `stack:`을 확인). |
| superpowers 가 자기 brainstorming 이나 계획 파일을 시작한다 | 위의 superpowers 문단을 프로젝트 CLAUDE.md 에 넣는다. |
| 푸시한 변경이 업데이트해도 안 보인다 | 플러그인 `version`을 올리지 않았거나 Claude Code 를 다시 시작하지 않았다(업데이트 절 참고). |

## 알아 둘 것

- **마이그레이션 담당은 하나.** 서버 마이그레이션 도구(Prisma, Drizzle, TypeORM, Alembic, Django, Atlas, Flyway, Liquibase, golang-migrate)가 있으면 데이터베이스가 Supabase 여도 `server` 플러그인이 마이그레이션 점검을 맡는다. 없고 `supabase/migrations/`가 있으면 `supabase` 플러그인이 맡는다. 둘 다 있으면 어느 쪽이 기준인지 묻는다. 담당이 아닌 쪽은 마이그레이션 항목을 건너뛰므로 같은 DB 를 두 번 검사하지 않는다.
- `/task`는 직접 입력할 때만 실행된다(`disable-model-invocation: true`). "백로그에 넣어 줘"라고 말해도 저절로 실행되지 않으니 `/task create …`로 부른다. `start`가 저절로 실행되는 것을 막기 위해서다.
- 의존 플러그인은 Claude Code 에 실제로 있는 마켓플레이스를 가리킨다. Anthropic 플러그인(superpowers, frontend-design, typescript-lsp, supabase)은 기본으로 들어 있는 `anthropic-plugin-directory`에서, Chrome DevTools 는 Google 의 자체 마켓플레이스 `chrome-devtools-plugins`에서 가져온다. 같은 플러그인을 다른 마켓플레이스 이름(예: `supabase@claude-plugins-official`)으로 또 켜지 않는다. 같은 MCP 서버가 두 번 뜬다.
- **외부 CLI 는 버전을 고정한다.** 스킬이 `npx`로 내려받아 실행하는 도구(React Doctor, `@sveltejs/mcp`, `sv`, `skills`)는 공개된 지 2주 넘은 버전으로 고정했다. 올릴 때는 새 버전을 확인하고 숫자만 바꾼다. 프로젝트 도구(Prisma, Drizzle, TypeORM)는 `npx --no-install`로 프로젝트에 설치된 것만 쓴다. `modern-web-guidance`는 플러그인 스킬에 맡기고 명령을 적지 않는다.

### Supabase MCP (프로젝트별)

프로젝트마다 `.mcp.json`에 Supabase MCP 서버를 직접 연결한다. 읽기 전용, 프로젝트 하나로 한정한다(`<ref>`는 `https://xxxx.supabase.co`의 xxxx).

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

`supabase` 점검과 `rls-reviewer`는 이 서버를 쓴다. 선언된 서버가 없으면 MCP 항목은 건너뛴다. 처음 쓸 때 서버 승인과 Supabase 로그인을 요청한다(`/mcp`).

공식 Supabase 플러그인은 스킬(`supabase`, `supabase-postgres-best-practices`) 때문에 의존성으로 같이 설치되는데, 자기 MCP 서버도 가져온다. 이 서버는 `read_only` 없이 연결되고 이를 바꾸는 옵션이 없다. 플러그인 서버는 주소로 같은 서버인지 판단하고 `?read_only=true`를 붙이면 다른 주소가 되므로, 프로젝트 `.mcp.json`으로 대체할 수도 없다. 플러그인은 두고 그 MCP 서버만 끈다. 그러면 스킬도 `local_supabase`를 쓴다. 방법은 둘이고, 하나만 해도 되고 둘 다 해도 된다.

- **`/mcp` → `plugin:supabase:supabase` → 끄기.** 연결도 로그인 요청도 하지 않는다. 내 `~/.claude.json`에 프로젝트별로 저장되므로 사람마다 한 번씩 한다.
- **프로젝트 `.claude/settings.json`의 deny 규칙**(커밋되어 모두에게 적용). 도구가 Claude 의 도구 목록에서 빠진다. 서버 자체는 `/mcp`에 남는다.

```json
{
  "permissions": {
    "deny": [
      "mcp__plugin_supabase_supabase__*"
    ]
  }
}
```

### CLI 로 하는 Supabase 쓰기 막기 (선택)

Supabase CLI 와 `psql`은 원격 프로젝트에 로그인하거나 연결돼 있으면 여전히 바꿀 수 있다. 이것도 막으려면 같은 `deny` 목록에 아래를 더한다. 로컬 작업(`supabase start`, `--linked` 없는 `supabase db reset`, `supabase migration list --local`, `127.0.0.1`로의 `psql`)은 그대로 된다.

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

설정으로 막을 수 없는 것: 앱 자체. 데이터를 저장하는 브라우저 테스트는 앱의 env 파일이 가리키는 프로젝트에 쓴다.
