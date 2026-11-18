# Python (FastAPI, Django, Flask): 시작 점검

`server-start-check`가 읽는다.

## 지킬 것

- 입력은 프로젝트의 스키마 계층(FastAPI 는 pydantic 모델, Django 는 form·serializer)으로 검증하고, 응답 모델을 선언해 내부 필드가 나가지 않게 한다.
- 문자열 포매팅으로 SQL 을 만들지 않는다. ORM 이나 파라미터를 쓴다.

## 마이그레이션 만들기 (서버 도구가 담당일 때)

| 도구 | 명령 |
| --- | --- |
| Alembic | `alembic revision --autogenerate -m "<이름>"` 뒤 생성된 파일을 확인 |
| Django | `python manage.py makemigrations` |
