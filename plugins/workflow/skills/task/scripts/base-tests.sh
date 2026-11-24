#!/usr/bin/env bash
# 이 브랜치의 테스트가 고친 것을 증명하는지: bash base-tests.sh <기준 브랜치> '<테스트 파일 하나를 돌리는 명령>' [테스트 파일…]
# 명령의 {} 자리에 테스트 파일 경로가 들어간다(예: 'pnpm vitest run {}', 'pytest {}', 'bash {}').
# 테스트 파일을 주지 않으면 <기준>...HEAD 에서 더하거나 바꾼 테스트 파일을 이름으로 고른다
# (*.test.*, *.spec.*, *_test.*, *-test.*, test_*.py, test-*.sh, *_spec.rb, 그리고 __tests__/·tests/·test/ 아래의 JS·TS 파일.
#  그 폴더 아래의 fixtures·helpers·utils·mocks·support·testdata 폴더, tests/·test/ 아래의 pages·factories·types 폴더와 constants.*,
#  _로 시작하거나 setup·helper·util·fixture 가 든 이름, 타입 선언 *.d.ts 는 도우미로 본다).
# 고른 테스트가 없으면: 테스트 밖 파일(문서 *.md 빼고)이 바뀌었으면 "바뀐 테스트 없음."을 쓰고 2(판단 못 함), 문서만 바뀌었으면 0.
# 1. 테스트를 HEAD 그대로 돌린다. 여기서 실패하면 "HEAD 에서 실패"로 적고 판단하지 않는다.
# 2. 테스트 밖의 바뀐 파일만 기준 판으로 잠시 되돌리고(브랜치에서 더한 파일은 뺀다) 다시 돌린다.
#    테스트 쪽 파일은 HEAD 판 그대로 둔다: 위 이름, tests/·__tests__/·spec/·fixtures/·testdata/·mocks/ 폴더,
#    conftest.py·pytest.ini·setupTests.*·*.setup.*·(vitest|jest|playwright|cypress|karma).config.*·.mocharc*, test_utils·test-helpers 같은 이름.
#    이름 규칙 밖의 도우미는 BASE_TESTS_KEEP(경로 정규식, 예: '^src/testing/')로 더한다.
#    테스트 하나는 BASE_TESTS_TIMEOUT 초(기본 600)가 지나면 끊는다(timeout 명령이 있을 때). 기준에서 끊긴 테스트는 기준에서 실패다.
#    "기준에서 실패"는 고친 것을 증명한다. "기준에서도 통과"는 증명하지 못한다.
# 3. 끝나면(중단돼도) 작업 트리를 HEAD 로 되돌린다.
# 끝 값: 0 모두 기준에서 실패(또는 볼 것 없음), 1 기준에서도 통과한 테스트가 있음, 2 판단 못 함(돌릴 수 없음, HEAD 에서 실패, 소스가 바뀌었는데 테스트를 못 찾음).
# 파일을 잠시 바꾸니 같은 폴더에서 다른 일(리뷰 에이전트 등)이 돌지 않을 때 돌린다. 커밋하지 않은 변경이 있으면 돌리지 않는다.
# 저장소 루트에서 돈다. 이 스크립트를 고치면 scripts/test-base-tests.sh 를 돌린다.

usage() { echo "사용법: bash base-tests.sh <기준 브랜치> '<테스트 파일 하나를 돌리는 명령, 파일 자리에 {}>' [테스트 파일…]" >&2; exit 2; }
[ "$#" -ge 2 ] || usage
[[ $2 == *"{}"* ]] || usage
ref=$1 cmd=$2
shift 2
git() { command git -c core.quotePath=false "$@"; }
cd "$(git rev-parse --show-toplevel)" || exit 2
base=
for r in "$ref" "origin/$ref"; do base=$(git merge-base "$r" HEAD 2> /dev/null) && break; done
[ -n "$base" ] || { echo "기준 브랜치 '$ref' 를 찾지 못했다." >&2; exit 2; }
[ -z "$(git status --porcelain)" ] || { echo "커밋하지 않은 변경이 있어 돌리지 않았다. 커밋한 뒤 돌린다." >&2; exit 2; }

run_re='(^|/)[^/]*[._-](test|spec)\.[^/]+$|(^|/)test_[^/]*\.py$|(^|/)test-[^/]*\.sh$|_spec\.rb$'
aux_dirs='fixtures?|__fixtures__|testdata|mocks?|__mocks__' # 테스트 쪽 도우미 폴더
dir_re='(^|/)(__tests__|tests?)/([^/]+/)*[^/]+\.[cm]?[jt]sx?$'
helper_re="(^|/)(__tests__|tests?)/([^/]+/)*($aux_dirs|helpers?|utils?|support)/|(^|/)tests?/([^/]+/)*((pages?|factories|types)/|constants?\.[^/]+$)|(^|/)_[^/]*\$|(^|/)[^/]*(setup|helper|util|fixture)[^/]*\$|\.d\.[cm]?ts\$" # 도우미 폴더는 테스트 폴더 아래일 때만
is_test() { [[ $1 =~ $run_re ]] || { [[ $1 =~ $dir_re ]] && ! [[ $1 =~ $helper_re ]]; }; }
test_re="(^|/)(tests?|__tests__|spec|$aux_dirs)/|$run_re"
test_re+='|(^|/)(conftest\.py|pytest\.ini|setupTests\.[^/]+|[^/]*\.setup\.[^/]+|(vitest|jest|playwright|cypress|karma)\.config\.[^/]+|\.mocharc[^/]*)$'
test_re+='|(^|/)test[-_](utils?|helpers?|support)[^/]*$'
[ -n "$BASE_TESTS_KEEP" ] && test_re+="|$BASE_TESTS_KEEP"

