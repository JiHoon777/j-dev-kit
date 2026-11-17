---
name: task-end
description: 작업 브랜치를 끝낸다. 켜진 스택 플러그인의 종료 점검을 돌리고, 리뷰 에이전트들을 동시에 돌려 결과를 모아 사용자에게 보여 주고, 고치고, 승인받아 기준 브랜치에 머지하고 백로그 항목을 done으로 옮긴다. 사용자가 /task-end 로 부를 때만 쓴다.
disable-model-invocation: true
allowed-tools: Bash(git status *), Bash(git branch --show-current), Bash(git log *), Bash(git diff *)
version: "0.2.0"
metadata:
  author: JiHoon777 <65200592+JiHoon777@users.noreply.github.com>
---

# task-end: 리뷰하고 머지하기

지금 작업 브랜치의 변경을 에이전트들에게 리뷰받고, 사용자가 정한 대로 고치고, 사용자가 고른 방식으로 마무리한다.

이 명령은 검증된 흐름을 이어 붙인 것이다. 출처의 방식을 바꾸지 않는다.

| 단계 | 출처 |
| --- | --- |
| 1-2 | 켜진 스택 플러그인의 `*-end-check` 스킬 (그대로 호출) |
| 2 | 내장 스킬 `code-review`, `security-review`, `simplify` (에이전트마다 하나씩 그대로 호출), 스택 플러그인의 리뷰 에이전트 |
| 2~3 | Anthropic `feature-dev` 플러그인의 Phase 6과 `code-reviewer` 지시문 (동시에 돌리고, 확신도를 붙이고, 모아서 보여 주고, 묻는다) |
| 4 | `superpowers:receiving-code-review` (그대로 호출) |
| 5 | Backlog.md 에이전트 지침 (완료 기준) |
| 6 | `superpowers:finishing-a-development-branch` (그대로 호출) |

## 프로젝트 설정

`task-start`와 같다: 프로젝트 CLAUDE.md 의 기준 브랜치(기본 `main`), 검증 명령, 린트 명령, 지켜야 할 문서. PR 을 만들 수 없는 환경이거나 푸시 규칙이 있으면 CLAUDE.md 에 적힌 대로 따른다.

## 지금 상태

- 브랜치: !`git branch --show-current 2>/dev/null || echo "(알 수 없음)"`
- 커밋하지 않은 변경: !`git status --short 2>/dev/null | head -20`
- 이 브랜치의 커밋: !`git log --oneline main..HEAD 2>/dev/null | head -30`
- 기준 브랜치와 달라진 파일: !`git diff --stat main...HEAD 2>/dev/null | tail -30`

(기준 브랜치가 `main`이 아니면 위 두 줄은 그 브랜치로 다시 본다.)

## 1. 리뷰해도 되는지 확인

아래 중 하나라도 걸리면 **멈추고 사용자에게 알린다.**

| 확인 | 걸리면 |
| --- | --- |
| 브랜치가 `w/`로 시작하지 않는다 | 리뷰할 작업 브랜치가 아니다. 어느 브랜치인지 묻는다 |
| 브랜치 이름에 맞는 항목 파일이 `docs/backlog/`에도 `docs/done/`에도 없다 | 어느 항목인지 묻는다 |
| 커밋하지 않은 변경이 있다 (추적 안 된 파일 포함) | 커밋할지 버릴지 묻는다. 스스로 버리지 않는다 |
| `<기준>...HEAD`에 변경이 없다 | 리뷰할 것이 없다고 알린다 |
| 검증 명령이 실패한다 | 실패 내용을 보여 주고, 고쳐서 커밋한 뒤 이어 갈지 묻는다 |

항목 파일을 읽는다. (항목이 이미 `docs/done/`에 있으면 5번까지 끝난 것이다. 6번부터 이어 간다.)

### 1-2. 스택 종료 점검

1. 쓸 수 있는 스킬 목록에서 **이름이 `-end-check`로 끝나는 스킬을 전부** 찾아 하나씩 Skill 도구로 부른다(예: `supabase:supabase-end-check`). 하나도 없으면 "켜진 스택 플러그인 없음"으로 적는다.
2. 각 스킬은 항목 `Implementation Notes`의 `### 기준선`과 비교해 **새로 생긴 실패**만 실패로 돌려준다. 실패는 3번의 지적 목록에 "스택 점검"을 출처로 넣는다.
3. 각 스킬이 돌려준 **리뷰에 넣을 에이전트**(조건과 근거 포함)를 2번에 더한다.
4. 각 스킬이 돌려준 **고친 뒤 할 것**(예: 브라우저 테스트)을 4번에서 한다.

## 2. 리뷰 에이전트를 동시에 돌린다 (feature-dev Phase 6)

"Launch 3 code-reviewer agents in parallel with different focuses" — **한 메시지에서** 모두 띄운다. **에이전트마다 리뷰 스킬 하나를 실제로 부른다.** 이름만 나누고 같은 지시문을 주지 않는다.

