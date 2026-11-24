# workflow eval

고정 체크리스트가 지금 모델에 도움이 되는지 잰다. 모델이 바뀌면 다시 돌린다.

측정 방법(비교할 판 두기, 반복, 채점 기준 쓰기, 판별력·들쭉날쭉함 보기, 평균 ± 표준편차, 트리거 요청 고르기)은 Anthropic 공식 `skill-creator` 스킬을 따른다. 여기에는 이 플러그인의 사례와 `claude plugin eval`로 돌리는 방법만 적는다. `skill-creator`의 트리거 스크립트(`run_eval.py`)는 파이프에 `select`를 써 네이티브 Windows 에서 돌지 않을 수 있고, 실제 플러그인을 싣지 않는다. 그래서 트리거도 아래처럼 `claude plugin eval`로 돌린다(012).

| 사례 | 재는 것 |
| --- | --- |
| `trigger-real/*` | `task` description. 지난 세션의 실제 요청(부르지 말 것 10, 부를 것 3), 사용자 말투로 쓴 합성 요청(부를 것 7, 사용자가 라벨을 확인했다), 012 에서 더한 합성 요청(비슷하지만 아닌 부르지 말 것 3, 처음 보는 서베이 표현 2, 라벨은 description 문장 기준). `--tag trigger-real` |
| `start-plan-real` | `start.md` 3단계 계획을 실제 큰 항목(nolmeong 013, 시작 전 `d8c75f5`)으로. 정답은 사용자가 승인한 계획(`ed9250b`)의 핵심 결정 6가지다. 묻기만 하고 기본안이 없으면 정답으로 치지 않고, 답이 계획을 바꾸지 않는 질문은 감점한다(012 A7). nolmeong 로컬 저장소에서 `git archive`로 꺼내 만들므로 그 저장소가 있는 기계에서만 돈다. 저장소 경로는 커밋하지 않는 `evals/nolmeong-src.local`에 한 줄로 쓴다(frontend evals README 참고). `--tag real-plan` |
| `create-many`, `create-few` | 합성 사례. `create` 1단계의 질문(사용자만 정할 결정을 묻는가, 저장소에 답이 있는 것을 묻지 않는가, 답이 항목을 바꾸는가). `--tag b4` |
| `survey-outside` | 합성 사례(013). URL 없이 목표만 준 `create --survey`가 바깥을 검색·읽는지(기록의 `WebSearch`·`WebFetch`), 보고서를 `.claude/.local/reports/`에 남기는지, 후보마다 출처와 [직접]/[검색] 표시가 있는지, 이미 있는 항목(001 Node 버전)과 겹치는 후보를 거르는지. 보고서 내용은 파일 경로가 날짜·이름으로 바뀌어(채점의 파일 `focus`는 glob 을 받지 않는다) 마지막 메시지의 후보 표로 채점한다. 웹·파일 쓰기가 필요해 `--allow-tools WebSearch WebFetch Write`를 붙인다. `--tag survey` |
| `start-plan` | 스모크용. 스킬이 불러와지고 계획까지 가는지 본다. 008 에서 세 판 모두 만점이라 결정 근거로 쓰지 않는다 |
| `end-fix-real` | 스모크용. `end.md` 5단계 리뷰 수정(nolmeong 002 리뷰 직전 `2b5627e`, 고친 커밋 `3d1649b`·`5aaa792`). 프롬프트가 고칠 방법을 다 적어 9회 모두 다 고쳤고 위임판이 위임을 한 번만 해, 위임 결정의 근거로 쓰지 않는다(위임은 사용자 방침으로 정했다, 010). Edit·Write 가 필요해 `--allow-tools Edit Write`를 붙인다. `--tag real-fix` |

008 에서 계획 사례로 `start.md`의 "Explore 최대 2개", "질문 최대 3개"를 재고 지웠다. 다시 재려면 넣은 사본에 그 문구를 되살린다.

다시 돌리기:

1. 이 플러그인 폴더를 비교할 판마다 복사하고, 잴 문구를 판에 맞게 넣거나 지운다. eval 실행은 의존 플러그인을 설치하지 않으니 사본의 `.claude-plugin/plugin.json`에서 `dependencies`를 지운다. Stop 훅(`hooks/`)도 지운다.
2. 사본마다 돌린다. `--model`은 작업 세션의 모델로 바꾼다. LLM 채점은 시험받는 모델과 다른 `sonnet`으로 한다. 셸 도구는 주지 않는다(Windows 에는 eval 샌드박스가 없다. 사례 프롬프트가 1~2단계를 건너뛰게 한다).

```bash
claude plugin eval <사본> --ablation none --scaffold --trust-plugin --model opus --judge-model sonnet --runs 5 --tag real-plan --no-publish --threshold 0 -j 2 --json <사본>.json
```

3. JSON 의 `cases[].arms.with[]`(실행마다 `score`, `graders[].passed`, `costUsd`, `turns`)로 판을 견준다. 결과 폴더 `evals/results/`는 커밋하지 않는다.

판정: frontend evals README 의 판정 규칙과 같다.

008 결정에 이 규칙을 다시 적용한 것(012): 008 의 결과 JSON 이 남아 있지 않아 어림했다. Explore 최대 2개(0.733 대 0.733)는 "같음"이라 삭제 그대로다. 질문 최대 3개(0.733 대 0.783)는 차이 0.05 가 표준오차 합과 비슷해 이 수치로는 가를 수 없다. 012 에서 고친 채점으로 다시 쟀다(항목 012 Notes). 트리거 description(0.95 대 0.95)은 "같음"이라 그대로다.
