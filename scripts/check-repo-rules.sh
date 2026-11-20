#!/usr/bin/env bash
# 저장소 규칙 검사. CLAUDE.md 의 검증 명령이 부른다.
# 1. plugins/ 의 마크다운마다 i18n/en/ 에 같은 경로의 번역본이 있다.
# 기준 브랜치(인자, 기본 main) 대비:
# 2. 원문 마크다운을 고쳤으면 번역본도 고쳤다.
# 3. 바뀐 플러그인은 plugin.json 의 version 을 올렸다.
# 저장소 루트에서 돌린다. 어기면 이유를 적고 1로 끝난다.

base_branch=${1:-main}
cd "$(git rev-parse --show-toplevel)" || exit 1
fail=0

# 1. 번역본 짝 (추적하는 파일과 아직 추가하지 않은 파일)
while IFS= read -r f; do
  [ -f "i18n/en/$f" ] && continue
  echo "번역본 없음: $f → i18n/en/$f"
  fail=1
done < <(git ls-files --cached --others --exclude-standard -- 'plugins/*.md')

if ! base=$(git merge-base "$base_branch" HEAD 2>/dev/null); then
  echo "기준 브랜치 '$base_branch' 를 찾지 못해 번역본 갱신과 version 검사를 건너뛴다."
  exit "$fail"
fi

# 기준 대비 바뀐 파일: 커밋, 작업 폴더, 아직 추가하지 않은 파일.
# 이름 바꿈은 지우기와 더하기로 본다(옮긴 쪽 플러그인도 바뀐 것이다).
changed=$(
  { git diff --name-only --no-renames "$base" -- plugins/ i18n/en/plugins/
    git ls-files --others --exclude-standard -- plugins/ i18n/en/plugins/; } | sort -u
)

# 2. 원문을 고치면 번역본도 (지운 원문과 번역본이 없는 원문은 뺀다. 없는 것은 1이 알린다)
while IFS= read -r f; do
  [ -f "$f" ] && [ -f "i18n/en/$f" ] || continue
  printf '%s\n' "$changed" | grep -qxF "i18n/en/$f" && continue
  echo "번역본 그대로: $f 를 고쳤는데 i18n/en/$f 는 바뀌지 않았다."
  fail=1
done < <(printf '%s\n' "$changed" | grep -E '^plugins/.*\.md$')

# 3. version 올리기
version_of() { # 표준 입력의 plugin.json 에서 version 값
  sed -nE '/"version"/{s/.*"version"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/p;q;}'
}
for p in $(printf '%s\n' "$changed" | grep '^plugins/' | cut -d/ -f2 | sort -u); do
  manifest="plugins/$p/.claude-plugin/plugin.json"
  old=$(git show "$base:$manifest" 2>/dev/null | version_of)
  [ -n "$old" ] || continue # 기준에 없던 플러그인
  new=$(version_of 2>/dev/null < "$manifest")
  if [ "$old" = "$new" ]; then
    echo "version 그대로: $p ($old). $manifest 의 version 을 올린다."
    fail=1
  fi
done

[ "$fail" = 0 ] && echo "저장소 규칙 검사 통과"
exit "$fail"
