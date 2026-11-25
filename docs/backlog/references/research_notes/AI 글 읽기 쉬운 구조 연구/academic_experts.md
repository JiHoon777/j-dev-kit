# Academic experts on how AI should present information so humans understand it

Scope note: about 20 search/fetch calls. Most findings come from abstracts, author pages, and essay text, not full papers. Where only an abstract was read, the finding says so. Direct quotes are under 15 words.

## Q1. Writing/cognition experts (Pinker, Gopen, Williams, Mayer): have they commented on LLM writing, or been applied to it?

### Takeaway
Pinker is the only one in this group found commenting on ChatGPT directly (2023, mainly about accuracy and world models, not prose style). No sources were found applying Gopen's or Williams's frameworks to LLM output, and no Mayer paper on generative AI was found. Their foundational claims (curse of knowledge, reader-expectation positions, Mayer's coherence/segmenting principles) still bear directly on how AI explanations should be written, but anyone using them for LLM text is extrapolating.

### Cited Findings
- **Steven Pinker (Harvard, psychology).** In a Feb 2023 Harvard Gazette interview he called ChatGPT impressive and said it would improve once it "stops making stuff up". He contrasted LLMs with a hypothetical semantic search engine that would have "a conceptual model of the world". — [Harvard Gazette, "Will ChatGPT replace human writers? Pinker weighs in" (Feb 2023)](https://news.harvard.edu/gazette/story/2023/02/will-chatgpt-replace-human-writers-pinker-weighs-in/); author copy at [stevenpinker.com](https://stevenpinker.com/publications/will-chatgpt-supplant-us-writers-thinkers)
- Pinker's foundational claim: the curse of knowledge (writers forget what it is like not to know something) is "the chief contributor to opaque writing" (*The Sense of Style*, 2014). His remedy is to show drafts to outsiders. — [APS Observer, "The Curse of Knowledge: Pinker Describes a Key Cause of Bad Writing"](https://www.psychologicalscience.org/observer/the-curse-of-knowledge-pinker-describes-a-key-cause-of-bad-writing)
- A later "How I Write" podcast with Pinker covers writing rules, the curse of knowledge, and AI's effect on writing. The interviewer is named inconsistently across sources (Dana Gioia vs. the show host), and the AI segment was not checked against a transcript. — [How I Write (Substack)](https://howiwrite.substack.com/p/steven-pinker-rules-for-writing-and)
- **George Gopen (Duke) & Judith Swan.** "The Science of Scientific Writing" (American Scientist, 1990): readers have fairly fixed expectations about where in a sentence particular information will appear (old information in the topic position, emphasis in the stress position at the end). Material placed between subject and verb reads as an interruption of lesser importance. — [Gopen & Swan 1990 (course mirror PDF)](https://www.cs.columbia.edu/~djhsu/coms6998-f17/science-of-writing.pdf)
- No study applying Gopen's reader-expectation framework to LLM output was found. Adjacent work: a 2026 ACL paper finds LLM-generated argumentative texts significantly more generic than human ones and links genericity to discourse structure (Rhetorical Structure Theory). — [ACL 2026 long 1521 (PDF)](https://aclanthology.org/2026.acl-long.1521.pdf)
- **Richard Mayer (UCSB).** His 2024 theory essay "The Past, Present, and Future of the Cognitive Theory of Multimedia Learning" (Educational Psychology Review 36:8, Jan 2024) does not appear to address generative AI directly. — [Springer PDF](https://link.springer.com/content/pdf/10.1007/s10648-023-09842-1.pdf)
- Mayer's principles are grouped as reducing extraneous processing (e.g., coherence: remove extraneous material), managing essential processing (e.g., segmenting, pre-training), and fostering generative processing. — [Mayer, research-based principles for multimedia instruction (UNH copy)](https://www.unh.edu/teaching-learning-resource-hub/sites/default/files/media/2023-06/itow-research-based-principles-for-designing-multimedia-instruction-mayer.pdf); a 2025 Mayer talk lists 14 principles — [Media & Learning 2025 slides](https://media-and-learning.eu/files/2025/07/18June_Auditorium_Mayer.pdf)
- Others have applied Mayer's theory to AI: AlShaikh, Al-Malki & Almasre (2024, *Heliyon* 10(3)) built and evaluated an LLM educational-video assistant on CTML (seen only as a citation, content not verified). An arXiv paper (2311.06586) warns that AI tools generating visualizations, code, and explanatory text can overwhelm learners if not curated, which is a coherence-principle concern. — [arXiv 2311.06586](https://arxiv.org/pdf/2311.06586)
- Empirical LLM-writing study (not by these experts): Miletić & Falk (LREC 2026) find LLM-"improved" passages use longer, more complex words and show lower lexical diversity. Yet 20 domain experts rated them "more understandable and exciting", while voicing negative attitudes toward LLMs. — [arXiv 2605.19936](https://arxiv.org/abs/2605.19936)

### Inferences
- The curse of knowledge carries over to LLMs in a specific form: a model has no picture of the reader unless one is given, so it defaults to a guessed "general" reader. Tal August's CHI 2024 result (Q3) is the empirical counterpart. This link is my inference; no source frames it this way.
- Gopen's topic/stress positions and Mayer's coherence and segmenting principles turn easily into checkable rules for AI-written explanations: lead with familiar context, end sentences on the new point, cut extras, and split into chunks. Treat these as extrapolations, not tested LLM guidance.
- Miletić & Falk suggest readers' sense that a text is "understandable" can diverge from linguistic measures, and from their attitude toward the source.

### Gaps
- No statement was found from Joseph Williams (*Style*) or his successor co-author Joseph Bizup about LLM writing. Williams died in 2008. I found no study applying his "characters as subjects, actions as verbs" principle to LLM text.
- No Gopen comment on AI was found.
- No first-hand Mayer paper on generative AI was found (searched once). His UCSB publication list should be checked.
- The Pinker podcast's AI segment was not verified from a transcript.

## Q2. HCI/visualization experts: specific claims relevant to AI explanations, readable structure, and AI-generated visual/interactive explanations

### Takeaway
The HCI consensus is that understandability comes from the reader's mental model and control, not from more explanation text. Agrawala says users need a predictive conceptual model plus common ground and repair. Heer argues for shared representations users can review and revise. Liao & Vaughan say transparency must be tailored to the stakeholder and goal. Glassman says interfaces must help readers notice and judge AI errors. Victor argues for active, explorable reading. Empirical work from Liao/Vaughan and Bernstein shows that wording and the cost of verifying change whether people rely on AI appropriately.

### Cited Findings
- **Maneesh Agrawala (Stanford).** Essay "Unpredictable Black Boxes are Terrible Interfaces" (Substack, 30 Mar 2023, revised from his Stanford HAI Fall 2022 talk). Key claims:
  - Generative AI tools lack a predictive conceptual model, so users fall back on trial and error ("When a conceptual model is not predictive, users are forced into using trial-and-error").
  - Human collaboration works through common ground, shared semantics, and repair, which current AI supports only shallowly.
  - Proposed fixes: multi-turn conversation, repair mechanisms (e.g., small prompt edits instead of full regeneration), constraints beyond language, learned shared references, and inspectable, editable neurosymbolic output (code).
  - Explanation as such is not the essay's emphasis.
  - Sources: [Substack essay](https://magrawala.substack.com/p/unpredictable-black-boxes-are-terrible); [ACM TechTalk page](https://learning.acm.org/techtalks/terribleinterfaces); [CS347 slides](https://magrawala.github.io/cs347-sp24/assets/slides/10-unpredictable%20black%20boxes.pdf)
- **Q. Vera Liao & Jennifer Wortman Vaughan (Microsoft Research).** "AI Transparency in the Age of LLMs: A Human-Centered Research Roadmap" (arXiv June 2023; *Harvard Data Science Review*, Special Issue 5, May 2024). Claims:
  - Transparency is "largely missing" from LLM discourse.
  - Transparency should be human-centered, because what people need to understand varies by stakeholder, goal, and context.
  - It reviews four approaches: model reporting, publishing evaluation results, explanations, and communicating uncertainty.
  - Sources: [arXiv 2306.01941](https://arxiv.org/abs/2306.01941); [MSR page](https://www.microsoft.com/en-us/research/?p=996246)
- **Kim, Liao, Vorvoreanu, Ballard & Vaughan.** "'I'm Not Sure, But…': Examining the Impact of LLMs' Uncertainty Expression on User Reliance and Trust" (FAccT 2024).
  - Design: pre-registered experiment, N=404, medical questions, a fictional LLM-infused search engine.
  - First-person hedges ("I'm not sure, but…") lowered trust and agreement with the system and raised accuracy, by reducing (not eliminating) overreliance on wrong answers.
  - General-perspective hedges ("It's not clear, but…") had weaker, non-significant effects.
  - The authors conclude that wording matters, so test with users before deployment.
  - Sources: [arXiv 2405.00623](https://www.arxiv.org/abs/2405.00623); [FAccT PDF](https://facctconference.org/static/papers24/facct24-56.pdf)
- **Helena Vasconcelos, ..., Michael Bernstein, Ranjay Krishna (Stanford).** "Explanations Can Reduce Overreliance on AI Systems During Decision-Making" (PACM HCI / CSCW 2023).
  - People strategically weigh the cost of engaging with an explanation against the cost of simply relying on the AI (5 studies, N=731, maze task).
  - Explanations reduce overreliance when they are easier to understand or make verification cheaper. Earlier null results may come from explanations that didn't lower verification cost enough.
  - Sources: [arXiv 2212.06823](https://arxiv.org/abs/2212.06823); [Stanford HAI summary](https://hai.stanford.edu/news/ai-overreliance-problem-are-explanations-solution)
- **Elena Glassman (Harvard), with Ziwei Gu & Jonathan Kummerfeld.** "AI-Resilient Interfaces [Working Draft]" (arXiv 2405.08447, May 2024). Recovering from bad AI output depends on first noticing it, and many interfaces poorly support noticing and judging. Examples: AI-assisted QA through search, and AI-assisted document clustering. It is a working draft, not peer-reviewed in this form. — [arXiv 2405.08447](https://arxiv.org/html/2405.08447v1); [Glassman lab](https://glassmanlab.seas.harvard.edu)
- **Jeffrey Heer (UW).** "Agency plus automation: Designing artificial intelligence into interactive systems" (PNAS 116(6):1844–1850, 2019; DOI 10.1073/pnas.1807184115).
  - Argues for computational assistance that augments rather than replaces people's intellectual work.
  - The mechanism is shared representations that models and users can both propose, review, and revise.
  - Case studies: data wrangling, exploratory visualization, translation.
  - Sources: [PMC full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC6369770); [UW IDL page](https://idl.uw.edu/papers/agency-automation)
- **Ben Shneiderman (UMD).** In *Human-Centered AI* (Oxford UP, 2022) he places high human control together with high automation, and his explanation-related elements are "explainable user interfaces" and retrospective explanations. In a podcast he said good UI examples of post-hoc explanations were hard to find. That podcast was seen only as a search snippet and is not verified. — [Shneiderman, Issues in S&T, Winter 2021](https://issues.org/wp-content/uploads/2021/01/56%E2%80%9361-Shneiderman-Human-Centered-AI-Winter-2021.pdf); [HCAI talk slides](https://www.cs.umd.edu/~ben/misc_files/HCAI-BayCHI-Shneiderman-6-8-2021-v3.pdf)
- **Bret Victor.** "Explorable Explanations" (10 Mar 2011, postscript Feb 2024).
  - Critiques treating text as information to be consumed, and argues for active reading.
  - "Reactive documents" let readers play with the author's assumptions and see the consequences.
  - The essay is widely treated as the founding text of the explorable-explanation genre.
  - Sources: [worrydream.com](https://worrydream.com/ExplorableExplanations/); [Wikipedia: Explorable explanation](https://en.wikipedia.org/wiki/Explorable_explanation)
- **Arvind Satyanarayan (MIT Visualization Group).** "Intelligence as Agency: Evaluating the Capacity of Generative AI to Empower or Constrain Human Action" (2024; *An MIT Exploration of Generative AI* / ACM DOI 10.1145/3672539.3695751). The author list differs between sources (with or without Graham M. Jones). Only bibliographic records were seen, not the argument. — [MIT VIS page](https://vis.mit.edu/pubs/intelligence-as-agency)
- **Mina Lee (et al., 36 authors).** "A Design Space for Intelligent and Interactive Writing Assistants" (CHI 2024, DOI 10.1145/3613904.3642697). From a systematic review of 115 papers, it defines five aspects: task, user, technology, interaction, ecosystem. It is a design-space tool, not a readability prescription. — [arXiv 2403.14117](https://arxiv.org/abs/2403.14117)

### Inferences
- Agrawala, Heer, Glassman, and Victor converge on one point: understanding comes from things the reader can inspect, test, and revise (shared representations, editable output, reactive documents, noticing support). Static prose explanations alone are not enough. For AI-generated visual or interactive explanations, this supports letting readers manipulate parameters or inspect sources, not only view a polished picture.
- The Liao/Vaughan and Vasconcelos/Bernstein findings imply a writing rule: explanations should cut the reader's cost of checking the claim (cite, show the step, mark uncertainty in first person), not just add length.

### Gaps
- No 2022–2026 statements were found from Tamara Munzner or Daniel Weld specifically on LLM-generated explanations or visualizations (not searched in depth). Munzner's nested model and "what-why-how" framework are foundational but were not linked to AI here.
- No Bret Victor commentary on LLMs was found. The 2024 postscript's content was not read.
- Shneiderman's 2023–2026 LLM-specific statements were not located.
- Satyanarayan's essay content was not read.

## Q3. Research groups on AI-augmented reading and explanation (Semantic Reader/AI2, UW, Stanford, MIT): what makes AI explanations understandable?

### Takeaway
The Semantic Reader line (AI2, UW, Berkeley, and others) has the strongest evidence. In-situ, just-in-time help placed in the reading flow (definitions where a term appears, plain summaries next to sections, guiding questions) improves speed or ease without lowering comprehension. Newer LLM work shows that adapting the explanation to the reader helps comprehension. A single over-simplified "general" version drops detail that knowledgeable readers want, and personalization adds risks of hallucination and reinforcing the reader's biases.

### Cited Findings
- **Semantic Reader Project** (Kyle Lo, Joseph Chee Chang, Andrew Head, ..., Marti Hearst, Daniel Weld; 55 authors; arXiv 2303.14334, 2023; *CACM* 67(10), Oct 2024).
  - Ten research prototype interfaces, usability studies with more than 300 participants and real users.
  - Organized around five opportunities: discovery, efficiency, comprehension, synthesis, accessibility.
  - Motivated by the limits of the static PDF (inaccessible to low-vision readers, hard to read on mobile).
  - The team released an open reader platform.
  - Sources: [arXiv 2303.14334](https://arxiv.org/abs/2303.14334); [CACM article](https://cacm.acm.org/research/the-semantic-reader-project)
- **Andrew Head et al. — ScholarPhi** (CHI 2021, DOI 10.1145/3411764.3445648).
  - Just-in-time, position-sensitive definitions of terms and symbols. Where a term has several definitions, it shows the most recent one before the reader's position.
  - A lab study found significantly faster question answering while viewing less of the paper than with a standard reader.
  - A usability study found it helped researchers at all experience levels.
  - Sources: [arXiv 2009.14237](https://arxiv.org/abs/2009.14237); [NSF PAR copy](https://par.nsf.gov/servlets/purl/10302719)
- **Tal August et al. — Paper Plain** (2022, TOCHI; pre-LLM NLP).
  - Four features for lay readers of medical papers: definitions of unfamiliar terms, in-situ plain-language section summaries, key questions that guide readers to answering passages, and plain summaries of those passages.
  - Participants found papers easier to understand with no loss in comprehension compared to a standard PDF reader.
  - Sources: [arXiv 2203.00130](https://arxiv.org/pdf/2203.00130)
- **Tal August, Kyle Lo, Noah A. Smith, Katharina Reinecke — "Know Your Audience: The benefits and pitfalls of generating plain language summaries beyond the 'general' audience"** (CHI 2024, DOI 10.1145/3613904.3642289).
  - Most prior work tested a single simplified summary for a single general audience.
  - Readers with more background tended to disregard some details in overly plain summaries (e.g., study limitations).
  - The generated lower-complexity summaries tried to explain details rather than remove them.
  - Recommendation: use the plainest language only when the audience knows very little about the topic.
  - Abstract and intro only; effect sizes not read.
  - Sources: [arXiv 2403.04979](https://arxiv.org/abs/2403.04979); [author PDF](https://talaugust.github.io/assets/pdf/August2024Complexity.pdf)
- **ReLay** (Chan, ..., Lucy Lu Wang, Yue Guo; COLM 2026; arXiv 2605.00468).
  - 50 lay participants, 300 participant–summary pairs, comparing static expert-written and interactive LLM-personalized plain-language summaries. Five LLMs were tested with two personalization methods.
  - Personalization improved comprehension and perceived quality, but raised the risk of reinforcing user biases and introducing hallucinations (a personalization–safety trade-off).
  - Effect sizes were not on the abstract page.
  - Source: [arXiv 2605.00468](https://arxiv.org/abs/2605.00468)
- Related: an EMNLP 2024 paper on personalized reading-comprehension support found that automated metrics correlate poorly with human evaluations of concept simplification. — [ACL Anthology 2024.emnlp-main.357](https://aclanthology.org/2024.emnlp-main.357)

### Inferences
- The design pattern that holds up best in user studies is to keep help in context and on demand: show the definition where the term appears, put the summary next to its section, and let the reader drill down. This is progressive disclosure tied to the reader's position. The papers do not use the phrase "progressive disclosure", so the label is my inference.
- Choose the complexity level from what the reader already knows. When that is unknown, explaining a detail is safer than deleting it, based on August et al.'s method.
- Automated readability or simplification metrics are weak proxies. Human evaluation is needed (EMNLP 2024, plus Miletić & Falk's split between subjective ratings and the measured text features).

### Gaps
- MIT Media Lab findings on AI explanation readability were not located in this pass.
- No full-text numbers were read for Know Your Audience, ReLay, or the CACM Semantic Reader article.
- Tal August's ACL 2022 paper on generating scientific definitions with controllable complexity was not checked (I believe it exists, but it is unverified here).

## Q4. Expert consensus or debate (one-size vs reader-adapted; text vs visual; concise vs complete)

### Takeaway
- **One-size vs adapted.** There is broad agreement that one-size "general audience" explanations are a weak default. Liao & Vaughan, August et al., and ReLay all favor tailoring to the reader. The open debate is the cost of tailoring: hallucination, bias reinforcement, and dropped detail.
- **Concise vs complete.** The evidence favors "explain, don't delete" and on-demand depth over blanket brevity.
- **Text vs visual.** Experts lean toward inspectable or interactive representations over static output, but I found no head-to-head study for LLM explanations.

### Cited Findings
- **For adaptation:**
  - Transparency needs differ by stakeholder, goal, and context — [Liao & Vaughan 2023/2024](https://arxiv.org/abs/2306.01941)
  - Reserve the plainest language for readers with very little background — [August et al. CHI 2024](https://arxiv.org/abs/2403.04979)
  - Personalized LLM summaries improve comprehension — [ReLay, COLM 2026](https://arxiv.org/abs/2605.00468)
- **Against naive adaptation and simplification:**
  - Personalization raises hallucination and bias-reinforcement risk — [ReLay](https://arxiv.org/abs/2605.00468)
  - Over-plain summaries lose details such as limitations — [August et al.](https://arxiv.org/abs/2403.04979)
- **Concise vs complete:**
  - Mayer's coherence principle favors cutting extraneous material — [Mayer principles](https://www.unh.edu/teaching-learning-resource-hub/sites/default/files/media/2023-06/itow-research-based-principles-for-designing-multimedia-instruction-mayer.pdf)
  - Vasconcelos et al. show that what matters is whether the explanation lowers the cost of verifying, not its length — [arXiv 2212.06823](https://arxiv.org/abs/2212.06823)
  - ScholarPhi users answered faster while reading less text, because help appeared exactly where needed — [ScholarPhi](https://arxiv.org/abs/2009.14237)
- **Uncertainty phrasing:** first-person hedges reduce overreliance, and the exact wording matters — [Kim et al. FAccT 2024](https://www.arxiv.org/abs/2405.00623)
- **Interactive and inspectable over static:**
  - Reactive documents let readers test the author's assumptions — [Victor 2011](https://worrydream.com/ExplorableExplanations/)
  - Inspectable, editable output and repair over trial and error — [Agrawala 2023](https://magrawala.substack.com/p/unpredictable-black-boxes-are-terrible)
  - Shared, revisable representations — [Heer 2019](https://pmc.ncbi.nlm.nih.gov/articles/PMC6369770)
- **Caution for AI-generated visuals:** AI can produce visualizations and explanations fast enough to overwhelm learners if not curated — [arXiv 2311.06586](https://arxiv.org/pdf/2311.06586)
- **Measured vs perceived:** experts rate LLM-polished text more understandable even as lexical diversity falls, which shows a gap between perceived and measured quality — [Miletić & Falk LREC 2026](https://arxiv.org/abs/2605.19936)

### Inferences
- A defensible synthesis for an AI-writing guideline:
  1. Lead with the answer for the assumed reader, and state the assumption.
  2. Explain jargon in place rather than delete it.
  3. Put extra depth behind on-demand expansion, not inline.
  4. Make claims cheap to verify (sources, steps, first-person uncertainty).
  5. Add a visual or interactive element only when it gives the reader something to inspect or manipulate, not as decoration.

  This is a synthesis, not a stated consensus of any single source.

### Gaps
- No direct experimental comparison of text-only vs AI-generated visual/interactive explanations for LLM answers was found in this pass.
- No explicit, named debate (e.g., an exchange of papers) between these experts on concise vs complete LLM answers was found. The tension is inferred from separate findings.
