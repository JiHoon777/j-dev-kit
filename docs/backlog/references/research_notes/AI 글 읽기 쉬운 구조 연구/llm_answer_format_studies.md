# LLM 답변의 형식·구조가 사람의 이해·선호·신뢰에 미치는 영향: 실증 연구 노트

(조사일 2026-11-25. 대부분 원문은 arXiv/ACL/저널/LMSYS 블로그에서 직접 읽었다. ACM DL 원문 두 편(Kim et al. CHI 2025, "Too Long to Read?")은 403이 떠서 초록과 저자 페이지만 봤다. 아래에 그렇게 표시했다.)

## 1. 선호 평가의 스타일·형식 편향 (Chatbot Arena 스타일 컨트롤, 길이 편향, 마크다운 편향). 선호되는 형식이 곧 더 잘 이해되는 형식인가?

### Takeaway
측정된 사실: 사람과 LLM 평가자 모두 길고, 리스트·볼드·헤더가 많고, 단정적인 답을 더 좋아한다. Arena에서는 길이 효과가 마크다운 효과보다 약 8~10배 크다. 다만 이 연구들은 모두 **선호**(표 던지기, 승률)를 쟀을 뿐 **이해도**는 재지 않았다. 사람이 고르는 형식이 이해를 돕는다는 증거는 이 연구들에 없다. 오히려 스타일이 사실 오류를 가린다는 증거가 있다.

