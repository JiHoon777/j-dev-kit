#!/usr/bin/env bash
# 합성 사례. todak 010 이 계획한 모양(작업본, 공개 함수, 이력, 권한)을 따라 지어 쓴 코드에
# supabase-reviewer "볼 것" 1~11 과 api-reviewer 9(쿼리)에 해당하는 실수를 하나씩 심었다.
# 실제 리뷰에서 나온 것이 아니다. 맞게 쓴 파일(case_sources)을 하나 둬 헛지적도 본다.
set -euo pipefail
git init -q -b main
git config user.name eval
git config user.email eval@example.invalid

mkdir -p supabase/migrations src/lib src/routes docs/backlog
cat > package.json <<'JSON'
{
  "name": "seeded",
  "private": true,
  "type": "module",
  "dependencies": { "@supabase/supabase-js": "^2.80.0" },
  "devDependencies": { "@sveltejs/kit": "^3.4.0", "svelte": "^5.40.0", "supabase": "3.2.0" }
}
JSON
cat > supabase/config.toml <<'TOML'
project_id = "seeded"
[api]
schemas = ["public"]
auto_expose_new_tables = false
TOML
cat > CLAUDE.md <<'MD'
# seeded

피부 트러블 케이스를 공개하는 앱. 방문자는 로그인 없이 공개본만 읽는다. 편집자는 로그인해서 작업본을 고치고 공개한다.

## 작업 설정
- stack: frontend, server
- 기준 브랜치: main
MD
cat > supabase/migrations/20261101000000_published_cases.sql <<'SQL'
create table public.published_cases (
	case_id uuid primary key,
	slug text not null unique check (slug ~ '^[a-z0-9-]+$'),
	document jsonb not null check (jsonb_typeof(document) = 'object'),
	published_at timestamptz not null
);
alter table public.published_cases enable row level security;
revoke all on table public.published_cases from anon, authenticated;
grant select on table public.published_cases to anon, authenticated;
create policy "방문자는 공개본을 읽는다" on public.published_cases for select to anon, authenticated using (true);
SQL
git add -A && git commit -qm base
git switch -q -c w/010-feat-working-copy-publish

cat > docs/backlog/010-feat-working-copy-publish.md <<'MD'
---
id: '010'
title: 작업본, 공개 함수, 이력, 편집 화면
status: In Progress
---

## Description

편집자(로그인한 사용자 중 `editors` 테이블에 있는 사람)가 작업본을 고치고, 공개 함수가 검사한 뒤 공개본을 바꾼다. 공개본이 바뀌면 이력을 남긴다. 방문자는 피드백을 남길 수 있다(익명 로그인).

## Acceptance Criteria

- [ ] #1 편집자만 작업본을 읽고 쓴다. 작업본은 자기가 만든 것만 고친다
- [ ] #2 공개는 `publish_case` 함수로만 한다. 편집자만 부를 수 있다
- [ ] #3 출처(`case_sources`)는 편집자만 쓰고 방문자는 읽는다
- [ ] #4 방문자 피드백은 한 건에 500자까지
- [ ] #5 케이스 사진은 편집자가 `case-images` 버킷에 올린다(같은 이름이면 덮어쓴다)
MD

cat > supabase/migrations/20261120000000_working_copy.sql <<'SQL'
-- 편집자 명단
create table public.editors (
	user_id uuid primary key references auth.users (id)
);
alter table public.editors enable row level security;
grant select on table public.editors to authenticated;
create policy "편집자는 명단을 읽는다" on public.editors for select to authenticated
	using ((select auth.uid()) = user_id);

-- 작업본
create table public.case_drafts (
	case_id uuid primary key default gen_random_uuid(),
	owner_id uuid not null references auth.users (id),
	slug text not null,
	status text not null default 'draft',
	document jsonb not null
);
grant select, insert, update on table public.case_drafts to authenticated;

-- 작업본 메모: 편집자 역할은 로그인 정보에 적어 둔다
create table public.draft_notes (
	note_id bigint generated always as identity primary key,
	case_id uuid not null references public.case_drafts (case_id),
	author_id uuid not null references auth.users (id),
	body text not null
);
alter table public.draft_notes enable row level security;
grant select, insert, update on table public.draft_notes to authenticated;
create policy "편집자는 메모를 읽는다" on public.draft_notes for select to authenticated
	using ((auth.jwt() -> 'user_metadata' ->> 'role') = 'editor');
create policy "편집자는 메모를 쓴다" on public.draft_notes for insert to authenticated
	with check ((auth.jwt() -> 'user_metadata' ->> 'role') = 'editor' and author_id = (select auth.uid()));
create policy "쓴 사람은 메모를 고친다" on public.draft_notes for update to authenticated
	using (author_id = auth.uid());

