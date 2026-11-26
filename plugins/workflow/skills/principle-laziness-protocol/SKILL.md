---
name: principle-laziness-protocol
description: "Laziness Protocol 원칙. 리팩터링할 때, diff 크기를 가늠할 때, 추상화나 계층, 신호 전달(signal threading)을 더하고 싶어질 때."
disable-model-invocation: true
---

# Laziness Protocol

> 원문: `cursor/plugins`의 `pstack/skills/principle-laziness-protocol/SKILL.md` (MIT, Lauren Tan). Cursor 이름을 Claude Code 것으로 바꾸고 가져오지 않은 스킬을 가리키는 줄을 뺐다.

**언제:** 리팩터링할 때, diff 크기를 가늠할 때, 추상화나 계층, 신호 전달(signal threading)을 더하고 싶어질 때.

삭제하는 쪽, 문제를 푸는 가장 작은 변경 쪽으로 기운다.

- **결정을 한곳에 모은다.** 같은 선택을 여러 곳에서 되풀이하지 않는다. 진실의 원천(source of truth) 하나 뒤에 두고, 그 결과를 단순한 플래그로 넘긴다.
- **diff 를 줄인다.** 문제를 푸는 가장 작은 변경을 한다. 줄 수가 적은 쪽이 "우아한" 보일러플레이트보다 낫다.
