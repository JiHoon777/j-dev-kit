#!/usr/bin/env bash
# 설정 키·값 파일·키 검사: bash config-check.sh <기준 브랜치>
# 실패만 한 줄씩 쓴다. 키 값은 쓰지 않는다.
# - <기준>...HEAD 의 추가된 줄(마크다운 빼고)에서 새로 읽는 환경 변수가 추적하는 .env.example·.env.sample 어디에도 없으면
#   `파일:줄 — 새 환경 변수 <이름> 이 .env.example 에 없음` (NODE_ENV, CI 는 보지 않는다)
# - 추적하는 값 파일(.env, .env.local 같은 것. .example·.sample 은 뺀다): `파일 — 값 파일이 커밋됨`
# - 추가된 줄의 키(파일 이름만): sb_secret_ 키, role 이 anon 이 아닌 JWT, 공개 접두사 환경 변수에 비밀 키 이름(마크다운 빼고)
# 실패가 있으면 1, 없으면 출력 없이 0.
# 저장소 루트에서 돈다. 이 스크립트를 고치면 scripts/test-config-check.sh 를 돌린다.

[ "$#" = 1 ] || { echo "사용법: bash config-check.sh <기준 브랜치>" >&2; exit 2; }
git() { command git -c core.quotePath=false "$@"; }
cd "$(git rev-parse --show-toplevel)" || exit 2
base=
for ref in "$1" "origin/$1"; do base=$(git merge-base "$ref" HEAD 2> /dev/null) && break; done
[ -n "$base" ] || { echo "기준 브랜치 '$1' 를 찾지 못했다." >&2; exit 2; }

failed=0
fail() { echo "$1"; failed=1; }

# 추가된 줄: 파일<TAB>줄<TAB>내용
added=$(
  git diff --no-color --no-ext-diff -U0 --no-renames --src-prefix=a/ --dst-prefix=b/ "$base" HEAD |
    awk '
      /^\+\+\+ / { f = substr($0, 7); next }
      /^@@/ { match($0, /\+[0-9]+/); n = substr($0, RSTART + 1, RLENGTH - 1); next }
      /^\+/ { print f "\t" n "\t" substr($0, 2); n++ }'
)

# 1. 새 환경 변수
example_re='(^|/)([^/]*\.)?env(\.[^/]*)?\.(example|sample)$|(^|/)\.env\.(example|sample)$'
known=$(
  git ls-files | grep -E "$example_re" | while IFS= read -r f; do
    git show "HEAD:$f" | sed -nE 's/^[[:space:]]*(export[[:space:]]+)?([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*=.*/\2/p'
  done
)
# 읽는 형태: process.env.X, import.meta.env.X, Bun.env.X 와 process.env["X"], Deno.env.get("X"), os.environ["X"],
# os.environ.get("X"), getenv("X")(Python·PHP·C·Java), os.Getenv/LookupEnv("X")(Go), env::var("X")(Rust), ENV["X"], ENV.fetch("X")(Ruby), $_ENV["X"]
# 줄마다 프로세스를 띄우면 Windows 에서 느려 awk 한 번으로 본다. 정규식과 이름 목록은 이스케이프를 건드리지 않게 환경 변수로 넘긴다
missing=$(
  ENV_RE="(process\\.env|import\\.meta\\.env|Bun\\.env)\\.[A-Za-z_][A-Za-z0-9_]*|(process\\.env\\[|Deno\\.env\\.get\\(|os\\.environ\\[|os\\.environ\\.get\\(|getenv\\(|Getenv\\(|LookupEnv\\(|env::var\\(|ENV\\[|ENV\\.fetch\\(|[\$]_ENV\\[)[ 	]*[\"'][A-Za-z_][A-Za-z0-9_]*" \
  EXAMPLE_RE=$example_re KNOWN=$known awk '
    BEGIN { n = split(ENVIRON["KNOWN"], k, "\n"); for (i = 1; i <= n; i++) known[k[i]] = 1; known["NODE_ENV"] = known["CI"] = 1 }
    {
      t1 = index($0, "\t"); f = substr($0, 1, t1 - 1); rest = substr($0, t1 + 1)
      t2 = index(rest, "\t"); ln = substr(rest, 1, t2 - 1); s = substr(rest, t2 + 1)
      if (f ~ /\.md$/ || f ~ ENVIRON["EXAMPLE_RE"]) next
      split("", seen)
      while (match(s, ENVIRON["ENV_RE"])) {
        m = substr(s, RSTART, RLENGTH); s = substr(s, RSTART + RLENGTH)
        sub(/.*[."\047]/, "", m)
        if ((m in known) || (m in seen)) continue
        seen[m] = 1
        print f ":" ln " — 새 환경 변수 " m " 이 .env.example 에 없음"
      }
    }' <<< "$added"
)
[ -n "$missing" ] && { printf '%s\n' "$missing"; failed=1; }

# 2. 커밋된 값 파일
while IFS= read -r f; do
  [ -n "$f" ] && fail "$f — 값 파일이 커밋됨"
done < <(git ls-files | grep -E '(^|/)\.env($|\.)' | grep -vE '\.(example|sample)$')

# 3. 키 (파일마다 이유 한 번, 값은 쓰지 않는다)
role_of() { # JWT 의 가운데 부분에서 role
  local p=${1//-/+}
  p=${p//_//}
  while [ $((${#p} % 4)) != 0 ]; do p="$p="; done
  printf '%s' "$p" | base64 -d 2> /dev/null | grep -oE '"role"[[:space:]]*:[[:space:]]*"[^"]*"' | sed -E 's/.*"([^"]*)"$/\1/'
}
keys=$(
  while IFS=$'\t' read -r f n line; do
    [ -n "$f" ] || continue
    [[ $line =~ sb_secret_[A-Za-z0-9_-]{10,} ]] && printf '%s — sb_secret_ 키\n' "$f"
    for tok in $(grep -oE 'eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}' <<< "$line"); do
      role=$(role_of "${tok#*.}")
      [ "$role" = anon ] || printf '%s — JWT 토큰(role: %s)\n' "$f" "${role:-없음}"
    done
    [[ $f == *.md ]] && continue
    for name in $(grep -oE '(NEXT_PUBLIC_|VITE_|PUBLIC_|EXPO_PUBLIC_|NUXT_PUBLIC_|REACT_APP_|GATSBY_)[A-Z0-9_]*(SERVICE_ROLE|SECRET)[A-Z0-9_]*' <<< "$line"); do
      printf '%s — 공개 접두사 환경 변수에 비밀 키 이름(%s)\n' "$f" "$name"
    done
  done < <(grep -E 'sb_secret_|eyJ|PUBLIC_|VITE_|REACT_APP_|GATSBY_' <<< "$added") | awk '!seen[$0]++'
)
[ -n "$keys" ] && { printf '%s\n' "$keys"; failed=1; }

exit "$failed"
