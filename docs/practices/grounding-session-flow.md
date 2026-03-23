# Grounding Session (5-4-3-2-1) — Technical Reference

## Overview

The grounding exercise guides users through the 5-4-3-2-1 technique: identifying things they can see (5), feel (4), hear (3), smell (2), and taste (1). Each step plays a narration audio file and runs a timed countdown. The session supports pause/resume, state persistence for mid-session exits, and a completion screen with rewards.

## Screen Sequence

| Screen           | Route                          | Component              | Purpose                                        |
| ---------------- | ------------------------------ | ---------------------- | ---------------------------------------------- |
| Intro            | `/practices/grounding-intro`   | `GroundingIntro`       | Exercise overview, sense cards, start/resume    |
| Session          | `/practices/grounding-session` | `GroundingSession`     | Timed steps with audio, visualizer, progress    |
| Completion       | `/practices/completion`        | `Completion`           | Badge, D.O.S.E. rewards, trumpets, confetti     |

## State

### Session State (persisted to AsyncStorage via Jotai `atomWithStorage`)

| Atom                   | Type                             | Default | Location                                     | Purpose                                              |
| ---------------------- | -------------------------------- | ------- | -------------------------------------------- | ---------------------------------------------------- |
| `groundingSessionAtom` | `GroundingSessionState \| null`  | `null`  | `src/modules/practices/store/grounding.ts`   | Saves step index + time remaining on mid-session exit |

```typescript
interface GroundingSessionState {
  currentStepIndex: number;
  timeRemaining: number;
}
```

### Derived State (computed in GroundingSession)

| Value             | Source                              | Description                                   |
| ----------------- | ----------------------------------- | --------------------------------------------- |
| `currentStepIndex`| Computed from `elapsedInTotal`      | Which of the 5 steps the user is on           |
| `timeRemaining`   | Countdown from `TOTAL_DURATION`     | Seconds left in the entire session            |
| `progress`        | `elapsedInTotal / TOTAL_DURATION`   | 0–1 value driving the `ProgressRing`          |
| `isPaused`        | Local `useState`                    | Whether the timer and audio are paused        |

## Steps Configuration

Each step has a fixed duration. The total session is 120 seconds.

| Step | Count | Sense | Duration |
| ---- | ----- | ----- | -------- |
| 1    | 5     | See   | 24s      |
| 2    | 4     | Feel  | 24s      |
| 3    | 3     | Hear  | 24s      |
| 4    | 2     | Smell | 24s      |
| 5    | 1     | Taste | 24s      |

Step advancement is computed from elapsed time, not from audio completion. Each step's audio file is shorter than its duration to leave time for the user to practice.

## Audio

### Library

Uses `expo-audio` (not `expo-av`). Installed as an Expo SDK 54 compatible module.

| Hook/API                   | Purpose                                          |
| -------------------------- | ------------------------------------------------ |
| `useAudioPlayer(source)`   | Creates a player that auto-disposes on unmount   |
| `useAudioPlayerStatus(p)`  | Reactive `playing`, `currentTime`, `duration`    |
| `player.replace(source)`   | Switches audio source without recreating player  |
| `player.play() / pause()`  | Playback control                                 |

### Audio Files

Located at `src/assets/audio/practices/grounding-session/`:

| File    | Step | Narration                      |
| ------- | ---- | ------------------------------ |
| `5.mp3` | 5    | "Identify 5 things you can see" |
| `4.mp3` | 4    | "Identify 4 things you can feel" |
| `3.mp3` | 3    | "Identify 3 things you can hear" |
| `2.mp3` | 2    | "Identify 2 things you can smell" |
| `1.mp3` | 1    | "Identify 1 thing you can taste" |

The player is created with `updateInterval: 100` for smooth visualizer updates. On step change, `player.replace()` switches to the new audio file.

### Audio Visualizer

The `AudioVisualizer` component displays 6 gradient bars that animate based on audio playback.

**Data source:** `useAudioPlayerStatus` provides reactive `currentTime` and `playing` state. Amplitude levels are generated from the playback position using offset sine waves (one per bar), creating varied patterns that change as audio progresses.

```typescript
const audioLevels = useMemo(() => {
  if (!status.playing) return null;
  const t = status.currentTime;
  return Array.from({ length: 6 }, (_, i) => {
    const v = Math.abs(Math.sin(t * (3 + i * 1.7) + i * 2.1));
    return v * 0.6 + 0.15;
  });
}, [status.playing, status.currentTime]);
```

**Behavior:**
- Audio playing: bars animate to computed levels (smooth `withTiming` transitions)
- Audio finished or paused: bars collapse to minimum height
- The component also accepts a `levels` prop for real PCM data if `useAudioSampleListener` becomes available (requires custom dev client, not supported in Expo Go)

