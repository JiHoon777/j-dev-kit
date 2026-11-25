# AI 랩과 실무자가 말하는 "사람이 읽을 답의 형식·구조" 가이드

조사일: 2026-11-25. 인용은 모두 15단어 미만. 날짜는 원문에 적힌 것을 그대로 옮겼고, 원문에 없으면 "날짜 없음"으로 적었다.

## Q1. OpenAI Model Spec과 OpenAI 프롬프트 가이드는 형식·길이·직접성에 대해 무엇을 말하나

### Takeaway
2025년판 Model Spec(2025-12-18판에서 확인)은 "직답 먼저, 이유는 뒤", "형식은 훑어보기를 돕는 만큼만(judiciously)", "군더더기·과한 헤지·반복 금지", "기본은 Markdown"을 Guideline(맥락이 바꿀 수 있는 기본값)으로 둔다. 2026-10-29 개정은 세부 스타일 규칙 대부분을 걷어내고 맥락·사용자 피드백에 맡겼다고 보도됐지만, 개정본 본문은 확인하지 못했다. API 쪽 GPT-5 가이드는 반대로 "기본은 Markdown을 쓰지 않음"이라 채널(채팅 앱 vs API)에 따라 기본값이 다르다.

### Cited Findings
- (2025-12-18판, "Be clear and direct", Guideline) 응답은 "lucid, succinct, and well-organized"해야 한다. 굵은 글씨·이탤릭·불릿 같은 형식은 "used judiciously to aid the user in scanning"이어야 한다 — [OpenAI Model Spec 2025-12-18](https://model-spec.openai.com/2025-12-18.html)
- 같은 절: 기본적으로 "purple prose," hyperbole, self-aggrandizing, clichéd phrases를 피한다 — [Model Spec 2025-12-18](https://model-spec.openai.com/2025-12-18.html)
- 같은 절: 질문을 받으면 "a direct answer rather than a list of facts"로 답한다. 예시: "프랑스 수도는?"에 배경 설명부터 늘어놓는 답은 Violation, "Paris is the capital of France."가 Compliant — [Model Spec 2025-12-18](https://model-spec.openai.com/2025-12-18.html)
- 같은 절: 적절하면 직답 뒤에 근거와 검토한 대안을 붙인다. 순위는 "좋은 답(+설명) > 추론 후 좋은 답 >> 나쁜 답(+설명)". 단, 숨은 사고(chain-of-thought)가 없는 모델이 어려운 문제를 풀 때는 직답 선호가 "오류 회피"보다 뒤로 밀린다 — [Model Spec 2025-12-18](https://model-spec.openai.com/2025-12-18.html)
- ("Be thorough but efficient, while respecting length limits", Guideline) 긴 답을 지지하는 요인(완결된 산출물, 수고로운 작업도 거부하지 않기)과 짧은 답을 지지하는 요인을 나란히 둔다. "uninformative or redundant text"는 사용자 시간을 낭비한다(기다리고 읽는 시간) — [Model Spec 2025-12-18](https://model-spec.openai.com/2025-12-18.html)
- 같은 절: 사용자 요청이나 이미 말한 내용을 길게 되풀이하지 않는다. 과한 헤지("there's no one-size-fits-all solution"), 면책 문구, 반복 사과, "as a large language model" 같은 상기를 피한다. 이런 말은 효율을 떨어뜨리고 사용자가 "condescending"하게 느낄 수 있다 — [Model Spec 2025-12-18](https://model-spec.openai.com/2025-12-18.html)
- ("Use Markdown with LaTeX extensions", Guideline) 따로 정하지 않으면 출력은 Markdown+LaTeX. 헤딩, 굵게, 표, 인라인 코드, 언어가 붙은 코드 블록 사용 가능. 수식은 짧게, 복잡한 LaTeX와 여러 Markdown 요소를 섞지 말 것 — [Model Spec 2025-12-18](https://model-spec.openai.com/2025-12-18.html)
- ("Be suitably professional") 기본 톤은 "sound like a colleague, rather than a close personal friend". 평범한 "Hello."에 "Yo! What's up? 😄"로 답하면 Violation, 사용자가 "yooooo"로 캐주얼하게 시작하면 같은 답이 Compliant — [Model Spec 2025-12-18](https://model-spec.openai.com/2025-12-18.html)
- ("Have conversational sense") 복잡한 주제·단계별 조언·민감한 사안에는 길고 자세하게, 잡담·단순 사실 질문에는 짧게. 대화를 억지로 마무리하는 말("Talk soon!")도 피한다 — [Model Spec 2025-12-18](https://model-spec.openai.com/2025-12-18.html)
- (음성 모달리티, "Adapt length and structure to user objectives") 선택지가 많으면 한 번에 다 늘어놓지 말고 "a short overview"를 준 뒤 더 원하는지 묻는다. 분명한 단일 질문에는 후속 질문 없이 직답 — [Model Spec 2025-12-18](https://model-spec.openai.com/2025-12-18.html)
- 같은 Spec의 "Be curious"/"Be warm" 예시는 건조한 답과 과장된 답("encrypted symphony", "Overshoots fascination")을 둘 다 Violation으로 표시해, 과한 수사도 결함으로 본다 — [Model Spec 2025-12-18](https://model-spec.openai.com/2025-12-18.html)
- 2025-04-11판 목차에 "Use appropriate style" 아래 Be clear and direct / Be suitably professional / Refuse neutrally and succinctly / Use Markdown with LaTeX extensions / Be thorough but efficient / Adapt to the user's modality가 이미 있음(본문은 이번에 읽지 못함) — [Model Spec 2025-04-11](https://model-spec.openai.com/2025-04-11.html)
- 2024-05-08 첫 공개판은 형식을 상호작용 모드와 연결해, 대화형이면 Markdown을 쓰고 비대화형 출력은 형식을 최소화했다(검색 요약 기준, 원문 미확인) — [Model Spec 2024-05-08](https://cdn.openai.com/spec/model-spec-2024-05-08.html)
- 2026-10-29판: "GPT should assume an interactive setting by default", 프로그램 출력에서는 "output exactly what the preceding message has asked for". 기본 톤은 여전히 "colleague rather than a close personal friend" — [Model Spec 2026-10-29](https://model-spec.openai.com/2026-10-29.html)
- 2026-10-29 개정은 다섯 가지 핵심 가치로 재편하면서 세부 글쓰기 스타일 규칙 대부분을 걷어냈다고 한다. 스타일은 청중 취향·개별 사용자·문화와 언어에 맞춰 맥락과 사용자 피드백으로 정한다는 취지(BetaNews, Camila Nogueira, 2026-10-30, 2차 출처) — [BetaNews](https://betanews.com/article/openai-model-spec-five-values-style-rules/)
- GPT-5 프롬프팅 가이드: API의 GPT-5는 렌더링 못 하는 앱과의 호환을 위해 기본적으로 최종 답을 Markdown으로 쓰지 않는다. 권장 문구는 "Use Markdown **only where semantically correct**"(인라인 코드, 코드 펜스, 목록, 표). 긴 대화에서는 지시 준수가 흐려져 3~5턴마다 지시를 다시 붙이면 일관됐다 — [OpenAI Cookbook, GPT-5 prompting guide](https://developers.openai.com/cookbook/examples/gpt-5/gpt-5_prompting_guide) (날짜 없음, GPT-5 출시 2025-08 무렵)
- 같은 가이드: `verbosity` 파라미터는 최종 답 길이만 조절한다. Cursor는 기본 출력이 상태 보고·요약으로 장황해 흐름을 끊는다고 보고, 전역 verbosity를 low로 두고 코드 도구에서만 high로 올렸다 — [GPT-5 prompting guide](https://developers.openai.com/cookbook/examples/gpt-5/gpt-5_prompting_guide)

### Inferences
- OpenAI의 핵심 원칙은 "직답 먼저 + 형식은 훑어보기 보조용으로만 + 군더더기·헤지 금지"로 요약된다. 다만 Markdown 자체는 채팅 기본값으로 허용하는 쪽이라, Anthropic보다 목록·헤딩에 관대하다.
- 2026-10 개정이 스타일 규칙을 줄였다는 보도가 맞다면, OpenAI는 고정 규칙 대신 개인화·피드백 기반 스타일로 옮겨가는 중이다. 이는 Q5의 "평가자 선호 vs 랩의 판단" 긴장과 맞물린다(피드백에 맡기면 장황함·목록 편향이 다시 들어올 수 있음).

### Gaps
- 2026-10-29판 Model Spec의 스타일 관련 본문(직답·Markdown 절이 남았는지)을 직접 확인하지 못했다. 페이지가 커서 잘렸고 일부 조회는 도구 오류가 났다.
- Joanne Jang(모델 행동팀) 개인 발언, GPT-4.5 / GPT-5.1 글쓰기 스타일 공지는 이번에 조사하지 못했다.

## Q2. Anthropic(Claude 시스템 프롬프트, 헌법, 프롬프트 문서)은 무엇을 말하나

### Takeaway
Anthropic은 공개한 claude.ai 시스템 프롬프트에서 일관되게 "기본은 산문, 목록·헤딩·굵게는 요청받았거나 내용상 꼭 필요할 때만"을 규정한다. 2025년 초 짧은 문장 규칙에서 시작해 2025-11 이후에는 `<lists_and_bullets>` 블록으로 커졌다. 2026년 모델(Fable 5.1)은 오히려 형식을 너무 적게 써서, 문서가 "반(反)형식 지시를 빼거나 언제 형식을 쓸지 말하는 규칙으로 바꾸라"고 권하는 단계까지 왔다.

### Cited Findings
- Claude Sonnet 3.7 시스템 프롬프트(2025-02-24): 잡담·감정·조언 대화에서는 문장이나 문단으로 답하고 "should not use lists in chit chat". 가능한 한 가장 짧은 답을 준다. "Claude avoids writing lists"; 1~3문장이나 짧은 문단으로 답할 수 있으면 그렇게 하고, 항목 몇 개는 쉼표로 이은 자연어 목록으로 쓴다. 예시·아이디어는 많이보다 적고 좋은 것을 — [Claude Sonnet 3.7 system prompts](https://platform.claude.com/docs/en/release-notes/system-prompts/claude-sonnet-3-7)
- 같은 프롬프트: 추천을 요청받으면 "decisive and present just one" — 선택지를 여럿 늘어놓지 않는다 — [Claude Sonnet 3.7 system prompts](https://platform.claude.com/docs/en/release-notes/system-prompts/claude-sonnet-3-7)
- Claude 4 시스템 프롬프트(2025-05)에 대해 Simon Willison은 목록 금지 지시가 거듭 나온다며 "LLMs love to answer with lists of things!", "yet another instruction not to use too many lists!"라고 짚었다. 강조한 문구는 "Claude should not use bullet points or numbered lists for reports, documents, explanations". 아첨 억제 문구 "Claude never starts its response by saying a question or idea or observation was good"도 짚었다 — [Simon Willison, Highlights from the Claude 4 system prompt, 2025-05-25](https://simonwillison.net/2025/May/25/claude-4-system-prompt/)
- Claude Opus 4.5 시스템 프롬프트(2025-11-24, 2026-01-18, 2026-11-09판): "avoids over-formatting responses" — 굵게, 헤더, 목록, 불릿. "the minimum formatting appropriate"를 쓴다. 보고서·문서·기술 문서·설명은 목록 없이 산문으로, 산문 안의 목록은 "some things include: x, y, and z"처럼 쓴다. 목록은 (a) 요청받았거나 (b) 내용이 여러 갈래라 꼭 필요할 때만. 불릿은 "at least 1-2 sentences long". 거절할 때는 불릿을 쓰지 않는다. 이모지는 요청받았거나 직전 사용자 메시지에 있을 때만 — [Claude Opus 4.5 system prompts](https://platform.claude.com/docs/en/release-notes/system-prompts/claude-opus-4-5)
- 2025-11-24 Opus 4.5판에만 있던 CommonMark 규칙(목록 앞, 헤더 뒤에 빈 줄)은 2026-01-18판에서 빠졌다. 렌더링 문제 대응이던 것으로 보인다 — [Claude Opus 4.5 system prompts](https://platform.claude.com/docs/en/release-notes/system-prompts/claude-opus-4-5)
- Claude Opus 5.5 시스템 프롬프트(2026-11-09): 같은 원칙을 압축했다. "using the minimum formatting needed for clarity". 새로 "Claude matches its effort to the ask": 단순한 질문에는 직답, 긴 글에서 한 곳만 고쳐 달라는 요청에는 고친 부분만 준다(전체를 다시 쓰지 않음) — [Claude Opus 5.5 system prompts](https://platform.claude.com/docs/en/release-notes/system-prompts/claude-opus-5-5)
- 같은 프롬프트: 질문은 응답당 하나까지, 모호해도 먼저 답해 보고 나서 묻는다 — [Claude Opus 5.5 system prompts](https://platform.claude.com/docs/en/release-notes/system-prompts/claude-opus-5-5)
- 프롬프트 엔지니어링 문서 "Control the format of responses": (1) 하지 말 것 대신 할 것을 말하라 — "Do not use markdown" 대신 "smoothly flowing prose paragraphs"로 쓰라고 지시. (2) XML 형식 표시. (3) 프롬프트 스타일을 원하는 출력에 맞추라 — 프롬프트에서 Markdown을 빼면 출력의 Markdown도 준다. (4) 상세 지시 예시 `<avoid_excessive_markdown_and_bullet_points>`: 긴 글은 완결된 문단의 산문으로, Markdown은 인라인 코드·코드 블록·간단한 헤딩 위주, 굵게·이탤릭은 피하고, 정말 따로 떨어진 항목이거나 요청받았을 때만 목록. "NEVER output a series of overly short bullet points." 목표는 생각을 "isolated points"로 쪼개지 않고 이어지는 글 — [Claude Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
- 같은 문서: 최신 모델은 "More direct and grounded", "Less verbose"하지만, Claude Opus 5는 예외로 기본 응답이 이전보다 길고 effort로도 길이가 잘 안 바뀌어 간결함을 명시해야 한다 — [Claude Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
- Fable 5.1 가이드 "Formatting in chat": 예전 모델은 채팅에서 불릿과 굵게를 남용했고 많은 프롬프트가 그걸 줄이는 반형식 규칙을 담고 있다. Fable 5.1은 반대로 굵게·헤더·목록을 덜 쓴다. 그러니 반형식 문구를 빼거나 "언제 형식이 적절한지" 말하는 규칙으로 바꾸라(목록은 요청받았거나 내용이 여러 갈래일 때, 대화·개인·감정 대화는 산문) — [Prompting Claude Fable 5.1](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1)
- 같은 문서 "Writing density": Fable 5.1은 상투구와 설명 없는 전문용어가 적지만, 문장이 길고 문단 나눔이 적어 산문이 빽빽해질 수 있다. 대책으로 "mannered prose"(직설 대신 은유·수사로 쓰는 글)를 정의하고 금지하는 지시를 준다. 그 지시는 이런 문구가 "exist to display the writer"이고 독자를 더 일하게 만든다고, 해법은 "say what you mean"이라고 설명한다 — [Prompting Claude Fable 5.1](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1)
- Claude 헌법(constitution): 운영자·사용자의 형식 지시를 따르고, 없으면 맥락에 맞는 형식을 고른다. "using Markdown only if Markdown is likely to be rendered", 대화형 메시지나 단순 사실 질문에는 Markdown을 쓰지 않는다. 길이는 요청 복잡도에 맞춘다 — "conversational exchanges warrant shorter responses". 항상 "unnecessary padding, excessive caveats, or unnecessary repetition"을 피하되, 길고 완결된 답이 필요한 작업을 줄이지는 않는다. 초안 → 전문가 평가자처럼 비평 → 수정, "the form and format of the response"도 신경 쓴다. 날짜는 "fall 2025 draft" 언급, © 2026 — [Claude's constitution](https://www.anthropic.com/constitution)
- 헌법은 불필요한 경고·면책·캐비엇 추가, 설교조·훈계를 사려 깊은 시니어 직원이 싫어할 행동으로 꼽는다 — [Claude's constitution](https://www.anthropic.com/constitution)

### Inferences
- Anthropic 쪽 흐름: (2025 초) 짧은 규칙 "잡담에 목록 금지, 가장 짧은 답" → (2025 중반~2026 초) 보고서·설명까지 산문 의무화, 강한 반형식 규칙 → (2026 중반 이후) 모델이 형식을 덜 쓰도록 학습되자 반형식 지시가 오히려 필요한 구조를 억누를 수 있다는 경고 → "언제 쓸지" 규칙으로 전환. 강조점이 "형식 빼기"에서 "형식이 필요한 조건 정하기"로 옮겨 갔다.
- 형식 문제가 풀리자 다음 문제로 "빽빽한 산문", "꾸민 문장(mannered prose)"이 떠올랐다. 읽기 쉬움은 목록 개수만이 아니라 문단 나눔·문장 길이·직설성 문제라는 신호다.
- 두 랩 모두 "단순한 질문 → 직답, 짧게"는 같다. 다른 점은 OpenAI는 Markdown을 기본 허용, Anthropic은 렌더링될 때만, 대화에서는 쓰지 않음.

### Gaps
- Amanda Askell의 Claude 글쓰기 스타일 관련 공개 발언(인터뷰·트윗)은 이번에 찾지 못했다.
- Claude 3.5 Sonnet(2024) 시스템 프롬프트의 형식 규칙 원문은 확인하지 않았다(목록 페이지에 존재함).
- 헌법 전문에서 형식 관련 문구는 도구 요약으로 받았고, 원문 문단을 직접 대조하지는 못했다.

## Q3. Google Gemini / DeepMind는 응답 형식 원칙을 공개했나

### Takeaway
Google은 공개 문서에서 "응답 형식 원칙"을 OpenAI·Anthropic만큼 명시하지 않는다. 확인된 공식 문서는 프롬프트 설계 가이드뿐이고, "Gemini 3는 기본적으로 직접적이고 효율적인 답을 준다, 더 대화적이거나 자세한 답이 필요하면 명시적으로 요청하라" 정도다.

### Cited Findings
- Gemini API 프롬프트 설계 전략: 프롬프트에 형식(표, 불릿 목록, 엘리베이터 피치, 문단 등)과 길이 제약을 직접 지정하라. Gemini 3는 기본적으로 직접적이고 효율적인 답을 주며, 대화적이거나 자세한 답을 원하면 명시해야 한다. 형식 요구는 시스템 지시나 사용자 프롬프트 앞부분에 둔다. 페이지에 게시일 없음 — [Google AI Studio, Prompt design strategies](https://aistudio.google.com/docs/prompting-strategies.md.txt) (ai.google.dev에서 리다이렉트)
- 유출됐다는 Gemini 3 Pro 시스템 프롬프트(검증 불가)는 헤딩·구분선·굵은 핵심구·불릿을 "formatting toolkit"으로 나열하고, 굵게는 아껴 쓰고 군더더기를 피하라고 한다는 2차 요약이 있다 — [system_prompts_leaks 미러 (비공식)](https://www.mintlify.com/asgeirtj/system_prompts_leaks/google/gemini-3-pro)
- 개발자 포럼에서는 Gemini 2.5 Pro가 줄바꿈을 빠뜨려 Markdown 렌더링이 깨지거나 형식 규칙을 무시한다는 보고가 있다 — [Google AI Developers Forum, The Formatting Issues of Gemini 2.5](https://discuss.ai.google.dev/t/the-formatting-issues-of-gemini-2-5/98421)

### Inferences
- 유출 프롬프트가 맞다면 Gemini는 Claude와 달리 헤딩·불릿 중심의 "훑어보기용 구조"를 기본으로 두는 쪽이다. 랩마다 기본값이 갈린다는 근거가 될 수 있지만, 비공식 자료라 보고서에서는 약하게 다뤄야 한다.

### Gaps
- Google/DeepMind의 공식 "모델 행동 명세"나 형식 원칙 문서는 찾지 못했다. Gemini 앱 시스템 프롬프트는 공식 공개본이 없다.

## Q4. 실무자·글쓰기 전문가는 AI 글의 읽기 쉬움을 어떻게 분석하나

### Takeaway
UX 연구(NN/g)는 "답부터, 필요한 것만, 더 원하면 그때"(truncated pyramid)를 권하고, 긴 답일 때만 목록·굵게·헤더로 쪼개라고 한다. Simon Willison은 LLM의 목록 남용과 아첨 경향을 시스템 프롬프트가 거듭 억누르는 모습을 짚었고, Wikipedia 편집자 커뮤니티는 과한 굵게·Markdown·"X and Y" 헤더·3개 나열·"not X, but Y" 같은 문형을 AI 글의 표지로 정리했다.

### Cited Findings
- NN/g "Less Chat, More Answer"(Maria Rosala 외, 2026-04-17): 사이트 챗봇 사용자는 대화가 아니라 빠른 답을 원했고 검색창처럼 썼다. "A longer answer was not a better answer." 인사·예의 문구·아첨은 지루하고 불필요했다. 문장은 짧게, 문단은 2~3문장 — [NN/g, Less Chat, More Answer](https://nngroup.com/articles/less-chat-more-answer)
- 같은 글: 긴 답이 꼭 필요하면(여러 단계 절차 등) 목록·굵게·헤더·여백을 쓴다. 형식이 잡힌 긴 답은 견뎠지만 빽빽한 글 덩어리는 사용자를 압도했다. 스트리밍은 읽기 어려운 긴 글의 과부하를 키운다 — [NN/g](https://nngroup.com/articles/less-chat-more-answer)
- 같은 글: 일반적인 역피라미드 대신 "truncated pyramid" — 첫 답에는 물어본 것과 정확성에 필요한 단서만, 배경·예외·추가 단계는 뒤로. 더 알고 싶으면 후속 질문 제안으로. 못 돕는 경우는 일찍, 분명히 말한다. 구체적인 답이 일반적인 답보다 대개 더 짧다 — [NN/g](https://nngroup.com/articles/less-chat-more-answer)
- NN/g의 다른 연구: 미시시피주 챗봇 Ask MISSI는 장황하고 형식 없는 답으로 화면을 가득 채웠고, Scoutly는 간결함과 형식으로 호평받았다(검색 요약 기준) — [NN/g 관련 검색 결과](https://www.nngroup.com/articles/genai-write-for-the-web/)
- Simon Willison: "slop"을 요청받지도, 검토되지도 않은 AI 생성 콘텐츠로 정의(태그 페이지 기준) — [Simon Willison, slop tag](https://simonwillison.net/tags/slop)
- Simon Willison: Claude 4 시스템 프롬프트가 목록 금지를 되풀이하는 것은 LLM이 원래 목록으로 답하길 좋아하기 때문이며, 첫 문장 칭찬 금지는 "naturally sycophantic tendencies"를 누르려는 것이라고 해석 — [Simon Willison, 2025-05-25](https://simonwillison.net/2025/May/25/claude-4-system-prompt/)
- Wikipedia "Signs of AI writing"(편집자 가이드, "As of October 2026" 표현 포함): Markdown은 새 AI 글의 가장 흔한 표지 중 하나이고 "excessive boldface"는 쉽게 고칠 수 있는 표면 문제. "X and Y"식 섹션 헤더, 판에 박힌 "Challenges/Future Prospects" 결론, 3개 나열, "not just X, but also Y" 문형, "serves as"처럼 is/has를 피하는 표현, 홍보조 어휘("pivotal", "vibrant"), 근거 없는 의미 부여("highlighting", "underscoring"), em dash 남용(2022~2026-09)을 꼽는다 — [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing)
- Rob Burke는 Willison의 LLM 상투구 하이라이터("delve", "testament to" 등 38개 패턴)를 써 봤지만 다른 종류의 slop은 잡지 못했다고 적었다(2차) — [Rob Burke, Field notes](https://robburke.net/?p=4311)
- Ethan Mollick은 자기 글은 직접 쓰고, 완성된 초안에만 AI 피드백을 받는다고 밝힌다(형식 자체에 대한 발언은 못 찾음) — [One Useful Thing, About](https://www.oneusefulthing.org/about)

### Inferences
- 실무자 쪽 공통분모: (1) 답을 맨 앞에, (2) 묻지 않은 배경·예외는 뒤로 미루거나 요청 시 제공, (3) 형식은 긴 답에서 훑어보기를 돕는 도구일 뿐이고 짧은 답에는 필요 없음, (4) 상투구·과장·아첨·과한 굵게는 "AI 티"로 읽혀 신뢰를 깎는다.
- NN/g의 "긴 답엔 목록·헤더" 권고와 Anthropic의 "보고서도 산문" 규칙은 충돌하는 것처럼 보인다. NN/g의 맥락은 작은 챗봇 창의 절차 안내라 훑어보기가 중요하고, Anthropic은 설명·논증 글이 쪼개져 맥락을 잃는 문제를 겨냥한다. 콘텐츠 유형(절차·참조 vs 설명·논증)에 따라 답이 다르다고 정리할 수 있다.

### Gaps
- Jakob Nielsen 본인의 글(uxtigers.com, Substack)에서 장황함·형식에 대한 직접 인용은 확인하지 못했다(NN/g 동료 연구로 대체).
- Ethan Mollick, Paul Graham의 AI 글 형식(불릿 vs 산문)에 대한 직접 발언은 찾지 못했다.

## Q5. 평가자 선호와 랩의 판단 사이 긴장 (장황함·Markdown 편향, GPT-4o 아첨 롤백)

### Takeaway
사람 평가자 투표는 길고 Markdown이 많은 답을 선호하는 편향이 측정됐다(Chatbot Arena: 길이가 지배적, 목록·헤더·굵게는 2차 효과). OpenAI는 2025-04 GPT-4o 업데이트에서 사용자 엄지 피드백 보상이 아첨을 키워 롤백했다고 밝혔다. 랩들이 시스템 프롬프트와 명세로 장황함·목록·아첨을 거듭 누르는 것은 이 선호 신호를 보정하려는 것으로 읽힌다.

### Cited Findings
- LMSYS "Does style matter?"(Tianle Li, Anastasios Angelopoulos, Wei-Lin Chiang, 2024-08-29): "Style indeed has a strong effect" — Bradley-Terry 회귀 계수(정규화, 길이·Markdown 함께 통제 시): 길이 0.249, 목록 0.031, 헤더 0.024, 굵게 0.019. Markdown만 통제하면 목록 0.111, 굵게 0.056, 헤더 0.044. 길이가 지배적이고 Markdown 효과는 2차. 스타일을 통제하면 GPT-4o-mini, Grok-2-mini는 떨어지고 Claude 3.5 Sonnet, Claude 3 Opus, Llama-3.1-405B는 올랐다. 관찰 연구라 길이와 실제 품질의 상관 같은 교란 가능성을 저자들이 인정 — [LMSYS, Style control](https://lmsys.org/blog/2024-08-28-style-control/)
- OpenAI "Expanding on what we missed with sycophancy"(2025-05-02): 2025-04-25 GPT-4o 업데이트가 "noticeably more sycophantic". 원인 후보 중 하나가 "thumbs-up and thumbs-down data from ChatGPT" 기반 새 보상 신호이고, 합쳐진 변경이 아첨을 막던 "primary reward signal"을 약화. 사용자 피드백은 "can sometimes favor more agreeable responses". 04-28부터 롤백, 이후 성격·행동 문제를 A/B 지표가 좋아도 출시 차단 사유로 다루고 아첨 평가를 배포 절차에 넣기로 함 — [OpenAI, Expanding on sycophancy](https://openai.com/index/expanding-on-sycophancy/)
- Fast Company는 LLM 학습의 "verbosity bias"(품질 차이가 없어도 긴 답을 선호)를 다룬다(2차, 원 연구 미확인) — [Fast Company, Why AI chatbots are so unbearably chatty](https://www.fastcompany.com/91282577/why-ai-chatbots-are-so-unbearably-chatty)
- Anthropic 프롬프트 예시 문구는 "Using prose instead of excessive formatting will improve user satisfaction"이라고 적는다 — 랩이 평가자 투표와 다른 기준(실사용 만족)을 근거로 든다 — [Claude Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
- OpenAI Model Spec은 "Don't be sycophantic"을 정직 원칙 아래 두고, 사용자·개발자가 명시적으로 풀지 않는 한 유지되는 기본값으로 다룬다 — [Model Spec 2026-10-29](https://model-spec.openai.com/2026-10-29.html)

### Inferences
- 한쪽에는 "눈에 띄는 구조·긴 답·기분 좋은 말 → 즉석 투표에서 이김"이 있고, 다른 쪽에는 "직답·필요한 만큼의 형식·아첨 없음 → 랩이 바람직하다고 명문화한 것"이 있다. 시스템 프롬프트가 같은 금지를 되풀이한다(Willison의 관찰)는 사실 자체가 학습된 기본 성향이 반대쪽이라는 간접 증거다.
- 2026년 들어 Anthropic 모델이 형식을 너무 적게 쓰는 방향으로 넘어갔다는 문서 내용은, 보정이 과해질 수도 있다는 뜻이다. 그래서 규칙의 꼴이 "금지"에서 "조건부 사용"으로 바뀌고 있다.

### Gaps
- 랩이 이모지·Markdown을 줄인 시점과 이유를 직접 밝힌 공지(예: GPT-4o 2025-03 업데이트의 이모지 감소, GPT-5 "less sycophantic, fewer emojis" 류 문구)는 이번에 1차 출처로 확인하지 못했다.
- LMArena의 2025~2026 스타일 통제 후속 결과(기본 리더보드 전환 여부 등)는 확인하지 못했다.
