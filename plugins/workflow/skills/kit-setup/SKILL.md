---
name: kit-setup
description: workflow 플러그인을 처음 설정하거나 설정을 바꿀 때 쓴다. 하위 세션과 하위 에이전트가 역할마다 쓸 모델과 노력, 머지 방식(로컬 머지 후 푸시 / PR)을 물어 JSON 설정 파일에 쓰고, 메인 세션의 모델도 함께 정한다. 프로젝트 CLAUDE.md 의 작업 설정과 검증 스킬도 없으면 만들지 묻는다. 프로젝트의 스택을 보고 맞는 공식 스킬과 플러그인을 묻지 않고 설치한다. "모델 설정", "머지 방식 설정", "setup", "셋업", "어떤 모델로 돌릴지 바꾸자"에 쓴다.
argument-hint: "[--user]"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# kit-setup

인자: `$ARGUMENTS`

workflow 플러그인의 설정을 쓴다. 형식과 역할은 `${CLAUDE_SKILL_DIR}/../start/references/settings.md`에 있다. 먼저 그 파일을 Read 도구로 읽는다.

묻는 것은 아래 2단계의 한 번이다. 선택지마다 추천과 이유를 붙인다. 묻는 도구(AskUserQuestion)가 있으면 그것으로 묻는다.

## 1. 지금 상태 읽기

- 모델 설정과 머지 방식(`merge`): `<저장소 루트>/.claude/workflow.json`, `~/.claude/workflow.json`. 없으면 모델은 기본값이 쓰이는 중이고, 머지 방식은 `/start`가 그때마다 묻는 중이다.
- 지난 머지: `git log <기준> --merges --oneline -20`. `Merge pull request`가 많으면 PR 로, `Merge branch`가 많으면 로컬 머지로 해 온 것이다.
- 메인 세션: 이 세션의 모델, 그리고 `model`·`effortLevel` 키가 적힌 곳(`.claude/settings.local.json`, `.claude/settings.json`, `~/.claude/settings.json`). 이 키들만 본다.
- 프로젝트 CLAUDE.md 의 `## 작업 설정`: 기준 브랜치, 검증 명령, 문서 언어, `stack:`.
- 프로젝트 검증 스킬: `.claude/skills/verify-*/`가 있는지, CLAUDE.md 에 `- 검증 스킬: 안 씀`이 있는지.
- 스택과 설치된 것: 4단계 표의 조건(`package.json`의 의존성, `tsconfig.json`, `supabase/config.toml`)과 이미 설치된 플러그인·스킬(`claude plugin list --json`, `.claude/skills/`, `~/.claude/skills/`). 플러그인은 `@` 앞의 이름으로 견준다. 마켓플레이스가 달라도 같은 플러그인이다. 범위가 user 이거나 이 프로젝트의 것만 있다고 친다. 모노레포면 앱과 패키지마다 본다.

## 2. 보여 주고 한 번에 묻기

역할마다 지금 쓰이는 값, 그 값이 온 곳(프로젝트 파일, 사용자 파일, 기본값), 기본값을 표로 보여 준다. 그다음 한 번에 묻는다.

1. **저장할 곳:** 프로젝트(`.claude/workflow.json`, 커밋한다. 워크트리와 하위 세션에서도 보인다) / 사용자(`~/.claude/workflow.json`, 모든 프로젝트의 기본값). 인자에 `--user`가 있으면 묻지 않고 사용자다. 추천은 프로젝트다.
2. **역할별 모델과 노력:** 셋 중 하나를 고르게 한다.
   - 지금 그대로 두기(`models`를 바꾸지 않는다)
   - 아끼기: `session`, `implement`, `review`, `judge`, `mechanical`을 `sonnet`으로, `explore`를 `haiku`로 낮춘다
   - 역할을 골라 바꾸기: 바꿀 역할과 값을 말하게 한다
