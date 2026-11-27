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
check "첫 줄이 워크트리 경로" [ "$(head -n1 <<< "$out")" = "$(cd "$tmp/a/.claude/worktrees/001-x" 2> /dev/null && pwd -P)" ]
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

# 하위 폴더에서 불러도 기준 폴더에 딴다
repo "$tmp/s"
mkdir -p "$tmp/s/apps/web"
run "$tmp/s/apps/web" 001-x
check "하위 폴더에서 불러도 기준 폴더에 딴다" [ -d "$tmp/s/.claude/worktrees/001-x" ]
check "하위 폴더 안에는 생기지 않는다" [ ! -e "$tmp/s/apps/web/.claude" ]

# 머지된 다른 항목의 워크트리 안에서 불러도 기준 폴더에서 새로 딴다
run "$tmp/s/.claude/worktrees/001-x" 002-y
check "다른 워크트리에서 불러도 끝 값 0" [ "$rc" = 0 ]
check "다른 워크트리에서 불러도 기준 폴더에 딴다" [ "$(git -C "$tmp/s/.claude/worktrees/002-y" branch --show-current)" = w/002-y ]

# exclude 가 줄바꿈 없이 끝나면 앞 줄에 붙이지 않는다
repo "$tmp/n"
printf '*.secret' > "$tmp/n/.git/info/exclude"
run "$tmp/n" 001-x
check "줄바꿈 없는 exclude 의 앞 줄은 그대로" [ "$(sed -n 1p "$tmp/n/.git/info/exclude")" = '*.secret' ]
check "줄바꿈 없는 exclude 에도 한 줄로 더한다" [ "$(sed -n 2p "$tmp/n/.git/info/exclude")" = '.claude/worktrees/' ]

# 원격이 앞섬: pull 한 최신에서 딴다
cloned b
git -C "$tmp/b-other" commit -q --allow-empty -m newer && git -C "$tmp/b-other" push -q origin main
run "$tmp/b" 001-x
check "원격이 앞서면 끝 값 0" [ "$rc" = 0 ]
check "워크트리가 원격 최신에서 땄다" [ "$(git -C "$tmp/b/.claude/worktrees/001-x" rev-parse HEAD)" = "$(git -C "$tmp/b-other" rev-parse HEAD)" ]

# --no-pull: 원격이 앞서도 pull 하지 않고 로컬 기준에서 딴다
cloned e
git -C "$tmp/e-other" commit -q --allow-empty -m newer && git -C "$tmp/e-other" push -q origin main
out=$(cd "$tmp/e" && bash "$script" --no-pull main 001-x); rc=$?
check "--no-pull 끝 값 0" [ "$rc" = 0 ]
check "--no-pull 은 로컬 기준에서 딴다" [ "$(git -C "$tmp/e/.claude/worktrees/001-x" rev-parse HEAD)" = "$(git -C "$tmp/e" rev-parse main)" ]
check "--no-pull 은 기준 브랜치를 움직이지 않는다" [ "$(git -C "$tmp/e" rev-parse main)" != "$(git -C "$tmp/e-other" rev-parse HEAD)" ]

out=$(cd "$tmp/e" && bash "$script" main --no-pull 2>&1); rc=$?
check "--no-pull 을 뒤에 붙이면 끝 값 2" [ "$rc" = 2 ]
check "--no-pull 을 뒤에 붙여도 워크트리를 따지 않는다" [ ! -e "$tmp/e/.claude/worktrees/--no-pull" ]

# 갈라짐: pull 이 실패하면 로컬 기준에서 따고 1과 이유
cloned c
git -C "$tmp/c-other" commit -q --allow-empty -m remote && git -C "$tmp/c-other" push -q origin main
git -C "$tmp/c" commit -q --allow-empty -m local
run "$tmp/c" 001-x
check "갈라지면 끝 값 1" [ "$rc" = 1 ]
check "갈라지면 로컬 기준에서 땄다" [ "$(git -C "$tmp/c/.claude/worktrees/001-x" rev-parse HEAD)" = "$(git -C "$tmp/c" rev-parse main)" ]
check "갈라지면 이유를 쓴다" grep -q 'pull 실패' <<< "$out"

# 이름 없이 부르면 pull 만 하고 기준 폴더 경로를 쓴다
cloned d
git -C "$tmp/d-other" commit -q --allow-empty -m newer && git -C "$tmp/d-other" push -q origin main
mkdir -p "$tmp/d/sub"
out=$(cd "$tmp/d/sub" && bash "$script" main); rc=$?
check "이름 없이 끝 값 0" [ "$rc" = 0 ]
check "이름 없이 첫 줄이 기준 폴더" [ "$(head -n1 <<< "$out")" = "$(cd "$tmp/d" && pwd -P)" ]
check "이름 없이 pull 했다" [ "$(git -C "$tmp/d" rev-parse main)" = "$(git -C "$tmp/d-other" rev-parse HEAD)" ]
check "이름 없이 워크트리는 따지 않는다" [ ! -e "$tmp/d/.claude" ]

exit "$fail"