### Cited Findings
- **LMSYS "Does style matter?" (Li, Angelopoulos, Chiang, 2024-08-29).** Bradley-Terry 회귀에 스타일 변수 네 개를 넣었다. 답변 토큰 길이, 마크다운 헤더 수, 볼드 수, 리스트 항목 수이고, 각각 (A−B)/(A+B)로 정규화했다. 둘 다 통제했을 때 계수는 길이 0.249, 리스트 0.031, 헤더 0.024, 볼드 0.019였다. 마크다운만 통제하면 리스트 0.111, 헤더 0.044, 볼드 0.056이었고, 길이만 통제하면 길이 0.267이었다. 저자는 마크다운 효과를 "부차적(second order)"이라고 불렀다. — [LMSYS blog](https://lmsys.org/blog/2024-08-28-style-control)
  - 순위 변화(Overall, 기준 → 둘 다 통제). 떨어진 모델: grok-2-mini 6→18, gpt-4o-mini 6→11, gemini-1.5-pro-api-0409 11→18. 오른 모델: claude-3-5-sonnet 6→4, claude-3-opus 16→10, gpt-4o-2024-05-13 5→2. Hard Prompt에서는 claude-3.5-sonnet 2→1, gpt-4o-mini 4→11. — [LMSYS blog](https://lmsys.org/blog/2024-08-28-style-control)
  - 저자가 밝힌 한계: 관찰 연구라 인과를 주장할 수 없다. 길이는 실제 품질(예: 추론 문제의 chain-of-thought)과 상관될 수 있다. 무작위 시험은 향후 과제로 남겼다. 배틀 수는 글에 적혀 있지 않다. — [LMSYS blog](https://lmsys.org/blog/2024-08-28-style-control); 같은 내용의 재게시본: [arena.ai](https://arena.ai/blog/style-control/)
  - 후속 "Sentiment Control"은 이모지 수와 감성 범주를 변수로 추가했다. — [LMArena news](https://news.lmarena.ai/sentiment-control)
- **"From Lists to Emojis: How Format Bias Affects Model Alignment" (Zhang, Xiong, Chen, Zhou, Huang, Zhang; arXiv 2409.11704, ACL 2025 Long).** 아래는 선호된 답 대 비선호 답에서 각 패턴이 나온 비율이다.
  - LMSYS-Arena(사람 라벨): 볼드 7.61% 대 4.54%, 리스트 38.84% 대 31.67%, 느낌표 18.52% 대 15.77%, 평균 길이 191.6 대 159.8단어.
  - AlpacaEval(GPT-4 라벨): 볼드 42.76% 대 16.78%, 리스트 61.73% 대 49.96%, 길이 325.4 대 239.4단어.
  - 사람과 GPT-4 모두 긴 답, 볼드, 리스트, 느낌표, 긍정적 어조를 선호했고 GPT-4 쪽이 더 강했다. 이모지·링크 선호는 GPT-4에서만 뚜렷했다. — [arXiv HTML v2](https://arxiv.org/html/2409.11704v2); [ACL Anthology](https://preview.aclanthology.org/setup/2025.acl-long.1308)
  - 편향 주입 실험에서는 볼드를 넣은 데이터 0.70%만 섞어도 보상모델의 볼드 승률이 57.5%에서 88.0%로 올랐다. 리스트 데이터 1.40%로는 51.0%에서 79.5%가 됐다. 저자는 형식을 바꾸는 편이 품질을 올리는 것보다 싸서 best-of-n이나 온라인 DPO에서 쉽게 악용된다고 결론지었다. — [arXiv HTML v2](https://arxiv.org/html/2409.11704v2)
  - 한계: 사람 편향은 통제 실험 없이 Arena 데이터의 패턴 빈도 비교로만 추정했다. 상관 분석이고 휴리스틱으로 셌다. **이해도는 재지 않았다.** — [arXiv HTML v2](https://arxiv.org/html/2409.11704v2)
- **Length-Controlled AlpacaEval (Dubois, Galambosi, Liang, Hashimoto; COLM 2024, arXiv 2404.04475).** GLM으로 길이 차이를 0으로 둔 반사실 선호를 예측해 길이를 보정한다. 보정 뒤 Chatbot Arena와의 Spearman 상관은 0.94에서 0.98로 올랐다. 자동 평가자가 길이를 편애한다는 점은 측정됐지만, 사람이 긴 답을 더 잘 이해하는지는 다루지 않았다. — [arXiv abs](https://arxiv.org/abs/2404.04475)
- **"Human Feedback is not Gold Standard" (Hosking, Blunsom, Bartolo; ICLR 2024).** 단정성과 복잡도를 조작한 답을 만들었다. 크라우드워커는 단정적인 답에서 사실 오류와 불일치 오류를 유의하게 덜 찾아냈다(전문가 라벨 기준으로는 오류가 있는 답이었다). 전문가는 복잡한 답일수록 오류가 적다고 판단했지만 크라우드워커의 추정은 복잡도에 따라 변하지 않았다. 단정적인 답이 선호되고 RLHF가 단정성을 키울 수 있다는 "예비 증거"도 냈다. — [arXiv 2309.16349](https://arxiv.org/abs/2309.16349); [ICLR poster](https://www.iclr.cc/virtual/2024/poster/19356)
- **"Style Over Substance" (Wu & Aji; COLING 2025, arXiv 2307.03025).** 사실 오류가 있는 답이 너무 짧은 답이나 문법 오류가 있는 답보다 더 좋게 평가됐다. 평가자는 크라우드워커, 전문가, GPT-4, Claude-1이었고 Elo 방식으로 점수를 냈다. 저자는 차원을 나눠 평가하는 Multi-Elo(MERS)를 제안했다. — [ACL Anthology](https://aclanthology.org/2025.coling-main.21); [arXiv](https://arxiv.org/abs/2307.03025)
- **Search Arena (Miroyan et al.; ICLR 2026, arXiv 2506.05334).** 대화 24,069개, 쌍 선호 12,652개. 인용이 정확히 연결된 경우 선호와의 연관은 β=0.285였고, **관련 없는 인용 수**도 β=0.273으로 비슷하게 양의 연관을 보였다. 응답 길이와 인용 수도 선호와 강하게 양의 상관이 있었다. 상관 분석이다. — [arXiv](https://arxiv.org/abs/2506.05334); [LMArena blog](https://arena.ai/blog/search-arena)

### Inferences
- 선호 데이터만 보면 "길게, 리스트·볼드 많이"가 이기지만, 이것을 이해·정확성 향상의 근거로 쓰면 안 된다. 이 연구들은 선호만 쟀고, Hosking·Wu&Aji는 스타일이 오류 탐지를 떨어뜨린다고 측정했다.
- 길이 효과(0.249)가 마크다운 효과(0.02~0.03)를 압도한다. "마크다운 남용"보다 "장황함"이 더 큰 평가 왜곡 요인이다.
- Arena에서 스타일 통제 뒤 순위가 오른 모델(Claude 계열)이 있다는 것은, 형식 장식이 적은 모델이 선호 점수에서 손해를 보고 있었다는 뜻으로 읽을 수 있다. 다만 관찰 데이터라 인과는 아니다.

### Gaps
- Arena 스타일 컨트롤 분석의 배틀 수와 신뢰구간은 블로그에 없다.
- 같은 내용을 형식만 바꿔 사람에게 무작위로 보여 주고 선호와 이해도를 **동시에** 잰 연구는 찾지 못했다. 그런 연구가 있어야 "선호 = 이해"를 직접 검증할 수 있다.

## 2. 불릿 vs 산문, 짧은 답 vs 긴 답, 헤딩 유무, 답 먼저 vs 설명 먼저: 이해도·과제 성공을 비교한 사용자 연구

### Takeaway
LLM 답변에서 같은 내용을 불릿과 산문으로, 헤딩 유무로, 답 먼저와 설명 먼저로 무작위 배정해 이해도를 비교한 통제 실험은 찾지 못했다. 가장 확실한 측정 결과는 **길이**다. 긴 설명은 확신만 올리고 정답 구별 능력은 올리지 않았다(Steyvers et al.). 구조화 효과는 소규모 정성 연구뿐이다.

### Cited Findings
- **Steyvers et al., "What large language models know and what people think they know" (Nature Machine Intelligence 2025; arXiv 2401.13835).**
  - 참가자는 실험 1이 41/39/42명, 실험 2가 60/60/59명, 실험 3이 40/41명이다(실험 1·2 합계 301명, Prolific 미국 원어민).
  - 조건: "long"은 길이 지시 없음, "short"는 최소 단어, "uncertainty only"는 근거를 빼고 확신 문구만 남김. 중앙값 단어 수는 GPT-3.5 객관식이 115 대 34, GPT-4o 단답이 95 대 24, uncertainty-only가 9였다.
  - 긴 설명은 짧은 설명보다 사람의 확신을 유의하게 높였다(BF=25). 짧은 설명도 확신 문구만 있을 때보다 확신을 높였다(BF>100).
  - 그러나 정답과 오답을 구별하는 능력(AUC)은 나아지지 않았다. long 0.54, uncertainty-only 0.57(BF=0.23, 차이 없음 쪽 증거).
  - 기본 설명을 받은 사람의 보정 오차(ECE)는 GPT-3.5 기준 0.264로 모델 자체 확신(0.104)보다 훨씬 나빴다. 설명 문구를 모델 확신에 맞추자 0.150으로 줄었다. AUC는 0.589에서 0.694로 올랐다.
  - 한계: 객관식·단답만 다뤘고, 비전문가 미국 참가자만 모집했다. — [arXiv HTML v2](https://arxiv.org/html/2401.13835v2); [Nature MI](https://www.nature.com/articles/s42256-024-00976-7)
- **"Too Long to Read? Restructuring LLM Responses for Users with Attention-Related Challenges" (ACM, Creativity & Cognition 2026으로 보임; DOI 10.1145/3803784.3816862).** 주의력 어려움이 있는 참가자 10명을 반구조화 인터뷰했다. 긴 응답을 접을 수 있는 날짜별 섹션과 시각적 위계로 바꾼 뷰를 7/10이 단계적 이해가 필요한 과제(공부 계획, 프로젝트 분해, 비교)에서 선호했다. 장황한 AI 응답이 이 집단에는 "불편"이 아니라 "사용 불가" 수준의 장벽이었다고 보고했다. 정성 연구이고 n=10, 이해도 측정은 없다. ACM 원문은 403이라 검색 요약과 프로젝트 페이지로 확인했다. — [ACM DL](https://dl.acm.org/doi/10.1145/3803784.3816862); [project page](https://personal-website-6cg.pages.dev/work/adapt-ai)
- **Auto-Slides (arXiv 2509.11062).** 연구자 24명이 불릿 기반 슬라이드 형식을 일반 LLM 채팅보다 시각적 명료성, 구조, 이해 지원에서 높게 평가했다. 형식 외에도 여러 요인이 함께 바뀌어 불릿 효과만 떼어 낼 수 없다(검색 요약 기준, 원문 미확인). — [arXiv](https://arxiv.org/pdf/2509.11062)
- **답 먼저 구조.** Kim et al.(CHI 2025)은 ChatGPT 응답이 대체로 "질문에 대한 답 다음에 설명"이라는 공통 구조를 따른다고 적었다. 그러나 순서를 바꿔 효과를 잰 것은 아니다(검색 요약 기준). — [ACM DL](https://dl.acm.org/doi/full/10.1145/3706598.3714020)
- **Si et al., "LLMs Help Humans Verify Truthfulness — Except When They Are Convincingly Wrong" (NAACL 2024).** 크라우드워커 80명. LLM 설명을 읽은 사람은 검색엔진 사용자보다 훨씬 빨랐고 정확도는 비슷했다. 그러나 설명이 틀렸을 때 과신했다. 참·거짓 양쪽 근거를 대는 대조 설명은 과의존을 줄였지만 검색엔진보다 확실히 낫지는 않았다. — [ACL Anthology](https://aclanthology.org/2024.naacl-long.81); [arXiv](https://arxiv.org/abs/2310.12558)

### Inferences
- "짧게 쓰라"는 권고는 근거가 비교적 탄탄하다. 길이는 확신만 키우고 판별력은 그대로 두므로, 길이를 늘리면 과신 위험만 커진다(Steyvers). 다만 Steyvers는 객관식·단답에서 잰 결과라 긴 설명이 필요한 과제로 일반화하기는 어렵다.
- 불릿·헤딩·답 먼저 배치의 효과는 LLM 맥락에서 실증 공백이다. 이 부분은 일반 문서 가독성 연구(웹 사용성, 멀티미디어 학습의 signaling/segmenting 원리)를 빌려 와야 하고, 보고서에 그렇게 밝혀야 한다.

### Gaps
- 불릿 대 산문, 헤딩 유무, 답 먼저 대 설명 먼저를 LLM 답변에서 무작위로 비교해 이해도나 과제 시간을 잰 연구는 찾지 못했다(검색 여러 번에서 나오지 않았다).
- 표 대 산문 비교 연구도 찾지 못했다.

## 3. LLM 출력의 가독성(가독성 점수, 장황함, "LLM-ese")과 사람이 LLM 답을 실제로 읽는 방식(아이트래킹, 훑어 읽기)

### Takeaway
의료 분야 연구들은 ChatGPT 기본 답변이 대학 수준 가독성(FKGL 약 12)으로, 환자 자료 권장 수준(6~8학년)보다 어렵다고 일관되게 측정했다. 쉽게 써 달라고 하면 가독성은 좋아지지만 정확성이 떨어질 수 있다. "LLM 특유 어휘"는 대규모 코퍼스에서 측정됐다. 아이트래킹 연구는 적고 소규모이며, 시선 지표는 신뢰 평가와 따로 움직였다.

### Cited Findings
- **이비인후과 (Eur Arch Otorhinolaryngol 2024).** 환자 질문 54개. ChatGPT 평균 FKGL은 약 12.1, 웹 검색은 9.4였다. 추가 프롬프트로 가독성이 나아졌다. — [PMC11410109](https://pmc.ncbi.nlm.nih.gov/articles/PMC11410109)
- **1차 진료 (PRiMER 2025).** 진단 10개에 대한 질문 40개를 GPT-4에 물었다. 평균 FRE 25.64, 중앙값 FKGL 12.61로 대학 졸업 수준이다. — [PRiMER](https://journals.stfm.org/primer/2025/rupareliya-2025-0022/)
- **소화기 분야.** 출력이 대학 수준 가독성이었다. — [PMC11596446](https://pmc.ncbi.nlm.nih.gov/articles/PMC11596446)
- **회전근개 (정형외과).** 기본 ChatGPT 답은 OrthoInfo나 6학년 수준 요청 답보다 FKGL이 높았다. 6학년 수준 답은 읽기는 쉬웠지만 정확성과 적절성이 떨어졌다. — [PMC11905972](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11905972/)
  - 위 연구들은 GPT-3.5/4(2023~2024) 기준이고, 전문 분야·프롬프트·모델 버전마다 다르다. 가독성 공식은 문장·단어 길이만 보는 대리 지표이고 실제 이해도를 잰 것이 아니다. — (같은 출처들)
- **"LLM-ese" 어휘: Kobak, González-Márquez, Horvát, Lause, "Delving into LLM-assisted writing in biomedical publications through excess vocabulary" (Science Advances 11(27), 2025-07-02).** PubMed 초록 1,500만 편 이상(2010~2024)을 분석했다. 2024년 초록의 최소 13.5%가 LLM을 거친 것으로 추정했다(arXiv 최신판, 일부 하위 코퍼스는 최대 30%). 과잉 사용 단어의 예로 delves(r=28.0), underscores(10.9), showcasing(10.2)이 있다. 과잉 단어 900개 목록을 공개했다. — [arXiv 2406.07016](https://arxiv.org/abs/2406.07016v5); [GitHub](https://github.com/berenslab/llm-excess-vocab)
  - 이 연구는 사용 빈도를 측정했을 뿐, 이런 어휘가 독자의 이해나 신뢰를 떨어뜨리는지는 재지 않았다.
- **"The Last Fingerprint: How Markdown Training Shapes LLM Prose" (arXiv 2603.27006).** 마크다운 학습이 LLM 산문에 남긴 흔적을 다룬다는 제목이 검색에 나왔다. 원문은 확인하지 못했다. — [arXiv](https://arxiv.org/pdf/2603.27006)
- **소스 표시 레이아웃 아이트래킹 (J. Eye Movement Research 2026, N=23, 대학생, 한국어 모의 화면).** 레이아웃 네 가지를 비교했다: 문장 끝 인라인 칩, 답 위 카드 리스트, 사이드 패널, 원시 하이퍼링크.
  - 첫 응시까지 시간: 카드 0.96초, 인라인 7.34초, 패널 11.17초, 링크 15.65초. 다중비교 보정 뒤 유의한 것은 카드 대비뿐이다.
  - 총 응시 시간: 패널 10.77초, 카드 9.11초, 인라인 4.87초, 링크 4.35초.
  - 최선 선택: 인라인 9명, 링크 1명(p=0.021). 순점수는 링크가 −7로 가장 낮았다.
  - 가독성, 신뢰성, 행동 의도는 레이아웃 간 유의한 차이가 없었다(모두 p≥0.155). 시선 지표와 신뢰도의 상관도 r=0.10(n.s.)이었다.
  - 한계: 구성개념마다 단일 문항, 제시 순서 불균형, 작은 표본(f≈0.27 이상만 탐지 가능). — [PMC13513764](https://pmc.ncbi.nlm.nih.gov/articles/PMC13513764/); [DOI](https://doi.org/10.3390/jemr19040089)
- **OASST-ETC (arXiv 2503.10927).** 참가자 24명이 OASST1의 LLM 응답을 읽는 동안 시선을 기록했다. 선호한 응답과 선호하지 않은 응답에서 읽기 패턴이 달랐다(검색 요약 기준, 세부 수치 미확인). — [arXiv](https://arxiv.org/abs/2503.10927)
- **AI 생성 콘텐츠 아이트래킹 체계적 문헌고찰 (2026).** 비교 연구 23편을 검토했다. 읽기 중심 연구는 소수였고, GPT 생성 자막·요약 등에서 응시·체류 시간이 더 길게 관찰됐다(검색 요약 기준). — [MDPI](https://www.mdpi.com/1995-8692/19/5/97)

### Inferences
- LLM 기본 출력은 일반 독자에게 어렵다(측정됨). 그러나 가독성을 낮추라는 프롬프트에는 정확성 손실이라는 대가가 있다(회전근개 연구). 쉬운 말만으로는 해결되지 않는다.
- 시선을 끄는 형식(카드, 패널)과 사람이 고르는 형식(인라인), 그리고 신뢰가 서로 따로 움직인다. "눈에 띄는 것 = 신뢰받는 것 = 선호되는 것"이 아니다.

### Gaps
- LLM 채팅 답을 사람이 훑어 읽는지(F-패턴 등) 직접 잰 아이트래킹 연구는 찾지 못했다.
- 가독성 점수 대신 실제 이해도 시험으로 LLM 답을 평가한 의료 연구도 찾지 못했다.
- "LLM-ese" 어휘가 독자의 신뢰나 인식에 미치는 영향을 잰 실험은 찾지 못했다.

## 4. 제시 방식(확신 어조, 불확실성 표현, 인용·출처, 설명)이 의존과 신뢰에 미치는 영향

### Takeaway
측정된 결과는 비교적 일관된다. (a) 1인칭 불확실성 표현은 과의존을 줄이고 정확도를 높인다. (b) 설명은 정답이든 오답이든 의존을 늘린다. (c) 정확한 출처와 드러난 불일치는 오답에 대한 과의존을 줄인다. (d) 인용은 관련이 없어도 선호를 높인다. (e) 단정적인 어조는 오류 탐지를 떨어뜨린다. 개입은 과의존을 줄이지만 "적절한 의존"까지 늘리지는 못하는 경우가 많다.

### Cited Findings
- **Kim et al., "'I'm Not Sure, But...'" (FAccT 2024, arXiv 2405.00623).** 사전등록한 집단 간 실험이다. N=404(MTurk, 656명 중 252명 제외), 예/아니오 의료 질문 8개, AI는 절반을 맞혔다.
  - 동의율: 통제 80.9%, 1인칭 불확실성 74.8%(p<.05), 일반 관점 불확실성 77.6%(n.s.).
  - AI에 대한 확신(1~5): 3.95 / 3.66(p<.01) / 3.80.
  - 정확도: 63.9% / 72.8%(p<.01) / 67.9%. AI 없이 푼 조건은 74.2%였다.
  - AI가 틀렸을 때 정확도: 33.0% / 47.8% / 40.1%. AI 없이 푼 조건은 64.7%였다.
  - 과제 시간 차이는 없었다(약 2.0~2.1분).
  - 한계: 불확실성 표현이 잘 보정되지 않았고, 단일 세션 예/아니오 과제이며, 미국 영어 사용자만 참가했다. — [ar5iv](https://ar5iv.labs.arxiv.org/html/2405.00623); [ACM](https://dl.acm.org/doi/fullHtml/10.1145/3630106.3658941)
- **Kim et al., "Fostering Appropriate Reliance on LLMs: The Role of Explanations, Sources, and Inconsistencies" (CHI 2025, arXiv 2502.08554).** 사고구술 연구 뒤 사전등록 통제 실험(N=308)을 했다.
  - 설명은 맞는 답과 틀린 답 모두에 대한 의존을 늘렸다.
  - 출처는 맞는 답에 대한 적절한 의존을 늘리고(설명보다는 약하게) 틀린 답에 대한 과의존을 줄였다.
  - 설명 안에 불일치가 있으면 틀린 답에 대한 과의존이 줄었다.
  - 효과 크기 수치는 원문(ACM 403)에서 확인하지 못했다. — [arXiv](https://arxiv.org/abs/2502.08554); [Microsoft Research](https://www.microsoft.com/en-us/research/publication/fostering-appropriate-reliance-on-large-language-models-the-role-of-explanations-sources-and-inconsistencies)
- **Bo, Wan, Anderson, "To Rely or Not to Rely?" (CHI 2025, arXiv 2412.15584).** N=400, LSAT 논리 문제와 이미지 수치 추정. 의존 개입 세 가지를 시험했다. 개입은 과의존을 줄였지만 적절한 의존은 대체로 늘리지 못했다. 일부 상황에서는 잘못 의존한 뒤에 오히려 확신이 커졌다(보정 악화). — [arXiv](https://arxiv.org/abs/2412.15584)
- **Steyvers et al. (Nature MI 2025).** 설명 문구를 모델의 내부 확신에 맞추면("I am not sure" / "somewhat sure" / "sure") 보정 격차와 판별 격차가 둘 다 줄었다(위 2절 수치). 그러나 사람의 정확도 자체는 나아지지 않았다. — [arXiv HTML v2](https://arxiv.org/html/2401.13835v2)
- **"Humans overrely on overconfident language models, across languages" (arXiv 2507.06306).** LLM은 영어에서 언어적으로 과신하는 경향이 있고, 사용자는 확신에 찬 생성물에 과의존했다(검색 요약 기준, 수치 미확인). — [arXiv](https://arxiv.org/pdf/2507.06306)
- **Hosking et al. (ICLR 2024).** 단정적인 답에서 평가자의 사실 오류 탐지율이 유의하게 떨어졌다(1절). — [arXiv](https://arxiv.org/abs/2309.16349)
- **Search Arena (ICLR 2026).** 관련 없는 인용 수도 선호와 양의 연관(β=0.273)을 보였다. 사용자가 인용의 존재 자체에 영향을 받을 수 있다는 뜻이다(1절). — [arXiv](https://arxiv.org/abs/2506.05334)
- **Si et al. (NAACL 2024).** 그럴듯한 틀린 설명에 과의존했다. 대조 설명은 과의존을 줄였다(2절). — [ACL Anthology](https://aclanthology.org/2024.naacl-long.81)

### Inferences
- 독자의 판단을 돕는 형식 장치로 측정 근거가 있는 것은 세 가지다. 정확한 확신 표시(특히 1인칭 hedge), 정확하고 관련 있는 출처, 반대 근거나 불일치를 드러내는 것. 반대로 길고 단정적이며 설명이 풍부한 답은 신뢰를 올리지만 판별력은 올리지 않는다.
- "인용을 많이 달면 신뢰받는다"는 측정됐지만 그것은 선호에 가깝고, 관련 없는 인용도 같은 효과를 냈다. 인용의 수가 아니라 정확성이 중요하다는 것은 Kim et al. CHI 2025의 "정확하고 관련 있는 출처" 권고와 일치한다.

### Gaps
- 효과 크기 수치(Kim et al. CHI 2025, Bo et al.)는 원문 본문을 열지 못해 확인하지 못했다.
- 대부분 미국 온라인 크라우드 표본의 단일 세션 객관식·예/아니오 과제다. 긴 자유 응답, 반복 사용, 한국어 사용자에 대한 연구는 찾지 못했다(소스 레이아웃 아이트래킹 연구만 한국어 화면을 썼고 n=23이다).
- Anthropic, OpenAI, DeepMind 연구 블로그에서 형식이 사용자 이해에 미치는 영향을 사용자 연구로 잰 공개 자료는 이번 조사에서 찾지 못했다(별도 검색을 하지는 않았다).
