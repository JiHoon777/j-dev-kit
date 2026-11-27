---
max_turns: 80
timeout_seconds: 2400
allowed_tools: [Skill, Agent, Read, Grep, Glob]
---

`start` 스킬을 `013`으로 불러 그 절차를 따른다. 이 실행에는 셸이 없어 git 과 검증 명령을 돌릴 수 없다. 1~2단계(시작 확인, 기준선, 스택 점검)는 모두 통과했고 스택 점검이 돌려준 것은 없다고 보고 3단계 계획만 한다. 4단계부터는 하지 않는다. 항목이 가리키는 저장소 밖 시안(`/Users/jihoon/jihoons/projects/sky-prototype`)은 이 기계에서 작업 디렉터리의 `sky-prototype/`이다. 계획 전문과 착수 전 질문(있을 때만)을 턴의 마지막 메시지에 쓰고 멈춘다.
