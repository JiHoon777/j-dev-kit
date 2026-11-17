# j-dev-kit

Claude Code용 개인 플러그인 마켓플레이스. 작업 흐름(백로그 → 시작 → 리뷰·머지)은 하나로 두고, 스택마다 다른 점검은 스택 플러그인으로 나눴다. 켠 플러그인의 점검만 돈다. 여러 개를 같이 켜도 충돌하지 않는다.

## 구성

| 플러그인 | 스킬 · 에이전트 | 같이 설치되는 것 |
| --- | --- | --- |
| `workflow` | `/backlog-create`, `/task-start`, `/task-end` | `superpowers` |
| `frontend` | `frontend-start-check`, `frontend-end-check`, 에이전트 `ui-reviewer` | `chrome-devtools-mcp`, `typescript-lsp`, `frontend-design`, `modern-web-guidance` |
| `svelte` | `svelte-start-check`, `svelte-end-check`, 에이전트 `svelte-reviewer` | `svelte` (공식: MCP svelte-autofixer, 문서) |
| `react` | `react-start-check`, `react-end-check`, 에이전트 `react-reviewer` | — (eslint-plugin-react-hooks, React Doctor CLI 를 쓴다) |
| `supabase` | `supabase-start-check`, `supabase-end-check`, 에이전트 `rls-reviewer` | `supabase` (공식: 스킬, MCP) |
| `server` | `server-start-check`, `server-end-check`, 에이전트 `api-reviewer` | — (언어별 LSP 는 아래 참고) |

### 스택 플러그인이 끼어드는 방식

- `/task-start`는 쓸 수 있는 스킬 중 이름이 **`-start-check`**로 끝나는 것을 전부 부른다. `/task-end`는 **`-end-check`**로 끝나는 것을 전부 부른다.
- 플러그인을 끄면 그 스킬이 목록에서 빠지므로 그 점검도 빠진다.
- 각 점검 스킬은 프로젝트에 해당하지 않으면 "해당 없음"만 돌려준다. 예를 들어 frontend·svelte·react 를 다 켜 둬도 Svelte 프로젝트에서는 react 점검이 빠진다.
- **점검 스킬은 명령만 돌린다.** 코드를 찾아 읽는 정보 취합은 `Explore` 에이전트 지시문으로, diff 를 읽고 판단하는 리뷰는 플러그인의 리뷰 에이전트로 돌려준다. `/task-start`·`/task-end`가 그 에이전트들을 기본 에이전트와 함께 동시에 띄운다. 메인 대화에서 직접 찾아다니거나 리뷰하지 않는다.
- 점검 스킬이 돌려주는 것:
  - 시작: 결과 표, **기준선**(작업 전 검사 결과), **탐색에 넣을 지시문**, 플랜에 넣을 것, 물을 것, **구현 중 지킬 것**, **끝내기 전 할 것**
  - 종료: 결과 표(기준선과 비교해 새로 생긴 실패만), **리뷰에 넣을 에이전트**, **고친 뒤 할 것**
- 새 스택을 더하려면 `plugins/<스택>/skills/<스택>-start-check`, `<스택>-end-check`를 같은 형식으로 만들고 `marketplace.json`에 등록한다.

## 흐름

```
/backlog-create ──► docs/backlog/001-….md ──/task-start──► 스택 시작 점검 ──► 플랜 모드(탐색·질문·설계) ──► 승인 ──► w/ 브랜치에서 구현
                                                                                                                         │
docs/done/001-….md ◄── 머지 ◄── 승인 ◄── 수정 ◄── 사용자 선택 ◄── 리뷰 에이전트 동시 실행 ◄── 스택 종료 점검 ◄── /task-end
```

### 어디서 가져왔나

세 명령은 새로 지은 절차가 아니라 검증된 흐름을 이어 붙인 것이다. 출처의 방식을 바꾸지 않는다.

