# Private Journal — Technical Reference

## Overview

The Private Journal is a biometric-locked feature where users write emotional reflections. It has three screens: a locked screen requiring biometric authentication, a dashboard with a calendar and entry list, and an entry screen for creating, viewing, and editing reflections. Entries can include a feeling, a need, custom tags, and freeform text. The journal auto-locks when the app goes to the background.

## Screen Sequence

| Screen     | Route                 | Component            | Purpose                                         |
| ---------- | --------------------- | -------------------- | ----------------------------------------------- |
| Locked     | `/journal`            | `LockedJournal`      | Biometric gate, blurred stats, unlock button    |
| Dashboard  | `/journal/dashboard`  | `JournalDashboard`   | Calendar, entry list, daily prompt, FAB         |
| New Entry  | `/journal/new`        | `JournalEntry`       | Create a new journal entry                      |
| View/Edit  | `/journal/[id]`       | `JournalEntry`       | View or edit an existing entry                  |

## State

### Jotai Atoms (client state)

| Atom                   | Type                   | Persisted | Location                                    | Purpose                                  |
| ---------------------- | ---------------------- | --------- | ------------------------------------------- | ---------------------------------------- |
| `journalUnlockedAtom`  | `boolean`              | No        | `src/modules/journal/store/journal.ts`      | Whether journal is unlocked this session |
| `selectedDateAtom`     | `string`               | No        | `src/modules/journal/store/journal.ts`      | Currently selected calendar date         |
| `selectedMonthAtom`    | `number`               | No        | `src/modules/journal/store/journal.ts`      | Currently viewed month (1–12)            |
| `selectedYearAtom`     | `number`               | No        | `src/modules/journal/store/journal.ts`      | Currently viewed year                    |
| `journalDraftAtom`     | `Draft \| null`        | Yes       | `src/modules/journal/store/journal.ts`      | Auto-saved draft for crash recovery      |

```typescript
interface Draft {
  feeling: string | null;
  need: string | null;
  content: string;
  tags: string[];
}
```

### React Query (server state)

| Hook                         | RPC Procedure                  | Purpose                                    |
| ---------------------------- | ------------------------------ | ------------------------------------------ |
| `useJournalEntriesForDate`   | `journal.listEntries`          | Entries for a specific date                |
| `useEntryDatesForMonth`      | `journal.getEntryDatesForMonth`| Dates with entries for calendar dots       |
| `useJournalEntry`            | `journal.getEntry`             | Single entry by ID                         |
| `useCreateEntry`             | `journal.createEntry`          | Create a new entry                         |
| `useUpdateEntry`             | `journal.updateEntry`          | Update an existing entry                   |
| `useDeleteEntry`             | `journal.deleteEntry`          | Delete an entry                            |
| `useJournalStats`            | `journal.getStats`             | Total entries count and streak             |
| `useJournalTags`             | `journal.listTags`             | All user's saved tags                      |
| `useCreateTag`               | `journal.createTag`            | Create or retrieve a tag                   |
| `useDeleteTag`               | `journal.deleteTag`            | Delete a saved tag                         |

## Database Schema

### journal_entry

| Column     | Type       | Notes                                        |
| ---------- | ---------- | -------------------------------------------- |
| id         | text PK    | UUID, auto-generated                         |
| userId     | text FK    | References user.id, cascade delete           |
| feeling    | text       | Nullable — pleasant, connected, neutral, unpleasant, anxious, angry |
| need       | text       | Nullable — connection, safety, autonomy, meaning |
| title      | text       | Nullable — auto-generated from first 50 chars of content |
| content    | text       | Not null, default empty string               |
| tags       | jsonb      | Array of tag name strings                    |
| entryDate  | text       | "YYYY-MM-DD" format, not null                |
| createdAt  | timestamp  | Not null, default now                        |
| updatedAt  | timestamp  | Not null, default now                        |

Index on (userId, entryDate) for calendar queries.

### journal_tag

| Column     | Type       | Notes                                        |
| ---------- | ---------- | -------------------------------------------- |
| id         | text PK    | UUID, auto-generated                         |
| userId     | text FK    | References user.id, cascade delete           |
| name       | text       | Not null                                     |
| color      | text       | Nullable — hex color string                  |
| createdAt  | timestamp  | Not null, default now                        |

Unique constraint on (userId, name).

