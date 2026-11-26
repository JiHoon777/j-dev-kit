---
max_turns: 20
timeout_seconds: 1800
allowed_tools: [Skill, Read, Grep, Glob]
---

`workflow:server-start-check` 스킬을 Skill 도구로 불러 그 결과(지킬 것, 플랜에 넣을 것, 물을 것)를 따르며, 항목 `docs/backlog/010-feat-working-copy-publish-functions.md`를 구현할 계획을 세운다. 이 실행에는 셸이 없어 git 과 명령을 돌릴 수 없다. 저장소는 기준 브랜치 main 에 있다. 파일은 고치지 않는다. 마지막 메시지에 계획 전문(무엇을 하나, 바꿀 파일과 각각의 일, 순서, 지킬 것, AC 마다 확인 방법, 가정)을 쓰고 멈춘다. 질문이 있으면 함께 쓴다.
