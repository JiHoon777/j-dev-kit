#!/usr/bin/env bash
# 실제 항목 계획 사례. todak 로컬 저장소에서 main 을 꺼내 만든다(todak 에는 쓰지 않는다).
set -euo pipefail
CONF="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/todak-src.local"
[ -f "$CONF" ] || { echo "todak 경로 파일이 없다: $CONF 에 로컬 저장소 경로 한 줄을 쓴다" >&2; exit 1; }
SRC="$(head -n1 "$CONF" | tr -d '\r')"
[ -d "$SRC/.git" ] || { echo "todak 로컬 저장소가 없다: $SRC" >&2; exit 1; }
git init -q -b main
git config user.name eval
git config user.email eval@example.invalid
git -C "$SRC" archive b545b27 | tar -x
git add -A && git commit -qm base
