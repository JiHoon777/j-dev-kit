# j-dev-kit

**한국어** | [English](README.en.md)

Claude Code 개인 플러그인 마켓플레이스. 작업 흐름은 `/task` 하나, 스택별 점검은 스택 플러그인으로 나눴다. `/task`는 직접 쳐도 되고, "백로그에 넣어 줘", "006 시작해 줘"처럼 말하면 Claude 가 알아서 부른다.

| 플러그인 | 들어 있는 것 | 같이 설치되는 것 |
| --- | --- | --- |
| `workflow` | `/task create`, `/task start`, `/task end`, 검증 Stop 훅, 화면 리뷰를 맡는 `design-reviewer` | `superpowers` |
| `frontend` | Svelte·React 점검, `frontend-reviewer`, 브라우저 확인을 맡는 `frontend-evaluator` | `workflow`, `typescript-lsp`, `frontend-design` |
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
/task create 이메일·비밀번호 로그인 화면 추가   # 하위 세션에서 docs/backlog/001-….md 쓰기
/task start 001                                  # 워크트리 하위 세션에서 계획 → 승인 → w/001-… 브랜치에서 구현
/task end                                        # 그 세션에서: 리뷰 → 고치기 → 항목 닫기 → 머지
/task start 001 --here                           # 하위 세션 없이 이 세션에서
```

- **하위 세션:** `create`와 `start`는 기본으로 세션을 하나 띄우고 링크만 알린다. `create`는 같은 폴더에서(기준 브랜치에 있을 때만. 작업 브랜치나 워크트리에서는 이 세션에서 한다), `start`는 기준 브랜치에서 딴 새 워크트리(`w/<항목>` 브랜치)에서 돈다. 질문과 승인은 그 세션을 열어 직접 한다. 작업하던 세션을 닫았으면 `start <번호>`가 이 세션에서 그 브랜치를 이어 간다. `end`는 작업한 세션에서 부른다. 세션을 새로 띄우는 도구가 없으면(데스크톱 앱이 아닌 곳) 이 세션에서 한다. 여러 항목을 함께 하려면 `start`를 여러 번 부르면 된다.

- **start:** 기준선(검증 명령 한 번), 스택 시작 점검, 크기에 맞춘 계획(작은 항목은 에이전트 없이), 테스트 먼저 구현, `simplify`로 정리, 검증.
- **end:** 스택 종료 점검, 리뷰(`code-review` + 필요할 때 `security-review`·스택 리뷰어·화면이 바뀌면 `design-reviewer`), 지적을 🔴 꼭 고칠 것 / 🟡 고려 / ⚪ 사소함으로 보여 주고 구분별로 묻기, 고치기, 검증, 머지. 푸시는 요청할 때만.
- **검증 훅:** `w/` 브랜치에서 항목의 Definition of Done 을 체크하고 멈추면, 훅이 CLAUDE.md 의 `검증 명령:`을 직접 돌린다. 실패하면 출력과 함께 되돌려 보내는데, 같은 내용으로는 한 번뿐이다. 코드가 그대로면 다시 돌리지 않는다. `/goal` 같은 다른 Stop 훅이 멈춤을 막은 뒤에도 돈다. 스킬이 이미 돌린 검증과 겹쳐 단계마다 한 번 더 돌 수 있다. Windows 에서는 Git Bash 가 필요하다.
- **포트:** CLAUDE.md `## 작업 설정`에 `- 웹 포트: 5000`, `- 서버 포트: 6000`을 두면 항목마다 `기준 포트 + 항목 번호`(항목 007 → 5007, 6007)를 항목의 `### 포트`에 적고, 개발 서버를 띄우는 점검과 `design-reviewer` 리뷰가 그 포트를 쓴다. 그 포트를 이미 누가 쓰고 있으면 1씩 올린다. 여러 프로젝트를 함께 한다면 프로젝트마다, 그리고 웹과 서버끼리 기준 포트를 1000씩 떨어뜨린다(예: 프로젝트 A 웹 5000·서버 6000, 프로젝트 B 웹 7000·서버 8000). 항목 번호가 세 자리라 겹치지 않는다. Supabase·DB 포트는 나누지 않는다.
- **워크트리:** 하위 세션의 워크트리가 저장소 안에 생기면(예: `.claude/worktrees/`) 테스트·린트 도구 설정에서 그 폴더를 빼 둔다. 머지한 뒤 세션을 보관하면 앱이 워크트리를 정리한다.
- **브라우저 확인:** UI 가 바뀌면 구현한 세션이 아니라 `frontend-evaluator` 에이전트가 실행 중인 화면에서 Acceptance Criteria 를 하나씩 판정한다.

