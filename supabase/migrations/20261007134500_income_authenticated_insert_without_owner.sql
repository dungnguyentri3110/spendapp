alter table public.income enable row level security;

drop policy if exists "Income anon can insert rows" on public.income;
drop policy if exists "Income owners can insert own rows" on public.income;
drop policy if exists "Income owners can read own rows" on public.income;
drop policy if exists "Authenticated users can insert income" on public.income;

create policy "Authenticated users can insert income"
on public.income
for insert
to authenticated
with check (true);
