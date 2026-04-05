# 7-Day Empathy Challenge — Technical Reference

## Overview

The Empathy Challenge is a 7-day guided empathy-building program. Users join a challenge, complete one day at a time (each with a unique prompt and reflection input), earn D.O.S.E. rewards, and unlock the next day sequentially. The feature includes an intro screen, calendar/timeline screen, per-day exercise screen, and a completion badge screen.

## Screen Sequence

| Screen     | Route                                      | Component                  | Purpose                                      |
| ---------- | ------------------------------------------ | -------------------------- | -------------------------------------------- |
| Index      | `/practices/empathy-challenge`             | `EmpathyChallengeIndex`    | Route guard — redirects to intro or calendar |
| Intro      | `/practices/empathy-challenge/intro`       | `EmpathyChallengeIntro`    | Welcome screen, "Join Challenge" CTA         |
| Calendar   | `/practices/empathy-challenge/calendar`    | `EmpathyChallengeCalendar` | Timeline showing 7 days with progress        |
| Day        | `/practices/empathy-challenge/day`         | `EmpathyChallengeDay`      | Per-day exercise with reflection input       |
| Completion | `/practices/empathy-challenge/complete`    | `EmpathyChallengeComplete` | Badge and achievement screen                 |

## Navigation Flow

```
LoveLanding → /practices/empathy-challenge (Index)
  ├── (no active challenge) → Redirect → /intro
  │     └── "Join Challenge" → startChallenge mutation → router.replace(/calendar)
  └── (active challenge) → Redirect → /calendar
        └── "Start Day N" → router.push(/day?dayNumber=N&dayId=ID)
              ├── (days 1-6) Complete → router.replace(/calendar)
              └── (day 7) Finish → router.replace(/complete)
                    └── "Return to Home" → router.replace(/(tabs)/practices)
```

## State

### Backend Schema

**Table: `empathy_challenge`**

| Column       | Type                                   | Notes                          |
| ------------ | -------------------------------------- | ------------------------------ |
| `id`         | `text` PK                              | `crypto.randomUUID()`          |
| `userId`     | `text` FK → `user.id`                 | cascade delete                 |
| `status`     | `challengeStatusEnum`                  | `active`, `completed`, `abandoned` |
| `startedAt`  | `timestamp`                            | default now                    |
| `completedAt`| `timestamp`                            | nullable                       |
| `createdAt`  | `timestamp`                            | default now                    |

Index on `(userId, status)`.

**Table: `empathy_challenge_day`**

| Column         | Type                | Notes                           |
| -------------- | ------------------- | ------------------------------- |
| `id`           | `text` PK           | `crypto.randomUUID()`           |
| `challengeId`  | `text` FK           | cascade delete                  |
| `dayNumber`    | `integer`           | 1-7                             |
| `status`       | `dayStatusEnum`     | `locked`, `unlocked`, `in_progress`, `completed` |
| `reflection`   | `text`              | nullable, user's written response |
| `doseOxytocin` | `integer`           | default 0, set to 10 on completion |
| `doseSerotonin`| `integer`           | default 0, set to 5 on completion |
| `startedAt`    | `timestamp`         | nullable                        |
| `completedAt`  | `timestamp`         | nullable                        |
| `createdAt`    | `timestamp`         | default now                     |

Unique constraint on `(challengeId, dayNumber)`.

### Enums

```typescript
challengeStatusEnum = pgEnum("challenge_status", ["active", "completed", "abandoned"]);
dayStatusEnum = pgEnum("day_status", ["locked", "unlocked", "in_progress", "completed"]);
```

## Backend API (oRPC Procedures)

| Procedure           | Input                              | Returns                              | Behavior                                                  |
| ------------------- | ---------------------------------- | ------------------------------------ | --------------------------------------------------------- |
| `getActiveChallenge`| none                               | challenge with days, or `null`       | Finds active challenge for the current user               |
| `startChallenge`    | none                               | challenge with days                  | Abandons existing active, creates new (day 1 = unlocked)  |
| `startDay`          | `{ dayId }`                        | updated day                          | Marks day as `in_progress`, validates ownership + status   |
| `completeDay`       | `{ dayId, reflection }`            | updated day                          | Saves reflection, awards D.O.S.E., unlocks next day, completes challenge on day 7 |

All procedures are protected via `authorized` middleware.

## Frontend Hooks

**File**: `src/modules/empathy-challenge/hooks/useEmpathyChallenge.ts`

| Hook                | Type     | Purpose                                  |
| ------------------- | -------- | ---------------------------------------- |
| `useActiveChallenge`| query    | Fetches active challenge with days       |
| `useStartChallenge` | mutation | Creates challenge, sets query data optimistically |
| `useStartDay`       | mutation | Marks day as in_progress, invalidates query |
| `useCompleteDay`    | mutation | Saves reflection, invalidates query      |

