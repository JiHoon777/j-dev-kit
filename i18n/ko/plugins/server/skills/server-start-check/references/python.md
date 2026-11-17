> 번역본입니다. 원문은 [plugins/server/skills/server-start-check/references/python.md](../../../../../../../plugins/server/skills/server-start-check/references/python.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# Python (FastAPI, Django, Flask): 시작 점검

`server-start-check`가 읽는다. 아래 행과 기준선 줄을 그 스킬의 보고에 더한다.

## 1. 설치와 런타임

- 프로젝트의 가상 환경 안에서 lockfile 을 바꾸지 않고 설치한다: `uv sync --frozen` (uv.lock) / `poetry install --sync` (poetry.lock) / `pip install -r requirements.txt`. 실패 → **중단**.
- `.python-version`이나 `requires-python`을 `python --version`과 비교한다. 맞지 않음 → 실패.

## 2. LSP

`pyright-lsp` 플러그인이 켜져 있고 `pyright-langserver`가 PATH 에 있는지 확인한다. 아니면 실패가 아니라 질문으로 돌려준다(설치는 사용자가 한다: `npm i -g pyright` 또는 `pipx install pyright`).

## 3. 마이그레이션 상태

적용 안 된 마이그레이션 → 실패(적용할지 질문으로 돌려준다). 갈라진 이력(head 가 여러 개) → **중단**.

| 판별 근거 | 도구 | 적용 상태 | 모델 대 마이그레이션 (빠진 마이그레이션) |
| --- | --- | --- | --- |
| `alembic.ini` | Alembic | `alembic current --check-heads` (1.17.1+). 그보다 옛 버전: `alembic current`와 `alembic heads`를 비교 | `alembic check` (1.9+) |
| `manage.py` + `*/migrations/` | Django | `python manage.py migrate --check` | `python manage.py makemigrations --check` |

## 4. 기준선

프로젝트 CLAUDE.md 의 검증 명령을 쓴다. 검증 명령이 여러 점검을 이어 붙인 것이면(예: `pnpm lint && pnpm check && pnpm test && pnpm build`) 하나가 실패해도 나머지가 가려지지 않도록 각 부분을 따로 돌린다. CLAUDE.md 에 검증 명령이 없으면 설정 파일에 갖춰진 것만: `ruff check`, `mypy`, `pytest`. 명령, exit code, 실패 개수, 실패한 이름(많으면 처음 10개)을 기록한다.

## 5. 구현 중 지킬 것 (돌려줄 것)

- 입력은 프로젝트의 스키마 계층(FastAPI 는 pydantic 모델, Django 는 form 이나 serializer)으로 검증하고, 응답 모델을 선언해 내부 필드가 나가지 않게 한다.
- Django: 문자열 포매팅으로 SQL 을 절대 만들지 않는다. ORM 이나 파라미터를 쓴다.

## 더할 행

```markdown
| Install | … | uv sync --frozen |
| Python version | … | … |
| LSP | … | pyright-lsp missing → question |
| Migration status | … | `alembic current --check-heads` exit 0 |
```
