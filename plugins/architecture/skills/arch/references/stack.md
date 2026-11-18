# 스택 추천

design 이 스택을 정해야 할 때 쓴다. 새 프로젝트이거나, 기존 프로젝트에 새 부품(데이터베이스, 큐, 인증, 상태 관리, 렌더링 방식 등)을 넣을 때다.

**스택 추천은 항상 웹 서베이를 한다**(`--research`가 없어도). 버전, 지원 기간, 유지보수 상태는 기억으로 답하지 않는다.

## 1. 출발점

- **기존 스택이 기본값이다.** 이미 쓰는 언어, 프레임워크, DB 로 할 수 있으면 그것을 추천한다. 바꾸는 것은 한 방향 문이라 기존 것으로는 품질 목표를 못 맞춘다는 근거가 있어야 한다.
- **확정된 ADR 은 제약이다.** 다시 볼 이유가 생겼을 때만 새 ADR 을 제안한다.
- **사용자의 숙련도를 묻는다.** 코드와 문서로 알 수 없고 추천을 바꿀 때만. 예: "TypeScript 와 Python 중 더 익숙한 쪽이 있나요?"

## 2. 앱 종류별로 먼저 정할 것

먼저 정할 요인을 정하고, 그 결정 트리가 있으면 서베이에서 읽는다. 공식 트리가 없는 종류는 아래 요인표로만 비교한다.

