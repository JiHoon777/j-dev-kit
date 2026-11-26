#!/usr/bin/env bash
# 저장소 규칙 검사. CLAUDE.md 의 검증 명령이 부른다.
# 1. plugins/ 의 마크다운마다 i18n/en/ 에 같은 경로의 번역본이 있다(plugins/*/evals/ 의 eval 사례는 뺀다).
# 2. marketplace.json 의 플러그인마다 plugin.json 과 설명이 같고, README 두 개의 목록에 있다.
# 5. 스킬·에이전트 마크다운(번역본 포함)에 셸 주입 줄(!`명령`)이 없다. Bash 가 막힌 곳에서 그 줄 하나가 스킬 호출 전체를 멈춘다.
# 7. 두 벌인 port_open(workflow 의 pick-port.sh, frontend 의 dev-server.sh)의 본문이 같다.
# 기준 브랜치(인자, 기본 main. 없으면 origin/<기준>) 대비:
# 3. 원문 마크다운을 고쳤으면 번역본도 고쳤다.
# 4. 바뀐 플러그인은 plugin.json 의 version 을 올렸다(내리지 않았다).
# 6. 바뀐 스크립트(plugins/ 의 .sh, evals 제외. 이 스크립트)의 짝 테스트 scripts/test-<이름>.sh 와
#    바뀐 짝 테스트를 돌려 통과한다. 짝이 없거나 시간 제한(CHECK_TESTS_TIMEOUT)을 넘으면 실패. 오래 걸리니 맨 마지막에 돈다.
# 저장소 루트에서 돈다. 어기면 이유를 적고 1로 끝난다.
# 이 스크립트를 고치면 6이 scripts/test-check-repo-rules.sh 를 돌린다.

base_branch=${1:-main}
git() { command git -c core.quotePath=false "$@"; } # 한글 경로를 그대로
cd "$(git rev-parse --show-toplevel)" || exit 1
fail=0
evals_re='^(i18n/en/)?plugins/[^/]+/evals/' # eval 사례는 원문 마크다운이 아니다

# 1. 번역본 짝 (추적하는 파일과 아직 추가하지 않은 파일. 지웠지만 스테이징하지 않은 파일은 뺀다)
while IFS= read -r f; do
  [ -f "$f" ] || continue
  [ -f "i18n/en/$f" ] && continue
  echo "번역본 없음: $f → i18n/en/$f"
  fail=1
done < <(git ls-files --cached --others --exclude-standard -- 'plugins/*.md' | grep -vE "$evals_re")

# 5. 셸 주입 줄
while IFS= read -r f; do
  [ -f "$f" ] && grep -qF '!`' "$f" || continue
  echo "셸 주입 줄: $f. 스킬을 불러올 때 셸을 돌리지 말고, 절차가 명령을 직접 돌리게 한다."
  fail=1
done < <(git ls-files --cached --others --exclude-standard -- 'plugins/*.md' 'i18n/en/plugins/*.md' | grep -vE "$evals_re")