3. **머지 방식:** `/start`가 일을 끝냈을 때 어떻게 합칠지. 로컬에서 기준 브랜치에 머지하고 푸시(`local`) / 기준 브랜치 대상으로 PR(`pr`) / 정하지 않기(그때마다 묻는다). 추천은 지난 머지 기록에서 해 온 쪽이다. 어느 쪽을 골라도 머지해도 되는지는 `/start`가 마지막에 묻는다고 알린다.
4. **메인 세션:** 그대로 두기(추천) / 모델과 노력을 골라 설정에 쓰기. 쓰면 새 세션부터 적용된다고 알린다.
5. **CLAUDE.md 작업 설정**(없을 때만): 찾은 값(기준 브랜치는 `git symbolic-ref`나 `main`, 검증 명령은 `package.json` 스크립트나 Makefile 에서)을 보여 주고 넣을지 묻는다. 검증 명령을 찾지 못하면 무엇인지 묻는다.
6. **검증 스킬**(`verify-*`가 없고 "안 씀" 줄도 없을 때만): 앱을 실제로 몰아 확인할 프로젝트 스킬을 만들지 묻는다.

이미 정해져 있는 것은 묻지 않는다.

## 3. 확인하고 쓰기

- 값을 확인한다. `model`은 `fable`, `opus`, `sonnet`, `haiku`, `inherit`, `auto` 중 하나, `effort`는 `low`, `medium`, `high`, `xhigh` 중 하나, `merge`는 `local`, `pr` 중 하나다. 아니면 그 역할만 다시 묻는다. 메인 세션의 `model`은 `fable`, `opus`, `sonnet`, `haiku` 중 하나만 받는다(`inherit`과 `auto`는 역할에만 쓴다).
- 설정 파일은 통째로 다시 쓴다. 다시 돌려도 결과가 같아야 한다. 사용자가 정한 역할만 적는다. 적지 않은 역할은 다음 순서(사용자 파일, 기본값)를 따른다. 프로젝트 파일에 기본값까지 적으면 사용자 파일의 값이 그 프로젝트에서 가려진다.
- 메인 세션을 바꾸기로 했으면 `.claude/settings.local.json`의 `model`과 `effortLevel` 키만 고친다. 파일이 없으면 그 두 키만 가진 파일을 만든다. 다른 키는 건드리지 않는다. 권한, 훅, 플러그인 키는 고치지 않는다.
- CLAUDE.md 를 넣기로 했으면 `## 작업 설정` 절만 더한다.
- 프로젝트 파일을 썼으면 `chore: workflow 설정`으로 커밋한다. 푸시하지 않는다. 기준 브랜치가 아닌 곳이면 그 브랜치에 커밋된다고 알린다.

## 4. 스택에 맞는 스킬과 플러그인 설치

묻지 않고 설치한다(`start` 스킬의 묻는 기준: 설치는 묻지 않는다). 아래 표에서 프로젝트에 맞는 줄을 모두 고르고, 아직 없는 것만 설치한다. 공식 스킬과 플러그인을 까는 곳은 여기뿐이다. `/start`의 스택 점검은 깔지 않고, 빠진 것이 있으면 이 스킬을 돌리라고 알린다.

조건의 이름은 `package.json`의 `dependencies`·`devDependencies`의 키와 정확히 같아야 한다(`react`는 `react-dom`이나 `@types/react`에 맞지 않는다). 프런트엔드 프레임워크는 react, next, vue, nuxt, svelte, @sveltejs/kit, solid-js, @angular/core, astro 가운데 하나가 있는 것이다. `react-native`나 `expo`가 있고 `react-dom`이 없으면 웹 프로젝트가 아니니 스택이 frontend 인 줄을 모두 건너뛴다.

