# Gentle Letter to Yourself — Technical Reference

## Overview

The Gentle Letter feature is a guided 5-step self-compassion writing exercise. Users progress through structured prompts (acknowledge feelings, name the inner critic, offer understanding, write a letter, seal with an affirmation), tag the letter with a "core act", and save it. A Compassion Archive provides a calendar view and list of past letters with date filtering and full read-back.

## Screen Sequence

| Screen        | Route                                  | Component            | Purpose                                    |
| ------------- | -------------------------------------- | -------------------- | ------------------------------------------ |
| Intro         | `/practices/gentle-letter`             | `GentleLetterIntro`  | Welcome screen, start writing or view past |
| Write         | `/practices/gentle-letter/write`       | `GentleLetterWrite`  | 5-step guided writing flow                 |
| Archive       | `/practices/gentle-letter/archive`     | `CompassionArchive`  | Calendar + list of saved letters           |
| Letter Detail | `/practices/gentle-letter/letter`      | `LetterDetail`       | Full read-back of a single letter          |

## Navigation Flow

```
LoveLanding → /practices/gentle-letter (Intro)
  ├── "Start My Letter" → /write (Step 1)
  │     ├── "Next Step" → Steps 2-4 (in-screen state change)
  │     └── Step 5 "Save Letter" → createLetter mutation → router.replace(/archive)
  └── "View Past Letters" → /archive
        └── Tap letter card → /letter?id=ID
```

Step navigation within `/write` is handled by local component state (`currentStep`), not route changes. Back button decrements step; on Step 1, confirms exit.

## State

### Backend Schema

**Table: `gentle_letter`**

| Column      | Type                | Notes                                 |
| ----------- | ------------------- | ------------------------------------- |
| `id`        | `text` PK           | `crypto.randomUUID()`                 |
| `userId`    | `text` FK → user.id | cascade delete                        |
| `title`     | `text`              | nullable, auto-generated from step4/step5/step1 |
| `coreAct`   | `coreActEnum`       | nullable                              |
| `content`   | `jsonb`             | typed as `GentleLetterContent`        |
| `entryDate` | `text`              | `YYYY-MM-DD` format for calendar queries |
| `createdAt` | `timestamp`         | default now                           |
| `updatedAt` | `timestamp`         | default now                           |

Index on `(userId, entryDate)`.

**Content JSONB type:**

```typescript
type GentleLetterContent = {
  step1: string; // Notice What Is Here
  step2: string; // Name the Inner Critic
  step3: string; // Offer Understanding
  step4: string; // Write Your Letter
  step5: string; // Seal with Kindness
};
```

**Enum:**

```typescript
coreActEnum = pgEnum("core_act", ["forgiveness", "patience", "acceptance", "kindness", "courage"]);
```

### Frontend State

**In-session (useRef + useState):**

The Write screen uses `useRef<Record<string, string>>` for the draft and `useState` for the current step's text. This avoids async storage issues that caused data loss with `atomWithStorage`. Text is synchronized between ref and state on step transitions.

| State             | Type                        | Scope      | Purpose                         |
| ----------------- | --------------------------- | ---------- | -------------------------------- |
| `draftRef`        | `Ref<Record<string, string>>`| Write screen | All step text (synchronous)   |
| `currentText`     | `string`                    | Write screen | Current step's input binding   |
| `currentStep`     | `number`                    | Write screen | 0-4, drives which step renders |
| `coreAct`         | `string \| null`            | Write screen | Selected core act on step 5    |
| `selectedDate`    | `string \| null`            | Archive      | Calendar date filter           |
| `calMonth/calYear`| `number`                    | Archive      | Calendar view month/year       |

**Persisted atoms (Jotai `atomWithStorage`):**

| Atom                    | Key                    | Purpose                      |
| ----------------------- | ---------------------- | ---------------------------- |
| `letterDraftAtom`       | `gentle-letter:draft`  | Draft persistence (legacy, unused in current Write screen) |
| `letterCoreActAtom`     | `gentle-letter:core-act` | Core act persistence (legacy) |
| `resetLetterDraftAtom`  | —                      | Clears both atoms             |

## Backend API (oRPC Procedures)

| Procedure              | Input                                     | Returns          | Behavior                                              |
| ---------------------- | ----------------------------------------- | ---------------- | ----------------------------------------------------- |
| `createLetter`         | `{ content, coreAct, title? }`            | created letter   | Auto-generates title from step4 → step5 → step1. Sets entryDate to today. |
| `getLetter`            | `{ id }`                                  | letter or `null` | Ownership check via userId                            |
| `listLetters`          | `{ limit?, date? }` (optional)            | letter[]         | Filtered by userId, optionally by entryDate. Ordered by createdAt desc. |
| `getLetterDatesForMonth` | `{ month, year }`                       | string[]         | Returns distinct entryDate strings for the given month |

All procedures are protected via `authorized` middleware.

### Title Auto-Generation

The `createLetter` procedure generates a title if none is provided:

