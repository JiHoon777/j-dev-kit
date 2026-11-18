> Translation. Source: [plugins/server/skills/server-start-check/references/python.md](../../../../../../../plugins/server/skills/server-start-check/references/python.md). Update this file when the source changes. Claude does not read this file.

# Python (FastAPI, Django, Flask): start check

Read by `server-start-check`.

## Follow

- Validate input with the project's schema layer (pydantic models in FastAPI, forms and serializers in Django), and declare response models so internal fields do not go out.
- Do not build SQL with string formatting. Use the ORM or parameters.

## Creating migrations (when the server tool is the owner)

| Tool | Command |
| --- | --- |
| Alembic | `alembic revision --autogenerate -m "<name>"`, then check the generated file |
| Django | `python manage.py makemigrations` |
