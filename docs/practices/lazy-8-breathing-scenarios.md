# Lazy 8 Breathing Session — User Scenarios

## Scenario 1: Fresh Start (No Saved Progress)

A user opens the lazy 8 breathing exercise for the first time (or after completing a previous session).

1. User navigates to the **Lazy 8 Breathing Intro** screen
2. Sees exercise overview with gradient infinity icon and description
3. "Start" button is shown
4. User taps "Start"
5. Session screen opens with instruction audio playing
6. Screen shows "Listen" with "Follow the guided instructions" below it
7. Infinity path is visible but the glowing orb is not moving yet
8. When audio finishes, countdown appears: "Starting in 3s", "Starting in 2s", "Starting in 1s"
9. Session begins — text switches to "Inhale", inhale audio plays, tibetan bowl sounds, and the orb begins tracing the infinity path
10. Timer counts down from 00:40
11. Phase audio (inhale/exhale) plays at each phase transition, tibetan bowl at each cycle start
12. When timer reaches 00:00, user is taken to the **Completion** screen

---

## Scenario 2: Completing the Exercise

A user finishes the full 40-second session.

1. Timer reaches 00:00
2. Saved progress is cleared
3. User is taken to the **Completion** screen
4. Confetti animation plays, trumpets sound
5. User sees "PRACTICE COMPLETED!" with the mandala badge
6. D.O.S.E. Rewards are shown with pulsing glow
7. User taps "Collect Rewards & Finish"
8. User is returned to the screen they came from
9. If user goes back to Lazy 8 Breathing Intro, they see "Start" (progress was cleared)

---

## Scenario 3: Pausing and Resuming Mid-Session

A user pauses the exercise during the session.

1. User is at 00:20 remaining, text shows "Exhale"
2. User taps "Pause Session"
3. Timer stops, orb freezes in place, phase audio stops
4. Button text changes to "Resume Session"
5. User taps "Resume Session"
6. Timer resumes, orb continues from the exact position, breathing text updates
7. Session continues normally

---

## Scenario 4: Leaving Mid-Session and Resuming Later

A user exits the session before completing it.

1. User is at 00:16 remaining
2. User taps the close button (X) in the header
3. Progress is automatically saved
4. User returns to the **Lazy 8 Breathing Intro** screen
5. Button now reads "Resume Session" and "Restart Progress" is visible below it
6. User taps "Resume Session"
7. Session picks up with the correct time remaining
8. Orb starts at the correct position along the infinity path
9. Intro audio is skipped — session starts immediately with breathing

---

## Scenario 5: Leaving During Instruction (No Save)

A user exits before the instruction audio finishes.

1. User opens the session, instruction audio starts playing
2. Screen shows "Listen" with "Follow the guided instructions" below it
3. Infinity path is visible but the orb is not moving yet
4. User taps the close button (X) before the audio finishes
5. User returns to the intro screen
6. No progress is saved — "Start" button is shown (not "Resume Session")
7. Starting again plays the instruction audio from the beginning

---

## Scenario 6: Restarting Progress

A user has saved progress but wants to start over.

1. User opens the **Lazy 8 Breathing Intro** screen and sees "Resume Session"
2. "Restart Progress" button is visible below the main button
3. User taps "Restart Progress"
4. Saved progress is cleared
5. "Restart Progress" button disappears
6. Button text changes back to "Start"
7. Tapping "Start" begins a fresh session with instruction audio

---

## Scenario 7: Breathing Phases

The glowing orb traces the infinity path in sync with the breathing instructions. Phase audio cues (inhale, exhale) play at each phase change. A tibetan bowl sounds at the start of each cycle.

1. "Inhale" (4s) — orb traces the right loop, inhale audio plays, tibetan bowl sounds
2. "Exhale" (4s) — orb traces the left loop, exhale audio plays
3. This repeats — 8 seconds per breath, 5 breaths per session (40s)

---

## Scenario 8: Muting Audio

A user wants to practice without sound.

1. User is in the session with audio playing
2. User taps the volume button (volume-up icon)
3. Icon changes to volume-off
4. All sounds go silent — no breathing cues, no tibetan bowl
5. The orb continues tracing the infinity path and phase text still updates
6. User taps the volume button again
7. Icon changes back to volume-up, sounds are audible again

---

## Scenario 9: Skipping the Instruction

A user taps the skip button during the instruction narration.

1. User opens the session and instruction audio begins playing
2. Screen shows "Listen" with the orb not yet moving
3. User taps the skip button (skip-next icon)
4. Narration stops
5. A 3-second countdown begins: "Starting in 3s", "Starting in 2s", "Starting in 1s"
6. Session starts normally — orb begins tracing the infinity path, breathing text appears

---

## Scenario 10: Restarting Mid-Session

A user taps the restart button during the breathing exercise.

1. User is at 00:16 remaining, orb is tracing the infinity path
2. User taps the restart button (replay icon)
3. Timer resets to full (00:40)
4. Animation restarts from the beginning
5. Breathing resumes immediately without instruction audio

---

## Edge Cases

### App goes to background during session

The timer and infinity animation both pause when the app is in the background. When the user returns, everything resumes from where it left off.

### Pausing during instruction audio

If the user pauses while the intro audio is playing, the audio pauses too. Resuming continues the audio from where it stopped. The breathing timer does not start until the intro audio finishes and the countdown completes.

### Resuming skips intro audio

When resuming a saved session, the intro instruction audio and countdown are skipped — the breathing animation starts immediately.

### Saved progress but user never returns

The saved progress stays until the user either resumes, restarts, or completes a new session. There is no expiration.

### Pressing back from the completion screen

The back button from the completion screen does not return to the session. It goes back to wherever the user was before starting the exercise.
