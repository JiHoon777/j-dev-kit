#!/usr/bin/env bash
# plugins/workflow/skills/start/scripts/make-worktree.sh 의 시나리오 테스트. `bash scripts/test-make-worktree.sh`
# 임시 폴더에 원격(bare)과 클론을 만들어 시나리오마다 돌린다. 하나라도 틀리면 1로 끝난다.

script="$(cd "$(dirname "$0")/.." && pwd)/plugins/workflow/skills/start/scripts/make-worktree.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com
export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com
fail=0
check() { # check <이름> <조건 명령...>
  local n=$1
  shift
  if "$@"; then echo "통과: $n"; else echo "실패: $n"; fail=1; fi
}

# repo <폴더>: 원격 없는 저장소
repo() { git init -q -b main "$1" && git -C "$1" commit -q --allow-empty -m base; }
# cloned <이름>: 원격 <이름>.git 과 그 클론 <이름>, 다른 클론 <이름>-other
cloned() {
  git init -q --bare -b main "$tmp/$1.git"
  repo "$tmp/$1-seed" && git -C "$tmp/$1-seed" push -q "$tmp/$1.git" main
  git clone -q "$tmp/$1.git" "$tmp/$1" && git clone -q "$tmp/$1.git" "$tmp/$1-other"
}
run() { out=$(cd "$1" && bash "$script" main "$2"); rc=$?; }

# 원격 없음: 따고, 기준 폴더는 깨끗하고, exclude 에 한 줄
repo "$tmp/a"
run "$tmp/a" 001-x
check "원격 없음 끝 값 0" [ "$rc" = 0 ]
check "첫 줄이 워크트리 경로" [ "$(head -n1 <<< "$out")" = "$(cd "$tmp/a/.claude/worktrees/001-x" 2> /dev/null && pwd)" ]
check "브랜치 w/001-x" [ "$(git -C "$tmp/a/.claude/worktrees/001-x" branch --show-current)" = w/001-x ]
check "기준 폴더 깨끗함" [ -z "$(git -C "$tmp/a" status --short)" ]
check "exclude 한 줄" [ "$(grep -c '^\.claude/worktrees/$' "$tmp/a/.git/info/exclude")" = 1 ]
run "$tmp/a" 002-y
check "둘째 워크트리도 exclude 는 한 줄" [ "$(grep -c '^\.claude/worktrees/$' "$tmp/a/.git/info/exclude")" = 1 ]

# 이미 있는 브랜치, 기준 브랜치가 아님: 따지 않는다
run "$tmp/a" 001-x
check "이미 있는 브랜치 끝 값 2" [ "$rc" = 2 ]
git -C "$tmp/a" switch -q -c other
run "$tmp/a" 003-z
check "기준 브랜치가 아니면 끝 값 2" [ "$rc" = 2 ]
check "기준 브랜치가 아니면 따지 않음" [ ! -e "$tmp/a/.claude/worktrees/003-z" ]

# .gitignore 가 이미 무시하면 exclude 를 건드리지 않는다
repo "$tmp/g"
echo '.claude/' > "$tmp/g/.gitignore" && git -C "$tmp/g" add -A && git -C "$tmp/g" commit -qm ignore
run "$tmp/g" 001-x
check "무시되면 exclude 에 더하지 않음" [ "$(grep -c 'worktrees' "$tmp/g/.git/info/exclude")" = 0 ]
check "무시되면 따고 끝 값 0" [ "$rc" = 0 ]

# 원격이 앞섬: pull 한 최신에서 딴다
cloned b
git -C "$tmp/b-other" commit -q --allow-empty -m newer && git -C "$tmp/b-other" push -q origin main
run "$tmp/b" 001-x
check "원격이 앞서면 끝 값 0" [ "$rc" = 0 ]
check "워크트리가 원격 최신에서 땄다" [ "$(git -C "$tmp/b/.claude/worktrees/001-x" rev-parse HEAD)" = "$(git -C "$tmp/b-other" rev-parse HEAD)" ]

# 갈라짐: pull 이 실패하면 로컬 기준에서 따고 1과 이유
cloned c
git -C "$tmp/c-other" commit -q --allow-empty -m remote && git -C "$tmp/c-other" push -q origin main
git -C "$tmp/c" commit -q --allow-empty -m local
run "$tmp/c" 001-x
check "갈라지면 끝 값 1" [ "$rc" = 1 ]
check "갈라지면 로컬 기준에서 땄다" [ "$(git -C "$tmp/c/.claude/worktrees/001-x" rev-parse HEAD)" = "$(git -C "$tmp/c" rev-parse main)" ]
check "갈라지면 이유를 쓴다" grep -q 'pull 실패' <<< "$out"

exit "$fail"
