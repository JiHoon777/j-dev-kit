> 번역본입니다. 원문은 [plugins/server/skills/server-end-check/references/node.md](../../../../../../../plugins/server/skills/server-end-check/references/node.md)이며, 원문이 바뀌면 이 파일도 같이 고칩니다. Claude 는 이 파일을 읽지 않습니다.

# Node: 종료 점검

`server-end-check`가 읽는다. 아래 행을 그 스킬의 보고에 더한다.

## 빠진 마이그레이션

| 도구 | 명령 (모델은 바뀌었는데 마이그레이션이 없음) |
| --- | --- |
| Prisma | `npx --no-install prisma migrate diff --from-migrations prisma/migrations --to-schema prisma/schema.prisma --exit-code` → 2면 실패. `npx --no-install prisma validate`도 |
| Drizzle | `npx --no-install drizzle-kit generate` 뒤 `git status --porcelain <출력 폴더>`에 새 파일이 있으면 실패(생성된 파일은 지우지 말고 보고한다). `npx --no-install drizzle-kit check`도 |
| TypeORM | `npx --no-install typeorm migration:generate <임시 경로> -d <DataSource>`가 파일을 만들면 실패(끝나면 임시 파일을 지운다) |
| Atlas | `atlas migrate validate`, `atlas migrate lint --dev-url <개발 DB> --latest <새 파일 수>` |

## 처음부터 다시 적용 (승인 후에만)

- Prisma: `npx --no-install prisma migrate reset`
- 그 밖: 프로젝트의 reset 스크립트, 또는 개발 데이터베이스를 지우고 다시 만든 뒤 모든 마이그레이션을 적용한다.

## 코드에서 읽는 환경 변수

추가된 줄에서 찾을 패턴: `process.env.`, `import.meta.env.`, 프로젝트의 설정 스키마(예: `@nestjs/config` 키).

## 채울 줄

보고서 표에서 맞는 줄을 채운다(같은 줄을 하나 더 만들지 않는다):

```markdown
| Missing migration | … | `prisma migrate diff … --exit-code` 0 |
```
