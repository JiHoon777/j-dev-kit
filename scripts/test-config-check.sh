#!/usr/bin/env bash
# plugins/server/skills/server-end-check/scripts/config-check.sh 의 시나리오 테스트. `bash scripts/test-config-check.sh`
# 임시 폴더에 가짜 저장소를 만들고, 시나리오마다 복사해 작업 브랜치에 변경을 커밋한 뒤 돌린다.
# 키 값이 출력에 나오지 않는 것도 본다. 하나라도 틀리면 1로 끝난다.

script="$(cd "$(dirname "$0")/.." && pwd)/plugins/server/skills/server-end-check/scripts/config-check.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com
export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com

b64url() { printf '%s' "$1" | base64 | tr -d '\n=' | tr '+/' '-_'; }
jwt() { echo "$(b64url '{"alg":"HS256","typ":"JWT"}').$(b64url "{\"iss\":\"supabase\",\"role\":\"$1\"}").c2lnbmF0dXJlLXNpZ25hdHVyZQ"; }
service_jwt=$(jwt service_role)
anon_jwt=$(jwt anon)
secret=sb_secret_AbCdEf0123456789xyz

make_repo() {
  git init -q -b main "$1" && cd "$1" || return 1
  printf 'DATABASE_URL=\nexport API_KEY=\n' > .env.example
  mkdir -p src apps/api
  printf 'const old = process.env.OLD_VAR\n' > src/server.ts
  printf 'INNER_KEY=\n' > apps/api/.env.example
  printf 'const k = "%s"\n' "$service_jwt" > src/legacy.ts # 기준에 이미 있던 키
  git add -A && git commit -qm fixture && git switch -q -c w/001-feat-x
}

pass=0 total=0
# check <설명> <기대 종료 코드> <출력에 있어야 할 줄들(|로 나눔) 또는 -> <없어야 할 말 또는 -> <변경 명령>
check() {
  local name=$1 want=$2 want_lines=$3 not_text=$4 change=$5 dir out code ok=1 why= l
  total=$((total + 1))
  dir="$tmp/case$total"
  cp -a "$tmp/template" "$dir"
  (cd "$dir" && eval "$change" && git add -A -f && git commit -qm change) > /dev/null 2>&1 || { ok=; why="준비 실패"; }
  out=$(cd "$dir" && bash "$script" main 2>&1)
  code=$?
  [ "$ok" ] && [ "$code" != "$want" ] && { ok=; why="종료 $code, 기대 $want"; }
  if [ "$ok" ] && [ "$want_lines" != - ]; then
    IFS='|' read -ra ls <<< "$want_lines"
    for l in "${ls[@]}"; do printf '%s\n' "$out" | grep -qxF -- "$l" || { ok=; why="'$l' 줄 없음"; break; }; done
  fi
  [ "$ok" ] && [ "$not_text" != - ] && [[ $out == *"$not_text"* ]] && { ok=; why="'$not_text' 가 나옴"; }
  if [ "$ok" ]; then
    pass=$((pass + 1)); echo "맞음: $name"
  else
    echo "틀림: $name ($why)"; printf '%s\n' "$out" | sed 's/^/    /'
  fi
}

(make_repo "$tmp/template") > /dev/null 2>&1 || { echo "가짜 저장소를 만들지 못했다"; exit 1; }

# 설정 키
check "아는 키만 읽음 → 출력 없이 0" 0 - "—" "echo 'const u = process.env.DATABASE_URL, k = process.env.API_KEY' > src/db.ts"
check "새 키가 .env.example 에 없음 → 파일:줄" 1 "src/pay.ts:2 — 새 환경 변수 STRIPE_SECRET 이 .env.example 에 없음" - \
  "printf 'import x from \"y\"\nconst s = process.env.STRIPE_SECRET\n' > src/pay.ts"
check "하위 폴더의 .env.example 에 있는 키 → 통과" 0 - "INNER_KEY" "echo 'os.getenv(\"INNER_KEY\")' > apps/api/main.py"
check "새 키와 .env.example 을 함께 고침 → 통과" 0 - "NEW_ONE" "echo 'process.env.NEW_ONE' > src/n.ts && echo 'NEW_ONE=' >> .env.example"
check "원래 있던 줄의 키는 보지 않는다" 0 - "OLD_VAR" "echo '// 다른 줄' >> src/server.ts"
check "NODE_ENV·CI 는 보지 않는다" 0 - "—" "echo 'if (process.env.NODE_ENV && process.env.CI) {}' > src/env.ts"
check "마크다운은 보지 않는다" 0 - "—" "echo '\`process.env.DOC_ONLY\`' > NOTES.md"
langs='process.env["L1"]
import.meta.env.VITE_L2
os.environ["L3"]
os.environ.get("L4")
os.getenv("L5")
os.Getenv("L6")
env::var("L7")
System.getenv("L8")
ENV["L9"]
ENV.fetch("L10")
Deno.env.get("L11")
Bun.env.L12
$_ENV["L13"]'
lines=
for n in 1 2 3 4 5 6 7 8 9 10 11 12 13; do
  name=L$n; [ $n = 2 ] && name=VITE_L2
  lines+="${lines:+|}src/langs.txt:$n — 새 환경 변수 $name 이 .env.example 에 없음"
done
check "언어별 읽는 형태 13가지 → 줄마다 파일:줄" 1 "$lines" - "cat > src/langs.txt <<'EOF'
$langs
EOF"

# 값 파일
check "커밋된 .env → 실패" 1 ".env — 값 파일이 커밋됨" - "echo 'DATABASE_URL=postgres://x' > .env"
check "커밋된 .env.local → 실패" 1 "apps/api/.env.local — 값 파일이 커밋됨" - "echo 'A=1' > apps/api/.env.local"

# 키 (파일 이름만, 값은 내지 않는다)
check "sb_secret_ 키 → 파일 이름만" 1 "src/admin.ts — sb_secret_ 키" "$secret" "echo 'const k = \"$secret\"' > src/admin.ts"
check "키 없이 sb_secret_ 낱말만 → 통과" 0 - "—" "echo '찾는 패턴: sb_secret_|eyJ' > docs.txt"
check "service_role JWT → 파일 이름만" 1 "seed/seed.ts — JWT 토큰(role: service_role)" "$service_jwt" "mkdir -p seed && echo 'const k = \"$service_jwt\"' > seed/seed.ts"
check "anon JWT → 통과" 0 - "—" "echo 'const k = \"$anon_jwt\"' > src/client.ts"
check "공개 접두사 환경 변수에 비밀 키 이름 → 실패" 1 "src/web.ts — 공개 접두사 환경 변수에 비밀 키 이름(NEXT_PUBLIC_SUPABASE_SERVICE_ROLE_KEY)" - \
  "echo 'NEXT_PUBLIC_SUPABASE_SERVICE_ROLE_KEY=' >> .env.example && echo 'process.env.NEXT_PUBLIC_SUPABASE_SERVICE_ROLE_KEY' > src/web.ts"
check "기준에 있던 키를 지운 변경은 걸리지 않는다" 0 - "—" "echo 'const k = 1' > src/legacy.ts"

total=$((total + 1))
out=$(cd "$tmp/template" && bash "$script" 2>&1); code=$?
if [ "$code" = 2 ] && [[ $out == *"사용법"* ]]; then pass=$((pass + 1)); echo "맞음: 인자 없음 → 사용법, 2"; else echo "틀림: 인자 없음 → 사용법, 2 (종료 $code)"; fi

echo "$total 개 중 $pass 개 맞음"
[ "$pass" = "$total" ]
