---
max_turns: 12
timeout_seconds: 900
allowed_tools: [Skill, Read, Grep, Glob]
---

`task` 스킬을 `create 결제 붙이자 --here`로 불러 그 절차를 따른다. 이 실행에는 셸이 없어 git 을 돌릴 수 없다. 저장소는 기준 브랜치 main 에 있고, 커밋하지 않은 변경은 없다. 질문과 승인 요청은 턴의 마지막 메시지에 빠짐없이 쓰고 멈춘다. 파일은 쓰지 않는다.
