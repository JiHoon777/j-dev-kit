# j-dev-kit

Claude Code용 개인 스킬 마켓플레이스.

## 설치

```
/plugin marketplace add JiHoon777/j-dev-kit
/plugin install workflow@j-dev-kit
```

## 구성

| 플러그인 | 스킬 | 용도 |
|---|---|---|
| workflow | `task-start` | 작업 시작: 백로그 확인, 브랜치 생성, 스택별 사전 점검 |
| workflow | `task-end` | 작업 종료: 변경 점검, 백로그 갱신, 스택별 마무리 점검 |
| workflow | `backlog-create` | 백로그 항목 생성 |

## 설계 원칙

- **같은 일을 하는 스킬은 하나만 둔다.** 스택별로 스킬을 복제하지 않고, 스킬 안에서 스택 섹션으로 나눈다.
- **스택은 프로젝트에서 판별한다.** 프로젝트 CLAUDE.md에 `stack: frontend, supabase`처럼 적어두면 그대로 따르고, 없으면 폴더와 의존성으로 추정한다. 여러 스택에 해당하면 전부 적용한다.
- **꼭 지켜야 할 점검은 SKILL.md 본문에 둔다.** 참고 문서(references)는 길고 가끔 필요한 내용에만 쓴다. 에이전트가 참고 문서를 건너뛰는 경우가 많기 때문이다.
- 스택 전용 도구 스킬(예: RLS 점검)은 하는 일이 겹치지 않으므로 항상 켜둬도 된다. description에 쓰이는 상황을 분명히 적는다.

## 프로젝트 쪽 설정

각 프로젝트 CLAUDE.md에 한 줄 추가:

```
stack: frontend, supabase
```
