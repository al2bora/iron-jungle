-- Lift Log cloud schema for Supabase
-- Run this once in your Supabase project: Dashboard -> SQL Editor -> New query -> paste -> Run

create extension if not exists pgcrypto;

-- One row per app user (keyed by their anonymous auth id)
create table if not exists profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  username text not null,
  created_at timestamptz not null default now()
);

-- A friend group, joined via a short invite code
create table if not exists groups (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  code text not null unique,
  created_by uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);

-- Membership: which users belong to which group
create table if not exists group_members (
  group_id uuid not null references groups (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  username text not null,
  joined_at timestamptz not null default now(),
  primary key (group_id, user_id)
);

-- A denormalized copy of each finished workout, synced for group visibility
create table if not exists cloud_workouts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  group_id uuid not null references groups (id) on delete cascade,
  username text not null,
  date date not null,
  exercises jsonb not null, -- [{ name, muscle, equipment, sets: [{ weight, reps }] }]
  total_volume numeric not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists cloud_workouts_user_idx on cloud_workouts (user_id);
create index if not exists cloud_workouts_group_idx on cloud_workouts (group_id);
create index if not exists group_members_user_idx on group_members (user_id);

-- ---------- Row Level Security ----------
alter table profiles enable row level security;
alter table groups enable row level security;
alter table group_members enable row level security;
alter table cloud_workouts enable row level security;

-- Profiles: anyone signed in can see usernames; you can only write your own row
drop policy if exists "profiles_select" on profiles;
create policy "profiles_select" on profiles for select using (true);
drop policy if exists "profiles_upsert" on profiles;
create policy "profiles_upsert" on profiles for insert with check (auth.uid() = id);
drop policy if exists "profiles_update" on profiles;
create policy "profiles_update" on profiles for update using (auth.uid() = id);

-- Groups: anyone signed in can look up a group by code or see groups they created
drop policy if exists "groups_select" on groups;
create policy "groups_select" on groups for select using (true);
drop policy if exists "groups_insert" on groups;
create policy "groups_insert" on groups for insert with check (auth.uid() = created_by);

-- Group members: you can see fellow members of your own group(s); you can only add/remove yourself
drop policy if exists "group_members_select" on group_members;
create policy "group_members_select" on group_members for select using (
  group_id in (select gm.group_id from group_members gm where gm.user_id = auth.uid())
);
drop policy if exists "group_members_insert" on group_members;
create policy "group_members_insert" on group_members for insert with check (auth.uid() = user_id);
drop policy if exists "group_members_delete" on group_members;
create policy "group_members_delete" on group_members for delete using (auth.uid() = user_id);

-- Cloud workouts: visible to yourself and to members of the same group(s); only you can write your own rows
drop policy if exists "cloud_workouts_select" on cloud_workouts;
create policy "cloud_workouts_select" on cloud_workouts for select using (
  user_id = auth.uid()
  or group_id in (select gm.group_id from group_members gm where gm.user_id = auth.uid())
);
drop policy if exists "cloud_workouts_insert" on cloud_workouts;
create policy "cloud_workouts_insert" on cloud_workouts for insert with check (auth.uid() = user_id);
drop policy if exists "cloud_workouts_delete" on cloud_workouts;
create policy "cloud_workouts_delete" on cloud_workouts for delete using (auth.uid() = user_id);
