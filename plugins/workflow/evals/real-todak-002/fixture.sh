#!/usr/bin/env bash
# 실제 리뷰 사례. todak 로컬 저장소에서 커밋을 꺼내 만든다(todak 에는 쓰지 않는다).
# j-dev-kit 에는 todak 코드를 넣지 않으므로 그 저장소가 없는 기계에서는 이 사례가 돌지 않는다.
set -euo pipefail
# todak 경로는 커밋하지 않는 evals/todak-src.local 한 줄에 둔다. eval 은 scaffold 에 환경 변수를 넘기지 않는다.
CONF="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/todak-src.local"
[ -f "$CONF" ] || { echo "todak 경로 파일이 없다: $CONF 에 로컬 저장소 경로 한 줄을 쓴다" >&2; exit 1; }
SRC="$(head -n1 "$CONF" | tr -d '\r')"
[ -d "$SRC/.git" ] || { echo "todak 로컬 저장소가 없다: $SRC" >&2; exit 1; }
git init -q -b main
git config user.name eval
git config user.email eval@example.invalid
git -C "$SRC" archive ecc333d | tar -x
git add -A && git commit -qm base
git switch -q -c w/002-feat-read-published-cases-local
git rm -rq --cached . && git ls-files -o --exclude-standard -z | xargs -0 rm -f
git -C "$SRC" archive b902a6a | tar -x
git add -A && git commit -qm "리뷰 전 상태"
# 셸 도구가 없는 실행도 읽을 수 있게 diff 를 파일로 남긴다.
git diff main...HEAD -- . > review.diff
