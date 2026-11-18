# Python: 마무리 점검

`server-end-check`가 읽는다.

## 빠진 마이그레이션과 순서

| 도구 | 빠진 마이그레이션 | 순서 |
| --- | --- | --- |
| Alembic | `alembic check` 실패 → 실패 | `alembic heads`가 두 줄 이상 → 실패(merge revision 필요) |
| Django | `python manage.py makemigrations --check` 실패 → 실패 | 같은 명령이 conflicting leaf node 를 보고 → 실패(`makemigrations --merge`) |

## 설정 키 패턴

`os.environ[`, `os.environ.get(`, `os.getenv(`, pydantic `BaseSettings` 필드, django-environ `env(`.