### Completion Audio

`success-trumpets.mp3` plays on mount via `useAudioPlayer`. The player auto-disposes on unmount.

### Config Plugin

```json
["expo-audio", { "recordAudioAndroid": false }]
```

Recording permission is disabled since `useAudioSampleListener` is not used in production.

## Session Persistence

### Saving (on back navigation)

Uses Expo Router's `beforeRemove` navigation event:

```typescript
navigation.addListener('beforeRemove', () => {
  if (timeRemaining > 0) {
    setGroundingSession({ currentStepIndex, timeRemaining });
  }
});
```

### Restoring (on mount)

```typescript
const savedState = useAtomValue(groundingSessionAtom);
const initialTimeRef = useRef(savedState?.timeRemaining ?? TOTAL_DURATION);
const [timeRemaining, setTimeRemaining] = useState(initialTimeRef.current);
```

The step index is derived from elapsed time, so only `timeRemaining` needs to be restored.

### Completion Navigation

When `timeRemaining` reaches 0, a `useEffect` clears the session state and navigates to the completion screen via `router.replace('/practices/completion')`. This matches the pattern used by `useSessionTimer` in other exercises, keeping the navigation outside of the `setTimeRemaining` updater to avoid React "setState during render" warnings.

### Clearing

Session state is cleared (`setGroundingSession(null)`) in two places:
1. **Completion screen mount** — session finished successfully
2. **Intro screen "Restart Progress" button** — user explicitly resets

## Intro Screen Logic

| Saved state | Button text       | "Restart Progress" visible |
| ----------- | ----------------- | -------------------------- |
| `null`      | "Start Session"   | No                         |
| `!== null`  | "Resume Session"  | Yes                        |

"Restart Progress" calls `setGroundingSession(null)`, which hides the button and reverts the CTA text.

## Completion Screen

### Layout
- Close button: absolutely positioned (`absolute right-6 top-16 z-20`)
- CompletionBadge: dashed orbit ring (180px) inside 200px container to prevent clipping
- D.O.S.E. Rewards: two reward circles (Endorphins +10, Serotonin +5) with pulsing glow animations
- CTA: "Collect Rewards & Finish" (calls `router.dismissAll()`)

### On Mount
1. Plays `success-trumpets.mp3`
2. Clears `groundingSessionAtom` so intro shows "Start Session" on return
3. Confetti animation (24 pieces, 2.8s duration)

## Components

| Component          | File                                              | Purpose                                       |
| ------------------ | ------------------------------------------------- | --------------------------------------------- |
| `AudioVisualizer`  | `src/modules/practices/components/AudioVisualizer.tsx`  | 6 gradient bars driven by playback state |
| `ProgressRing`     | `src/modules/practices/components/ProgressRing.tsx`     | Circular progress indicator              |
| `HeartRateBadge`   | `src/modules/practices/components/HeartRateBadge.tsx`   | Heart rate display badge                 |
| `CompletionBadge`  | `src/modules/practices/components/CompletionBadge.tsx`  | Mandala with gradient checkmark          |
| `SenseCard`        | `src/modules/practices/components/SenseCard.tsx`        | Sense step card for intro screen         |
| `PulsingGlow`      | Inline in `Completion.tsx`                              | Animated glow behind reward circles      |
| `RewardCircle`     | Inline in `Completion.tsx`                              | D.O.S.E. reward with gradient + shadow   |
| `Confetti`         | Inline in `Completion.tsx`                              | 24-piece falling confetti animation      |

## File Map

| File                                                      | Role                                                  |
| --------------------------------------------------------- | ----------------------------------------------------- |
| `src/app/practices/grounding-intro.tsx`                   | Route re-export                                       |
| `src/app/practices/grounding-session.tsx`                 | Route re-export                                       |
| `src/app/practices/completion.tsx`                        | Route re-export                                       |
| `src/modules/practices/screens/GroundingIntro.tsx`        | Intro screen with sense cards and resume/restart logic |
| `src/modules/practices/screens/GroundingSession.tsx`      | Timed session with audio, visualizer, state save       |
| `src/modules/practices/screens/Completion.tsx`            | Badge, rewards, trumpets, confetti, state clear        |
| `src/modules/practices/store/grounding.ts`                | `groundingSessionAtom` (persisted)                    |
| `src/modules/practices/components/AudioVisualizer.tsx`    | Gradient bar visualizer                               |
| `src/modules/practices/components/CompletionBadge.tsx`    | Mandala badge with dashed orbit ring                  |
| `src/assets/audio/practices/grounding-session/1-5.mp3`   | Narration audio per step                              |
| `src/assets/audio/success-trumpets.mp3`                   | Completion celebration audio                          |