`useStartChallenge` uses optimistic updates via `setQueryData` with the exact query key from `queryOptions()`.

## Day Content Data

**File**: `src/modules/empathy-challenge/data/empathy-days.ts`

Each day has:

```typescript
interface EmpathyDay {
  day: number;
  title: string;
  subtitle: string;
  badge: string;
  intention: string;
  challengeHeader?: string;          // defaults to "Today's Challenge"
  challengeText: string;
  challengeHighlight?: string;       // rendered in left-bordered quote card
  challengeBullets?: ChallengeBullet[]; // Day 3: icon + text list
  challengeCards?: ChallengeCard[];    // Day 7: icon + title + description cards
  reflectionLabel: string;
  reflectionPlaceholder: string;
  calendarDescription: string;
  buttonLabel?: string;               // Day 7: "Finish Challenge"
  icon?: keyof typeof MaterialIcons.glyphMap;
}
```

### Day Content Summary

| Day | Title                    | Type            | Unique Elements                    |
| --- | ------------------------ | --------------- | ---------------------------------- |
| 1   | See Through New Eyes     | Perspective     | Standard challenge + quote         |
| 2   | Tune In, Don't Fix       | Emotional       | Standard challenge + quote         |
| 3   | Pause Before You Reply   | Reactive        | 3 bullet points with colored icons |
| 4   | Stay Open, Stay Grounded | Boundary        | Two-line mantra quote              |
| 5   | Kindness in Motion       | Action          | No highlighted quote               |
| 6   | Support Without Absorbing| Resilient       | Custom header "The Challenge"      |
| 7   | The Empathy Loop         | Integration     | 3 challenge cards, "Finish Challenge" button |

## Components

### EmpathyChallengeIndex

Route guard screen. Fetches `useActiveChallenge` and uses `<Redirect>` to navigate to intro (no challenge) or calendar (active challenge). Shows error state with retry/back buttons on failure.

### EmpathyChallengeIntro

Welcome screen with `GlowBg`, title, description, 3 `BenefitCard` components, and `GradientButton`. On press: calls `startChallenge` mutation, then `router.replace` to calendar.

### EmpathyChallengeCalendar

Timeline screen. Fetches `useActiveChallenge` for days data. Renders a progress bar and 7 timeline rows. Active day shows an `ActiveDayCard` with gradient hero and "Start Day" button. Locked days are dimmed with lock icons. Completed days show checkmarks. Redirects to intro if no active challenge.

### EmpathyChallengeDay

Per-day exercise screen. Receives `dayNumber` and `dayId` via search params. Calls `startDay` on mount. Renders hero section with `RadialGlow`, intention card, challenge section (adapts to bullets/cards/quotes per day data), reflection `TextInput` inside `KeyboardAwareScrollView`, D.O.S.E. reward cards, and complete button. Day 7 uses fire-and-forget `mutate` + immediate navigation to completion screen.

### EmpathyChallengeComplete

Badge screen with `RadialGlow`, gradient ring circle with heart icon, "Empathy Master!" title, 7/7 stats, D.O.S.E. rewards, share button, and return-to-home button.

### BenefitCard

Simple presentational component for the intro screen benefit rows.

## File Map

| File                                                           | Role                          |
| -------------------------------------------------------------- | ----------------------------- |
| `src/modules/empathy-challenge/screens/EmpathyChallengeIndex.tsx` | Route guard                |
| `src/modules/empathy-challenge/screens/EmpathyChallengeIntro.tsx` | Intro/welcome screen       |
| `src/modules/empathy-challenge/screens/EmpathyChallengeCalendar.tsx` | Timeline/calendar screen |
| `src/modules/empathy-challenge/screens/EmpathyChallengeDay.tsx`   | Per-day exercise screen    |
| `src/modules/empathy-challenge/screens/EmpathyChallengeComplete.tsx` | Completion badge screen  |
| `src/modules/empathy-challenge/components/BenefitCard.tsx`        | Intro benefit row          |
| `src/modules/empathy-challenge/hooks/useEmpathyChallenge.ts`     | React Query hooks          |
| `src/modules/empathy-challenge/data/empathy-days.ts`             | Static day content data    |
| `src/app/practices/empathy-challenge/_layout.tsx`                 | Stack layout               |
| `src/app/practices/empathy-challenge/index.tsx`                   | Route re-export            |
| `src/app/practices/empathy-challenge/intro.tsx`                   | Route re-export            |
| `src/app/practices/empathy-challenge/calendar.tsx`                | Route re-export            |
| `src/app/practices/empathy-challenge/day.tsx`                     | Route re-export            |
| `src/app/practices/empathy-challenge/complete.tsx`                | Route re-export            |
| `backend/src/db/schema/empathy-challenge.ts`                     | DB schema + enums          |
| `backend/src/rpc/procedures/empathy-challenge.ts`                | oRPC procedures            |
