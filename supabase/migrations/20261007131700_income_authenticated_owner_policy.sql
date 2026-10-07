alter table public.income
add column if not exists user_id uuid references auth.users (id);

alter table public.income enable row level security;

drop policy if exists "Income anon can insert rows" on public.income;
drop policy if exists "Income owners can insert own rows" on public.income;
drop policy if exists "Income owners can read own rows" on public.income;

create policy "Income owners can insert own rows"
on public.income
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "Income owners can read own rows"
on public.income
for select
to authenticated
using (auth.uid() = user_id);
