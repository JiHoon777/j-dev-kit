---
type: tool_used
tool: Write
input_match: '\.claude.{1,2}\.local.{1,2}reports.{1,2}[^"]+\.md'
weight: 1
---

서베이가 보고서를 `.claude/.local/reports/`에 쓴다(고르기 전이라 아직 references 로 옮기지 않았다). eval 은 `.claude/` 아래 쓰기를 막아 파일이 생기지 않으므로 그 경로로 Write 를 부른 것을 본다. 경로 구분자는 / 와 JSON 에서 두 겹이 된 역슬래시를 둘 다 맞춘다(`start-plan` 채점과 같은 방식).
