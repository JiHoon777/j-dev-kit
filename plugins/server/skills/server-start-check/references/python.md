# Python (FastAPI, Django, Flask): start checks

Read by `server-start-check`. Add these rows and baseline lines to that skill's report.

## 1. Install and runtime

- Install without changing the lockfile, inside the project's virtual environment: `uv sync --frozen` (uv.lock) / `poetry install --sync` (poetry.lock) / `pip install -r requirements.txt`. Failure → **stop**.
- Compare `.python-version` or `requires-python` with `python --version`. Mismatch → fail.

## 2. LSP

Check that the `pyright-lsp` plugin is enabled and `pyright-langserver` is on PATH. If not, it is not a failure; return it as a question (the user installs it: `npm i -g pyright` or `pipx install pyright`).

## 3. Migration status

Unapplied migrations → fail (return a question about applying them). Diverged history (several heads) → **stop**.

| Detected | Tool | Applied status | Model vs migrations (missing migration) |
| --- | --- | --- | --- |
| `alembic.ini` | Alembic | `alembic current --check-heads` (1.17.1+). Older: compare `alembic current` with `alembic heads` | `alembic check` (1.9+) |
| `manage.py` + `*/migrations/` | Django | `python manage.py migrate --check` | `python manage.py makemigrations --check` |

## 4. Baseline

Use the verification command from the project's CLAUDE.md. If the verification command chains several checks (for example `pnpm lint && pnpm check && pnpm test && pnpm build`), run each part separately, so a failure in one does not hide the others. If CLAUDE.md has no verification command, use only what the config files set up: `ruff check`, `mypy`, `pytest`. Record command, exit code, failure count, and failing names (first 10 if many).

## 5. Rules during implementation (to return)

- Validate input with the project's schema layer (pydantic models in FastAPI, forms or serializers in Django) and declare response models so internal fields are not returned.
- Django: never build SQL with string formatting; use the ORM or parameters.

## Rows to add

```markdown
| Install | … | uv sync --frozen |
| Python version | … | … |
| LSP | … | pyright-lsp missing → question |
| Migration status | … | `alembic current --check-heads` exit 0 |
```
