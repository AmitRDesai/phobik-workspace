# Double Inhale Breathing Session — Technical Reference

## Overview

The double inhale breathing exercise guides users through a 30-second breathing practice (3 cycles of 10 seconds each). The pattern is: deep inhale for 2 seconds, second inhale for 2 seconds, long exhale for 6 seconds. An animated orb with concentric pulse rings expands in two stages on the inhales and contracts on the exhale. The session runs for exactly 3 cycles (30 seconds) with instruction audio at the start, a 3-second countdown, per-phase audio cues (inhale on first inhale only, exhale on exhale), a tibetan bowl at each cycle start, controls (mute, pause, restart), session persistence, and a completion screen with rewards.

## Screen Sequence

| Screen     | Route                                | Component               | Purpose                                           |
| ---------- | ------------------------------------ | ----------------------- | ------------------------------------------------- |
| Intro      | `/practices/double-inhale-intro`     | `DoubleInhaleIntro`     | Exercise overview, start/resume/restart            |
| Session    | `/practices/double-inhale-session`   | `DoubleInhaleSession`   | Timed breathing with orb animation, audio          |
| Completion | `/practices/completion`              | `Completion`            | Badge, D.O.S.E. rewards, trumpets, confetti        |

## State

### Session State (persisted to AsyncStorage via Jotai `atomWithStorage`)

| Atom                        | Type                                   | Default | Location                                           | Purpose                                    |
| --------------------------- | -------------------------------------- | ------- | -------------------------------------------------- | ------------------------------------------ |
| `doubleInhaleSessionAtom`   | `DoubleInhaleSessionState \| null`     | `null`  | `src/modules/practices/store/double-inhale.ts`      | Saves time remaining on mid-session exit   |

```typescript
interface DoubleInhaleSessionState {
  timeRemaining: number;
}
```

### Local State (in DoubleInhaleSession)

| Value             | Source                                     | Description                                           |
| ----------------- | ------------------------------------------ | ----------------------------------------------------- |
| `timeRemaining`   | `useState`, decremented via `setInterval`  | Seconds left in the session (counts down from 30)     |
| `elapsed`         | `TOTAL_DURATION - timeRemaining`           | Seconds elapsed since session start                   |
| `isPaused`        | Local `useState`                           | Whether the timer, audio, and animation are paused    |
| `isMuted`         | Local `useState`                           | Whether all audio is muted (volumes set to 0)         |
| `instructionDone` | Detected from audio playback status        | Whether the intro audio has finished                  |
| `countdown`       | 3-second countdown after instruction ends  | Counts 3 → 2 → 1 → 0, then session starts            |
| `sessionReady`    | Set when countdown reaches 0               | Whether the exercise has started (gate for timer/audio) |
| `phaseIndex`      | Derived from `elapsed % 10` with accumulation | 0=first inhale, 1=second inhale, 2=exhale          |

## Breathing Timing

| Constant          | Value     | Description                        |
| ----------------- | --------- | ---------------------------------- |
| `PHASE_DURATIONS` | [2, 2, 6] | Seconds per phase                 |
| `PHASE_TOTAL`     | 10s       | One full breath cycle              |
| `TOTAL_CYCLES`    | 3         | Number of cycles per session       |
| `TOTAL_DURATION`  | 30s       | Full session (3 cycles)            |

### Phases

```
Deep Inhale (2s) → Second Inhale (2s) → Long Exhale (6s) → repeat
```

Phases are derived from elapsed time using accumulated durations — not simple division like box breathing, since phases have different lengths.

## Orb Animation (inline in DoubleInhaleSession)

### Visual Layers (bottom to top)

1. **Outer pulse ring** — SVG circle (280px) with gradient stroke (pink→yellow), animated opacity (0.05–0.2)
2. **Inner pulse ring** — SVG circle (220px) with gradient stroke (pink→yellow), animated opacity (0.1–0.35)
3. **Decorative wave** — SVG path overlay at 30% opacity
4. **Main breathing orb** — LinearGradient circle (112px) with "air" icon, animated scale

### Scale Animation

The breathing orb uses `withRepeat` + `withSequence` with Reanimated:

- **First inhale (2s)**: Scale 1.0 → 1.15, easeInOut
- **Second inhale (2s)**: Scale 1.15 → 1.3, easeInOut
- **Exhale (6s)**: Scale 1.3 → 1.0, easeInOut

Animation is gated behind `sessionReady` — does not run during instruction/countdown. Resets to base values when paused or not ready.

### Phase Text States

