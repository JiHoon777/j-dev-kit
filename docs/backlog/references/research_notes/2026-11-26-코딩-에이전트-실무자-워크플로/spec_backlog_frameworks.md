# 스펙 주도·백로그 주도 코딩 에이전트 프레임워크 (2026-11-26 기준)

조사 범위: GitHub Spec Kit, AWS Kiro(spec 모드), BMAD Method, Backlog.md, Taskmaster AI, OpenSpec, Agent OS, cc-sdd(추가), 그리고 SDD 비판.
비교 대상: j-dev-kit(`/task create` → `docs/backlog/` 에 Backlog.md 형식 항목 + Acceptance Criteria, `/task start` → 워크트리 하위 세션 구현, `/task end` → 별도 판정 에이전트 리뷰 + 사용자 승인 후 머지), pstack(계획 스킬 없이 코드·프로토타입으로 계획).
스타·포크·릴리스 수치는 2026-11-26 에 GitHub 공개 API 로 직접 조회한 값이다(각 저장소 `api.github.com/repos/...`).

## 1. 누가 유지하고, 얼마나 쓰이나

### Takeaway
2026년 이 범주는 Spec Kit(15만 스타)과 OpenSpec(7.6만)이 압도적이고, BMAD(5.6만)·Taskmaster(2.9만)가 뒤를 잇는다. Taskmaster 는 2026-04 이후 저장소 활동이 멈췄고, Agent OS 는 2026-01 v3 에서 스펙 작성·구현 단계를 스스로 내려놓았다.