changed=$(git diff --name-status --no-renames "$base" HEAD)
targets=()
if [ "$#" -gt 0 ]; then
  targets=("$@")
else
  while IFS=$'\t' read -r st f; do
    [ "$st" != D ] && is_test "$f" && targets+=("$f")
  done <<< "$changed"
fi
sources=() added=() in_base=()
nl=$'\n'
tlist=$nl$(printf '%s\n' "${targets[@]}")$nl
while IFS=$'\t' read -r st f; do
  [ -n "$f" ] || continue
  [[ $f =~ $test_re || $tlist == *"$nl$f$nl"* ]] && continue
  sources+=("$f")
  if [ "$st" = A ]; then added+=("$f"); else in_base+=("$f"); fi
done <<< "$changed"
[ "${#sources[@]}" -gt 0 ] || { echo "테스트 밖 변경 없음. 건너뛴다."; exit 0; }
if [ "${#targets[@]}" = 0 ]; then # 볼 테스트가 없는 것을 통과로 두지 않는다(문서만 바뀌었으면 볼 것이 없다)
  for f in "${sources[@]}"; do [[ $f == *.md ]] || { echo "바뀐 테스트 없음."; exit 2; }; done
  echo "문서만 바뀜. 건너뛴다."; exit 0
fi

limit=${BASE_TESTS_TIMEOUT:-600}
tmo=$(command -v timeout || command -v gtimeout) # macOS 에는 기본으로 없다. 없으면 끊지 않는다
run_one() { # 끝 값 124 는 시간 초과
  local c=${cmd//\{\}/$(printf '%q' "$1")}
  if [ -n "$tmo" ]; then "$tmo" -k 5 "$limit" bash -c "$c"; else bash -c "$c"; fi > /dev/null 2>&1 < /dev/null
}
late() { [ "$1" = 124 ] && [ -n "$tmo" ] && echo " (${limit}초 시간 초과)"; }

unknown=0 ok=()
for f in "${targets[@]}"; do
  run_one "$f"
  rc=$?
  if [ "$rc" = 0 ]; then ok+=("$f"); else echo "HEAD 에서 실패: $f$(late "$rc")"; unknown=1; fi
done
[ "${#ok[@]}" -gt 0 ] || exit 2

# 되돌릴 때는 git 대신 떠 둔 사본을 쓴다. git 은 줄 끝(core.autocrlf)을 바꿔 쓸 수 있다
backup=$(mktemp -d)
for f in "${sources[@]}"; do
  [ -e "$f" ] || continue
  { [[ $f != */* ]] || mkdir -p "$backup/${f%/*}"; } && cp -p -- "$f" "$backup/$f" ||
    { rm -rf "$backup"; echo "사본을 뜨지 못해 돌리지 않았다: $f" >&2; exit 2; }
done
restore() {
  for f in "${sources[@]}"; do
    if [ -e "$backup/$f" ]; then
      [[ $f == */* ]] && mkdir -p "${f%/*}"
      cp -p -- "$backup/$f" "$f"
    else
      rm -f -- "$f"
    fi
  done
  rm -rf "$backup"
}
trap restore EXIT
trap 'exit 2' INT TERM
# 작업 트리만 기준 판으로 바꾼다(인덱스는 그대로). 브랜치에서 더한 파일은 뺀다.
# 경로는 인자 대신 표준 입력으로 넘긴다. 바뀐 파일이 많으면 Windows 명령줄 한도(32K자)를 넘는다.
# 하나라도 실패하면 반쯤 바꾼 트리로 판정하지 않고 되돌린 뒤 2로 끝낸다
switch_failed() { echo "기준 판으로 바꾸지 못해 판정하지 않았다: $1" >&2; exit 2; }
if [ "${#added[@]}" -gt 0 ]; then rm -f -- "${added[@]}" || switch_failed "더한 파일 빼기"; fi
if [ "${#in_base[@]}" -gt 0 ]; then
  printf '%s\0' "${in_base[@]}" |
    git --literal-pathspecs restore -q --source="$base" --worktree --pathspec-from-file=- --pathspec-file-nul ||
    switch_failed "git restore"
fi

passed=0
for f in "${ok[@]}"; do
  run_one "$f"
  rc=$?
  if [ "$rc" = 0 ]; then echo "기준에서도 통과: $f"; passed=1; else echo "기준에서 실패: $f$(late "$rc")"; fi
done

restore
trap - EXIT
if [ -n "$(git status --porcelain)" ]; then
  echo "작업 트리를 HEAD 로 되돌리지 못했다. git status 를 본다." >&2
  exit 2
fi
[ "$passed" = 1 ] && exit 1
[ "$unknown" = 1 ] && exit 2
exit 0
