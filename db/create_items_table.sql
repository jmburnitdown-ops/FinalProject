-- Run this in the Supabase SQL editor to create the items table
create extension if not exists "uuid-ossp";

create table if not exists items (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users(id) on delete cascade,
  title text not null,
  image_url text,
  created_at timestamptz default now()
);

-- Recommended: create index on user_id for faster per-user queries
create index if not exists items_user_idx on items(user_id);
