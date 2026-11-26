# Migrate Callers Then Delete Legacy APIs

> 원문: `cursor/plugins`의 `pstack/skills/principle-migrate-callers-then-delete-legacy-apis/SKILL.md` (MIT, Lauren Tan). Cursor 이름을 Claude Code 것으로 바꾸고 가져오지 않은 스킬을 가리키는 줄을 뺐다.

**언제:** 옛 호출자가 아직 남아 있는데 새 내부 API 를 들일 때.

호환 계층을 남겨 두지 말고, 호출자를 옮기는 일과 옛 API 를 지우는 일을 같은 차례(wave)에 한다.

- 테스트는 새 계약을 단언하도록 고치고, 리팩터링 전의 구현 세부만 지키던 테스트는 지운다

**적용되는 경우:**
- 하위 호환에 기대는 외부 사용자가 없다
- 프로젝트가 여러 곳을 한꺼번에 맞춰 바꾸는, 호환성을 깨는 변경을 감당할 수 있다
- 새 API 가 단순화나 리팩터링 작업의 일부다
