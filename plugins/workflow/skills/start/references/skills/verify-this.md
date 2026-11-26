# Verify This

> 원문: `cursor/plugins`의 `cursor-team-kit/skills/verify-this/SKILL.md` (MIT, Cursor). Cursor 이름을 Claude Code 것으로 바꾸고 가져오지 않은 스킬을 가리키는 줄을 뺐다.

**언제:** 어떤 주장을 새로 뜬 로컬 증거로 검증할 때. 주장을 반증할 수 있게 다시 쓰고, 기준선과 변경 뒤를 뜨고, 결과물을 비교하고, `VERIFIED`, `NOT VERIFIED`, `INCONCLUSIVE` 중 하나를 돌려준다.

검증은 한 일을 되짚는 것이 아니다. 구체적인 주장 하나를 되풀이할 수 있는 증거로 증명하거나 반증한다.

## 언제 쓰나

- 사용자가 "이거 검증해 줘", "되는 걸 증명해 줘", "이걸로 고쳐졌어?", "증거를 보여 줘"라고 한다.
- 버그 수정에 전후 재현이 필요하다.
- UI, CLI, API, 성능, 메모리에 관한 주장을 재야 한다.
- 테스트는 통과하지만 사용자에게 보이는 동작은 아직 확인해야 한다.

"코드가 더 깔끔하다" 같은 막연한 주장에는 쓰지 않는다. 먼저 잴 수 있는 주장을 달라고 한다.

## 순서

1. 주장을 반증할 수 있는 꼴로 다시 쓴다: 조건, 수치, 문턱값.
2. 주장을 반증할 수 있는 가장 작은 로컬 표면을 고른다.
3. 옛 상태에서 기준선을 뜬다: 머지 베이스, 부모 커밋, 실패하는 브랜치, 지금 깨져 있는 재현.
4. 바뀐 상태에서 같은 명령, 데이터, 워밍업, 환경으로 변경 뒤를 뜬다.
5. 원본 결과물을 비교한다: 숫자, 스크린숏, 터미널 기록, HTTP 응답, 프로파일, 힙 스냅샷, 테스트 출력.
6. 판정을 딱 하나 돌려준다: `VERIFIED`, `NOT VERIFIED`, `INCONCLUSIVE`.

## 로컬 표면

- 코드 동작: 초점을 좁힌 단위/통합 테스트나 최소 재현 스크립트.
- CLI/TUI 동작: `skills/control-cli.md`, 터미널 기록, 데모 녹화.
- UI 동작: `skills/control-ui.md`, 스크린숏, 접근성 스냅샷, 브라우저 트레이스.
- API 동작: 로컬 HTTP/RPC 요청과 응답 diff.
- 성능: 같은 기계에서 잰 기준선/변경 뒤 시간이나 CPU 프로파일.
- 메모리: 의심하는 동작 전과 후의 힙 스냅샷.

## 결과물 배치

결과물을 써도 안전할 때:

```text
/tmp/verify-this/<claim-slug>/
├── claim.md
├── timeline.md
├── baseline/
├── treatment/
├── diff/
└── verdict.md
```

결과물에 민감한 코드, 프롬프트, 스크린숏, HTTP 본문, 힙 데이터가 들어갈 수 있으면, 사용자가 디스크 저장에 동의하지 않는 한 최소한의 증거만 답 안에 남긴다.

## 판정 규칙

- `VERIFIED`: 기준선과 변경 뒤가 예측한 방향으로, 주장한 문턱값만큼 다르고, 눈에 띄는 교란 요인이 없다.
- `NOT VERIFIED`: 동작이 그대로거나, 반대 방향으로 움직이거나, 문턱값에 못 미친다.
- `INCONCLUSIVE`: 쓸 수 있는 기준선이 없거나, 신호에 잡음이 많거나, 측정이 실패했거나, 환경 차이 때문에 비교가 성립하지 않는다.

## 출력

이 모양으로 쓴다.

```text
VERIFIED | NOT VERIFIED | INCONCLUSIVE
Claim: <falsifiable claim>

Evidence:
<metric/artifact>: baseline=<...>, treatment=<...>, delta=<...>, threshold=<...>

Reasoning:
<one tight paragraph naming the evidence and any confounds>
```

부정적인 결과를 누그러뜨리지 않는다. 분명한 `NOT VERIFIED`는 쓸모가 있다.
