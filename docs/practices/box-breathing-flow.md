# Box Breathing Session — Technical Reference

## Overview

The box breathing exercise guides users through a continuous 4-4-4-4 breathing pattern: inhale for 4 seconds, hold for 4 seconds, exhale for 4 seconds, rest for 4 seconds. A rounded square fills and empties from the center in sync with the breathing phases. The session runs for exactly 5 cycles (80 seconds) with instruction audio at the start, a 3-second countdown, per-phase audio cues, a tibetan bowl at each cycle start, playback controls (skip forward/backward between phases), session persistence, and a completion screen with rewards.

## Screen Sequence

| Screen     | Route                              | Component              | Purpose                                              |
| ---------- | ---------------------------------- | ---------------------- | ---------------------------------------------------- |
| Intro      | `/practices/box-breathing-intro`   | `BoxBreathingIntro`    | Exercise overview, start/resume/restart               |
| Session    | `/practices/box-breathing-session` | `BoxBreathingSession`  | Timed breathing with square animation, HRV, controls |
| Completion | `/practices/completion`            | `Completion`           | Badge, D.O.S.E. rewards, trumpets, confetti           |

## State

### Session State (persisted to AsyncStorage via Jotai `atomWithStorage`)

| Atom                       | Type                                 | Default | Location                                       | Purpose                                    |
| -------------------------- | ------------------------------------ | ------- | ---------------------------------------------- | ------------------------------------------ |
| `boxBreathingSessionAtom`  | `BoxBreathingSessionState \| null`   | `null`  | `src/modules/practices/store/box-breathing.ts`  | Saves time remaining on mid-session exit   |

```typescript
interface BoxBreathingSessionState {
  timeRemaining: number;
}
```

### Local State (in BoxBreathingSession)

| Value             | Source                                     | Description                                           |
| ----------------- | ------------------------------------------ | ----------------------------------------------------- |
| `timeRemaining`   | `useState`, decremented via `setInterval`  | Seconds left in the session (counts down from 80)     |
| `elapsed`         | `TOTAL_DURATION - timeRemaining`           | Seconds elapsed since session start                   |
| `isPaused`        | Local `useState`                           | Whether the timer, audio, and animation are paused    |
| `instructionDone` | Detected from audio playback status        | Whether the intro audio has finished                  |
| `countdown`       | 3-second countdown after instruction ends  | Counts 3 → 2 → 1 → 0, then session starts            |
| `sessionReady`    | Set when countdown reaches 0               | Whether the exercise has started (gate for timer/audio) |
| `phaseIndex`      | `Math.floor((elapsed % 16) / 4)`          | Which of the 4 phases (0–3)                           |

## Breathing Timing

All timing is defined in `BreathingBox.tsx` and `BoxBreathingSession.tsx`:

| Constant         | Value | Description                        |
| ---------------- | ----- | ---------------------------------- |
| `PHASE_DURATION` | 4s    | Duration of each phase             |
| `CYCLE_DURATION` | 16s   | One full breath cycle (4 phases)   |
| `TOTAL_DURATION` | 80s   | Full session (5 cycles)            |

### Phases

```
Inhale (4s) → Hold (4s) → Exhale (4s) → Rest (4s) → repeat
```

Phases are derived from elapsed time using modular arithmetic — no state transitions needed.

## Square Animation (BreathingBox)

### Props

| Prop        | Type    | Default     | Description                                    |
| ----------- | ------- | ----------- | ---------------------------------------------- |
| `elapsed`   | number  | —           | Seconds elapsed since session start            |
| `isPaused`  | boolean | —           | Whether the session is paused                  |
| `isActive`  | boolean | `true`      | Whether the exercise is active (post-instruction) |
| `countdown` | number  | `undefined` | Countdown seconds (3, 2, 1) before start       |

### Fill Animation

The square starts empty and fills from the center using a scale transform on a gradient view:

- **Inhale (phaseIndex 0)**: `fillProgress` animates 0→1 (grows from center)
- **Hold after inhale (phaseIndex 1)**: stays at 1 (full)
- **Exhale (phaseIndex 2)**: `fillProgress` animates 1→0 (shrinks to center)
- **Rest after exhale (phaseIndex 3)**: stays at 0 (empty)

Uses `withSequence` with a 0ms snap followed by `withTiming` to avoid the double-assignment issue where a snap + animation in the same tick causes the snap to be lost.

### Animated Shadow

The square's shadow grows with the fill:
- `shadowOpacity`: 0 → 0.5 as fill increases
- `shadowRadius`: 10 → 35 as fill increases

### Visual Layers (bottom to top)

1. **Decorative circles** — two concentric circles (320px and 380px)
2. **Glow pulse** — pink background behind the square, opacity 0.15–0.3 (4s cycle)
3. **Square border** — 240x240px, 32px border-radius, 4px pink border, animated shadow
4. **Fill gradient** — pink → warm brown → amber, clipped inside the square via `overflow: hidden`
5. **Phase text** — "Inhale 4s" / "Hold 4s" / "Exhale 4s" / "Rest 4s", "Starting in Xs" during countdown, or "Listen" when inactive, with scale pulse
6. **Phase dots** — 4 dots below text, active dot is pink with glow (hidden during "Listen" and countdown)

### Text States

| State                          | Display            |
| ------------------------------ | ------------------ |
| Instruction playing            | "Listen"           |
| Countdown (3, 2, 1)           | "Starting in Xs"   |
| Exercise active                | "{Phase} {seconds}s" |

## Audio

### Instruction Audio

File: `src/assets/audio/practices/box-breathing-session/instructions.mp3`

