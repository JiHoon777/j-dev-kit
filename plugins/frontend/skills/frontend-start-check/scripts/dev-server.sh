#!/usr/bin/env bash
# 개발 서버 띄우고 듣는지 확인: bash dev-server.sh <포트> [<명령…>]
# 명령을 주면 로그 파일로 백그라운드에 띄우고, 그 포트에서 들을 때까지 기다린다. 명령은 그 포트로 띄우는 것이어야 한다.
# 명령 없이 주면(다른 도구로 이미 띄웠을 때) 듣는지만 기다린다.
# 성공하면 0: URL, PID, LOG, 끄기(끄는 명령) 줄을 쓰고, 서버는 계속 돈다.
# 실패하면 1: 포트를 이미 누가 쓴다, 명령이 먼저 끝났다(로그 끝을 보인다), 시간이 다 됐다(띄운 것을 끈다).
# 듣는지 확인할 방법이 없으면 띄우지 않고 2.
# 기다리는 시간은 DEV_SERVER_TIMEOUT(초, 기본 60). 확인 방법은 PORT_CHECK_METHODS(기본 "netstat devtcp nc", 빈 값이면 없음).
# 이 스크립트를 고치면 scripts/test-dev-server.sh 를 돌린다.

usage() { echo "사용법: bash dev-server.sh <포트> [<명령…>]" >&2; exit 2; }
[ "$#" -ge 1 ] && [[ $1 =~ ^[0-9]+$ ]] || usage
port=$1
shift
timeout=${DEV_SERVER_TIMEOUT:-60}

# 0 듣고 있음, 1 아님, 2 확인할 방법 없음. PORT_CHECK_METHODS 의 순서로 쓴다 (workflow task 스킬의 pick-port.sh 와 같은 함수. 고치면 둘 다)
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

port_open "$port"
case $? in
  2) echo "듣는지 확인할 방법 없음(netstat, bash /dev/tcp, nc 를 쓸 수 없다). 띄우지 않았다." >&2; exit 2 ;;
  0) if [ "$#" = 0 ]; then echo "URL: http://localhost:$port"; exit 0; fi
     echo "포트 $port 는 이미 다른 프로세스가 듣고 있다. 다른 서버의 화면일 수 있어 띄우지 않았다." >&2; exit 1 ;;
esac

pid= log=
# 자식까지 끄는 명령. Windows(Git Bash)에서는 kill 이 자식 프로세스를 끄지 못한다.
# 쓸 때마다 정한다: Git Bash 에서는 exec 가 같은 PID 로 새 Windows 프로세스를 띄워 winpid 가 바뀐다
stop_cmd() {
  if [ -r "/proc/$pid/winpid" ]; then echo "taskkill //PID $(< "/proc/$pid/winpid") //T //F"; else echo "pkill -P $pid; kill $pid"; fi
}
if [ "$#" -gt 0 ]; then
  log=$(mktemp "${TMPDIR:-/tmp}/dev-server-$port.XXXXXX")
  "$@" > "$log" 2>&1 < /dev/null &
  pid=$!
fi

deadline=$((SECONDS + timeout))
until port_open "$port"; do
  if [ -n "$pid" ] && ! kill -0 "$pid" 2> /dev/null; then
    echo "개발 서버가 포트 $port 에서 듣기 전에 끝났다. 로그 끝($log):" >&2
    tail -n 20 "$log" >&2
    exit 1
  fi
  if [ "$SECONDS" -ge "$deadline" ]; then
    echo "포트 $port 에서 ${timeout}초 동안 듣지 않는다." >&2
    if [ -n "$pid" ]; then
      eval "$(stop_cmd)" > /dev/null 2>&1
      echo "띄운 것을 껐다. 로그 끝($log):" >&2
      tail -n 20 "$log" >&2
    fi
    exit 1
  fi
  sleep 0.5
done

echo "URL: http://localhost:$port"
if [ -n "$pid" ]; then
  echo "PID: $pid"
  echo "LOG: $log"
  echo "끄기: $(stop_cmd)"
fi
