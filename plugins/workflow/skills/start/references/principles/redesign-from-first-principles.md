# Redesign from First Principles

> 원문: `cursor/plugins`의 `pstack/skills/principle-redesign-from-first-principles/SKILL.md` (MIT, Lauren Tan). Cursor 이름을 Claude Code 것으로 바꾸고 가져오지 않은 스킬을 가리키는 줄을 뺐다.

**언제:** 기존 설계에 새 요구 사항을 넣을 때.

변경을 넣을 때 기존 설계에 덧붙이지 않는다. 그 요구 사항이 처음부터 기본 전제였던 것처럼 다시 설계한다.

- 영향받는 파일을 모두 읽고 지금의 설계를 이해한다
- 묻는다: "이 새 요구 사항을 안고 처음부터 쓴다면 무엇을 만들까?"
- 변경을 모든 참조에 퍼뜨린다: 타입, 문서, 예제, 근거를 적은 절
- 재설계 전체를 생각한 다음, 나눠서 차례로 낸다

기존 설계에 변경을 넣으면서 선택의 여지(option value)를 지키는 방법이 이것이다.
