#!/usr/bin/env bash
# Stop 훅. 작업 브랜치(w/*)의 항목이 Definition of Done 을 체크했으면
# 기준 브랜치 CLAUDE.md 의 검증 명령을 실제로 돌려 본다. 실패하면 그 내용으로는 한 번만 되돌려 보낸다.
# 해당하지 않으면 아무것도 하지 않고 끝난다.
# "한 번만"은 내용(tree)과 명령으로 가린다. stop_hook_active 는 어느 Stop 훅(/goal 등)이 막았든 true 가 되어서,
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
  grep -m1 -iE "($1)[[:space:]]*:" | tr -d '\r' |
    sed -E 's/^[^:]*:[[:space:]]*//; s/^[^`]*`([^`]*)`.*$/\1/; s/[[:space:]]+$//'
}

# 검증 명령: 기준 브랜치 CLAUDE.md 의 "검증 명령:" 또는 "verify command:" 줄.
# 작업 브랜치가 판정할 명령을 바꾸거나 CLAUDE.md 를 지워 스스로 통과시키지 못하게 하려는 것이다.
# 기준 브랜치는 로컬에서, 없으면 origin 에서 찾는다. 기준 브랜치에 CLAUDE.md 나 그 줄이 없으면(첫 설정)
# 작업 트리의 것을 쓴다. 기준 브랜치를 찾지 못해도 작업 트리의 것을 쓰고 그렇다고 알린다.
keys='검증 명령|verify command'
md=$(cat CLAUDE.md 2>/dev/null)
work_cmd=$(setting "$keys" <<<"$md")
# 기준 브랜치 이름: 작업 트리 CLAUDE.md, 지웠으면 지우기 전 판(HEAD, 커밋했으면 지운 커밋의 부모), 그래도 없으면 main.
name_md=$md
if [ ! -f CLAUDE.md ]; then
  name_md=$(git show HEAD:CLAUDE.md 2>/dev/null)
  if [ -z "$name_md" ]; then
    del=$(git log -1 --format=%H --diff-filter=D -- CLAUDE.md 2>/dev/null)
    [ -n "$del" ] && name_md=$(git show "$del^:CLAUDE.md" 2>/dev/null)
  fi
fi
base=$(setting '기준 브랜치|base branch' <<<"$name_md")
base=${base:-main}
base_ref= base_cmd= fork_cmd=
for r in "$base" "origin/$base"; do
  git rev-parse --verify -q "$r^{commit}" >/dev/null 2>&1 && { base_ref=$r; break; }
done
if [ -n "$base_ref" ]; then
  base_cmd=$(git show "$base_ref:CLAUDE.md" 2>/dev/null | setting "$keys")
  # 이 브랜치가 명령을 바꿨는지는 갈라진 판과 비교한다(브랜치를 딴 뒤 기준 쪽만 바뀐 것은 이 브랜치 탓이 아니다).
  fork=$(git merge-base "$base_ref" HEAD 2>/dev/null)
  [ -n "$fork" ] && fork_cmd=$(git show "$fork:CLAUDE.md" 2>/dev/null | setting "$keys")
fi
cmd=${base_cmd:-$work_cmd}
[ -n "$cmd" ] || exit 0
changed=
if [ -z "$base_ref" ]; then
  changed="기준 브랜치 $base 을 찾지 못해(로컬, origin 모두) 작업 트리의 검증 명령으로 판정했다."
elif [ "$work_cmd" != "$fork_cmd" ] && [ "$cmd" != "$work_cmd" ]; then
  changed="이 브랜치가 검증 명령을 바꿨다(${work_cmd:-없음}). 판정은 $base 의 명령으로 했고, 바뀐 명령은 머지 뒤부터 쓰인다. /task end 리뷰에서 바뀐 명령을 본다."
fi

# 지금 작업 폴더의 내용(백로그 문서 제외)과 명령이 마지막으로 통과한 것과 같으면 다시 돌리지 않는다.
# 명령은 내용(tree) 밖(기준 브랜치)에서 오므로 표시에 함께 적는다.
idx=$(mktemp) || exit 0
cp "$(git rev-parse --git-path index)" "$idx" 2>/dev/null
tree=$(
  export GIT_INDEX_FILE="$idx"
  git add -A >/dev/null 2>&1
  git rm -r -q --cached --ignore-unmatch docs/backlog docs/done >/dev/null 2>&1
  git write-tree 2>/dev/null
)
rm -f "$idx"
key="$tree $cmd"
marker="$(git rev-parse --git-dir)/task-verified"
[ -n "$tree" ] && [ -f "$marker" ] && [ "$(cat "$marker")" = "$key" ] && exit 0
# 같은 브랜치·같은 내용·같은 명령으로 이미 되돌려 보냈으면 다시 보내지 않는다(바뀌면 다시 돌린다).
# 내용을 구하지 못했으면 Stop 훅 때문에 이어 가는 중일 때 통과시킨다(끝없이 막지 않게).
bounced="$(git rev-parse --git-dir)/task-verify-bounced"
if [ -n "$tree" ]; then
  [ -f "$bounced" ] && [ "$(cat "$bounced")" = "$branch $key" ] && exit 0
else
  printf '%s' "$input" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && exit 0
fi

out=$(eval "$cmd" 2>&1)
status=$?
if [ "$status" -eq 0 ]; then
  [ -n "$tree" ] && printf '%s' "$key" > "$marker"
  rm -f "$bounced"
  # 통과했어도 사용자에게는 알린다(Claude 는 막지 않는다).
  if [ -n "$changed" ]; then
    msg=${changed//\\/\\\\}
    printf '{"systemMessage": "%s"}\n' "${msg//\"/\\\"}"
  fi
  exit 0
fi
[ -n "$tree" ] && printf '%s' "$branch $key" > "$bounced"

{
  echo "검증 명령이 실패했다(종료 코드 $status): $cmd"
  echo "항목 $item 의 Definition of Done 은 체크돼 있다."
  [ -n "$changed" ] && echo "$changed"
  echo "고친 뒤 검증을 다시 돌린다. 항목의 ### Baseline 에 적힌 실패뿐이면 고치지 말고 그렇다고 사용자에게 알린다."
  echo "--- 출력의 마지막 40줄 ---"
  printf '%s\n' "$out" | tail -40
} >&2
exit 2
