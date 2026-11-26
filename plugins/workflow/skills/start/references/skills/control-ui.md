# Control UI

> 원문: `cursor/plugins`의 `cursor-team-kit/skills/control-ui/SKILL.md` (MIT, Cursor). Cursor 이름을 Claude Code 것으로 바꾸고 가져오지 않은 스킬을 가리키는 줄을 뺐다.

**언제:** 웹, IDE, Electron UI 를 몰고 들여다볼 로컬 브라우저/CDP 하네스를 만들거나 맞출 때. 로컬 UI 검증, 스크린숏, 접근성 스냅샷, 성능 프로파일, 시각 diff, UI 버그 재현에 쓴다.

로컬 브라우저 자동화로 UI 동작을 증거와 함께 검증한다. 저장소에 Playwright, 브라우저, Electron 하네스가 있으면 그것부터 다시 쓴다. 없으면 앱의 개발 서버나 Chromium 디버그 포트에 붙는 임시 로컬 하네스를 짠다.

## 어디에 쓰나

- 실제 브라우저의 포커스, 키보드 입력, 스크롤, 크기 조절, 렌더링에 달린 UI 버그를 재현한다.
- 시각 변경이나 접근성 변경을 스크린숏과 스냅샷으로 검증한다.
- 내보내기 전에 로컬 웹, IDE, Electron 동작을 확인한다.
- 콘솔 로그, 네트워크 로그, CPU 프로파일, 트레이스, 힙 스냅샷을 뜬다.
- `skills/verify-this.md`에 쓸 전후 증거를 만든다.

## 준비 순서

Claude Code 의 내장 브라우저 도구나 `chrome-devtools` 스킬이 있으면 그것을 먼저 쓴다.

1. 저장소 문서에 적힌 개발 명령으로 앱을 로컬에서 띄운다.
2. 이미 있는 로컬 하네스를 찾는다: Playwright 테스트, Cypress 스펙, Storybook, 브라우저 스크립트, Electron 실행 스크립트, 스냅샷 도구.
3. 웹 앱이면 이미 있는 브라우저 도구로 로컬 URL 에 붙는다.
4. Electron/Chromium 이면 지원할 때 원격 디버깅 포트를 켠다.
5. 탭 순서만 보지 말고 안정적인 앱 표식으로 맞는 페이지를 고른다.
6. 좌표보다 접근성 역할, 레이블, 안정적인 `data-*` 선택자를 쓴다.

## 일반 웹 하네스

할 수 있으면 저장소에 설치된 브라우저 도구를 쓴다. 저장소에 이미 Playwright 가 있으면 한 번 쓰고 버리는 최소 프로브는 이런 모양이다.

```javascript
import { chromium } from "playwright";

const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1280, height: 800 } });
await page.goto("http://127.0.0.1:<port>");
await page.getByRole("button", { name: /submit/i }).click();
await page.screenshot({ path: "/tmp/ui-harness-after.png", fullPage: true });
await browser.close();
```

사용자가 요청하지 않으면 이 프로브만을 위해 Playwright 를 프로젝트 의존성으로 더하지 않는다. 이미 있는 개발 의존성이나 환경에 이미 있는 외부 브라우저 도구를 쓴다.

## 일반 CDP 하네스

Electron 이나 `--remote-debugging-port=<port>`로 띄운 Chromium 앱이면 CDP 로 붙는다.

```javascript
import { chromium } from "playwright";

const browser = await chromium.connectOverCDP("http://127.0.0.1:<debug-port>");
const pages = browser.contexts().flatMap((context) => context.pages());
let page;
for (const candidate of pages) {
  if (await candidate.locator("<app-root-selector>").count()) {
    page = candidate;
    break;
  }
}

if (!page) {
  console.log(await Promise.all(pages.map(async (p) => ({
    title: await p.title(),
    url: p.url(),
  }))));
  throw new Error("No matching app page found");
}

await page.screenshot({ path: "/tmp/ui-harness-cdp.png", fullPage: true });
await browser.close();
```

`<app-root-selector>`는 지금 저장소의 안정적인 표식으로 바꾼다. 앱의 루트 노드, 랜드마크, 제품 고유의 `data-*` 속성 같은 것이다.

## 상호작용 반복

1. 움직이기 전에 페이지 스냅샷이나 스크린숏을 뜬다.
2. 가장 최근의 페이지 구조에서 대상을 고른다.
3. 구조를 바꾸는 동작을 딱 하나 한다: 클릭, 입력, 키 누르기, 드래그, 스크롤, 이동, 크기 조절.
4. 스냅샷이나 스크린숏을 새로 뜬다.
5. 기대한 상태 변화가 있었는지 확인한다.
6. 사용자가 증거를 요청했으면 전후 비교에 쓸 결과물을 저장한다.

## CDP 로 할 수 있는 것

원시 CDP 는 상위 수준 브라우저 API 로 모자랄 때만 쓴다.

- 성능: CPU 프로파일, 트레이스, 페인트 플래싱, FPS 미터, 레이아웃 시프트 조사.
- 메모리: 누수 조사를 위한 힙 스냅샷과 강제 GC.
- 네트워크: 요청 차단, 스로틀링, 캐시 끄기, 요청/응답 로그.
- 렌더링: 뷰포트 변경, 색 구성표 에뮬레이션, 모션 줄이기, 접근성 검사.
- 디버깅: 콘솔 스트리밍, 예외 잡기, DOM 스냅샷.

## 페이지 고르기

여러 앱 창이나 탭이 디버그 포트 하나를 같이 쓸 때:

- 시험하는 표면에 있는 표식(예: 앱 루트 선택자)으로 고른다.
- 필요하면 없어야 하는 표식으로 엉뚱한 표면을 피한다.
- 맞는 페이지가 없으면 추측하지 말고 있는 페이지의 제목과 URL 을 나열한다.

## 지킬 것

- 이동하거나 구조가 바뀐 뒤에는 오래된 요소 참조에 기대지 않는다.
- 좌표 클릭은 클릭 바로 전에 스크린숏을 새로 떴을 때만 한다.
- 테스트 데이터는 로컬에 두고 버릴 수 있게 한다.
- 개인정보에 민감한 작업 공간의 스크린숏이나 힙 스냅샷은 사용자가 분명히 동의하지 않으면 저장하지 않는다.
- 다른 저장소의 선택자, 포트, 스크립트 경로를 하드코딩하지 않는다. 지금 저장소의 로컬 앱 표식을 찾는다.
- 끝나면 개발 서버, 디버그 세션, 임시 프로필을 정리한다.
