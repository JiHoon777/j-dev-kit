# frontend eval

고정 체크리스트가 지금 모델에 도움이 되는지 잰다. 모델이 바뀌면 다시 돌린다. 같은 사례를 체크리스트가 있는 사본과 뺀 사본으로 돌려 점수와 비용을 비교한다(008).

| 사례 | 재는 것 |
| --- | --- |
| `reviewer-svelte` | `frontend-reviewer`의 "볼 것 (Svelte 5 / SvelteKit)" 절. Svelte 고유 문제 5개를 찾는지, 맞는 파일을 지적하지 않는지 |
| `reviewer-react` | 같은 에이전트의 "볼 것 (React / Next.js)" 절. React 고유 문제 5개 |

다시 돌리기:

1. 이 플러그인 폴더를 두 번 복사한다(`with/frontend`, `without/frontend`). eval 실행은 의존 플러그인을 설치하지 않으니, 두 사본의 `.claude-plugin/plugin.json`에서 `dependencies`를 지운다. `without` 사본의 `agents/frontend-reviewer.md`에서 잴 절을 지운다.
2. 사본마다 돌린다. `--model`은 작업 세션의 모델로 바꾼다. 셸 도구는 주지 않는다(Windows 에는 eval 샌드박스가 없어 셸을 주면 실행이 거부된다. fixture 가 diff 를 `review.diff`로 남긴다).

```bash
claude plugin eval <사본> --ablation none --scaffold --trust-plugin --model opus --runs 3 --case reviewer-svelte --no-publish --threshold 0 --json <사본>.json
```

3. 두 JSON 의 `cases[].aggregates.score`와 `costUsd`를 비교한다. 결과 폴더 `evals/results/`는 커밋하지 않는다.
