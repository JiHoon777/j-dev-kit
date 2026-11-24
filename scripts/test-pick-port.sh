#!/usr/bin/env bash
# plugins/workflow/skills/task/scripts/pick-port.sh 의 시나리오 테스트. `bash scripts/test-pick-port.sh`
# 임시 폴더에 가짜 저장소를 만들고, 다른 항목의 w/ 브랜치와 듣는 포트를 시나리오마다 꾸며 돌린다.
# 듣는 포트는 node(없으면 python)로 localhost 에 띄운다. 하나라도 틀리면 1로 끝난다.

script="$(cd "$(dirname "$0")/.." && pwd)/plugins/workflow/skills/task/scripts/pick-port.sh"
tmp=$(mktemp -d)
listener_pid=
cleanup() { [ -n "$listener_pid" ] && kill "$listener_pid" 2>/dev/null; rm -rf "$tmp"; }
trap cleanup EXIT
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com
export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com
base=47100 # 기준 포트. 이 기계에서 쓰지 않을 만한 높은 번호

# item <번호> <status> [포트 줄...]: 지금 폴더의 docs/backlog 에 항목 파일을 쓴다
item() {
  local num=$1 status=$2 f
  shift 2
  f="docs/backlog/$num-feat-x.md"
  mkdir -p docs/backlog
  printf -- "---\nid: '%s'\nstatus: %s\n---\n\n## Implementation Notes\n\n### 포트\n\n" "$num" "$status" > "$f"
  for line; do printf -- '- %s\n' "$line" >> "$f"; done
  printf '\n## Final Summary\n\n- 웹: %s 는 포트 칸이 아니다\n' $((base + 9)) >> "$f"
}
# other <번호> <status> [포트 줄...]: 다른 세션의 w/ 브랜치를 만든다(지금 브랜치는 그대로)
other() {
  local here
  here=$(git branch --show-current)
  git switch -q -c "w/$1-feat-x" main && item "$@" && git add -A && git commit -qm "$1 start" && git switch -q "$here"
}
make_repo() {
  git init -q -b main "$1" && cd "$1" || return 1
  echo fixture > README.md
  git add -A && git commit -qm fixture && git switch -q -c w/009-feat-x
  item 009 "In Progress" && git add -A && git commit -qm "009 start"
}
listen() { # 기준+9 포트를 localhost 에 띄운다
  local p=$((base + 9))
  if command -v node > /dev/null; then
    node -e "require('net').createServer().listen($p,'localhost')" &
  else
    python -c "import socket,time;s=socket.socket();s.bind(('127.0.0.1',$p));s.listen();time.sleep(60)" &
  fi
  listener_pid=$!
  for _ in $(seq 50); do (exec 3<> "/dev/tcp/127.0.0.1/$p") 2> /dev/null && return; (exec 3<> "/dev/tcp/::1/$p") 2> /dev/null && return; sleep 0.1; done
  return 1
}
unlisten() { kill "$listener_pid" 2> /dev/null; wait "$listener_pid" 2> /dev/null; listener_pid=; }

pass=0 total=0
# check <설명> <기대 종료 코드> <기대 첫 줄(포트)> <출력에 있어야 할 말 또는 -> <준비...> -- <인자...>
check() {
  local name=$1 want=$2 want_port=$3 want_text=$4 dir step out code ok=1 why=
  shift 4
  total=$((total + 1))
  dir="$tmp/case$total"
  cp -a "$tmp/template" "$dir"
  while [ "$#" -gt 0 ] && [ "$1" != -- ]; do
    (cd "$dir" && eval "$1") > /dev/null 2>&1 || { ok=; why="준비 실패: $1"; }
    shift
  done
  shift
  out=$(cd "$dir" && bash "$script" "$@" 2>&1)
  code=$?
  [ "$ok" ] && [ "$code" != "$want" ] && { ok=; why="종료 $code, 기대 $want"; }
  [ "$ok" ] && [ "$want_port" != - ] && [ "$(printf '%s\n' "$out" | head -n 1)" != "$want_port" ] && { ok=; why="첫 줄이 $want_port 가 아님"; }
  [ "$ok" ] && [ "$want_text" != - ] && [[ $out != *"$want_text"* ]] && { ok=; why="출력에 '$want_text' 없음"; }
  if [ "$ok" ]; then
    pass=$((pass + 1)); echo "맞음: $name"
  else
    echo "틀림: $name ($why)"; printf '%s\n' "$out" | sed 's/^/    /'
  fi
}

(make_repo "$tmp/template") > /dev/null 2>&1 || { echo "가짜 저장소를 만들지 못했다"; exit 1; }

check "겹치는 것 없음 → 기준+번호" 0 $((base + 9)) - -- $base 009
check "번호는 앞 0 없이도" 0 $((base + 9)) - -- $base 9
check "다른 w/ 브랜치 항목이 적은 포트 → 다음 번호" 0 $((base + 10)) - "other 012 'In Progress' '웹: $((base + 9))'" -- $base 009
check "서버 포트 줄도 피한다" 0 $((base + 10)) - "other 012 'In Progress' '웹: 5012' '서버: $((base + 9))'" -- $base 009
check "포트 칸 밖의 숫자는 보지 않는다" 0 $((base + 9)) - "other 012 'In Progress' '웹: 5012'" -- $base 009
check "끝난 항목의 포트는 피하지 않는다" 0 $((base + 9)) - "other 012 Done '웹: $((base + 9))'" -- $base 009
check "이 항목이 전에 적은 포트는 피하지 않는다" 0 $((base + 9)) - "item 009 'In Progress' '웹: $((base + 9))'" -- $base 009
check "작업 트리의 진행 중 항목도 피한다" 0 $((base + 10)) - "item 012 'In Progress' '웹: $((base + 9))'" -- $base 009
if listen; then
  check "듣고 있는 포트 → 다음 번호" 0 $((base + 10)) - -- $base 009
  check "다른 진행 중 항목의 기본 포트도 피한다" 0 $((base + 11)) - "other 010 'In Progress'" -- $base 009
  unlisten
else
  total=$((total + 1)); echo "틀림: 시험용 서버를 띄우지 못했다(node·python 없음?)"
fi
# 확인할 방법을 하나도 쓰지 못하는 기계를 흉내 낸다(빈 목록)
PORT_CHECK_METHODS= check "확인할 방법 없음 → 항목만 피한 포트와 이유, 0 아님" 2 $((base + 9)) "확인할 방법 없음" -- $base 009
# PATH 에서 nc 가 있는 폴더를 뺀다(macOS 처럼 nc 가 있는 기계에서도 "없음"을 시험하려고)
no_nc_path=$(printf '%s' "$PATH" | tr ':' '\n' | while IFS= read -r d; do [ -x "$d/nc" ] || printf '%s:' "$d"; done)
PORT_CHECK_METHODS=nc PATH=${no_nc_path%:} check "nc 만 쓰는데 nc 없음 → 0 아님" 2 $((base + 9)) "확인할 방법 없음" -- $base 009
check "인자가 틀림 → 사용법, 0 아님" 2 - "사용법" -- $base

echo "$total 개 중 $pass 개 맞음"
[ "$pass" = "$total" ]
