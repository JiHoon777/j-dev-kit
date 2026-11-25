# 읽기 쉬운 글의 과학(가독성·쉬운 말·읽기 행동)과 AI/LLM 글에의 적용

조사일 2026-11-25. 각 항목은 출처 링크를 붙였다. 검색 요약이나 2차 자료로만 확인한 것은 그렇게 표시했다.

## Q1. 사람은 화면 글을 어떻게 읽는가 (NN/g 읽기 행동 연구), 그리고 AI 챗봇 답변 읽기 연구

### Takeaway
사람은 화면 글을 읽지 않고 훑는다. 간결·훑기 쉬운 구조·객관적 어조를 합치면 측정된 사용성이 124% 올랐다(1997). 2025~2026년 NN/g 질적 연구는 같은 원리가 AI 챗봇 답변에도 그대로 적용됨을 관찰했다: 답 먼저, 짧은 문단, 목록·굵게·제목, 군더더기·인사말 제거, 요청 시 더 주기("truncated pyramid").

### Cited Findings
**기초 연구: 간결·훑기·객관 (Morkes & Nielsen 1997)**
- 같은 내용의 7쪽 "Travel Nebraska" 사이트를 문체만 바꿔 5버전으로 만들고, 51명 피험자간 설계로 비교. 측정: 과제 시간, 오류, 기억(재인·회상), 사이트맵 그리기 시간·정확도, 주관 만족. 종합 점수는 다섯 지표 정규화 점수의 기하평균 — [NN/g, Concise, SCANNABLE, and Objective: How to Write for the Web](https://www.nngroup.com/articles/concise-scannable-and-objective-how-to-write-for-the-web/)
- 결과(홍보문 대조군=100): 간결 158(+58%), 훑기 쉬운 구조 147(+47%), 객관 어조 127(+27%), 셋 결합 224(+124%) — [같은 출처](https://www.nngroup.com/articles/concise-scannable-and-objective-how-to-write-for-the-web/)

**F-패턴과 다른 훑기 패턴 (NN/g 아이트래킹)**
- F-패턴: 위쪽을 가로로 읽고, 조금 아래에서 더 짧게 가로로 읽고, 왼쪽을 세로로 훑는다. 글에 서식이 없고 사용자가 효율을 원할 때 나타난다. 2006년 처음 보고, 2017년 47명 데이터로 11년 전과 같은 패턴 재확인(Kara Pernice, 2017-11-12) — [NN/g, F-Shaped Pattern of Reading on the Web: Misunderstood, But Still Relevant](https://www.nngroup.com/articles/f-shaped-pattern-reading-web-content/)
- 다른 패턴: layer-cake(제목·소제목만 훑고 본문 건너뜀), spotted(링크·숫자·특정 단어만 찾아 건너뜀), marking(모바일에서 시선 고정한 채 스크롤), bypassing(같은 말로 시작하는 목록 항목의 첫 단어를 건너뜀), commitment(거의 모든 글자를 봄, 동기가 높을 때만) — [같은 출처](https://www.nngroup.com/articles/f-shaped-pattern-reading-web-content/)
- 권고: 시각적으로 구별되고 가장 정보가 많은 단어로 시작하는 제목·소제목을 쓰면 F-패턴(비효율 훑기)을 막을 수 있다. (주의: 이 글은 layer-cake가 "가장 효과적"이라고 명시하지는 않는다. 그런 주장은 별도 layer-cake 글을 확인해야 함) — [같은 출처](https://www.nngroup.com/articles/f-shaped-pattern-reading-web-content/)
- 목록(bullet)은 훑기를 돕고 핵심을 강조하고 항목 간 관계를 드러내지만, 각 항목이 간결할 때 가장 유용하다. 항목이 길면 굵게 등 추가 서식이 필요하다 — [NN/g, Presenting Bulleted Lists](https://www.nngroup.com/articles/presenting-bulleted-lists/) (검색 요약으로 확인)

**AI 챗봇 답변 읽기 연구 (NN/g, 2025~2026, 질적 연구)**
- "Less Chat, More Answer: Site AI Chatbots Need to Get to the Point" (Maria Rosala, Georgia Kenderova, Tanner Kohler, 2026-04-17). 디지털·AI 숙련도가 다양한 9명이 사이트 챗봇 8개(Turo, Home Depot, Williams Sonoma, Scouting America, Redfin, 올림픽, 미시시피주 정부 등) 중 2~3개를 실제 과제로 사용 — [NN/g](https://www.nngroup.com/articles/less-chat-more-answer/)
  - 미시시피주 챗봇은 채팅창을 가득 채운 텍스트 덩어리를 돌려줬고 참가자는 압도당함. 스트리밍(글자가 흘러나오는 표시)은 더 나쁘게 느끼게 함. 직접 답 + 목록 + 제목을 쓴 Scouting America·Williams Sonoma 봇은 읽기 쉽다고 함. 권고: 문단은 "no more than 2–3 sentences" — [NN/g](https://www.nngroup.com/articles/less-chat-more-answer/)
  - 인사말·아첨은 마찰. 참가자는 인사 없이 정보만 준 Home Depot 봇을 칭찬 — [NN/g](https://www.nngroup.com/articles/less-chat-more-answer/)
  - "truncated pyramid" 모델 제안: 꼭 필요한 답과 필요한 단서만 주고, 추가 내용은 후속 제안으로. 스케이터 이름을 물었는데 점수·배경까지 받은 사례 — [NN/g](https://www.nngroup.com/articles/less-chat-more-answer/)
  - 못 하는 일은 첫 문장에 분명히. Redfin 봇은 한계를 첫 문장에 말했지만 대안을 둘째 문단에 둬서 참가자가 거기까지 가지 않음 — [NN/g](https://www.nngroup.com/articles/less-chat-more-answer/)
  - 일반론보다 구체적 답(범위·추정치). 구체적 답이 대체로 더 짧다(일반론은 여러 경우를 다 덮어야 하므로) — [NN/g](https://www.nngroup.com/articles/less-chat-more-answer/)
  - 결론: 답변의 모든 단어가 자리값을 해야 한다 — [NN/g](https://www.nngroup.com/articles/less-chat-more-answer/)
- "Product-Specific GenAI Needs to Write for the Web" (Taylor Dykes, 2025-04-04). 제품 내장 AI(Carvana Sebastian, Instagram AI 검색, Amazon Rufus)와 범용 도구(ChatGPT, Perplexity) 비교 관찰. 참가자 수 미기재 — [NN/g](https://www.nngroup.com/articles/genai-write-for-the-web/)
  - 범용 도구가 더 훑기 쉽고 읽기 쉬웠다(둘 다 완벽하진 않음) — [NN/g](https://www.nngroup.com/articles/genai-write-for-the-web/)
  - Rufus는 예/아니오형 질문에 장황하게 답해 여러 참가자가 요약·"TLDR"을 요청 — [NN/g](https://www.nngroup.com/articles/genai-write-for-the-web/)
  - 목록을 써도 들여쓰기가 없어 보통 문단처럼 보이면 훑기 실패. 굵게·기울임 부재 — [NN/g](https://www.nngroup.com/articles/genai-write-for-the-web/)
  - 역피라미드(답 먼저) 적용은 일관되지 않음. Perplexity는 대체로 답 먼저라 한 참가자가 그래서 선택했지만, 5G 예시에선 개요를 결론에 둠 — [NN/g](https://www.nngroup.com/articles/genai-write-for-the-web/)
  - 기본 질문에도 전문용어가 잦음. 6~8학년 읽기 수준 권고. 참가자: 전문용어가 "go over their heads" — [NN/g](https://www.nngroup.com/articles/genai-write-for-the-web/)
  - 사용자의 맥락에 맞춰 답의 길이·세부를 조절하라(ChatGPT는 되물어 필요를 확인) — [NN/g](https://www.nngroup.com/articles/genai-write-for-the-web/)
- "Response outlining" 연구: 참가자가 프롬프트에 구조·목록 형식을 지정하기도 하지만, 대개 첫 답이 불만족스러운 뒤에야 그렇게 함 — [NN/g, Response Outlining](https://www.nngroup.com/articles/response-outlining/) (검색 요약으로 확인)
- "Articulation barrier"(Jakob Nielsen, 2023): 프롬프트 기반 UI는 사용자가 원하는 것을 글로 잘 표현해야 쓸 수 있다. 선진국 인구 중 고급 사용이 가능할 만큼 글을 잘 쓰는 사람은 20% 미만(최빈 추정 10%)이라는 Nielsen의 추정 — 측정값이 아니라 그의 추정 — [Jakob Nielsen, The Articulation Barrier](https://jakobnielsenphd.substack.com/p/prompt-driven-ai-ux-hurts-usability); [UX Tigers](https://www.uxtigers.com/post/ai-articulation-barrier)

### Inferences
- 1997년 웹 글 원칙(간결·훑기·객관)과 2025~2026년 AI 챗봇 관찰이 같은 방향을 가리킨다. AI 답변에 새 원칙이 필요하다기보다 기존 웹 글쓰기 원칙을 적용하는 문제다.
- "Articulation barrier"는 입력(프롬프트) 쪽 문제지만, 출력 쪽에서도 사용자가 형식을 지정하지 않아도 기본값이 읽기 쉬워야 한다는 근거로 쓸 수 있다(response outlining 관찰과 같이).
- 스트리밍이 긴 덩어리 글을 더 나쁘게 만든다는 관찰은 채팅 UI 특유의 요인이다.

### Gaps
- NN/g "How Users Read on the Web"(1997, "79%가 훑고 16%만 한 단어씩 읽는다")과 역피라미드 글 원문은 이번에 직접 확인하지 못했다.
- NN/g AI 답변 연구는 소표본 질적 연구다(9명 등). AI 답변 서식(목록·굵게·제목)이 이해도·과제 성공에 주는 효과를 통제 실험으로 잰 연구는 찾지 못했다.
- layer-cake 패턴이 가장 효과적이라는 NN/g 원문 주장은 확인하지 못했다.

## Q2. 인지 부하·텍스트 이해 연구 (신호, 응집성, 덩어리 나누기, Mayer 원칙, Gopen & Swan)

### Takeaway
제목·강조 같은 신호(signaling)는 메타분석에서 학습에 작지만 일관된 이득을 보이고 인지 부하를 약간 줄인다. Gopen & Swan은 문장 안 위치(앞=맥락·옛 정보, 끝=강조·새 정보)와 주어-동사 근접을 "독자 기대"로 정리했다. 다만 이번 조사에서 효과 크기 수치는 1차 원문으로 확인하지 못했다.

### Cited Findings
- 신호 메타분석: Schneider, S., Beege, M., Nebel, S., & Rey, G. D. (2018). A meta-analysis of how signaling affects learning with media. *Educational Research Review*, 23, 1–24. 인용 논문에 따르면 신호가 있는 자료는 대체로 인지 부하를 낮췄으나 효과는 작았다 — [Springer, Cognitive Processing 2020 논문(이 메타분석 인용)](https://link.springer.com/article/10.1007/s10339-020-01002-5) (2차 인용)
- 신호는 조직 신호(제목·요약), 색, 글-그림 참조, 억양, 혼합형으로 나뉜다 — [같은 출처](https://link.springer.com/article/10.1007/s10339-020-01002-5) (검색 요약)
- 제목(headings)만 다룬 2020년 실험(대학생 51명): 제목이 기억과 이해를 높였다 — [Springer, Cognitive Processing 2020](https://link.springer.com/article/10.1007/s10339-020-01002-5) (검색 요약; 실험 세부 미확인)
- Richter, Scheiter & Eitel (2016) 메타분석: 글-그림 관계 신호는 작은~중간 이득, 사전 지식이 낮은 학습자에게 더 큼 — [검색 결과 요약, B2FIND 데이터셋](https://b2find.eudat.eu/dataset/edf0e3e7-9eee-56de-9e2f-904511bfe462) (2차)
- Schneider 등의 메타분석에 대한 독일어 요약(TUM Clearinghouse)이 하위군 수치를 제공 — [TUM Clearinghouse 요약 PDF](https://www.clearinghouse.edu.tum.de/wp-content/uploads/2018/12/CHU_KR-22_-Schneider_2017_Lernmaterial_Hervorhebungen.pdf) (수치 미확인)
- Gopen, G. D., & Swan, J. A. (1990). The Science of Scientific Writing. *American Scientist*, 78(6), 550–558 — [U. Michigan Sweetland PDF](https://prod.lsa.umich.edu/content/dam/sweetland-assets/sweetland-documents/Graduates/DWG/The-Science-of-Scientific-Writing.pdf); [Columbia 사본](https://www.cs.columbia.edu/~djhsu/coms6998-f17/science-of-writing.pdf)
  - 강세 위치(문장 끝)에서 독자는 종결·성취를, 주제 위치(문장 앞)에서는 관점·맥락을 기대한다. 강조할 새 정보는 끝에, 앞 문장과 잇는 옛 정보는 앞에 — [TU/e 인용 페이지](https://www.win.tue.nl/~wstomv/quotes/science-of-scientific-writing.html) (검색 요약)
  - 독자는 문장의 행위가 동사로 표현되길, 그리고 주어 뒤에 동사가 곧 나오길 기대한다(주어-동사 사이가 멀면 혼란) — [같은 출처](https://www.win.tue.nl/~wstomv/quotes/science-of-scientific-writing.html)
  - 2022년 리뷰: Gopen은 강조할 정보를 잘못된 위치에 두는 것을 명료한 글의 "주적"으로 봄. 후속 저서 *The Sense of Structure* (2004) — [PMC, Writing for the reader: Using reader expectation principles to maximize clarity (2022)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9391546/)
  - 주의: Gopen & Swan은 실험 연구가 아니라 편집 경험에 기반한 원칙 정리다.

### Inferences
- 신호(제목·굵게·목록)의 이득은 "작지만 일관된" 수준으로 보는 게 정직하다. AI 답변 서식에 과도한 효과를 기대하면 안 되고, 군더더기 제거·답 먼저 같은 내용 구조가 더 큰 몫을 할 수 있다(Morkes & Nielsen에서도 간결 +58% > 훑기 구조 +47%).
- Gopen & Swan의 "앞=맥락, 끝=새 정보"는 NN/g의 "정보가 많은 단어로 시작하는 제목"과 긴장이 있다. 문장 단위(이어 읽기)와 훑기 단위(제목·목록 첫머리)를 구분해 적용해야 한다는 추론.

### Gaps
- Schneider et al. (2018)의 효과 크기(유지·전이, 인지 부하 각각 g 값)를 원문으로 확인하지 못했다.
- Mayer 멀티미디어 학습 원칙 중 coherence(불필요한 내용 빼기)·segmenting(덩어리 나누기) 원칙의 메타분석 수치는 이번 세션에서 검색·확인하지 못했다. 보고서에 쓰려면 Mayer, *Multimedia Learning* (3판, 2021) 또는 Mayer & Fiorella 편 *Cambridge Handbook of Multimedia Learning* 확인 필요.
- 응집성(coherence, McNamara 등)과 사전 지식 상호작용 연구는 확인하지 못했다.

## Q3. 쉬운 말(plain language) 표준과 근거

### Takeaway
ISO 24495-1:2023은 쉬운 말을 "독자가 필요한 것을 얻는다(relevant)"를 첫 원칙으로 하는 국제 표준으로 정리했다. 쉬운 말의 효과 근거는 Kimble이 모은 실증 연구들이 대표적이며, 그의 요약으로는 이해도가 10~15%에서 100% 넘게 올랐다. 단 Kimble 본인의 정리라는 한계가 있다.

### Cited Findings
- ISO 24495-1:2023 Plain language — Part 1: Governing principles and guidelines. 쉬운 말 문서 작성을 위한 원칙과 지침, 그리고 그 해석·적용 방법을 정한다. 주로 텍스트 형태의 인쇄·디지털 정보에만 적용. 유료(CHF 135) — [ISO](https://www.iso.org/standard/78907.html); [EU AccessibleEU 소개](https://accessible-eu-centre.ec.europa.eu/content-corner/digital-library/iso-24495-12023-plain-language-part-1-governing-principles-and-guidelines_en)
- 원칙 1은 "Readers get what they need (relevant)" (목차의 5.1) — [ISO](https://www.iso.org/standard/78907.html); [DIN 목차](https://www.din.de/de/mitwirken/normenausschuesse/nat/veroeffentlichungen/wdc-beuth:din21:370015899/toc-3456451/download)
- Kimble: 독자는 법률 문체보다 쉬운 말을 강하게 선호하고, 더 잘·더 빨리 이해하고, 더 잘 따르고, 애초에 읽을 가능성이 더 높다(2016 Michigan Bar Journal) — [Michigan Bar Journal](https://www.michbar.org/file/barjournal/article/documents/pdf4article2972.pdf) (검색 요약)
- 여러 실증 연구에서 쉬운 말로 이해도가 "10-15% to over 100%" 향상, 읽는 속도도 빨라짐 — [plainlanguage.gov, The Arguments Against Plain Language Have Been Refuted](https://plainlanguage.gov/resources/articles/arguments-against-plain-language-have-been-refuted/)
- Kimble, *Writing for Dollars, Writing to Please* — 비즈니스·정부·법 분야 쉬운 말 실증 연구 모음(도서관 설명: 50개 연구 요약, 미확인) — [Scribes, Answering the Critics of Plain Language](https://scribes.org/wp-content/uploads/2022/12/Scribes_vol5_06_Answering_the_Critics_of_Plain_Language.pdf) (검색 요약)
- NN/g도 쉬운 말은 전문가 독자에게도 좋다고 주장("The Myth of Plain Language"는 전문가가 쉬운 말을 싫어한다는 통념을 다룸) — [NN/g, Plain Language Is for Everyone, Even Experts](https://www.nngroup.com/articles/plain-language-experts/) (제목·취지만 검색 결과로 확인)

### Inferences
- ISO 원칙 1이 "relevant(독자가 필요한 것)"라는 점은 NN/g의 "모든 단어가 자리값을 해야 한다", "truncated pyramid"와 맞닿는다. 쉬운 말 표준의 핵심은 단어 난이도보다 독자에게 필요한 정보 선택이다.

### Gaps
- ISO 24495-1의 나머지 세 원칙 이름(일반적으로 findable, understandable, usable로 알려짐)은 이번에 1차 자료로 확인하지 못했다. 보고서에 쓸 때 "일반적으로 알려진" 수준으로 표시하거나 ISO OBP 미리보기로 확인 필요.
- 미국 Plain Writing Act of 2010과 Federal Plain Language Guidelines의 세부 규칙(능동태, "you", 짧은 문장 등)은 이번 세션에서 1차 자료로 확인하지 못했다.
- Kimble이 모은 개별 연구를 독립적으로 검토한 리뷰는 찾지 못했다.

## Q4. 이 원칙을 LLM 글에 적용·검증한 연구

### Takeaway
통제된 사람 대상 실험이 2024~2025년에 나오기 시작했고, 결과는 일관되게 "LLM으로 쉽게 고친 글은 이해도를 올린다"이다(+3.9%p~+10.8%p, 일부 영역 +14.6%). 그러나 정보 누락·정확성 문제가 반복해서 보고되고, 자동 가독성 지표만으로 평가하면 안 된다는 경고가 공통적이다. 사람들은 이해가 더 잘 돼도 원문을 선호하기도 한다(60%).

### Cited Findings
**대규모 무작위 이해도 실험**
- Google Research, "LLM-based Text Simplification and its Effect on User Comprehension and Cognitive Load" (arXiv:2505.01980, 2025-05). 4,563명, 6개 분야 31개 글. 쉽게 고친 글을 읽은 집단이 객관식 정답률 3.9%p 높음(p<0.05). PubMed 글에서 +14.6%로 가장 큼, 금융·항공우주/컴퓨터과학·법률은 작음. 원문을 다시 볼 수 있든 없든 효과 유지(볼 수 없으면 두 집단 모두 최대 약 9% 하락). 간이 NASA-TLX로 잰 체감 용이성 5점 척도에서 +0.33(p<0.05) — [arXiv](https://arxiv.org/abs/2505.01980); [Google Research 블로그, Minimally-lossy text simplification with Gemini](https://research.google/blog/making-complex-text-understandable-minimally-lossy-text-simplification-with-gemini/)
  - 한계: 설문 플랫폼 모집 참가자라 실제로 복잡한 정보를 이해하려는 사용자와 다를 수 있음(블로그가 직접 언급) — [Google Research 블로그](https://research.google/blog/making-complex-text-understandable-minimally-lossy-text-simplification-with-gemini/)

**의료: 환자용 글**
- Chen, Rudin, Levine, Mehrotra. "Improving patient understanding of radiology reports using generative artificial intelligence: a vignette study of 2000 US adults." *JAMIA* 33(2):326–335 (온라인 2025-11-16). ChatGPT-4와 보고서 유형별 맞춤 프롬프트로 유방 영상·흉부 X선 보고서 20개를 쉽게 고침. 2024년 8월 미국 성인 2,000명이 원본 1개·AI 버전 1개를 무작위 배정으로 읽음. 이해 정확도 68.0% vs 58.0%(한계 차이 10.8%p, 95% CI 7.8–13.8), 후속 조치 정확도 64.5% vs 58.4%(6.8%p, 95% CI 4.1–9.4). 44세 초과·대졸 미만에서 이득이 더 큼. 자신감↑ 불안↓. 그러나 60.0%가 원본을 선호 — [Crossref 메타데이터/초록](https://api.crossref.org/works/10.1093%2FJAMIA%2FOCAF187)
- Zaretsky et al. "Generative Artificial Intelligence to Transform Inpatient Discharge Summaries to Patient-Friendly Language and Format." *JAMA Network Open* 7(3):e240357 (2024). 단면 연구, 퇴원 요약 50건을 GPT-4로 변환. Flesch-Kincaid 학년 11.0(SD 1.5) → 6.2(SD 0.5), P<.001. PEMAT 이해도 13% → 81%. 의사 검토에서 완전하다고 본 요약은 약 56%. 저자: 정확성·완전성·안전성 개선이 필요 — [JAMA Netw Open](https://jamanetwork.com/journals/jamanetworkopen/fullarticle/10.1001/jamanetworkopen.2024.0357); [NYU Langone 보도](https://nyulangone.org/news/artificial-intelligence-model-makes-doctors-notes-more-patient-friendly); [News-Medical 요약](https://www.news-medical.net/news/20240313/How-AI-can-make-a-more-patient-friendly-hospital-discharge-summary-for-patients.aspx) (56%·PEMAT 수치는 보도 기반)
- Mannhardt et al. (Sontag, Ghassemi 등). "Impact of Large Language Model Assistance on Patients Reading Clinical Notes: A Mixed-Methods Study" (arXiv:2401.09637, 2024, 동료심사 미확인). 단순화·정보 추출·맥락 추가 3종 보강. 건강한 여성 참가자 200명에게 보강 수준이 다른 노트 3개를 무작위 배정 → 후속 조치 이해 점수 "유의하게 증가". 유방암 환자 7명 인터뷰: 긍정적이지만 AI 우려. 임상의가 모델 오류 유형을 분석 — [arXiv](https://arxiv.org/abs/2401.09637)
- oncOPAL: 혈액종양 환자 대상 단일기관 무작위 시험(2:1, 의사가 검토한 LLM 쉬운 요약 vs 표준 편지), 1차 지표 PEMAT 기반 이해 점수. 등록만 확인, 결과 미확인 — [ClinicalTrials.gov NCT07519811](https://clinicaltrials.gov/study/NCT07519811)
- 근거 검토 요약(Cochrane·AHRQ 쉬운 말 요건으로 만든 프롬프트, Claude 2) 타당성 연구: 포괄성·정확성·가독성·문화 민감성 평가. 일반인 검토자 시험은 후속 과제로 남김 — [PMC11795904](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11795904/)

**정부·행정 글**
- Beks van Raaij, Kolkman, Podoynitsyna. "Clearer Governmental Communication: Text Simplification with ChatGPT Evaluated by Quantitative and Qualitative Research." DeTermIt 워크숍(LREC-COLING 2024). ChatGPT-3.5로 네덜란드 정부 편지를 쉽게 고치고 실제 독자 RCT로 검증. 이해 가능성 점수 20% 넘게 증가, 질문 정답 19% 증가. 자동 지표에만 의존하지 말라고 경고 — [ACL Anthology](https://aclanthology.org/2024.determit-1.15)
- 브라질 정부 법률 텍스트에 프롬프트 기법 5종 비교(2025): AI 모델이 가독성·이해도를 과대평가하는 경향 → 사람 검토를 섞은 방식 권고 — [SBSI 2025](https://sol.sbc.org.br/index.php/sbsi/article/download/41361/41131) (검색 요약)
- 이탈리아 행정 텍스트(CLiC-it 2024): GPT-3.5/GPT-4 등과 사람 단순화의 의미·복잡도 근접성 비교, 독자 실험은 아님 — [ACL Anthology](https://aclanthology.org/2024.clicit-1.91.pdf)

**평가 방법론**
- Wu & Arase: LLM 문장 단순화를 오류 기반 사람 평가로 분석. 자동 지표와 사람 평가 모두 신뢰도 문제 지적 — [arXiv:2403.04963](https://arxiv.org/html/2403.04963v4)

### Inferences
- 사람 대상 실험의 효과 크기는 영역 차이가 크다: 일반 혼합 영역 +3.9%p(Google), 의료 영상 보고서 +10.8%p(JAMIA), 의료 논문 +14.6%(Google 하위), 정부 편지 +19%(네덜란드). 원문이 어려울수록·독자 사전 지식이 낮을수록 이득이 커 보인다(JAMIA의 학력·연령 하위군, 신호 메타분석의 사전 지식 효과와 같은 방향).
- 공통 위험: 누락(Zaretsky 완전성 약 56%), 자동 지표 과신(네덜란드·브라질), 신뢰·선호 문제(60% 원본 선호). "쉽게"보다 "잃지 않고 쉽게"(Google의 minimally-lossy)가 핵심 설계 목표.
- 가독성 공식(Flesch-Kincaid) 점수 하락은 이해도 향상의 대리 지표일 뿐이며, 측정된 이해도 실험이 별도로 필요하다.

### Gaps
- LLM 답변의 서식(목록·제목·굵게)이나 "답 먼저" 구조 자체를 독립 변수로 두고 이해도를 잰 통제 실험은 찾지 못했다. 위 연구들은 대부분 "단순화(어휘·문장)"를 다룬다.
- Zaretsky 연구의 정확한 누락·오류 분류는 원문으로 확인하지 못했다(PMC 페이지 접근 차단).
- 프롬프트에 쉬운 말 지침(ISO·plainlanguage.gov)을 넣은 경우와 안 넣은 경우를 사람 이해도로 비교한 연구는 찾지 못했다.

## Q5. 한국어 연구·지침과 AI 적용

### Takeaway
한국에는 정부의 '쉬운 공공언어' 정책과 인식 조사가 있지만, 쉬운 말이 이해도·읽기 시간을 얼마나 바꾸는지 측정한 국립국어원 실험은 이번에 찾지 못했다. AI 적용은 LLM 기반 쉬운 말(이지리드) 변환을 자동 지표로 평가한 학술대회 논문과 정부 제안 수준에 머문다.

### Cited Findings
- 문화체육관광부는 공문서의 어려운 표현을 바로잡는 '쉬운 공공언어 사용 운동'을 추진 — [문화체육관광부](https://www.mcst.go.kr/site/s_policy/comm/studentNews/studentNewsView.jsp?pSeq=5235)
- 2020년 국민의 언어 의식 조사: 말의 의미를 몰라 곤란했던 경험 2015년 5.6% → 2020년 36.3% (검색 요약으로 확인, 원 보고서 미확인) — [정책브리핑](https://m.korea.kr/news/policyNewsView.do?newsId=148767446)
- 한 위원회가 AI로 외래어·전문용어 사용 현황을 분석하고, 전자결재·공문서 작성에서 어려운 외래어를 쓰면 쉬운 우리말을 추천하는 기능 도입 검토를 정부에 제안(도입 여부 미확인) — [뉴데일리 2025-08-28](https://www.newdaily.co.kr/site/data/html/2025/08/28/2025082800093.amp.html) (검색 요약)
- 문체부·국립국어원은 2025년 12월 24~30일 14~79세 3,000명 대상 '개선이 필요한 공공언어' 설문을 실시하고 2026년 2월 '개선이 필요한 공공언어 30선'을 발표 — [뉴데일리 2026-02-12](https://www.newdaily.co.kr/site/data/html/2026/02/12/2026021200088.amp.html) (검색 요약)
- 국립국어원 20년사: 중앙 부처·지자체·병원·보건소 서식 1,000여 종 조사, 행정안전부 서식 보완 기초 자료로 활용 — [국립국어원](https://korean.go.kr/niklintro2/20years05_03_01.jsp) (검색 요약)
- LLM 기반 한국어 쉬운 말(이지리드) 변환 평가(ACK 2024): 경계선 지능인 등을 위한 사기·부당 계약 문제 대응 목적, AI-Hub 데이터로 변환 성능 측정, 문장 복잡도·KoBERTScore로 가독성·의미 유사도 평가 방법론 제시. 사람 대상 이해도 실험은 요약에서 확인 안 됨 — [KoreaScience, ACK 2024](https://koreascience.or.kr/article/CFKO202433161719073.pdf) (검색 요약; 저자 미확인)
- 기고문: EU·영국·호주 등은 쉬운 정보를 공식 정보 제공 형식으로 인정하며, AI가 쉬운 정보 제작을 도우면 적용 범위를 넓힐 수 있다는 주장(의견) — [전자신문 기고 2025-11-21](https://www.etnews.com/20251121000305)

### Inferences
- 한국어에서는 "무엇이 어려운가"(어휘 목록·인식 조사)에 대한 자료는 있지만 "쉽게 쓰면 얼마나 더 이해하는가"의 측정 근거는 이번 조사에선 영어권 연구를 빌려 써야 한다.
- 한국어 AI 쉬운 말 연구는 자동 지표 중심이라, 영어권에서 나온 "자동 지표 과신 금지" 경고가 그대로 적용된다.

### Gaps
- 국어기본법 제14조(공문서 작성 시 알기 쉬운 용어·문장) 조문과 국립국어원 「쉬운 공공언어 쓰기」 안내서의 세부 기준은 이번 세션에서 1차 자료로 확인하지 못했다.
- 한국어 공공언어 이해도·읽기 시간 측정 실험(예: KCI의 공공언어 이해도 연구, 공공언어 개선의 경제적 효과 연구)은 찾지 못했다. koreascience 논문 PDF(JAKO201508556261853) 하나를 열었지만 텍스트 추출이 안 돼 내용 미확인.
- 한국어 AI 챗봇 답변의 서식·구조에 대한 사용자 연구는 찾지 못했다.
