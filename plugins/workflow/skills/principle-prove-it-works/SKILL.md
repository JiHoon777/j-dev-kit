---
name: principle-prove-it-works
description: "Prove It Works 원칙. 작업을 마친 뒤, 끝났다고 말하기 전에."
disable-model-invocation: true
---

# Prove It Works

> 원문: `cursor/plugins`의 `pstack/skills/principle-prove-it-works/SKILL.md` (MIT, Lauren Tan). Cursor 이름을 Claude Code 것으로 바꾸고 가져오지 않은 스킬을 가리키는 줄을 뺐다.

**언제:** 작업을 마친 뒤, 끝났다고 말하기 전에.

모든 결과물은 실물을 직접 확인해 검증한다. 기능을 돌려 보고, 실제 값을 읽고, diff 를 살핀다. 대리 지표(파일 수정 시각, 자기 보고, 캐시된 출력, "컴파일된다")는 치지 않는다. 확인이 실패하면 시스템보다 관찰 방법을 먼저 의심한다.

할 수 있으면 확인을 스크립트로 만든다. 비교를 다시 돌리는 결정적인 스크립트가 한 번 들여다보는 것보다 낫다. 그 출력은 사람이 볼 수 있는 곳에 둔다. 커밋은 나중에 그 흔적을 감사할 수 있어야 할 때만 한다.
