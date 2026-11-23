# frontend eval

고정 체크리스트가 지금 모델에 도움이 되는지 잰다. 모델이 바뀌면 다시 돌린다. 같은 사례를 체크리스트가 있는 사본과 뺀 사본으로 돌려 점수와 비용을 비교한다(008).

| 사례 | 재는 것 |
| --- | --- |
| `reviewer-svelte` | `frontend-reviewer`의 "볼 것 (Svelte 5 / SvelteKit)" 절. Svelte 고유 문제 5개를 찾는지, 맞는 파일을 지적하지 않는지 |
| `reviewer-react` | 같은 에이전트의 "볼 것 (React / Next.js)" 절. React 고유 문제 5개 |
| `compose-code-review`, `compose-with-stack` | `/task end` 3단계의 리뷰어 구성. `code-review` 하나만 쓴 것과 `frontend-reviewer`를 더한 것이 같은 심은 문제를 얼마나 찾는지(사본 하나로 두 사례를 돌린다). `--tag compose` |

| `real-line`, `real-sky`, `real-birthday` | 실제 리뷰 실패(nolmeong 002·013·012 의 리뷰 전 커밋). 정답은 리뷰에서 고친 동작 버그이고 고친 커밋이 근거다(각 `case.yaml`). 버그마다 sonnet 판정, `real-line`에는 그대로 두기로 한 것을 🔴 로 올리지 않는지도 본다. `--tag real` |

`real-*`는 이 기계에서만 돈다. scaffold 가 `C:/Users/user/Documents/jihoons/nolmeong` 로컬 저장소에서 `git archive`로 커밋을 꺼내 만든다(그 저장소에는 쓰지 않는다). j-dev-kit 에는 nolmeong 코드를 넣지 않는다. 지시 없는 대조군이 정답을 늘 다 찾는 사례는 판별력이 없으니 쓰지 않는다(008).

다시 돌리기:

1. 이 플러그인 폴더를 두 번 복사한다(`with/frontend`, `without/frontend`). eval 실행은 의존 플러그인을 설치하지 않으니, 두 사본의 `.claude-plugin/plugin.json`에서 `dependencies`를 지운다. `without` 사본의 `agents/frontend-reviewer.md`에서 잴 절을 지운다.
2. 사본마다 돌린다. `--model`은 작업 세션의 모델로 바꾼다(모델이 바뀌면 다시 잰다). LLM 채점은 시험받는 모델과 다른 `sonnet`으로 한다. 반복은 사례마다 3회, 문구만 바꾸는 미세 비교(역할 문장 등)는 판마다 5회이고 그 문구가 없는 대조군을 둔다. 두 판이 모두 만점이면 판별력이 없는 것이니 지우지 않는다. 셸 도구는 주지 않는다(Windows 에는 eval 샌드박스가 없어 셸을 주면 실행이 거부된다. fixture 가 diff 를 `review.diff`로 남긴다).

```bash
claude plugin eval <사본> --ablation none --scaffold --trust-plugin --model opus --judge-model sonnet --runs 3 --case reviewer-svelte --no-publish --threshold 0 --json <사본>.json
```

3. 두 JSON 의 `cases[].aggregates.score`와 `costUsd`를 비교한다. 결과 폴더 `evals/results/`는 커밋하지 않는다.