| 앱 종류 | 먼저 정할 것 | 참고할 결정 트리·가이드 |
| --- | --- | --- |
| 웹 앱·사이트 | 렌더링 방식(정적, SSR, CSR, 페이지마다 섞기), 개인화 정도, SEO, 호스팅 | [web.dev Rendering on the Web](https://web.dev/articles/rendering-on-the-web) |
| API·백엔드 | 데이터 모델(관계형, 문서, 키-값, 그래프), 일관성 요구, 트래픽 규모, 동기·비동기 처리 | [Azure: 데이터 저장소 고르기](https://learn.microsoft.com/azure/architecture/guide/technology-choices/data-store-decision-tree), [Azure: 컴퓨트 고르기](https://learn.microsoft.com/azure/architecture/guide/technology-choices/compute-decision-tree), [AWS Decision Guides](https://docs.aws.amazon.com/decision-guides/) |
| 메시징·이벤트 | 큐인가 스트림인가, 순서·중복 보장, 재처리 | [Azure Technology choices](https://learn.microsoft.com/azure/architecture/guide/technology-choices/technology-choices-overview) (메시징) |
| 데이터 파이프라인 | 지연 요구(분·시간이면 batch, 초 이하면 stream), 관리형인가 직접 운영인가, 선언형인가 | Azure data guide 의 batch·stream processing technology choices |
| 모바일 | 네이티브 UI 인가 공유 UI 인가, 플랫폼 API 를 얼마나 깊이 쓰나, 웹 팀과 코드 공유 | 중립적인 공식 트리 없음. 플랫폼 공식 문서와 프레임워크 공식 문서를 함께 보되, 프레임워크 제작사의 비교는 이해당사자 자료로 표시 |
| CLI | 배포 방식(단일 바이너리, 패키지 관리자), 시작 속도, 대상 OS | 공식 트리 없음 |
| 라이브러리 | 대상 생태계와 패키지 관리자, 런타임 크기, 지원할 런타임 버전, 라이선스 | 공식 트리 없음 |
| 데스크톱 | 네이티브인가 웹 기술 기반인가, 설치 크기, OS API 접근, 자동 업데이트 | 공식 트리 없음 |

## 3. 요인표

결정마다 후보 2~3개를 아래 요인으로 비교한다. 해당 없는 요인은 뺀다. 신호가 있는 요인은 서베이에서 실제 값을 가져온다.

| # | 요인 | 무엇을 보나 | 신호와 출처 |
| --- | --- | --- | --- |
| 1 | 요구와 품질 목표 | 이 앱의 품질 목표(순위)를 이 후보가 맞추는가 | 공식 문서, 결정 트리 |
| 2 | 숙련도 | 사용자·팀이 이미 아는가. 모르면 배우는 비용 | 사용자 답, 기존 코드 |
| 3 | 생태계 성숙도 | 쓰는 사람, 릴리스 주기, 주변 라이브러리 | 레지스트리 다운로드, GitHub 릴리스, [Thoughtworks Radar](https://www.thoughtworks.com/radar) 링, [CNCF 단계](https://contribute.cncf.io/projects/lifecycle/), 설문(연도 표시) |
| 4 | 지원 수명 | 현재 버전의 지원 종료일, LTS | [endoflife.date](https://endoflife.date/) API |
| 5 | 보안 | 보안 관행, 알려진 취약점, 대응 속도 | [OpenSSF Scorecard](https://scorecard.dev/), [deps.dev](https://deps.dev/) |
| 6 | 운영 복잡도와 비용 | 띄우고 지키는 데 드는 일, 관리형 여부, 요금 구조 | 공식 문서·요금 페이지 |
| 7 | 종속과 빠져나갈 길 | 독점 API 에 얼마나 묶이나, 옮길 때 무엇을 다시 써야 하나 | 공식 문서, 표준 준수 여부 |
| 8 | 라이선스 | 프로젝트의 라이선스·상업적 사용과 맞는가 | deps.dev, 저장소 LICENSE |
| 9 | AI 도구 친숙도 | 주류인가, 학습 시점 이후에 나온 메이저 버전인가 | 아래 근거. 근거 강도가 중간이므로 1~8 보다 가볍게 |

**9번 근거 [R, 중간]:**
- 학습 데이터가 적은 언어에서는 코드 생성 성능이 크게 떨어진다([arXiv 2501.19085](https://arxiv.org/abs/2501.19085)).
- 같은 에이전트가 다언어 SWE-bench 에서 Python 만 있을 때보다 낮다([SWE-bench Multilingual](https://www.swebench.com/multilingual)).
- LLM 은 지원 중단된 API 를 25~38% 쓴다([arXiv 2406.09834](https://arxiv.org/abs/2406.09834)).
- 버전에 맞춘 코드 작성은 절반 정도만 성공한다([arXiv 2507.12367](https://arxiv.org/abs/2507.12367)).

그래서 학습 시점 이후의 메이저 버전을 고르면, 그 버전의 공식 문서를 프로젝트에서 쉽게 찾을 수 있게 하라고 함께 적는다. 이 요인만으로 다른 요인을 뒤집지 않는다.

## 4. 혁신 토큰

새롭거나 덜 검증된 기술(팀이 처음 쓰는 것, Radar 의 Assess, CNCF Sandbox, 1.0 전, 기여자가 한두 명)을 센다. 한 프로젝트에서 2~3개를 넘으면 경고하고, 줄일 수 있는 것을 제안한다. 출처: [Choose Boring Technology](https://mcfunley.com/choose-boring-technology). 비판: [Against Innovation Tokens](https://blog.glyph.im/2024/07/against-innovation-tokens.html) — 진짜 비용은 기술과 기술의 경계에서 생기는 운영 부담이라는 지적이라, 개수와 함께 경계 수도 본다.

## 5. 서베이 지시 (architecture-researcher 에게)

- 결정마다: 결정 이름, 앱 종류와 품질 목표, 기존 스택, 후보(있으면), 볼 요인 번호.
- 후보가 없으면 결정 트리와 공식 문서로 후보 2~3개를 찾게 한다. 인기 순위 글 하나로 정하지 않는다.
- 후보마다 돌려받을 것: 최신 안정 버전과 날짜, 지원 종료일, 마지막 릴리스, 다운로드나 사용 지표, Scorecard 점수(있으면), 라이선스, 알려진 큰 문제, 출처 URL 과 확인 날짜.

## 6. 보여 주는 형식

```markdown
#### 결정: 주 데이터베이스 (한 방향 문)
| 요인 | PostgreSQL 17 | MongoDB 8 |
| --- | --- | --- |
| 품질 목표: 정합성 | 트랜잭션, 제약 — 맞음 | 다중 문서 트랜잭션 가능, 스키마 강제 약함 |
| 지원 수명 | 2029-11 까지 (endoflife.date, 2026-11-18 확인) | … |
| … | … | … |

추천: PostgreSQL 17 — 이유 한두 문장. 대안을 고를 때: …
```

한 방향 문이면 ADR 을 쓴다(`references/docs.md`). 양방향 문(대부분의 라이브러리)은 개요 문서의 스택 줄에 한 줄로 적는다.