1. Try first 50 chars of `step4` (the letter body)
2. Fall back to `step5` (the affirmation)
3. Fall back to `step1` (the feelings)
4. Fall back to "Untitled"

## Frontend Hooks

**File**: `src/modules/gentle-letter/hooks/useGentleLetter.ts`

| Hook                    | Type     | Purpose                                         |
| ----------------------- | -------- | ------------------------------------------------ |
| `useCreateLetter`       | mutation | Creates letter, invalidates list + dates queries |
| `useListLetters`        | query    | Fetches all letters (recent, unfiltered)         |
| `useLettersForDate`     | query    | Fetches letters for a specific date (enabled by selectedDate) |
| `useGetLetter`          | query    | Fetches single letter by ID (enabled by id param) |
| `useLetterDatesForMonth`| query    | Fetches date strings for calendar highlighting   |

## Step Content Data

**File**: `src/modules/gentle-letter/data/letter-steps.ts`

```typescript
interface LetterStep {
  step: number;
  key: 'step1' | 'step2' | 'step3' | 'step4' | 'step5';
  label: string;
  headline: string;
  body: string;
  placeholder: string;
  tip: string;
  icon: keyof typeof MaterialIcons.glyphMap;
}
```

| Step | Key   | Label                 | Headline                                      |
| ---- | ----- | --------------------- | --------------------------------------------- |
| 1    | step1 | Notice What Is Here   | Acknowledge your feelings without judgment.   |
| 2    | step2 | Name the Inner Critic | Identify the harsh voice within.              |
| 3    | step3 | Offer Understanding   | Reframe with compassion.                      |
| 4    | step4 | Write Your Letter     | Compose your gentle letter.                   |
| 5    | step5 | Seal with Kindness    | Close with an affirmation.                    |

**Core Acts** (step 5 picker):

| Value        | Label       | Icon             |
| ------------ | ----------- | ---------------- |
| `forgiveness`| Forgiveness | `healing`        |
| `patience`   | Patience    | `hourglass-top`  |
| `acceptance` | Acceptance  | `check-circle`   |
| `kindness`   | Kindness    | `favorite`       |
| `courage`    | Courage     | `shield`         |

## Components

### GentleLetterIntro

Welcome screen with `GlowBg`, `RadialGlow` behind a glowing lotus icon (`filter-vintage`), title, subtitle, body text, `GradientButton` to start, and ghost link to view past letters.

### GentleLetterWrite

Multi-step writing flow. Manages step state locally with `useState` and `useRef`. Renders `ProgressDots`, step label, headline, body, `TextInput` with `KeyboardAwareScrollView`, tip text. Step 5 adds a core act picker (row of selectable `Pressable` pills). On save: calls `createLetter` mutation with `dialog.loading`, then `router.replace` to archive. The `saveLetter` function is extracted from `handleNext` to avoid try/catch blocking React Compiler.

### CompassionArchive

Calendar + letter list screen. Calendar is built inline with a 7-column grid. Days with letters get `bg-primary-pink/20` with a heart icon. Selected date gets solid `bg-primary-pink`. Future dates are disabled (30% opacity). Letter list switches between `useListLetters` (all) and `useLettersForDate` (filtered) based on `selectedDate`. Letter cards show date, title, core act badge, "Read reflection" link, and gradient thumbnail.

### LetterDetail

Read-back screen. Fetches letter via `useGetLetter(id)` from search params. Displays title, formatted date, core act badge, and each step's content in labeled cards. Empty steps are skipped.

## File Map

| File                                                        | Role                          |
| ----------------------------------------------------------- | ----------------------------- |
| `src/modules/gentle-letter/screens/GentleLetterIntro.tsx`   | Intro/welcome screen          |
| `src/modules/gentle-letter/screens/GentleLetterWrite.tsx`   | 5-step writing flow           |
| `src/modules/gentle-letter/screens/CompassionArchive.tsx`   | Calendar + letter list        |
| `src/modules/gentle-letter/screens/LetterDetail.tsx`        | Single letter read-back       |
| `src/modules/gentle-letter/hooks/useGentleLetter.ts`        | React Query hooks             |
| `src/modules/gentle-letter/data/letter-steps.ts`            | Step content + core acts data |
| `src/modules/gentle-letter/store/gentle-letter.ts`          | Jotai atoms (draft persistence)|
| `src/app/practices/gentle-letter/_layout.tsx`                | Stack layout                  |
| `src/app/practices/gentle-letter/index.tsx`                  | Route re-export (intro)       |
| `src/app/practices/gentle-letter/write.tsx`                  | Route re-export               |
| `src/app/practices/gentle-letter/archive.tsx`                | Route re-export               |
| `src/app/practices/gentle-letter/letter.tsx`                 | Route re-export               |
| `backend/src/db/schema/gentle-letter.ts`                     | DB schema + enum              |
| `backend/src/rpc/procedures/gentle-letter.ts`                | oRPC procedures               |
| `backend/scripts/seed-gentle-letters.ts`                     | Dummy data seed script        |
