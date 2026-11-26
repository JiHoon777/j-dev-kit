#!/usr/bin/env bash
# supabase-seeded 와 같은 합성 코드를 만든다.
set -euo pipefail
bash "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/supabase-seeded/fixture.sh"
