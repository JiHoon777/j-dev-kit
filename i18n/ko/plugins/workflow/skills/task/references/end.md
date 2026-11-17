> 번역본입니다. 원문은 [plugins/workflow/skills/task/references/end.md](../../../../../../../plugins/workflow/skills/task/references/end.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# task end: 리뷰하고 머지하기

현재 작업 브랜치의 변경을 에이전트들에게 리뷰시키고, 사용자가 정한 것을 고치고, 사용자가 고른 방식으로 마무리한다.

이 모드는 검증된 흐름을 이어 붙인 것이다. 출처의 방식을 바꾸지 않는다.

| 단계 | 출처 |
| --- | --- |
| 1-2 | 켜 둔 스택 플러그인의 `*-end-check` 스킬 (그대로 호출) |
| 2 | 내장 스킬 `code-review`, `security-review`, `simplify` (에이전트마다 하나씩, 그대로 호출), 그리고 스택 리뷰 에이전트 |
| 2–3 | Anthropic `feature-dev` 플러그인 Phase 6과 그 `code-reviewer` 지시문 (병렬 실행, 확신도 점수, 취합, 제시, 묻기) |
| 4 | `superpowers:receiving-code-review` (그대로 호출) |
| 5 | Backlog.md 에이전트 지침 (definition of done) |
| 6 | `superpowers:finishing-a-development-branch` (그대로 호출) |

프로젝트 CLAUDE.md 에 이 환경에서 PR 을 만들 수 없다고 적혀 있거나 푸시 규칙이 있으면 따른다. 스킬의 "현재 상태"는 `main`과 비교한다. 기준 브랜치가 다르면 그 브랜치로 브랜치의 커밋과 바뀐 파일을 다시 확인한다(`git log --oneline <기준>..HEAD`, `git diff --stat <기준>...HEAD`).

## 1. 리뷰를 시작할 수 있는지 확인

아래 중 하나라도 해당하면 **멈추고 사용자에게 알린다.**

| 확인 | 해당하면 |
| --- | --- |
| 브랜치가 `w/`로 시작하지 않는다 | 리뷰할 작업 브랜치가 아니다. 어느 브랜치인지 묻는다 |
| `docs/backlog/`나 `docs/done/`에 브랜치 이름과 맞는 항목 파일이 없다 | 어느 항목인지 묻는다 |
| 커밋하지 않은 변경이 있다(추적하지 않는 파일 포함) | 커밋할지 버릴지 묻는다. 절대 스스로 버리지 않는다 |
| `<기준>...HEAD`에 변경이 없다 | 리뷰할 것이 없다고 말한다 |
| 검증 명령이 실패한다 | 실패를 보여 주고, 고치고 커밋한 뒤 계속할지 묻는다 |

항목 파일을 읽는다. (항목이 이미 `docs/done/`에 있으면 5단계까지는 끝난 것이다. 6단계부터 다시 한다.)

### 1-2. 스택 종료 점검

1. 쓸 수 있는 스킬 목록에서 **이름이 `-end-check`로 끝나는 스킬을 전부** 찾아 각각 Skill 도구로 호출한다(예: `supabase:supabase-end-check`). 하나도 없으면 "켠 스택 플러그인 없음"이라고 적는다.
2. 각 점검은 항목 `Implementation Notes`의 `### Baseline`과 비교해 **새로 생긴 실패**만 실패로 돌려준다. 그 실패들을 출처를 "스택 점검"으로 해서 3단계의 지적 목록에 넣는다.
3. 각 점검의 **리뷰에 넣을 에이전트**(조건과 근거 포함)를 2단계에 더한다.
4. 각 점검의 **고친 뒤 할 것**(예: 브라우저 테스트)은 4단계에서 한다.
5. 각 점검의 **나중에** 항목(예: 테스트로 남길 권한 규칙)은 `Final Summary`에 넣거나, 승인을 받아 `/task create`로 새 항목을 만든다.

## 2. 리뷰 에이전트 병렬 실행 (feature-dev Phase 6)

"Launch 3 code-reviewer agents in parallel with different focuses" — **한 메시지에서** 모두 띄운다. **에이전트마다 실제로 리뷰 스킬 하나를 호출한다.** 같은 지시문에 이름만 다르게 붙여 보내지 않는다.

| 에이전트 | 언제 | 호출하는 것 (Skill 도구) |
| --- | --- | --- |
| 정확성 (general-purpose) | 항상 | `code-review` — 수정 옵션(`--fix`) 없이 |
| 보안 (general-purpose) | 항상 | `security-review` |
| 단순화 (general-purpose) | 항상 | `simplify` — 찾기만 하고 고치는 단계는 건너뛴다 |
| 스택 리뷰 에이전트 (`frontend:ui-reviewer`, `frontend:svelte-reviewer`, `frontend:react-reviewer`, `supabase:rls-reviewer`, `server:api-reviewer`, …) | 1-2의 스택 점검이 돌려줬을 때 | (에이전트가 정한 대로) |

띄우기 전에 한 번 확인한다: `git symbolic-ref refs/remotes/origin/HEAD`가 실패하면 `git remote set-head origin -a`를 돌린다. `security-review`는 `origin/HEAD`와 비교해 변경을 찾는다.

점검 스킬은 명령만 돌린다. diff 를 읽고 판단하는 리뷰는 이 대화에서 직접 하지 않는다. 모두 이 단계의 에이전트가 한다.

모든 에이전트(위의 셋과 스택 리뷰 에이전트)의 지시문에 아래를 **전부** 넣는다. 에이전트는 이 대화를 볼 수 없다. 스택 리뷰 에이전트에게는 1번(호출할 스킬) 대신, 점검 스킬이 그 에이전트와 함께 돌려준 근거(바뀐 파일, 찾은 위치, 도구 결과)를 준다.

1. **호출할 스킬:** "Skill 도구로 `<스킬 이름>` 스킬을 호출하고 그 방식대로 리뷰하라." 다른 리뷰는 다른 에이전트가 한다고 말해 준다.
   - `code-review`: 대상은 현재 브랜치(`w/<이름>`). `--fix`나 `--comment`를 넘기지 않는다. 노력 수준은 주지 않거나 `medium`. `max`나 `ultra`는 절대 쓰지 않는다.
   - `simplify`: 이 스킬은 보통 찾은 것을 바로 고친다. **고치지 말고 지적만 보고하라.**
2. **읽기만:** 파일을 고치거나 만들지 않고, 커밋하지 않고, 서버를 띄우지 않고, 빌드나 검증 명령을 돌리지 않는다(여러 에이전트가 같은 폴더에 동시에 쓰게 된다). 테스트와 읽기 전용 명령은 괜찮다.
3. **범위:** `git diff <기준>...HEAD`와 바뀐 파일 목록을 적어 준다. 스킬이 범위를 찾지 못하면 이것을 쓴다.
4. **기준:** 항목 파일 경로, `CLAUDE.md`, 관련 문서 경로.
5. **보고:** 아래 **리뷰어 지시문**의 형식으로 지적을 보고한다. 지적마다 확신도(0–100)를 매기고 **낮은 것까지 전부** 보고한다. 각 지적에는 `file:line`, 무엇이 문제인지, 어떻게 고칠지가 있어야 한다. 보고는 프로젝트의 언어로 쓴다.
6. **스킬을 호출할 수 없으면** 지어낸 것으로 대신하지 말고 "스킬을 호출할 수 없음"이라고 보고한다. 그리고 사용자에게 알린다.

### 리뷰어 지시문 (feature-dev `code-reviewer` 원문)

아래 지시문을 모든 에이전트에게 그대로 붙인다. **무엇을 어떻게 볼지**는 스킬이 정하고, **무엇을 보고할지**(확신도 기준과 형식)는 이 지시문이 정한다.

**원문에서 바꾼 것:** 원문은 확신도 80 미만을 모두 버린다("Only report issues with confidence ≥ 80"). 그러면 75("very likely a real issue that will be hit in practice")도 가려진다. 여기서는 **아무것도 자르지 않고, 모든 문제를 점수와 함께 보고한다.** 3단계에서 사용자가 고르기 때문이다. 그 문장과, 출력 설명에서 그 문장에 딸린 두 군데만 바꿨다.

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

## 3. 취합하고, 보여 주고, 묻기 (feature-dev Phase 6)

모든 에이전트가 보고한 뒤에 한다.

1. "Consolidate findings and identify highest severity issues that you recommend fixing" — 중복을 합치고 고치기를 추천할 것을 정한다. 1-2의 스택 점검 실패도 넣는다.
2. "**Present findings to user and ask what they want to do** (fix now, fix later, or proceed as-is)" — 지적마다 어느 리뷰에서 나왔는지, `file:line`, 무엇이 문제인지, 확신도, 추천 처리를 표로 보여 주고 묻는다. **확신도 높은 순**으로 나열하고 낮은 것도 빼지 않는다. 확신도가 낮은 지적은 고치기 전에 직접 코드에서 확인한다.
   - **지금 고치기**
   - **나중에 고치기** → 승인을 받아 `/task create`를 따라 새 항목(`To Do`)을 만든다
   - **그대로 진행**
3. 에이전트가 권한 설정, `CLAUDE.md`, `.claude/` 설정을 바꾸자고 하면 바꾸지 않는다. 사용자에게 제안으로 전한다.

**답을 받기 전에는 아무것도 고치지 않는다.**

## 4. 정한 것 고치기

- `superpowers:receiving-code-review` 스킬을 호출해 그대로 따른다. (지적을 덮어놓고 믿지 않고 코드에서 확인한다. 틀린 지적은 적용하지 않고 이유를 댄다. 하나씩 고치고 하나씩 검증한다.)
- 동작을 바꾸는 수정은 `superpowers:test-driven-development`를 따라 실패하는 테스트를 먼저 쓴다.
- 수정을 모두 마치면 검증 명령을 돌린다.
- **그다음, 수정이 무관해 보여도 1-2에서 스택 점검이 돌려준 "고친 뒤 할 것"(예: 브라우저 테스트)을 반드시 한다.** 고친 지적마다 그것이 말한 상황을 재현하고 문제가 사라졌는지 확인한다. 도구를 쓸 수 없으면 건너뛰지 말고 멈춰서 사용자에게 알린다.
- 고친 게 없어도(전부 "그대로 진행"이어도) 머지 전에 "고친 뒤 할 것"을 한 번 한다.
- 수정이 스택 점검이 다루는 것을 건드리면 그 `*-end-check`를 다시 호출한다.
- 테스트한 것과 본 것을 항목의 `Implementation Notes`에 적는다.
- 작업 브랜치에 커밋한다.

## 5. 항목 닫기 (Backlog.md definition of done)

"A task is **Done** only when **ALL** of the following are complete" — 하나라도 빠지면 멈추고 사용자에게 알린다. "NEVER mark a task as Done without completing ALL items above."

- [ ] Acceptance Criteria 가 모두 체크됐다
- [ ] Definition of Done 줄이 모두 체크됐다
- [ ] `Final Summary`를 썼다: 바뀐 것, 리뷰에서 고친 것, 미룬 것(새 항목 번호)

모두 끝나면 작업 브랜치에서:

```bash
# 항목 파일에서 status: Done, updated_date 를 오늘로 바꾼 다음
git mv docs/backlog/<파일> docs/done/<파일>
git add -A docs/
<검증 명령>                         # 실패하면 여기서 고친다
git commit -m "docs(backlog): <번호> done"
git status --short                             # 비어 있어야 한다
```

`git mv`만 하고 커밋하면 방금 고친 내용이 빠진다. 반드시 `git add -A docs/`를 돌린다.

## 6. 마무리

`superpowers:finishing-a-development-branch` 스킬을 호출해 그대로 따른다. 이 스킬은 테스트를 돌리고, 선택지를 보여 주고, 행동하기 전에 **사용자의 답을 기다린다.** 그것이 머지 전 승인이다.

스킬에 이 저장소에 대해 알려 준다:

- 테스트 명령은 이 프로젝트의 검증 명령이고, 기준 브랜치는 프로젝트 설정에 있는 것이다.
- 워크트리를 쓰지 않았으면 지울 워크트리가 없다.
- 이 환경에서 PR 을 만들 수 없으면(CLAUDE.md 에 적혀 있거나 `gh auth status`가 실패하면) 선택지는 그대로 보여 주되 그렇다고 말한다.
- 기준 브랜치에 upstream 이 없으면(`git rev-parse --abbrev-ref <기준>@{upstream}`가 실패하면) `git pull`을 건너뛴다.
- 머지한 뒤 푸시는 사용자가 따로 요청할 때만 한다.

끝나면 보고한다: 머지된 커밋, 옮긴 항목 파일, 새 항목, `docs/backlog/`에 남은 `To Do` 항목.
