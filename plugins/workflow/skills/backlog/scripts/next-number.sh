#!/usr/bin/env bash
# 새 백로그 항목의 번호를 찍는다: bash next-number.sh
# 지금 폴더의 docs/backlog·docs/done 과, 모든 브랜치(로컬과 이미 가져온 원격)의 같은 두 폴더에서
# 가장 큰 항목 번호(파일 이름 맨 앞 세 자리)를 찾아 + 1 을 세 자리로 쓴다. 항목이 없으면 001.
# 브랜치는 체크아웃하지 않고 읽는다.
# git 저장소가 아니거나 브랜치를 읽을 수 없으면 지금 폴더만 보고 센다. 멈추지 않는다.
# 저장소 안이면 어느 폴더에서 돌려도 저장소 루트 기준으로 센다. 저장소가 아니면 지금 폴더 기준이다.
# 이 스크립트를 고치면 scripts/test-next-number.sh 를 돌린다.

root=$(git rev-parse --show-toplevel 2> /dev/null) && cd "$root" || root=
names=$(ls docs/backlog docs/done 2> /dev/null)
if [ -n "$root" ]; then
  while IFS= read -r ref; do
    names+=$'\n'$(git -c core.quotePath=false ls-tree --name-only "$ref" docs/backlog/ docs/done/ 2> /dev/null)
  done < <(git for-each-ref --format='%(refname)' refs/heads refs/remotes 2> /dev/null)
fi
max=$(printf '%s\n' "$names" | sed -nE 's|^(.*/)?([0-9]{3})-[^/]*\.md$|\2|p' | sort -n | tail -1)
printf '%03d\n' $((10#${max:-0} + 1))
