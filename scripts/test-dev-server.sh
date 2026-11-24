#!/usr/bin/env bash
# plugins/frontend/skills/frontend-start-check/scripts/dev-server.sh 의 시나리오 테스트. `bash scripts/test-dev-server.sh`
# 가짜 개발 서버는 node(없으면 python)로 localhost 에 띄운다. 하나라도 틀리면 1로 끝난다.

script="$(cd "$(dirname "$0")/.." && pwd)/plugins/frontend/skills/frontend-start-check/scripts/dev-server.sh"
tmp=$(mktemp -d)
pids=()
cleanup() { for p in "${pids[@]}"; do kill "$p" 2> /dev/null; done; rm -rf "$tmp"; }
trap cleanup EXIT
port=47201

# 가짜 개발 서버 명령: <포트>에서 듣는다
if command -v node > /dev/null; then
  serve=(node -e "require('net').createServer().listen(+process.argv[1],'localhost')")
else
  serve=(python -c "import socket,sys,time;s=socket.socket();s.bind(('127.0.0.1',int(sys.argv[1])));s.listen();time.sleep(600)")
fi
is_open() { (exec 3<> "/dev/tcp/127.0.0.1/$1") 2> /dev/null || (exec 3<> "/dev/tcp/::1/$1") 2> /dev/null; }
pid_of() { printf '%s\n' "$1" | sed -n 's/^PID: //p'; }

pass=0 total=0
# result <설명> <조건 결과 0/1> <이유>
result() {
  total=$((total + 1))
  if [ "$2" = 0 ]; then pass=$((pass + 1)); echo "맞음: $1"; else echo "틀림: $1 ($3)"; printf '%s\n' "$out" | sed 's/^/    /'; fi
}

# 1. 띄우고 듣기를 기다린다
out=$(DEV_SERVER_TIMEOUT=20 bash "$script" $port "${serve[@]}" $port 2>&1); code=$?
pid=$(pid_of "$out"); [ -n "$pid" ] && pids+=("$pid")
ok=1; [ "$code" = 0 ] && [[ $out == *"URL: http://localhost:$port"* ]] && [[ $out == *"끄기: "* ]] && is_open $port && ok=0
result "명령을 띄우고 듣기를 기다린다 → URL·PID·끄기, 스크립트가 끝나도 서버가 산다" $ok "종료 $code"

# 2. 같은 포트로 다시 띄우면 이미 쓰는 포트
out=$(DEV_SERVER_TIMEOUT=5 bash "$script" $port "${serve[@]}" $port 2>&1); code=$?
ok=1; [ "$code" = 1 ] && [[ $out == *"이미"* ]] && ok=0
result "이미 듣는 포트에 띄우기 → 1" $ok "종료 $code"

# 3. 명령 없이: 듣는지만 확인
out=$(DEV_SERVER_TIMEOUT=5 bash "$script" $port 2>&1); code=$?
ok=1; [ "$code" = 0 ] && [[ $out == *"URL: http://localhost:$port"* ]] && ok=0
result "명령 없이, 듣는 포트 → URL" $ok "종료 $code"

# 4. 끄기 줄의 명령으로 끈다
out=$(DEV_SERVER_TIMEOUT=20 bash "$script" $((port + 1)) "${serve[@]}" $((port + 1)) 2>&1)
pid=$(pid_of "$out"); [ -n "$pid" ] && pids+=("$pid")
stop=$(printf '%s\n' "$out" | sed -n 's/^끄기: //p')
eval "$stop" > /dev/null 2>&1
for _ in $(seq 30); do is_open $((port + 1)) || break; sleep 0.2; done
ok=1; [ -n "$stop" ] && ! is_open $((port + 1)) && ok=0
result "끄기 줄의 명령을 돌리면 서버가 꺼진다" $ok "끄기: $stop"

# 5. 명령 없이, 아무도 듣지 않음
out=$(DEV_SERVER_TIMEOUT=1 bash "$script" $((port + 2)) 2>&1); code=$?
ok=1; [ "$code" = 1 ] && [[ $out == *"듣지 않"* ]] && ok=0
result "명령 없이, 듣지 않는 포트 → 1" $ok "종료 $code"

# 6. 명령이 먼저 끝남 → 로그 끝을 보인다
out=$(DEV_SERVER_TIMEOUT=10 bash "$script" $((port + 3)) bash -c 'echo 포트-설정-오류; exit 3' 2>&1); code=$?
ok=1; [ "$code" = 1 ] && [[ $out == *"포트-설정-오류"* ]] && ok=0
result "명령이 듣기 전에 끝남 → 1, 로그 끝" $ok "종료 $code"

# 7. 시간이 다 되도록 듣지 않음 → 끄고 1
out=$(DEV_SERVER_TIMEOUT=2 bash "$script" $((port + 4)) sh -c "echo \$\$ > '$tmp/sleep.pid'; exec sleep 60" 2>&1); code=$?
sleeper=$(cat "$tmp/sleep.pid" 2> /dev/null); [ -n "$sleeper" ] && pids+=("$sleeper")
sleep 0.5
ok=1; [ "$code" = 1 ] && [[ $out == *"듣지 않"* ]] && [ -n "$sleeper" ] && ! kill -0 "$sleeper" 2> /dev/null && ok=0
result "시간이 다 되도록 듣지 않음 → 띄운 것을 끄고 1" $ok "종료 $code, 남은 프로세스 $sleeper"

# 8. 확인할 방법 없음
out=$(PORT_CHECK_METHODS= bash "$script" $((port + 5)) "${serve[@]}" $((port + 5)) 2>&1); code=$?
ok=1; [ "$code" = 2 ] && [[ $out == *"확인할 방법 없음"* ]] && ok=0
result "확인할 방법 없음 → 띄우지 않고 2" $ok "종료 $code"

# 9. 인자가 틀림
out=$(bash "$script" 2>&1); code=$?
ok=1; [ "$code" = 2 ] && [[ $out == *"사용법"* ]] && ok=0
result "인자가 틀림 → 사용법, 2" $ok "종료 $code"

echo "$total 개 중 $pass 개 맞음"
[ "$pass" = "$total" ]
