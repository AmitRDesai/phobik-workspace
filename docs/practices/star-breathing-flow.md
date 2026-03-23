# Star Breathing Session — Technical Reference

## Overview

The star breathing exercise guides users through a single star-trace breathing practice (~50 seconds). A glowing orb traces a five-pointed star while the user follows along: inhaling along an edge to a tip, holding at the tip, then exhaling to the next inner point. An instruction audio plays at the start, followed by a 3-second countdown before the breathing session begins. Phase audio cues (inhale, hold, exhale) play at each transition. The session supports pause/resume, mute/unmute, skip/restart controls, state persistence for mid-session exits, and a completion screen with rewards. The layout is scrollable with a fixed header, matching the Lazy 8 pattern.

## Screen Sequence

| Screen     | Route                               | Component               | Purpose                                           |
| ---------- | ----------------------------------- | ----------------------- | ------------------------------------------------- |
| Intro      | `/practices/star-breathing-intro`   | `StarBreathingIntro`    | Exercise overview, start/resume/restart            |
| Session    | `/practices/star-breathing-session` | `StarBreathingSession`  | Timed breathing with star animation, audio, HRV   |
| Completion | `/practices/completion`             | `Completion`            | Badge, D.O.S.E. rewards, trumpets, confetti        |

## State

### Session State (persisted to AsyncStorage via Jotai `atomWithStorage`)

| Atom                        | Type                                  | Default | Location                                        | Purpose                                         |
| --------------------------- | ------------------------------------- | ------- | ----------------------------------------------- | ------------------------------------------------ |
| `starBreathingSessionAtom`  | `StarBreathingSessionState \| null`   | `null`  | `src/modules/practices/store/star-breathing.ts`  | Saves time remaining on mid-session exit         |

```typescript
interface StarBreathingSessionState {
  timeRemaining: number;
}
```

### Derived State (computed in StarBreathingSession)

| Value             | Source                                  | Description                                            |
| ----------------- | --------------------------------------- | ------------------------------------------------------ |
| `elapsed`         | `TOTAL_DURATION - timeRemaining`        | Seconds elapsed in the session                         |
| `overallProgress` | `elapsed / TOTAL_DURATION`              | 0–1 value driving the gradient progress bar            |
| `currentPhase`    | `BreathingStar` `onPhaseChange` callback | "Inhale", "Hold", or "Exhale" (or "Listen" / countdown) |
| `isPaused`        | Local `useState`                        | Whether the timer, audio, and star animation are paused |
| `isMuted`         | Local `useState`                        | Whether all audio is muted (volumes set to 0)          |
| `restartKey`      | Local `useState`                        | Incremented on restart to remount BreathingStar        |
| `instructionDone` | Detected from audio playback status     | Whether the intro audio has finished                   |
| `sessionReady`    | Set after countdown completes           | Whether the breathing session timer is running         |
| `countdown`       | 3→2→1→0 after `instructionDone`         | Countdown before session starts                        |
| `phaseIndex`      | Derived from `elapsed % 10`             | 0=inhale (0-4s), 1=hold (4-6s), 2=exhale (6-10s)     |

## Breathing Timing

All timing is defined in `BreathingStar.tsx`:

| Constant          | Value | Description                            |
| ----------------- | ----- | -------------------------------------- |
| `INHALE_DURATION` | 4s    | Inhale — orb moves inner → tip         |
| `HOLD_DURATION`   | 2s    | Hold — orb stays at tip                |
| `EXHALE_DURATION` | 4s    | Exhale — orb moves tip → inner         |
| `CYCLE_DURATION`  | 10s   | One full breath cycle                  |
| `ORBIT_DURATION`  | 50s   | One full star trace (5 cycles)         |
| `TOTAL_DURATION`  | 50s   | Full session (one star trace)          |

### Phase Sync

The instruction text ("Inhale", "Hold", "Exhale") is derived from the star animation's Reanimated `elapsed` shared value — not from a separate JS timer. `BreathingStar` computes the phase on the UI thread via `useDerivedValue` and notifies the session screen through `onPhaseChange` (via `useAnimatedReaction` + `scheduleOnRN`). This guarantees the text always matches the orb position.

## Star Animation (BreathingStar)

### Geometry

The star has 10 vertices: 5 outer tips (even indices) and 5 inner points (odd indices), defined by the `VX`/`VY` arrays. The SVG path is rendered at 200x200 viewBox inside a 280x280 container.

### Orb Movement

A single `getOrbCoord` worklet computes the orb's position for both X and Y axes:

1. `elapsed % ORBIT_DURATION` → position within the current star trace
2. `Math.floor(orbitTime / CYCLE_DURATION)` → which of the 5 star edges
3. Within each cycle: eased interpolation between inner point → tip (inhale), hold at tip, then tip → next inner point (exhale)

### Visual Layers (bottom to top)

