---
name: principle-boundary-discipline
description: "Boundary Discipline 원칙. 검증, 오류 처리, 프레임워크 어댑터를 연결할 때."
disable-model-invocation: true
---

# Boundary Discipline

> 원문: `cursor/plugins`의 `pstack/skills/principle-boundary-discipline/SKILL.md` (MIT, Lauren Tan). Cursor 이름을 Claude Code 것으로 바꾸고 가져오지 않은 스킬을 가리키는 줄을 뺐다.

**언제:** 검증, 오류 처리, 프레임워크 어댑터를 연결할 때.

데이터가 시스템 경계(CLI 인자, 설정 파일, 외부 API, 네트워크)를 넘는 곳에서 검증하고, 타입을 좁히고, 오류를 처리한다. 안쪽에서는 타입을 믿는다. 다시 검증하지 않고, 불필요한 nil 검사도 하지 않는다. 날것의 데이터는 경계에서 도메인 타입으로 파싱하고, 전송 계층과 프레임워크의 타입은 공개 표면에 드러내지 않는다. 비즈니스 로직은 프레임워크 의존성이 없는 순수 함수에 둔다. 그 함수를 부르는 껍데기는 얇다.

시험은 두 가지다. 이 데이터가 지금 경계를 넘고 있는가? 아니라면 그 검증은 불필요하다. 이것을 껍데기가 부르기만 하면 되는 순수 함수로 만들 수 있는가? 그렇다면 뽑아낸다.
