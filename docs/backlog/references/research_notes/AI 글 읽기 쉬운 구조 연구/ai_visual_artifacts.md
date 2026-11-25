# AI/LLM-generated explanatory visuals, artifacts, interactive explanations — and evidence on human understanding

Note on method: about 20 search/fetch calls (2026-11-25). Where a number comes from a fetched primary page (paper HTML, official blog), it is marked [primary]. Where it comes only from search-result summaries or secondary write-ups, it is marked [snippet/secondary] and should be checked before it is quoted as fact. The PDF of the Google Generative UI paper could not be rendered, but its arXiv HTML could be read.

## Q1. Generative UI (Google Research 2025) and product surfaces (Claude Artifacts, ChatGPT Canvas, Gemini dynamic view / visual layout): design rationale and evaluation

### Takeaway
The Google "Generative UI" paper is the only rigorous published comparison of LLM-built custom interfaces against markdown/text answers. Raters strongly preferred generative UI over markdown: 82.8–90.5% pairwise preference, with expert-made websites still ahead. It measured **preference only, not comprehension or learning**, and it ignored the 1–2 minute generation latency. The product surfaces (Artifacts, Canvas) have published *design rationale* and, for Canvas, internal model-quality evals. None of them has published evidence on user understanding.

### Cited Findings
**Google Research, Generative UI**
- Paper: Leviathan, Valevski, Kalman, Natchu, Matias, et al. (13 authors), "Generative UI: LLMs are Effective UI Generators," arXiv:2604.09577 (cs.HC/AI/CL/LG). The blog post is dated Nov 18, 2025, and the PDF is also hosted at generativeui.github.io — [arXiv](https://arxiv.org/abs/2604.09577); [HTML v1](https://arxiv.org/html/2604.09577v1); [PDF](https://generativeui.github.io/static/pdfs/paper.pdf); [Google Research blog](https://research.google/blog/generative-ui-a-rich-custom-visual-interactive-user-experience-for-any-prompt/) [primary]
- Motivation, in the paper's framing: LLM output is "often a markdown 'wall of text'." The authors claim that a modern LLM with the right prompting and tools "can robustly produce high quality custom UIs for virtually any prompt," and that this ability is "emergent" in newer models — [arXiv abstract](https://arxiv.org/pdf/2604.09577) [snippet of abstract]
- Implementation: Gemini 3 Pro plus three additions (tool access such as image generation/search, a long system instruction that includes a design "philosophy," and post-processors that fix common errors) — [Google Research blog](https://research.google/blog/generative-ui-a-rich-custom-visual-interactive-user-experience-for-any-prompt/) [primary]
- Evaluation design. There were two prompt sets: (a) 100 random LMArena prompts, of which 8 were removed as nonsensical or sensitive, and (b) 100 manually chosen "Info-Seeking" prompts. Each output went to 2 raters for a pairwise 3-point judgment (left / neutral / right). Raters saw pre-cached results, so generation time did not count. The conditions were an expert-made website (the PAGEN dataset), the top Google Search result, plain-text LLM output, markdown LLM output, and Generative UI. The total number of raters, their backgrounds and inter-rater agreement are **not reported** — [arXiv HTML](https://arxiv.org/html/2604.09577v1) [primary]
- LMArena-set ELO: Expert website 1800.3; Generative UI 1736.2; Markdown 1437.7; Top search result 1352.2; Plain text 1173.7. Pairwise, Generative UI was preferred over markdown 82.8%, over the top search result 90%, and over text 97.0%. Against the expert site, Generative UI was preferred 35.3% and the expert site 50.0% — [arXiv HTML](https://arxiv.org/html/2604.09577v1) [primary]
- Info-Seeking-set ELO: Expert 1821.5; GenUI 1727.3; Top search 1424.3; Markdown 1385.5; Text 1141.4. Pairwise, GenUI beat markdown 90.5%, search 73.5% and text 95.5%, and beat the expert site only 30.0% — [arXiv HTML](https://arxiv.org/html/2604.09577v1) [primary]
- Model scaling (LMArena / Info-Seeking ELO, with the share of outputs that had errors): Gemini 3 1706.7 (0%) / 1739.31 (0%); 2.5 Pro 1653.6 / 1578.53; 2.5 Flash 1623.9 / 1577.74; 2.0 Flash 1332.9 (29% errors) / 1361.75; 2.0 Flash-Lite 1183.0 (60% errors) / 1242.67 (1%). Older models often produced broken UIs — [arXiv HTML](https://arxiv.org/html/2604.09577v1) [primary]
- Prompt ablation: full prompt 1553.23 / 1551.34 > minimal prompt 1496.00 / 1488.27 > "no philosophy" 1450.77 / 1460.39. The design guidance in the system prompt measurably helps — [arXiv HTML](https://arxiv.org/html/2604.09577v1) [primary]. (Caveat: the full-prompt ELO in this ablation differs from the main 1736.2 figure, and the paper does not explain why.)
- Limitations the authors state: generation "can sometimes take a minute or more" (streaming cuts the wait "by about a half"), there are occasional JS/CSS/HTML errors and "occasional inaccuracies," and the preference holds only "when ignoring generation speed" — [arXiv HTML](https://arxiv.org/html/2604.09577v1); [blog](https://research.google/blog/generative-ui-a-rich-custom-visual-interactive-user-experience-for-any-prompt/) [primary]
- **No comprehension, retention or task-success measure**, and no breakdown by prompt type showing where GenUI helps or hurts. Suitable uses (games, simulators, custom visualizations) are illustrated with examples but not measured — [arXiv HTML](https://arxiv.org/html/2604.09577v1) [primary]
- Product rollout: in the Gemini app, two experiments, "dynamic view" and "visual layout" (users may see only one); in Google Search AI Mode, for Google AI Pro/Ultra subscribers in the US via the "Thinking" option — [Google Research blog](https://research.google/blog/generative-ui-a-rich-custom-visual-interactive-user-experience-for-any-prompt/) [primary]

**ChatGPT Canvas (OpenAI, Oct 3, 2024)**
- Rationale: Canvas is a separate window beside the chat for writing and coding. The stated reason is that chat makes revisions hard to follow. Canvas opens automatically when the model judges it useful, or when the user asks for it. It supports version restore — [OpenAI, "Introducing canvas"](https://openai.com/index/introducing-canvas/) [snippet of official post]
- Evaluation (model behavior, not user comprehension): "over 20 automated internal evaluations." On human evals of comment quality, the canvas-trained model beat prompted zero-shot GPT-4o by 30% in accuracy and 16% in quality. On targeted edits, it beat a prompted baseline by 18% — [OpenAI, "Introducing canvas"](https://openai.com/index/introducing-canvas/) [snippet of official post]
- Press coverage framed Canvas as following Claude Artifacts' side-panel model — [Yahoo Tech](https://tech.yahoo.com/computing/articles/chatgpt-canvas-feature-sure-looks-191451524.html); [TechCrunch](https://techcrunch.com/2024/10/03/openai-launches-new-canvas-chatgpt-interface-tailored-to-writing-and-coding-projects/) [secondary]

**Claude Artifacts (Anthropic)**
- The 2024 Claude artifacts system prompt (leaked or extracted, analyzed by third parties) tells the model to "err on the side of not creating an artifact" when unsure. Artifact types include SVG, Mermaid diagrams and React components. One analyst summarizes the intent as making artifacts files the user will want to use outside the conversation — [N.J. Pearman, "The Claude Artifacts system prompt"](https://njpearman.github.io/2024-09-06/the-claude-artifacts-system-prompt-or-message) [secondary, fetched]
- Secondary reporting on the same leaked prompt says it prefers inline content, avoids artifacts "when possible" because overuse is "jarring," allows one artifact per message unless asked, and targets substantial, self-contained content (code, documents over about 15 lines, content to be edited or reused) — [Rosetta/Matthew Berman summary](https://rosetta.to/u/matthew_berman/claude-3-5-artifacts-leaked-anthropic-s-secret-revealed); [Simon Willison](https://simonwillison.net/e/8881) [secondary, not fetched — verify]
- Claude Code docs describe artifacts as things kept and revisited, for example a dashboard that is kept updated during an investigation — [Claude Code docs: artifacts](https://code.claude.com/docs/en/artifacts.md) [snippet]
- I found no Anthropic publication that evaluates whether artifacts improve user understanding.

### Inferences
- The best evidence for "visual/interactive answers beat markdown" is **preference** evidence from one vendor's own study, with 2 raters per item and no reported agreement. It supports "people like it" more than "people understand it better."
- The ablation (removing the design "philosophy" lowers ELO) suggests that the *quality* of a generated UI depends heavily on explicit design guidance in the prompt. This matters for anyone writing skills or prompts that make LLMs produce visuals.
- The vendors converge on one rule: the default is inline text, and a separate artifact or canvas is for substantial, reusable or editable content. The rationale is workflow (editing, versioning, reuse), not comprehension.

### Gaps
- No published data from Google on dynamic view / visual layout usage, satisfaction or comprehension beyond the paper.
- No official, current Anthropic or OpenAI document that sets evidence-based criteria for when an answer should be a visual. What exists is product rationale and leaked or extracted prompts.
- The PAGEN dataset release status was not verified.

## Q2. LLM-generated visualizations and diagrams (NL2VIS, LIDA, Data Formulator, benchmarks): correctness and comprehensibility

### Takeaway
Systems such as LIDA and Data Formulator show LLMs can author charts end-to-end. Benchmarks (VisEval) show recurring failures: code that does not run, wrong field-to-axis mapping, and overflowing or unreadable layouts. Studies of whether *readers* understand LLM charts correctly are few, and one study found that visuals paired with LLM explanations increased overtrust in wrong answers.

### Cited Findings
- **LIDA** (Victor Dibia, ACL 2023 System Demonstrations; arXiv:2303.02927) treats visualization generation as a multi-stage pipeline with four modules: Summarizer (data to a compact NL summary), Goal Explorer (enumerates visualization goals), VisGenerator (generates, refines, executes and filters chart code) and Infographer ("data-faithful" stylized graphics via image models). It has a Python API and a hybrid UI — [arXiv:2303.02927](https://arxiv.org/abs/2303.02927) [primary]. Its reported metrics (visualization error rate, self-evaluated visualization quality) were not readable on the abstract page — see Gaps.
- **Data Formulator** (Chenglong Wang, John Thompson, Bongshin Lee; Microsoft Research; IEEE VIS 2023, Best Paper Honorable Mention). It uses "concept binding": users define data concepts in natural language or by example and bind them to visual channels, and an AI agent writes the data transformations. A 10-participant chart-reproduction study found participants could learn the tool and build charts that need hard transformations. This was a usability study, not a measure of comprehension — [arXiv:2309.10094](https://arxiv.org/abs/2309.10094v2); [MSR publication page](https://www.microsoft.com/en-us/research/publication/data-formulator-ai-powered-concept-driven-visualization-authoring/); [MSR blog](https://www.microsoft.com/en-us/research/blog/data-formulator-a-concept-driven-ai-powered-approach-to-data-visualization/); [IEEE VIS 2023 entry](https://virtual.ieeevis.org/year/2023/paper_v-full-1567.html) [snippet/secondary]
- **VisEval** (Microsoft Research; IEEE VIS 2024, best paper award per search summary): an NL2VIS benchmark of 2,524 queries over 146 databases. Evaluation has three dimensions: **validity** (the code runs and renders), **legality** (the chart meets the query) and **readability** (clarity of presentation, judged by an evaluator). Example failures: CodeLlama-7B code that does not run, Gemini-Pro mapping the wrong field to the y-axis, and GPT-4 closest to the requirements but with overflow problems that hurt readability — [arXiv:2407.00981](https://arxiv.org/abs/2407.00981v2); [GitHub microsoft/viseval](https://github.com/microsoft/viseval); [IEEE VIS 2024 page](https://aa.ieeevis.org/year/2024/program/paper_v-full-1332.html) [snippet]. Aggregate pass rates were not retrieved.
- **Ströbel, Eckert, Nagel (EuroVis 2024 posters/short), "Hey ChatGPT, can you visualize my data?"**: an expert reviewer scored LLM-generated visualizations across simulated user-competence levels and requirements. It used simulated personas, not real participants — [Eurographics DL](https://diglib.eg.org/bitstream/handle/10.2312/evp20241083/09_evp20241083.pdf) [snippet]
- **Ford & Rios (arXiv:2409.18764, 2024)**: an automated evaluation of LLM-generated charts using visual question answering. The LLM charts did not match the accuracy of the original non-LLM charts on VQA measures — [arXiv:2409.18764](https://www.arxiv.org/pdf/2409.18764) [snippet]
- **ALTA 2024**: a 57-participant human study of the *creativity and accessibility* of LLM-generated visualizations, not their correctness — [ACL Anthology 2024.alta-1.2](https://aclanthology.org/2024.alta-1.2.pdf) [snippet]
- **Overtrust risk (LinkQ, arXiv:2505.21512)**: in an LLM-assisted knowledge-graph system, participants often overtrusted the LLM's answer and cited the visualizations paired with LLM explanations as reasons for believing a *false* answer — [arXiv:2505.21512](https://arxiv.org/pdf/2505.21512) [snippet]
- **Interactive explanation interfaces for verifying LLM reasoning (arXiv:2510.22922, IUI '26)**: LLMs turned chain-of-thought into interactive interfaces (iCoT text, iGraph graph, iPoT code). In a 125-participant controlled study on GSM8K, interactive interfaces significantly improved users' accuracy at judging whether reasoning was correct. iGraph was fastest at 57.9 s per question, vs. 60 s for iCoT/iPoT and 64.7 s for static CoT — [arXiv:2510.22922](https://arxiv.org/abs/2510.22922) [snippet]
- Newer work (2026) continues: human vs. LLM chart comprehension (arXiv:2604.08959) and DSL-mediated authoring (Raiven, arXiv:2604.10008). Not examined in detail — [arXiv:2604.08959](https://arxiv.org/html/2604.08959); [arXiv:2604.10008](https://arxiv.org/pdf/2604.10008) [snippet]

### Inferences
- "Correctness" of an LLM chart has at least three layers: it renders, it encodes the right data and fields, and it is readable. Benchmarks find failures at every layer, so a generated chart that looks polished can still be semantically wrong.
- The LinkQ result points to a specific harm: a visual adds unearned credibility to an LLM answer. The iGraph result shows that well-designed structure (a graph view of the reasoning) can help people *check* the reasoning. A visual helps when it exposes structure the reader can check, and hurts when it decorates an unverified claim.

### Gaps
- LIDA's quantitative metrics (VER/SEVQ values) and VisEval's leaderboard numbers were not retrieved. Check the full PDFs.
- Data Formulator 2 (2024/2025, iterative multi-turn authoring) was not covered in this session.
- I found no large study measuring whether *end readers* interpret LLM-generated charts correctly compared with human-made charts (the 2026 arXiv:2604.08959 may partly address this, but it was not read).

## Q3. The explorable-explanations tradition and LLM-generated interactive explanations: measured learning gains

### Takeaway
The tradition (Bret Victor 2011, Distill, Nicky Case, Ciechanowski) is strong on design rationale and thin on controlled learning measures. Recent studies give mixed but mostly positive evidence for interactivity: conceptual and transfer gains in some, null differences in others. Evidence on *LLM-generated* explorables is only emerging; one 2026 preprint proposes ways to evaluate their interactivity, and Google's Learn Your Way reports retention gains for an AI-transformed textbook that bundled many features.

### Cited Findings
- Bret Victor's essay "Explorable Explanations" (2011) coined and popularized the term — [worrydream.com](https://worrydream.com/ExplorableExplanations/); [Wikipedia](https://en.wikipedia.org/wiki/Explorable_explanation) [snippet]
- Hohman et al., "Communicating with Interactive Articles," Distill (2020), aims to connect interactive articles with research on techniques, theory and empirical evaluation. It cites self-explanation as a learning technique with positive effects. It is a synthesis, not a new learning experiment — [Distill 2020](https://distill.pub/2020/communicating-with-interactive-articles/) [snippet]
- **AI-literacy explorables (arXiv:2507.21090, 2025 preprint)**: a controlled study with more than 600 Prolific participants and four explorable explanations (datasets and bias, algorithmic decisions, ethics and fairness, generative AI). Control conditions also showed learning gains, but the explorable group showed more conceptual improvement and broader generalization — [arXiv:2507.21090](https://arxiv.org/html/2507.21090v1) [snippet]
- **Explorables for correcting misleading charts**: no significant differences among explanation methods in convincing participants to accept corrections — [NSF PAR 10210727](https://par.nsf.gov/biblio/10210727) [snippet]
- **Evaluating AI-generated explorables (arXiv:2606.31012, 2026)**: argues that evaluating explorables differs from evaluating static content, and proposes modeling them as finite state machines to assess interaction logic automatically — [arXiv:2606.31012](https://arxiv.org/pdf/2606.31012) [snippet]
- **Transformer Explainer (arXiv:2408.04619)**, a human-built interactive visual tool for learning how LLMs work: significant gains on the architecture-overview objective (p=0.026) and the output-probabilities objective (p=0.011), and weaker results on an objective that had no interactive elements — [arXiv:2408.04619](https://arxiv.org/pdf/2408.04619) [snippet]
- **Google "Learn Your Way"** (Sept 2025; Heldreth et al., listed for Frontiers in AI 2026): textbook content was transformed with generative AI into personalized text, mind maps, audio lessons, slides, quizzes and generated visuals. In an RCT with 60 Chicago-area students aged 15–18, retention 3–5 days later was 78% vs. 67% for a standard digital reader (+11 points), and immediate scores were 77% vs. 68%. It covered **one chapter, many bundled features, and the effect of visuals is not isolated**. The authors also say general-purpose image models were inadequate for educational visuals, which is why they built a custom pipeline — [Google Research blog](https://research.google/blog/learn-your-way-reimagining-textbooks-with-generative-ai/); [arXiv:2509.18664](https://arxiv.org/html/2509.18664v2); [Google Keyword blog](https://blog.google/outreach-initiatives/education/learn-your-way/); [Maginative](https://www.maginative.com/article/learn-your-way-googles-new-ai-transforms-static-textbooks-into-interactive-personalized-lessons/); [Frontiers 2026](https://www.frontiersin.org/journals/artificial-intelligence/articles/10.3389/frai.2026.1783117/full) [snippet/secondary]
- **iLLuMinaTE** (arXiv:2409.08027): LLM explanations of student-model predictions. 114 university students preferred them over traditional explainers 89.52% of the time. This is preference, not learning — [arXiv:2409.08027](https://arxiv.org/html/2409.08027v2) [snippet]
- **LLM-supported self-explanation in calculus** (arXiv:2604.00142, 2026): 92 participants. All conditions improved, with **no significant post-test differences** between LLM-feedback self-explanation and the other conditions, though LLM support improved explanation quality on transfer problems — [arXiv:2604.00142](https://arxiv.org/abs/2604.00142) [snippet]

### Inferences
- Interactivity seems to help most for conceptual understanding and transfer when the learner must *act* (manipulate parameters, explain). It helps less where the goal is persuasion or simple recall.
- Measured learning gains from AI-transformed material exist (Learn Your Way), but they come from bundles that include quizzes and personalization. They cannot support the claim that "AI visuals improve learning" on their own.
- Like Generative UI, AI-built educational tools tend to report preference (iLLuMinaTE 89.52%) as a stand-in for understanding. Preference and learning should be kept apart.

### Gaps
- I found no controlled study of LLM-generated, Nicky-Case-style explorable simulations that measures learning outcomes.
- Nicky Case's and Bartosz Ciechanowski's work has no formal evaluations that I found. Its influence is cultural and design-level.
- Distill's 2021 hiatus statement (about the cost of producing interactive articles) was not fetched. It may be relevant to "authoring cost" arguments: https://distill.pub/2021/distill-hiatus/ (not verified this session).

## Q4. Multimedia learning evidence (Mayer) applied to AI-generated visuals; risks of decorative or misleading visuals

### Takeaway
The classic findings are that relevant ("instructive") graphics support learning, while "seductive" ones (interesting but irrelevant) harm it, and all graphic types raise satisfaction. Satisfaction and learning can come apart, the same split seen in the Generative UI preference results. AI image tools tend to add extra details and can produce inaccurate ones, which pushes images toward the seductive or misleading end. Direct experimental evidence on AI-generated instructional images is still thin.

### Cited Findings
- Sung & Mayer (2012) taxonomy: instructive graphics support essential processing of core concepts, decorative graphics improve aesthetics without changing learning, and seductive graphics are interesting but irrelevant and add extraneous processing that hurts learning. **All three types raised student satisfaction**, but seductive images reduced learning — [MIT Sloan EdTech, "AI-generated images can be eye-catching, but do they actually help your students learn?" (2024)](https://mitsloanedtech.mit.edu/2024/03/06/supporting-learning-with-ai-generated-images-a-research-backed-guide) [secondary guide summarizing primary research]
- Seductive details harmed learning only when students (mistakenly) treated them as relevant (Bender et al., cited in a 2021 review) — [Springer, Instructional Science s11251-023-09632-w](https://link.springer.com/content/pdf/10.1007/s11251-023-09632-w.pdf) [snippet; attribution to this specific article not fully verified]
- AI image generators can produce inaccurate details that confuse students. The guide recommends choosing visuals that directly support learning outcomes — [MIT Sloan EdTech](https://mitsloanedtech.mit.edu/2024/03/06/supporting-learning-with-ai-generated-images-a-research-backed-guide) [secondary]
- Instructional designers report that AI tools "seem to think that more is better," adding extra objects that turn instructive images into seductive ones — [Derailed by Design: When AI Imagery Distracts from the Lesson](https://multimediaideas.opened.ca/?p=185) [practitioner blog]
- Google's Learn Your Way team found general-purpose image models inadequate for effective educational visuals — [arXiv:2509.18664](https://arxiv.org/html/2509.18664v2) [snippet]
- Visual explanations can increase overtrust in false LLM answers (LinkQ) — [arXiv:2505.21512](https://arxiv.org/pdf/2505.21512) [snippet]

### Inferences
- The pattern "all graphics raise satisfaction, only instructive ones raise learning" (Sung & Mayer) parallels "raters prefer generative UI" (Google). Preference-based evaluations of AI visuals cannot by themselves show a comprehension benefit and may reward seductive richness.
- Mayer's coherence principle (cut extraneous material) and the signaling principle favor sparse, structure-revealing visuals: diagrams of relations, steps or quantities. Decorative hero images, icons and gradients do not have this support. This is my application of the principles. No study tests it on LLM output directly.
- Accuracy risk adds to the classic cognitive-load risk. A generated diagram can be wrong in ways text would not be (wrong axis, spurious relations), and the visual form makes it look more credible.

### Gaps
- No primary Mayer source (e.g., *Multimedia Learning*, 3rd ed., 2020, or the Cambridge Handbook) was fetched this session. The multimedia principle ("words + pictures > words alone"), the redundancy principle and the published effect sizes (median d of about 1.39 for the multimedia principle in Mayer's own summaries) come from background knowledge and are **not verified here**. Cite a primary source before using them.
- I found no peer-reviewed experiment that directly compares AI-generated with human-made instructional graphics on learning outcomes.

## Q5. Guidance from labs on when an answer should be a visual/artifact vs text

### Takeaway
Published lab guidance is product-level and workflow-based: use inline text by default, and use an artifact or canvas for substantial, self-contained content that will be edited, reused or revisited. Google's Generative UI system prompt encodes a design "philosophy," and removing it measurably lowers quality. No lab has published comprehension-based criteria for choosing a visual over text.

### Cited Findings
- Claude (2024 artifacts prompt, via third-party analyses): "err on the side of not creating an artifact" when unsure. Artifacts are for content used outside the conversation — [Pearman](https://njpearman.github.io/2024-09-06/the-claude-artifacts-system-prompt-or-message) [secondary]. Prefer inline, overuse is "jarring," one artifact per message, and the targets are code, documents over about 15 lines and editable/reusable content — [Rosetta summary](https://rosetta.to/u/matthew_berman/claude-3-5-artifacts-leaked-anthropic-s-secret-revealed) [secondary, not fetched]
- Claude Code artifacts docs: artifacts suit things you keep and revisit, such as a dashboard kept current during an investigation — [code.claude.com/docs/en/artifacts](https://code.claude.com/docs/en/artifacts.md) [snippet]
- OpenAI Canvas opens automatically when ChatGPT judges it useful, or when the user asks. The stated motive is that tracking revisions in chat is hard — [OpenAI](https://openai.com/index/introducing-canvas/) [snippet]
- Google Generative UI: the system prompt includes design guidance. Ablations show "no philosophy" < "minimal" < "full" prompt in ELO — [arXiv HTML](https://arxiv.org/html/2604.09577v1) [primary]

### Inferences
- A defensible synthesis of the evidence gathered here:
  1. Default to text.
  2. Use a visual when the content is inherently spatial, relational, quantitative or procedural, so the visual shows structure the reader can check.
  3. Use an interactive or artifact form when the user must manipulate it, reuse it or come back to it.
  4. Avoid decorative visuals and visuals that make unverified claims look more credible.

  Steps 2 and 4 rest on multimedia-learning theory and the LinkQ/iGraph findings, not on lab guidance.

### Gaps
- No current official Anthropic, OpenAI or Google document lays out evidence-based criteria for choosing visual vs. text. Current production system prompts were not verified in this session; Anthropic publishes system prompts in its release notes, which would be the place to check.
- Gemini "dynamic view" / "visual layout" triggering criteria are not published, as far as I found.