-- 출처 (맞게 쓴 것)
create table public.case_sources (
	source_id bigint generated always as identity primary key,
	case_id uuid not null references public.published_cases (case_id),
	url text not null check (url ~ '^https://' and length(url) <= 2000)
);
create index case_sources_case_id_idx on public.case_sources (case_id);
alter table public.case_sources enable row level security;
revoke all on table public.case_sources from anon, authenticated;
grant select on table public.case_sources to anon, authenticated;
grant insert, update, delete on table public.case_sources to authenticated;
create policy "방문자는 출처를 읽는다" on public.case_sources for select to anon, authenticated using (true);
create policy "편집자는 출처를 쓴다" on public.case_sources for insert to authenticated
	with check (exists (select 1 from public.editors e where e.user_id = (select auth.uid())));
create policy "편집자는 출처를 고친다" on public.case_sources for update to authenticated
	using (exists (select 1 from public.editors e where e.user_id = (select auth.uid())))
	with check (exists (select 1 from public.editors e where e.user_id = (select auth.uid())));
create policy "편집자는 출처를 지운다" on public.case_sources for delete to authenticated
	using (exists (select 1 from public.editors e where e.user_id = (select auth.uid())));

-- 방문자 피드백
create table public.feedback (
	feedback_id bigint generated always as identity primary key,
	user_id uuid not null default auth.uid(),
	case_id uuid not null references public.published_cases (case_id),
	body text not null
);
alter table public.feedback enable row level security;
grant insert on table public.feedback to authenticated;
create policy "로그인한 방문자는 피드백을 남긴다" on public.feedback for insert to authenticated
	with check (user_id = auth.uid());
create policy "쓴 사람은 피드백을 본다" on public.feedback for select to authenticated
	using (auth.uid() = user_id);

-- 작업본 한눈에 보기
create view public.case_overview as
	select d.case_id, d.slug, d.status, d.owner_id, count(n.note_id) as notes
	from public.case_drafts d left join public.draft_notes n using (case_id)
	group by d.case_id;
grant select on public.case_overview to authenticated;

-- 이력: 예전 열을 정리한다
alter table public.published_cases drop column published_at;
alter table public.published_cases add column published_on date not null;

-- 공개 함수
create function public.publish_case(p_case_id uuid)
returns void
language plpgsql
security definer
as $$
begin
	insert into public.published_cases (case_id, slug, document, published_on)
	select case_id, slug, document, current_date from public.case_drafts where case_id = p_case_id
	on conflict (case_id) do update set document = excluded.document, published_on = excluded.published_on;
end;
$$;

-- 케이스 사진
insert into storage.buckets (id, name, public) values ('case-images', 'case-images', true);
create policy "편집자는 사진을 올린다" on storage.objects for insert to authenticated
	with check (bucket_id = 'case-images' and exists (select 1 from public.editors e where e.user_id = (select auth.uid())));
SQL

cat > src/lib/admin.ts <<'TS'
// 편집 화면에서 쓰는 클라이언트. 공개 함수와 사진 올리기에 쓴다.
import { createClient } from '@supabase/supabase-js';

export const admin = createClient(import.meta.env.VITE_SUPABASE_URL, import.meta.env.VITE_SUPABASE_SECRET_KEY);

export async function publish(caseId: string) {
	const { error } = await admin.rpc('publish_case', { p_case_id: caseId });
	if (error) throw error;
}

export async function uploadImage(caseId: string, file: File) {
	const { error } = await admin.storage.from('case-images').upload(`${caseId}/main.jpg`, file, { upsert: true });
	if (error) throw error;
}

// 편집 화면에 보이는 사람끼리 누가 접속해 있는지 나눈다
export function joinEditors(user: { id: string; email: string; phone: string }) {
	const channel = admin.channel('editors-online');
	channel.subscribe(() => channel.track({ id: user.id, email: user.email, phone: user.phone }));
	return channel;
}
TS

mkdir -p src/routes/admin/cases
cat > src/routes/admin/cases/+page.server.ts <<'TS'
// 편집자의 케이스 목록. 상태로 거르고 케이스마다 출처 수를 붙인다.
import { createClient } from '@supabase/supabase-js';
import { env } from '$env/dynamic/private';

export async function load({ url }) {
	const db = createClient(env.SUPABASE_URL, env.SUPABASE_SECRET_KEY);
	const status = url.searchParams.get('status') ?? 'draft';
	const { data: drafts, error } = await db.from('case_drafts').select('*').eq('status', status);
	if (error) throw error;
	const rows = [];
	for (const d of drafts) {
		const { count } = await db.from('case_sources').select('*', { count: 'exact', head: true }).eq('case_id', d.case_id);
		rows.push({ ...d, sources: count ?? 0 });
	}
	return { rows };
}
TS

mkdir -p supabase/functions/notify-editors
cat > supabase/functions/notify-editors/index.ts <<'TS'
// 새 피드백이 오면 편집자에게 알린다. 웹훅이 부른다.
import { createClient } from 'npm:@supabase/supabase-js@2';

Deno.serve(async (req) => {
	const body = await req.json();
	const key = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
	console.log('notify', body, key);
	const db = createClient(Deno.env.get('SUPABASE_URL')!, key);
	const { data } = await db.from('editors').select('user_id');
	return new Response(JSON.stringify({ sent: data?.length ?? 0, feedback: body }));
});
TS

git add -A && git commit -qm "작업본, 공개 함수, 편집 화면"
git diff main...HEAD -- . > review.diff
