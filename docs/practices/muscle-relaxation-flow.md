# Muscle Relaxation Session — Technical Reference

## Overview

The muscle relaxation exercise guides users through 10 muscle groups with audio-guided progressive muscle relaxation. Each group plays an instruction audio clip, followed by a 10-second hold/relax period, then advances to the next group. One pass through all 10 groups, then completion. Total session duration is approximately 208 seconds (~3.5 minutes).

## Screen Sequence

| Screen     | Route                                    | Component                    | Purpose                                             |
| ---------- | ---------------------------------------- | ---------------------------- | --------------------------------------------------- |
| Intro      | `/practices/muscle-relaxation-intro`     | `MuscleRelaxationIntro`      | Exercise overview, start/resume/restart              |
| Session    | `/practices/muscle-relaxation-session`   | `MuscleRelaxationSession`    | Audio-guided relaxation with body silhouette         |
| Completion | `/practices/completion`                  | `Completion`                 | Badge, D.O.S.E. rewards, trumpets, confetti          |

## State

### Session State (persisted to AsyncStorage via Jotai `atomWithStorage`)

| Atom                              | Type                                       | Default | Location                                              | Purpose                                        |
| --------------------------------- | ------------------------------------------ | ------- | ----------------------------------------------------- | ---------------------------------------------- |
| `muscleRelaxationSessionAtom`     | `MuscleRelaxationSessionState \| null`     | `null`  | `src/modules/practices/store/muscle-relaxation.ts`     | Saves current step index on mid-session exit   |

```typescript
interface MuscleRelaxationSessionState {
  currentStepIndex: number;
}
```

### Local State (in MuscleRelaxationSession)

| Value              | Source                                        | Description                                                  |
| ------------------ | --------------------------------------------- | ------------------------------------------------------------ |
| `currentStepIndex` | `useState`, initialized from saved state      | Index of the active muscle group (0–9)                       |
| `stepPhase`        | `useState`                                    | Current phase: `'audio'` (instruction playing) or `'wait'` (10s hold) |
| `waitTimeRemaining`| `useState`, decremented via `setInterval`     | Seconds left in the wait phase (counts down from 10)         |
| `isPaused`         | `useState`                                    | Whether the timer, audio, and elapsed counter are paused     |
| `elapsedTotal`     | `useState`, incremented via `setInterval`     | Total seconds elapsed (computed from completed steps on resume) |
| `audioElapsedRef`  | `useRef`                                      | Seconds elapsed in the current audio phase                   |

## Muscle Groups

10 groups, each with an instruction audio and a 10-second hold:

| # | Group          | Audio Duration | Glow Position (cx, cy) | Audio File                   |
|---|----------------|---------------|------------------------|------------------------------|
| 1 | Face           | 15s           | [100, 40]              | `face.mp3`                   |
| 2 | Neck           | 9s            | [100, 55]              | `neck.mp3`                   |
| 3 | Chest          | 9s            | [100, 100]             | `chest.mp3`                  |
| 4 | Shoulders      | 12s           | [100, 75]              | `shoulders.mp3`              |
| 5 | Upper Back     | 3s            | [100, 110]             | `upper-back.mp3`             |
| 6 | Abdomen        | 3s            | [100, 145]             | `abdomen.mp3`                |
| 7 | Hands & Arms   | 18s           | [50, 165]              | `hands-and-arms.mp3`         |
| 8 | Right Leg      | 14s           | [120, 280]             | `right-leg.mp3`              |
| 9 | Left Leg       | 18s           | [80, 280]              | `left-leg.mp3`               |
| 10| Feet           | 7s            | [100, 370]             | `feet.mp3`                   |

Total audio: ~108s. Total wait: 10 x 10s = 100s. **TOTAL_DURATION ≈ 208s**.

## Step State Machine

Each muscle group goes through two phases:

```
Audio Phase (instruction plays) → Wait Phase (10s hold/relax) → Next Group
```

### Audio Phase

- Instruction audio plays via `useAudioPlayer` with `player.replace()` on step change
- Duration tracked by a `setInterval` timer (`audioElapsedRef`) using the known `audioDuration` values
- When `audioElapsedRef >= audioDuration`, transitions to wait phase
- GlowBg intensity: **0.15** (reduced during instruction)

### Wait Phase

- 10-second countdown displayed as "Hold and relax for Xs"
- `waitTimeRemaining` decremented via `setInterval`
- When `waitTimeRemaining` reaches 0, advances to next step (or completes if last)
- GlowBg intensity: **0.25** (brighter during hold)

## Body Silhouette

An SVG body outline (200x400 viewBox, rendered at 160x340) with an animated glow that moves to the active muscle group's position.

### Glow Layers

1. **Inner pink circle** — `r=25`, `fillOpacity=0.15`, centered on `glowPosition`
2. **Shoulder side circles** — two `r=12` circles at `cx±25, cy+10`, shown only when `60 < cy < 100`
3. **Animated outer overlay** — 100x100 `Animated.View` with pink background, pulsing opacity `0.08–0.15` (1.2s cycle)

## Audio

### Instruction Audio (per muscle group)

Files: `src/assets/audio/practices/muscle-relaxation-session/{group-id}.mp3`

