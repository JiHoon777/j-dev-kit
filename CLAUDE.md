# j-dev-kit

Claude Code 플러그인 마켓플레이스 저장소다. 내용은 마크다운 스킬·에이전트와 훅 스크립트이고, 앱 코드는 없다.

## 작업 설정
- stack: 없음
- 기준 브랜치: main
- 검증 명령: `claude plugin validate . && bash scripts/check-repo-rules.sh`
- 문서 언어: 한국어

## 저장소 규칙
- 원문은 한국어(`plugins/`)이고 번역본은 `i18n/en/`이다. 원문을 고치면 번역본도 고친다.
- 플러그인을 고치면 그 플러그인의 `plugin.json` `version`을 올린다. README 두 개와 `marketplace.json` 설명도 맞춘다.
- 백로그 항목이 근거로 삼는 조사 보고서와 리서치 노트는 `docs/backlog/references/`에 두고 커밋한다. 항목에는 그 경로를 적는다. 그 밖의 메모와 실행 결과는 `.claude/.local/`에 둔다(커밋하지 않는다).
