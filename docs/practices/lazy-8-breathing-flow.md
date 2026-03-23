# Lazy 8 Breathing Session — Technical Reference

## Overview

The lazy 8 breathing exercise guides users through a 40-second breathing practice (5 cycles of 8 seconds each). A glowing orb traces an infinity/lemniscate path while the user follows along: inhaling on the right loop and exhaling on the left loop. An instruction audio plays at the start, followed by a 3-second countdown before the breathing session begins. Phase audio cues (inhale, exhale) and a tibetan bowl play at each transition. The session supports pause/resume, state persistence for mid-session exits, and a completion screen with rewards.

## Screen Sequence

| Screen     | Route                                | Component                | Purpose                                           |
| ---------- | ------------------------------------ | ------------------------ | ------------------------------------------------- |
| Intro      | `/practices/lazy-8-breathing-intro`  | `Lazy8BreathingIntro`    | Exercise overview, start/resume/restart            |
| Session    | `/practices/lazy-8-breathing-session`| `Lazy8BreathingSession`  | Timed breathing with infinity animation, audio     |
| Completion | `/practices/completion`              | `Completion`             | Badge, D.O.S.E. rewards, trumpets, confetti        |

## State

### Session State (persisted to AsyncStorage via Jotai `atomWithStorage`)

| Atom                          | Type                                    | Default | Location                                           | Purpose                                         |
| ----------------------------- | --------------------------------------- | ------- | -------------------------------------------------- | ------------------------------------------------ |
| `lazy8BreathingSessionAtom`   | `Lazy8BreathingSessionState \| null`    | `null`  | `src/modules/practices/store/lazy-8-breathing.ts`   | Saves time remaining on mid-session exit         |

```typescript
interface Lazy8BreathingSessionState {
  timeRemaining: number;
}
```

### Derived State (computed in Lazy8BreathingSession)

| Value             | Source                                        | Description                                            |
| ----------------- | --------------------------------------------- | ------------------------------------------------------ |
| `elapsed`         | `TOTAL_DURATION - timeRemaining`              | Seconds elapsed in the session                         |
| `overallProgress` | `elapsed / TOTAL_DURATION`                    | 0–1 value driving the gradient progress bar            |
| `currentPhase`    | `BreathingInfinity` `onPhaseChange` callback  | "Inhale" or "Exhale" (or "Listen" / countdown)         |
| `isPaused`        | Local `useState`                              | Whether the timer, audio, and animation are paused     |
| `instructionDone` | Detected from audio playback status           | Whether the intro audio has finished                   |
| `sessionReady`    | Set after countdown completes                 | Whether the breathing session timer is running         |
| `countdown`       | 3→2→1→0 after `instructionDone`               | Countdown before session starts                        |
| `phaseIndex`      | Derived from `elapsed % 8`                    | 0=inhale (0-4s), 1=exhale (4-8s)                     |

## Breathing Timing

All timing is defined in `BreathingInfinity.tsx` and `Lazy8BreathingSession.tsx`:

| Constant          | Value | Description                            |
| ----------------- | ----- | -------------------------------------- |
| `INHALE_DURATION` | 4s    | Inhale — orb moves along right loop    |
| `EXHALE_DURATION` | 4s    | Exhale — orb moves along left loop     |
| `CYCLE_DURATION`  | 8s    | One full breath cycle                  |
| `TOTAL_DURATION`  | 40s   | Full session (5 cycles)                |

### Phase Sync

The instruction text ("Inhale", "Exhale") is derived from the infinity animation's Reanimated `elapsed` shared value — not from a separate JS timer. `BreathingInfinity` computes the phase on the UI thread via `useDerivedValue` and notifies the session screen through `onPhaseChange` (via `useAnimatedReaction` + `scheduleOnRN`). This guarantees the text always matches the orb position.

## Infinity Animation (BreathingInfinity)

### Geometry

The infinity/lemniscate path is defined by 4 cubic Bezier segments in a `-30 -4 124 88` viewBox (centered with glow padding). The container aspect ratio matches the viewBox (124:88) to ensure the path is perfectly centered. The right loop represents inhale, the left loop represents exhale. Pre-computed sample points (80 total) enable smooth worklet interpolation.

### Orb Movement

The orb position is computed from the `elapsed` shared value:

1. `elapsed % CYCLE_DURATION` → position within the current cycle
2. `cycleProgress / CYCLE_DURATION` → normalized 0–1 progress
3. Linear interpolation between pre-computed sample points on the Bezier path

### Visual Layers (bottom to top)

1. **Infinity path** — gradient stroke (pink→yellow→pink, semi-transparent)
2. **Orb outer glow** — r=14, white at 8% opacity
3. **Orb inner glow** — r=9, pink at 25% opacity
4. **Breathing orb** — solid white, radius pulsates between 5–7.5 (1.5s cycle)

## Audio

### Instruction Audio

File: `src/assets/audio/practices/lazy-8-breathing-session/instructions.mp3`

**Playback timeline:**