| State                | Phase text          | Subtext                                                |
| -------------------- | ------------------- | ------------------------------------------------------ |
| Instruction playing  | "Listen"            | "Follow the guided instructions"                       |
| Countdown (3, 2, 1)  | "Starting in Xs"    | "Get ready..."                                         |
| Phase 0              | "Deep Inhale"       | "Expanding your lungs with a deep breath in."          |
| Phase 1              | "Second Inhale"     | "Filling your lungs completely with a second breath."  |
| Phase 2              | "Long Exhale"       | "Releasing all tension slowly through your mouth."     |

Subtext is wrapped in a fixed-height container (36px) to prevent layout shifts when text length changes.

### Phase Progress

Three progress bars below the phase text indicate the current phase. Each bar's width is proportional to the phase duration (40px for 2s phases, 56px for 6s exhale). The active bar is pink with a glow shadow.

Step text below shows "Step X of 3: {label}" where labels are "Expanding Lungs", "Filling Completely", "Releasing Tension".

## Audio

### Instruction Audio

File: `src/assets/audio/practices/double-inhale-session/instructions.mp3`

| Event              | Trigger                                                    |
| ------------------ | ---------------------------------------------------------- |
| Initial play       | On mount (skipped if resuming a saved session)             |
| Instruction done   | Detected when `currentTime >= duration && !playing`        |
| Countdown start    | Immediately after instruction finishes (3s countdown)      |
| Session ready      | When countdown reaches 0                                   |

**Pause behavior:** Pausing the session pauses the instruction audio. Resuming continues from where it stopped.

### Phase Audio

| Phase          | File          | Trigger                        |
| -------------- | ------------- | ------------------------------ |
| Deep Inhale    | `inhale.mp3`  | `phaseIndex` changes to 0      |
| Second Inhale  | —             | No audio cue                   |
| Long Exhale    | `exhale.mp3`  | `phaseIndex` changes to 2      |

Inhale audio plays only on the first inhale (phase 0). The second inhale (phase 1) has no audio cue — the user continues inhaling from the first phase. All phase players are paused when the session is paused.

### Tibetan Bowl Audio

File: `src/assets/audio/practices/common/tibetan-bowl.mp3`

- Plays at the start of each cycle (when `phaseIndex === 0`)
- Volume set to 0.8
- Seeked to 0 and played each cycle

### Mute/Unmute

The mute button toggles `isMuted` state. When muted, all audio player volumes are set to 0. When unmuted, phase audio volumes restore to 1.0 and bowl to 0.8. Audio continues playing silently when muted (so phase transitions remain in sync).

### Completion Audio

`success-trumpets.mp3` plays on the Completion screen (shared with all practices).

## Controls

| Button   | Icon                           | Action                                                     |
| -------- | ------------------------------ | ---------------------------------------------------------- |
| Mute     | `volume-up` / `volume-off`     | Toggle all audio volumes to 0 / restore                    |
| Pause    | `pause` / `play-arrow`         | Pause/resume timer, audio, and animation (solid white circle) |
| Restart  | `replay`                       | Reset timer, skip instruction, start breathing immediately |

Mute and restart buttons use glass style (border-white/[0.08], bg-white/[0.04], 56px circle). The pause/play button is a solid white 80px circle with a dark icon and pink shadow glow.

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
const savedState = useAtomValue(doubleInhaleSessionAtom);
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

| Component        | File                                                    | Purpose                                      |
| ---------------- | ------------------------------------------------------- | -------------------------------------------- |
| `GlowBg`         | `src/components/ui/GlowBg.tsx`                          | Radial gradient background                   |
| `BackButton`     | `src/components/ui/BackButton.tsx`                      | Close/back button                            |
| `GradientButton` | `src/components/ui/GradientButton.tsx`                  | Pink-to-yellow gradient CTA                  |

## File Map

| File                                                                    | Role                                      |
| ----------------------------------------------------------------------- | ----------------------------------------- |
| `src/app/practices/double-inhale-intro.tsx`                              | Route re-export                           |
| `src/app/practices/double-inhale-session.tsx`                            | Route re-export                           |
| `src/app/practices/completion.tsx`                                       | Route re-export                           |
| `src/modules/practices/screens/DoubleInhaleIntro.tsx`                    | Intro screen with start/resume/restart    |
| `src/modules/practices/screens/DoubleInhaleSession.tsx`                  | Session screen with timer, audio, orb     |
| `src/modules/practices/screens/Completion.tsx`                           | Badge, rewards, trumpets, confetti        |
| `src/modules/practices/store/double-inhale.ts`                           | `doubleInhaleSessionAtom` (persisted)     |
| `src/assets/audio/practices/double-inhale-session/instructions.mp3`      | Instruction narration audio               |
| `src/assets/audio/practices/common/inhale.mp3`                          | Inhale phase audio cue                    |
| `src/assets/audio/practices/common/exhale.mp3`                          | Exhale phase audio cue                    |
| `src/assets/audio/practices/common/tibetan-bowl.mp3`                    | Tibetan bowl cycle marker                 |
