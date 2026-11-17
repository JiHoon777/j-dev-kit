# Python: end checks

Read by `server-end-check`. Add these rows to that skill's report.

## Missing migration

| Tool | Command |
| --- | --- |
| Alembic | `alembic check` fails → fail |
| Django | `python manage.py makemigrations --check` fails → fail |

## Apply from scratch (only after approval)

- Alembic: `alembic downgrade base && alembic upgrade head`
- Django: run the tests (the test database is created from all migrations), or reset the development database with the project's script.

## Order

- Alembic: more than one line from `alembic heads` → fail (a merge revision is needed).
- Django: `python manage.py makemigrations --check` reporting conflicting leaf nodes → fail (`makemigrations --merge` is needed).

## Environment variables read in code

Patterns on added lines: `os.environ[`, `os.environ.get(`, `os.getenv(`, pydantic `BaseSettings` fields, `env(` from django-environ.

## Rows to add

```markdown
| Missing migration | … | `alembic check` exit 0 |
```
