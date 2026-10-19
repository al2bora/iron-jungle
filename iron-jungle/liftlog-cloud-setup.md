# Lift Log — Cloud Setup Guide (Supabase, free tier)

This connects your group so everyone's workouts sync automatically and the monthly leaderboard and awards update live. It takes about 10 minutes, once, and one person in the group does it (then shares the invite code).

## 1. Create a free Supabase project
1. Go to supabase.com and sign up (free).
2. Click "New project". Pick any name (e.g. "lift-log"), set a database password (save it somewhere), and choose a region close to you.
3. Wait about a minute while the project is provisioned.

## 2. Create the database tables
1. In your project, open the **SQL Editor** (left sidebar).
2. Click **New query**.
3. Open the file `liftlog-supabase-schema.sql` (included with this app), copy its entire contents, and paste it into the SQL editor.
4. Click **Run**. You should see "Success. No rows returned."

This creates four tables (profiles, groups, group_members, cloud_workouts) and the security rules that let group members see each other's workouts but nobody else's.

## 3. Turn on anonymous sign-in
The app signs each device in anonymously, so nobody needs an email or password — your existing username/PIN login stays the same.
1. Go to **Authentication → Sign In / Providers** (or **Authentication → Providers** depending on your Supabase version).
2. Find **Anonymous Sign-Ins** and toggle it **on**.
3. Save.

## 4. Get your API credentials
1. Go to **Project Settings → API**.
2. Copy the **Project URL** (looks like `https://xxxxxxxx.supabase.co`).
3. Copy the **anon public** key (a long string starting with `eyJ...`). Do not use the `service_role` key — that one is secret and must never go in the app.

## 5. Connect the app
1. Open Lift Log and go to the **Friends** tab.
2. Under "Connect your group", paste the Project URL and anon public key.
3. Tap **Connect**.
4. One person taps **Create group**, names it, and shares the resulting invite code with friends.
5. Everyone else pastes that code under **Join with a code**.

That's it — every workout finished from now on syncs automatically, and the leaderboard and monthly awards (Gym Rat, Heavy Lifter, Lazy Ass, PR Machine, Most Improved, Hybrid Athlete) update for the whole group.

## Notes and limits
- **Free tier is plenty** for a friend group: Supabase's free plan includes a shared Postgres database with generous limits for this kind of light read/write traffic.
- **The anon key is safe to embed** in the app — it only allows what your database's row-level security rules permit, which is: see your own data, see your group's data, and never see or edit anyone else's.
- **One group per person** in this version. Leaving a group stops future syncing to it; past data already sent stays associated with that group.
- **If you lose connection**, logging still works locally and is saved to the cloud next time you reopen the Friends tab and reconnect automatically (the app remembers your project URL, key, and login — you shouldn't need to reconnect manually after the first time).
- **To reset for testing**, you can delete rows from the Supabase Table Editor at any time, or drop and re-run the schema file.
