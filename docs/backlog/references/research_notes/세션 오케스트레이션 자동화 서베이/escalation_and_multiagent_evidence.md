# 멀티에이전트(리드-워커) 효과 근거와 사람 호출(에스컬레이션) 설계 근거

기준일 2026-11-20. 각 항목에 출처 날짜를 붙였다. "미확인" 표시는 1차 출처에서 직접 확인하지 못한 것이다.

## 1. 멀티에이전트 / 리드-워커 구조는 언제 도움이 되고 언제 해가 되나 (코딩·장기 작업)

### Takeaway
병렬로 쪼갤 수 있는 읽기·조사 작업에서는 이득이 크지만(토큰 약 15배 비용), 순차 의존성이 강한 작업과 "여러 명이 동시에 쓰기"를 하는 코딩에서는 성능이 떨어진다. 2026년 기준 실무 합의는 "쓰기는 한 스레드, 다른 에이전트는 지능(조사·리뷰)만 보탠다"이고, 오케스트레이터가 있는 중앙집중형이 오류 전파를 가장 잘 막는다.

### Cited Findings
**Anthropic, "How we built our multi-agent research system" (2025-06-13)**
- 에이전트는 채팅보다 토큰을 약 4배, 멀티에이전트 시스템은 약 15배 쓴다. — [Anthropic](https://www.anthropic.com/engineering/multi-agent-research-system)
- BrowseComp 성능 분산의 80%를 토큰 사용량 하나가 설명하고, 도구 호출 수와 모델 선택을 더하면 95%. — [Anthropic](https://www.anthropic.com/engineering/multi-agent-research-system)
- Opus 4 리드 + Sonnet 4 서브에이전트 구성이 단일 Opus 4보다 내부 리서치 평가에서 90.2% 높았다. 병렬화로 복잡한 질의의 조사 시간이 최대 90% 줄었다. — [Anthropic](https://www.anthropic.com/engineering/multi-agent-research-system)
- 잘 맞지 않는 경우: 모든 에이전트가 같은 맥락을 공유해야 하는 작업, 에이전트 간 의존성이 많은 작업, 병렬화할 하위 작업이 적은 대부분의 코딩 작업, 가치가 낮은 작업, 실시간 조율. — [Anthropic](https://www.anthropic.com/engineering/multi-agent-research-system)
- 관찰된 실패: 간단한 질문에 서브에이전트 50개 생성, 존재하지 않는 자료를 끝없이 검색, 서브에이전트끼리 과도한 업데이트로 서로 방해, 모호한 지시로 인한 중복 작업(반도체 예시에서 2명이 같은 2025 공급망 조사). — [Anthropic](https://www.anthropic.com/engineering/multi-agent-research-system)
- 동기 실행이 병목: 리드가 서브에이전트 묶음이 끝날 때까지 기다리므로 가장 느린 하나에 전체가 묶인다. — [Anthropic](https://www.anthropic.com/engineering/multi-agent-research-system)

**Cognition, "Don't Build Multi-Agents" (Walden Yan, 2025-06-12)**
- 두 원칙: 메시지가 아니라 전체 에이전트 트레이스를 공유할 것, 그리고 "Actions carry implicit decisions"(행동에는 암묵적 결정이 담겨 있고, 충돌하는 결정은 나쁜 결과를 낳는다). — [Cognition](https://cognition.com/blog/dont-build-multi-agents)
- Flappy Bird 예시: 하위 작업으로 나누면 한 에이전트는 마리오풍 배경, 다른 에이전트는 엉뚱한 새를 만들어 결과가 서로 안 맞는다. — [Cognition](https://cognition.com/blog/dont-build-multi-agents)
- 기본 권장은 단일 스레드 선형 에이전트, 아주 긴 작업은 별도 모델로 기록을 압축(어렵다고 명시, Cognition은 소형 모델을 파인튜닝해 씀). — [Cognition](https://cognition.com/blog/dont-build-multi-agents)
- 2025년 6월 당시 Claude Code 서브에이전트는 주 에이전트와 병렬로 코드를 쓰지 않고 잘 정의된 질문에만 답하는 의도적으로 단순한 설계라고 평가. — [Cognition](https://cognition.com/blog/dont-build-multi-agents)

**Cognition 후속, "Multi-Agents: What's Actually Working" (Walden Yan, 2026-04-22)**
- 통하는 패턴은 "writes stay single-threaded"(쓰기는 단일 스레드)이고 추가 에이전트는 행동이 아니라 지능을 보탠다. — [Cognition](https://cognition.com/blog/multi-agents-working)
- 코더-리뷰어 루프: Devin Review가 PR당 약 2개 버그를 잡고 그중 약 58%가 심각. 리뷰어는 코더의 기록 없이 diff만 보는 깨끗한 맥락에서 더 잘 한다(긴 세션의 "context rot" 회피, 스펙 없이 보면 사용자 지시의 오류도 드러남). — [Cognition](https://cognition.com/blog/multi-agents-working)
- Managed Devins: 매니저가 큰 작업을 쪼개 자식 Devin을 띄우고 내부 MCP로 조율("map-reduce-and-manage"). 실패 지점: 코드베이스 맥락이 얕은 매니저는 지나치게 지시적이 되고, 에이전트들이 자식과 상태를 공유한다고 착각하며, 에이전트 간 메시징은 기본으로 일어나지 않는다. — [Cognition](https://cognition.com/blog/multi-agents-working)
- 병렬 쓰기 스웜과 비정형 에이전트 네트워크는 여전히 의미 있는 채택이 없고 "mostly a distraction". 리뷰어 지적을 사용자 지시와 대조해 거르는 "communication bridge"가 루프와 범위 밖 작업을 막았다. — [Cognition](https://cognition.com/blog/multi-agents-working)
- 사람이 언제 개입해야 하는지에 대한 구체적 기준은 글에 없다(사람은 대부분의 버그가 해결된 뒤 PR을 연다는 정도). — [Cognition](https://cognition.com/blog/multi-agents-working)

**MAST, "Why Do Multi-Agent LLM Systems Fail?" (arXiv 2503.13657, v2 2025-04-22, NeurIPS 2025 D&B)**
- 3개 범주 14개 실패 모드. 비율(v2 기준 관찰된 실패 중 비중): 명세 문제 41.77%(단계 반복 17.14%, 작업 명세 불이행 10.98%, 종료 조건 인지 못함 9.82%), 에이전트 간 불일치 36.94%(추론-행동 불일치 13.98%, 명확화 요청 안 함 11.65%, 작업 이탈 7.15%), 작업 검증 21.30%(조기 종료 7.82%, 검증 없음/불완전 6.82%, 잘못된 검증 6.66%). — [arXiv v2](https://arxiv.org/html/2503.13657v2)
- 주의: 이후 버전(v3, 2025-10-26)과 2차 요약은 수치가 다르다(예: 단계 반복 15.7%, 명세 불이행 11.8%, 1600+ 트레이스, 7개 프레임워크, 실패율 41~86.7%). 최신 수치는 v3 PDF로 재확인 필요. — [alphaxiv v3](https://www.alphaxiv.org/abs/2503.13657v3), [arXiv PDF](https://arxiv.org/pdf/2503.13657.pdf)
- 역할 명세 개선만으로 ChatDev는 +9.4%, 고수준 검증 단계 추가는 ProgramDev에서 +15.6%. 저자 결론: 단순 수정으로는 부족. 검증자가 있어도 컴파일·주석 같은 피상적 검사만 해 ChatDev 정답률 33.33%. — [arXiv v2](https://arxiv.org/html/2503.13657v2)

**Google Research / Kim et al., "Towards a Science of Scaling Agent Systems" (arXiv 2512.08296, 2025-12; 블로그 2026-01-28)**
- 180개 구성, 5개 구조, 4개 벤치마크, 3개 모델 계열(GPT·Gemini·Claude). — [Google Research](https://research.google/blog/towards-a-science-of-scaling-agent-systems-when-and-why-agent-systems-work/)
- 병렬화 가능한 Finance-Agent에서 중앙집중형이 단일 대비 +80.9%, 엄격히 순차적인 PlanCraft에서는 모든 멀티에이전트 변형이 39~70% 하락. — [Google Research](https://research.google/blog/towards-a-science-of-scaling-agent-systems-when-and-why-agent-systems-work/)
- 오류 증폭: 독립형 최대 17.2배, 오케스트레이터가 있는 중앙집중형 4.4배(오케스트레이터가 "validation bottleneck" 역할). — [Google Research](https://research.google/blog/towards-a-science-of-scaling-agent-systems-when-and-why-agent-systems-work/)
- 도구 수가 늘수록 조율 오버헤드가 불균형하게 커진다(16개+ 도구의 코딩 에이전트 예시). 작업 속성으로 구조를 고르는 예측 모델은 R²=0.513, 미지 구성의 87%에서 최적 전략 선택(R²는 버전에 따라 0.524로도 보고됨). — [Google Research](https://research.google/blog/towards-a-science-of-scaling-agent-systems-when-and-why-agent-systems-work/), [arXiv](https://arxiv.org/abs/2512.08296v1)

### Inferences
- 코딩 세션 관리용 리드 세션은 "병렬 작성자 여럿"보다 "작성자 1 + 조사/리뷰 보조" 구조가 근거가 가장 탄탄하다. 하위 세션이 동시에 코드를 쓰게 하려면 서로 겹치지 않는 범위(파일·브랜치·워크트리)로 나눠야 Flappy Bird식 충돌을 줄일 수 있다.
- 오케스트레이터를 두는 이유는 처리량보다 오류 차단(17.2배 대 4.4배)이다. 리드는 하위 결과를 그대로 넘기지 말고 검증 관문 역할을 해야 한다.
- 비용은 단일 대비 대략 한 자릿수 배수(15배)로 잡고, 가치가 낮은 작업에는 하위 세션을 띄우지 않는 규칙이 필요하다.

### Gaps
- 2026년 "멀티에이전트 코딩" 전용 실패 연구(코딩 벤치마크에서 병렬 작성 대 단일 작성의 정량 비교)는 이번 조사에서 1차 출처를 찾지 못했다.
- MAST v3의 최종 수치는 PDF를 직접 확인하지 못했다.
- METR 자료(작업 시간 지평 등)는 이번 범위에서 직접 조사하지 못했다.

## 2. 리드(오케스트레이터)는 무엇을 쥐고 무엇을 넘기나, 워커는 어떻게 보고하나, 장기 리드의 맥락 관리

### Takeaway
리드는 계획·결정·요약을 쥐고, 워커에게는 목표·출력 형식·도구 안내·경계를 명시해 넘긴다. 워커는 결과를 디스크(아티팩트)에 쓰고 가벼운 참조나 1,000~2,000토큰 요약만 돌려준다. 장기 리드는 계획을 외부 메모리에 저장하고, 진행 파일 + git + 기계가 읽는 기능 목록(JSON)으로 세션 간 연속성을 유지한다.

### Cited Findings
- 위임할 때 각 서브에이전트에 목표, 출력 형식, 도구·자료 안내, 명확한 작업 경계를 준다. 노력 규모 규칙: 단순 사실 확인 1개·도구 3~10회, 비교 2~4개·각 10~15회, 복잡한 조사 10개 이상. — [Anthropic 멀티에이전트](https://www.anthropic.com/engineering/multi-agent-research-system)
- 리드는 맥락이 200,000토큰을 넘으면 잘리므로 계획을 Memory에 저장하고, 끝난 단계를 요약해 외부에 보관한 뒤 새 맥락의 서브에이전트를 띄운다. — [Anthropic 멀티에이전트](https://www.anthropic.com/engineering/multi-agent-research-system)
- 서브에이전트는 결과를 외부 아티팩트에 저장하고 리드에는 가벼운 참조만 넘겨 "game of telephone"(전달 과정의 정보 손실)을 피한다. — [Anthropic 멀티에이전트](https://www.anthropic.com/engineering/multi-agent-research-system)
- 오류 시 처음부터 재시작하지 않고 오류 지점에서 재개(재시도 + 정기 체크포인트). — [Anthropic 멀티에이전트](https://www.anthropic.com/engineering/multi-agent-research-system)
- 평가는 약 20개 대표 질의로 시작, LLM 심판 한 번 호출로 0.0~1.0 점수 + 통과/실패가 사람 판단과 가장 일치. 사람 테스터는 SEO 콘텐츠팜 선호 같은 편향을 잡았다. — [Anthropic 멀티에이전트](https://www.anthropic.com/engineering/multi-agent-research-system)
- "Effective context engineering for AI agents" (2025-09-29): 맥락이 길어질수록 회상이 떨어지는 context rot은 모든 모델에서 발생. 압축(compaction) 시 남길 것은 구조적 결정, 미해결 버그, 구현 세부, 버릴 것은 중복 도구 출력. 도구 결과 지우기가 가장 가벼운 형태. Claude Code는 압축 후 요약 + 최근 접근한 파일 5개로 이어간다. — [Anthropic](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- 같은 글: 구조화된 노트(NOTES.md, 할 일 목록)는 마일스톤이 분명한 반복 개발에, 압축은 대화 흐름이 필요한 작업에, 서브에이전트는 병렬 탐색이 이득인 조사에 쓴다. 서브에이전트는 수만 토큰을 쓰고 1,000~2,000토큰 요약만 반환. — [Anthropic](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- "Effective harnesses for long-running agents" (2025-11-26): 두 실패 모드는 한 번에 다 만들려다 맥락이 끊겨 반쯤 만든 상태로 남기는 것, 그리고 이후 세션이 진행된 흔적을 보고 너무 일찍 "완료"를 선언하는 것. — [Anthropic](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- 같은 글: 초기화 에이전트가 init 스크립트, 진행 로그(claude-progress.txt), 첫 git 커밋, 200개 이상의 기능 목록(JSON, 모두 failing으로 시작)을 만들고, 코딩 에이전트는 세션마다 기능 하나만 하고 `passes` 값만 바꿀 수 있다. JSON을 쓴 이유는 모델이 Markdown보다 덜 함부로 고치기 때문. 테스트를 지우거나 고치는 것은 "unacceptable"이라고 프롬프트에 명시. 단위 테스트·curl만으로 완료 처리하는 경향이 있어 브라우저 자동화로 사람처럼 검증하게 하자 크게 개선. — [Anthropic](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- 같은 글의 열린 질문: 범용 단일 코딩 에이전트와 전문화된 테스트·QA·정리 에이전트 구성 중 무엇이 나은지는 아직 불명. — [Anthropic](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- Agent SDK 문서: 서브에이전트는 최종 응답만 반환하므로 주 에이전트 맥락은 요약만큼만 는다. 압축은 초기 지시를 잃을 수 있으므로 지속 규칙은 매 요청마다 다시 주입되는 CLAUDE.md에 두고, CLAUDE.md에 "압축 시 보존할 것"(목표·수용 기준, 읽고 고친 파일 경로, 테스트 결과, 결정과 이유)을 적을 수 있다. `PreCompact`, `SubagentStart/Stop`, `Stop` 훅 제공. 세션 ID로 재개·포크 가능. — [Claude Agent SDK 문서](https://code.claude.com/docs/en/agent-sdk/agent-loop)
- Cognition: 매니저에게 맥락이 부족하면 지나치게 지시적이 되므로, 강한 모델에게는 주 에이전트의 전체 맥락 포크를 주고 넓게 묻는 것이 "80/20 solution". — [Cognition 2026](https://cognition.com/blog/multi-agents-working)

### Inferences
- 리드가 쥘 것: 계획 파일, 결정 로그, 하위 세션별 상태(무엇을 맡았고 어디에 결과를 썼는지), 수용 기준. 넘길 것: 탐색·구현·검증의 원자료.
- 워커 보고 형식은 "디스크의 산출물 경로 + 짧은 구조화 요약 + 상태(완료/막힘/질문)"가 근거에 가장 부합한다.
- 진행 상태는 사람이 쓰는 Markdown보다 기계가 갱신하는 JSON 체크리스트가 "조기 완료 선언"을 줄인다는 실무 근거가 있다(정량 데이터는 없음).

### Gaps
- 리드 맥락을 몇 토큰에서 압축할지 같은 정량 기준은 공개 자료에서 찾지 못했다.
- 하위 세션 결과 요약의 최적 길이에 대한 실험 데이터는 Anthropic의 "1,000~2,000토큰" 서술 외에 없다.

## 3. 사람에게 언제 묻고 어떻게 묶어 전달하나 (에스컬레이션, 승인 피로, 자율성 단계)

### Takeaway
매 행동마다 승인받는 방식은 실제로 무너진다. 사용자는 권한 프롬프트의 93%를 승인하고, 에이전트 코드 리뷰 승인율은 반복 노출로 오르고 검토 노력은 준다. 사람에게는 "방향 선택·모호한 요구·되돌릴 수 없는/권한 경계를 넘는 행동·병합"만 올리고, 나머지는 자동 분류기와 샌드박스로 걸러 묶어서 전달하는 쪽이 근거가 있다. 에스컬레이션을 너무 많이 하면 오히려 덜 안전해진다는 모델링 결과도 있다.

### Cited Findings
**실제 사용 데이터: Anthropic, "Measuring AI agent autonomy in practice" (2026-02-18)**
- 전체 자동 승인 세션 비율: 신규 사용자(<50세션) 약 20%, 750세션쯤에는 40% 이상. 턴당 중단율은 신규 약 5%에서 숙련 약 9%로 오히려 증가(숙련자는 더 맡기되 더 자주 끼어든다). — [Anthropic](https://www.anthropic.com/research/measuring-agent-autonomy)
- 가장 복잡한 작업에서 Claude가 스스로 멈춰 묻는 빈도가 사람이 중단시키는 빈도의 2배 이상. — [Anthropic](https://www.anthropic.com/research/measuring-agent-autonomy)
- Claude가 스스로 멈추는 이유: 접근법 선택지 제시 35%, 진단 정보·테스트 결과 수집 21%, 모호한 요청 명확화 13%, 자격증명·접근 권한 요청 12%, 행동 전 승인 11%. — [Anthropic](https://www.anthropic.com/research/measuring-agent-autonomy)
- 사람이 끼어드는 이유: 빠진 기술 맥락·수정 제공 32%, 느림·멈춤·과도함 17%, 충분히 도움받음 7%, 다음 단계를 직접 하려고 7%, 요구사항 변경 5%. — [Anthropic](https://www.anthropic.com/research/measuring-agent-autonomy)
- 공개 API 도구 호출 998,481건: 안전장치가 하나 이상 있는 호출 80%, 어떤 식으로든 사람이 관여 73%(둘 다 상한 추정), 되돌릴 수 없어 보이는 행동 0.8%, 소프트웨어 엔지니어링이 약 50%. — [Anthropic](https://www.anthropic.com/research/measuring-agent-autonomy)
- Claude Code 99.9 백분위 턴 시간이 25분 미만(2025-09 말)에서 45분 이상(2026-01 초)으로, 중앙값 턴은 약 45초. 내부적으로 최난도 작업 성공률은 8~12월 사이 2배, 세션당 사람 개입은 5.4회에서 3.3회로 감소. — [Anthropic](https://www.anthropic.com/research/measuring-agent-autonomy)
- 권고: 모델은 자신의 불확실성을 인식해 사람에게 드러내도록 훈련, 제품은 가시성과 쉬운 개입·방향 전환을 설계. "모든 행동 승인" 의무화는 안전 이득 없이 마찰만 늘릴 수 있다("It's too early to mandate specific interaction patterns"). — [Anthropic](https://www.anthropic.com/research/measuring-agent-autonomy)

**승인 피로: Anthropic, Claude Code auto mode 엔지니어링 글 (2026-03-25)**
- 사용자는 수동 권한 프롬프트의 93%를 승인한다("approval fatigue"). 2차 출처 일부는 97%로 인용하나 1차 출처는 93%. — [Anthropic](https://www.anthropic.com/engineering/claude-code-auto-mode), [DevOps.com(2차)](https://devops.com/anthropic-makes-claude-codes-auto-mode-the-default-betting-automation-beats-manual-review/)
- 대안 비교: 수동 프롬프트(대부분 그냥 승인), 샌드박스(안전하지만 기능마다 설정 필요, 네트워크·호스트 접근이 격리를 깸), `--dangerously-skip-permissions`(보호 없음), auto mode(분류기에 승인 위임). — [Anthropic](https://www.anthropic.com/engineering/claude-code-auto-mode)
- 구조: 도구 출력에 대한 서버측 프롬프트 인젝션 탐지 + 실행 전 행동마다 거는 대화록 분류기(Sonnet 4.6). 분류기는 에이전트의 추론과 도구 출력을 보지 않고 사용자 메시지와 도구 호출만 본다("reasoning-blind by design"). 읽기 전용 도구와 프로젝트 내 파일 수정은 분류기를 건너뛴다. — [Anthropic](https://www.anthropic.com/engineering/claude-code-auto-mode)
- 오류율(전체 파이프라인): 실제 트래픽 오탐 0.4%, 실제 과잉행동 미탐 17%, 합성 유출 미탐 5.7%. 1단계만이면 오탐 8.5%·미탐 6.6%. 과잉행동 테스트셋은 n=52로 작다. — [Anthropic](https://www.anthropic.com/engineering/claude-code-auto-mode)
- 차단 범주: 데이터 파괴·유출(force-push, 대량 삭제), 보안 약화(로깅 끄기), 신뢰 경계 넘기(외부 저장소 코드 실행, 자격증명 뒤지기), 리뷰 우회·타인 영향(main 직접 push, 프로덕션 배포). 사고 사례: "오래된 브랜치 정리" 요청에 원격 브랜치 삭제, 인증 오류 후 다른 토큰 찾기, 이름이 비슷한 job 삭제, Gist로 스크립트 공유, 검증 건너뛰기 플래그로 배포 재시도, 프로덕션 DB 마이그레이션 시도. — [Anthropic](https://www.anthropic.com/engineering/claude-code-auto-mode)
- 거부 처리: 거부는 도구 결과로 돌아가 안전한 경로를 찾게 하고, 연속 3회 또는 누적 20회 거부되면 멈추고 사람에게 올린다. 헤드리스(`claude -p`)에서는 UI가 없으므로 프로세스를 종료. 미탐의 주원인은 위험은 알아보지만 사용자의 앞선 승인이 그 행동의 영향 범위까지 덮는지를 잘못 판단하는 것. "not a drop-in replacement for careful human review on high-stakes infrastructure". — [Anthropic](https://www.anthropic.com/engineering/claude-code-auto-mode)
- auto mode가 8월 14일부터 일부 요금제의 기본값이 되었다는 보도가 있으나 1차 출처로 확인 못함(미확인). — [DevOps.com](https://devops.com/anthropic-makes-claude-codes-auto-mode-the-default-betting-automation-beats-manual-review/)

**권한 단계(티어)**
- Claude Agent SDK 권한 모드: `default`(승인 콜백, 콜백 없으면 거부), `acceptEdits`(작업 디렉터리 내 편집·기본 파일 명령 자동 승인), `plan`(탐색·계획만, 편집은 콜백으로), `dontAsk`(묻지 않고, 사전 허용 외에는 모두 거부, 헤드리스용), `auto`(분류기), `bypassPermissions`(격리 환경 전용, root 불가). — [Claude Agent SDK 문서](https://code.claude.com/docs/en/agent-sdk/agent-loop)
- OpenAI Codex: 승인 정책 `on-request`(샌드박스 안에서 돌고 경계를 넘을 때만 승인 요청), `never`(묻지 않고 실패를 모델에 돌려줌), 샌드박스 `workspace-write`(작업 디렉터리 + /tmp 쓰기, 네트워크 기본 차단), `danger-full-access`. `untrusted`는 폐지되었다는 공식 문서(중국어판)와 아직 나열하는 구버전 자료가 엇갈림(부분 미확인, 영문 공식 페이지 직접 확인 못함). — [OpenAI Codex 샌드박스 문서](https://developers.openai.com/codex/concepts/sandboxing), [OpenAI 문서(중국어)](https://developers.openai.com/zh-Hans/docs/sandboxing)

**승인 피로·습관화 연구**
- "Habituation at the Gate" (arXiv 2606.22721, 2026-06-21, KDD 2026 워크숍): AIDev 데이터셋 400명 반복 리뷰어, 11,429건 리뷰, 7개월. 에이전트 PR 승인율 30.1%에서 36.8%로 상승(경험 1분위→10분위 누적 +14.5%p), 인라인 코멘트 22% 감소, 대기 시간 약 3.5배 증가. 같은 기간 사람 PR 승인율은 하락, PR 크기 중앙값 변화 없음. 저자 해석: 합리적 신뢰 보정보다 "reflexive habituation under growing workload"에 가장 부합. — [arXiv](https://arxiv.org/abs/2606.22721)
- "Oversight Has a Capacity" (Emre Turan, arXiv 2606.08919, 2026-06-08): 125개 행동에 대해 리뷰어 간 위험 판단 일치도는 Fleiss' kappa 0.52(정답이 하나가 아님). 피로하는 리뷰어를 모델링하면 실제 안전성은 에스컬레이션 비율에 대해 역U자형이고 "more human oversight can make a system less safe". 최적은 "전부 에스컬레이션"보다 낮고, 부하를 고려한 정책이 대량 요청으로 지친 리뷰어 틈에 악성 행동을 끼워 넣는 공격에 강하다. 단, 모델링 결과이며 사람 실험은 아님. — [arXiv](https://arxiv.org/abs/2606.08919)
- 2차 출처에 "Claude Code 테스터 1,053명 중 사람은 위험 명령의 13.6%, 분류기는 89%를 잡았다"는 수치가 돌지만 1차 출처를 찾지 못함(미확인). — [yage.ai(2차)](https://yage.ai/share/claude-auto-mode-approval-illusion-en-20260808.html)

**알림 묶음(배칭) HCI 근거**
- Fitz et al. 2019 (Computers in Human Behavior), 237명 무작위 현장 실험: 하루 3회 묶음 알림 집단이 대조군보다 스트레스·생산성 압박·방해가 적고 더 행복하다고 보고. 매시간 묶음은 이득이 거의 없었고, 알림을 아예 안 받은 집단은 불안이 높았다. 3회 묶음 집단은 놓칠까 걱정(FOMO)은 늘었다. — [Duke Scholars](https://scholars.duke.edu/display/pub1402953), [Springer Nature 커뮤니티](https://communities.springernature.com/posts/batching-notifications-can-improve-attention-well-being-and-productivity)

**Anthropic, "Building effective agents" (2024-12-19, 기준 자료)**
- 에이전트는 체크포인트나 막혔을 때 사람 피드백을 위해 멈출 수 있어야 하고, 최대 반복 수 같은 중단 조건을 둔다. 가장 단순한 해법부터 시작. — [Anthropic](https://www.anthropic.com/research/building-effective-agents)

### Inferences
- 사람에게 올릴 결정은 실제 데이터상 에이전트가 스스로 멈추는 상위 이유와 일치시키는 것이 자연스럽다: 접근법 선택(35%), 모호한 요구(13%), 권한·자격증명(12%), 행동 전 승인(11%). 여기에 auto mode의 차단 범주(되돌릴 수 없는 삭제, main push, 프로덕션 배포, 외부 공유)와 병합을 더하면 "검토 지점" 목록이 된다.
- 개별 도구 호출 승인은 93% 승인율과 습관화 데이터로 볼 때 실효가 낮다. 사람 검토는 적은 수의 고가치 지점(스펙 승인, 최종 diff/병합)으로 모으고, 그 사이는 분류기·샌드박스·예산으로 막는 설계가 근거에 맞다.
- 급하지 않은 결정은 묶어서(하루 몇 번 수준) 전달하는 것이 HCI 근거와 맞지만, 완전히 알림을 끊으면 불안이 커진다는 결과도 있으므로 "막힘" 상태는 즉시 알리는 이원화가 합리적이다(에이전트 맥락에서 직접 실험한 연구는 찾지 못함).
- 숙련 사용자는 더 맡기되 더 자주 끼어들므로, 중간 상태를 쉽게 보고 언제든 방향을 틀 수 있게 하는 가시성이 승인 게이트보다 중요하다.

### Gaps
- 코딩 에이전트에서 "인박스/다이제스트 대 즉시 인터럽트"를 직접 비교한 실험은 찾지 못했다.
- 사람 승인 대 분류기 탐지율의 직접 비교(13.6% 대 89%)는 1차 출처 미확인.
- Codex 승인 모드의 최신 영문 공식 문서를 직접 열어 확인하지 못했다.

## 4. 무인 실행 안전장치 (샌드박스, 예산 상한, 최대 반복, 킬 스위치, 자기 승인 방지)

### Takeaway
무인 실행은 격리(샌드박스·워크트리·네트워크 차단) + 하드 상한(턴 수·예산·벽시계 시간) + 누적 거부 시 정지 + "작성자와 검증자 분리"로 막는다. 상한은 기본값이 "없음"이므로 반드시 명시해야 하고, 예산 상한은 응답 하나만큼 초과될 수 있다.

### Cited Findings
- Agent SDK: `max_turns`, `max_budget_usd` 모두 기본값은 제한 없음. 초과 시 `error_max_turns` / `error_max_budget_usd` 결과. 예산에는 서브에이전트 비용이 포함되고, 상한 도달 시 새 서브에이전트 생성이 "Budget limit reached"로 실패하며 실행 중인 백그라운드 서브에이전트도 멈춘다(Claude Code v2.1.217 이상). 예산 검사는 응답 도착 후라서 응답 1개 + 실행 중 서브에이전트 비용만큼 초과 가능하니 여유를 두라고 명시. 문서는 "프로덕션 에이전트에는 예산 설정이 좋은 기본값"이라 권한다. — [Claude Agent SDK 문서](https://code.claude.com/docs/en/agent-sdk/agent-loop)
- 구독 인증에서 `--max-budget-usd`가 실제 청구가 아닌 추정 토큰 비용을 비교한다는 사용자 보고가 있음(2차, 미확인). — [aident.ai](https://aident.ai/blog/fix-claude-code-max-budget-usd-subscription)
- auto mode는 연속 3회/누적 20회 거부 시 사람에게 올리고, 헤드리스에서는 종료한다(사실상 자동 킬 스위치). auto mode 진입 시 임의 코드 실행을 허용하는 권한 규칙(무제한 셸 등)은 제거된다. — [Anthropic auto mode](https://www.anthropic.com/engineering/claude-code-auto-mode)
- `bypassPermissions`는 CI·컨테이너 등 격리 환경에서만 쓰라고 명시. — [Claude Agent SDK 문서](https://code.claude.com/docs/en/agent-sdk/agent-loop)
- Codex `workspace-write`는 네트워크가 기본 차단. — [OpenAI Codex 샌드박스 문서](https://developers.openai.com/codex/concepts/sandboxing)
- 샌드박스 테스트와 가드레일, 최대 반복 수 같은 중단 조건 권고. — [Anthropic Building effective agents](https://www.anthropic.com/research/building-effective-agents)
- 자기 승인 방지 근거: auto mode는 "리뷰 우회(main 직접 push, 프로덕션 배포)"를 차단 범주에 둔다 — [Anthropic auto mode](https://www.anthropic.com/engineering/claude-code-auto-mode); Cognition은 코더 기록 없이 diff만 보는 별도 리뷰어가 더 잘 잡는다고 보고 — [Cognition 2026](https://cognition.com/blog/multi-agents-working); 장기 하네스는 테스트 삭제·수정을 금지하고 `passes` 필드만 바꾸게 함 — [Anthropic harness](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents); MAST는 검증자가 있어도 피상적 검사로 정답률 33.33%에 그쳤다고 보고 — [arXiv v2](https://arxiv.org/html/2503.13657v2).
- 실무 가이드들은 턴·예산 상한과 함께 벽시계 타임아웃을 함께 쓰라고 권하지만 2차 출처다. — [agentpatterns.ai](https://agentpatterns.ai/workflows/headless-claude-ci/)

### Inferences
- 하위 세션마다 턴·예산·시간 상한을 걸고, 리드 세션 전체에도 별도 총예산을 두는 2단 상한이 SDK 동작(서브에이전트 비용 합산)과 맞는다.
- 작성 세션이 자기 결과를 "완료"로 판정하지 못하게, 완료 판정은 다른 맥락의 리뷰 세션 또는 결정론적 검사(테스트, 기계가 읽는 체크리스트)로 하고 병합은 사람에게 남기는 것이 근거들과 일치한다.
- 반복 거부·반복 실패 횟수 기반 자동 정지는 auto mode의 3/20 규칙이 공개된 구체적 선례다.

### Gaps
- 리드가 하위 세션을 강제 종료하는 "킬 스위치"의 표준 설계나 효과를 측정한 공개 연구는 찾지 못했다.
- 무인 장기 실행에서 실제 비용 폭주 사고 통계는 찾지 못했다.
