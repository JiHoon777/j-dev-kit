#!/usr/bin/env bash
# check-repo-rules.sh 의 시나리오 테스트. `bash scripts/test-check-repo-rules.sh`
# 임시 폴더에 작은 가짜 저장소를 만들어 clone 해 두고, 시나리오마다 그것을 복사해 검사 스크립트를 돌린다.
# 실제 플러그인 내용에 기대지 않는다. 하나라도 틀리면 1로 끝난다.

check="$(cd "$(dirname "$0")" && pwd)/check-repo-rules.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com
export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com
export GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.autocrlf GIT_CONFIG_VALUE_0=false # 줄 끝 경고 끄기
export CHECK_TESTS_TIMEOUT=3 # 가짜 짝 테스트는 바로 끝난다. 시간 초과 시나리오만 이것에 걸린다
# sed -i 는 GNU 와 BSD(macOS)가 다르다. 백업 접미사를 붙이면 둘 다 받으니, 그렇게 돌리고 백업을 지운다. 파일은 마지막 인자 하나다.
sed() { if [ "$1" = -i ]; then shift; command sed -i.bak "$@" && rm -f "${!#}.bak"; else command sed "$@"; fi; }

# 가짜 저장소: alpha·beta 는 marketplace 와 README 에 있고, gamma 는 없다.
plugin() { # 이름
  mkdir -p "plugins/$1/.claude-plugin" "plugins/$1/skills" "i18n/en/plugins/$1/skills"
  cat > "plugins/$1/.claude-plugin/plugin.json" <<EOF
{
  "name": "$1",
  "description": "$1 plugin",
  "version": "0.1.0",
  "author": {
    "name": "owner"
  }
}
EOF
  echo "# $1" > "plugins/$1/skills/a.md"
  echo "# $1 en" > "i18n/en/plugins/$1/skills/a.md"
}
pick_port=plugins/workflow/skills/start/scripts/pick-port.sh
dev_server=plugins/frontend/skills/frontend-start-check/scripts/dev-server.sh
port_fn() { # 위 주석 줄. 실제처럼 주석은 다르고 본문은 같다
  printf '%s\nport_open() {\n  local p=$1\n  return 2\n}\n\nport_open 1\n' "$1"
}
scripts_fixture() { # 스크립트와 짝 테스트 (가짜 테스트는 실제 테스트를 부르지 않는다)
  mkdir -p plugins/alpha/scripts scripts "${pick_port%/*}" "${dev_server%/*}"
  echo 'exit 0' > plugins/alpha/scripts/tool.sh
  echo 'bash plugins/alpha/scripts/tool.sh' > scripts/test-tool.sh
  port_fn '# workflow 쪽' > "$pick_port"
  port_fn '# frontend 쪽' > "$dev_server"
  echo '# 가짜 검사' > scripts/check-repo-rules.sh
  for t in pick-port dev-server check-repo-rules; do echo 'exit 0' > "scripts/test-$t.sh"; done
}
make_fixture() {
  git init -q -b main "$tmp/fixture" && cd "$tmp/fixture" || exit 1
  plugin alpha; plugin beta; plugin gamma
  scripts_fixture
  mkdir .claude-plugin
  cat > .claude-plugin/marketplace.json <<'EOF'
{
  "name": "fixture",
  "owner": {
    "name": "owner"
  },
  "metadata": {
    "description": "fixture marketplace"
  },
  "plugins": [
    {
      "name": "alpha",
      "source": "./plugins/alpha",
      "description": "alpha plugin",
      "dependencies": [
        "beta"
      ]
    },
    {
      "name": "beta",
      "source": "./plugins/beta",
      "description": "beta plugin"
    }
  ]
}
EOF
  printf '| 플러그인 | 내용 |\n| --- | --- |\n| `alpha` | 알파 |\n| `beta` | 베타 |\n' > README.md
  printf '| Plugin | What |\n| --- | --- |\n| `alpha` | Alpha |\n| `beta` | Beta |\n' > README.en.md
  git add -A && git commit -qm fixture
}

# 준비 도우미 (clone 한 저장소의 work 브랜치에서 돈다)
edit() { for f; do echo "고침" >> "$f"; done; }
bump() { sed -i "s/\"version\": \"0.1.0\"/\"version\": \"${2:-0.1.1}\"/" "plugins/$1/.claude-plugin/plugin.json"; }
both() { edit "plugins/$1/skills/a.md" "i18n/en/plugins/$1/skills/a.md"; }

