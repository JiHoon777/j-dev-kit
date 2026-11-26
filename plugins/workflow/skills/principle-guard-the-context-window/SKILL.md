---
name: principle-guard-the-context-window
description: "Guard the Context Window 원칙. 컨텍스트가 차오를 때. 큰 출력, 긴 파일, 반복해서 읽기, 나눠 맡기기(fan-out) 계획이 그렇다."
disable-model-invocation: true
---

# Guard the Context Window

> 원문: `cursor/plugins`의 `pstack/skills/principle-guard-the-context-window/SKILL.md` (MIT, Lauren Tan). Cursor 이름을 Claude Code 것으로 바꾸고 가져오지 않은 스킬을 가리키는 줄을 뺐다.

**언제:** 컨텍스트가 차오를 때. 큰 출력, 긴 파일, 반복해서 읽기, 나눠 맡기기(fan-out) 계획이 그렇다.

부피가 큰 일은 하위 에이전트에 넘긴다. 메인 스레드에는 날것의 결과가 아니라 요약을 둔다.

**왜:** 컨텍스트가 넘치면 추론의 질이 떨어지고, 압축 때문에 내용이 뭉개지고, 진행이 멈춘다.

**패턴:**
- **단계의 크기를 정하고 범위에 상한을 둔다.** 단계마다 파일 수를 제한하고, 턴 예산을 정하고, 쓰는 방식(mechanism)마다 드는 비용을 셈에 넣는다.
