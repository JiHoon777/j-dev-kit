#!/usr/bin/env bash
# n01-pnpm 과 같은 저장소(main 에서).
set -euo pipefail
bash "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/n01-pnpm/fixture.sh"
