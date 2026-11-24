#!/usr/bin/env bash
# plugins/frontend/skills/frontend-end-check/scripts/diff-check.sh 의 시나리오 테스트. `bash scripts/test-diff-check.sh`
# 임시 폴더에 가짜 저장소를 만들고, 시나리오마다 복사해 작업 브랜치에 변경을 커밋한 뒤 돌린다. 하나라도 틀리면 1로 끝난다.

script="$(cd "$(dirname "$0")/.." && pwd)/plugins/frontend/skills/frontend-end-check/scripts/diff-check.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com
export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com

make_repo() {
  git init -q -b main "$1" && cd "$1" || return 1
  printf '{\n  "name": "web",\n  "scripts": { "dev": "vite" },\n  "dependencies": { "a": "1.0.0" }\n}\n' > package.json
  echo '{}' > package-lock.json
  mkdir -p src apps/web
  printf 'export const a = 1\nconsole.log("예전부터 있던 줄")\n' > src/a.js
  printf '{\n  "name": "inner",\n  "dependencies": { "b": "1.0.0" }\n}\n' > apps/web/package.json
  echo 'lockfileVersion: 9' > pnpm-lock.yaml
  git add -A && git commit -qm fixture && git switch -q -c w/001-feat-x
}

pass=0 total=0
# check <설명> <기대 종료 코드> <출력에 있어야 할 줄 또는 -> <없어야 할 말 또는 -> <변경 명령>
check() {
  local name=$1 want=$2 want_line=$3 not_text=$4 change=$5 dir out code ok=1 why=
  total=$((total + 1))
  dir="$tmp/case$total"
  cp -a "$tmp/template" "$dir"
  (cd "$dir" && eval "$change" && git add -A && git commit -qm change) > /dev/null 2>&1 || { ok=; why="준비 실패"; }
  out=$(cd "$dir" && bash "$script" main 2>&1)
  code=$?
  [ "$ok" ] && [ "$code" != "$want" ] && { ok=; why="종료 $code, 기대 $want"; }
  [ "$ok" ] && [ "$want_line" != - ] && ! printf '%s\n' "$out" | grep -qxF -- "$want_line" && { ok=; why="'$want_line' 줄 없음"; }
  [ "$ok" ] && [ "$not_text" != - ] && [[ $out == *"$not_text"* ]] && { ok=; why="'$not_text' 가 나옴"; }
  if [ "$ok" ]; then
    pass=$((pass + 1)); echo "맞음: $name"
  else
    echo "틀림: $name ($why)"; printf '%s\n' "$out" | sed 's/^/    /'
  fi
}

(make_repo "$tmp/template") > /dev/null 2>&1 || { echo "가짜 저장소를 만들지 못했다"; exit 1; }

check "걸리는 것 없음 → 출력 없이 0" 0 - "—" "echo 'export const b = 2' > src/b.js"
check "추가된 console.log → 파일:줄" 1 "src/a.js:4 — console.log 남음" "src/a.js:2" "printf 'const c = 3\nconsole.log(c)\n' >> src/a.js"
check "추가된 debugger" 1 "src/b.js:2 — debugger 남음" - "printf 'let x\ndebugger\n' > src/b.js"
check "추가된 .only(" 1 "src/a.test.js:1 — .only( 남음" - "echo 'it.only(\"x\", () => {})' > src/a.test.js"
check "지운 console.log 줄은 걸리지 않는다" 0 - "console.log" "printf 'export const a = 1\n' > src/a.js"
check "문서(.md)의 console.log 는 걸리지 않는다" 0 - "console.log" "echo '\`console.log\` 를 지운다' > NOTES.md"
check "debugger 가 낱말 일부면 걸리지 않는다" 0 - "debugger" "echo 'const debuggerPort = 9229' > src/b.js"
check "의존성이 바뀌고 lockfile 그대로 → 실패" 1 "package.json — 의존성이 바뀌었는데 lockfile 이 그대로" - "sed -i 's/\"a\": \"1.0.0\"/\"a\": \"2.0.0\"/' package.json"
check "의존성과 lockfile 이 함께 바뀜 → 통과" 0 - "lockfile" "sed -i 's/\"a\": \"1.0.0\"/\"a\": \"2.0.0\"/' package.json && echo '{\"v\":2}' > package-lock.json"
check "의존성 밖(scripts)만 바뀜 → 통과" 0 - "lockfile" "sed -i 's/\"vite\"/\"vite --open\"/' package.json"
check "하위 package.json 의존성 + 루트 lockfile → 통과" 0 - "lockfile" "sed -i 's/\"b\": \"1.0.0\"/\"b\": \"2.0.0\"/' apps/web/package.json && echo 'lockfileVersion: 9.1' > pnpm-lock.yaml"
check "하위 package.json 의존성만 → 실패" 1 "apps/web/package.json — 의존성이 바뀌었는데 lockfile 이 그대로" - "sed -i 's/\"b\": \"1.0.0\"/\"b\": \"2.0.0\"/' apps/web/package.json"
check "새 package.json 에 의존성, lockfile 없음 → 실패" 1 "pkg/package.json — 의존성이 바뀌었는데 lockfile 이 그대로" - "mkdir pkg && echo '{\"dependencies\":{\"c\":\"1\"}}' > pkg/package.json"

# node 가 없으면 의존성 비교를 못 한다
no_node_path=$(printf '%s' "$PATH" | tr ':' '\n' | while IFS= read -r d; do [ -x "$d/node" ] || [ -x "$d/node.exe" ] || printf '%s:' "$d"; done)
PATH=${no_node_path%:} check "node 없음 → 확인 못 함, 2" 2 "package.json — 확인 못 함(node 없음)" - "sed -i 's/\"a\": \"1.0.0\"/\"a\": \"2.0.0\"/' package.json"
total=$((total + 1))
out=$(cd "$tmp/template" && bash "$script" 2>&1); code=$?
if [ "$code" = 2 ] && [[ $out == *"사용법"* ]]; then pass=$((pass + 1)); echo "맞음: 인자 없음 → 사용법, 2"; else echo "틀림: 인자 없음 → 사용법, 2 (종료 $code)"; fi

echo "$total 개 중 $pass 개 맞음"
[ "$pass" = "$total" ]
