#!/usr/bin/env bash
# plugins/workflow/hooks/verify-on-stop.sh 의 시나리오 테스트. `bash scripts/test-verify-on-stop.sh`
# 임시 폴더에 작은 가짜 저장소를 만들고, 시나리오마다 복사해 Stop 훅 입력(JSON)을 넣어 돌린다.
# 하나라도 틀리면 1로 끝난다.

hook="$(cd "$(dirname "$0")/.." && pwd)/plugins/workflow/hooks/verify-on-stop.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com
export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com

# 가짜 저장소: w/001-feat-x 브랜치, 항목 001, 검증 명령은 verify.sh.
# verify.sh 는 무시되는 파일 .verify-result 에 fail 이 있으면 실패한다(내용 tree 를 바꾸지 않고 결과만 바꾸려고).
make_fixture() {
  git init -q -b main "$tmp/template" && cd "$tmp/template" || exit 1
  printf '# fixture\n\n## 작업 설정\n- 검증 명령: `bash verify.sh`\n' > CLAUDE.md
  printf 'grep -q fail .verify-result 2>/dev/null && { echo "검증 실패함"; exit 1; }\nexit 0\n' > verify.sh
  printf '.verify-result\n' > .gitignore
  echo "a" > src.txt
  mkdir -p docs/backlog
  cat > docs/backlog/001-feat-x.md <<'EOF'
---
id: '001'
---

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 검증 통과

<!-- DOD:END -->
EOF
  git add -A && git commit -qm fixture && git switch -q -c w/001-feat-x
}

# 준비 도우미 (복사한 저장소 안에서 돈다)
dod_checked() { sed 's/- \[ \] #1/- [x] #1/' docs/backlog/001-feat-x.md > d && mv d docs/backlog/001-feat-x.md; }
verify_fails() { echo fail > .verify-result; }
verify_passes() { rm -f .verify-result; }
change_code() { echo "b" >> src.txt; }

pass=0 total=0
# scenario <설명> <기대 마지막 종료 코드> <단계...>
# 단계: 준비 함수 이름, 또는 run:true / run:false. 앞선 run 의 종료 코드는 expect:<코드> 로 확인한다.
scenario() {
  local name=$1 want=$2 dir step ok=1 why=
  shift 2
  total=$((total + 1))
  dir="$tmp/case$total"
  cp -a "$tmp/template" "$dir"
  code= out=
  for step; do
    case $step in
      run:*) run "${step#run:}" ;;
      expect:*) [ "$code" = "${step#expect:}" ] || { ok=; why="중간 종료 $code, 기대 ${step#expect:}"; break; } ;;
      *) (cd "$dir" && $step) > /dev/null 2>&1 || { ok=; why="준비 실패: $step"; break; } ;;
    esac
  done < /dev/null
  [ "$ok" ] && [ "$code" != "$want" ] && { ok=; why="종료 $code, 기대 $want"; }
  if [ "$ok" ]; then
    pass=$((pass + 1)); echo "맞음: $name"
  else
    echo "틀림: $name ($why)"; printf '%s\n' "$out" | sed 's/^/    /'
  fi
}
# 훅을 시나리오 폴더에서 한 번 돌린다: run <stop_hook_active true|false>. 종료 코드는 code, 출력은 out.
run() {
  out=$(cd "$tmp/case$total" && printf '{"session_id":"s","hook_event_name":"Stop","stop_hook_active":%s}' "$1" | bash "$hook" 2>&1)
  code=$?
}

(make_fixture) > /dev/null || { echo "가짜 저장소를 만들지 못했다"; exit 1; }

scenario "작업 브랜치가 아님 → 통과"                  0 "git switch -q main" verify_fails dod_checked run:false
scenario "DoD 체크 없음 → 검증 안 돌리고 통과"        0 verify_fails run:false
scenario "DoD 체크, 검증 통과 → 통과"                 0 dod_checked verify_passes run:false
scenario "DoD 체크, 검증 실패 → 되돌림"               2 dod_checked verify_fails run:false
scenario "다른 훅이 막은 뒤에도 검증 실패 → 되돌림"   2 dod_checked verify_fails run:true
scenario "같은 내용 두 번째 실패 → 되풀이 안 함"      0 dod_checked verify_fails run:false expect:2 run:true
scenario "내용을 바꾼 뒤 다시 실패 → 되돌림"          2 dod_checked verify_fails run:false expect:2 change_code run:true
scenario "통과한 내용은 다시 돌리지 않음"             0 dod_checked verify_passes run:false expect:0 verify_fails run:false

echo "$total 개 중 $pass 개 맞음"
[ "$pass" = "$total" ]
