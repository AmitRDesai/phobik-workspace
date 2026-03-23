# Sleep Meditation Session — Technical Reference

## Overview

The sleep meditation exercise plays a guided audio meditation to help users fall asleep. Unlike other exercises, it has no intro screen — the exercise library navigates directly to the session screen. Users choose a session length (Full, 15 Min, 30 Min, or 45 Min), then press play to start the audio. The session includes playback controls (pause/resume, 10s skip forward/backward) and a progress bar with elapsed/remaining time. There is no completion screen; when the audio finishes, the saved state is cleared.

## Screen Sequence

| Screen  | Route                                  | Component                  | Purpose                                         |
| ------- | -------------------------------------- | -------------------------- | ----------------------------------------------- |
| Session | `/practices/sleep-meditation-session`  | `SleepMeditationSession`   | Audio playback with duration selection, controls |

No intro screen. No completion screen. The exercise library card navigates directly to the session.

## State

### Session State (persisted to AsyncStorage via Jotai `atomWithStorage`)

| Atom                            | Type                                      | Default | Location                                            | Purpose                                              |
| ------------------------------- | ----------------------------------------- | ------- | --------------------------------------------------- | ---------------------------------------------------- |
| `sleepMeditationSessionAtom`    | `SleepMeditationSessionState \| null`     | `null`  | `src/modules/practices/store/sleep-meditation.ts`    | Saves selected duration and playback position on exit |

```typescript
type SleepMeditationDuration = '15min' | '30min' | '45min' | 'full';

interface SleepMeditationSessionState {
  selectedDuration: SleepMeditationDuration;
  currentTime: number;
}
```

### Local State (in SleepMeditationSession)

| Value              | Source                                       | Description                                                     |
| ------------------ | -------------------------------------------- | --------------------------------------------------------------- |
| `selectedDuration` | `useState`, initialized from saved state     | Active duration: `'15min'` (default), `'30min'`, `'45min'`, or `'full'` |
| `hasStarted`       | `useState`                                   | Whether the user has pressed play at least once                  |
| `player`           | `useAudioPlayer`                             | Expo Audio player for the selected duration's file               |
| `status`           | `useAudioPlayerStatus`                       | Current playback status (currentTime, duration, playing)         |

## Audio Files

4 variants of the guided sleep meditation, stored in `src/assets/audio/practices/sleep-meditation/`:

| Key     | File                              | Duration |
| ------- | --------------------------------- | -------- |
| `full`  | `sleep-meditation-1.m4a`         | Full     |
| `15min` | `sleep-meditation-1-15min.m4a`   | 15 min   |
| `30min` | `sleep-meditation-1-30min.m4a`   | 30 min   |
| `45min` | `sleep-meditation-1-45min.m4a`   | 45 min   |

Default selection: **15 min**.

## Duration Selector

A horizontal row of 4 pill buttons: "Full", "15 Min", "30 Min", "45 Min".

| Condition       | Behavior                                                        |
| --------------- | --------------------------------------------------------------- |
| Before playing  | All pills interactive; tapping switches `player.replace()`      |
| While playing   | Pills disabled and dimmed (`opacity-40`)                        |
| While paused    | Pills re-enable; tapping switches audio and resets `hasStarted` |

When switching duration while paused, `hasStarted` resets to `false`, so the user must press play to start the new audio from the beginning.

## Playback Controls

### Play/Pause

Large yellow circular button (80x80, `accent.yellow` background).

| State        | Icon         | Action                     |
| ------------ | ------------ | -------------------------- |
| Not started  | `play-arrow` | Sets `hasStarted`, plays   |
| Playing      | `pause`      | Pauses audio               |
| Paused       | `play-arrow` | Resumes audio              |

### Skip Forward/Backward 10s

Two buttons flanking the play/pause button:
- **Replay 10s:** `player.seekTo(Math.max(0, currentTime - 10))`
- **Forward 10s:** `player.seekTo(Math.min(duration, currentTime + 10))`

Both are disabled (dimmed) until playback has started.

## Progress Bar

