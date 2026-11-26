# ui-design system: DESIGN.md 만들기·갱신

형식은 Google DESIGN.md 다(alpha). 스펙은 외워 쓰지 말고 `npx -y -p @google/design.md@0.4.0 designmd spec --rules`로 받아 따른다. 아래 명령도 이 형태로 쓴다.

## 1. 읽기

- 토큰 소스: CSS 변수(`:root`, `@theme`), tailwind 설정, theme 파일, 컴포넌트 라이브러리 설정.
- 이미 있는 `DESIGN.md`, CLAUDE.md 의 디자인 항목.
- 토큰 소스가 없으면 그렇다고 말하고, 새로 정할지 묻는다. 정하면 사용자가 고른 값만 쓴다.

## 2. 쓰기

- **새로 만들 때:** 코드에 있는 값만 YAML 토큰에 넣는다. 섹션은 내용이 있는 것만 둔다. 코드로 알 수 없는 것(톤, 원칙, Do's and Don'ts)은 묻는다. 묻지 않고 지어내지 않는다.
- **갱신할 때:** 코드와 DESIGN.md 가 다른 토큰만 표로 보여 준다(토큰, DESIGN.md 값, 코드 값). 어느 쪽이 맞는지 묻는다.

쓸 내용을 보여 주고 한 번 승인받는다. 이 승인이 쓰기와 5단계의 커밋을 함께 덮는다. 승인받으면 루트 `DESIGN.md`에 쓴다.

## 3. 확인

`npx -y -p @google/design.md@0.4.0 designmd lint DESIGN.md`를 돌리고 오류를 고친다. 갱신이면 `diff`로 바뀐 토큰을 보여 준다.

## 4. 연결

DESIGN.md 는 자동으로 읽히지 않는다. CLAUDE.md 에 `@DESIGN.md` 줄이 없으면 넣을지 묻고, 승인하면 넣는다.

## 5. 커밋

2단계에서 승인받았으니 다시 묻지 않고 `design: DESIGN.md <만들기|갱신>`으로 커밋한다.
