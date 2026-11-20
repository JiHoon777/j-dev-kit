# j-dev-kit

**한국어** | [English](README.en.md)

Claude Code 개인 플러그인 마켓플레이스. 작업 흐름은 `/task` 하나, 스택별 점검은 스택 플러그인으로 나눴다. 여러 항목을 한 세션에서 지휘할 때는 `/lead`를 쓴다. 아키텍처 설계·리뷰는 `/arch`, UI 시안·디자인 리뷰는 `/ui`로 따로 쓴다(둘 다 스택과 상관없음).

| 플러그인 | 들어 있는 것 | 같이 설치되는 것 |
| --- | --- | --- |
| `workflow` | `/task create`, `/task start`, `/task end`, `/lead run`, `/lead scout`, `/lead schedule`, `backlog-scout` | `superpowers` |
| `frontend` | Svelte·React 점검, `frontend-reviewer`, 브라우저 확인을 맡는 `frontend-evaluator` | `workflow`, `typescript-lsp`, `frontend-design` |
| `server` | 서버·Supabase 점검(마이그레이션, API 스펙, 키), `api-reviewer`, `supabase-reviewer` | `workflow` |
| `architecture` | `/arch design`, `/arch review`, `architecture-reviewer`, `architecture-researcher` | 없음 |
| `design` | `/ui system`, `/ui mockup`, `/ui review`, `design-reviewer` | 없음 |

Supabase 를 쓰면 프론트엔드에서 바로 부르더라도 `server`를 설치한다.

## 설치

```bash
claude plugin marketplace add JiHoon777/j-dev-kit --scope project
claude plugin install frontend@j-dev-kit --scope project
claude plugin install server@j-dev-kit --scope project
claude plugin install architecture@j-dev-kit --scope project
claude plugin install design@j-dev-kit --scope project
```

쓰는 스택만 설치한다. `architecture`와 `design`은 어떤 프로젝트에나 따로 설치할 수 있다. `.claude/settings.json`에 적힌 의존 플러그인 줄은 지우지 않는다.

프로젝트 CLAUDE.md 에 적는다.

