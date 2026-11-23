# workflow eval

고정 체크리스트가 지금 모델에 도움이 되는지 잰다. 모델이 바뀌면 다시 돌린다. 같은 사례를 체크리스트가 있는 사본과 뺀 사본으로 돌려 점수와 비용을 비교한다(008).

| 사례 | 재는 것 |
| --- | --- |
| `trigger-real/*` | `task` description. 지난 세션의 실제 요청(부르지 말 것 10, 부를 것 3)과 사용자 말투로 쓴 합성 요청(부를 것 7). 사용자가 라벨을 확인했다. `--tag trigger-real` |
| `start-plan` | `start.md` 3단계 계획. 여러 모듈에 걸친 항목에서 꼭 읽을 파일을 짚는지, 코드로 답할 수 있는 것을 묻지 않는지, 계획이 빠짐없는지 |
| `start-plan-real` | 같은 계획 단계를 실제 큰 항목(nolmeong 013, 시작 전 `d8c75f5`)으로. 정답은 사용자가 승인한 계획(`ed9250b`)의 핵심 결정 6가지다. nolmeong 로컬 저장소에서 `git archive`로 꺼내 만들므로 그 저장소가 있는 기계에서만 돈다. 저장소 경로는 커밋하지 않는 `evals/nolmeong-src.local`에 한 줄로 쓴다(frontend evals README 참고). `--tag real-plan` |

008 에서 두 계획 사례로 `start.md`의 "Explore 최대 2개", "질문 최대 3개"를 재고 지웠다. 다시 재려면 넣은 사본에 그 문구를 되살린다.

다시 돌리기:

1. 이 플러그인 폴더를 비교할 판마다 복사하고, 잴 문구를 판에 맞게 넣거나 지운다. eval 실행은 의존 플러그인을 설치하지 않으니 사본의 `.claude-plugin/plugin.json`에서 `dependencies`를 지운다. Stop 훅(`hooks/`)도 지운다.
2. 사본마다 돌린다. `--model`은 작업 세션의 모델로 바꾼다(모델이 바뀌면 다시 잰다). LLM 채점은 시험받는 모델과 다른 `sonnet`으로 한다. 반복은 사례마다 3회, 문구만 바꾸는 미세 비교(역할 문장 등)는 판마다 5회이고 그 문구가 없는 대조군을 둔다. 두 판이 모두 만점이면 판별력이 없는 것이니 지우지 않는다. 셸 도구는 주지 않는다(Windows 에는 eval 샌드박스가 없다. 사례 프롬프트가 1~2단계를 건너뛰게 한다).

```bash
claude plugin eval <사본> --ablation none --scaffold --trust-plugin --model opus --judge-model sonnet --runs 3 --no-publish --threshold 0 --json <사본>.json
```

3. 두 JSON 의 `cases[].aggregates.score`, 실행마다의 `costUsd`·`turns`를 비교한다. 결과 폴더 `evals/results/`는 커밋하지 않는다.
