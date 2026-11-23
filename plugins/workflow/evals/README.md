# workflow eval

고정 체크리스트가 지금 모델에 도움이 되는지 잰다. 모델이 바뀌면 다시 돌린다. 같은 사례를 체크리스트가 있는 사본과 뺀 사본으로 돌려 점수와 비용을 비교한다(008).

| 사례 | 재는 것 |
| --- | --- |
| `start-plan` | `start.md` 3단계의 "`Explore` 에이전트를 최대 2개", "한꺼번에 최대 3개"(질문). 여러 모듈에 걸친 항목에서 꼭 읽을 파일을 짚는지, 코드로 답할 수 있는 것을 묻지 않는지, 계획이 빠짐없는지 |

다시 돌리기:

1. 이 플러그인 폴더를 비교할 판마다 복사한다(예: `with`, `no-explore-limit`, `no-question-limit`). eval 실행은 의존 플러그인을 설치하지 않으니, 사본의 `.claude-plugin/plugin.json`에서 `dependencies`를 지운다. 뺀 사본의 `skills/task/references/start.md`에서 잴 문구를 지운다.
2. 사본마다 돌린다. `--model`은 작업 세션의 모델로 바꾼다. 셸 도구는 주지 않는다(Windows 에는 eval 샌드박스가 없다. 사례 프롬프트가 1~2단계를 건너뛰게 한다).

```bash
claude plugin eval <사본> --ablation none --scaffold --trust-plugin --model opus --runs 3 --no-publish --threshold 0 --json <사본>.json
```

3. 두 JSON 의 `cases[].aggregates.score`, 실행마다의 `costUsd`·`turns`를 비교한다. 결과 폴더 `evals/results/`는 커밋하지 않는다.