```markdown
## 작업 설정
- stack: frontend, server
- 기준 브랜치: main
- 검증 명령: pnpm verify
- 문서 언어: 한국어
- 동시 작업 세션: 2

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
- **검증 훅:** `w/` 브랜치에서 항목의 Definition of Done 을 체크하고 멈추면, 훅이 CLAUDE.md 의 `검증 명령:`을 직접 돌린다. 실패하면 출력과 함께 한 번 되돌려 보낸다. 코드가 그대로면 다시 돌리지 않는다. 스킬이 이미 돌린 검증과 겹쳐 단계마다 한 번 더 돌 수 있다. Windows 에서는 Git Bash 가 필요하다.
- **브라우저 확인:** UI 가 바뀌면 구현한 세션이 아니라 `frontend-evaluator` 에이전트가 실행 중인 화면에서 Acceptance Criteria 를 하나씩 판정한다.

### 진두지휘

```
/lead schedule 평일 아침 9시     # scout 을 주기 실행으로 건다
/lead scout                      # 지금 한 번: 제안함(docs/backlog/_proposals.md) 갱신
/lead run                        # 제안 승격 → 항목마다 작업 세션 → 계획·머지 지점에서 보고 → 머지
/lead run 003 005                # 고른 항목만
```

- **scout:** `backlog-scout` 에이전트가 저장소를 읽고 아이디어·백로그 정리·개선 제안을 제안함 파일 하나에 쓴다. 부른 세션은 다 쓴 제안함만 읽어 보여 준다. 제안은 쌓이고(관점마다 최대 10개) 해결된 것만 빠진다. 근거 없으면 제안하지 않고, 없으면 "없음". 제안은 사용자가 승격해야 항목이 된다.
- **run:** 상위 세션은 코드를 고치지 않는다. 승격한 제안은 `/task create` 절차로 항목을 만들고, 항목마다 자기 워크트리의 작업 세션을 띄워 `/task start`·`end` 절차를 그대로 따르게 하고, 보고를 직접 확인한 뒤 올린다. 작업 세션이 `/task` 절차에서 사용자에게 물을 것(질문, 계획 승인, 리뷰 지적 결정)은 상위 세션이 받아 올린다. 머지는 상위 세션이 `/task end`의 마무리 단계대로 하나씩 하고, 충돌은 그때 풀고 매번 검증한다.
- 세션 시작과 예약은 앱이 주는 기능을 쓴다. 예약 실행은 앱이 열려 있을 때만 돈다. 세션 시작 도구가 없으면 워크트리로 격리한 서브에이전트로 돈다.

### 아키텍처

```
/arch design 팀 일정 공유 웹앱 (새 프로젝트)   # 품질 목표 → 스택 서베이 → 구조 → 승인 → 개요 문서·ADR
/arch design 결제 수단 추가 구조              # 기존 프로젝트: 기존 스택과 ADR 을 제약으로
/arch review                                   # 시스템 지도 확인 → git 측정 → 리뷰 → 지적별로 ADR / 부채 / 그대로
/arch review src/billing --research            # 경로 하나, 최신 구조 지침도 서베이
```

- 기준은 출처가 있는 것만 쓴다(ISO 25010 유지보수성, 정보 은닉·깊은 모듈, 결합도·응집도, 피트니스 함수, arc42 품질 목표 등). 코딩 에이전트에 대한 연구 근거가 있는 항목에만 그 근거를 덧붙인다.
- 스택 추천은 항상 웹 서베이로 버전·지원 종료·유지보수 상태를 확인한다. 구조 지침 서베이는 `--research`일 때만.
- 코드는 고치지 않는다. 쓰는 것은 `docs/architecture/`의 개요 문서, ADR, 리서치 파일뿐이고 쓰기 전에 묻는다.

### 디자인

```
/ui system                     # 코드의 토큰으로 DESIGN.md 만들기·갱신, CLAUDE.md 에 @DESIGN.md
/ui mockup 로그인 화면          # 시안 1개 또는 여러 개 → 캔버스에서 고르기 → docs/design/<NNN>-<slug>/ 에 기록
/ui review http://localhost:5173/login   # 1440/768/375 폭, DESIGN.md·고른 시안·WCAG AA 기준 리뷰
```

- 시안은 Claude Code 디자인 캔버스(claude.ai 로그인, CLI·데스크톱)에 그린다. 못 쓰면 단일 `variants.html`로 대신한다.
- 미감·접근성 규칙은 캔버스와 `frontend-design`에 맡기고, 이 플러그인은 절차(브리프, 시안 수, 방향, 고르기, 기록)만 담는다.

## 구조

```
plugins/workflow/skills/task/       SKILL.md + references/create.md, start.md, end.md
plugins/workflow/skills/lead/       SKILL.md + references/run.md, scout.md, schedule.md
plugins/workflow/agents/            backlog-scout.md
plugins/workflow/hooks/             hooks.json, verify-on-stop.sh (Stop 훅)
plugins/frontend/                   skills/frontend-{start,end}-check, agents/frontend-reviewer.md, frontend-evaluator.md
plugins/server/                     skills/server-{start,end}-check, agents/api-reviewer.md, supabase-reviewer.md
plugins/architecture/               skills/arch (SKILL.md + references/), agents/architecture-{reviewer,researcher}.md
plugins/design/                     skills/ui (SKILL.md + references/), agents/design-reviewer.md
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
| 멈출 때 검증 명령이 돈다 | 검증 훅이다. 항목의 Definition of Done 이 체크돼 있고 코드가 마지막 통과 뒤에 바뀌었을 때만 돈다. CLAUDE.md 에 `검증 명령:` 줄이 없으면 돌지 않는다. |
| 스택 점검이 하나도 안 돈다 | 플러그인이 꺼져 있거나 CLAUDE.md 의 `stack:`에 빠져 있다. |

