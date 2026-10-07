drop policy if exists "Income anon can insert rows" on public.income;
create policy "Income anon can insert rows"
on public.income
for insert
to anon
with check (true);
