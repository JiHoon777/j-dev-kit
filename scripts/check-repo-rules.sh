#!/usr/bin/env bash
# 저장소 규칙 검사. CLAUDE.md 의 검증 명령이 부른다.
# 1. plugins/ 의 마크다운마다 i18n/en/ 에 같은 경로의 번역본이 있다.
# 2. marketplace.json 의 플러그인마다 plugin.json 과 설명이 같고, README 두 개의 목록에 있다.
# 기준 브랜치(인자, 기본 main. 없으면 origin/<기준>) 대비:
# 3. 원문 마크다운을 고쳤으면 번역본도 고쳤다.
# 4. 바뀐 플러그인은 plugin.json 의 version 을 올렸다(내리지 않았다).
# 저장소 루트에서 돈다. 어기면 이유를 적고 1로 끝난다.
# 이 스크립트를 고치면 scripts/test-check-repo-rules.sh 를 돌린다.

base_branch=${1:-main}
git() { command git -c core.quotePath=false "$@"; } # 한글 경로를 그대로
cd "$(git rev-parse --show-toplevel)" || exit 1
fail=0

# 1. 번역본 짝 (추적하는 파일과 아직 추가하지 않은 파일. 지웠지만 스테이징하지 않은 파일은 뺀다)
while IFS= read -r f; do
  [ -f "$f" ] || continue
  [ -f "i18n/en/$f" ] && continue
  echo "번역본 없음: $f → i18n/en/$f"
  fail=1
done < <(git ls-files --cached --others --exclude-standard -- 'plugins/*.md')

# 2. marketplace.json 의 플러그인: 설명 일치와 README 목록 (JSON 은 한 줄에 키 하나라고 본다)
json_string() { # 줄에서 "<키>": "<값>" 의 값
  sed -nE "s/^[[:space:]]*\"$1\"[[:space:]]*:[[:space:]]*\"(.*)\",?[[:space:]]*$/\1/p"
}
listed=0
while IFS=$'\t' read -r name desc; do
  listed=$((listed + 1))
  manifest="plugins/$name/.claude-plugin/plugin.json"
  own=$(json_string description 2>/dev/null < "$manifest" | head -n 1)
  if [ "$own" != "$desc" ]; then
    echo "설명 다름: $name. $manifest 와 marketplace.json 의 description 을 맞춘다."
    fail=1
  fi
  for readme in README.md README.en.md; do
    grep -qF "| \`$name\` |" "$readme" && continue
    echo "README 에 없음: $readme $name. 플러그인 표에 줄을 더한다."
    fail=1
  done
done < <(
  sed -n '/"plugins"[[:space:]]*:/,$p' .claude-plugin/marketplace.json | awk '
    /^[[:space:]]*"name"[[:space:]]*:/        { name = $0; sub(/^[^:]*:[[:space:]]*"/, "", name); sub(/",?[[:space:]]*$/, "", name) }
    /^[[:space:]]*"description"[[:space:]]*:/ { d = $0; sub(/^[^:]*:[[:space:]]*"/, "", d); sub(/",?[[:space:]]*$/, "", d); print name "\t" d }'
)
if [ "$listed" = 0 ]; then
  echo "marketplace.json 에서 플러그인을 읽지 못했다. 한 줄에 키 하나인 형식인지 본다."
  fail=1
fi

for ref in "$base_branch" "origin/$base_branch"; do
  base=$(git merge-base "$ref" HEAD 2>/dev/null) && break
done
if [ -z "$base" ]; then
  echo "기준 브랜치 '$base_branch' 를 찾지 못해 번역본 갱신과 version 검사를 건너뛴다."
  exit "$fail"
fi

# 기준 대비 바뀐 파일: 커밋, 작업 폴더, 아직 추가하지 않은 파일.
# 이름 바꿈은 지우기와 더하기로 본다(옮긴 쪽 플러그인도 바뀐 것이다).
changed=$(
  { git diff --name-only --no-renames "$base" -- plugins/ i18n/en/plugins/
    git ls-files --others --exclude-standard -- plugins/ i18n/en/plugins/; } | sort -u
)

# 3. 원문을 고치면 번역본도 (지운 원문과 번역본이 없는 원문은 뺀다. 없는 것은 1이 알린다)
while IFS= read -r f; do
  [ -f "$f" ] && [ -f "i18n/en/$f" ] || continue
  printf '%s\n' "$changed" | grep -qxF "i18n/en/$f" && continue
  echo "번역본 그대로: $f 를 고쳤는데 i18n/en/$f 는 바뀌지 않았다."
  fail=1
done < <(printf '%s\n' "$changed" | grep -E '^plugins/.*\.md$')

# 4. version 올리기
version_of() { json_string version | head -n 1; }
for p in $(printf '%s\n' "$changed" | grep '^plugins/' | cut -d/ -f2 | sort -u); do
  manifest="plugins/$p/.claude-plugin/plugin.json"
  [ -f "$manifest" ] || continue # 지운 플러그인
  old=$(git show "$base:$manifest" 2>/dev/null | version_of)
  [ -n "$old" ] || continue # 기준에 없던 플러그인
  new=$(version_of < "$manifest")
  if [ "$old" = "$new" ]; then
    echo "version 그대로: $p ($old). $manifest 의 version 을 올린다."
    fail=1
  elif [ "$(printf '%s\n%s\n' "$old" "$new" | sort -V | head -n 1)" = "$new" ]; then
    echo "version 내림: $p ($old → $new). $manifest 의 version 을 $old 보다 올린다."
    fail=1
  fi
done

[ "$fail" = 0 ] && echo "저장소 규칙 검사 통과"
exit "$fail"
