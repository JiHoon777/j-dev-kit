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
| workflow | `backlog-create` | 요청을 질문으로 좁혀 수용 기준이 붙은 백로그 항목 하나로 만든다 |
| workflow | `task-start` | 다음 항목을 추천·확인받고, 진행 중 표시, 브랜치 생성, 스택별 사전 점검, 플랜 |
| workflow | `task-end` | 검증·리뷰, 수용 기준을 증거로 확인, 완료 처리, 승인 후 커밋·푸시·PR. 못 끝내면 인계 메모 |

## 프로젝트 쪽 설정

각 프로젝트 CLAUDE.md 에 필요한 것만 적는다. 없으면 스킬이 추정한다.

```
stack: frontend, supabase     # 여러 개 가능. 없으면 폴더·의존성으로 추정
backlog: docs/backlog.md      # 기본값
worktree: true                # 쓰는 경우만
```

백로그는 저장소 안의 마크다운이다.

```
docs/backlog.md          한 줄에 한 항목 (Now / Backlog / Bugs / Inbox / Done)
docs/backlog/<ID>.md     항목별 상세: 무엇을, 왜, 수용 기준, 범위 밖, 인계
```

## 설계 원칙

- **같은 일을 하는 스킬은 하나만 둔다.** frontend·supabase·server 가 모두 켜져 있어도 충돌하지 않도록, 스택별로 스킬을 복제하지 않고 스킬 안에서 스택 섹션으로 나눈다. 여러 스택이 섞인 프로젝트는 해당 섹션을 전부 적용한다.
- **꼭 지켜야 할 점검은 SKILL.md 본문에 둔다.** 에이전트는 참고 문서를 자주 건너뛴다(Supabase 팀의 경험).
- **단계는 전부 하고, 해당 없으면 이유를 남기고 건너뛴다.** 완료는 증거(실제로 돌린 테스트, 직접 본 결과)로 판단한다.
- **결정은 사용자가 한다.** 다음 항목 선택, 백로그 쓰기, 커밋·푸시·PR 은 확인받은 뒤에 한다.

## 참고한 것

- [jpablodrexler/backlog-kit](https://github.com/jpablodrexler/backlog-kit): 단계별 진행과 "해당 없으면 이유를 남기고 건너뛰기", 수용 기준 형식, 다음 항목은 사용자가 확정
- [rave-altfred/claude-backlog-skill](https://github.com/rave-altfred/claude-backlog-skill): 한 줄 한 항목 백로그, 상태 표시, Now 섹션, 백로그 변경을 작업 커밋에 같이 넣기
- [tc3oliver/skills](https://github.com/tc3oliver/skills) `backlog`: 증거 기반 완료, 진행 중 항목 이어 하기와 인계 메모, 정의가 덜 된 항목은 Inbox
- [gringolito/backcraft](https://github.com/gringolito/backcraft): 질문으로 요구를 좁히기, 범위는 파일 목록이 아닌 의도로, 준비 안 된 항목 건너뛰기
- [Anthropic Agent Skills best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices), [Supabase Agent Skills](https://supabase.com/blog/supabase-agent-skills)
