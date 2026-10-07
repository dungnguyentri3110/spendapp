alter table public.income
add column if not exists user_id uuid references auth.users (id);

alter table public.spend
add column if not exists user_id uuid references auth.users (id);

alter table public.income enable row level security;
alter table public.spend enable row level security;

drop policy if exists "Income anon can insert rows" on public.income;
drop policy if exists "Authenticated users can insert income" on public.income;
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

drop policy if exists "Spend anon can insert rows" on public.spend;
drop policy if exists "Authenticated users can insert spend" on public.spend;
drop policy if exists "Spend owners can insert own rows" on public.spend;
drop policy if exists "Spend owners can read own rows" on public.spend;

create policy "Spend owners can insert own rows"
on public.spend
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "Spend owners can read own rows"
on public.spend
for select
to authenticated
using (auth.uid() = user_id);
