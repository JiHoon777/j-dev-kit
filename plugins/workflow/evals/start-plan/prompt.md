---
max_turns: 40
timeout_seconds: 1200
allowed_tools: [Skill, Agent, Read, Grep, Glob]
---

`task` 스킬을 `start 001 --here`로 불러 그 절차를 따른다. 이 실행에는 셸이 없어 git 과 검증 명령을 돌릴 수 없다. 1~2단계(시작 확인, 기준선, 스택 점검)는 모두 통과했고 스택 점검은 해당 없음이라고 보고 3단계 계획부터 한다. 플랜 모드 도구는 쓰지 않는다. 질문과 승인 요청(계획은 전문)은 턴의 마지막 메시지에 빠짐없이 쓰고 멈춘다.
