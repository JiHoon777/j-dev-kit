---
name: deslop
description: "커밋하기 전. 브랜치에 들어간 AI 생성 코드 군더더기를 걷어 내고 코드 스타일을 정리한다."
disable-model-invocation: true
---

# Remove AI code slop

> 원문: `cursor/plugins`의 `cursor-team-kit/skills/deslop/SKILL.md` (MIT, Cursor). Cursor 이름을 Claude Code 것으로 바꾸고 가져오지 않은 스킬을 가리키는 줄을 뺐다.

**언제:** 커밋하기 전. 브랜치에 들어간 AI 생성 코드 군더더기를 걷어 내고 코드 스타일을 정리한다.

기준 브랜치 대비 diff 를 보고, 이 브랜치에서 들어간 AI 생성 군더더기를 걷어 낸다.

## 볼 곳

- 필요 없거나 그 파일의 스타일과 맞지 않는 주석
- 믿을 수 있는 코드 경로에는 어울리지 않는 방어적 검사나 try/catch 블록
- 타입 문제를 피하려고만 쓴 `any` 캐스팅
- 이른 반환으로 단순하게 해야 할 깊은 중첩 코드
- 그 밖에 그 파일이나 주변 코드베이스와 맞지 않는 패턴

## 지킬 것

- 분명한 버그를 고치는 것이 아니면 동작을 바꾸지 않는다.
- 넓게 다시 쓰기보다 작고 초점이 분명한 수정을 한다.
- 마지막 요약은 짧게 쓴다(1~3문장).
