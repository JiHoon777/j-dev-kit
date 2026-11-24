#!/usr/bin/env bash
# 이 브랜치의 테스트가 고친 것을 증명하는지: bash base-tests.sh <기준 브랜치> '<테스트 파일 하나를 돌리는 명령>' [테스트 파일…]
# 명령의 {} 자리에 테스트 파일 경로가 들어간다(예: 'pnpm vitest run {}', 'pytest {}', 'bash {}').
# 테스트 파일을 주지 않으면 <기준>...HEAD 에서 더하거나 바꾼 테스트 파일을 이름으로 고른다
# (*.test.*, *.spec.*, *_test.*, *-test.*, test_*.py, test-*.sh, *_spec.rb).
# 1. 테스트를 HEAD 그대로 돌린다. 여기서 실패하면 "HEAD 에서 실패"로 적고 판단하지 않는다.
# 2. 테스트 밖의 바뀐 파일만 기준 판으로 잠시 되돌리고(브랜치에서 더한 파일은 뺀다) 다시 돌린다.
#    테스트 쪽 파일(tests/, __tests__/, spec/ 폴더와 위 이름)은 HEAD 판 그대로 둔다.
#    "기준에서 실패"는 고친 것을 증명한다. "기준에서도 통과"는 증명하지 못한다.
# 3. 끝나면(중단돼도) 작업 트리를 HEAD 로 되돌린다.
# 끝 값: 0 모두 기준에서 실패(또는 볼 것 없음), 1 기준에서도 통과한 테스트가 있음, 2 판단 못 함(돌릴 수 없음, HEAD 에서 실패).
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
test_re="(^|/)(tests?|__tests__|spec)/|$run_re"

changed=$(git diff --name-status --no-renames "$base" HEAD)
targets=()
if [ "$#" -gt 0 ]; then
  targets=("$@")
else
  while IFS=$'\t' read -r st f; do
    [ "$st" != D ] && [[ $f =~ $run_re ]] && targets+=("$f")
  done <<< "$changed"
fi
[ "${#targets[@]}" -gt 0 ] || { echo "바뀐 테스트 없음."; exit 0; }

sources=()
while IFS=$'\t' read -r st f; do
  [ -n "$f" ] || continue
  [[ $f =~ $test_re ]] && continue
  printf '%s\n' "${targets[@]}" | grep -qxF -- "$f" && continue
  sources+=("$f")
done <<< "$changed"
[ "${#sources[@]}" -gt 0 ] || { echo "테스트 밖 변경 없음. 건너뛴다."; exit 0; }

run_one() { bash -c "${cmd//\{\}/$(printf '%q' "$1")}" > /dev/null 2>&1 < /dev/null; }

unknown=0 ok=()
for f in "${targets[@]}"; do
  if run_one "$f"; then ok+=("$f"); else echo "HEAD 에서 실패: $f"; unknown=1; fi
done
[ "${#ok[@]}" -gt 0 ] || exit 2

# 되돌릴 때는 git checkout 대신 떠 둔 사본을 쓴다. checkout 은 줄 끝(core.autocrlf)을 바꿔 쓸 수 있다
backup=$(mktemp -d)
for f in "${sources[@]}"; do
  [ -e "$f" ] && mkdir -p "$backup/$(dirname "$f")" && cp -p -- "$f" "$backup/$f"
done
restore() {
  for f in "${sources[@]}"; do
    if [ -e "$backup/$f" ]; then mkdir -p "$(dirname "$f")" && cp -p -- "$backup/$f" "$f"; else rm -f -- "$f"; fi
  done
  git reset -q HEAD -- "${sources[@]}" 2> /dev/null
  rm -rf "$backup"
}
trap restore EXIT
trap 'exit 2' INT TERM
for f in "${sources[@]}"; do
  if git cat-file -e "$base:$f" 2> /dev/null; then git checkout -q "$base" -- "$f"; else rm -f -- "$f"; fi
done

passed=0
for f in "${ok[@]}"; do
  if run_one "$f"; then echo "기준에서도 통과: $f"; passed=1; else echo "기준에서 실패: $f"; fi
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