# 시나리오: 준비 함수
s_none()             { :; }
s_en_removed()       { rm "i18n/en/plugins/alpha/skills/a.md"; }
s_untracked_no_pair(){ echo "# new" > plugins/alpha/skills/new.md; bump alpha; }
s_same_version()     { both alpha; }
s_bump()             { both alpha; bump alpha; }
s_committed_same()   { both alpha; git commit -qam edit; }
s_translation_only() { edit "i18n/en/plugins/alpha/skills/a.md"; }
s_source_only()      { edit plugins/alpha/skills/a.md; bump alpha; }
s_add_pair_bump()    { echo "# b" > plugins/alpha/skills/b.md; echo "# b" > i18n/en/plugins/alpha/skills/b.md; bump alpha; }
s_move_receiver()    { git mv plugins/alpha/skills/a.md plugins/beta/skills/moved.md
                       git mv i18n/en/plugins/alpha/skills/a.md i18n/en/plugins/beta/skills/moved.md; bump beta; }
s_move_both()        { s_move_receiver; bump alpha; }
s_no_base()          { s_origin_only; git update-ref -d refs/remotes/origin/HEAD
                       git update-ref -d refs/remotes/origin/main; }
s_desc_mismatch()    { sed -i 's/"alpha plugin"/"alpha plugin, changed"/' plugins/alpha/.claude-plugin/plugin.json; bump alpha; }
s_readme_missing()   { sed -i '/`alpha`/d' README.md; }
s_readme_en_missing(){ sed -i '/`beta`/d' README.en.md; }
s_delete_unstaged()  { rm plugins/alpha/skills/a.md i18n/en/plugins/alpha/skills/a.md; bump alpha; }
s_korean_path()      { echo "# 한글" > "plugins/alpha/skills/한글.md"; bump alpha; }
s_version_down()     { both alpha; bump alpha 0.0.9; }
s_origin_only()      { git branch -q -D main; both alpha; }
s_plugin_removed()   { git rm -rq plugins/gamma i18n/en/plugins/gamma; }
s_one_line_json()    { tr -d '
' < .claude-plugin/marketplace.json > m && mv m .claude-plugin/marketplace.json; }
s_readme_dep_column(){ sed -i -e '/^| `alpha`/d' -e 's/^| `beta` | 베타 |$/| `beta` | 베타 | `alpha` |/' README.md; }
s_desc_missing()     { sed -i '/"description": "alpha plugin"/d' .claude-plugin/marketplace.json; }
s_desc_missing_readme(){ s_desc_missing; sed -i '/`alpha`/d' README.md; }
s_author_in_entry()  { sed -i 's|^      "source": "./plugins/alpha",$|&\n      "author": {\n        "name": "someone"\n      },|' .claude-plugin/marketplace.json; }
s_key_after_plugins(){ sed -i 's|^  \]$|  ],\n  "extra": {\n    "description": "other"\n  }|' .claude-plugin/marketplace.json; }
s_eval_md()          { mkdir -p plugins/alpha/evals/c1/graders; echo "# p" > plugins/alpha/evals/c1/prompt.md
                       echo "# g" > plugins/alpha/evals/c1/graders/g.md; bump alpha; }
s_eval_md_edit()     { s_eval_md; git add -A && git commit -qm eval && git branch -q -f main HEAD
                       edit plugins/alpha/evals/c1/prompt.md
                       sed -i 's/"version": "0.1.1"/"version": "0.1.2"/' plugins/alpha/.claude-plugin/plugin.json; }
s_skill_bang()       { printf -- '- 브랜치: !`git branch --show-current`
' >> plugins/alpha/skills/a.md
                       printf -- '- Branch: !`git branch --show-current`
' >> i18n/en/plugins/alpha/skills/a.md; bump alpha; }
s_one_line_base()    { tr -s ' \n' ' ' < plugins/gamma/.claude-plugin/plugin.json > m && mv m plugins/gamma/.claude-plugin/plugin.json
                       git commit -qam one-line && git branch -q -f main HEAD; both gamma; }
s_script_pass()      { echo '# 고침' >> plugins/alpha/scripts/tool.sh; bump alpha; }
s_script_fail()      { echo 'exit 1' > plugins/alpha/scripts/tool.sh; bump alpha; }
s_script_no_pair()   { echo 'exit 0' > plugins/alpha/scripts/new.sh; bump alpha; }
s_check_changed()    { echo '# 고침' >> scripts/check-repo-rules.sh; }
s_test_only()        { echo '# 고침' >> scripts/test-tool.sh; }
s_test_only_fail()   { echo 'exit 1' >> scripts/test-tool.sh; }
s_eval_sh()          { mkdir -p plugins/alpha/evals/c1; echo 'exit 0' > plugins/alpha/evals/c1/fixture.sh; bump alpha; }
s_script_deleted()   { git rm -q plugins/alpha/scripts/tool.sh; bump alpha; }
s_port_comment()     { sed -i 's/^# frontend 쪽$/# frontend 쪽, 고침/' "$dev_server"; }
s_port_diff()        { sed -i 's/return 2/return 1/' "$dev_server"; }
s_port_missing()     { sed -i 's/^port_open() {$/port_check() {/' "$dev_server"; }
s_test_hangs()       { echo 'sleep 30' >> scripts/test-tool.sh; }
s_test_reads_stdin() { echo '# 고침' >> plugins/alpha/scripts/tool.sh; bump alpha # 첫 테스트가 표준 입력을 읽어도
                       echo 'cat > /dev/null' >> scripts/test-tool.sh             # 뒤에 바뀐 것의 테스트가 돈다
                       echo 'exit 1' > scripts/test-pick-port.sh; }

pass=0 total=0
has() { printf '%s\n' "$out" | grep -qF -- "$1"; }
scenario() { # 설명 기대종료코드 준비함수 [출력에 있어야 할 문구, !로 시작하면 없어야 할 문구]
  local name=$1 want=$2 setup=$3 msg=$4 dir out code
  total=$((total + 1))
  dir="$tmp/case$total"
  cp -a "$tmp/template" "$dir"
  if ! (cd "$dir" && $setup) > "$dir.setup" 2>&1; then
    echo "틀림: $name (준비 실패)"; sed 's/^/    /' "$dir.setup"; return
  fi
  out=$(cd "$dir" && bash "$check" 2>&1); code=$?
  if [ "$code" = "$want" ] && case $msg in '') ;; '!'*) ! has "${msg#!}" ;; *) has "$msg" ;; esac; then
    pass=$((pass + 1)); echo "맞음: $name"
  else
    echo "틀림: $name (종료 $code, 기대 $want${msg:+, 문구 \"$msg\"})"
    printf '%s\n' "$out" | sed 's/^/    /'
  fi
}