| Event              | Trigger                                                    |
| ------------------ | ---------------------------------------------------------- |
| Initial play       | On mount (skipped if resuming a saved session)             |
| Instruction done   | Detected when `currentTime >= duration && !playing`        |
| Countdown start    | Immediately after instruction finishes (3s countdown)      |
| Session ready      | When countdown reaches 0                                   |

**Pause behavior:** Pausing the session pauses the instruction audio. Resuming continues from where it stopped.

### Phase Audio

| Phase   | File          | Trigger                        |
| ------- | ------------- | ------------------------------ |
| Inhale  | `inhale.mp3`  | `phaseIndex` changes to 0      |
| Hold    | `hold.mp3`    | `phaseIndex` changes to 1      |
| Exhale  | `exhale.mp3`  | `phaseIndex` changes to 2      |
| Rest    | `rest.mp3`    | `phaseIndex` changes to 3      |

Phase audio plays on every phase change (every 4 seconds). All phase players are paused when the session is paused.

### Tibetan Bowl Audio

File: `src/assets/audio/practices/box-breathing-session/tibetan-bowl.mp3`

- Plays at the start of each cycle (when `phaseIndex === 0`)
- Volume set to 0.3 (reduced to avoid overpowering phase cues)
- Seeked to 0 and played each cycle

### Completion Audio

`success-trumpets.mp3` plays on the Completion screen (shared with all practices).

## Playback Controls

### Backward (previous phase)

Jumps to the start of the **previous** phase by adding `timeIntoPhase + PHASE_DURATION` to `timeRemaining`. Clamped to `TOTAL_DURATION`. This triggers a `phaseIndex` change, which replays the phase audio.

### Forward (next phase)

Jumps to the start of the **next** phase by subtracting the remaining time in the current phase from `timeRemaining`. Clamped to 0.

### Skip/Restart

During the instruction phase, the restart button functions as a skip button (`skip-next` icon) and calls `skipToCountdown()` — stops instruction audio and triggers the 3-second countdown instead of jumping straight to the session. During the active session, it shows the `replay` icon and performs a full restart.

## Session Persistence

### Saving (on back navigation)

Uses Expo Router's `beforeRemove` navigation event. Only saves if `sessionReady` is true (instruction has finished and exercise has started):

```typescript
navigation.addListener('beforeRemove', () => {
  if (sessionReady && timeRemaining > 0) {
    setSession({ timeRemaining });
  }
});
```

### Restoring (on mount)

```typescript
const savedState = useAtomValue(boxBreathingSessionAtom);
const initialTimeRef = useRef(savedState?.timeRemaining ?? TOTAL_DURATION);
const [timeRemaining, setTimeRemaining] = useState(initialTimeRef.current);
```

When resuming, `instructionDone` and `sessionReady` are both initialized to `true`, so instruction audio is skipped and the exercise starts immediately.

### Clearing

Session state is cleared (`setSession(null)`) in two places:
1. **When `timeRemaining` reaches 0** — session finished, navigates to completion
2. **Intro screen "Restart Progress" button** — user explicitly resets

## Intro Screen Logic

| Saved state | Button text      | "Restart Progress" visible |
| ----------- | ---------------- | -------------------------- |
| `null`      | "Start"          | No                         |
| `!== null`  | "Resume Session" | Yes                        |

## Components

| Component       | File                                                    | Purpose                                      |
| --------------- | ------------------------------------------------------- | -------------------------------------------- |
| `BreathingBox`  | `src/modules/practices/components/BreathingBox.tsx`     | Animated square with fill, text, phase dots  |
| `GlowBg`        | `src/components/ui/GlowBg.tsx`                          | Radial gradient background                   |
| `BackButton`    | `src/components/ui/BackButton.tsx`                      | Close/back button                            |
| `GradientButton`| `src/components/ui/GradientButton.tsx`                  | Pink-to-yellow gradient CTA                  |

## File Map

| File                                                                | Role                                      |
| ------------------------------------------------------------------- | ----------------------------------------- |
| `src/app/practices/box-breathing-intro.tsx`                         | Route re-export                           |
| `src/app/practices/box-breathing-session.tsx`                       | Route re-export                           |
| `src/app/practices/completion.tsx`                                  | Route re-export                           |
| `src/modules/practices/screens/BoxBreathingIntro.tsx`               | Intro screen with start/resume/restart    |
| `src/modules/practices/screens/BoxBreathingSession.tsx`             | Session screen with timer, audio, square  |
| `src/modules/practices/screens/Completion.tsx`                      | Badge, rewards, trumpets, confetti        |
| `src/modules/practices/components/BreathingBox.tsx`                 | Square animation + fill + phase logic     |
| `src/modules/practices/store/box-breathing.ts`                      | `boxBreathingSessionAtom` (persisted)     |
| `src/assets/audio/practices/box-breathing-session/instructions.mp3` | Instruction narration audio               |
| `src/assets/audio/practices/box-breathing-session/inhale.mp3`       | Inhale phase audio cue                    |
| `src/assets/audio/practices/box-breathing-session/hold.mp3`         | Hold phase audio cue                      |
| `src/assets/audio/practices/box-breathing-session/exhale.mp3`       | Exhale phase audio cue                    |
| `src/assets/audio/practices/box-breathing-session/rest.mp3`         | Rest phase audio cue                      |
| `src/assets/audio/practices/box-breathing-session/tibetan-bowl.mp3` | Tibetan bowl cycle start audio            |
| `src/assets/audio/success-trumpets.mp3`                             | Completion celebration audio              |