## 구조

```
plugins/workflow/skills/task/       SKILL.md + references/create.md, start.md, end.md
plugins/workflow/agents/            design-reviewer.md
plugins/workflow/hooks/             hooks.json, verify-on-stop.sh (Stop 훅)
plugins/frontend/                   skills/frontend-{start,end}-check, agents/frontend-reviewer.md, frontend-evaluator.md
plugins/server/                     skills/server-{start,end}-check, agents/api-reviewer.md, supabase-reviewer.md
i18n/en/                            영어 번역본 (Claude 는 읽지 않음)
scripts/check-repo-rules.sh         저장소 규칙 검사 (번역본 짝과 갱신, 설명 일치, README 목록, version 올리기)
scripts/test-check-repo-rules.sh    검사 스크립트의 시나리오 테스트
scripts/test-verify-on-stop.sh      검증 훅의 시나리오 테스트
```

- 원문은 한국어(`plugins/`), 번역본은 `i18n/en/`. 원문을 고치면 번역본도 고친다.
- `/task start`는 이름이 `-start-check`로, `/task end`는 `-end-check`로 끝나는 스킬을 모두 부른다. 새 스택은 같은 이름 규칙으로 플러그인을 만들어 `marketplace.json`에 등록한다.

## 업데이트

```bash
claude plugin marketplace update j-dev-kit
claude plugin update <플러그인>@j-dev-kit --scope project
```

그다음 세션을 새로 연다. 관리자는 바뀐 플러그인의 `plugin.json` `version`을 올리고 CLAUDE.md 의 검증 명령(`claude plugin validate .`과 `scripts/check-repo-rules.sh`)을 돌린 뒤 푸시한다. 검사 스크립트는 `plugins/`의 마크다운에 `i18n/en/` 번역본이 없거나, `plugin.json`과 `marketplace.json`의 플러그인 설명이 다르거나, `marketplace.json`의 플러그인이 README 두 개의 표에 없거나, `main`(없으면 `origin/main`) 대비 원문만 고치고 번역본은 그대로이거나, 바뀐 플러그인의 `version`이 그대로이거나 내려갔으면 실패한다. 버전이 같으면 업데이트되지 않는다. 검사 스크립트를 고치면 `bash scripts/test-check-repo-rules.sh`로 시나리오를 돌린다.

## 문제 해결

| 증상 | 해결 |
| --- | --- |
| `supabase@j-dev-kit`을 찾을 수 없다 | `server`로 합쳤다. `enabledPlugins`에서 지우고 `server@j-dev-kit`을 설치한다. |
| `architecture@j-dev-kit`, `design@j-dev-kit`을 찾을 수 없다 | 지웠다. `enabledPlugins`에서 지운다. 화면 리뷰는 `workflow`의 `design-reviewer`로 옮겼다. |
| `Dependency "…" is not installed` | 지워진 의존 플러그인을 같은 `--scope`로 설치한다. |
| 멈출 때 검증 명령이 돈다 | 검증 훅이다. 항목의 Definition of Done 이 체크돼 있고 코드가 마지막 통과 뒤에 바뀌었을 때만 돈다. CLAUDE.md 에 `검증 명령:` 줄이 없으면 돌지 않는다. |
| 스택 점검이 하나도 안 돈다 | 플러그인이 꺼져 있거나 CLAUDE.md 의 `stack:`에 빠져 있다. |

## 출처

[Backlog.md](https://github.com/MrLesk/Backlog.md) 항목 형식, [superpowers](https://github.com/obra/superpowers)(brainstorming, TDD, 완료 전 검증, 리뷰 받기, 브랜치 마무리), [spec-kit](https://github.com/github/spec-kit)(질문 최대 3개), [compound-engineering](https://github.com/EveryInc/compound-engineering-plugin)(크기에 맞춘 계획), [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills), Claude Code 내장 `code-review`·`security-review`·`simplify`, OWASP API Security Top 10, [supabase/agent-skills](https://github.com/supabase/agent-skills), Anthropic [Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices).

검증 훅, `frontend-evaluator`, `design-reviewer`: Claude Code [hooks](https://code.claude.com/docs/en/hooks.md)(꼭 지킬 것은 지침이 아니라 훅으로), Anthropic [harness design](https://www.anthropic.com/engineering/harness-design-long-running-apps)(만든 쪽과 따로 둔 평가자가 실행 중인 앱을 직접 써 본다).

`design-reviewer`: WCAG 2.2, [Google DESIGN.md](https://github.com/google-labs-code/design.md), [OneRedOak/claude-code-workflows](https://github.com/OneRedOak/claude-code-workflows) `design-review`(폭별 실제 화면 리뷰).
