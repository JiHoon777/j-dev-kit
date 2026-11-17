> 번역본입니다. 원문은 [plugins/server/skills/server-end-check/references/python.md](../../../../../../../plugins/server/skills/server-end-check/references/python.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# Python: 종료 점검

`server-end-check`가 읽는다. 아래 행을 그 스킬의 보고에 더한다.

## 빠진 마이그레이션

| 도구 | 명령 |
| --- | --- |
| Alembic | `alembic check`가 실패 → 실패 |
| Django | `python manage.py makemigrations --check`가 실패 → 실패 |

## 처음부터 다시 적용 (승인 후에만)

- Alembic: `alembic downgrade base && alembic upgrade head`
- Django: 테스트를 돌리거나(테스트 데이터베이스는 모든 마이그레이션으로 만들어진다), 프로젝트의 스크립트로 개발 데이터베이스를 초기화한다.

## 순서

- Alembic: `alembic heads`의 결과가 한 줄보다 많음 → 실패(merge revision 이 필요하다).
- Django: `python manage.py makemigrations --check`가 conflicting leaf node 를 보고함 → 실패(`makemigrations --merge`가 필요하다).

## 코드에서 읽는 환경 변수

추가된 줄에서 찾을 패턴: `os.environ[`, `os.environ.get(`, `os.getenv(`, pydantic `BaseSettings` 필드, django-environ 의 `env(`.

## 채울 줄

보고서 표에서 맞는 줄을 채운다(같은 줄을 하나 더 만들지 않는다):

```markdown
| Missing migration | … | `alembic check` exit 0 |
```
