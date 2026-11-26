---
name: principle-sequence-verifiable-units
description: "Sequence Work into Verifiable Units 원칙. 여러 단계로 된 일(훑어 고치기, 마이그레이션, 비슷한 수정의 연속)을 할 때, 그리고 커밋과 PR 을 쌓는 순서를 정할 때. 내는 순서 자체가 리뷰어에게 작업을 증명하게 한다."
disable-model-invocation: true
---

# Sequence Work into Verifiable Units

> 원문: `cursor/plugins`의 `pstack/skills/principle-sequence-verifiable-units/SKILL.md` (MIT, Lauren Tan). Cursor 이름을 Claude Code 것으로 바꾸고 가져오지 않은 스킬을 가리키는 줄을 뺐다.

**언제:** 여러 단계로 된 일(훑어 고치기, 마이그레이션, 비슷한 수정의 연속)을 할 때, 그리고 커밋과 PR 을 쌓는 순서를 정할 때. 내는 순서 자체가 리뷰어에게 작업을 증명하게 한다.

일을 작은 단위로 나눠 순서를 잡는다. 단위마다 확인할 수 있는 상태로 끝나게 하고, 지금 단위가 통과하기 전에는 다음으로 넘어가지 않는다.

훑어 고치기, 마이그레이션, 비슷한 수정의 연속에서 각 단위는 괄호 한 쌍이다. 알려진 정상 상태, 변경 하나, 검사 실행, 다음으로. 도구가 수정을 하더라도 단위별 검사는 돌린다.

작업을 증명하는 순서로 낸다. 실패하는 테스트가 먼저고 그다음이 수정이다. 빼는 것이 먼저고 그다음이 모양 바꾸기다. 기준선이 먼저고 그다음이 처치(treatment)다. 커밋은 하나하나 그것만으로 성립한다.
