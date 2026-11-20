#!/usr/bin/env bash
# 저장소 규칙 검사. CLAUDE.md 의 검증 명령이 부른다.
# 1. plugins/ 의 마크다운마다 i18n/en/ 에 같은 경로의 번역본이 있다.
# 2. 기준 브랜치(인자, 기본 main) 대비 바뀐 플러그인은 plugin.json 의 version 을 올렸다.
# 저장소 루트에서 돌린다. 어기면 이유를 적고 1로 끝난다.

base_branch=${1:-main}
cd "$(git rev-parse --show-toplevel)" || exit 1
fail=0

# 1. 번역본 짝 (추적하는 파일과 아직 추가하지 않은 파일)
while IFS= read -r f; do
  [ -f "i18n/en/$f" ] && continue
  echo "번역본 없음: $f → i18n/en/$f"
  fail=1
done < <(git ls-files --cached --others --exclude-standard -- 'plugins/*.md' | sort -u)

# 2. version 올리기 (기준과 지금 작업 폴더를 비교한다)
version_of() { # 내용이 들어오면 version 값
  grep -m1 '"version"' | sed -E 's/.*"version"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/'
}
if base=$(git merge-base "$base_branch" HEAD 2>/dev/null); then
  changed=$(
    { git diff --name-only "$base" -- plugins/
      git ls-files --others --exclude-standard -- plugins/; } | cut -d/ -f2 | sort -u
  )
  for p in $changed; do
    manifest="plugins/$p/.claude-plugin/plugin.json"
    old=$(git show "$base:$manifest" 2>/dev/null | version_of)
    [ -n "$old" ] || continue # 기준에 없던 플러그인
    new=$(version_of < "$manifest" 2>/dev/null)
    if [ "$old" = "$new" ]; then
      echo "version 그대로: $p ($old). $manifest 의 version 을 올린다."
      fail=1
    fi
  done
else
  echo "기준 브랜치 '$base_branch' 를 찾지 못해 version 검사를 건너뛴다."
fi

[ "$fail" = 0 ] && echo "저장소 규칙 검사 통과"
exit "$fail"
