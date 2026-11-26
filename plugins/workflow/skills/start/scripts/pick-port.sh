#!/usr/bin/env bash
# 항목 포트 고르기: bash pick-port.sh <기준 포트> <항목 번호>
# 후보는 기준 포트 + 항목 번호. 다음은 쓰이는 것으로 보고 1씩 올려 피한다.
# - 지금 듣고 있는 포트(127.0.0.1 과 ::1)
# - 다른 진행 중 항목(작업 트리의 docs/backlog 와 다른 w/ 브랜치의 항목 파일, status: In Progress)의 `### 포트` 줄
# - 그 항목들의 기본 포트(기준 포트 + 그 번호)
# 첫 줄에 고른 포트를 쓴다. 듣는지 확인할 방법이 없으면 항목만 피한 포트와 이유를 쓰고 2로 끝난다.
# 확인 방법은 PORT_CHECK_METHODS(기본 "netstat devtcp nc", 빈 값이면 없음)의 순서로 쓴다.
# 저장소 루트에서 돈다. 이 스크립트를 고치면 scripts/test-pick-port.sh 를 돌린다.

usage() { echo "사용법: bash pick-port.sh <기준 포트> <항목 번호>" >&2; exit 2; }
[ "$#" = 2 ] || usage
[[ $1 =~ ^[0-9]+$ && $2 =~ ^[0-9]+$ ]] || usage
base=$1 num=$((10#$2))
git() { command git -c core.quotePath=false "$@"; }

# 0 듣고 있음, 1 아님, 2 확인할 방법 없음. PORT_CHECK_METHODS 의 순서로 쓴다 (frontend 의 dev-server.sh 와 같은 함수. 고치면 둘 다)
port_open() {
  local p=$1 m out dir j4 j6 rc4 rc6
  for m in ${PORT_CHECK_METHODS-netstat devtcp nc}; do
    case $m in
      netstat) # 한 번에 목록을 읽어 빠르다. 상태 낱말(LISTEN)은 언어마다 달라, 상대 주소가 빈 TCP 줄을 듣는 줄로 본다
        # TCP 줄이 하나도 없으면 netstat 이 소켓을 보여 주지 못한 것이다(macOS 에서 bash 로 돌 때 그럴 수 있다). 다음 방법으로 넘어간다
        out=$(netstat -an 2> /dev/null) && grep -qE '^[[:space:]]*(TCP|tcp[46]*)[[:space:]]' <<< "$out" || continue
        grep -qE "^[[:space:]]*(TCP|tcp[46]*)[[:space:]].*[.:]$p[[:space:]]+(0\.0\.0\.0:0|\[::\]:0|0\.0\.0\.0:\*|:::\*|\*\.\*|\*:\*)([[:space:]]|\$)" <<< "$out" && return 0
        return 1 ;;
      devtcp) # 두 주소에 함께 붙는다(Windows 는 닫힌 포트에 붙는 데 2초쯤 걸린다)
        dir=$(mktemp -d)
        (LC_ALL=C; exec 3<> "/dev/tcp/127.0.0.1/$p") 2> "$dir/err" & j4=$!
        (exec 3<> "/dev/tcp/::1/$p") 2> /dev/null & j6=$!
        wait "$j4"; rc4=$?
        wait "$j6"; rc6=$?
        out=$(< "$dir/err")
        rm -rf "$dir"
        [ "$rc4" = 0 ] || [ "$rc6" = 0 ] && return 0
        [[ $out == *"No such file"* ]] && continue # 네트워크 경로를 지원하지 않는 bash 는 파일로 본다
        return 1 ;;
      nc)
        command -v nc > /dev/null || continue
        nc -z 127.0.0.1 "$p" 2> /dev/null || nc -z ::1 "$p" 2> /dev/null && return 0
        return 1 ;;
    esac
  done
  return 2
}

# 다른 w/ 브랜치의 항목 파일은 임시 폴더에 꺼내, 작업 트리의 항목 파일과 함께 awk 한 번으로 읽는다
# (macOS 의 bash 3.2 에도 돌게 연관 배열은 쓰지 않는다)
tmpd=$(mktemp -d)
trap 'rm -rf "$tmpd"' EXIT
current=$(git branch --show-current)
while IFS= read -r br; do
  [ "$br" = "$current" ] && continue
  name=${br#w/}
  git show "$br:docs/backlog/$name.md" > "$tmpd/$name.md" 2> /dev/null || rm -f "$tmpd/$name.md"
done < <(git for-each-ref --format='%(refname:short)' 'refs/heads/w/*')
shopt -s nullglob
items=(docs/backlog/[0-9]*.md "$tmpd"/[0-9]*.md)
taken=" "
[ "${#items[@]}" -gt 0 ] && taken=" $(awk -v base="$base" -v num="$num" '
  FNR == 1 { f = FILENAME; sub(/.*\//, "", f); id = match(f, /^[0-9]+/) ? substr(f, 1, RLENGTH) + 0 : -1; live = inport = 0 }
  id < 0 || id == num { next }
  /^status: In Progress/ { live = 1; printf "%d ", base + id; next }
  /^#/ { inport = ($0 ~ /^### 포트/); next }
  live && inport && /^- / { s = $0; while (match(s, /[0-9][0-9]+/)) { printf "%s ", substr(s, RSTART, RLENGTH); s = substr(s, RSTART + RLENGTH) } }
' "${items[@]}")"

port=$((base + num)) unknown=
while :; do
  if [[ $taken == *" $port "* ]]; then port=$((port + 1)); continue; fi
  port_open "$port"
  case $? in
    0) port=$((port + 1)); continue ;;
    2) unknown=1 ;;
  esac
  break
done

echo "$port"
if [ "$unknown" ]; then
  echo "듣는지 확인할 방법 없음(netstat, bash /dev/tcp, nc 를 쓸 수 없다). 다른 항목의 포트만 피했다." >&2
  exit 2
fi