| Event              | Trigger                                          |
| ------------------ | ------------------------------------------------ |
| Initial play       | On mount (`useEffect` with `player.play()`)      |
| Instruction done   | Detected when `status.currentTime >= status.duration && !status.playing` |

**Pause behavior:** During the initial instruction phase, pausing the session also pauses the audio.

### Phase Audio

Files from `src/assets/audio/practices/common/`:
- `inhale.mp3` — plays at the start of each inhale phase
- `exhale.mp3` — plays at the start of each exhale phase

Phase audio is triggered by `phaseIndex` changes (derived from `elapsed % 8`). Only plays when `sessionReady && !isPaused`. All phase audio is paused when the session is paused.

### Tibetan Bowl

File: `src/assets/audio/practices/common/tibetan-bowl.mp3`

Plays at the start of each cycle (when `phaseIndex === 0`), at 80% volume. Paused when the session is paused.

### Countdown

After the instruction audio finishes, a 3-second countdown displays ("Starting in 3s", "Starting in 2s", "Starting in 1s") before `sessionReady` is set to `true` and the breathing session begins.

### Completion Audio

`success-trumpets.mp3` plays on the Completion screen (shared with all practices).

## Session Persistence

### Saving (on back navigation)

Uses Expo Router's `beforeRemove` navigation event. Only saves if the session is ready (`sessionReady` is true), so exiting during the instruction phase or countdown does not create a saved session:

```typescript
navigation.addListener('beforeRemove', () => {
  if (sessionReady && timeRemaining > 0) {
    setSession({ timeRemaining });
  }
});
```

### Restoring (on mount)

```typescript
const savedState = useAtomValue(lazy8BreathingSessionAtom);
const initialTimeRef = useRef(savedState?.timeRemaining ?? TOTAL_DURATION);
const [timeRemaining, setTimeRemaining] = useState(initialTimeRef.current);
```

When resuming, the infinity animation receives `initialElapsed` so the orb starts at the correct position along the path, matching where the timer left off.

### Clearing

Session state is cleared (`setSession(null)`) in two places:
1. **When `timeRemaining` reaches 0** — session finished, navigates to completion
2. **Intro screen "Restart Progress" button** — user explicitly resets

## Session Timer

The countdown timer runs via `setInterval` (1s ticks) and only starts after `sessionReady` is true (i.e., after instruction audio finishes AND the 3-second countdown completes). When `timeRemaining` reaches 0, a separate `useEffect` handles completion (clearing state + navigating), avoiding the React "setState during render" pitfall.

## Intro Screen Logic

| Saved state | Button text      | "Restart Progress" visible |
| ----------- | ---------------- | -------------------------- |
| `null`      | "Start"          | No                         |
| `!== null`  | "Resume Session" | Yes                        |

"Restart Progress" calls `setSavedSession(null)`, which hides the button and reverts the CTA text.

## Components

| Component            | File                                                       | Purpose                                         |
| -------------------- | ---------------------------------------------------------- | ----------------------------------------------- |
| `BreathingInfinity`  | `src/modules/practices/components/BreathingInfinity.tsx`    | Animated infinity SVG with orb, phase callback   |
| `GlowBg`            | `src/components/ui/GlowBg.tsx`                             | Radial gradient background                       |
| `BackButton`         | `src/components/ui/BackButton.tsx`                         | Close/back button                                |
| `GradientButton`     | `src/components/ui/GradientButton.tsx`                     | Pink-to-yellow gradient CTA                      |

## File Map

| File                                                                  | Role                                      |
| --------------------------------------------------------------------- | ----------------------------------------- |
| `src/app/practices/lazy-8-breathing-intro.tsx`                         | Route re-export                           |
| `src/app/practices/lazy-8-breathing-session.tsx`                       | Route re-export                           |
| `src/app/practices/completion.tsx`                                     | Route re-export                           |
| `src/modules/practices/screens/Lazy8BreathingIntro.tsx`                | Intro screen with start/resume/restart    |
| `src/modules/practices/screens/Lazy8BreathingSession.tsx`              | Session screen with timer, audio, infinity|
| `src/modules/practices/screens/Completion.tsx`                         | Badge, rewards, trumpets, confetti        |
| `src/modules/practices/components/BreathingInfinity.tsx`               | Infinity SVG + orb animation + phase logic|
| `src/modules/practices/store/lazy-8-breathing.ts`                      | `lazy8BreathingSessionAtom` (persisted)   |
| `src/assets/audio/practices/lazy-8-breathing-session/instructions.mp3` | Instruction narration audio               |
| `src/assets/audio/practices/common/inhale.mp3`                        | Inhale phase audio cue                    |
| `src/assets/audio/practices/common/exhale.mp3`                        | Exhale phase audio cue                    |
| `src/assets/audio/practices/common/tibetan-bowl.mp3`                  | Tibetan bowl cycle marker                 |
| `src/assets/audio/success-trumpets.mp3`                                | Completion celebration audio              |
