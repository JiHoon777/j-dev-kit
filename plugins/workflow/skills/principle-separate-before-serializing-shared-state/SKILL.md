---
name: principle-separate-before-serializing-shared-state
description: "Separate Before Serializing Shared State 원칙. 동시에 도는 행위자들이 같은 파일, 브랜치, 키, 상태 객체에 쓸 수 있을 때. 공유를 먼저 없애고, 공유하는 작성 대상 하나가 진짜 불변 조건일 때만 구조로 직렬화한다."
disable-model-invocation: true
---

# Separate Before Serializing Shared State

> 원문: `cursor/plugins`의 `pstack/skills/principle-separate-before-serializing-shared-state/SKILL.md` (MIT, Lauren Tan). Cursor 이름을 Claude Code 것으로 바꾸고 가져오지 않은 스킬을 가리키는 줄을 뺐다.

**언제:** 동시에 도는 행위자들이 같은 파일, 브랜치, 키, 상태 객체에 쓸 수 있을 때. 공유를 먼저 없애고, 공유하는 작성 대상 하나가 진짜 불변 조건일 때만 구조로 직렬화한다.

동시에 도는 행위자들이 같은 파일, 브랜치, 키, 객체에 쓸 수 있으면, 먼저 그들에게 공유 객체 하나가 필요한지, 아니면 서로 독립인 사실을 내놓는 것인지 묻는다. 기본은 행위자마다 자기 파일, 키, 브랜치, 상태 디렉터리를 주고, 상태를 읽는 곳에서만 합치는 것이다. 두 워커가 `state.json` 하나에 각자의 필드를 쓰는 것도 여전히 공유 변경이다.

공유하는 쓰기 대상 하나가 진짜 불변 조건일 때만, 접근을 구조로 직렬화한다(락 파일, 단일 작성자, 순차 단계, compare-and-swap). 지시문은 동시성 제어가 아니다. "락이 필요하다"는 말은 먼저 따져 볼 냄새다.
