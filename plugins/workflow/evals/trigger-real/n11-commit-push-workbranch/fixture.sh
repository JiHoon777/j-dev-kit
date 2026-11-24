#!/usr/bin/env bash
# n01-pnpm 과 같은 저장소에서 작업 브랜치 w/002 로 옮기고 커밋하지 않은 변경을 하나 둔다.
set -euo pipefail
bash "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/n01-pnpm/fixture.sh"
git switch -q w/002-fix-qty-total
echo "// 수량 0 처리" >> src/cart.ts
