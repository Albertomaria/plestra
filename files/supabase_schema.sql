-- Schema Supabase per l'app Palestra Alberto V2
-- Incolla tutto in Supabase → SQL Editor → Run.

-- Tabella sessioni allenamento
create table sessioni (
  id uuid default gen_random_uuid() primary key,
  user_id text not null default 'alberto',
  data date not null,
  giorno char(1) not null, -- 'A' o 'B'
  durata_min integer,
  creato_at timestamptz default now()
);

-- Tabella serie registrate
create table serie_log (
  id uuid default gen_random_uuid() primary key,
  sessione_id uuid references sessioni(id),
  esercizio_id text not null,
  esercizio_nome text not null,
  serie_num integer not null,
  peso_kg numeric,
  rip_effettive integer,
  durata_sec integer, -- AGGIUNTA rispetto allo schema del prompt: secondi per gli esercizi a tempo (plank ecc.)
  note text,
  creato_at timestamptz default now()
);

-- Tabella esercizi saltati
create table salti_log (
  id uuid default gen_random_uuid() primary key,
  user_id text not null default 'alberto',
  data date not null,
  giorno char(1) not null,
  esercizio_id text not null,
  esercizio_nome text not null,
  nota text,
  creato_at timestamptz default now()
);

-- Accesso con la chiave anon (l'app non ha login).
-- ATTENZIONE: chiunque abbia URL + anon key può leggere/scrivere queste tabelle.
-- Va bene per un'app personale; non metterci dati sensibili.
alter table sessioni  enable row level security;
alter table serie_log enable row level security;
alter table salti_log enable row level security;

create policy "anon all" on sessioni  for all to anon using (true) with check (true);
create policy "anon all" on serie_log for all to anon using (true) with check (true);
create policy "anon all" on salti_log for all to anon using (true) with check (true);