1. **Ghost track** — faint white star outline (`rgba(255,255,255,0.1)`)
2. **Gradient star** — pink-to-yellow gradient stroke
3. **Guide circles** — two concentric circles at r=45 and r=55
4. **Orb outer glow** — r=14, white at 8% opacity
5. **Orb inner glow** — r=9, pink at 25% opacity
6. **Breathing orb** — solid white, radius pulsates between 5–7.5 (1.5s cycle)
7. **BPM display** — centered heart icon + "72" (placeholder)

## Audio

### Instruction Audio

File: `src/assets/audio/practices/star-breathing-session/instructions.mp3`

**Playback timeline:**

| Event              | Trigger                                          |
| ------------------ | ------------------------------------------------ |
| Initial play       | On mount (`useEffect` with `player.play()`)      |
| Instruction done   | Detected when `status.currentTime > 0 && !status.playing` |

**Pause behavior:** During the initial instruction phase, pausing the session also pauses the audio.

### Phase Audio

Files from `src/assets/audio/practices/common/`:
- `inhale.mp3` — plays at the start of each inhale phase
- `hold.mp3` — plays at the start of each hold phase
- `exhale.mp3` — plays at the start of each exhale phase

Phase audio is triggered by `phaseIndex` changes (derived from `elapsed % 10`). Only plays when `sessionReady && !isPaused`. All phase audio is paused when the session is paused.

### Mute/Unmute

The mute button toggles `isMuted` state. When muted, all audio player volumes (instruction, inhale, hold, exhale) are set to 0. Audio continues playing silently so phase transitions stay in sync. When unmuted, volumes restore to their normal levels.

### Countdown

After the instruction audio finishes, a 3-second countdown displays ("Starting in 3s", "Starting in 2s", "Starting in 1s") before `sessionReady` is set to `true` and the breathing session begins.

### Completion Audio

`success-trumpets.mp3` plays on the Completion screen (shared with all practices).

## Controls

| Button       | Icon                           | Action                                                          |
| ------------ | ------------------------------ | --------------------------------------------------------------- |
| Mute         | `volume-up` / `volume-off`     | Toggle all audio volumes to 0 / restore                        |
| Pause        | `pause` / `play-arrow`         | Pause/resume timer, audio, and animation (solid white circle)  |
| Skip/Restart | `skip-next` / `replay`         | During instruction: skip to countdown. During session: full restart |

During instruction phase, the button shows `skip-next` and calls `skipToCountdown()` — stops instruction audio and triggers the 3-second countdown. During the active session, the button shows `replay` and performs a full restart: resets timer, remounts animation, skips to ready, clears saved state.

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
const savedState = useAtomValue(starBreathingSessionAtom);
const initialTimeRef = useRef(savedState?.timeRemaining ?? TOTAL_DURATION);
const [timeRemaining, setTimeRemaining] = useState(initialTimeRef.current);
```

When resuming, the star animation receives `initialElapsed` so the orb starts at the correct position along the star, matching where the timer left off.

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

| Component       | File                                                    | Purpose                                         |
| --------------- | ------------------------------------------------------- | ----------------------------------------------- |
| `BreathingStar` | `src/modules/practices/components/BreathingStar.tsx`     | Animated star SVG with orb, phase callback       |
| `GlowBg`        | `src/components/ui/GlowBg.tsx`                          | Radial gradient background                       |
| `BackButton`    | `src/components/ui/BackButton.tsx`                      | Close/back button                                |
| `GradientButton`| `src/components/ui/GradientButton.tsx`                  | Pink-to-yellow gradient CTA                      |

## File Map

| File                                                                | Role                                      |
| ------------------------------------------------------------------- | ----------------------------------------- |
| `src/app/practices/star-breathing-intro.tsx`                        | Route re-export                           |
| `src/app/practices/star-breathing-session.tsx`                      | Route re-export                           |
| `src/app/practices/completion.tsx`                                  | Route re-export                           |
| `src/modules/practices/screens/StarBreathingIntro.tsx`              | Intro screen with start/resume/restart    |
| `src/modules/practices/screens/StarBreathingSession.tsx`            | Session screen with timer, audio, star    |
| `src/modules/practices/screens/Completion.tsx`                      | Badge, rewards, trumpets, confetti        |
| `src/modules/practices/components/BreathingStar.tsx`                | Star SVG + orb animation + phase logic    |
| `src/modules/practices/store/star-breathing.ts`                     | `starBreathingSessionAtom` (persisted)    |
| `src/assets/audio/practices/star-breathing-session/instructions.mp3`| Instruction narration audio               |
| `src/assets/audio/practices/common/inhale.mp3`                     | Inhale phase audio cue                    |
| `src/assets/audio/practices/common/hold.mp3`                       | Hold phase audio cue                      |
| `src/assets/audio/practices/common/exhale.mp3`                     | Exhale phase audio cue                    |
| `src/assets/audio/success-trumpets.mp3`                             | Completion celebration audio              |
