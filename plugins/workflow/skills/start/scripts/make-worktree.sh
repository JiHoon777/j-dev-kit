#!/usr/bin/env bash
# 항목 워크트리 따기: bash make-worktree.sh <기준 브랜치> <이름>
# 기준 브랜치가 체크아웃된 저장소 루트에서 돈다. <이름>은 w/ 를 뺀 브랜치 이름이다(예: 007-feat-x).
# 1. 기준 브랜치에 upstream 이 있으면 git pull --ff-only 로 최신으로 맞춘다. 없으면 건너뛴다.
# 2. .claude/worktrees/ 가 무시되지 않으면 .git/info/exclude 에 더한다(기준 폴더에 ?? .claude/ 가 남지 않게).
# 3. git worktree add .claude/worktrees/<이름> -b w/<이름> <기준>
# 첫 줄에 워크트리의 절대 경로를 쓴다.
# 끝 값: 0 됐다. 1 pull 이 실패해 지금의 로컬 기준 브랜치에서 땄다(둘째 줄부터 이유). 2 따지 못했다(이유).
# 이 스크립트를 고치면 scripts/test-make-worktree.sh 를 돌린다.

usage() { echo "사용법: bash make-worktree.sh <기준 브랜치> <이름>" >&2; exit 2; }
[ "$#" = 2 ] && [ -n "$1" ] && [ -n "$2" ] || usage
base=$1 name=$2
git() { command git -c core.quotePath=false "$@"; }
die() { echo "$1"; exit 2; }

[ "$(git branch --show-current)" = "$base" ] || die "기준 브랜치($base)에 있지 않다. 지금: $(git branch --show-current)"
git show-ref --verify -q "refs/heads/w/$name" && die "브랜치 w/$name 가 이미 있다"
dir=.claude/worktrees/$name
[ -e "$dir" ] && die "$dir 가 이미 있다"

rc=0 note=
if git rev-parse -q --verify "$base@{upstream}" > /dev/null 2>&1; then
  if ! out=$(GIT_TERMINAL_PROMPT=0 git pull -q --ff-only 2>&1); then
    rc=1 note="pull 실패. 지금의 로컬 $base 에서 땄다: $out"
  fi
fi

if ! git check-ignore -q .claude/worktrees/; then
  ex="$(git rev-parse --git-common-dir)/info/exclude"
  mkdir -p "$(dirname "$ex")" && echo '.claude/worktrees/' >> "$ex" || die "$ex 에 쓰지 못했다"
fi

out=$(git worktree add -q "$dir" -b "w/$name" "$base" 2>&1) || die "git worktree add 실패: $out"
(cd "$dir" && pwd)
[ -n "$note" ] && echo "$note"
exit "$rc"
