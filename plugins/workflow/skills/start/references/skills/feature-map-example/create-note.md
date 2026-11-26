# Create a note

> 원문: `cursor/plugins`의 `pstack/skills/create-verification-skill/references/feature-map-example/create-note.md` (MIT, Lauren Tan).

Create note 로 사용자는 브라우저나 CLI 에서 제목 있는 노트를 저장하고, 끝내지 않은 초안을 취소하고, 저장된 노트를 둘째 사용자 화면에서 확인한다.

## Sub-features

- `create-open`은 브라우저 진입점마다 빈 편집기를 연다.
- `create-save`는 제목과 본문을 저장한다.
- `create-cancel`은 끝내지 않은 브라우저 초안을 버린다.
- `create-cli`는 터미널에서 같은 모양의 노트를 만든다.

## How to get to it (user POV)

- 브라우저 toolbar 의 `New note` 버튼을 누른다.
- 포커스가 입력란 밖에 있을 때 브라우저에서 `n`을 누른다.
- 터미널에서 `notes create --title <title> --body <body>`를 돌린다.

## Driving it with control-notes

Preconditions:

- Notes 가 `http://127.0.0.1:4173`에서 정상이다.
- 제목이 `Release checklist`인 노트가 없다.
- `control-notes doctor`가 기대한 URL 과 일회용 데이터 폴더를 보고한다.

- **편집기 열기.** `New note`를 누른다. `control-notes browser click --role button --name "New note"`를 돌린다. `Note editor`라는 form 이 나타나고 포커스가 `Title` textbox 에 있다.
- **내용 입력.** 제목과 본문을 친다. `control-notes browser fill --role textbox --name "Title" --value "Release checklist"`와 `control-notes browser fill --role textbox --name "Body" --value "Tag and publish"`를 돌린다. `Save note` 버튼이 켜진다.
- **노트 저장.** `Save note`를 누른다. `control-notes browser click --role button --name "Save note"`를 돌린다. `Note saved`라는 status 가 나타나고 heading 이 `Release checklist`다.
- **저장 확인.** 노트 목록으로 돌아가 노트를 다시 연다. `control-notes browser click --role link --name "All notes"`와 `control-notes browser click --role link --name "Release checklist"`를 돌린다. 편집기에 저장한 두 값이 모두 보인다.
- **초안 취소.** 새 노트를 열고 `Discard me`를 넣고 `Cancel`을 누른다. `control-notes browser click --role button --name "New note"`, `control-notes browser fill --role textbox --name "Title" --value "Discard me"`, `control-notes browser click --role button --name "Cancel"`을 돌린다. 노트 목록으로 돌아오고 `Discard me` 링크가 없다.
- **CLI 진입.** 둘째 노트를 만든다. `control-notes cli -- notes create --title "CLI note" --body "Created from terminal" --format json`을 돌린다. 종료 코드가 `0`이고 stdout 에 새 노트 ID 와 제목이 있다.
- **증거.** `All notes`에서 저장한 두 노트를 다시 연다. `control-notes browser snapshot --aria --path artifacts/create-note/list.aria.txt`와 `control-notes browser screenshot --path artifacts/create-note/list.png`를 돌린다. 산출물에 `Release checklist`와 `CLI note`가 보인다.

## Gotchas

- textbox 에 포커스가 있을 때 `n`을 누르면 새 편집기가 열리지 않고 글자가 입력된다.
- 제목은 저장할 때 앞뒤 공백이 잘린다. 초안 입력값이 아니라 화면에 그려진 제목을 확인한다.
- 저장 status 만으로는 증거가 모자란다. 목록에서 노트를 다시 연다.
- fixture cleanup 때 `Release checklist`와 `CLI note`를 지우되, 그 증거 산출물은 남긴다.
