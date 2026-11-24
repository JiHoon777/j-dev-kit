#!/usr/bin/env bash
# 프론트엔드 diff 검사: bash diff-check.sh <기준 브랜치>
# <기준>...HEAD 에서
# - 추가된 줄(마크다운 파일 빼고)에 console.log, debugger, .only( 가 있으면 `파일:줄 — 이유`
# - package.json 의 의존성(dependencies, devDependencies, peerDependencies, optionalDependencies)이 바뀌었는데
#   그 폴더나 상위 폴더의 lockfile 이 바뀌지 않았으면 `파일 — 이유`. 비교에 node 를 쓴다
# 를 한 줄씩 쓴다(표준 출력에는 실패만). 확인 못 한 것은 표준 오류에 쓴다.
# 걸린 것이 있으면 1, 확인 못 한 것만 있으면 2, 없으면 출력 없이 0.
# 저장소 루트에서 돈다. 이 스크립트를 고치면 scripts/test-diff-check.sh 를 돌린다.

[ "$#" = 1 ] || { echo "사용법: bash diff-check.sh <기준 브랜치>" >&2; exit 2; }
git() { command git -c core.quotePath=false "$@"; }
cd "$(git rev-parse --show-toplevel)" || exit 2
base=
for ref in "$1" "origin/$1"; do base=$(git merge-base "$ref" HEAD 2> /dev/null) && break; done
[ -n "$base" ] || { echo "기준 브랜치 '$1' 를 찾지 못했다." >&2; exit 2; }

failed=0 unknown=0

# 1. 추가된 줄의 디버그 코드
found=$(
  git diff --no-color --no-ext-diff -U0 --no-renames --src-prefix=a/ --dst-prefix=b/ "$base" HEAD -- . ':(exclude)*.md' |
    awk '
      /^\+\+\+ / { f = substr($0, 7); next }
      /^@@/ { match($0, /\+[0-9]+/); n = substr($0, RSTART + 1, RLENGTH - 1); next }
      /^\+/ {
        s = substr($0, 2)
        if (s ~ /console\.log/) print f ":" n " — console.log 남음"
        if (s ~ /(^|[^A-Za-z0-9_$])debugger([^A-Za-z0-9_$]|$)/) print f ":" n " — debugger 남음"
        if (index(s, ".only(")) print f ":" n " — .only( 남음"
        n++
      }'
)
[ -n "$found" ] && { printf '%s\n' "$found"; failed=1; }

# 2. 의존성과 lockfile
changed=$(git diff --name-status --no-renames "$base" HEAD)
# 두 판은 인자 대신 표준 입력으로 넘긴다. Git Bash 는 / 로 시작하는 인자를 Windows 경로로 바꿔 버릴 수 있다
deps_changed() { # <package.json 경로>: 0 바뀜, 1 그대로, 2 node 없음
  command -v node > /dev/null || return 2
  { git show "$base:$1" 2> /dev/null; printf '\n--diff-check--\n'; git show "HEAD:$1" 2> /dev/null; } |
    node -e '
      const [a, b] = require("fs").readFileSync(0, "utf8").split("\n--diff-check--\n").map(s => {
        try { const j = JSON.parse(s.trim() || "{}");
          return JSON.stringify(["dependencies", "devDependencies", "peerDependencies", "optionalDependencies"].map(k => j[k] || {})) }
        catch (e) { return s }
      });
      process.exit(a === b ? 1 : 0)'
}
lock_re='(^|/)(package-lock\.json|npm-shrinkwrap\.json|pnpm-lock\.yaml|yarn\.lock|bun\.lockb?)$'
lock_dirs=" " # lockfile 이 바뀐 폴더들
while IFS=$'\t' read -r st f; do
  [[ $f =~ $lock_re ]] || continue
  if [[ $f == */* ]]; then lock_dirs+="${f%/*} "; else lock_dirs+=". "; fi
done <<< "$changed"
while IFS=$'\t' read -r st pkg; do
  [[ $st != D && $pkg =~ (^|/)package\.json$ ]] || continue
  deps_changed "$pkg"
  case $? in
    1) continue ;;
    2) echo "$pkg — 확인 못 함(node 없음)" >&2; unknown=1; continue ;;
  esac
  dir=$pkg lock=
  while :; do # 그 폴더와 상위 폴더의 lockfile 이 바뀌었나
    if [[ $dir == */* ]]; then dir=${dir%/*}; else dir=.; fi
    [[ $lock_dirs == *" $dir "* ]] && { lock=1; break; }
    [ "$dir" = . ] && break
  done
  [ "$lock" ] || { echo "$pkg — 의존성이 바뀌었는데 lockfile 이 그대로"; failed=1; }
done <<< "$changed"

[ "$failed" = 1 ] && exit 1
[ "$unknown" = 1 ] && exit 2
exit 0
