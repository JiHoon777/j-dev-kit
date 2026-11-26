---
name: principle-minimize-reader-load
description: "Minimize Reader Load 원칙. 따라가기 어려운 코드를 리뷰하거나 다듬을 때."
disable-model-invocation: true
---

# Minimize Reader Load

> 원문: `cursor/plugins`의 `pstack/skills/principle-minimize-reader-load/SKILL.md` (MIT, Lauren Tan). Cursor 이름을 Claude Code 것으로 바꾸고 가져오지 않은 스킬을 가리키는 줄을 뺐다.

**언제:** 따라가기 어려운 코드를 리뷰하거나 다듬을 때.

읽는 부담(reader load)은 코드를 이해하려고 읽는 사람이 해야 하는 일이다. 서로 독립인 두 축이 있다. 질문과 답 사이에서 따라가야 하는 계층, 그리고 머릿속에 들고 있어야 하는 숨은 상태나 변하는 상태다. 둘 다 지킨다.

- 전달만 하는 계층을 접는다. 호출자가 하나뿐인 래퍼, 두 번째 구현이 없는 어댑터, 그대로 넘기기만 하는 메서드가 그렇다. 인라인한다.
- 상태의 범위를 줄인다. 변경(mutation)보다 반환, 필드보다 지역 변수, 모듈 상태보다 필드, 전역보다 모듈 상태를 택한다. 동기화하지 말고 파생한다.
- 불변 조건은 쓰는 곳마다가 아니라 경계에서 한 번 이름 붙인다.

시험: 처음 읽는 사람이 "X 는 어디서 오나?"와 "무엇이 X 를 바꿀 수 있나?"에 30초 안에 답할 수 있는가? 아니라면 계층을 줄이거나 상태를 줄인다.
