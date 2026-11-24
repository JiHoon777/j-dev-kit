#!/usr/bin/env bash
# Stop 훅. 작업 브랜치(w/*)의 항목이 Definition of Done 을 체크했으면
# 기준 브랜치 CLAUDE.md 의 검증 명령을 실제로 돌려 본다. 실패하면 그 내용으로는 한 번만 되돌려 보낸다.
# 해당하지 않으면 아무것도 하지 않고 끝난다.
# "한 번만"은 내용(tree)으로 가린다. stop_hook_active 는 어느 Stop 훅(/goal 등)이 막았든 true 가 되어서,
# 그것으로 빠져나가면 다른 훅이 한 번 막은 뒤로는 검증이 돌지 않는다. 내용을 구하지 못할 때만 그것으로 가린다.
# 이 스크립트를 고치면 scripts/test-verify-on-stop.sh 를 돌린다.

input=$(cat)

branch=$(git branch --show-current 2>/dev/null) || exit 0
case "$branch" in w/*) ;; *) exit 0 ;; esac
root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$root" || exit 0

# 이 브랜치의 항목 파일
name=${branch#w/}
item="docs/backlog/$name.md"
[ -f "$item" ] || item="docs/done/$name.md"
[ -f "$item" ] || exit 0

# Definition of Done 에 체크가 없으면 아직 끝났다고 한 것이 아니다.
sed -n '/<!-- DOD:BEGIN -->/,/<!-- DOD:END -->/p' "$item" | grep -qi '^[[:space:]]*- \[x\]' || exit 0

# CLAUDE.md 내용(표준 입력)에서 <이름>: 줄의 값을 뽑는다. 백틱이 있으면 그 안의 것.
setting() {
  local line val
  line=$(grep -m1 -iE "($1)[[:space:]]*:" | tr -d '\r')
  [ -n "$line" ] || return 0
  val=$(printf '%s' "$line" | sed -E 's/^[^:]*:[[:space:]]*//')
  case "$val" in
    *\`*\`*) val=$(printf '%s' "$val" | sed -E 's/^[^`]*`([^`]*)`.*$/\1/') ;;
  esac
  printf '%s' "$val" | sed -E 's/[[:space:]]+$//'
}

# 검증 명령: 기준 브랜치 CLAUDE.md 의 "검증 명령:" 또는 "verify command:" 줄.
# 작업 브랜치가 판정할 명령을 바꿔 스스로 통과시키지 못하게 하려는 것이다.
# 기준 브랜치에 CLAUDE.md 나 그 줄이 없으면(첫 설정) 작업 트리의 것을 쓴다.
[ -f CLAUDE.md ] || exit 0
keys='검증 명령|verify command'
work_cmd=$(setting "$keys" < CLAUDE.md)
base=$(setting '기준 브랜치|base branch' < CLAUDE.md)
base=${base:-main}
base_cmd=$(git show "$base:CLAUDE.md" 2>/dev/null | setting "$keys")
cmd=${base_cmd:-$work_cmd}
[ -n "$cmd" ] || exit 0
changed=
if [ -n "$base_cmd" ] && [ -n "$work_cmd" ] && [ "$base_cmd" != "$work_cmd" ]; then
  changed="이 브랜치가 검증 명령을 바꿨다($work_cmd). 판정은 $base 의 명령으로 했고, 바뀐 명령은 머지 뒤부터 쓰인다. /task end 리뷰에서 바뀐 명령을 본다."
fi

# 지금 작업 폴더의 내용(백로그 문서 제외)이 마지막으로 통과한 것과 같으면 다시 돌리지 않는다.
idx=$(mktemp) || exit 0
cp "$(git rev-parse --git-path index)" "$idx" 2>/dev/null
tree=$(
  export GIT_INDEX_FILE="$idx"
  git add -A >/dev/null 2>&1
  git rm -r -q --cached --ignore-unmatch docs/backlog docs/done >/dev/null 2>&1
  git write-tree 2>/dev/null
)
rm -f "$idx"
marker="$(git rev-parse --git-dir)/task-verified"
[ -n "$tree" ] && [ -f "$marker" ] && [ "$(cat "$marker")" = "$tree" ] && exit 0
# 같은 브랜치·같은 내용으로 이미 되돌려 보냈으면 다시 보내지 않는다(내용이 바뀌면 다시 돌린다).
# 내용을 구하지 못했으면 Stop 훅 때문에 이어 가는 중일 때 통과시킨다(끝없이 막지 않게).
bounced="$(git rev-parse --git-dir)/task-verify-bounced"
if [ -n "$tree" ]; then
  [ -f "$bounced" ] && [ "$(cat "$bounced")" = "$branch $tree" ] && exit 0
else
  printf '%s' "$input" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && exit 0
fi

out=$(eval "$cmd" 2>&1)
status=$?
if [ "$status" -eq 0 ]; then
  [ -n "$tree" ] && printf '%s' "$tree" > "$marker"
  rm -f "$bounced"
  # 통과했어도 사용자에게는 알린다(Claude 는 막지 않는다).
  [ -n "$changed" ] && printf '{"systemMessage": "%s"}\n' "$(printf '%s' "$changed" | sed 's/\\/\\\\/g; s/"/\\"/g')"
  exit 0
fi
[ -n "$tree" ] && printf '%s' "$branch $tree" > "$bounced"

{
  echo "검증 명령이 실패했다(종료 코드 $status): $cmd"
  echo "항목 $item 의 Definition of Done 은 체크돼 있다."
  [ -n "$changed" ] && echo "$changed"
  echo "고친 뒤 검증을 다시 돌린다. 항목의 ### Baseline 에 적힌 실패뿐이면 고치지 말고 그렇다고 사용자에게 알린다."
  echo "--- 출력의 마지막 40줄 ---"
  printf '%s\n' "$out" | tail -40
} >&2
exit 2
