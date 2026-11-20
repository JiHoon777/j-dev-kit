# j-dev-kit

Claude Code 플러그인 마켓플레이스 저장소다. 내용은 마크다운 스킬·에이전트와 훅 스크립트이고, 앱 코드는 없다.

## 작업 설정
- stack: 없음
- 기준 브랜치: main
- 검증 명령: `claude plugin validate .`
- 문서 언어: 한국어
- 동시 작업 세션: 2

## 저장소 규칙
- 원문은 한국어(`plugins/`)이고 번역본은 `i18n/en/`이다. 원문을 고치면 번역본도 고친다.
- 플러그인을 고치면 그 플러그인의 `plugin.json` `version`을 올린다. README 두 개와 `marketplace.json` 설명도 맞춘다.
- 조사 보고서와 노트는 `.claude/.local/`에 둔다(커밋하지 않는다).

## superpowers
이 문서의 규칙이 우선이다. `/task`가 부르는 스킬만 따르고, writing-plans, executing-plans,
subagent-driven-development, using-git-worktrees 는 쓰지 않는다.
