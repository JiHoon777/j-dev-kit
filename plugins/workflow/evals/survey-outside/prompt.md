---
max_turns: 80
timeout_seconds: 2400
allowed_tools: [Skill, Agent, Read, Grep, Glob, WebSearch, WebFetch, Write]
---

`backlog` 스킬을 `--survey CI 가 GitHub Actions 쪽 변경으로 깨지기 전에 고칠 것 찾기 --here`로 불러 그 절차를 따른다. 이 실행에는 셸이 없어 git 과 `gh`를 돌릴 수 없다. 저장소는 기준 브랜치 main 에 있고, 커밋하지 않은 변경은 없다. 후보를 보여 주고 고르게 하는 데서 멈춘다(항목 파일은 쓰지 않는다). 질문과 승인 요청은 턴의 마지막 메시지에 빠짐없이 쓰고 멈춘다.