| 단계 | 출처 | 방식 |
| --- | --- | --- |
| 항목 형식, 좋은 항목, 완료 기준 | [Backlog.md](https://github.com/MrLesk/Backlog.md) 에이전트 지침 | 형식과 규칙을 가져옴 |
| `/backlog-create`에서 무엇을 왜 하는지 묻기 | `superpowers:brainstorming` | 그대로 호출 |
| `/task-start` 탐색, 질문, 설계안 | Anthropic `feature-dev` 플러그인 Phase 2~4 | 구조를 그대로 옮김 |
| `/task-start` 계획 승인 | Claude Code 플랜 모드, `feature-dev` Phase 5 | 그대로 |
| `/task-start` 구현과 완료 확인 | `superpowers:test-driven-development`, `verification-before-completion` | 그대로 호출 |
| 화면을 새로 만들거나 다시 디자인할 때 | Anthropic `frontend-design` | 그대로 호출 (frontend 플러그인) |
| 브라우저 테스트 | Chrome DevTools 플러그인의 `chrome-devtools` 스킬 | 그대로 호출 (frontend 플러그인) |
| Svelte 자동 교정과 문서 | Svelte 공식 플러그인 | 그대로 호출 (svelte 플러그인) |
| `/task-end` 리뷰 | 내장 스킬 `code-review`, `security-review`, `simplify` + 스택 리뷰 에이전트 | 에이전트마다 하나씩 그대로 호출 |
| `/task-end` 리뷰를 돌리고 모으는 방식, 보고 기준 | `feature-dev` Phase 6과 `code-reviewer` 지시문 (80점 컷만 없앰) | 구조와 지시문을 그대로 옮김 |
| `/task-end` 지적 처리 | `superpowers:receiving-code-review` | 그대로 호출 |
| `/task-end` 승인과 머지 | `superpowers:finishing-a-development-branch` | 그대로 호출 |
| API 리뷰 기준 | OWASP API Security Top 10 2023, OWASP Logging Cheat Sheet, Google AIP-180 | 체크 항목으로 옮김 |

비교해 보고 쓰지 않은 것: Compound Engineering(스킬 38개, 흐름 전체를 바꿈), superpowers 의 계획·실행 스킬(`writing-plans`, `executing-plans`, `subagent-driven-development`, `using-git-worktrees` — 이 흐름과 겹침), `vercel-plugin`(React 규칙만 필요한데 세션 훅·텔레메트리·배포 스킬이 같이 옴).

## 설치

마켓플레이스 추가:

```
/plugin marketplace add JiHoon777/j-dev-kit
/plugin marketplace add sveltejs/ai-tools                 # svelte 플러그인을 쓸 때
/plugin marketplace add GoogleChrome/modern-web-guidance  # frontend 플러그인을 쓸 때
```

필요한 것만 설치한다. 같이 설치되는 것(위 표)은 자동으로 따라온다.

```
/plugin install workflow@j-dev-kit
/plugin install frontend@j-dev-kit
/plugin install svelte@j-dev-kit
/plugin install supabase@j-dev-kit
```

### 프로젝트에 고정하기

프로젝트의 `.claude/settings.json`에 적어 두면 저장소를 연 사람에게 같은 구성이 제안된다. 플러그인 자체는 각자 한 번 설치한다(`claude plugin install <이름>@<마켓> --scope project`).

```json
{
  "extraKnownMarketplaces": {
    "j-dev-kit": { "source": { "source": "github", "repo": "JiHoon777/j-dev-kit" } },
    "svelte": { "source": { "source": "github", "repo": "sveltejs/ai-tools" } },
    "googlechrome": { "source": { "source": "github", "repo": "GoogleChrome/modern-web-guidance" } }
  },
  "enabledPlugins": {
    "workflow@j-dev-kit": true,
    "frontend@j-dev-kit": true,
    "svelte@j-dev-kit": true,
    "supabase@j-dev-kit": true
  }
}
```

### 프로젝트 CLAUDE.md 에 적을 것

```markdown
## 작업 설정
- stack: frontend, svelte, supabase        # 없으면 점검 스킬이 파일로 추정
- 기준 브랜치: main
- 검증 명령: pnpm verify                     # 린트·타입·테스트·빌드를 한 번에
- 린트 명령: pnpm lint

## superpowers
이 문서의 규칙이 우선이다. `/task-start`, `/task-end`, `/backlog-create`가 부르는 스킬
(brainstorming, test-driven-development, verification-before-completion, receiving-code-review,
finishing-a-development-branch)은 그대로 따르고, 그 밖의 계획·실행 스킬(writing-plans,
executing-plans, subagent-driven-development, using-git-worktrees)은 이 흐름과 겹치므로 쓰지 않는다.
```

superpowers 는 세션을 시작할 때마다 "맞을 것 같으면 스킬을 반드시 쓰라"는 지시를 넣는다. 끄는 설정이 없어서, 위 문단으로 CLAUDE.md 가 우선이라고 적어 둬야 `/task-start`의 플랜 단계를 가로채지 않는다.

### 서버 언어별 LSP (선택)

`server` 플러그인은 언어를 판별해 해당 LSP 가 없으면 설치를 권한다. Anthropic 공식 마켓플레이스의 `pyright-lsp`, `gopls-lsp`, `jdtls-lsp`, `kotlin-lsp`, `typescript-lsp`. 실행 파일(`pyright-langserver`, `gopls` 등)은 따로 설치해야 한다.

## 알아 둘 것

- `supabase` 플러그인은 공식 Supabase 플러그인을 `supabase@claude-plugins-official`로 가져온다. claude.ai 디렉터리에서 같은 플러그인을 다른 이름(예: `supabase@anthropic-plugin-directory`)으로 이미 켜 두었다면 둘 중 하나만 켠다. 같은 MCP 서버가 두 번 뜬다.
- `react` 플러그인의 React Doctor 는 `npx`로 내려받아 돌리고(버전 고정) `--no-telemetry`를 붙인다. Vercel `react-best-practices` 스킬은 Claude 마켓플레이스가 없어서 `npx -y skills@1.7.5 add vercel-labs/agent-skills`로 따로 설치한다(없어도 점검은 돈다).
- **외부 CLI 는 버전을 고정한다.** 스킬이 `npx`로 내려받아 실행하는 도구(React Doctor, `@sveltejs/mcp`, `sv`, `skills`)는 공개된 지 2주 넘은 버전으로 고정했다. 올린 사람의 패키지가 오염돼도 바로 실행되지 않게 하려는 것이다. 올릴 때는 새 버전을 확인하고 숫자만 바꾼다. 프로젝트 도구(Prisma, Drizzle, TypeORM)는 `npx --no-install`로 프로젝트에 설치된 것만 쓴다.
- Supabase MCP 는 실제 서비스 프로젝트에 연결하지 않는다. 연결해야 하면 읽기 전용으로, 프로젝트 하나로 범위를 좁힌다.
