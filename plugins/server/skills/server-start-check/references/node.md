# Node (Express, NestJS, Fastify, Hono, Koa): 시작 점검

`server-start-check`가 읽는다.

## 지킬 것

- 요청 본문은 라우트 경계에서 프로젝트의 스키마 라이브러리(zod, class-validator 등)로 검증한다.
- NestJS: 인가는 guard, `ValidationPipe`에 `whitelist: true`(또는 프로젝트의 같은 설정).

## 마이그레이션 만들기 (서버 도구가 담당일 때)

| 도구 | 명령 |
| --- | --- |
| Prisma | `npx --no-install prisma migrate dev --name <이름>` |
| Drizzle | `npx --no-install drizzle-kit generate` |
| TypeORM | `npx --no-install typeorm migration:generate <경로> -d <DataSource>` |
| Atlas | `atlas migrate diff <이름>` |
