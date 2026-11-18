# Node: 마무리 점검

`server-end-check`가 읽는다.

## 빠진 마이그레이션

| 도구 | 명령 (모델은 바뀌었는데 마이그레이션이 없으면 실패) |
| --- | --- |
| Prisma | `npx --no-install prisma migrate diff --from-migrations prisma/migrations --to-schema prisma/schema.prisma --exit-code` → 2 면 실패 |
| Drizzle | `npx --no-install drizzle-kit generate` 뒤 `git status --porcelain <출력 폴더>`에 새 파일이 있으면 실패(생성된 파일은 지우지 말고 보고) |
| TypeORM | `npx --no-install typeorm migration:generate <임시 경로> -d <DataSource>`가 파일을 만들면 실패(임시 파일은 지운다) |
| Atlas | `atlas migrate validate` |

## 설정 키 패턴

`process.env.`, `import.meta.env.`, 프로젝트의 설정 스키마(예: `@nestjs/config`).