| 에이전트 | 언제 | 부르는 스킬 (Skill 도구) |
| --- | --- | --- |
| 정확성 (general-purpose) | 항상 | `code-review` — 고치기 옵션(`--fix`) 없이 |
| 보안 (general-purpose) | 항상 | `security-review` |
| 단순화 (general-purpose) | 항상 | `simplify` — 찾기만 하고 고치는 단계는 건너뜀 |
| 스택 리뷰 에이전트 | 1-2에서 스택 점검이 넣으라고 돌려준 것 | (자기 정의대로) |

띄우기 전에 한 번 확인한다: `git symbolic-ref refs/remotes/origin/HEAD`가 실패하면 `git remote set-head origin -a`를 돌린다. `security-review`가 `origin/HEAD`와 비교해서 바뀐 것을 찾는다.

앞의 세 에이전트에게 주는 지시에는 아래를 **모두** 넣는다. 에이전트는 이 대화를 보지 못한다.

1. **부를 스킬:** "Skill 도구로 `<스킬 이름>` 스킬을 부르고 그 방식대로 리뷰한다." 다른 리뷰는 다른 에이전트가 한다는 것.
   - `code-review`: 대상은 지금 브랜치(`w/<이름>`)다. `--fix`, `--comment`를 주지 않는다. 노력 수준은 주지 않거나 `medium`으로 한다. `max`와 `ultra`는 쓰지 않는다.
   - `simplify`: 이 스킬은 원래 찾은 것을 바로 고친다. **고치지 말고 찾은 것만 보고한다.**
2. **읽기만 한다:** 파일을 고치거나 만들지 않고, 커밋하지 않고, 서버를 띄우지 않고, 빌드와 검증 명령을 돌리지 않는다(여러 에이전트가 같은 폴더에 동시에 쓰게 된다). 테스트와 읽기 전용 명령은 된다.
3. **범위:** `git diff <기준>...HEAD`와 바뀐 파일 목록을 직접 적어 준다. 스킬이 범위를 못 찾으면 이 범위를 쓴다.
4. **기준:** 항목 파일의 경로, `CLAUDE.md`, 관련 문서의 경로.
5. **보고:** 스킬로 찾은 것을 아래 **리뷰어 지시문**의 형식으로 보고한다. 지적마다 확신도(0~100)를 매기고, **낮은 것도 버리지 않고 전부** 적는다. `파일:줄`, 무엇이 문제인지, 고치는 법이 있어야 한다. 한국어로.
6. **스킬을 부를 수 없으면** 지어서 대신하지 말고 "스킬을 부르지 못함"이라고 보고한다. 그러면 사용자에게 알린다.

### 리뷰어 지시문 (feature-dev `code-reviewer` 원문)

세 에이전트 모두에게 아래 지시문을 그대로 붙여 준다. 스킬은 **무엇을 어떻게 볼지**를 정하고, 이 지시문은 **무엇을 보고할지**(확신도 기준과 형식)를 정한다.

**원문에서 바꾼 곳:** 원문은 "Only report issues with confidence ≥ 80"으로 확신도 80 미만을 버린다. 그러면 75점("실제로 겪을 가능성이 매우 높은 문제")도 보이지 않게 된다. **자르지 않고 점수를 붙여 전부 보고**하게 한다. 3번에서 사용자가 직접 고르기 때문이다. 그 문장과, 거기에 맞춘 출력 설명 두 군데만 바꿨다.

> You are an expert code reviewer. Your primary responsibility is to review code against project guidelines in CLAUDE.md with high precision to minimize false positives.
>
> **Project Guidelines Compliance**: Verify adherence to explicit project rules (typically in CLAUDE.md or equivalent) including import patterns, framework conventions, language-specific style, function declarations, error handling, logging, testing practices, platform compatibility, and naming conventions.
>
> **Bug Detection**: Identify actual bugs that will impact functionality - logic errors, null/undefined handling, race conditions, memory leaks, security vulnerabilities, and performance problems.
>
> **Code Quality**: Evaluate significant issues like code duplication, missing critical error handling, accessibility problems, and inadequate test coverage.
>
> **Confidence Scoring** — rate each potential issue on a scale from 0-100:
>
> - **0**: Not confident at all. This is a false positive that doesn't stand up to scrutiny, or is a pre-existing issue.
> - **25**: Somewhat confident. This might be a real issue, but may also be a false positive. If stylistic, it wasn't explicitly called out in project guidelines.
> - **50**: Moderately confident. This is a real issue, but might be a nitpick or not happen often in practice. Not very important relative to the rest of the changes.
> - **75**: Highly confident. Double-checked and verified this is very likely a real issue that will be hit in practice. The existing approach is insufficient. Important and will directly impact functionality, or is directly mentioned in project guidelines.
> - **100**: Absolutely certain. Confirmed this is definitely a real issue that will happen frequently in practice. The evidence directly confirms this.
>
> **Report every issue you found, each with its confidence score. Do not drop low-confidence issues** — the person reading decides what to do with them. Do not pad the list either: an issue you scored 0 is not an issue.
>
> **Output**: Start by clearly stating what you're reviewing. For each issue, provide: clear description with confidence score; file path and line number; specific project guideline reference or bug explanation; concrete fix suggestion. Group issues by severity (Critical vs Important) and list them from highest confidence to lowest. If you found no issues, confirm the code meets standards with a brief summary.

