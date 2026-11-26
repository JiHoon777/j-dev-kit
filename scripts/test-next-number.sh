#!/usr/bin/env bash
# plugins/workflow/skills/backlog/scripts/next-number.sh 의 시나리오 테스트. `bash scripts/test-next-number.sh`
# 가짜 저장소를 만들어, 지금 폴더와 다른 브랜치(로컬, 원격 추적)의 항목 번호를 모두 세는지,
# git 저장소가 아니어도 지금 폴더만 보고 세는지 본다. 하나라도 틀리면 1로 끝난다.

script="$(cd "$(dirname "$0")/.." && pwd)/plugins/workflow/skills/backlog/scripts/next-number.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com
export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com
total=0 pass=0

# check <이름> <바라는 출력>: 지금 폴더에서 스크립트를 돌려 출력과 끝 값(0)을 본다
check() {
  local out code
  total=$((total + 1))
  out=$(bash "$script" 2>&1)
  code=$?
  if [ "$out" = "$2" ] && [ "$code" = 0 ]; then
    pass=$((pass + 1))
  else
    echo "틀림: $1. 바란 것 '$2', 나온 것 '$out' (끝 값 $code)"
  fi
}
item() { mkdir -p "$(dirname "$1")" && echo x > "$1"; }

# git 저장소가 아닌 폴더
mkdir "$tmp/plain" && cd "$tmp/plain" || exit 1
check "저장소 아님, 항목 없음 → 001" 001
item docs/backlog/003-feat-a.md
item docs/done/005-fix-b.md
item docs/backlog/README.md
item docs/backlog/_template.md
check "저장소 아님, 지금 폴더의 가장 큰 번호 + 1" 006

# 저장소: main 에 002, 008. 항목이 아닌 파일은 세지 않는다
git init -q -b main "$tmp/repo" && cd "$tmp/repo" || exit 1
item docs/done/002-fix-a.md
item docs/backlog/008-feat-b.md
item docs/backlog/README.md
item docs/backlog/_template.md
item docs/backlog/references/2026-11-26-016-note.md
git add -A && git commit -qm main
check "008 다음은 009 (앞의 0 을 8진수로 읽지 않는다)" 009

# 다른 작업 브랜치에만 있는 번호 (체크아웃하지 않은 브랜치)
git switch -q -c w/011-feat-c
item docs/backlog/011-feat-c.md
git add -A && git commit -qm c
git switch -q main
check "다른 로컬 브랜치의 번호를 센다" 012
[ "$(git branch --show-current)" = main ] && [ -z "$(git status --short)" ] || { total=$((total + 1)); echo "틀림: 브랜치나 작업 트리가 바뀌었다"; }

# 원격 추적 브랜치에만 있는 번호
git switch -q -c tmp-remote
item docs/done/020-fix-d.md
git add -A && git commit -qm d
git update-ref refs/remotes/origin/w/020-fix-d HEAD
git switch -q main && git branch -q -D tmp-remote
check "이미 가져온 원격 브랜치의 번호를 센다" 021

# 작업 브랜치에서 커밋하지 않은 새 항목
git switch -q -c w/work
item docs/backlog/025-feat-e.md
check "지금 폴더의 커밋하지 않은 항목도 센다" 026

echo "$total 개 중 $pass 개 맞음"
[ "$pass" = "$total" ]
