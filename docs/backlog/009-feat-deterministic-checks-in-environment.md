---
id: '009'
title: 정해진 절차는 스크립트로, 되풀이되는 지적은 자동 검사로, 테스트는 고치기 전 코드에서 확인 (네 자료 1~4)
status: To Do
labels: [feat]
priority: medium
dependencies: []
created_date: 2026-11-23
updated_date: 2026-11-23
---

## Description

Lauren Tan(pstack) 영상과 Satya Nadella 영상, 그리고 두 영상을 옮긴 뉴스레터 글 두 편(아래 참고 자료)을 j-dev-kit 과 대조한 보고서 `.claude/.local/reports/2026-11-23-네-자료-비교.md`(커밋하지 않음)의 3절 개선 후보 1~4를 한 항목으로 한다. 사용자가 나누지 않기로 정했다. 아래 타임스탬프는 그 시점으로 가는 링크다. "탠"과 "포콕"은 Tan 영상, "나델라"는 Nadella 영상이다.

1. **기계적인 절차를 스크립트로:** 스킬의 결정적인 부분은 스크립트로 옮겨 판단을 아낀다(탠 [20:51](https://www.youtube.com/watch?v=MN9dGgmLyso&t=1251s), [23:05](https://www.youtube.com/watch?v=MN9dGgmLyso&t=1385s) "rebuild the world each time", [23:43](https://www.youtube.com/watch?v=MN9dGgmLyso&t=1423s), 글 1의 「첫 계단은 검증, 실수는 환경으로」 단락). 지금 포트 정하기(`start.md` 4단계), 개발 서버를 띄우고 듣는지 확인하기(`frontend-start-check`와 `frontend-end-check`에 같은 긴 문단이 두 번), 추가된 줄의 디버그 코드·lockfile 검사(`frontend-end-check` 1절)는 마크다운 문장이고 `lsof`만 쓴다. 이 Windows 기계에는 `lsof`도 `nc`도 없어 세션마다 다른 방법을 지어낸다. 판단이 필요한 부분(무엇을 띄울지, 백엔드도 필요한지)은 마크다운에 남긴다. `server-end-check`의 기계적 검사(새로 읽는 환경 변수가 `.env.example`에 없음, 값 파일 커밋, 키 패턴)도 같다. 전문가 스킬 활용 조사(`.claude/.local/reports/2026-11-23-전문가-스킬-활용.md` 공통분모 2, 후보 4)가 같은 결론이라 이 항목에 더했다. 마이그레이션 담당 판별, oasdiff 결과 해석처럼 판단이 필요한 검사는 글로 남긴다.
2. **되풀이되는 지적은 린트·테스트·타입으로:** 같은 실수를 두 번 보면 글로 당부하지 말고 자동 검사로 막는다(탠 [31:43](https://www.youtube.com/watch?v=MN9dGgmLyso&t=1903s)–[32:01](https://www.youtube.com/watch?v=MN9dGgmLyso&t=1921s), [50:24](https://www.youtube.com/watch?v=MN9dGgmLyso&t=3024s)–[51:06](https://www.youtube.com/watch?v=MN9dGgmLyso&t=3066s), [54:02](https://www.youtube.com/watch?v=MN9dGgmLyso&t=3242s), 포콕 [32:42](https://www.youtube.com/watch?v=MN9dGgmLyso&t=1962s), 글 1의 「첫 계단은 검증, 실수는 환경으로」 단락의 역피라미드와 「1인 창업자를 위한 체크리스트」 3번). 지금 `/task end` 4단계는 🟡 에 "지금 / 나중 / 그대로"만 묻는다. 받아들여 고친 지적이 전에도 있었거나 이번 리뷰에서 여러 곳에 나오면 "자동 검사로 막기"를 고를 수 있게 한다. 한 번뿐인 지적에는 붙이지 않는다.
3. **새 테스트가 고치기 전 코드에서 실패하는지:** 고친 코드를 뺀 채 새 테스트를 돌려 그래도 통과하면 고쳤다는 증거로 치지 않는다(나델라 [13:22](https://www.youtube.com/watch?v=0NE89Nzfk20&t=802s) "make sure you truly verify the test", 글 2의 「나델라도 배우는 검증, 일은 작게 나눠 에이전트에게 맡기고 결과는 테스트와 운영 로그로 본다」 단락 중 [참고]의 Cowork 팀 방식, 탠 [9:32](https://www.youtube.com/watch?v=MN9dGgmLyso&t=572s) 동어반복 테스트). 지금은 TDD 의 빨강을 구현 세션이 스스로 확인할 뿐이다(`start.md` 5단계, `end.md` 5단계).
4. **`design-reviewer` 쓰기 권한:** 권한을 지능과 떼고 에이전트를 내부자 위험으로 본다(나델라 [51:53](https://www.youtube.com/watch?v=0NE89Nzfk20&t=3113s), [52:01](https://www.youtube.com/watch?v=0NE89Nzfk20&t=3121s)). `design-reviewer`는 frontmatter 에 도구 제한이 없어 쓰기 금지가 문장뿐이다. 같은 성격의 `frontend-evaluator`는 이미 `disallowedTools`로 막는다.

008 과 겹치는 곳(묶지 않는다. 함께 돌리고 충돌은 머지 때 푼다):

- 008 이 고치는 곳: `start.md` 3단계 전문가 단계·6단계 AC 판정, `end.md` 3단계 리뷰 입력·4단계 판정을 작업 세션 밖으로·6단계 Final Summary, 리뷰 에이전트 5개의 첫 문장(`design-reviewer` 포함).
- 이 항목이 고치는 곳: `start.md` 4단계 포트, `end.md` 4단계의 선택지와 새 🟡 지적, `frontend-start-check`·`frontend-end-check`의 절차, `server-end-check` 1절의 설정 키·키 검사, `design-reviewer`의 frontmatter.
- 008 은 그대로 둔 지적을 원칙(글)으로 모은다. 2는 받아들여 고친 지적을 자동 검사로 올리는 것이라 다르다. 3은 008 AC #7 이 말하는 "바깥 증거"의 구체적인 수단 하나다.

가정: 어느 절차를 스크립트로 옮길지, 스크립트 이름·위치·언어, 되풀이를 무엇으로 알아볼지(`docs/done/`의 Final Summary 등), 테스트를 기준 브랜치 소스에 대고 돌리는 방법은 `/task start` 계획에서 정한다.

이번에 빼는 것: 항목 번호 세기(`create.md` 2단계. 제안함의 "항목 번호 겹침 막기"가 아직 "논의 필요"다). 보고서 3절 5~7(008 에 넣었다). `frontend-reviewer`·`api-reviewer`·`supabase-reviewer`의 `tools`(이미 Edit·Write 가 없고 Bash 는 008 이 쓴다). 자동 검사 규칙을 대신 써 주는 것(항목만 만든다).

참고 자료:

- Tan 영상: 「LIVE: Poteto (creator of pstack) on shipping 1,000's of PR's a month at SpaceX」, Matt Pocock 채널, Lauren Tan 출연 — https://www.youtube.com/watch?v=MN9dGgmLyso
- Nadella 영상: 「Software engineering after code becomes cheap with Satya Nadella」, The Pragmatic Engineer(Gergely Orosz 진행) — https://www.youtube.com/watch?v=0NE89Nzfk20
- 글 1: 「한 달 PR 2,500개 머지했다는 개발자는 왜 PR을 다 리뷰하지 않을까?」, 조쉬의 뉴스레터, Tan 영상을 Q&A 로 옮긴 글 — https://maily.so/josh/posts/xyowyd21z28
- 글 2: 「마이크로소프트 CEO 나델라, 코드는 싸졌지만 어려워진 건 검증이다」, 조쉬의 뉴스레터, Nadella 영상을 Q&A 로 옮긴 글 — https://maily.so/josh/posts/32z831mjon4

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 빈 포트 고르기, 개발 서버를 그 포트로 띄우고 듣는지 확인하기, 추가된 줄의 `console.log`·`debugger`·`.only(`와 lockfile 검사가 스킬 폴더 안 스크립트로 있고, `start.md` 4단계와 `frontend-start-check`·`frontend-end-check`의 해당 자리에는 그 스크립트를 돌려 출력을 쓰라는 말만 남았다(`grep -rn 'lsof' plugins/ i18n/`이 비어 있다)
- [ ] #8 `server-end-check`의 새 환경 변수가 `.env.example`에 없는지, 값 파일(`.env` 등)이 커밋됐는지, 키 패턴 검사가 스킬 폴더 안 스크립트로 있고 실패만 `파일:줄 — 이유`(키는 파일 이름만)로 출력한다. `server-end-check` 해당 자리에는 그 스크립트를 돌려 실패를 돌려준다는 말만 남았다. 이 스크립트도 #2 처럼 테스트가 있다
- [ ] #2 #1 의 스크립트마다 `scripts/`에 테스트가 있고, `lsof`·`nc`가 없는 이 Windows(Git Bash)에서 통과한다. 포트를 확인할 방법이 없으면 스크립트가 그렇다고 출력하고 0 이 아닌 값으로 끝난다
- [ ] #3 `end.md` 4단계에서, 받아들여 고칠 지적이 이전 항목의 Final Summary "리뷰에서 고친 것"에 같은 종류로 있거나 이번 리뷰에서 여러 곳에 나오면, 그 지적에 "린트 규칙·테스트·타입으로 막기(새 항목)" 선택지가 붙는다고 적혀 있다. 한 번뿐인 지적에는 붙지 않는다
- [ ] #4 그 선택지를 고르면 `end.md` 5단계가 "나중"과 같이 `task` 스킬을 `create <지적과 근거, 막을 수단> --here`로 불러 항목을 만든다고 적혀 있다
- [ ] #5 `/task end`가 이번 브랜치에서 더하거나 바꾼 테스트를 기준 브랜치의 소스에 대고 돌리고, 거기서도 통과하는 테스트를 🟡 "고친 것을 증명하지 못함"으로 지적 목록에 넣는다고 `end.md`에 적혀 있다. 그렇게 돌릴 수 없으면 "확인 못 함"으로 적고 넘어간다
- [ ] #6 #5 의 확인이 #1 처럼 스크립트로 있고, 그 스크립트의 테스트가 "기준 브랜치에서도 통과하는 테스트"와 "기준 브랜치에서는 실패하는 테스트"를 구별하는 것을 보인다
- [ ] #7 `plugins/frontend/agents/design-reviewer.md`와 번역본의 frontmatter 에 `disallowedTools: Edit, Write, NotebookEdit`이 있다

<!-- AC:END -->

## Definition of Done

<!-- DOD:BEGIN -->

- [ ] #1 `claude plugin validate . && bash scripts/check-repo-rules.sh` 통과
- [ ] #2 원문(`plugins/`)을 고친 곳은 번역본(`i18n/en/`)도 같이 고쳤다
- [ ] #3 고친 플러그인마다 `plugin.json` `version`을 올렸고, README 두 개와 `marketplace.json` 설명을 맞췄다

<!-- DOD:END -->

## Implementation Plan

만들 때는 비워 둔다. `/task start`가 승인된 계획을 적는다.

## Implementation Notes

작업하며 알게 된 것, 계획에서 바뀐 것.

## Final Summary

`/task end`가 쓴다: 바뀐 것, 리뷰에서 고친 것, 미룬 것.
