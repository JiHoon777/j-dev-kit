#!/usr/bin/env bash
# 항목 포트 고르기: bash pick-port.sh <기준 포트> <항목 번호>
# 후보는 기준 포트 + 항목 번호. 다음은 쓰이는 것으로 보고 1씩 올려 피한다.
# - 지금 듣고 있는 포트(127.0.0.1 과 ::1)
# - 다른 진행 중 항목(작업 트리의 docs/backlog 와 다른 w/ 브랜치의 항목 파일, status: In Progress)의 `### 포트` 줄
# - 그 항목들의 기본 포트(기준 포트 + 그 번호)
# 첫 줄에 고른 포트를 쓴다. 듣는지 확인할 방법이 없으면 항목만 피한 포트와 이유를 쓰고 2로 끝난다.
# 확인 방법은 PORT_CHECK_METHODS(기본 "devtcp nc", 빈 값이면 없음)의 순서로 쓴다.
# 저장소 루트에서 돈다. 이 스크립트를 고치면 scripts/test-pick-port.sh 를 돌린다.

usage() { echo "사용법: bash pick-port.sh <기준 포트> <항목 번호>" >&2; exit 2; }
[ "$#" = 2 ] || usage
[[ $1 =~ ^[0-9]+$ && $2 =~ ^[0-9]+$ ]] || usage
base=$1 num=$((10#$2))
git() { command git -c core.quotePath=false "$@"; }

# 0 듣고 있음, 1 아님, 2 확인할 방법 없음
port_open() {
  local p=$1 m err h
  for m in ${PORT_CHECK_METHODS-devtcp nc}; do
    case $m in
      devtcp)
        for h in 127.0.0.1 ::1; do
          err=$( (exec 3<> "/dev/tcp/$h/$p") 2>&1) && return 0
        done
        # 네트워크 경로를 지원하지 않는 bash 는 파일로 보고 "No such file" 을 낸다
        [[ $err == *"No such file"* ]] && continue
        return 1 ;;
      nc)
        command -v nc > /dev/null || continue
        nc -z 127.0.0.1 "$p" 2> /dev/null || nc -z ::1 "$p" 2> /dev/null && return 0
        return 1 ;;
    esac
  done
  return 2
}

# 항목 파일 내용(표준 입력)이 진행 중이면 그 항목의 포트들을 한 줄에 하나씩 쓴다
item_ports() { # <그 항목 번호>
  local text
  text=$(cat)
  grep -q '^status: In Progress' <<< "$text" || return
  echo $((base + 10#$1))
  awk '/^#/ { inport = ($0 ~ /^### 포트/) ; next } inport && /^- / { print }' <<< "$text" | grep -oE '[0-9]{2,5}'
}

taken=$(
  for f in docs/backlog/[0-9]*.md; do
    [ -f "$f" ] || continue
    n=$(basename "$f" | grep -oE '^[0-9]+')
    [ "$((10#$n))" = "$num" ] && continue
    item_ports "$n" < "$f"
  done
  current=$(git branch --show-current)
  git for-each-ref --format='%(refname:short)' 'refs/heads/w/*' | while IFS= read -r br; do
    [ "$br" = "$current" ] && continue
    name=${br#w/}
    n=$(grep -oE '^[0-9]+' <<< "$name") || continue
    [ "$((10#$n))" = "$num" ] && continue
    git show "$br:docs/backlog/$name.md" 2> /dev/null | item_ports "$n"
  done
)

port=$((base + num)) unknown=
while :; do
  if grep -qxF "$port" <<< "$taken"; then port=$((port + 1)); continue; fi
  port_open "$port"
  case $? in
    0) port=$((port + 1)); continue ;;
    2) unknown=1 ;;
  esac
  break
done

echo "$port"
if [ "$unknown" ]; then
  echo "듣는지 확인할 방법 없음(bash /dev/tcp, nc 를 쓸 수 없다). 다른 항목의 포트만 피했다." >&2
  exit 2
fi