## Biometric Lock

### How it works

The `useJournalLock` hook manages the lock lifecycle:

- `journalUnlockedAtom` is in-memory only — defaults to `false` on every app start
- `unlock()` calls `expo-local-authentication` `authenticateAsync` with the prompt "Unlock your journal"
- `lock()` sets the atom back to `false`
- An `AppState` listener auto-locks when the app transitions from active to inactive or background
- The biometric icon adapts to the device: `scan` (Ionicons) for Face ID, `finger-print` for Touch ID/Fingerprint

### Auto-unlock on return

When the dashboard detects a lock (via `journalUnlockedAtom` becoming false), it navigates to `/journal?autoUnlock=1`. The locked screen reads this param and waits for `AppState` to become `active`, then automatically triggers biometric authentication. If it succeeds, the user goes straight back to the dashboard.

### Manual lock

The lock button on the dashboard header sets `journalUnlockedAtom` to false and navigates to `/journal` (without the `autoUnlock` param), so the user must manually tap "Unlock Journal."

## Calendar

### Custom implementation

The calendar is built from scratch (no external library) to match the design's gradient borders and dot indicators.

### Grid computation

- First day of the week is Monday
- Empty cells pad before the 1st of the month
- Each day cell is a fixed 36x36 Pressable to prevent layout shifts
- Selected day has a LinearGradient border (pink to yellow)
- Days with entries show a 4px pink dot with glow shadow
- Future days are dimmed and not selectable

### Month navigation

Left/right arrows change `selectedMonthAtom` and `selectedYearAtom`. Crossing year boundaries is handled (December ↔ January).

## Entry Screen

### Three modes

The `JournalEntry` component serves all three modes based on route params:

| Mode   | Condition              | Behavior                                    |
| ------ | ---------------------- | ------------------------------------------- |
| Create | No `id` param          | Empty form, restores draft on mount         |
| View   | `id` param, not editing| Read-only, "Edit" button in header          |
| Edit   | `id` param, editing    | Editable, "Save Reflection" button visible  |

### Feeling and need dropdowns

Expandable sections animated with Reanimated (`useSharedValue` + `withTiming`). FeelingDropdown has a pink glow border, NeedDropdown has a yellow glow border. Selecting an option collapses the dropdown.

### Tags

- Tags are displayed in a horizontal ScrollView (edge-to-edge with negative margins)
- Feeling and need selections appear as the first chips (pink and yellow)
- Custom tags get a deterministic color from 6 options based on a hash of the tag name
- Tag colors are stored in the backend when created
- Previously saved tags appear as suggestions for quick re-selection
- Suggested tags also scroll horizontally edge-to-edge

### Auto-save drafts

A debounced effect (1.5s) saves feeling, need, content, and tags to `journalDraftAtom` (AsyncStorage). On create mode mount, if a draft exists, it is restored. After successful save, the draft is cleared. "Auto-saving..." briefly appears during the debounce.

### Keyboard handling

Uses `KeyboardAwareScrollView` from `react-native-keyboard-controller` for auto-scrolling to the focused input. The save button uses `KeyboardStickyView` to stay above the keyboard.

## Entry Card (Dashboard)

Each entry on the dashboard shows:

- Time (top left) — formatted as "HH:MM AM/PM"
- Time icon (top right) — sun icon (yellow) for 6am–6pm, moon/bedtime icon (purple) for nighttime
- Title — bold, auto-generated from content if not set
- Content preview — one line, dimmed
- Tags — horizontal scroll, up to 3 shown with "+N" overflow, colors match the tag's stored color

## RPC Procedures

All procedures use the `authorized` middleware (require valid session).

| Procedure              | Input                                  | Description                                     |
| ---------------------- | -------------------------------------- | ----------------------------------------------- |
| `createEntry`          | feeling?, need?, content, title?, tags?, entryDate | Insert entry, auto-gen title from content |
| `updateEntry`          | id, feeling?, need?, content?, title?, tags? | Update with ownership check              |
| `deleteEntry`          | id                                     | Delete with ownership check                     |
| `getEntry`             | id                                     | Get single entry, verify ownership              |
| `listEntries`          | date                                   | Entries for a specific date, newest first        |
| `getEntryDatesForMonth`| month, year                            | Distinct dates with entries (for calendar dots)  |
| `getStats`             | —                                      | Total entries and current streak                 |
| `listTags`             | —                                      | All user's custom tags                           |
| `createTag`            | name, color?                           | Upsert on (userId, name)                        |
| `deleteTag`            | id                                     | Delete with ownership check                     |

