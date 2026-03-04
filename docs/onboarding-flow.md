# Onboarding Flow — Technical Reference

## Prerequisites

The onboarding flow activates at priority 5 in the guard chain (see [auth-flow.md](./auth-flow.md#guard-priority-evaluated-in-useappinitializer)). The user must be authenticated with a profile and verified email before reaching onboarding.

```typescript
if (!onboardingCompleted) return 'onboarding';
```

## Screen Sequence

The flow has a pre-step (profile picture) plus 8 numbered steps. The pre-step is the index route; steps 1–8 use the `OnboardingLayout` progress bar.

| Step | Route                            | Screen Component       | Purpose                                        |
| ---- | -------------------------------- | ---------------------- | ---------------------------------------------- |
| Pre  | `/onboarding`                    | `AuraPictureSetup`     | Profile picture upload + aura filter toggle    |
| 1    | `/onboarding/welcome`            | `Welcome`              | Intro illustration, Start / Skip               |
| 2    | `/onboarding/life-stressors`     | `LifeStressors`        | Select life stressors (multi-select grid)      |
| 3    | `/onboarding/fear-triggers`      | `FearTriggers`         | Select fear triggers + custom text + dialog    |
| 4    | `/onboarding/regulation-preference` | `RegulationPreference` | Pick regulation tools (max 3) + custom text |
| 5    | `/onboarding/energy-patterns`    | `EnergyPatterns`       | Time-of-day energy mapping (3 segmented rows)  |
| 6    | `/onboarding/calendar-support`   | `CalendarSupport`      | Calendar permission + preferences              |
| 7    | `/onboarding/privacy-trust`      | `PrivacyTrust`         | Privacy guarantees, saves calendar prefs       |
| 8    | `/onboarding/completion`         | `Completion`           | Save answers + mark onboarding complete        |

## State

### Onboarding Atoms (in-memory, not persisted)

Onboarding is a one-time flow. All data is held in a single `onboardingDataAtom` with derived read/write atoms for each screen slice. On completion, the atom is reset to defaults.

| Atom                            | Type                         | Default | Screen   |
| ------------------------------- | ---------------------------- | ------- | -------- |
| `onboardingStressorsAtom`       | `LifeStressor[]`             | `[]`    | Step 2   |
| `onboardingTriggersAtom`        | `FearTrigger[]`              | `[]`    | Step 3   |
| `onboardingCustomTriggerAtom`   | `string`                     | `''`    | Step 3   |
| `onboardingReminderPrefAtom`    | `ReminderPreference \| null` | `null`  | Step 3 (dialog) |
| `onboardingRegulationToolsAtom` | `RegulationTool[]`           | `[]`    | Step 4   |
| `onboardingCustomToolAtom`      | `string`                     | `''`    | Step 4   |
| `onboardingEnergyFocusAtom`     | `TimeOfDay \| null`          | `null`  | Step 5   |
| `onboardingEnergyCreativityAtom`| `TimeOfDay \| null`          | `null`  | Step 5   |
| `onboardingEnergyDipAtom`       | `TimeOfDay \| null`          | `null`  | Step 5   |
| `auraFilterEnabledAtom`         | `boolean`                    | `false` | Pre-step |

**Composite atom:** `onboardingDataAtom` (type `OnboardingData`) holds all fields above (except `auraFilterEnabledAtom`). Derived atoms read/write slices of it. `resetOnboardingAtom` is a write-only atom that resets `onboardingDataAtom` to defaults.

### Calendar Atoms (persisted to AsyncStorage via `atomWithStorage`)

| Atom                       | Storage Key               | Type                      | Default |
| -------------------------- | ------------------------- | ------------------------- | ------- |
| `calendarConnectedAtom`    | `calendar:connected`      | `boolean`                 | `false` |
| `selectedCalendarIdsAtom`  | `calendar:stableIds`      | `string[]`                | `[]`    |
| `checkInTimingAtom`        | `calendar:checkInTiming`  | `CheckInTiming \| null`   | `null`  |
| `supportToneAtom`          | `calendar:supportTone`    | `SupportTone \| null`     | `null`  |

Calendar atoms are persisted because they represent device-level preferences that survive the onboarding flow.

## Types

### `LifeStressor` (Step 2)

```typescript
type LifeStressor =
  | 'work'
  | 'financial'
  | 'relationships'
  | 'self-image'
  | 'time'
  | 'inner-critic'
  | 'isolation'
  | 'fear'
  | 'purpose'
  | 'exhaustion';
```

### `FearTrigger` (Step 3)

```typescript
type FearTrigger =
  | 'spiders'
  | 'heights'
  | 'claustrophobia'
  | 'flying'
  | 'snakes'
  | 'dentist'
  | 'public-speaking'
  | 'crowds'
  | 'needles'
  | 'dogs';
```

### `ReminderPreference` (Step 3 dialog)

```typescript
type ReminderPreference =
  | 'yes-reminders'
  | 'high-stress-only'
  | 'no-reminders';
```

### `RegulationTool` (Step 4)

```typescript
type RegulationTool =
  | 'breathing'
  | 'movement'
  | 'journaling'
  | 'meditation'
  | 'calming-sounds'
  | 'learning'
  | 'talking'
  | 'listen-to-music'
  | 'laughter'
  | 'rest'
  | 'cooking'
  | 'not-sure';
```

### `TimeOfDay` (Step 5)

```typescript
type TimeOfDay = 'morning' | 'midday' | 'evening';
```

### `CheckInTiming` (Step 6)

```typescript
type CheckInTiming = '2-days' | 'day-of' | '1-hour';
```

### `SupportTone` (Step 6)

```typescript
type SupportTone = 'gentle' | 'subtle' | 'direct';
```

## Navigation

### Stack Layout

The onboarding uses a simple Expo Router `Stack` with `headerShown: false`:

```tsx
// src/app/onboarding/_layout.tsx
<Stack screenOptions={{ headerShown: false }} />
```

The index route (`/onboarding`) maps to `AuraPictureSetup`. All other screens are navigated to imperatively via `router.push()`.

### Navigation Flow

```
/onboarding (AuraPictureSetup)
  ├── "Looks Great" or "Maybe Later"
  └── /onboarding/welcome
        ├── "Start" → /onboarding/life-stressors
        │     └── /onboarding/fear-triggers
        │           └── /onboarding/regulation-preference
        │                 └── /onboarding/energy-patterns
        │                       └── /onboarding/calendar-support
        │                             └── /onboarding/privacy-trust
        │                                   └── /onboarding/completion
        └── "Skip for now" → /onboarding/completion
```

### Skip Shortcuts

- **AuraPictureSetup**: "Maybe Later" skips photo upload, navigates to `/onboarding/welcome`
- **Welcome**: "Skip for now" jumps directly to `/onboarding/completion`
- **CalendarSupport**: "Maybe later" / "Skip for now" jumps to `/onboarding/privacy-trust`

All other screens have a back button (`router.back()`) but no skip shortcut.

## Screen Details

### Pre-step: AuraPictureSetup

- Shows the user's existing profile image (from `session.user.image`) or a placeholder
- Camera FAB triggers a dialog: "Choose from Library" or "Take a Photo" (via `useImagePicker`)
- Aura filter toggle enables/disables the `AuraFilterOverlay`
- **"Looks Great"**: If no image selected and no existing image → shows error dialog. If image selected → uploads via `useUploadProfilePicture` then navigates. If existing image and no new selection → navigates without upload.
- **"Maybe Later"**: Navigates to `/onboarding/welcome` without uploading

### Step 1: Welcome

- Full-screen intro with decorative orb illustration
- No `OnboardingLayout` — custom layout with `OnboardingProgressBar` at step 1
- **"Start"**: Navigates to `/onboarding/life-stressors`
- **"Skip for now"**: Navigates directly to `/onboarding/completion`

### Step 2: LifeStressors

- 10-item grid of `OnboardingGridCard` components (2 columns)
- Multi-select toggle, no maximum
- **Validation**: Continue button disabled when `selected.length === 0`
- Navigates to `/onboarding/fear-triggers`

### Step 3: FearTriggers

- 10-item grid + search filter + custom text input (`onboardingCustomTriggerAtom`)
- Multi-select toggle, no maximum
- **Conditional dialog**: If `selected.length > 0`, opens `FearTriggersDialog` (bottom sheet) before navigating. The dialog lets the user pick a `ReminderPreference`.
- **No validation**: Continue is always enabled (0 triggers is valid)
- Navigates to `/onboarding/regulation-preference`

### Step 4: RegulationPreference

- 12 `SelectableChip` options + custom text input (`onboardingCustomToolAtom`)
- **Max 3 selections** — toggling is ignored when at limit (unless deselecting)
- Shows "Selection Limit: X / 3" counter
- **Validation**: Continue button disabled when `selected.length === 0`
- Navigates to `/onboarding/energy-patterns`

### Step 5: EnergyPatterns

- 3 `SegmentedControl` rows: Focus, Creativity, Energy Dip
- Each maps to a `TimeOfDay | null` atom
- **No validation**: All segments start unselected, continue is always enabled
- Navigates to `/onboarding/calendar-support`

### Step 6: CalendarSupport

Three permission states control the UI:

| State      | Condition                      | UI                                                               |
| ---------- | ------------------------------ | ---------------------------------------------------------------- |
| Default    | `!connected && !denied`        | "Connect my calendar" button + "Maybe later" link                |
| Denied     | `!connected && denied`         | Explanation text + "Open Settings" button + "Skip for now" link  |
| Connected  | `connected`                    | Calendar list + check-in timing segmented control + support tone cards |

- Calendar permission requested via `useCalendarPermission` → `expo-calendar`
- On grant: sets `calendarConnectedAtom = true`, loads device calendars filtered by type
- Calendar list uses stable IDs (djb2 hash of sourceType + sourceName + title)
- **"Maybe later" / "Skip for now"**: Both navigate to `/onboarding/privacy-trust`
- **Continue**: Navigates to `/onboarding/privacy-trust`

### Step 7: PrivacyTrust

- 3 privacy feature cards (No Data Sales, Private Events, Granular Control)
- `headerContent` prop renders a shield icon above the title
- **On continue**: If `calendarConnected`, fires `saveCalendarPrefs.mutate()` (fire-and-forget). Always navigates to `/onboarding/completion`.

### Step 8: Completion

- Custom layout (no `OnboardingLayout`) with progress bar at 100% (step 8/8)
- Decorative gradient orb with checkmark
- **"Go to Today"** triggers the save sequence:
  1. `saveOnboardingAnswers.mutateAsync(onboardingData)` — saves all onboarding answers to backend
  2. `completeOnboarding.mutateAsync({})` — sets `onboardingCompletedAt` timestamp
  3. `resetOnboarding()` — clears in-memory atom to defaults
  4. Guard re-evaluates → user proceeds to biometric setup (if available) or Home
- **On error**: Shows dialog "Something went wrong — We couldn't save your answers. Please try again."

## OnboardingLayout Component

Shared layout shell used by steps 2–7. Source: `src/modules/onboarding/components/OnboardingLayout.tsx`.

| Prop                | Type              | Default | Description                                    |
| ------------------- | ----------------- | ------- | ---------------------------------------------- |
| `step`              | `number`          | —       | Current step number (for progress bar)         |
| `totalSteps`        | `number`          | `8`     | Total steps (for progress bar)                 |
| `title`             | `string`          | —       | Screen title text                              |
| `subtitle`          | `string?`         | —       | Subtitle below title                           |
| `titleClassName`    | `string?`         | —       | Override default title NativeWind classes       |
| `subtitleClassName` | `string?`         | —       | Override default subtitle NativeWind classes    |
| `onBack`            | `() => void?`     | —       | Back button handler (hidden if undefined)      |
| `onSkip`            | `() => void?`     | —       | Skip button + footer "Skip for now" (hidden if undefined) |
| `buttonLabel`       | `string`          | —       | Primary CTA text                               |
| `onButtonPress`     | `() => void`      | —       | Primary CTA handler                            |
| `buttonDisabled`    | `boolean?`        | —       | Disables the primary CTA                       |
| `buttonLoading`     | `boolean?`        | —       | Shows spinner on the primary CTA               |
| `buttonIcon`        | `ReactNode?`      | —       | Icon inside the CTA button                     |
| `showStepCounter`   | `boolean`         | `true`  | Shows "Step X of 8" below the button           |
| `headerContent`     | `ReactNode?`      | —       | Content rendered above the title                |
| `children`          | `ReactNode`       | —       | Screen body content                            |
| `scrollable`        | `boolean`         | `true`  | Wraps content in ScrollView with ScrollFade    |

Layout structure: `GlowBg` → `SafeAreaView` → Header (back + `OnboardingProgressBar` + skip) → scrollable/static content → footer (`GradientButton` + step counter + skip link).

## Backend API

### `profile.saveOnboardingAnswers` (authorized)

Upserts onboarding answer columns on the `user_profile` row. Called from the Completion screen.

```typescript
input: {
  stressors: ('work' | 'financial' | 'relationships' | 'self-image' | 'time' | 'inner-critic' | 'isolation' | 'fear' | 'purpose' | 'exhaustion')[]
  triggers: ('spiders' | 'heights' | 'claustrophobia' | 'flying' | 'snakes' | 'dentist' | 'public-speaking' | 'crowds' | 'needles' | 'dogs')[]
  customTrigger: string
  reminderPreference: 'yes-reminders' | 'high-stress-only' | 'no-reminders' | null
  regulationTools: ('breathing' | 'movement' | 'journaling' | 'meditation' | 'calming-sounds' | 'learning' | 'talking' | 'listen-to-music' | 'laughter' | 'rest' | 'cooking' | 'not-sure')[]
  customTool: string
  energyFocus: 'morning' | 'midday' | 'evening' | null
  energyCreativity: 'morning' | 'midday' | 'evening' | null
  energyDip: 'morning' | 'midday' | 'evening' | null
}
```

### `profile.completeOnboarding` (authorized)

Sets `onboardingCompletedAt = new Date()` on the user profile. No input. Called after `saveOnboardingAnswers` succeeds.

### `profile.uploadProfilePicture` (authorized)

Accepts a base64 image, uploads to storage, updates the `user.image` field. Called from the AuraPictureSetup screen.

```typescript
input: {
  base64: string
  mimeType: 'image/jpeg' | 'image/png' | 'image/webp'  // regex-validated
}
```

### `calendar.savePreferences` (authorized)

Upserts the `calendar_preferences` row. Called from PrivacyTrust (fire-and-forget) when the user connected their calendar.

```typescript
input: {
  calendarConnected: boolean
  selectedCalendarIds: string[]
  checkInTiming: '2-days' | 'day-of' | '1-hour' | null
  supportTone: 'gentle' | 'subtle' | 'direct' | null
}
```

## Database Schema

### `user_profile` (onboarding columns)

These columns are added to the existing `user_profile` table alongside the profile setup columns documented in [auth-flow.md](./auth-flow.md).

| Column                  | Type          | Notes                              |
| ----------------------- | ------------- | ---------------------------------- |
| `stressors`             | `jsonb`       | `string[]` — LifeStressor values   |
| `triggers`              | `jsonb`       | `string[]` — FearTrigger values    |
| `custom_trigger`        | `text`        | Free-text custom trigger           |
| `reminder_preference`   | `text`        | ReminderPreference value           |
| `regulation_tools`      | `jsonb`       | `string[]` — RegulationTool values |
| `custom_tool`           | `text`        | Free-text custom tool              |
| `energy_focus`          | `text`        | TimeOfDay value                    |
| `energy_creativity`     | `text`        | TimeOfDay value                    |
| `energy_dip`            | `text`        | TimeOfDay value                    |
| `onboarding_completed_at` | `timestamp` | Set by `completeOnboarding`        |

### `calendar_preferences`

| Column                  | Type          | Notes                                |
| ----------------------- | ------------- | ------------------------------------ |
| `id`                    | `text` PK     | UUID, auto-generated                |
| `user_id`               | `text` UNIQUE | FK → `user.id`, cascade delete      |
| `calendar_connected`    | `boolean`     | Default `false`                      |
| `selected_calendar_ids` | `jsonb`       | `string[]` — stable calendar hashes  |
| `check_in_timing`       | `text`        | CheckInTiming value                  |
| `support_tone`          | `text`        | SupportTone value                    |
| `created_at`            | `timestamp`   | Default `now()`                      |
| `updated_at`            | `timestamp`   | Default `now()`                      |

## Optimistic Updates

`useCompleteOnboarding` implements an optimistic update on the `profile.getProfileStatus` query:

1. **`onMutate`**: Cancels in-flight queries, snapshots current data, sets `onboardingCompleted: true` immediately
2. **`onError`**: Rolls back to the snapshot
3. **`onSettled`**: Invalidates the query to refetch from backend

This allows the guard to re-evaluate instantly (routing to biometric setup or Home) without waiting for the network round-trip.

## File Map

| File                                                          | Role                                                      |
| ------------------------------------------------------------- | --------------------------------------------------------- |
| `src/app/onboarding/_layout.tsx`                              | Stack navigator, `headerShown: false`                     |
| `src/app/onboarding/index.tsx`                                | Route → `AuraPictureSetup`                                |
| `src/app/onboarding/welcome.tsx`                              | Route → `Welcome`                                         |
| `src/app/onboarding/life-stressors.tsx`                       | Route → `LifeStressors`                                   |
| `src/app/onboarding/fear-triggers.tsx`                        | Route → `FearTriggers`                                    |
| `src/app/onboarding/regulation-preference.tsx`                | Route → `RegulationPreference`                            |
| `src/app/onboarding/energy-patterns.tsx`                      | Route → `EnergyPatterns`                                  |
| `src/app/onboarding/calendar-support.tsx`                     | Route → `CalendarSupport`                                 |
| `src/app/onboarding/privacy-trust.tsx`                        | Route → `PrivacyTrust`                                    |
| `src/app/onboarding/completion.tsx`                           | Route → `Completion`                                      |
| `src/modules/onboarding/screens/AuraPictureSetup.tsx`         | Pre-step: photo upload + aura toggle                      |
| `src/modules/onboarding/screens/Welcome.tsx`                  | Step 1: intro + Start/Skip                                |
| `src/modules/onboarding/screens/LifeStressors.tsx`            | Step 2: stressor grid                                     |
| `src/modules/onboarding/screens/FearTriggers.tsx`             | Step 3: trigger grid + search + dialog                    |
| `src/modules/onboarding/screens/RegulationPreference.tsx`     | Step 4: regulation tool chips (max 3)                     |
| `src/modules/onboarding/screens/EnergyPatterns.tsx`           | Step 5: 3× segmented time-of-day controls                 |
| `src/modules/onboarding/screens/CalendarSupport.tsx`          | Step 6: calendar permission + preferences                 |
| `src/modules/onboarding/screens/PrivacyTrust.tsx`             | Step 7: privacy guarantees + calendar save                |
| `src/modules/onboarding/screens/Completion.tsx`               | Step 8: save answers + complete onboarding                |
| `src/modules/onboarding/components/OnboardingLayout.tsx`      | Shared layout shell (steps 2–7)                           |
| `src/modules/onboarding/components/OnboardingProgressBar.tsx` | Gradient progress bar (8 segments)                        |
| `src/modules/onboarding/components/OnboardingGridCard.tsx`    | Pressable icon+label card with gradient border            |
| `src/modules/onboarding/components/SelectableChip.tsx`        | Pill chip with gradient background when selected          |
| `src/modules/onboarding/components/SegmentedControl.tsx`      | Generic segmented control with gradient active state      |
| `src/modules/onboarding/components/FearTriggersDialog.tsx`    | Bottom-sheet dialog for reminder preference               |
| `src/modules/onboarding/components/ProfilePictureCircle.tsx`  | 200px circular image + camera FAB + aura overlay          |
| `src/modules/onboarding/components/AuraFilterOverlay.tsx`     | SVG radial gradient aura effect overlay                   |
| `src/modules/onboarding/components/AuraFilterToggle.tsx`      | Animated toggle switch with haptic feedback               |
| `src/modules/onboarding/hooks/useImagePicker.ts`              | Library/camera image picker with permission handling      |
| `src/modules/onboarding/hooks/useUploadProfilePicture.ts`     | Mutation wrapper for `profile.uploadProfilePicture`       |
| `src/modules/onboarding/hooks/useSaveOnboardingAnswers.ts`    | Mutation wrapper for `profile.saveOnboardingAnswers`      |
| `src/modules/onboarding/hooks/useCompleteOnboarding.ts`       | Optimistic mutation for `profile.completeOnboarding`      |
| `src/modules/onboarding/store/onboarding.ts`                  | Types, `onboardingDataAtom`, derived atoms, reset atom    |
| `src/modules/calendar/types.ts`                               | `CheckInTiming`, `SupportTone`, `DeviceCalendar`, `calendarStableId` |
| `src/modules/calendar/store/calendar.ts`                      | Persisted calendar atoms                                  |
| `src/modules/calendar/hooks/useCalendarPermission.ts`         | Calendar permission + device calendar loading             |
| `src/modules/calendar/hooks/useSaveCalendarPrefs.ts`          | Mutation wrapper for `calendar.savePreferences`           |
| `backend/src/rpc/procedures/profile.ts`                       | `saveOnboardingAnswers`, `completeOnboarding`, `uploadProfilePicture` |
| `backend/src/rpc/procedures/calendar.ts`                      | `savePreferences`                                         |
| `backend/src/db/schema/user-profile.ts`                       | `user_profile` table with onboarding columns              |
| `backend/src/db/schema/calendar-preferences.ts`               | `calendar_preferences` table                              |
