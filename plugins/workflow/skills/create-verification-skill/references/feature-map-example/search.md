# Search notes

> 원문: `cursor/plugins`의 `pstack/skills/create-verification-skill/references/feature-map-example/search.md` (MIT, Lauren Tan).

Search 로 사용자는 제목이나 본문 글로 노트를 찾고, 일치하는 노트를 살펴보고, 일치하는 것이 없는 경우와 검색을 쓸 수 없는 경우를 구별한다.

## Sub-features

- `search-open`은 지원하는 브라우저 진입점마다 검색을 연다.
- `search-match`는 노트 데이터를 바꾸지 않고 제목 일치와 본문 일치를 돌려준다.
- `search-open-result`는 결과를 노트 편집기에서 연다.
- `search-empty`는 일치하는 것이 없는 검색어에 온전한 빈 상태를 보여 준다.
- `search-clear`는 검색어를 지우고 최근 노트 화면을 되돌린다.
- `search-cli`는 터미널에서 같은 일치 노트를 돌려준다.

## How to get to it (user POV)

- 브라우저 toolbar 의 `Search` 버튼을 누른다.
- 포커스가 입력란 밖에 있을 때 브라우저에서 `/`를 누른다.
- 터미널에서 `notes search <query>`를 돌린다.

## Driving it with control-notes

Preconditions:

- Notes 가 `http://127.0.0.1:4173`에서 정상이다.
- 일회용 데이터 폴더에 본문이 `Draft budget`인 `Quarterly plan`이 있다.
- `control-notes doctor`가 기대한 URL 과 데이터 폴더를 보고한다.

- **Toolbar 진입.** `Search` 버튼을 누른다. `control-notes browser click --role button --name "Search"`를 돌린다. `Search notes`라는 dialog 가 나타나고 포커스가 그 searchbox 에 있다.
- **키보드 진입.** dialog 를 닫고, 페이지에 포커스를 두고, `/`를 누른다. `control-notes browser press --key "/"`를 돌린다. 같은 dialog 가 나타나고 페이지에 빗금이 입력되지 않는다.
- **제목 일치.** `quarterly`를 친다. `control-notes browser fill --role searchbox --name "Search notes" --value "quarterly"`를 돌린다. `Search results` 목록에 `Quarterly plan`이 있고 `Grocery list`는 없다.
- **본문 일치.** 검색어를 `budget`으로 바꾼다. `control-notes browser fill --role searchbox --name "Search notes" --value "budget"`을 돌린다. 결과 `Quarterly plan`이 본문 일치 발췌와 함께 그대로 보인다.
- **결과 열기.** `Quarterly plan`을 누른다. `control-notes browser click --role link --name "Quarterly plan"`을 돌린다. dialog 가 닫히고 편집기 heading 이 `Quarterly plan`이다.
- **빈 상태.** 검색을 다시 열고 `volcano`를 넣는다. `control-notes browser fill --role searchbox --name "Search notes" --value "volcano"`를 돌린다. 검색이 끝난 뒤 `No matching notes`라는 status 가 나타난다.
- **검색어 지우기.** `Clear search`를 누른다. `control-notes browser click --role button --name "Clear search"`를 돌린다. searchbox 가 비고 결과 목록 자리에 `Recent notes` region 이 들어선다.
- **CLI 일치.** 터미널에서 검색한다. `control-notes cli -- notes search "quarterly" --format json`을 돌린다. 종료 코드가 `0`이고 stdout 에 제목이 `Quarterly plan`인 객체 하나가 있다.
- **CLI 불일치.** 없는 값을 검색한다. `control-notes cli -- notes search "volcano" --format json`을 돌린다. 종료 코드가 `0`이고 stdout 이 `[]`다.
- **증거.** 결과가 채워진 상태를 남긴다. `control-notes browser snapshot --aria --path artifacts/search/results.aria.txt`와 `control-notes browser screenshot --path artifacts/search/results.png`를 돌린다. 두 산출물 모두에서 Notes, 검색어, `Quarterly plan`을 알아볼 수 있다.

## Gotchas

- 편집기나 searchbox 에 포커스가 있을 때 `/`를 누르면 검색이 열리지 않고 글자가 입력된다.
- 결과는 짧은 debounce 뒤에 바뀐다. 정해진 시간만큼 sleep 하지 말고 결과 목록이나 빈 상태 status 를 기다린다.
- 보관된 노트는 사용자가 `Include archived`를 켜지 않으면 빠진다.
- CLI 는 기본으로 사람이 읽는 출력을 낸다. 안정된 확인에는 `--format json`을 쓴다.
- 결과를 열면 브라우저 상태가 바뀐다. 다른 검색어를 증명하기 전에 검색을 다시 연다.