### Cited Findings
- **GitHub Spec Kit**: GitHub 조직 저장소. 스타 151,433 / 포크 13,617, 최신 릴리스 v1.4.5(2026-11-25), 마지막 푸시 2026-11-25 — [GitHub API](https://api.github.com/repos/github/spec-kit). README 에 개별 메인테이너 명단은 없고, 2026-10-16 "Open Source Friday" 영상에서 Manfred Riem·Nicole Haugen 이 "Spec Kit 1.0" 을 소개한다 — [README](https://github.com/github/spec-kit).
- **AWS Kiro**: AWS 의 IDE/CLI/Web/Mobile 제품. 2026년에 Analyze Requirements, Correctness(속성 기반 테스트, IDE 전용), 병렬 태스크 실행(IDE·CLI·Web·Mobile)이 추가됨 — [kiro.dev Specs](https://kiro.dev/docs/specs/). 사용 규모 수치는 공식 문서에서 찾지 못함.
- **BMAD Method**: `bmad-code-org`, 상표는 "BMad Code, LLC" 소유. 스타 55,767 / 포크 6,209, 안정판 v6.12.4(2026-10-14), v7 은 프리뷰 알파(잦은 호환 깨짐, 2026-11 중순 목표) — [GitHub API](https://api.github.com/repos/bmad-code-org/BMAD-METHOD), [README](https://github.com/bmad-code-org/BMAD-METHOD). README 에 개인 메인테이너 이름은 없음.
- **Backlog.md**: MrLesk 개인 저장소(MIT). 스타 7,495 / 포크 499, v1.57.4(2026-11-22) — [GitHub API](https://api.github.com/repos/MrLesk/Backlog.md), [README](https://github.com/MrLesk/Backlog.md).
- **Taskmaster AI (claude-task-master)**: Eyal Toledano 와 @RalphEcom, 회사는 Hamster(tryhamster.com) — [README](https://github.com/eyaltoledano/claude-task-master). 스타 28,552 / 포크 2,639, 최신 릴리스 task-master-ai@0.43.1(2026-03-31), 마지막 푸시 2026-04-28 — [GitHub API](https://api.github.com/repos/eyaltoledano/claude-task-master). 2026-04 의 마지막 커밋들은 retired 된 task-master.dev 링크를 tryhamster.com 으로 바꾸는 것 — [커밋 API](https://api.github.com/repos/eyaltoledano/claude-task-master/commits). 0.37.0 에서 Hamster 계정으로 parse-prd 추론을 대신하는 연동 추가(2차 요약) — [newreleases.io](https://newreleases.io/project/github/eyaltoledano/claude-task-master/release/task-master-ai@0.37.0).
- **OpenSpec**: Fission-AI 조직(개인 명단은 MAINTAINERS.md 로 링크, 연락처 @0xTab). 스타 75,756 / 포크 5,185, v2.2.0(2026-11-24) — [GitHub API](https://api.github.com/repos/Fission-AI/OpenSpec), [README](https://github.com/Fission-AI/OpenSpec).
- **Agent OS**: Brian Casel(Builder Methods). 스타 5,640 / 포크 830, v3.0.0(2026-01-20), 마지막 푸시 2026-10-07 — [GitHub API](https://api.github.com/repos/buildermethods/agent-os), [README](https://github.com/buildermethods/agent-os).
- **cc-sdd(추가)**: gotalab. "Kiro-inspired", 기존 Kiro 스펙과 호환. 스타 3,781, v3.1.0(2026-09-23). Claude Code·Codex 안정, 나머지 6개 에이전트 베타, 설치당 17개 스킬 — [README](https://github.com/gotalab/cc-sdd), [GitHub API](https://api.github.com/repos/gotalab/cc-sdd).
- **참고: obra/superpowers** 는 스타 326,931, v7.0.2(2026-11-03)로 규모는 가장 크지만 자신을 "agentic skills framework & software development methodology" 로 설명한다(스펙 프레임워크 전용은 아님) — [GitHub API](https://api.github.com/repos/obra/superpowers).
- **연구 근거(실사용)**: CMU 등 연구진(Agarwal, Singhal, Macvean, Vasilescu, Breaux)이 실무자 21명(도구 제작자 8명 포함) 인터뷰, 활성 저장소 266개 검토, 73,030개 공개 저장소의 스펙 파일 470,795개 코퍼스(SpecMine) 공개. 팀들은 SDD 를 주로 새 기능에 "선택적으로" 썼다 — [arXiv 2608.25202 (2026-08, v5 2026-11-16)](https://arxiv.org/abs/2608.25202).

### Inferences
- 스타 수는 관심도이지 사용 깊이가 아니다. 실제 사용에 대한 1차 근거는 위 arXiv 연구가 거의 유일하며, 그 결론은 "새 기능에만 선택적으로" 다.
- Taskmaster 는 사실상 유지보수 정체(7개월 무커밋)로 보이며, 상업 제품 Hamster 로 무게가 옮겨간 것으로 읽힌다(추론).

### Gaps
- Spec Kit 의 공식 메인테이너 명단, Kiro 사용자 수, BMAD 창시자 실명은 1차 출처에서 확인하지 못함(README·문서에 개인 이름 없음).

## 2. 어떤 파일을 어디에 만들고, 어떻게 최신으로 유지하나

### Takeaway
대부분이 "기능별 폴더에 spec/plan(design)/tasks 3종"을 만든다(Spec Kit, Kiro, OpenSpec, cc-sdd). 백로그 계열(Backlog.md, Taskmaster)은 태스크 하나가 단위다. 스펙을 코드 변경 후에도 살아 있게 하는 장치는 OpenSpec 의 archive(델타 병합)와 Kiro 의 Sync Files 정도이고, 대체로 약하다.

### Cited Findings
- **Spec Kit**: 기능별 `spec.md`, `plan.md`, `tasks.md`, 내장 `checklists/requirements.md`, 프로젝트 단위 constitution. 활성 기능은 `.specify/feature.json` 으로 추적 — [command reference](https://github.com/github/spec-kit/blob/main/docs/reference/agentic-sdd.md), [quickstart](https://github.com/github/spec-kit/blob/main/docs/quickstart.md). 버그·평가 확장은 `.specify/bugs/<slug>/`, `.specify/assessments/<slug>/`(결정 요약 `decision.md`) — [README](https://github.com/github/spec-kit). 2025-09 시점 테스트에서 한 기능에 data-model, plan, tasks, spec, research, api, component 등 8개 파일이 생김(2025-10 글) — [Böckeler, martinfowler.com](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html). 유지: README 는 "evolving existing specs" 가이드와 "Living Specs in SpecKit"(2026-10-15) 블로그로 링크만 함 — [README](https://github.com/github/spec-kit).
- **Kiro**: `.kiro/specs/` 아래 기능별 `requirements.md`(버그는 `bugfix.md`), `design.md`, `tasks.md` — [kiro.dev Specs](https://kiro.dev/docs/specs/), [best practices](https://kiro.dev/docs/specs/best-practices/). requirements 는 EARS 형식 "WHEN … THE SYSTEM SHALL …" — [Feature specs](https://kiro.dev/docs/specs/feature-specs/). 요구사항 변경 후 tasks.md 의 "Sync Files" 로 반영 — [best practices](https://kiro.dev/docs/specs/best-practices/). 스티어링 기본 파일 product.md, structure.md, tech.md(2025-10 글) — [Böckeler](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html).
- **OpenSpec**: 변경 단위 `openspec/changes/<change>/` 에 `proposal.md`, `specs/`(델타: `## ADDED Requirements` + WHEN/THEN 시나리오), `design.md`, `tasks.md`. 아카이브 시 `openspec/changes/archive/<date>-<name>/` 로 옮기고 현재 스펙 `openspec/specs/` 를 갱신 — [README](https://github.com/Fission-AI/OpenSpec). (병합 세부 동작은 README 에 없음.)
- **BMAD v6.12**: 의도가 정해지면 `bmad-spec` 이 `SPEC.md` 를 쓰고, 에픽 규모면 옆에 `stories.yaml`; PRD 경로는 에픽 파일 + `sprint-status.yaml`. Build 실행마다 "implementation record" 를 스펙·스토리 옆에 남김 — [Break Work into Stories](https://github.com/bmad-code-org/BMAD-METHOD/blob/v6.12.4/docs/plan/break-work-into-stories-and-track-it.md), [Build a Change](https://github.com/bmad-code-org/BMAD-METHOD/blob/v6.12.4/docs/build/build-a-change.md). sprint-status 재생성은 끝난 일을 보존하고 드리프트를 dry run 으로 보고 — 같은 문서.
- **Backlog.md**: `backlog/`(설정 가능) 아래 태스크마다 md 파일 1개, YAML 프런트매터 + Description, Acceptance Criteria 체크리스트, Implementation Plan, Implementation Notes/Final Summary, Definition of Done(프로젝트 기본값 + `--dod`). docs, drafts, decisions 명령 있음 — [README](https://github.com/MrLesk/Backlog.md).
- **Taskmaster**: PRD `.taskmaster/docs/prd.txt` → `tasks.json`. 태스크 필드 status, dependencies, priority, details, testStrategy, subtasks — [README](https://github.com/eyaltoledano/claude-task-master), [task-structure.md](https://github.com/eyaltoledano/claude-task-master/blob/main/docs/task-structure.md).
- **Agent OS v3**: 표준(`/discover-standards`, `index.yml` 로 자동 선택), 스펙은 Plan mode 결과를 Agent OS spec 폴더에 저장 — [CHANGELOG 3.0 (2026-01-20)](https://github.com/buildermethods/agent-os/blob/main/CHANGELOG.md).
- **cc-sdd v3**: `/kiro-discovery` 가 `brief.md`, 필요 시 `roadmap.md` 를 씀. `design.md` 에 File Structure Plan, 태스크에 `_Boundary:_`, `_Depends:_` 주석, 학습 내용은 `tasks.md` 의 `## Implementation Notes` 로 전파 — [README](https://github.com/gotalab/cc-sdd).
- 연구: 실무자들은 스펙에 구현 세부까지 넣는 경향이 있고, 이것이 에이전트에는 도움이 되지만 스펙을 낡게 만든다(spec drift) — [arXiv 2608.25202](https://arxiv.org/abs/2608.25202).

### Inferences
- j-dev-kit 의 백로그 항목은 Backlog.md 형식(설명 + AC + 계획 + 메모)이라 Spec Kit/Kiro 의 3파일보다 가볍다. 파일 하나에 AC 와 구현 메모를 함께 두는 방식은 Backlog.md·cc-sdd(`Implementation Notes`)·BMAD(implementation record)와 같은 방향이다.
- "스펙을 계속 최신으로" 를 진지하게 하는 곳은 OpenSpec(변경 델타 → 현재 스펙 병합) 정도다. 백로그 항목은 변경 단위 기록이므로 spec-first(Böckeler 분류)에 해당하고, 이걸 스펙 문서로 계속 유지하려 하지 않는 편이 drift 문제를 피한다.

### Gaps
- OpenSpec archive 의 델타 병합 규칙, Kiro tasks.md 의 정확한 형식(선택 태스크 표시 등)은 이번에 1차 출처에서 확인하지 못함.

## 3. 흐름과 사람 승인 지점

### Takeaway
Spec Kit·Kiro·cc-sdd 는 단계마다 사람이 검토하는 "단계 게이트"가 기본이다. 2026년 흐름은 게이트를 줄이는 쪽으로 움직였다: Kiro Quick Spec(게이트 없음), Spec Kit 의 clarify/checklist/analyze 는 선택, BMAD 는 "작은 변경은 바로 빌드", Agent OS 는 스펙 작성을 Plan mode 에 넘겼다.

### Cited Findings
- **Spec Kit**: 전체 순서 constitution → specify → clarify → plan → checklist → tasks → analyze → implement → converge. "specify 만 plan 전에 엄격히 필요", clarify/checklist/analyze 는 모호함이 있을 때 붙이는 선택 게이트 — [command reference](https://github.com/github/spec-kit/blob/main/docs/reference/agentic-sdd.md). README 최소 흐름은 6개 명령을 "하나씩, 결과를 검토하며" 실행 — [README](https://github.com/github/spec-kit). clarify 는 회당 최대 5개 질문, 필요한 만큼 반복 — [reference](https://github.com/github/spec-kit/blob/main/docs/reference/agentic-sdd.md). implement 는 체크리스트에 미체크 항목이 있으면 진행 전에 묻는다; 커스텀 체크리스트는 리뷰어 소유이고 구현이 "silently self-approve" 하면 안 됨 — 같은 문서.
- **Kiro**: Requirements → Design → Tasks 3단계(Requirements-First 또는 Design-First). Quick Spec 은 세 산출물을 "without approval gates" 로 한 번에 만듦 → 기본 Feature Spec 은 단계 간 승인 게이트가 있음(문서 문맥상 추론). 문서마다 Review 버튼으로 구간별 코멘트 후 일괄 전송 — [kiro.dev Specs](https://kiro.dev/docs/specs/), [Feature specs](https://kiro.dev/docs/specs/feature-specs/).
- **OpenSpec**: 기본 프로필은 explore(선택) → propose → apply-change → archive-change. 문서화된 게이트는 코드 전에 사람이 계획을 검토하는 것 하나. Spec Kit 을 "thorough but heavyweight", 경직된 단계 게이트라 비교하며 자신은 "lighter" 라고 주장(자기 주장) — [README](https://github.com/Fission-AI/OpenSpec).
- **BMAD v6.12**: 핵심 질문은 "의도가 이미 잘 정의됐나". 그렇다면 `bmad-spec` → `bmad-build`; 아니면 독립 도구들로 의도를 다듬는다("stages 가 아니라 tools"). 명백하고 위험 낮은 수정엔 BMad 자체가 불필요 — [Choose a Planning Path](https://github.com/bmad-code-org/BMAD-METHOD/blob/v6.12.4/docs/plan/choose-a-planning-path.md). `bmad-build` 는 사람 체크포인트가 있고, 열린 질문은 "작업 전 인터뷰"가 아니라 완성된 설계 위의 질문으로 나오며, 요청 시 계획 승인 — [Build a Change](https://github.com/bmad-code-org/BMAD-METHOD/blob/v6.12.4/docs/build/build-a-change.md). PRD 경로는 구현 전 readiness 게이트(PASS/CONCERNS/FAIL, CONCERNS 는 사용자가 진행 여부 선택) — [Break Work into Stories](https://github.com/bmad-code-org/BMAD-METHOD/blob/v6.12.4/docs/plan/break-work-into-stories-and-track-it.md). 문서 문구: 사람 주의가 "by far the most expensive resource" — [Build a Change](https://github.com/bmad-code-org/BMAD-METHOD/blob/v6.12.4/docs/build/build-a-change.md).
- **Backlog.md** 권장 흐름: 에이전트가 AC 달린 작은 태스크로 쪼갬 → 사람 검토 → 세션당 태스크 1개, PR 1개 → 에이전트가 구현 계획을 태스크에 쓰고 사람이 승인한 뒤 코딩 → 구현 후 사람이 코드 리뷰·테스트·Done 처리. 결과가 나쁘면 계획·메모를 지우고 태스크를 다듬어 새 세션에서 재실행 — [README](https://github.com/MrLesk/Backlog.md).
- **Taskmaster**: PRD 작성 → parse-prd → list/show/next → expand → set status. 명시적 승인 게이트 서술 없음 — [README](https://github.com/eyaltoledano/claude-task-master).
- **Agent OS v3**: 스펙 작성은 Plan mode 로 넘기고 `/shape-spec` 이 표준·미션을 고려한 질문을 던짐, 제품 계획은 AskUserQuestion 사용, 태스크 분해·구현 오케스트레이션 단계는 폐기("frontier models handle this well") — [CHANGELOG 3.0](https://github.com/buildermethods/agent-os/blob/main/CHANGELOG.md).
- **cc-sdd v3**: "Agents write the spec, humans approve the contract at phase gates". `/kiro-discovery` 가 요청을 기존 스펙 확장/스펙 없이 바로 구현/새 스펙/다중 스펙으로 분기 — [README](https://github.com/gotalab/cc-sdd).
- 연구: 단계별 사용자 승인 + 리뷰어 서브에이전트 게이트를 쓴 저자 자체 사례연구(9개 기능, 7개 프로젝트)에서 계획된 581개 태스크 중 288개 완료, 9개 중 5개 기능만 전부 완료 — [arXiv 2611.05094 (2026-11)](https://arxiv.org/abs/2611.05094).

### Inferences
- 기능 하나에 필요한 사람 개입 횟수(추정): Spec Kit 최소 흐름은 단계 검토 5~6회 + clarify 질문 최대 5개/회, Kiro 기본은 단계 승인 3회, OpenSpec·Backlog.md 는 계획 검토 1회 + 최종 리뷰 1회, BMAD build 는 열린 질문 + 계획 승인(요청 시)으로 1~2회. 이 숫자는 문서 흐름에서 센 것이며 측정값이 아니다.
- 2026년의 공통 방향은 "크기에 따라 진입점을 다르게"(Kiro Quick Spec, BMAD 경로 선택, cc-sdd discovery 분기, Spec Kit 선택 게이트)다. j-dev-kit 백로그 016(계획 승인 제거)은 BMAD·Agent OS 의 방향과 맞는다.

### Gaps
- Kiro 기본 Feature Spec 의 정확한 승인 위치(어느 전이에 승인이 필수인지)는 문서에 명시돼 있지 않음.
- 기능당 실제 질문·승인 횟수를 측정한 1차 데이터는 찾지 못함.

## 4. 누가 구현하고, 완료는 어떻게 판정하나

### Takeaway
구현은 대부분 같은 에이전트 세션이 한다. 판정 방식은 갈린다: Spec Kit 은 같은 흐름 안의 append-only "converge" 루프, BMAD 와 cc-sdd 는 병렬·독립 리뷰어 에이전트, Backlog.md·Taskmaster 는 사람과 테스트에 맡긴다. j-dev-kit 의 "별도 판정 에이전트" 방식은 BMAD·cc-sdd 쪽에 가깝다.

### Cited Findings
- **Spec Kit**: implement 는 tasks.md 를 단계·의존 순서대로 실행, 큰 기능은 범위를 나눠 단계마다 검증 권장. converge 는 코드베이스를 spec/plan/tasks 와 대조해 빠진 것을 찾고 "append-only"(코드는 수정하지 않고 tasks.md 에 Convergence 섹션 태스크만 추가). "Converged" 가 나올 때까지 implement ↔ converge 반복. analyze 는 spec/plan/tasks 일관성만 읽기 전용으로 점검 — [command reference](https://github.com/github/spec-kit/blob/main/docs/reference/agentic-sdd.md). 버그 확장은 verified/partial/failed 판정 — [README](https://github.com/github/spec-kit).
- **Kiro**: 태스크 진행 상태 실시간 표시, 개별 또는 전체 실행, tasks.md 의존 그래프로 독립 태스크를 웨이브 단위 병렬 실행; Correctness 기능으로 속성 기반 테스트(IDE 전용) — [kiro.dev Specs](https://kiro.dev/docs/specs/).
- **BMAD**: `bmad-build` 에 리뷰·트리아지 단계가 내장. `bmad-code-review` 는 새 채팅에서 실행하며 4개 레이어 `blind-hunter`, `edge-case-hunter`, `verification-gap`, `acceptance-auditor` 가 같은 diff 를 독립·병렬로 보고 트리아지가 발견 하나하나를 판정. 스펙을 주지 않으면 리뷰어는 diff 를 diff 자체로만 판단. 세 번째 패스에서도 중요한 발견이 나오면 상류(약한 스펙·모순)를 고치라고 함 — [Review a Change](https://github.com/bmad-code-org/BMAD-METHOD/blob/v6.12.4/docs/build/review-a-change.md). 무인 실행용 `bmad-build-auto`, 에픽 회고 `bmad-retrospective`(acceptance verdict) — [Build a Change](https://github.com/bmad-code-org/BMAD-METHOD/blob/v6.12.4/docs/build/build-a-change.md).
- **cc-sdd v3 `/kiro-impl`**: 네이티브 서브에이전트가 있으면 태스크마다 새 구현자(TDD RED→GREEN, 기능 플래그 뒤), 독립 리뷰어, 막히거나 리뷰 반려가 반복되면 auto-debug. 없으면 인라인 리뷰. 리뷰·검증은 경계 위반을 봄 — [README](https://github.com/gotalab/cc-sdd).
- **Backlog.md**: 구현 후 사람이 코드 리뷰, 테스트 실행, Done 표시; DoD 체크리스트 — [README](https://github.com/MrLesk/Backlog.md).
- **Taskmaster**: 태스크별 `testStrategy` 필드(검증 방법 서술) — [task-structure.md](https://github.com/eyaltoledano/claude-task-master/blob/main/docs/task-structure.md). 판정 주체에 대한 서술은 없음.
- **Agent OS v3**: 구현·오케스트레이션 단계 자체를 폐기 — [CHANGELOG 3.0](https://github.com/buildermethods/agent-os/blob/main/CHANGELOG.md).
- 연구: 스펙-코드 대조는 주로 변경이 끝났을 때 이뤄지고 지속적으로 하지 않는다 — [arXiv 2608.25202](https://arxiv.org/abs/2608.25202). 게이트형 워크플로 사례에서 가장 약한 지점은 "자기 검사를 직접 돌리고 판정하는" 오케스트레이터였고, 파일 목록 검사가 247회 블록 점검 중 11회 미선언 변경을 잡음 — [arXiv 2611.05094](https://arxiv.org/abs/2611.05094).

### Inferences
- "구현한 쪽이 스스로 판정하면 약하다"는 점은 2611.05094 의 결론과 BMAD 의 다층 독립 리뷰 설계가 함께 뒷받침한다. j-dev-kit 의 별도 판정 에이전트는 이 흐름과 맞다.
- BMAD 의 "스펙 없이 리뷰하면 diff 만 본다", "3차 리뷰에도 중요한 발견이면 상류 문제" 는 j-dev-kit `/task end` 에 그대로 빌릴 만한 규칙이다(판정자에게 항목 AC 를 꼭 넘기고, 리뷰 반복 횟수에 상한을 두기).
- Spec Kit converge 의 "판정은 코드를 고치지 않고 할 일만 추가" 원칙도 판정 에이전트의 읽기 전용 성격과 같다.

### Gaps
- Spec Kit converge 가 별도 에이전트로 도는지 같은 세션에서 도는지는 문서에 없음.
- 각 도구의 판정 방식이 결함을 실제로 줄였다는 독립 측정은 찾지 못함(Taskade 블로그가 언급한 ESEM 2026 연구는 1차 출처 미확인).

## 5. 결정 기록과 세션 간 재개

### Takeaway
재개는 거의 모두 "git 에 남은 마크다운/상태 파일"에 기대며, 별도 재개 메커니즘은 드물다. 결정 기록은 Spec Kit 평가 확장의 `decision.md`, Backlog.md 의 decisions, Agent OS 의 표준 파일, BMAD 의 implementation record·회고 정도다.

### Cited Findings
- **Spec Kit**: `.specify/feature.json` 이 활성 기능 디렉터리를 기록하고 명령은 이 상태로 기능을 찾음 — [quickstart](https://github.com/github/spec-kit/blob/main/docs/quickstart.md). 아이디어 평가는 go/clarify/stop 결정을 `decision.md` 로 남기고 go 면 그 요약을 specify 에 넘김 — [README](https://github.com/github/spec-kit). Böckeler 는 기능별 브랜치 방식이라 스펙이 변경 요청 하나 동안만 사는 것 같다고 봄(2025-10) — [martinfowler.com](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html).
- **Backlog.md**: 전용 재개 기능은 없고 태스크가 git 에 남으며, 에이전트는 `backlog instructions overview` 로 시작. MCP(`backlog mcp start`, `backlog://workflow/overview`) 선택, 터미널·웹 칸반 보드 제공 — [README](https://github.com/MrLesk/Backlog.md).
- **BMAD**: v6.12 는 `bmad-help`, v7 은 `bmad status` 로 다음 할 일 확인 — [README](https://github.com/bmad-code-org/BMAD-METHOD). sprint-status.yaml 을 Build 가 동기화하고, 회고가 액션 아이템을 추가 — [Break Work into Stories](https://github.com/bmad-code-org/BMAD-METHOD/blob/v6.12.4/docs/plan/break-work-into-stories-and-track-it.md).
- **cc-sdd**: `brief.md`/`roadmap.md` 로 범위를 다시 설명하지 않고 워크스트림 재개 — [README](https://github.com/gotalab/cc-sdd).
- **Taskmaster**: `next` 로 의존성이 풀린 다음 태스크 선택, tags 로 워크스트림 분리 — [README](https://github.com/eyaltoledano/claude-task-master).
- **OpenSpec**: 구현 전에 컨텍스트를 비우라고 권장; 재개 서술 없음. Stores(베타)로 여러 저장소가 스펙 공유 — [README](https://github.com/Fission-AI/OpenSpec).
- **Agent OS**: 동기는 에이전트가 코드만 봐서는 알 수 없는 관례·아키텍처 결정을 세션마다 다시 배우는 문제 — [buildermethods.com/agent-os](https://buildermethods.com/agent-os).

### Inferences
- j-dev-kit 의 백로그 항목 + 구현 메모 방식은 Backlog.md·cc-sdd 와 같은 "파일이 곧 재개 지점" 모델이다. 추가로 빌릴 만한 것은 BMAD 의 상태 질의(`bmad status`)처럼 "다음에 뭘 돌릴지"를 알려주는 가벼운 진입점 정도다.

### Gaps
- Kiro 의 세션 간 재개·결정 기록 방식은 이번에 확인한 문서에 없음.

## 6. 알려진 문제·비판, 그리고 j-dev-kit 이 빌릴 것과 피할 것

### Takeaway
신뢰할 만한 비판은 세 갈래다: (1) 한 가지 무거운 흐름이 작은 일에 과하다, (2) 마크다운 리뷰 부담이 크고 에이전트가 스펙을 잘 안 따른다, (3) 미리 다 정하는 것은 워터폴이고 알 수 없는 것은 스펙으로 못 쓴다. 도구 쪽도 이를 받아들여 2026년에 가벼운 경로를 추가했고, Agent OS 는 스펙 작성을 아예 Plan mode 에 넘겼다.

### Cited Findings
- **Birgitta Böckeler(Thoughtworks), 2025-10-15**: 작은 버그에 Kiro 는 "sledgehammer to crack a nut", 작은 버그 하나가 사용자 스토리 4개·AC 16개가 됨. Spec Kit 은 반복적이고 장황한 파일이 많아 리뷰가 지루했고 차라리 코드를 리뷰하겠다고 함. 에이전트가 기존 클래스를 적은 research 노트를 무시하고 중복 생성, constitution 규칙을 과적용. 세 도구 모두 실질적으로 spec-first — [martinfowler.com](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html).
- **Marmelab, 2025-11-12**: SDD 가 무거운 사전 문서화를 되살리고, 에이전트가 스펙을 늘 따르지는 않으며, 대부분의 경우 이득이 적고 비용을 늘리기도 한다는 주장(검색 요약 기반 2차 정리) — [Marmelab](https://marmelab.com/blog/2025/11/12/spec-driven-development-waterfall-strikes-back.html).
- **Johnny Butler(HEY 블로그)**: 소프트웨어는 모르는 것투성이라 모르는 것은 스펙으로 쓸 수 없고, 스펙이 얇으면 에이전트가 빈칸을 채운다는 요지(검색 요약 기반, 날짜 미확인) — [world.hey.com](https://world.hey.com/johnnybutler/spec-first-ai-is-just-waterfall-with-better-typing-35a91a66).
- **Maxim Saplin, dev.to**: 작은 작업에서는 Plan mode 를 "alignment ceremony" 로 쓰는 편이 이전 Kiro SDD 시도보다 나았다는 일화적 실험(검색 요약 기반, 날짜 미확인) — [dev.to](https://dev.to/maximsaplin/ai-dev-plan-mode-vs-sdd-a-weekend-experiment-f8e).
- **Brian Casel(Agent OS) 자기 비판, 2026-01-20**: Plan mode, 확장 사고, 개선된 모델이 예전 스캐폴딩을 대신하므로 스펙 작성·태스크 분해·구현 오케스트레이션을 재발명하지 않겠다며 v3 에서 해당 단계를 폐기 — [CHANGELOG 3.0](https://github.com/buildermethods/agent-os/blob/main/CHANGELOG.md).
- **OpenSpec 의 경쟁 비판(자기 주장)**: Spec Kit 은 무겁고 단계 게이트가 경직적이며 마크다운이 많다; Kiro 는 IDE 종속 — [README](https://github.com/Fission-AI/OpenSpec).
- **실증 연구 2026**: 실무자들은 에이전트 행동이 더 믿을 만해졌다고 하면서도 계획·리뷰 비용이 늘었다고 보고; 이득은 위임 전에 의도를 명확히 하는 데서 온다 — [arXiv 2608.25202](https://arxiv.org/abs/2608.25202). 게이트형 흐름에서도 계획한 태스크의 약 절반만 완료, 판정자를 겸하는 오케스트레이터가 약점 — [arXiv 2611.05094](https://arxiv.org/abs/2611.05094).
- **BMAD 자체 문서**: 명백하고 위험 낮은 수정에는 BMad 가 불필요; `bmad-spec` 입력은 수만 토큰(약 40쪽)이 실질 한계라 큰 자료 더미를 넘기면 중요한 부분을 "silently" 잃는다 — [Choose a Planning Path](https://github.com/bmad-code-org/BMAD-METHOD/blob/v6.12.4/docs/plan/choose-a-planning-path.md).
- Fowler·Beck 의 "사양 전체를 먼저 쓰기" 비판, Thoughtworks Radar 2025-11 의 SDD "Assess" 배치는 2차 기사(Levelup)로만 확인 — [levelup.gitconnected.com](https://levelup.gitconnected.com/sdd-kent-beck-and-martin-fowler-why-spec-anchored-development-wins-a4c838d5be11).

### Inferences
- **빌릴 것**
  - 크기별 진입점: BMAD "의도가 정의됐나?" 질문, cc-sdd discovery 분기, Kiro Quick Spec. `/task create` 에서 작은 일은 AC 몇 줄로 끝내는 경로.
  - 판정 규칙: 판정자에게 AC 를 반드시 넘김(BMAD), 판정자는 코드를 고치지 않고 남은 일만 보고(Spec Kit converge·analyze), 리뷰 반복 상한과 "3차에도 중요하면 항목(상류)을 고쳐라"(BMAD).
  - 구현 메모를 항목 파일에 누적(Backlog.md Implementation Notes, cc-sdd), 결과가 나쁘면 계획·메모를 지우고 항목을 다듬어 새 세션에서 재실행(Backlog.md).
  - AC 를 EARS 나 WHEN/THEN 처럼 판정 가능한 문장으로 쓰는 관례(Kiro, OpenSpec) — 단 형식 강제는 선택.
- **피할 것**
  - 기능마다 3~8개 문서를 만드는 다단계 흐름과 단계마다 승인(Böckeler 의 리뷰 부담 비판, 2611.05094 의 낮은 완료율).
  - 스펙을 장기 "살아 있는 문서"로 유지하려는 시도: drift 가 생기고(2608.25202) 대부분 도구가 실제로는 spec-first 에 머문다. 백로그 항목은 변경 기록으로 두고 끝난 뒤 갱신 의무를 지우지 않는 편이 맞다.
  - 구현 세부를 항목에 과하게 적기(에이전트에는 도움이지만 drift 원인).
  - 큰 자료를 통째로 계획 단계에 넣기(BMAD 의 토큰 한계 경고).
- **pstack 과의 관계(추론)**: Agent OS v3 의 "스펙 작성은 Plan mode 에 맡긴다", Böckeler 의 "차라리 코드를 리뷰" 는 계획 스킬 없이 코드·프로토타입으로 계획하는 pstack 쪽 논리와 통한다. j-dev-kit 은 그 사이에서 "AC 만 사전에, 계획은 구현 세션 안에서" 로 두는 것이 이 근거들과 가장 잘 맞는다.

### Gaps
- pstack(Lauren Tan) 자체는 이번 조사 범위 밖이라 1차 출처를 확인하지 않았다.
- Marmelab·Butler·Saplin 글은 검색 요약으로만 봤다(원문 미열람). 정량적 근거는 arXiv 2편이 전부이며, 2611.05094 는 저자 자신의 프로젝트 사례연구라 일반화가 어렵다.
- Taskade 블로그가 인용한 "ESEM 2026: 스펙 산출물만으로는 결함 감소 없음" 은 1차 출처를 찾지 못했다.
- Tessl 등 기타 2026 도구의 현황은 조사하지 못했다(Böckeler 2025-10 글에서만 언급: 스펙 1개 ↔ 코드 파일 1개, "GENERATED FROM SPEC - DO NOT EDIT").
