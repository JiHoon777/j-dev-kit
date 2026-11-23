#!/usr/bin/env bash
# 실제 계획 사례. nolmeong 로컬 저장소에서 꺼내 만든다(nolmeong 에는 쓰지 않는다).
# 저장소는 013 시작 전(d8c75f5). 항목이 가리키는 저장소 밖 시안은 c32b56d 의 docs/design/002-sky-real/project 를 sky-prototype/ 로 둔다(커밋하지 않은 바깥 자료).
set -euo pipefail
# nolmeong 경로는 커밋하지 않는 evals/nolmeong-src.local 한 줄에 둔다. eval 은 scaffold 에 환경 변수를 넘기지 않는다.
CONF="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/nolmeong-src.local"
[ -f "$CONF" ] || { echo "nolmeong 경로 파일이 없다: $CONF 에 로컬 저장소 경로 한 줄을 쓴다" >&2; exit 1; }
SRC="$(head -n1 "$CONF" | tr -d '\r')"
[ -d "$SRC/.git" ] || { echo "nolmeong 로컬 저장소가 없다: $SRC" >&2; exit 1; }
git init -q -b main
git config user.name eval
git config user.email eval@example.invalid
git -C "$SRC" archive d8c75f5 | tar -x
git add -A && git commit -qm base
mkdir -p sky-prototype
git -C "$SRC" archive c32b56d docs/design/002-sky-real/project | tar -x --strip-components=4 -C sky-prototype
echo "sky-prototype/" >> .git/info/exclude
