# Build Prompt: Personal Gym Lift Tracker with Analytics

## Purpose
A personal workout app for logging lifts at the gym and understanding my progress through analytics. It is built first for my own use, so it should be fast, simple, and honest about the data.

## Users
- Primary user: me, a regular gym-goer who lifts with free weights and machines.
- Context: I use it mid-workout with sweaty hands, short rest periods, and weak or unreliable signal. Every interaction should take a few taps.

## Platform
- Responsive web app that works well on a phone browser and on desktop. Mobile layout is the priority.
- Optional later: installable as a home-screen PWA with offline logging.

## Core Workflow: Logging a Workout
1. Start a workout (optionally from a saved routine such as Push / Pull / Legs).
2. For each exercise, the app shows the target sets based on my last session.
3. Each set row has weight and reps pre-filled from the last session for that exercise. I tap to confirm, or edit if different.
4. Adding a set takes one tap and copies the previous set's values.
5. Mark a set as complete. Optional: RPE (1-10) and a short note.
6. Finish the workout. It is saved with date, duration, and total volume.

## Exercise Library
- Preset library of common exercises (barbell, dumbbell, machine, bodyweight, cable), each tagged with primary muscle group and equipment type.
- I can add custom exercises with a name, muscle group, and equipment type.
- Search and filter by muscle group.
- Units: kg or lb, selectable in settings. Store everything in one base unit internally and convert for display.

## Analytics (priority order)
1. **Progress per exercise**: line chart of estimated 1RM over time (Epley formula: weight x (1 + reps / 30)), with a toggle for top set weight.
2. **Training volume**: sets x reps x weight, per workout and per week.
3. **Personal records**: list of PRs per exercise (heaviest weight, best estimated 1RM, most reps at a given weight), with the date each was set.
4. **Volume per muscle group**: weekly bar chart, so I can spot imbalances.
5. **Consistency**: workouts per week, current streak, longest streak, calendar heatmap.
6. **Bodyweight vs. strength**: optional bodyweight entries, plotted against key lift 1RM trends.

Each chart should allow a time range (4 weeks, 3 months, 1 year, all time) and an exercise filter.

## Data and Storage
- Store all data locally in the browser first (IndexedDB or localStorage), with a JSON export and import so I never lose history.
- Data model: Exercise, Workout, WorkoutExercise, Set (weight, reps, RPE, completed flag, timestamp), BodyweightEntry, Routine.
- Keep the data model simple enough that a cloud backend (e.g., Supabase or Firebase) can be added later without rewriting the app.

## Design Principles
- Speed over decoration: the logging screen must be usable in under 3 seconds per set.
- Large tap targets (at least 44px), high contrast for gym lighting, dark mode default.
- Show the single most useful number first (for example, today's estimated 1RM change for the exercise).
- Avoid clutter: one primary action per screen.

## Quality and Acceptance Criteria
- A set can be logged in no more than 2 taps when the values are pre-filled.
- Changing an old workout updates all analytics correctly.
- Charts handle empty data gracefully (show a helpful message, not a broken chart).
- Works offline for logging; sync or export is not required to use the app.
- Edge cases handled: zero reps, missing weight (bodyweight exercises), deleted exercises that still appear in history.

## Suggested Build Plan
1. **Phase 1 (MVP):** Exercise library, start/finish workout, pre-filled set logging, workout history.
2. **Phase 2:** Per-exercise progress chart (estimated 1RM), PRs, weekly volume.
3. **Phase 3:** Muscle group volume, consistency heatmap, routines, bodyweight tracking.
4. **Phase 4:** Export/import, PWA install, offline support, optional cloud sync.

## Out of Scope (for now)
- Social features, coaching, nutrition tracking, wearable integrations, and multi-user accounts.

## Deliverable Requested
Build Phase 1 and Phase 2 as a working responsive app, with clear component structure, a documented data model, and sample data so the analytics can be tested immediately.