A yellow progress bar showing `currentTime / duration`:
- **Left label:** Elapsed time (e.g., `18:42`)
- **Center pill:** Remaining time badge with timer icon (e.g., `11:18 REMAINING`)
- **Right label:** Total duration (e.g., `30:00`)
- **Bar:** Yellow fill on a `bg-white/5` track, with yellow glow shadow

All time labels use `fontVariant: ['tabular-nums']` for stable width.

## Visual Elements

### Pulsing Aura

A circular image (190x190) of a nebula/galaxy scene, surrounded by:
1. **Yellow ring** — 24px padding, `bg-accent-yellow/[0.06]`
2. **SVG radial gradient aura** — 300x300, `RadialGradient` from `primary.pink-light` (40% opacity) at center → `accent.yellow` (15% opacity) at 60% → transparent

When audio is playing, the aura pulses (scale 1 → 1.12 → 1, opacity 0.3 → 0.6 → 0.3, 6s cycle). When not playing, it settles to static (scale 1, opacity 0.4).

### Background

Two overlapping `GlowBg` layers creating the nebula effect:
1. Pink glow at top-left (20%, 30%), intensity 0.12
2. Yellow glow at bottom-right (80%, 70%), intensity 0.08

## Session Persistence

### Saving (on back navigation)

Uses Expo Router's `beforeRemove` navigation event. Saves both `selectedDuration` and `currentTime` if the session has started and has a valid position:

```typescript
navigation.addListener('beforeRemove', () => {
  if (hasStartedRef.current && status.currentTime > 0 && status.duration > 0) {
    setSession({ selectedDuration, currentTime: status.currentTime });
  }
});
```

### Restoring (on mount)

```typescript
const savedState = useAtomValue(sleepMeditationSessionAtom);
const initialDuration = savedState?.selectedDuration ?? '15min';
const initialTime = savedState?.currentTime ?? 0;
```

On resume:
- The saved duration's audio file is loaded
- Player seeks to `savedState.currentTime` once `status.duration > 0`
- Audio does **not** auto-play — user must press play to resume

### Clearing

Session state is cleared (`setSession(null)`) when audio finishes playing (detected via `currentTime >= duration && !playing`).

## Audio Completion

When the audio reaches the end:
- Saved state is cleared
- No navigation occurs — the user stays on the session screen
- The user can switch to a different duration and start again

## Components

| Component      | File                                                         | Purpose                                    |
| -------------- | ------------------------------------------------------------ | ------------------------------------------ |
| `PulsingAura`  | Inline in `SleepMeditationSession.tsx`                       | Radial gradient aura with pulsing animation |
| `GlowBg`       | `src/components/ui/GlowBg.tsx`                               | Radial gradient background                 |
| `BackButton`   | `src/components/ui/BackButton.tsx`                           | Back/collapse button                       |

## File Map

| File                                                                       | Role                                      |
| -------------------------------------------------------------------------- | ----------------------------------------- |
| `src/app/practices/sleep-meditation-session.tsx`                           | Route re-export                           |
| `src/modules/practices/screens/SleepMeditationSession.tsx`                 | Session screen with audio, aura, controls |
| `src/modules/practices/store/sleep-meditation.ts`                          | `sleepMeditationSessionAtom` (persisted)  |
| `src/modules/practices/data/exercises.ts`                                  | Exercise definition (id: `sleep-meditation`) |
| `src/modules/practices/screens/ExerciseLibrary.tsx`                        | Route mapping to session (no intro)       |
| `src/assets/audio/practices/sleep-meditation/sleep-meditation-1.m4a`       | Full meditation audio                     |
| `src/assets/audio/practices/sleep-meditation/sleep-meditation-1-15min.m4a` | 15 min meditation audio                   |
| `src/assets/audio/practices/sleep-meditation/sleep-meditation-1-30min.m4a` | 30 min meditation audio                   |
| `src/assets/audio/practices/sleep-meditation/sleep-meditation-1-45min.m4a` | 45 min meditation audio                   |
| `src/assets/images/practices/sleep-meditation.jpg`                         | Nebula circle image                       |
