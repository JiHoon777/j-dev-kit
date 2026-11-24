# frontend eval

고정 체크리스트가 지금 모델에 도움이 되는지 잰다. 모델이 바뀌면 다시 돌린다.

측정 방법(비교할 판 두기, 반복, 채점 기준 쓰기, 판별력·들쭉날쭉함 보기, 평균 ± 표준편차)은 Anthropic 공식 `skill-creator` 스킬을 따른다. 여기에는 이 플러그인의 사례와 `claude plugin eval`로 돌리는 방법만 적는다. `skill-creator`의 실행 방식(서브에이전트에 스킬 경로를 준다)은 플러그인 로드, 네임스페이스 에이전트, Skill 도구, 의존성, `allowed_tools`를 시험하지 않으므로, 실제 사례는 아래처럼 `claude plugin eval`로 돌린다(012).

| 사례 | 재는 것 |
| --- | --- |
| `real-line`, `real-sky`, `real-birthday` | 실제 리뷰 실패(nolmeong 002·013·012 의 리뷰 전 커밋). 정답은 리뷰에서 고친 동작 버그이고 고친 커밋이 근거다(각 `case.yaml`). 버그마다 sonnet 판정, `real-line`에는 그대로 두기로 한 것을 🔴 로 올리지 않는지도 본다. 정답에 Svelte 고유 버그가 없어 Svelte 절은 재지 못한다(012 A7). `--tag real` |
| `compose-real-*-cr`, `compose-real-*-stack` | 리뷰어 구성을 실제 사례로. `code-review` 하나만 쓴 것과 `frontend-reviewer`를 더한 것. 정답과 채점은 `real-*`와 같다. 리뷰어 수와 내용이 함께 바뀌고 과정 채점이 한쪽에만 있어 구성 결정의 근거로는 약하다(012 A7). `--tag compose-real` |
| `reviewer-svelte` | 스모크용. 심은 Svelte 문제 5개. 008 에서 두 판 모두 만점이라 결정 근거로 쓰지 않는다 |

`real-*`와 `compose-real-*`는 nolmeong 로컬 저장소가 있는 기계에서만 돈다. scaffold 가 그 저장소에서 `git archive`로 커밋을 꺼내 만든다(그 저장소에는 쓰지 않는다). 저장소 경로는 `evals/nolmeong-src.local`에 한 줄로 쓴다(예: `echo ~/projects/nolmeong > evals/nolmeong-src.local`. 셸이 `~`를 절대 경로로 펼친다). 이 파일은 커밋하지 않고, 플러그인 폴더를 복사하면 사본에도 따라간다. eval 은 scaffold 에 환경 변수를 넘기지 않으므로 환경 변수로는 줄 수 없다. j-dev-kit 에는 nolmeong 코드를 넣지 않는다.

다시 돌리기:

1. 이 플러그인 폴더를 비교할 판마다 복사하고, 잴 문구를 판에 맞게 넣거나 지운다. eval 실행은 의존 플러그인을 설치하지 않으니 사본의 `.claude-plugin/plugin.json`에서 `dependencies`를 지운다. 판에 다른 플러그인의 스킬이 필요하면 그 스킬 폴더를 사본의 `skills/`에 넣는다(커밋하지 않는 사본에만).
2. 사본마다 돌린다. `--model`은 작업 세션의 모델로 바꾼다. LLM 채점은 시험받는 모델과 다른 `sonnet`으로 한다. 셸 도구는 주지 않는다(Windows 에는 eval 샌드박스가 없어 셸을 주면 실행이 거부된다. fixture 가 diff 를 `review.diff`로 남긴다).

```bash
claude plugin eval <사본> --ablation none --scaffold --trust-plugin --model opus --judge-model sonnet --runs 5 --tag real --no-publish --threshold 0 -j 2 --json <사본>.json
```

3. JSON 의 `cases[].arms.with[]`(실행마다 `score`, `graders[].passed`, `costUsd`)로 판을 견준다. 결과 폴더 `evals/results/`는 커밋하지 않는다.
