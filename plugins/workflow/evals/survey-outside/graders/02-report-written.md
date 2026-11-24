---
type: regex
target: trace
pattern: '"name":\s*"Write",\s*"input":\s*\{\s*"file_path":\s*"[^"]*\.claude/\.local/reports/[^"]+\.md"'
weight: 1
---

서베이가 보고서 파일을 `.claude/.local/reports/`에 쓴다(고르기 전이라 아직 references 로 옮기지 않았다). eval 실행은 `.claude/` 아래 쓰기를 권한으로 막아(허용 규칙으로도 풀리지 않는다, 013 에서 확인) 파일이 생기지 않으므로, 기록에 그 경로로 Write 를 부른 것이 있으면 통과로 본다.
