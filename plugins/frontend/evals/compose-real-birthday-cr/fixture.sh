#!/usr/bin/env bash
# 실제 리뷰 실패 사례. 이 기계의 nolmeong 로컬 저장소에서 커밋을 꺼내 만든다(nolmeong 에는 쓰지 않는다).
# j-dev-kit 에는 nolmeong 코드를 넣지 않으므로 그 저장소가 없는 기계에서는 이 사례가 돌지 않는다.
set -euo pipefail
SRC="C:/Users/user/Documents/jihoons/nolmeong"
[ -d "$SRC/.git" ] || { echo "nolmeong 로컬 저장소가 없다: $SRC" >&2; exit 1; }
git init -q -b main
git config user.name eval
git config user.email eval@example.invalid
git -C "$SRC" archive ae9f422^ | tar -x
git add -A && git commit -qm base
git switch -q -c w/012-birthday-port-prototype
git rm -rq --cached . && git ls-files -o --exclude-standard -z | xargs -0 rm -f
git -C "$SRC" archive e7b45fd | tar -x
git add -A && git commit -qm "리뷰 전 상태"
# 셸 도구가 없는 실행도 읽을 수 있게 diff 를 파일로 남긴다.
git diff main...HEAD -- . > review.diff
