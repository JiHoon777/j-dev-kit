#!/usr/bin/env bash
# 설정 키·값 파일·키 검사: bash config-check.sh <기준 브랜치>
# 실패만 한 줄씩 쓴다. 키 값은 쓰지 않는다.
# - <기준>...HEAD 의 추가된 줄(마크다운 빼고)에서 새로 읽는 환경 변수가 추적하는 .env.example·.env.sample 어디에도 없으면
#   `파일:줄 — 새 환경 변수 <이름> 이 .env.example 에 없음` (NODE_ENV, CI 와 Vite 가 늘 정의하는 import.meta.env 의
#   DEV·PROD·MODE·SSR·BASE_URL 은 보지 않는다)
# - 추적하는 값 파일(.env, .env.local 같은 것. .example·.sample 은 뺀다): `파일 — 값 파일이 커밋됨`
# - 추가된 줄의 키(파일 이름만): sb_secret_ 키, role 이 anon 이 아닌 JWT(이 둘은 예시·샘플 파일에서 보지 않는다),
#   공개 접두사 환경 변수에 비밀 키 이름(마크다운 빼고)
# 실패가 있으면 1, 없으면 출력 없이 0.
# 저장소 루트에서 돈다. 이 스크립트를 고치면 scripts/test-config-check.sh 를 돌린다.

[ "$#" = 1 ] || { echo "사용법: bash config-check.sh <기준 브랜치>" >&2; exit 2; }
git() { command git -c core.quotePath=false "$@"; }
cd "$(git rev-parse --show-toplevel)" || exit 2
base=
for ref in "$1" "origin/$1"; do base=$(git merge-base "$ref" HEAD 2> /dev/null) && break; done
[ -n "$base" ] || { echo "기준 브랜치 '$1' 를 찾지 못했다." >&2; exit 2; }

# 추가된 줄: 파일<TAB>줄<TAB>내용
added=$(
  git diff --no-color --no-ext-diff -U0 --no-renames --src-prefix=a/ --dst-prefix=b/ "$base" HEAD |
    awk '
      /^\+\+\+ / { f = substr($0, 7); next }
      /^@@/ { match($0, /\+[0-9]+/); n = substr($0, RSTART + 1, RLENGTH - 1); next }
      /^\+/ { print f "\t" n "\t" substr($0, 2); n++ }'
)
files=$(git ls-files)
example_re='(^|/)([^/]*\.)?env(\.[^/]*)?\.(example|sample)$'
known=$(
  grep -E "$example_re" <<< "$files" | while IFS= read -r f; do
    git show "HEAD:$f" | sed -nE 's/^[[:space:]]*(export[[:space:]]+)?([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*=.*/\2/p'
  done
)

# 추가된 줄은 awk 한 번으로 본다(줄마다 프로세스를 띄우면 Windows 에서 느리다). 내는 줄:
#   E<TAB>새 환경 변수 실패  K<TAB>키 실패  J<TAB>파일<TAB>JWT 가운데 부분(role 은 아래에서 디코드)
# 환경 변수를 읽는 형태(Node·Vite 와 Supabase Edge Functions 의 Deno): process.env.X, import.meta.env.X, process.env["X"], Deno.env.get("X")
# 정규식과 이름 목록은 이스케이프를 건드리지 않게 환경 변수로 넘긴다
found=$(
  ENV_RE="(process\.env|import\.meta\.env)\.[A-Za-z_][A-Za-z0-9_]*|(process\.env\[|Deno\.env\.get\()[[:space:]]*[\"'][A-Za-z_][A-Za-z0-9_]*" \
  EXAMPLE_RE=$example_re KNOWN=$known awk '
    BEGIN {
      n = split(ENVIRON["KNOWN"], k, "\n"); for (i = 1; i <= n; i++) known[k[i]] = 1; known["NODE_ENV"] = known["CI"] = 1
      split("DEV PROD MODE SSR BASE_URL", v, " "); for (i in v) vite[v[i]] = 1 # Vite 가 늘 정의하는 import.meta.env 값
    }
    {
      t1 = index($0, "\t"); f = substr($0, 1, t1 - 1); rest = substr($0, t1 + 1)
      t2 = index(rest, "\t"); ln = substr(rest, 1, t2 - 1); line = substr(rest, t2 + 1)
      md = (f ~ /\.md$/); example = (f ~ ENVIRON["EXAMPLE_RE"])
      # 키 값 (예시·샘플 파일의 값은 자리표시자라 보지 않는다)
      s = example ? "" : line
      while (match(s, /sb_secret_[A-Za-z0-9_-]+/)) { if (RLENGTH >= 20) print "K\t" f " — sb_secret_ 키"; s = substr(s, RSTART + RLENGTH) }
      s = example ? "" : line
      while (match(s, /eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+/)) {
        t = substr(s, RSTART, RLENGTH); s = substr(s, RSTART + RLENGTH); d = index(t, ".")
        if (d > 13 && length(t) - d >= 10) print "J\t" f "\t" substr(t, d + 1)
      }
      if (md) next
      s = line
      while (match(s, /(NEXT_PUBLIC_|VITE_|PUBLIC_|EXPO_PUBLIC_|NUXT_PUBLIC_|REACT_APP_|GATSBY_)[A-Z0-9_]*(SERVICE_ROLE|SECRET)[A-Z0-9_]*/)) {
        print "K\t" f " — 공개 접두사 환경 변수에 비밀 키 이름(" substr(s, RSTART, RLENGTH) ")"; s = substr(s, RSTART + RLENGTH)
      }
      # 새 환경 변수 (.env.example 같은 파일 자신은 뺀다)
      if (example) next
      split("", seen)
      s = line
      while (match(s, ENVIRON["ENV_RE"])) {
        m = substr(s, RSTART, RLENGTH); s = substr(s, RSTART + RLENGTH)
        form = m; sub(/.*[."\047]/, "", m)
        if ((m in known) || (m in seen) || (form ~ /^import\.meta\.env\./ && m in vite)) continue
        seen[m] = 1
        print "E\t" f ":" ln " — 새 환경 변수 " m " 이 .env.example 에 없음"
      }
    }' <<< "$added"
)

role_of() { # JWT 가운데 부분(base64url)의 role
  local p=${1//-/+} json re='"role"[[:space:]]*:[[:space:]]*"([^"]*)"'
  p=${p//_//}
  while ((${#p} % 4)); do p+="="; done
  json=$(printf '%s' "$p" | base64 -d 2> /dev/null)
  [[ $json =~ $re ]] && echo "${BASH_REMATCH[1]}"
}
missing= keys=
while IFS=$'\t' read -r kind a b; do
  case $kind in
    E) missing+=$a$'\n' ;;
    K) keys+=$a$'\n' ;;
    J) role=$(role_of "$b"); [ "$role" = anon ] || keys+="$a — JWT 토큰(role: ${role:-없음})"$'\n' ;;
  esac
done <<< "$found"
values=$(grep -E '(^|/)\.env($|\.)' <<< "$files" | grep -vE '\.(example|sample)$' | sed 's/$/ — 값 파일이 커밋됨/')
keys=$(printf '%s' "$keys" | awk '!seen[$0]++') # 파일마다 같은 이유는 한 번

out=$(printf '%s%s\n%s' "$missing" "$values" "$keys" | sed '/^$/d')
[ -n "$out" ] || exit 0
printf '%s\n' "$out"
exit 1
