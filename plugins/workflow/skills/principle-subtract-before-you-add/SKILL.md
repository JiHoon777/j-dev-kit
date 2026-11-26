---
name: principle-subtract-before-you-add
description: "Subtract Before You Add 원칙. 추가, 리팩터링, 재작성의 순서를 정할 때. 죽은 코드, 중복된 검증기, 껍데기만 남은 참조를 먼저 지우고, 더 단순해진 바탕 위에 짓는다."
disable-model-invocation: true
---

# Subtract Before You Add

> 원문: `cursor/plugins`의 `pstack/skills/principle-subtract-before-you-add/SKILL.md` (MIT, Lauren Tan). Cursor 이름을 Claude Code 것으로 바꾸고 가져오지 않은 스킬을 가리키는 줄을 뺐다.

**언제:** 추가, 리팩터링, 재작성의 순서를 정할 때. 죽은 코드, 중복된 검증기, 껍데기만 남은 참조를 먼저 지우고, 더 단순해진 바탕 위에 짓는다.

시스템을 발전시킬 때는 복잡함을 먼저 걷어 내고 그다음에 짓는다. 기본은 빼기다.

단순화를 꾸준한 투자로 삼는다. 설계를 처음 봤을 때보다 조금 더 단순하고 더 많은 일을 하게, 표면은 같거나 더 작게 남긴다.

- 짓기 전에 걷어 내는 순서로 한다
- 다듬기 전에 자른다(품질에 공을 들이기 전에 최소한으로 줄인다)
- 추측한 예외 경우가 아니라 관찰된 쓰임에 맞춰 설계한다
- 명세가 요구하는 것 이상의 추측성 검증기, 파서, 가드를 두지 않는다
- 프롬프트를 단순하게 한다(중복된 지시와 지나친 템플릿을 뺀다)
- 참조에 새로운 내용이 없으면 껍데기로 남기지 말고 지운다
