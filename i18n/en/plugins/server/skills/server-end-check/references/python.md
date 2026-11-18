> Translation. Source: [plugins/server/skills/server-end-check/references/python.md](../../../../../../../plugins/server/skills/server-end-check/references/python.md). Update this file when the source changes. Claude does not read this file.

# Python: end check

Read by `server-end-check`.

## Missing migrations and order

| Tool | Missing migrations | Order |
| --- | --- | --- |
| Alembic | `alembic check` fails → fail | `alembic heads` prints two or more lines → fail (merge revision needed) |
| Django | `python manage.py makemigrations --check` fails → fail | The same command reports a conflicting leaf node → fail (`makemigrations --merge`) |

## Config key patterns

`os.environ[`, `os.environ.get(`, `os.getenv(`, pydantic `BaseSettings` fields, django-environ `env(`.
