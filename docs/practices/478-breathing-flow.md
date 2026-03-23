# 4-7-8 Breathing Session — Technical Reference

## Overview

The 4-7-8 breathing exercise guides users through a 76-second breathing practice (4 cycles of 19 seconds each). An animated circle visualization with a GlowBg-style inner glow expands on inhale, holds during hold, and contracts on exhale. The progress ring fills each cycle and animates in reverse on cycle transitions. An instruction audio plays at the start, followed by a 3-second countdown before the breathing session begins. Phase audio cues (inhale, hold, exhale) and a tibetan bowl play at each transition. The session supports pause/resume, mute/unmute, restart (skips instruction), state persistence for mid-session exits, and a completion screen with rewards.

## Screen Sequence

| Screen     | Route                              | Component              | Purpose                                           |
| ---------- | ---------------------------------- | ---------------------- | ------------------------------------------------- |
| Intro      | `/practices/478-breathing-intro`   | `Breathing478Intro`    | Exercise overview, start/resume/restart            |
| Session    | `/practices/478-breathing-session` | `Breathing478Session`  | Timed breathing with circle animation, audio       |
| Completion | `/practices/completion`            | `Completion`           | Badge, D.O.S.E. rewards, trumpets, confetti        |

## State

### Session State (persisted to AsyncStorage via Jotai `atomWithStorage`)

| Atom                       | Type                                  | Default | Location                                         | Purpose                                         |
| -------------------------- | ------------------------------------- | ------- | ------------------------------------------------ | ------------------------------------------------ |
| `breathing478SessionAtom`  | `Breathing478SessionState \| null`    | `null`  | `src/modules/practices/store/478-breathing.ts`    | Saves time remaining on mid-session exit         |

```typescript
interface Breathing478SessionState {
  timeRemaining: number;
}
```

### Derived State (computed in Breathing478Session)

| Value             | Source                                        | Description                                            |
| ----------------- | --------------------------------------------- | ------------------------------------------------------ |
| `elapsed`         | `TOTAL_DURATION - timeRemaining`              | Seconds elapsed in the session                         |
| `phaseIndex`      | Derived from `elapsed % 19`                   | 0=inhale (0-4s), 1=hold (4-11s), 2=exhale (11-19s)   |
| `currentPhase`    | Phase text or instruction/countdown state     | "Inhale Deeply", "Hold Breath", "Exhale Slowly" (or "Listen" / countdown) |
| `isPaused`        | Local `useState`                              | Whether the timer, audio, and animation are paused     |
| `isMuted`         | Local `useState`                              | Whether all audio is muted (volumes set to 0)          |
| `instructionDone` | Detected from audio playback status           | Whether the intro audio has finished                   |
| `sessionReady`    | Set after countdown completes                 | Whether the breathing session timer is running         |
| `countdown`       | 3→2→1→0 after `instructionDone`               | Countdown before session starts                        |

## Breathing Timing

| Constant          | Value | Description                            |
| ----------------- | ----- | -------------------------------------- |
| `INHALE`          | 4s    | Inhale — glow expands                  |
| `HOLD`            | 7s    | Hold — glow stays expanded             |
| `EXHALE`          | 8s    | Exhale — glow contracts                |
| `CYCLE_DURATION`  | 19s   | One full breath cycle                  |
| `TOTAL_CYCLES`    | 4     | Number of cycles per session           |
| `TOTAL_DURATION`  | 76s   | Full session (4 cycles)                |

## Circle Animation (BreathingCircle478)

### Visual Structure (bottom to top in SVG)

1. **Breathing glow** — GlowBg-style circular glow (diagonal linear gradient pink→yellow, masked with radial fade), animated radius
2. **Track circle** — Faint white ring (`rgba(255,255,255,0.1)`) at radius 44
3. **Progress circle** — Pink→yellow gradient stroke, animated `strokeDashoffset`
4. **Center countdown** — Large phase countdown number + "Seconds" label (View overlay)

### Inner Glow Animation

The inner glow uses the same visual style as the `GlowBg` component — a diagonal linear gradient (`colors.primary.pink` at 20% opacity → `colors.accent.yellow` at 12% opacity) masked by a radial fade (solid center → transparent edge). The glow radius animates based on breathing phase:

- **Inhale (4s)**: Radius 24 → 36, easeInOut
- **Hold (7s)**: Holds at radius 36
- **Exhale (8s)**: Radius 36 → 24, easeInOut
- **Inactive**: Stays at radius 24 (no animation before session starts)

Animation is driven by `phaseIndex` prop changes (not per-second `elapsed` ticks) to avoid jerky restarts.

### Progress Ring Animation

The progress ring fills smoothly over each 19s cycle using animated `strokeDashoffset`. On cycle transitions:

- The ring animates to **full** (offset → 0) over 500ms with easeInOut
- Then resets to empty for the next cycle

This creates a "complete then reset" effect at each cycle boundary rather than an abrupt jump.

### Props