### Streak calculation

Queries all distinct entry dates ordered descending, then counts consecutive days starting from today. If today has no entry, the streak is 0.

## Components

| Component            | File                                                      | Purpose                                    |
| -------------------- | --------------------------------------------------------- | ------------------------------------------ |
| `LockedJournal`      | `src/modules/journal/screens/LockedJournal.tsx`           | Biometric lock screen                      |
| `JournalDashboard`   | `src/modules/journal/screens/JournalDashboard.tsx`        | Calendar + entry list + FAB                |
| `JournalEntry`       | `src/modules/journal/screens/JournalEntry.tsx`            | Create/view/edit entry                     |
| `JournalCalendar`    | `src/modules/journal/components/JournalCalendar.tsx`      | Month grid with navigation                 |
| `CalendarDay`        | `src/modules/journal/components/CalendarDay.tsx`          | Single day cell with gradient border + dot |
| `DailyInsightCard`   | `src/modules/journal/components/DailyInsightCard.tsx`     | Gradient-border prompt card                |
| `EntryCard`          | `src/modules/journal/components/EntryCard.tsx`            | Entry preview with tags and time icon      |
| `FeelingDropdown`    | `src/modules/journal/components/FeelingDropdown.tsx`      | Expandable feeling selector (pink glow)    |
| `NeedDropdown`       | `src/modules/journal/components/NeedDropdown.tsx`         | Expandable need selector (yellow glow)     |
| `TagSection`         | `src/modules/journal/components/TagSection.tsx`           | Selected chips + tag input + suggestions   |
| `BlurredStats`       | `src/modules/journal/components/BlurredStats.tsx`         | Blurred stat boxes for locked screen       |
| `FloatingAddButton`  | `src/modules/journal/components/FloatingAddButton.tsx`    | Gradient FAB for new entry                 |
| `GlowBg`             | `src/components/ui/GlowBg.tsx`                            | Radial gradient background                 |
| `BackButton`         | `src/components/ui/BackButton.tsx`                        | Back/close button                          |
| `GradientButton`     | `src/components/ui/GradientButton.tsx`                    | Pink-to-yellow gradient CTA                |

## File Map

| File                                                        | Role                          |
| ----------------------------------------------------------- | ----------------------------- |
| `src/app/journal/_layout.tsx`                               | Stack layout, no header       |
| `src/app/journal/index.tsx`                                 | Route re-export → LockedJournal |
| `src/app/journal/dashboard.tsx`                             | Route re-export → JournalDashboard |
| `src/app/journal/new.tsx`                                   | Route re-export → JournalEntry |
| `src/app/journal/[id].tsx`                                  | Route re-export → JournalEntry |
| `src/modules/journal/store/journal.ts`                      | Jotai atoms                   |
| `src/modules/journal/data/options.ts`                       | Feeling/need option arrays    |
| `src/modules/journal/data/tag-colors.ts`                    | Shared tag color utilities    |
| `src/modules/journal/hooks/useJournalLock.ts`               | Biometric lock/unlock + AppState auto-lock |
| `src/modules/journal/hooks/useJournalEntries.ts`            | React Query CRUD hooks        |
| `src/modules/journal/hooks/useJournalStats.ts`              | Stats query hook              |
| `src/modules/journal/hooks/useJournalTags.ts`               | Tags query + mutation hooks   |
| `backend/src/db/schema/journal-entry.ts`                    | Entry table definition        |
| `backend/src/db/schema/journal-tag.ts`                      | Tag table definition          |
| `backend/src/rpc/procedures/journal.ts`                     | All journal RPC procedures    |

## Navigation

```
Home → QuickAccessGrid "Journal" → /journal (LockedJournal)
  → Biometric unlock → /journal/dashboard (JournalDashboard)
    → Tap entry card → /journal/[id] (view entry)
    → Tap "+" FAB → /journal/new (create entry)
    → Tap lock button → /journal (manual re-lock)
  → App backgrounds → auto-lock → /journal?autoUnlock=1 (auto biometric prompt on return)
  → Back button → Home
```