# 템플릿: 가짜 저장소를 clone 해 origin/main 을 두고 work 브랜치로 옮긴 것
{ (make_fixture) && git clone -q "$tmp/fixture" "$tmp/template" && git -C "$tmp/template" switch -q -c work; } > /dev/null ||
  { echo "가짜 저장소를 만들지 못했다"; exit 1; }

# 001 에서 만든 것
scenario "변경 없음 → 통과"                     0 s_none
scenario "번역본 짝 지움 → 실패"                 1 s_en_removed        "번역본 없음: plugins/alpha/skills/a.md"
scenario "추가 안 한 md 짝 없음 → 실패"          1 s_untracked_no_pair "번역본 없음: plugins/alpha/skills/new.md"
scenario "고치고 version 그대로 → 실패"          1 s_same_version      "version 그대로: alpha"
scenario "고치고 version 올림 → 통과"            0 s_bump
scenario "커밋한 변경 version 그대로 → 실패"     1 s_committed_same    "version 그대로: alpha"
scenario "번역본만 고침 → 통과"                  0 s_translation_only
scenario "원문만 고침 → 실패"                    1 s_source_only       "번역본 그대로: plugins/alpha/skills/a.md"
scenario "원문·번역본 함께 더하고 올림 → 통과"   0 s_add_pair_bump
scenario "옮기고 받는 쪽만 올림 → 실패"          1 s_move_receiver     "version 그대로: alpha"
scenario "옮기고 양쪽 올림 → 통과"               0 s_move_both
scenario "기준 브랜치 없음 → 건너뛰고 통과"      0 s_no_base           "건너뛴다"
# 002 에서 더한 것
scenario "설명 다름 → 실패"                      1 s_desc_mismatch     "설명 다름: alpha"
scenario "README.md 에 없음 → 실패"              1 s_readme_missing    "README 에 없음: README.md alpha"
scenario "README.en.md 에 없음 → 실패"           1 s_readme_en_missing "README 에 없음: README.en.md beta"
scenario "다른 줄의 의존 칸에만 있음 → 실패"     1 s_readme_dep_column "README 에 없음: README.md alpha"
scenario "함께 지우고 스테이징 안 함 → 통과"     0 s_delete_unstaged
scenario "한글 경로 → 이스케이프 없이 실패"      1 s_korean_path       "번역본 없음: plugins/alpha/skills/한글.md"
scenario "version 내림 → 실패"                   1 s_version_down      "version 내림: alpha"
scenario "로컬 main 없고 origin/main 만 → 실패"  1 s_origin_only       "version 그대로: alpha"
scenario "marketplace 밖 플러그인 지움 → 통과"   0 s_plugin_removed
scenario "marketplace 를 못 읽음 → 실패"        1 s_one_line_json     "marketplace.json 에서 플러그인을 읽지 못했다"
scenario "marketplace 항목에 설명 없음 → 실패"   1 s_desc_missing      "설명 다름: alpha"
scenario "설명 없는 항목도 README 검사"        1 s_desc_missing_readme "README 에 없음: README.md alpha"
scenario "항목 안 author.name → 통과"          0 s_author_in_entry
scenario "plugins 뒤 최상위 키 → 통과"         0 s_key_after_plugins
scenario "기준 plugin.json 한 줄 → 실패"       1 s_one_line_base     "version 을 읽지 못함: gamma"
# 008 에서 더한 것
scenario "evals 의 md 는 번역본 없이 → 통과"   0 s_eval_md
scenario "evals 의 md 만 고침 → 통과"          0 s_eval_md_edit
scenario "스킬에 셸 주입 줄 → 실패"           1 s_skill_bang        "셸 주입 줄: plugins/alpha/skills/a.md"
# 011 에서 더한 것
scenario "바뀐 스크립트의 테스트 통과 → 통과"  0 s_script_pass       "테스트 통과: scripts/test-tool.sh"
scenario "바뀐 스크립트의 테스트 틀림 → 실패"  1 s_script_fail       "테스트 실패: scripts/test-tool.sh"
scenario "마크다운만 바뀜 → 테스트 안 돌림"     0 s_bump              "!scripts/test-"
scenario "짝 테스트 없는 스크립트 → 실패"       1 s_script_no_pair    "짝 테스트 없음: plugins/alpha/scripts/new.sh"
scenario "검사 스크립트 바뀜 → 그 테스트 돌림"  0 s_check_changed     "테스트 통과: scripts/test-check-repo-rules.sh"
scenario "짝 테스트만 바뀜 → 그 테스트 돌림"    0 s_test_only         "테스트 통과: scripts/test-tool.sh"
scenario "짝 테스트만 바뀌고 틀림 → 실패"       1 s_test_only_fail    "테스트 실패: scripts/test-tool.sh"
scenario "evals 의 fixture.sh → 짝 없이 통과"   0 s_eval_sh           "!짝 테스트 없음"
scenario "스크립트 지움 → 테스트 안 돌림"       0 s_script_deleted    "!scripts/test-tool.sh"
scenario "port_open 같고 주석만 다름 → 통과"    0 s_port_comment      "테스트 통과: scripts/test-dev-server.sh"
scenario "port_open 다름 → 실패"                1 s_port_diff         "port_open 다름: $pick_port, $dev_server"
scenario "port_open 없음 → 실패"                1 s_port_missing      "port_open 을 찾지 못함: $dev_server"
scenario "짝 테스트가 멈춤 → 시간 초과로 실패"  1 s_test_hangs        "테스트 실패(3초 시간 초과): scripts/test-tool.sh"
scenario "테스트가 표준 입력 읽음 → 뒤도 돌림"  1 s_test_reads_stdin  "테스트 실패: scripts/test-pick-port.sh"

echo "$total 개 중 $pass 개 맞음"
[ "$pass" = "$total" ]
