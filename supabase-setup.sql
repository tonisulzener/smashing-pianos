-- Smashing Pianos: Tabelle für die Online-Rangliste
-- In Supabase: links «SQL Editor» öffnen, alles hier einfügen, «Run» klicken.

create table if not exists public.scores (
  id         bigint generated always as identity primary key,
  name       text        not null check (char_length(name) between 1 and 16),
  score      integer     not null check (score between 1 and 300000),
  kills      integer     not null default 0 check (kills between 0 and 3000),
  version    text        not null check (version in ('2d', '3d')),
  created_at timestamptz not null default now()
);

create index if not exists scores_version_score on public.scores (version, score desc);

-- Zugriffsschutz: Besucher dürfen nur lesen und neue Einträge anlegen,
-- aber nichts ändern oder löschen. Löschen kannst nur du im Supabase-Dashboard.
alter table public.scores enable row level security;

create policy "Rangliste lesen" on public.scores
  for select to anon using (true);

create policy "Punkte eintragen" on public.scores
  for insert to anon with check (true);

grant select, insert on public.scores to anon;
