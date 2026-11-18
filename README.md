# j-dev-kit

**한국어** | [English](README.en.md)

Claude Code 개인 플러그인 마켓플레이스. 작업 흐름은 `/task` 하나, 스택별 점검은 스택 플러그인으로 나눴다.

| 플러그인 | 들어 있는 것 | 같이 설치되는 것 |
| --- | --- | --- |
| `workflow` | `/task create`, `/task start`, `/task end` | `superpowers` |
| `frontend` | Svelte·React 점검, 브라우저 확인, `frontend-reviewer` | `workflow`, `typescript-lsp`, `frontend-design` |
| `server` | 서버·Supabase 점검(마이그레이션, API 스펙, 키), `api-reviewer`, `supabase-reviewer` | `workflow` |

Supabase 를 쓰면 프론트엔드에서 바로 부르더라도 `server`를 설치한다.

## 설치

```bash
claude plugin marketplace add JiHoon777/j-dev-kit --scope project
claude plugin install frontend@j-dev-kit --scope project
claude plugin install server@j-dev-kit --scope project
```

쓰는 스택만 설치한다. `.claude/settings.json`에 적힌 의존 플러그인 줄은 지우지 않는다.

프로젝트 CLAUDE.md 에 적는다.

```markdown
## 작업 설정
- stack: frontend, server
- 기준 브랜치: main
- 검증 명령: pnpm verify
- 문서 언어: 한국어

## superpowers
이 문서의 규칙이 우선이다. `/task`가 부르는 스킬만 따르고, writing-plans, executing-plans,
subagent-driven-development, using-git-worktrees 는 쓰지 않는다.
```

superpowers 문단이 없으면 superpowers 가 `/task start`의 계획 단계를 가로챈다.

### 있으면 쓰는 것

| 플러그인 · 스킬 | 설치 |
| --- | --- |
| Svelte 공식 | `/plugin marketplace add sveltejs/ai-tools`, `/plugin install svelte@svelte` |
| Chrome DevTools | `/plugin marketplace add ChromeDevTools/chrome-devtools-mcp`, `/plugin install chrome-devtools-mcp@chrome-devtools-plugins` |
| modern-web-guidance | `/plugin marketplace add GoogleChrome/modern-web-guidance`, `/plugin install modern-web-guidance@googlechrome` |
| Vercel react-best-practices | `npx -y skills@1.7.5 add vercel-labs/agent-skills` |
| Supabase 공식 | `/plugin install supabase@anthropic-plugin-directory` (같이 오는 MCP 는 `/mcp`에서 끈다) |

## 사용법

```
/task create 이메일·비밀번호 로그인 화면 추가   # docs/backlog/001-….md
/task start 001                                  # 계획 → 승인 → w/001-… 브랜치에서 구현
/task end                                        # 리뷰 → 고치기 → 항목 닫기 → 머지
```

- **start:** 기준선(검증 명령 한 번), 스택 시작 점검, 크기에 맞춘 계획(작은 항목은 에이전트 없이), 테스트 먼저 구현, `simplify`로 정리, 검증.
- **end:** 스택 종료 점검, 리뷰(`code-review` + 필요할 때 `security-review`·스택 리뷰어), 지적을 🔴 꼭 고칠 것 / 🟡 고려 / ⚪ 사소함으로 보여 주고 구분별로 묻기, 고치기, 검증, 머지. 푸시는 요청할 때만.

## 구조

```
plugins/workflow/skills/task/       SKILL.md + references/create.md, start.md, end.md
plugins/frontend/                   skills/frontend-{start,end}-check, agents/frontend-reviewer.md
plugins/server/                     skills/server-{start,end}-check, agents/api-reviewer.md, supabase-reviewer.md
i18n/en/                            영어 번역본 (Claude 는 읽지 않음)
```

- 원문은 한국어(`plugins/`), 번역본은 `i18n/en/`. 원문을 고치면 번역본도 고친다.
- `/task start`는 이름이 `-start-check`로, `/task end`는 `-end-check`로 끝나는 스킬을 모두 부른다. 새 스택은 같은 이름 규칙으로 플러그인을 만들어 `marketplace.json`에 등록한다.

## 업데이트

```bash
claude plugin marketplace update j-dev-kit
claude plugin update <플러그인>@j-dev-kit --scope project
```

그다음 세션을 새로 연다. 관리자는 바뀐 플러그인의 `plugin.json` `version`을 올리고 `claude plugin validate .`를 돌린 뒤 푸시한다. 버전이 같으면 업데이트되지 않는다.

## 문제 해결

| 증상 | 해결 |
| --- | --- |
| `supabase@j-dev-kit`을 찾을 수 없다 | `server`로 합쳤다. `enabledPlugins`에서 지우고 `server@j-dev-kit`을 설치한다. |
| `Dependency "…" is not installed` | 지워진 의존 플러그인을 같은 `--scope`로 설치한다. |
| 스택 점검이 하나도 안 돈다 | 플러그인이 꺼져 있거나 CLAUDE.md 의 `stack:`에 빠져 있다. |

## 출처

[Backlog.md](https://github.com/MrLesk/Backlog.md) 항목 형식, [superpowers](https://github.com/obra/superpowers)(brainstorming, TDD, 완료 전 검증, 리뷰 받기, 브랜치 마무리), [spec-kit](https://github.com/github/spec-kit)(질문 최대 3개), [compound-engineering](https://github.com/EveryInc/compound-engineering-plugin)(크기에 맞춘 계획), [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills), Claude Code 내장 `code-review`·`security-review`·`simplify`, OWASP API Security Top 10, [supabase/agent-skills](https://github.com/supabase/agent-skills), Anthropic [Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices).
