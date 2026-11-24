#!/usr/bin/env bash
# plugins/workflow/skills/task/scripts/base-tests.sh 의 시나리오 테스트. `bash scripts/test-base-tests.sh`
# 가짜 저장소: 기준 브랜치의 lib.sh 에는 버그(add 가 뺀다)가 있고, 작업 브랜치가 고친다.
# 작업 브랜치의 테스트 중 고친 것을 증명하는 것(기준에서 실패)과 증명하지 못하는 것(기준에서도 통과)을 구별하는지,
# 돌린 뒤 작업 트리가 원래대로인지 본다. 하나라도 틀리면 1로 끝난다.

script="$(cd "$(dirname "$0")/.." && pwd)/plugins/workflow/skills/task/scripts/base-tests.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com
export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com

make_repo() {
  git init -q -b main "$1" && cd "$1" || return 1
  printf 'add() { echo $(($1 - $2)); }\n' > lib.sh
  echo 'old() { :; }' > old.sh
  echo '[ 1 = 1 ]' > test-old.sh
  git add -A && git commit -qm fixture && git switch -q -c w/001-fix-add
}
# 준비 도우미 (복사한 저장소 안에서 돈다)
fix_add() { printf 'add() { echo $(($1 + $2)); }\n' > lib.sh; }
test_add() { printf '. ./lib.sh\n[ "$(add 2 3)" = 5 ]\n' > test-add.sh; }    # 기준에서 실패해야 한다
test_echo() { echo '[ 1 = 1 ]' > test-echo.sh; }                             # 기준에서도 통과한다
test_bad() { echo 'exit 1' > test-bad.sh; }                                  # HEAD 에서도 실패
new_source() { echo 'mul() { echo $(($1 * $2)); }' > lib2.sh; printf '. ./lib2.sh\n[ "$(mul 2 3)" = 6 ]\n' > test-mul.sh; }
helper_test() { mkdir -p tests && echo 'ok() { :; }' > tests/helper.sh && printf '. tests/helper.sh\nok\n' > tests/test-helper.sh; }
root_helper() { echo 'ok() { :; }' > test_utils.sh && printf '. ./test_utils.sh\nok\n' > test-uses-helper.sh; }   # 기준에서도 통과한다
support_helper() { mkdir -p support && echo 'ok() { :; }' > support/render.sh && printf '. support/render.sh\nok\n' > test-render.sh; }
slow_test() { printf '. ./lib.sh\n[ "$(add 2 3)" = 5 ] || { sleep 60; exit 1; }\n' > test-slow.sh; }  # 기준에서는 멈춘다
# 기준에도 있는 긴 경로의 파일 800개를 브랜치에서 바꾼다(경로를 모두 합치면 Windows 명령줄 한도 32K자를 넘는다)
many_sources() {
  local d=src/a-fairly-long-directory-name-so-the-argument-list-is-long i
  git switch -q main && mkdir -p "$d" && for i in $(seq -w 800); do echo a > "$d/file-$i.txt"; done &&
    git add -A && git commit -qm many && git switch -q w/001-fix-add && git merge -q --no-edit main &&
    for i in $(seq -w 800); do echo b > "$d/file-$i.txt"; done
}
jest_test() { mkdir -p src/__tests__ && printf '. ./lib.sh
[ "$(add 2 3)" = 5 ]
' > src/__tests__/login.js; }   # Jest 의 __tests__ 규칙
dir_test() { # tests/ 아래 테스트와 도우미·fixture. 도우미를 테스트로 고르면 기준에서도 통과(1), fixture 를 고르면 HEAD 에서 실패(2)다
  mkdir -p tests/helpers tests/fixtures && echo 'ok() { :; }' > tests/helpers/x.js && echo 'exit 1' > tests/fixtures/data.js &&
    printf '. tests/helpers/x.js
. ./lib.sh
ok && [ "$(add 2 3)" = 5 ]
' > tests/login.js
}
docs_only() { echo '# 문서' > README.md; }
delete_old() { git rm -q old.sh; }
commit() { git add -A && git commit -qm change; }
dirty() { echo dirty >> lib.sh; }

pass=0 total=0
# check <설명> <기대 종료 코드> <출력에 있어야 할 줄들(|로 나눔) 또는 -> <준비...> -- <인자...>
check() {
  local name=$1 want=$2 want_lines=$3 dir out code ok=1 why= before after l
  shift 3
  total=$((total + 1))
  dir="$tmp/case$total"
  cp -a "$tmp/template" "$dir"
  while [ "$#" -gt 0 ] && [ "$1" != -- ]; do
    (cd "$dir" && $1) > /dev/null 2>&1 || { ok=; why="준비 실패: $1"; }
    shift
  done
  shift
  before=$(cd "$dir" && git status --porcelain; cat lib.sh lib2.sh old.sh 2> /dev/null)
  start=$SECONDS
  out=$(cd "$dir" && bash "$script" "$@" 2>&1)
  code=$?
  after=$(cd "$dir" && git status --porcelain; cat lib.sh lib2.sh old.sh 2> /dev/null)
  [ "$ok" ] && [ "$code" != "$want" ] && { ok=; why="종료 $code, 기대 $want"; }
  [ "$ok" ] && [ -n "$MAX_SECONDS" ] && [ $((SECONDS - start)) -gt "$MAX_SECONDS" ] && { ok=; why="$((SECONDS - start))초 걸림, 기대 $MAX_SECONDS초 안"; }
  if [ "$ok" ] && [ "$want_lines" != - ]; then
    IFS='|' read -ra ls <<< "$want_lines"
    for l in "${ls[@]}"; do printf '%s\n' "$out" | grep -qxF -- "$l" || { ok=; why="'$l' 줄 없음"; break; }; done
  fi
  [ "$ok" ] && [ "$before" != "$after" ] && { ok=; why="돌린 뒤 작업 트리가 달라졌다"; }
  if [ "$ok" ]; then
    pass=$((pass + 1)); echo "맞음: $name"
  else
    echo "틀림: $name ($why)"; printf '%s\n' "$out" | sed 's/^/    /'
  fi
}

(make_repo "$tmp/template") > /dev/null 2>&1 || { echo "가짜 저장소를 만들지 못했다"; exit 1; }

check "고친 것을 증명하는 테스트와 못 하는 테스트를 구별한다" 1 "기준에서 실패: test-add.sh|기준에서도 통과: test-echo.sh" \
  fix_add test_add test_echo commit -- main 'bash {}'
check "모두 기준에서 실패 → 0" 0 "기준에서 실패: test-add.sh" fix_add test_add commit -- main 'bash {}'
check "브랜치에서 더한 소스는 잠시 빼고 돌린다" 0 "기준에서 실패: test-mul.sh" new_source commit -- main 'bash {}'
check "브랜치에서 지운 소스는 돌린 뒤에도 없다" 0 "기준에서 실패: test-add.sh" fix_add test_add delete_old commit -- main 'bash {}'
check "테스트 폴더의 도우미는 HEAD 판 그대로" 1 "기준에서도 통과: tests/test-helper.sh" fix_add helper_test commit -- main 'bash {}'
check "루트의 test-utils 같은 도우미도 HEAD 판 그대로" 1 "기준에서도 통과: test-uses-helper.sh" fix_add root_helper commit -- main 'bash {}'
BASE_TESTS_KEEP='^support/' check "이름 규칙 밖의 도우미는 BASE_TESTS_KEEP 로 둔다" 1 "기준에서도 통과: test-render.sh" \
  fix_add support_helper commit -- main 'bash {}'
check "바뀐 파일이 많아 경로가 길어도 기준 판으로 바꾼다" 0 "기준에서 실패: test-add.sh" many_sources fix_add test_add commit -- main 'bash {}'
BASE_TESTS_TIMEOUT=3 MAX_SECONDS=30 check "기준에서 멈추는 테스트는 시간 제한으로 끊는다" 0 "기준에서 실패: test-slow.sh (3초 시간 초과)" \
  fix_add slow_test commit -- main 'bash {}'
check "HEAD 에서도 실패하는 테스트는 판단하지 않는다 → 2" 2 "HEAD 에서 실패: test-bad.sh|기준에서 실패: test-add.sh" \
  fix_add test_add test_bad commit -- main 'bash {}'
check "고를 테스트 파일을 인자로 준다" 1 "기준에서도 통과: test-echo.sh" fix_add test_add test_echo commit -- main 'bash {}' test-echo.sh
check "테스트만 바꾼 브랜치 → 건너뜀, 0" 0 "테스트 밖 변경 없음. 건너뛴다." test_echo commit -- main 'bash {}'
check "소스만 바뀌고 테스트를 못 찾음 → 판단 못 함, 2" 2 "바뀐 테스트 없음." fix_add commit -- main 'bash {}'
check "문서만 바뀌고 테스트 없음 → 0" 0 "문서만 바뀜. 건너뛴다." docs_only commit -- main 'bash {}'
check "__tests__/ 아래 파일을 테스트로 고른다" 0 "기준에서 실패: src/__tests__/login.js" fix_add jest_test commit -- main 'bash {}'
check "tests/ 아래 파일을 고르고 도우미·fixture 는 고르지 않는다" 0 "기준에서 실패: tests/login.js" fix_add dir_test commit -- main 'bash {}'
check "커밋하지 않은 변경 → 돌리지 않고 2" 2 - fix_add test_add commit dirty -- main 'bash {}'
check "명령에 {} 가 없음 → 사용법, 2" 2 - fix_add test_add commit -- main 'bash test-add.sh'
check "기준 브랜치 없음 → 2" 2 - fix_add test_add commit -- nope 'bash {}'

echo "$total 개 중 $pass 개 맞음"
[ "$pass" = "$total" ]