## 출처

[Backlog.md](https://github.com/MrLesk/Backlog.md) 항목 형식, [superpowers](https://github.com/obra/superpowers)(brainstorming, TDD, 완료 전 검증, 리뷰 받기, 브랜치 마무리), [spec-kit](https://github.com/github/spec-kit)(질문 최대 3개), [compound-engineering](https://github.com/EveryInc/compound-engineering-plugin)(크기에 맞춘 계획), [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills), Claude Code 내장 `code-review`·`security-review`·`simplify`, OWASP API Security Top 10, [supabase/agent-skills](https://github.com/supabase/agent-skills), Anthropic [Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices).

검증 훅과 `frontend-evaluator`: Claude Code [hooks](https://code.claude.com/docs/en/hooks.md)(꼭 지킬 것은 지침이 아니라 훅으로), Anthropic [harness design](https://www.anthropic.com/engineering/harness-design-long-running-apps)(만든 쪽과 따로 둔 평가자가 실행 중인 앱을 직접 써 본다).

`/lead`: [GitHub Agentic Workflows safe outputs](https://github.github.com/gh-aw/reference/safe-outputs/)(실행당 상한, 할 일 없음 허용, 제안은 사람이 승격), [Langfuse 주간 다이제스트](https://langfuse.com/blog/2026-03-13-weekly-digest-ai-skill)(근거 링크, 다음 단계 분명함 / 논의 필요), Anthropic [multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)(워커는 산출물과 짧은 요약으로 보고)·[long-running harness](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)(상태는 파일과 git 에, 테스트를 지우지 않는다), Claude Code [scheduled tasks](https://code.claude.com/docs/en/desktop-scheduled-tasks.md). 관점마다 10개라는 숫자는 근거가 있는 값이 아니라 기본값이다.

`architecture`: ISO/IEC 25010:2023, Parnas(정보 은닉), Ousterhout(깊은 모듈), *Building Evolutionary Architectures*(피트니스 함수), [arc42](https://arc42.org/), [MADR](https://adr.github.io/madr/), [Choose Boring Technology](https://mcfunley.com/choose-boring-technology), Azure Architecture Center·AWS Decision Guides, [endoflife.date](https://endoflife.date/)·[deps.dev](https://deps.dev/)·[OpenSSF Scorecard](https://scorecard.dev/). 아이디어를 빌린 스킬: [alexei-led/architect](https://github.com/alexei-led/architect)(지도 확인 후 판단, 증거 없으면 확인 못 함), [mattpocock/skills](https://github.com/mattpocock/skills) `improve-codebase-architecture`(핫스팟, 삭제 테스트), [mblode/agent-skills](https://github.com/mblode/agent-skills) `codebase-architecture`(새 에이전트로 레시피 따라 하기). 기준의 AI 근거 논문은 `criteria.md`에 링크.

`design`: [Google DESIGN.md](https://github.com/google-labs-code/design.md), WCAG 2.2, Claude Code [artifacts](https://code.claude.com/docs/en/artifacts.md). 아이디어를 빌린 스킬: [emilkowalski/skills](https://github.com/emilkowalski/skills) `prototype`(이름과 축, 3~5개, 고를 때까지 멈춤), [compound-engineering](https://github.com/EveryInc/compound-engineering-plugin) `ce-prototype`(`decisions.md`), [impeccable](https://github.com/pbakaus/impeccable)(축 목록, 정체성 고정), [gstack](https://github.com/garrytan/gstack) `design-shotgun`(헤드라인 바꾸기 테스트), [OneRedOak/claude-code-workflows](https://github.com/OneRedOak/claude-code-workflows) `design-review`(폭별 실제 화면 리뷰).
