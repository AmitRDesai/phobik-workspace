# 4-7-8 Breathing Session — User Scenarios

## Scenario 1: Fresh Start (No Saved Progress)

A user opens the 4-7-8 breathing exercise for the first time (or after completing a previous session).

1. User navigates to the **4-7-8 Breathing Intro** screen
2. Sees exercise overview with gradient air icon and description
3. "Start" button is shown
4. User taps "Start"
5. Session screen opens with instruction audio playing
6. Screen shows "Listen" with "Follow the guided instructions" below it
7. Inner glow is visible at resting size but not animating yet
8. When audio finishes, countdown appears: "Starting in 3s", "Starting in 2s", "Starting in 1s"
9. Session begins — text switches to "Inhale Deeply", inhale audio plays, tibetan bowl sounds, and the inner glow begins expanding
10. Phase countdown shows seconds remaining in each phase
11. Phase audio (inhale/hold/exhale) plays at each phase transition, tibetan bowl at each cycle start
12. Progress ring fills over each 19s cycle, then animates to full and resets for the next cycle
13. When all 4 cycles complete (76s), user is taken to the **Completion** screen

---

## Scenario 2: Completing the Exercise

A user finishes the full 76-second session (4 cycles).

1. Final exhale phase ends
2. Saved progress is cleared
3. User is taken to the **Completion** screen
4. Confetti animation plays, trumpets sound
5. User sees "PRACTICE COMPLETED!" with the mandala badge
6. D.O.S.E. Rewards are shown with pulsing glow
7. User taps "Collect Rewards & Finish"
8. User is returned to the screen they came from
9. If user goes back to 4-7-8 Breathing Intro, they see "Start" (progress was cleared)

---

## Scenario 3: Pausing and Resuming Mid-Session

A user pauses the exercise during the session.

1. User is in the hold phase, countdown showing "05"
2. User taps the pause button (gradient circle)
3. Timer stops, inner glow freezes, phase audio stops
4. Pause icon changes to play icon
5. User taps play
6. Timer resumes, inner glow continues animating, breathing text updates
7. Session continues normally

---

## Scenario 4: Leaving Mid-Session and Resuming Later

A user exits the session before completing it.

1. User is in cycle 2
2. User taps the back button in the header
3. Progress is automatically saved
4. User returns to the **4-7-8 Breathing Intro** screen
5. Button now reads "Resume Session" and "Restart Progress" is visible below it
6. User taps "Resume Session"
7. Session picks up with the correct time remaining
8. Intro audio is skipped — session starts immediately with breathing

---

## Scenario 5: Leaving During Instruction (No Save)

A user exits before the instruction audio finishes.

1. User opens the session, instruction audio starts playing
2. Screen shows "Listen" with "Follow the guided instructions" below it
3. Inner glow is visible but not animating yet
4. User taps the back button before the audio finishes
5. User returns to the intro screen
6. No progress is saved — "Start" button is shown (not "Resume Session")
7. Starting again plays the instruction audio from the beginning

---

## Scenario 6: Restarting Progress

A user has saved progress but wants to start over.

1. User opens the **4-7-8 Breathing Intro** screen and sees "Resume Session"
2. "Restart Progress" button is visible below the main button
3. User taps "Restart Progress"
4. Saved progress is cleared
5. "Restart Progress" button disappears
6. Button text changes back to "Start"
7. Tapping "Start" begins a fresh session with instruction audio

---

## Scenario 7: Restarting Mid-Session

A user taps the restart button while the breathing exercise is already running.

1. User is in cycle 3
2. User taps the restart (replay) button
3. Timer resets to full duration (76s)
4. Instruction audio is skipped — breathing starts immediately
5. Text switches to "Inhale Deeply", inner glow begins expanding
6. Saved session state is cleared

---

## Scenario 8: Muting Audio

A user wants to practice without sound.

1. User is in the session with audio playing
2. User taps the volume button (volume-up icon)
3. Icon changes to volume-off
4. All audio continues playing silently (volumes set to 0)
5. Phase transitions still happen visually (glow animation, text changes, progress ring)
6. User taps volume button again
7. Icon changes back to volume-up, audio is audible again

---

## Scenario 9: Breathing Phases

The inner glow animates in sync with the breathing instructions. Phase audio cues (inhale, hold, exhale) play at each phase change. A tibetan bowl sounds at the start of each cycle.

1. "Inhale Deeply" (4s) — inner glow expands (r 24→36), inhale audio plays, tibetan bowl sounds
2. "Hold Breath" (7s) — inner glow stays expanded (r 36), hold audio plays
3. "Exhale Slowly" (8s) — inner glow contracts (r 36→24), exhale audio plays
4. Progress ring fills during each cycle, then animates to full and resets
5. This repeats — 19 seconds per breath, 4 breaths per session (76s)

---

## Scenario 10: Cycle Transition Animation

When a cycle completes and the next one begins:

1. Progress ring is nearly full at the end of exhale phase
2. Ring smoothly fills to 100% over 500ms
3. Ring resets to empty for the next cycle
4. Inner glow begins expanding again for the new inhale phase
5. Tibetan bowl sounds at the start of the new cycle

---

## Scenario 11: Skipping the Instruction

A user taps the skip button during the instruction narration.

1. User opens the session and instruction audio begins playing
2. Screen shows "Listen" with the inner glow at resting size
3. User taps the skip button (skip-next icon)
4. Narration stops
5. A 3-second countdown begins: "Starting in 3s", "Starting in 2s", "Starting in 1s"
6. Session starts normally — text switches to "Inhale Deeply", inner glow begins expanding

---

## Edge Cases

### App goes to background during session

The timer pauses when the app is in the background. When the user returns, everything resumes from where it left off.

### Pausing during instruction audio

If the user pauses while the intro audio is playing, the audio pauses too. Resuming continues the audio from where it stopped. The breathing timer does not start until the intro audio finishes and the countdown completes.

### Resuming skips intro audio

When resuming a saved session, the intro instruction audio and countdown are skipped — the breathing animation starts immediately.

### Muting during instruction

Muting during instruction audio sets the instruction player volume to 0. The audio continues playing silently and the instruction-done detection still fires when it reaches the end.

### Saved progress but user never returns

The saved progress stays until the user either resumes, restarts, or completes a new session. There is no expiration.

### Pressing back from the completion screen

The back button from the completion screen does not return to the session. It goes back to wherever the user was before starting the exercise.
