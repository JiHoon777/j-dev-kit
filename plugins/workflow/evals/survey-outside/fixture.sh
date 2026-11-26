#!/usr/bin/env bash
# 합성 사례(013). 작은 Node 라이브러리. CI 가 오래된 GitHub Actions 버전(checkout@v3, setup-node@v3 + node 16, cache@v2)을 쓴다.
# 001 은 Node 버전 올리기(To Do)라, 그와 겹치는 후보는 걸러야 한다. 오류 로그·이슈는 없다.
set -euo pipefail
git init -q -b main
git config user.name eval
git config user.email eval@example.invalid
mkdir -p src test docs/backlog docs/done .github/workflows
cat > CLAUDE.md <<'E'
# slugko

한글 제목을 URL 조각(slug)으로 바꾸는 작은 라이브러리. npm 에 배포한다.

## 작업 설정
- stack: 없음
- 기준 브랜치: main
- 검증 명령: npm test
- 문서 언어: 한국어
E
cat > package.json <<'E'
{ "name": "slugko", "version": "1.2.0", "type": "module", "main": "src/index.js",
  "scripts": { "test": "node --test" } }
E
cat > src/index.js <<'E'
export function slug(title) {
  return title.trim().toLowerCase().replace(/\s+/g, '-');
}
E
cat > test/slug.test.js <<'E'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { slug } from '../src/index.js';
test('공백을 하이픈으로', () => assert.equal(slug(' 안녕 세상 '), '안녕-세상'));
E
cat > .github/workflows/ci.yml <<'E'
name: ci
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-20.04
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 16
      - uses: actions/cache@v2
        with:
          path: ~/.npm
          key: npm-${{ hashFiles('package.json') }}
      - run: npm test
      - uses: actions/upload-artifact@v3
        if: failure()
        with:
          name: test-output
          path: test/
E
cat > docs/backlog/README.md <<'E'
# 백로그

`/backlog`가 항목을 만들고, `/start`가 구현부터 머지까지 진행한다.
E
cat > docs/backlog/001-chore-ci-node-version.md <<'E'
---
id: '001'
title: CI 의 Node 버전을 22 로 올린다
status: To Do
labels: [chore]
priority: medium
dependencies: []
created_date: 2026-11-01
updated_date: 2026-11-01
---

## Description

CI 가 Node 16 으로 테스트한다. Node 16 은 지원이 끝났다. CI 와 `package.json` `engines`를 Node 22 로 맞춘다.

## Acceptance Criteria

<!-- AC:BEGIN -->

- [ ] #1 `.github/workflows/ci.yml`의 `node-version`이 22 다

<!-- AC:END -->
E
git add -A && git commit -qm base