| Prop         | Type      | Default | Description                              |
| ------------ | --------- | ------- | ---------------------------------------- |
| `elapsed`    | `number`  | —       | Current elapsed seconds in session       |
| `isPaused`   | `boolean` | —       | Whether animation should pause           |
| `isActive`   | `boolean` | `true`  | Whether breathing animation should run   |
| `phaseIndex` | `number`  | `0`     | Current phase: 0=inhale, 1=hold, 2=exhale |

## Header

Simple layout matching Box Breathing:
- Back button (left)
- "4-7-8 Breathing" title (center)
- Spacer (right)

## Audio

### Instruction Audio

File: `src/assets/audio/practices/478-breathing-session/instructions.mp3`

| Event              | Trigger                                          |
| ------------------ | ------------------------------------------------ |
| Initial play       | On mount (`useEffect` with `player.play()`)      |
| Instruction done   | Detected when `status.currentTime >= status.duration && !status.playing` |

### Phase Audio

Files from `src/assets/audio/practices/common/`:
- `inhale.mp3` — plays at the start of each inhale phase
- `hold.mp3` — plays at the start of each hold phase
- `exhale.mp3` — plays at the start of each exhale phase

Phase audio is triggered by `phaseIndex` changes (derived from `elapsed % 19`). Only plays when `sessionReady && !isPaused`.

### Tibetan Bowl

File: `src/assets/audio/practices/common/tibetan-bowl.mp3`

Plays at the start of each cycle (when `phaseIndex === 0`), at 80% volume.

### Mute/Unmute

The mute button toggles `isMuted` state. When muted, all audio player volumes are set to 0. When unmuted, phase audio volumes restore to 1.0 and bowl to 0.8. Audio continues playing silently when muted (so phase transitions remain in sync).

### Countdown

After the instruction audio finishes, a 3-second countdown displays ("Starting in 3s", "Starting in 2s", "Starting in 1s") before `sessionReady` is set to `true`.

## Session Persistence

### Saving (on back navigation)

Uses Expo Router's `beforeRemove` navigation event. Only saves if `sessionReady && timeRemaining > 0`:

```typescript
navigation.addListener('beforeRemove', () => {
  if (sessionReady && timeRemaining > 0) {
    setSession({ timeRemaining });
  }
});
```

### Restoring (on mount)

When resuming, instruction audio and countdown are skipped — `instructionDone` and `sessionReady` init to `true`.

### Clearing

Session state cleared in two places:
1. **When `timeRemaining` reaches 0** — navigates to completion
2. **Intro screen "Restart Progress" button** — user explicitly resets

## Controls

| Button   | Icon          | Action                                              |
| -------- | ------------- | --------------------------------------------------- |
| Mute     | `volume-up` / `volume-off` | Toggle all audio volumes to 0 / restore  |
| Pause    | `pause` / `play-arrow`     | Pause/resume timer, audio, and animation |
| Restart  | `replay`      | Reset timer, skip instruction, start breathing immediately |

## Intro Screen Logic

| Saved state | Button text      | "Restart Progress" visible |
| ----------- | ---------------- | -------------------------- |
| `null`      | "Start"          | No                         |
| `!== null`  | "Resume Session" | Yes                        |

## Components

| Component            | File                                                       | Purpose                                         |
| -------------------- | ---------------------------------------------------------- | ----------------------------------------------- |
| `BreathingCircle478` | `src/modules/practices/components/BreathingCircle478.tsx`   | Animated glow + progress ring + countdown        |
| `GlowBg`            | `src/components/ui/GlowBg.tsx`                             | Radial gradient background (visual reference)    |
| `BackButton`         | `src/components/ui/BackButton.tsx`                         | Back button                                      |
| `GradientButton`     | `src/components/ui/GradientButton.tsx`                     | Pink-to-yellow gradient CTA                      |

## File Map

| File                                                                 | Role                                      |
| -------------------------------------------------------------------- | ----------------------------------------- |
| `src/app/practices/478-breathing-intro.tsx`                           | Route re-export                           |
| `src/app/practices/478-breathing-session.tsx`                         | Route re-export                           |
| `src/app/practices/completion.tsx`                                    | Route re-export                           |
| `src/modules/practices/screens/Breathing478Intro.tsx`                 | Intro screen with start/resume/restart    |
| `src/modules/practices/screens/Breathing478Session.tsx`               | Session screen with timer, audio, circle  |
| `src/modules/practices/screens/Completion.tsx`                        | Badge, rewards, trumpets, confetti        |
| `src/modules/practices/components/BreathingCircle478.tsx`             | Circle SVG + glow animation + countdown   |
| `src/modules/practices/store/478-breathing.ts`                        | `breathing478SessionAtom` (persisted)     |
| `src/assets/audio/practices/478-breathing-session/instructions.mp3`   | Instruction narration audio               |
| `src/assets/audio/practices/common/inhale.mp3`                       | Inhale phase audio cue                    |
| `src/assets/audio/practices/common/hold.mp3`                         | Hold phase audio cue                      |
| `src/assets/audio/practices/common/exhale.mp3`                       | Exhale phase audio cue                    |
| `src/assets/audio/practices/common/tibetan-bowl.mp3`                 | Tibetan bowl cycle marker                 |
