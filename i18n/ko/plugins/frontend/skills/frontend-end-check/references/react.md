> 번역본입니다. 원문은 [plugins/frontend/skills/frontend-end-check/references/react.md](../../../../../../../plugins/frontend/skills/frontend-end-check/references/react.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# React / Next.js: 마무리 점검

package.json `dependencies`나 `devDependencies`에 `react`가 있을 때 `frontend-end-check`가 읽는다. 아래 행, 에이전트, 고친 뒤 할 항목을 그 스킬의 보고서에 더한다.

이 파일은 도구를 실행하고 결과를 비교하기만 한다. diff를 읽고 판단하는 리뷰(파생 state, effect, key, 요청 워터폴, Next 경계, …)는 `frontend:react-reviewer` 에이전트에게 넘긴다(4단계).

`.jsx`/`.tsx`(또는 훅이 든 `.js`/`.ts`) 중 바뀐 것이 없으면 1단계만 하고 나머지는 "React 변경 없음"으로 건너뛴다.

## 1. Lint(기준선과 비교)

`### Baseline`의 lint 명령을 다시 실행한다. 새 react-hooks 위반(`rules-of-hooks`, `exhaustive-deps`, 컴파일러 규칙) → 실패. 추가된 줄에 있는 `eslint-disable`의 개수와 위치를 기록한다(이유가 타당한지는 `react-reviewer`가 본다).

## 2. React Doctor

`npx -y react-doctor@0.9.22 --verbose --no-telemetry --scope changed`를 실행한다. 점수가 기준선보다 낮거나 바뀐 파일에 새 발견 사항이 있으면 → 실패. 기준선이 없으면 점수만 기록한다. 실행할 수 없으면 "React Doctor 없음"으로 건너뛴다.

## 3. 빌드

Next.js면 `next build`(프로젝트의 빌드 스크립트)가 통과하는지 확인한다. 공통 단계에서 이미 실행했으면 그 결과를 쓴다.

## 4. 리뷰에 넣을 에이전트

위의 React 파일 중 하나라도 바뀌었으면 근거(바뀐 파일 목록과 React Doctor 발견 사항)와 함께 `frontend:react-reviewer`를 돌려준다. 이 에이전트는 파생 state, effect 정리와 경쟁, key, 요청 워터폴, Next 서버/클라이언트 경계, 서버 액션 검증, `dangerouslySetInnerHTML`, 불필요한 메모이제이션, `eslint-disable`의 이유를 리뷰한다.

## 더할 행

```markdown
| react-hooks lint | … | 0 new violations, 0 new eslint-disable |
| React Doctor | … | 82 → 84 |
| Next build | … | … |
```

고친 뒤 할 것: lint와 React Doctor를 다시 실행한다.