# 2. marketplace.json 의 플러그인: 설명 일치와 README 목록
# JSON 은 한 줄에 키 하나라고 본다. "<키>": "<문자열>" 줄이 아닌 줄에서만 괄호를 세어 깊이를 안다.
kv_re='^[[:space:]]*"([^"]+)"[[:space:]]*:[[:space:]]*"(.*)",?[[:space:]]*$'
json_value() { # 표준 입력에서 처음 나온 키의 문자열 값
  local line
  while IFS= read -r line || [ -n "$line" ]; do
    [[ $line =~ $kv_re && ${BASH_REMATCH[1]} = "$1" ]] && { printf '%s' "${BASH_REMATCH[2]}"; return; }
  done
}
names=() depth=0 in_plugins=
while IFS= read -r line || [ -n "$line" ]; do
  if [[ $line =~ $kv_re ]]; then # 플러그인 항목 바로 아래(깊이 3)의 name·description 만
    [ "$in_plugins" ] && [ "$depth" = 3 ] || continue
    case ${BASH_REMATCH[1]} in name) name=${BASH_REMATCH[2]} ;; description) desc=${BASH_REMATCH[2]} ;; esac
    continue
  fi
  [ "$depth" = 1 ] && [[ $line =~ ^[[:space:]]*\"plugins\"[[:space:]]*: ]] && in_plugins=1
  open=${line//[^\{\[]/} close=${line//[^\}\]]/} prev=$depth
  depth=$((depth + ${#open} - ${#close}))
  [ "$in_plugins" ] || continue
  if [ "$prev" = 2 ] && [ "$depth" = 3 ]; then # 항목 시작
    name= desc=
  elif [ "$prev" = 3 ] && [ "$depth" = 2 ]; then # 항목 끝 (설명이 없으면 빈 값과 비교한다)
    names+=("$name")
    manifest="plugins/$name/.claude-plugin/plugin.json"
    if [ "$(json_value description 2>/dev/null < "$manifest")" != "$desc" ] || [ -z "$desc" ]; then
      echo "설명 다름: $name. $manifest 와 marketplace.json 의 description 을 맞춘다."
      fail=1
    fi
  elif [ "$depth" -lt 2 ]; then # plugins 배열 끝
    in_plugins=
  fi
done < .claude-plugin/marketplace.json
if [ "${#names[@]}" = 0 ]; then
  echo "marketplace.json 에서 플러그인을 읽지 못했다. 한 줄에 키 하나인 형식인지 본다."
  fail=1
fi
for readme in README.md README.en.md; do
  text=$'\n'$(< "$readme")
  for name in "${names[@]}"; do
    [[ $text == *$'\n'"| \`$name\` |"* ]] && continue # 표 줄의 첫 칸 (의존 칸은 아니다)
    echo "README 에 없음: $readme $name. 플러그인 표에 줄을 더한다."
    fail=1
  done
done

# 7. 두 벌인 port_open (플러그인은 따로 설치되니 한 파일로 합칠 수 없다)
port_files=(plugins/workflow/skills/start/scripts/pick-port.sh plugins/frontend/skills/frontend-start-check/scripts/dev-server.sh)
bodies=()
for f in "${port_files[@]}"; do
  body=$(sed -n '/^port_open() {$/,/^}$/p' "$f" 2>/dev/null)
  [ -n "$body" ] || { echo "port_open 을 찾지 못함: $f. 함수를 옮기거나 이름을 바꿨으면 이 검사도 맞춘다."; fail=1; }
  bodies+=("$body")
done
if [ -n "${bodies[0]}" ] && [ -n "${bodies[1]}" ] && [ "${bodies[0]}" != "${bodies[1]}" ]; then
  echo "port_open 다름: ${port_files[0]}, ${port_files[1]}. 두 함수를 같게 맞춘다."
  fail=1
fi

for ref in "$base_branch" "origin/$base_branch"; do
  base=$(git merge-base "$ref" HEAD 2>/dev/null) && break
done
if [ -z "$base" ]; then
  echo "기준 브랜치 '$base_branch' 를 찾지 못해 번역본 갱신, version, 짝 테스트 검사를 건너뛴다."
  exit "$fail"
fi

# 기준 대비 바뀐 파일: 커밋, 작업 폴더, 아직 추가하지 않은 파일.
# 이름 바꿈은 지우기와 더하기로 본다(옮긴 쪽 플러그인도 바뀐 것이다).
changed=$(
  { git diff --name-only --no-renames "$base" -- plugins/ i18n/en/plugins/ scripts/
    git ls-files --others --exclude-standard -- plugins/ i18n/en/plugins/ scripts/; } | sort -u
)

# 3. 원문을 고치면 번역본도 (지운 원문과 번역본이 없는 원문은 뺀다. 없는 것은 1이 알린다)
while IFS= read -r f; do
  [ -f "$f" ] && [ -f "i18n/en/$f" ] || continue
  printf '%s\n' "$changed" | grep -qxF "i18n/en/$f" && continue
  echo "번역본 그대로: $f 를 고쳤는데 i18n/en/$f 는 바뀌지 않았다."
  fail=1
done < <(printf '%s\n' "$changed" | grep -E '^plugins/.*\.md$' | grep -vE "$evals_re")

# 4. version 올리기
for p in $(printf '%s\n' "$changed" | grep '^plugins/' | cut -d/ -f2 | sort -u); do
  manifest="plugins/$p/.claude-plugin/plugin.json"
  [ -f "$manifest" ] || continue # 지운 플러그인
  old_manifest=$(git show "$base:$manifest" 2>/dev/null) || continue # 기준에 없던 플러그인
  old=$(json_value version <<< "$old_manifest")
  new=$(json_value version < "$manifest")
  if [ -z "$old" ] || [ -z "$new" ]; then
    echo "version 을 읽지 못함: $p. 기준과 지금의 $manifest 가 한 줄에 키 하나인 형식인지 본다."
    fail=1
  elif [ "$old" = "$new" ]; then
    echo "version 그대로: $p ($old). $manifest 의 version 을 올린다."
    fail=1
  elif [ "$(printf '%s\n%s\n' "$old" "$new" | sort -V | head -n 1)" = "$new" ]; then
    echo "version 내림: $p ($old → $new). $manifest 의 version 을 $old 보다 올린다."
    fail=1
  fi
done

# 6. 바뀐 스크립트의 짝 테스트 (지운 파일은 뺀다. 같은 테스트는 한 번만)
# 테스트 하나는 CHECK_TESTS_TIMEOUT 초(기본 540)가 지나면 끊는다. Stop 훅의 기본 시간 제한(600초)보다 짧게 두어
# 멈춘 테스트가 훅째 취소되지 않고 실패로 남게 한다. timeout 명령이 없으면(macOS 기본) 끊지 않는다.
limit=${CHECK_TESTS_TIMEOUT:-540}
tmo=$(command -v timeout || command -v gtimeout)
ran=' '
while IFS= read -r f; do
  [ -f "$f" ] || continue
  case $f in
    scripts/test-*.sh) t=$f ;;
    scripts/check-repo-rules.sh | plugins/*.sh) t="scripts/test-$(basename "$f" .sh).sh" ;;
    *) continue ;;
  esac
  if [ ! -f "$t" ]; then
    echo "짝 테스트 없음: $f. $t 를 만든다."
    fail=1
    continue
  fi
  [[ $ran == *" $t "* ]] && continue
  ran+="$t "
  # 표준 입력은 막는다. 테스트가 읽으면 이 루프의 남은 목록을 먹는다
  if [ -n "$tmo" ]; then t_out=$("$tmo" -k 5 "$limit" bash "$t" 2>&1 < /dev/null); else t_out=$(bash "$t" 2>&1 < /dev/null); fi
  rc=$?
  if [ "$rc" = 0 ]; then
    echo "테스트 통과: $t"
  else # Stop 훅은 마지막 40줄만 보여 주니 요약 줄을 맨 뒤에
    printf '%s\n' "$t_out" | tail -n 20 | sed 's/^/    /'
    late=
    [ "$rc" = 124 ] && [ -n "$tmo" ] && late="(${limit}초 시간 초과)"
    echo "테스트 실패$late: $t ($f 가 바뀜)"
    fail=1
  fi
done < <(printf '%s\n' "$changed" | grep -vE "$evals_re")

[ "$fail" = 0 ] && echo "저장소 규칙 검사 통과"
exit "$fail"
