#!/usr/bin/env bash
# create-few 와 같은 합성 쇼핑몰 저장소.
set -euo pipefail
bash "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/create-few/fixture.sh"