## 3. 모아서 보여 주고 묻는다 (feature-dev Phase 6)

모든 에이전트의 보고가 온 뒤에 한다.

1. "Consolidate findings and identify highest severity issues that you recommend fixing" — 같은 문제를 하나로 합치고, 고치기를 권하는 것을 정한다. 1-2의 스택 점검 실패도 여기 넣는다.
2. "**Present findings to user and ask what they want to do** (fix now, fix later, or proceed as-is)" — 지적마다 어느 리뷰에서 나왔는지, `파일:줄`, 무엇이 문제인지, 확신도, 권하는 처리를 표로 보여 주고 묻는다. **확신도가 높은 것부터** 적고, 낮은 것도 빼지 않는다. 확신도가 낮은 지적은 고치기 전에 코드에서 직접 확인한다.
   - **지금 고친다**
   - **나중에 고친다** → 승인받으면 `/backlog-create`의 규칙대로 새 항목(`To Do`)을 만든다
   - **그대로 간다**
3. 에이전트가 권한 설정, `CLAUDE.md`, `.claude/` 설정을 바꾸라고 제안하면 직접 바꾸지 않고 사용자에게 제안으로 전한다.

**답을 받기 전에는 고치지 않는다.**

## 4. 정한 대로 고친다

- `superpowers:receiving-code-review` 스킬을 부르고 그대로 따른다. (지적을 그대로 믿지 않고 코드에서 확인한다. 틀린 지적은 근거를 들어 반영하지 않는다. 한 번에 하나씩 고치고 각각 확인한다.)
- 동작이 바뀌는 수정은 `superpowers:test-driven-development`대로 실패하는 테스트를 먼저 쓴다.
- 다 고치면 검증 명령을 돌린다.
- **그다음 1-2에서 스택 점검이 돌려준 "고친 뒤 할 것"을 반드시 한다**(예: 브라우저 테스트). 고친 것이 상관없어 보여도 한다. 고친 지적마다 그 문제가 사라졌는지 직접 재현해 본다. 도구를 쓸 수 없으면 건너뛰지 말고 멈춰서 사용자에게 알린다.
- 고친 것이 없어도(전부 "그대로 간다"여도) 머지 전에 "고친 뒤 할 것"을 한 번 한다.
- 고친 것이 스택 점검에 걸리는 부분이면 그 `*-end-check`를 다시 부른다.
- 테스트한 것과 본 것을 항목의 `Implementation Notes`에 적는다.
- 작업 브랜치에 커밋한다.

## 5. 항목을 끝낸다 (Backlog.md 완료 기준)

"A task is **Done** only when **ALL** of the following are complete" — 하나라도 안 되면 멈추고 알린다. "NEVER mark a task as Done without completing ALL items above."

- [ ] Acceptance Criteria가 전부 체크됐다
- [ ] Definition of Done이 전부 체크됐다
- [ ] `Final Summary`를 적었다: 무엇이 바뀌었는지, 리뷰에서 고친 것, 나중으로 미룬 것(새 항목 번호)

다 됐으면 작업 브랜치에서:

```bash
# 항목 파일: status: Done, updated_date를 오늘로 고친 뒤
git mv docs/backlog/<파일> docs/done/<파일>
git add -A docs/
<검증 명령>                                    # 실패하면 여기서 고친다
git commit -m "docs(backlog): <번호> 완료"
git status --short                             # 비어 있어야 한다
```

`git mv`만 하고 커밋하면 방금 고친 내용이 빠진다. 반드시 `git add -A docs/`를 한다.

## 6. 마무리한다

`superpowers:finishing-a-development-branch` 스킬을 부르고 그대로 따른다. 그 스킬이 테스트를 돌리고, 선택지를 보여 주고, **사용자의 답을 기다린 뒤** 실행한다. 이것이 머지 전 승인이다.

스킬에 알려 줄 이 저장소의 사정:

- 테스트 명령은 이 프로젝트의 검증 명령, 기준 브랜치는 프로젝트 설정의 것이다.
- 워크트리를 쓰지 않았으면 지울 워크트리가 없다.
- PR 을 만들 수 없는 환경(CLAUDE.md 에 적혀 있거나 `gh auth status` 가 실패)이면 선택지는 그대로 보여 주되 그 사실을 같이 알린다.
- 기준 브랜치에 upstream이 없으면(`git rev-parse --abbrev-ref <기준>@{upstream}`이 실패하면) `git pull`은 건너뛴다.
- 머지한 뒤 푸시는 사용자가 따로 요청할 때만 한다.

끝나면 보고한다: 머지된 커밋, 옮긴 항목 파일, 새로 만든 항목, `docs/backlog/`에 남은 `To Do` 항목.
