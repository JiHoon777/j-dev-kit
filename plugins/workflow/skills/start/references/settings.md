# 설정

workflow 플러그인의 설정 파일이다. 두 가지를 정한다: 하위 세션이나 하위 에이전트를 띄울 때 역할마다 쓸 모델과 노력(effort), 그리고 일을 끝냈을 때의 머지 방식. 값은 JSON 설정 파일에 있고, `kit-setup` 스킬이 써 준다. `start`와 `backlog`가 이 파일을 따른다. 다른 스킬을 직접 부르면(`/how` 등) 이 설정은 쓰이지 않는다.

## 설정 파일

- 프로젝트: `<저장소 루트>/.claude/workflow.json`. 커밋하면 워크트리와 하위 세션에서도 보인다.
- 사용자: `~/.claude/workflow.json`. 모든 프로젝트의 기본값이다.

세션이나 에이전트를 띄우기 전에 두 파일을 Read 도구로 읽는다(없는 파일은 건너뛴다). 역할마다 프로젝트 값이 있으면 그것을, 없으면 사용자 값을, 그것도 없으면 아래 기본값을 쓴다. 두 파일이 모두 없거나 읽을 수 없으면 묻지 않고 기본값으로 간다. 한 번 읽은 값은 그 세션 동안 다시 읽지 않아도 된다.

기본값을 그대로 적으면 이렇다. 역할은 바꿀 것만 적어도 된다.

```json
{
  "models": {
    "session": { "model": "auto", "effort": "high" },
    "implement": { "model": "inherit" },
    "review": { "model": "auto" },
    "judge": { "model": "inherit" },
    "mechanical": { "model": "sonnet", "effort": "high" },
    "explore": { "model": "inherit" }
  }
}
```

## 역할

| 역할 | 누구 | 기본값 |
| --- | --- | --- |
| `session` | `start`와 `backlog`가 띄우는 하위 세션 | `auto`, 노력 `high` |
| `implement` | 구현을 맡는 하위 에이전트(플레이북이 "맡긴다"고 하는 곳) | `inherit` |
| `review` | 리뷰 에이전트: `code-review`, `security-review`, 스택 리뷰어 | `auto` |
| `judge` | 판정 에이전트: AC 판정, 리뷰 지적 판정, 서베이 판정, `frontend-evaluator` | `inherit` |
| `mechanical` | 판단이 남지 않는 기계적 수정을 맡는 에이전트 | `sonnet`, 노력 `high` |
| `explore` | 읽기만 하는 탐색과 조사: `start`와 `backlog`가 띄우는 `Explore`, 서베이 수집 | `inherit` |

## 값

- `model`: `fable`, `opus`, `sonnet`, `haiku`, `inherit`, `auto` 중 하나다.
  - `inherit`: 모델을 주지 않는다. 이 세션의 모델을 이어받는다.
  - `auto`: 이 세션이 Fable 이면 한 단계 낮은 최신 모델(지금은 `opus`)로, 아니면 `inherit`으로 한다. `inherit`으로 풀리면 그 역할의 `effort`도 주지 않는다(모델과 노력을 모두 이어받는다).
- `effort`: `low`, `medium`, `high`, `xhigh` 중 하나다. 적지 않으면 이어받는다.

## 넘기는 법

- **하위 에이전트:** Agent 도구의 `model`과 `effort`로 넘긴다. `model`은 별칭(`fable`, `opus`, `sonnet`, `haiku`)만 받는다. `inherit`이면 `model`을 주지 않는다. 이 값은 에이전트 정의 파일에 적힌 모델보다 우선한다.
- **하위 세션:** 세션을 띄우는 도구의 `model`과 `effort`로 넘긴다. `model`에는 그 별칭의 최신 모델 ID 를 준다(예: `opus`는 지금 `claude-opus-5-5`). 도구는 이 세션보다 높은 모델과 노력을 받지 않는다. 설정이 더 높으면 주지 않고(이어받는다) 그렇다고 한 줄 알린다.
- 도구가 값을 거부하면 그 값을 빼고 띄운 뒤 그렇다고 알린다.

## 머지 방식

같은 파일의 `merge` 키다. `models`와 나란히 적는다.

```json
{
  "merge": "local"
}
```

- `local`: 작업 브랜치를 로컬에서 기준 브랜치에 머지하고 기준 브랜치를 푸시한다.
- `pr`: 작업 브랜치를 푸시하고 기준 브랜치를 대상으로 PR 을 만든다.
- 프로젝트 값이 있으면 그것을, 없으면 사용자 값을 쓴다. 둘 다 없으면 `start`가 마지막 메시지에서 방식을 묻는다.
- 이 값은 방식만 정한다. 머지해도 되는지는 `start`가 마지막 메시지에서 그대로 묻는다. 머지와 기준 브랜치 푸시는 묻는 기준에 든다.

## 메인 세션

이 파일은 메인 세션의 모델을 바꾸지 못한다. 메인 세션의 모델과 노력은 Claude Code 설정(`settings.json`의 `model`, `effortLevel`)이 정하고, 새 세션부터 적용된다. `kit-setup`이 고른 값을 그 키에 써 준다. 세션 도중에는 `/model`로 바꾼다.
