#!/usr/bin/env bash
# 기준 맞추기와 항목 워크트리 따기: bash make-worktree.sh [--no-pull] <기준 브랜치> [<이름>]
# 어느 폴더에서 불러도 기준 폴더(git worktree list 의 첫 줄)에서 돈다. <이름>은 w/ 를 뺀 브랜치 이름이다(예: 007-feat-x).
# 1. 기준 브랜치에 upstream 이 있으면 git pull --ff-only 로 최신으로 맞춘다. 없거나 --no-pull 이면 건너뛴다.
# <이름>이 없으면 여기서 멈추고 첫 줄에 기준 폴더 경로를 쓴다. 있으면 이어서
# 2. git worktree add .claude/worktrees/<이름> -b w/<이름> <기준>. 첫 줄에 워크트리 경로를 쓴다.
# 끝 값: 0 됐다. 1 pull 이 실패해 지금의 로컬 기준 브랜치를 썼다(둘째 줄부터 이유). 2 하지 못했다(이유).
# 이 스크립트를 고치면 scripts/test-make-worktree.sh 를 돌린다.

usage() { echo "사용법: bash make-worktree.sh [--no-pull] <기준 브랜치> [<이름>]" >&2; exit 2; }
pull=1
[ "${1-}" = --no-pull ] && { pull=; shift; }
[ "$#" = 1 ] || [ "$#" = 2 ] || usage
[ -n "$1" ] || usage
[[ $1 == -* || ${2-} == -* ]] && usage # --no-pull 은 첫 인자로만 받는다
base=$1 name=${2-}
[ "$#" = 2 ] && [ -z "$name" ] && usage
git() { command git -c core.quotePath=false "$@"; }
die() { echo "$1"; exit 2; }

root=$(git worktree list --porcelain 2> /dev/null | sed -n '1s/^worktree //p')
[ -n "$root" ] && cd "$root" || die "기준 폴더를 찾지 못했다"
[ "$(git branch --show-current)" = "$base" ] || die "기준 폴더($root)가 기준 브랜치($base)에 있지 않다. 지금: $(git branch --show-current)"
if [ -n "$name" ]; then
  git show-ref --verify -q "refs/heads/w/$name" && die "브랜치 w/$name 가 이미 있다"
  dir=.claude/worktrees/$name
  [ -e "$dir" ] && die "$dir 가 이미 있다"
fi

rc=0 note=
if [ -n "$pull" ] && git rev-parse -q --verify "$base@{upstream}" > /dev/null 2>&1; then
  if ! out=$(GIT_TERMINAL_PROMPT=0 git pull -q --ff-only 2>&1); then
    rc=1 note="pull 실패. 지금의 로컬 $base 를 쓴다: $out"
  fi
fi

if [ -z "$name" ]; then
  echo "$root"
  [ -n "$note" ] && echo "$note"
  exit "$rc"
fi

out=$(git worktree add -q "$dir" -b "w/$name" "$base" 2>&1) || die "git worktree add 실패: $out"
echo "$root/$dir"
[ -n "$note" ] && echo "$note"
exit "$rc"
