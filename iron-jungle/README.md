# Iron Jungle

A personal workout tracker for logging lifts at the gym, tracking progress with analytics, and (optionally) sharing monthly stats with friends through a private group leaderboard with fun awards.

## What's in this folder

| File | What it is |
| --- | --- |
| `index.html` | The app as a single file. Open it on your phone or computer. This is the version to use day to day. |
| `workout-tracker.jsx` | The same app as a React component, for the in-chat preview or for developers. |
| `liftlog-supabase-schema.sql` | Database setup script for the optional cloud group feature. Run once in Supabase. |
| `liftlog-cloud-setup.md` | Step-by-step guide to set up the free Supabase project for cloud groups. |
| `workout-tracker-build-prompt.md` | The original product brief the app was built from. |
| `README.md` | This file. |

## Features

**Logging**
- Choose exercises from your library, grouped by body part, and start a workout.
- Save a selection as a named workout (for example "Leg Day A") and start it again later.
- Sets pre-fill from your last session for the same exercise. Tap ✓ to mark a set done.
- Add or remove exercises during a workout. Add extra sets with one tap.
- Switch between kg and lb at any time.

**Exercise library**
- Starts with 8 common exercises. Add your own with a name, body part (Chest, Back, Legs, Shoulders, Arms, Core, Full body, Other) and equipment (Barbell, Dumbbell, Machine, Cable, Bodyweight, Kettlebell, Cardio, Hyrox, CrossFit, Other).
- Edit or delete exercises at any time. Old logs keep working and show "Deleted exercise" where needed.

**Progress and analytics**
- Estimated 1RM trend per exercise (Epley formula).
- Personal records with the date each was set.
- Volume per body part over the last 7 days.
- Workout history with volume totals, weekly average and current streak.

**Accounts and saving**
- Create an account with a username and a 4 to 6 digit PIN. Log in on the same device to pick up where you left off.
- Everything saves automatically: exercises, workouts, saved workouts, unit setting, and any workout in progress.
- You stay logged in until you tap **Log out**.

**Friends and monthly awards (Friends tab)**
- **Cloud group (optional):** connect to a free Supabase project, create or join a group with an invite code, and your finished workouts sync automatically. The leaderboard and awards update for everyone in the group.
- **Manual codes (no setup):** generate a text code with your monthly totals and paste a friend's code to compare. It shares totals only.
- **Awards:** Gym Rat (most sessions), Heavy Lifter (most volume), Lazy Ass (fewest sessions), PR Machine (most personal records), Most Improved (biggest average strength gain), Hybrid Athlete (most varied training).

## How to use it

### On your phone (simplest)
1. Download `index.html` to your phone.
2. Open it in your browser. It needs an internet connection the first time to load its parts (React, from unpkg.com).
3. Optional: add it to your home screen. In Safari, tap Share, then **Add to Home Screen**. In Chrome, tap the menu, then **Add to Home screen**.

### On a computer
Open `index.html` in any modern browser. It works in a narrow window too, so you can test the phone layout.

### Hosting it for a permanent link
Upload `index.html` to a free static host such as Netlify Drop or GitHub Pages. Open the link on any device. Each device has its own local data unless you use the cloud group.

## Setting up cloud groups (optional)

Only one person needs to set this up. Full instructions are in `liftlog-cloud-setup.md`. In short:

1. Create a free Supabase project.
2. Run `liftlog-supabase-schema.sql` in the SQL Editor.
3. Turn on **Anonymous Sign-Ins** under Authentication.
4. Copy the Project URL and the **anon public** key from Project Settings → API. Never use the `service_role` key in the app.
5. In the app, open **Friends**, paste the URL and key, tap **Connect**, then **Create group**. Share the invite code with friends. They paste it under **Join with a code**.

## Where your data lives

| Data | Stored where |
| --- | --- |
| Exercises, workouts, saved workouts, settings | In the browser of the device you use (localStorage). Nothing leaves your device unless you use cloud groups. |
| Account username and PIN | On the same device only. The PIN is hashed, but this is convenience protection, not strong security. |
| Finished workouts (cloud groups only) | Your Supabase project. Visible to you and to members of your group, including exercise names, weights and reps. |
| Monthly summaries (manual codes) | Only in the code you copy and send. Contains totals, not individual sets. |

Clearing your browser data deletes local data. Cloud data stays in Supabase until you delete it there.

## Limitations

- **Device-only by default.** Logging in on a new phone starts an empty account unless you use cloud groups.
- **One cloud group per person.** Joining a new group replaces your membership in the old one.
- **Cloud setup is not tested live.** The code compiles, but it hasn't been run against a real Supabase project. If connecting fails, check the error message against `liftlog-cloud-setup.md`.
- **Award matching uses exercise names.** Use consistent names across the group (for example "Bench Press", not "Bench" for one person and "Bench Press" for another) so personal records compare correctly.
- **Strength gain uses each exercise's best estimated 1RM** compared with its best before the month. Exercises with no earlier history don't count toward "Most Improved".
- **The PIN is not real security.** Don't rely on it to protect sensitive health data.
- **Friends can see details.** In cloud groups, everyone in the group can see exact exercises, weights and reps. Only invite people you trust.
- **Units:** cloud leaderboard volumes are always shown in kg, even if you use lb.

## Troubleshooting

- **Blank page on phone:** check your internet connection and reload. The first load needs access to unpkg.com.
- **"Could not load the Supabase library":** check your connection, or the CDN (cdn.jsdelivr.net) may be blocked on your network.
- **"Could not connect":** double-check the Project URL (it should start with `https://` and end in `.supabase.co`) and that you copied the **anon public** key, not the `service_role` key. Also confirm Anonymous Sign-Ins is enabled.
- **Leaderboard empty or missing friends:** each person has to finish a workout after joining the group. Past workouts from before joining are not uploaded.
- **Preview shows no saved data:** the chat preview may not keep data between sessions. Use `index.html` for real use.

## Roadmap ideas

- Multiple groups per person
- Bodyweight tracking and a consistency heatmap
- Routines with set and rep targets
- Export and import of your data as a file
- Notifications for group awards at the end of each month

## Credits

Built with React 18, Babel standalone, and Supabase JavaScript client (`@supabase/supabase-js`) loaded from public CDNs.
