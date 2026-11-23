#!/usr/bin/env bash
# 실제 계획 사례. 이 기계의 nolmeong 로컬 저장소에서 꺼내 만든다(nolmeong 에는 쓰지 않는다).
# 저장소는 013 시작 전(d8c75f5). 항목이 가리키는 저장소 밖 시안은 c32b56d 의 docs/design/002-sky-real/project 를 sky-prototype/ 로 둔다(커밋하지 않은 바깥 자료).
set -euo pipefail
SRC="C:/Users/user/Documents/jihoons/nolmeong"
[ -d "$SRC/.git" ] || { echo "nolmeong 로컬 저장소가 없다: $SRC" >&2; exit 1; }
git init -q -b main
git config user.name eval
git config user.email eval@example.invalid
git -C "$SRC" archive d8c75f5 | tar -x
git add -A && git commit -qm base
mkdir -p sky-prototype
git -C "$SRC" archive c32b56d docs/design/002-sky-real/project | tar -x --strip-components=4 -C sky-prototype
echo "sky-prototype/" >> .git/info/exclude
