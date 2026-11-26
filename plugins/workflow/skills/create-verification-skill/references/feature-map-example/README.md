# Notes verification map

> 원문: `cursor/plugins`의 `pstack/skills/create-verification-skill/references/feature-map-example/README.md` (MIT, Lauren Tan).

이 폴더는 Notes 의 사용자 동작을 검증할 때 쓰는, 관리하는 원본이다. 앱을 몰기 전에 색인을 읽고, 맞는 기능 파일을 절차로 쓴다.

## 기본 전제 조건

- Notes 를 일회용 데이터 폴더로 `http://127.0.0.1:4173`에 띄운다.
- `NOTES_DATA_DIR=/tmp/notes-verify-$RUN_ID`로 두어 동시에 도는 실행이 상태를 함께 쓰지 않게 한다.
- 제목이 `Quarterly plan`과 `Grocery list`인 노트를 seed 로 넣는다.
- `control-notes`와 `notes` CLI 를 `PATH`에 둔다.
- `control-notes doctor`를 돌린다. 기대한 URL, 데이터 폴더, 빌드 revision 이 나와야 한다.
- 이번 검증 실행이 띄우지 않은 인스턴스는 몰지 않는다.

## 모는 규칙

- 절차는 전제 조건에 다른 말이 없으면 기본 상태에서 시작한다.
- CSS selector 나 DOM 위치보다 ARIA role 과 accessible name 을 쓴다.
- 명령은 모두 글자 그대로 쓴다. 따옴표 안의 이름과 플래그를 바꾸지 않는다.
- 브라우저 동작은 `control-notes browser`로 돌린다.
- 터미널 동작은 `control-notes cli -- <command>`로 돌린다.
- 데이터를 바꿨으면 seed 데이터를 되돌린다. cleanup 중에 증거 산출물을 지우지 않는다.

## 증거와 건너뛴 것의 보고

- 마지막 화면만이 아니라 사용자 동작과 그 결과 상태를 남긴다.
- UI 증거에는 ARIA snapshot 과, 어느 앱인지 보이는 스크린샷이 들어간다.
- CLI 증거에는 명령, stdout, stderr, 종료 코드가 들어간다.
- 데이터를 바꾼 증거에는 저장된 값을 읽기 전용인 둘째 화면에서 본 것이 들어간다.
- 산출물마다 기능 ID 와 쓴 진입점을 적는다.
- 닿을 수 없는 경로는 시도한 명령과 채우지 못한 전제 조건과 함께 보고한다.
- 건너뛴 진입점을 다른 경로로 검증했다고 보고하지 않는다.

## 기능 파일의 형식

기능 파일은 H1 제목과, 사용자에게 보이는 동작을 설명하는 한 문단으로 시작한다. 그다음 H2 섹션 넷을 정확히 이 순서로 쓴다.

1. `Sub-features`는 짧은 ID 와 동작마다 한 줄을 나열한다.
2. `How to get to it (user POV)`는 사용자 진입점을 모두 나열한다.
3. `Driving it with <harness>`는 `Preconditions:`로 시작하고, 라벨 붙은 글머리표로 사용자 동작마다 정확한 명령과 관찰 가능한 결과를 짝짓는다.
4. `Gotchas`는 검증 실행을 헛되게 하거나 무효로 만들 수 있는 함정을 나열한다.

지도에 구현 세부를 넣지 않는다. 사용자 경로, 안정된 손잡이, 필요한 상태, 명령, 관찰 가능한 증거만 적는다.

## 기능

- [Create a note](./create-note.md)는 브라우저와 CLI 에서 만들기, 취소, 저장 유지, cleanup 을 다룬다.
- [Search notes](./search.md)는 toolbar, 키보드, CLI 검색과 일치, 빈 결과, 지우기 상태를 다룬다.