| 이름 | 스택 | 조건 | 명령 |
| --- | --- | --- | --- |
| `frontend-design` | frontend | 프런트엔드 프레임워크가 있다 | `claude plugin install frontend-design@anthropic-plugin-directory --scope project` |
| `chrome-devtools-mcp` | frontend | 프런트엔드 프레임워크가 있다 | `claude plugin marketplace add ChromeDevTools/chrome-devtools-mcp --scope project`, `claude plugin install chrome-devtools-mcp@chrome-devtools-plugins --scope project` |
| `modern-web-guidance` | frontend | 프런트엔드 프레임워크가 있다 | `claude plugin marketplace add GoogleChrome/modern-web-guidance --scope project`, `claude plugin install modern-web-guidance@googlechrome --scope project` |
| `typescript-lsp` | 공통 | 저장소 루트나 앱·패키지 루트에 `tsconfig.json`이 있거나 `typescript`가 있다 | `claude plugin install typescript-lsp@anthropic-plugin-directory --scope project` |
| `svelte` | frontend | `svelte`가 있다 | `claude plugin marketplace add sveltejs/ai-tools --scope project`, `claude plugin install svelte@svelte --scope project` |
| `react` | frontend | `react`가 있다 | `npx -y skills@1.7.5 add vercel-labs/agent-skills --skill vercel-react-best-practices --skill vercel-composition-patterns -a claude-code` |
| `react-router` | frontend | `react-router`가 있다 | `npx -y skills@1.7.5 add https://github.com/remix-run/react-router --skill react-router -a claude-code` |
| `supabase` | server | `supabase/config.toml`이 있거나 `@supabase/`로 시작하는 패키지가 있다 | `claude plugin install supabase@anthropic-plugin-directory --scope project` |

- CLAUDE.md `## 작업 설정`의 `- 공식 스킬 설치 안 함:` 줄에 위 표의 이름이 있으면 그 줄은 설치하지 않는다(예: `- 공식 스킬 설치 안 함: supabase, chrome-devtools-mcp`).
- CLAUDE.md 에 `stack:` 줄이 있으면 거기에 없는 스택의 줄은 건너뛴다. 공통은 건너뛰지 않는다. `stack: 없음`이면 모두 건너뛴다.
- 명령은 저장소 루트(`git rev-parse --show-toplevel`)에서 돌린다. 설치는 위 명령으로만 한다. 표에 없는 명령이나 출처로 대신 깔지 않는다. 설정 파일의 플러그인 키를 손으로 고치지 않는다.
- 명령이 실패하면 멈추지 않는다. 마켓플레이스만 더해지고 설치가 실패했으면 그 마켓플레이스를 지운다(`claude plugin marketplace remove <이름> --scope project`). 실패한 것과 이유를 6단계에서 알린다.
- `supabase` 플러그인에는 MCP 가 같이 온다. 로그인하면 계정의 모든 프로젝트에 읽기·쓰기 도구로 붙는다. 그렇다는 것과 끄는 법(`/mcp`)을 6단계에서 알린다.
- `typescript-lsp`는 `typescript-language-server`가 PATH 에 있어야 돈다. 없으면 전역 설치하지 않고 명령(`npm install -g typescript-language-server typescript`)을 6단계에서 알린다.
- `next`만을 위해 따로 깔 것은 없다. 16.3 이상은 `next dev`가 `AGENTS.md`를 만든다. 그보다 낮으면 `npx @next/codemod@canary agents-md`를 돌리면 된다고 알린다.
- 커밋: 설치 전에 `git status --short -- .claude/`가 비어 있는지 본다. 비어 있지 않으면 설치는 하되 커밋하지 않고, 커밋하지 않은 변경이 있었다고 알린다. 비어 있었으면 설치로 바뀐 경로(`git status --short`로 확인한다. 예: `.claude/settings.json`, `.claude/skills/`)만 `chore: 스택 스킬과 플러그인 설치`로 커밋한다. 푸시하지 않는다. 기준 브랜치가 아닌 곳이면 그 브랜치에 커밋된다고 알린다.

## 5. 검증 스킬

만들기로 했으면 `create-verification-skill` 스킬(`${CLAUDE_SKILL_DIR}/../create-verification-skill/SKILL.md`)을 읽고 따른다. 만들지 않기로 했으면 다시 묻지 않게 CLAUDE.md `## 작업 설정`에 `- 검증 스킬: 안 씀`을 적자고 제안한다.

## 6. 알리기

쓴 파일, 역할마다 정한 값, 머지 방식, 설치한 것과 설치하지 못한 것, 언제부터 적용되는지를 알린다. 역할별 설정은 다음에 세션이나 에이전트를 띄울 때부터, 메인 세션 설정과 설치한 플러그인은 새 세션부터다. 다시 바꾸려면 `/kit-setup`을 또 부르면 된다.