| Event          | Trigger                                                |
| -------------- | ------------------------------------------------------ |
| Initial play   | On mount (plays the current step's audio)              |
| Step change    | `player.replace(newAudio)` then `player.play()`        |
| Phase end      | Timer-based: `audioElapsedRef >= audioDuration`        |

**Pause behavior:** Pausing the session pauses the audio player. Resuming calls `player.play()` to continue.

**Note:** Audio completion is detected via a timer (using known `audioDuration` values), not via `useAudioPlayerStatus`, because `player.replace()` causes stale status values that break status-based detection.

## Playback Controls

### Pause/Resume

A single button toggles `isPaused`:
- **Pause:** Stops the audio player, audio phase timer, wait countdown, and elapsed counter
- **Resume:** Restarts all timers and resumes audio playback

## Progress Bar

A gradient bar (pink → yellow) showing `elapsedTotal / TOTAL_DURATION`.

## Step Navigator

A horizontal `ScrollView` showing all 10 muscle groups as icon cards:
- **Completed:** Check-circle icon, muted pink
- **Active:** Gradient background (pink → yellow), dark icon
- **Upcoming:** Muted icon, white/20 opacity

Auto-scrolls to keep the active group visible.

## Session Persistence

### Saving (on back navigation)

Uses Expo Router's `beforeRemove` navigation event. Saves `currentStepIndex` if session is still in progress:

```typescript
navigation.addListener('beforeRemove', () => {
  if (timeRemaining > 0) {
    setSession({ currentStepIndex });
  }
});
```

### Restoring (on mount)

```typescript
const savedState = useAtomValue(muscleRelaxationSessionAtom);
const initialStepRef = useRef(savedState?.currentStepIndex ?? 0);
const initialElapsed = MUSCLE_GROUPS.slice(0, initialStepRef.current).reduce(
  (sum, g) => sum + g.audioDuration + WAIT_DURATION, 0,
);
```

On resume, `elapsedTotal` is computed from completed steps (sum of `audioDuration + 10s` for each step before the current one). The current step's audio replays from the beginning.

### Clearing

Session state is cleared (`setSession(null)`) in two places:
1. **When the last step's wait finishes** — session completed, navigates to completion
2. **Intro screen "Restart Progress" button** — user explicitly resets

## Intro Screen Logic

| Saved state | Button text      | "Restart Progress" visible |
| ----------- | ---------------- | -------------------------- |
| `null`      | "Start Session"  | No                         |
| `!== null`  | "Resume Session" | Yes                        |

## Components

| Component          | File                                                        | Purpose                                      |
| ------------------ | ----------------------------------------------------------- | -------------------------------------------- |
| `BodySilhouette`   | Inline in `MuscleRelaxationSession.tsx`                      | SVG body with animated glow                  |
| `BiometricBadge`   | Inline in `MuscleRelaxationSession.tsx`                      | Stress/breath metric badges                  |
| `MuscleGroupStep`  | Inline in `MuscleRelaxationSession.tsx`                      | Step navigator card                          |
| `GlowBg`           | `src/components/ui/GlowBg.tsx`                               | Radial gradient background                   |
| `BackButton`       | `src/components/ui/BackButton.tsx`                           | Close/back button                            |
| `GradientButton`   | `src/components/ui/GradientButton.tsx`                       | Pink-to-yellow gradient CTA                  |

## File Map

| File                                                                       | Role                                       |
| -------------------------------------------------------------------------- | ------------------------------------------ |
| `src/app/practices/muscle-relaxation-intro.tsx`                            | Route re-export                            |
| `src/app/practices/muscle-relaxation-session.tsx`                          | Route re-export                            |
| `src/app/practices/completion.tsx`                                         | Route re-export                            |
| `src/modules/practices/screens/MuscleRelaxationIntro.tsx`                  | Intro screen with start/resume/restart     |
| `src/modules/practices/screens/MuscleRelaxationSession.tsx`                | Session screen with audio, body silhouette |
| `src/modules/practices/screens/Completion.tsx`                             | Badge, rewards, trumpets, confetti         |
| `src/modules/practices/store/muscle-relaxation.ts`                         | `muscleRelaxationSessionAtom` (persisted)  |
| `src/assets/audio/practices/muscle-relaxation-session/face.mp3`            | Face instruction audio                     |
| `src/assets/audio/practices/muscle-relaxation-session/neck.mp3`            | Neck instruction audio                     |
| `src/assets/audio/practices/muscle-relaxation-session/chest.mp3`           | Chest instruction audio                    |
| `src/assets/audio/practices/muscle-relaxation-session/shoulders.mp3`       | Shoulders instruction audio                |
| `src/assets/audio/practices/muscle-relaxation-session/upper-back.mp3`      | Upper back instruction audio               |
| `src/assets/audio/practices/muscle-relaxation-session/abdomen.mp3`         | Abdomen instruction audio                  |
| `src/assets/audio/practices/muscle-relaxation-session/hands-and-arms.mp3`  | Hands & arms instruction audio             |
| `src/assets/audio/practices/muscle-relaxation-session/right-leg.mp3`       | Right leg instruction audio                |
| `src/assets/audio/practices/muscle-relaxation-session/left-leg.mp3`        | Left leg instruction audio                 |
| `src/assets/audio/practices/muscle-relaxation-session/feet.mp3`            | Feet instruction audio                     |
| `src/assets/audio/success-trumpets.mp3`                                    | Completion celebration audio               |
