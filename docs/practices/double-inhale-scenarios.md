# Double Inhale Breathing Session — User Scenarios

## Scenario 1: Fresh Start (No Saved Progress)

A user opens the double inhale breathing exercise for the first time (or after completing a previous session).

1. User navigates to the **Double Inhale Intro** screen
2. Sees exercise description with a gradient icon
3. "Start" button is shown
4. User taps "Start"
5. Session screen opens with instruction audio playing
6. The orb is visible at resting size, text shows "Listen" — no animation
7. When audio finishes, a 3-second countdown begins: "Starting in 3s", "Starting in 2s", "Starting in 1s"
8. The orb begins expanding, text switches to "Deep Inhale"
9. Tibetan bowl plays at the start of the first cycle
10. Inhale audio plays on the first inhale; no audio on second inhale; exhale audio plays on exhale
11. Phase progress bars highlight the current phase
12. When all 3 cycles complete (30s), user is taken to the **Completion** screen

---

## Scenario 2: Completing the Exercise

A user finishes the full 30-second session (3 cycles).

1. Final exhale phase ends
2. Saved progress is cleared
3. User is taken to the **Completion** screen
4. Confetti animation plays, trumpets sound
5. User sees "PRACTICE COMPLETED!" with the mandala badge
6. D.O.S.E. Rewards are shown with pulsing glow
7. User taps "Collect Rewards & Finish"
8. User is returned to the screen they came from
9. If user goes back to Double Inhale Intro, they see "Start" (progress was cleared)

---

## Scenario 3: Pausing and Resuming Mid-Session

A user pauses the exercise during the session.

1. User is in the second inhale phase, orb expanding
2. User taps the pause button (solid white circle at the bottom)
3. Timer stops, orb animation resets to resting size, phase audio stops
4. Pause icon changes to a play icon
5. User taps the play button
6. Timer resumes, orb animation restarts, breathing text updates
7. Session continues normally

---

## Scenario 4: Leaving Mid-Session and Resuming Later

A user exits the session before completing it.

1. User is in cycle 2
2. User taps the close button in the header
3. Progress is automatically saved
4. User returns to the **Double Inhale Intro** screen
5. Button now reads "Resume Session" and "Restart Progress" is visible below it
6. User taps "Resume Session"
7. Session picks up with the correct time remaining
8. Instruction audio is skipped — exercise starts immediately

---

## Scenario 5: Leaving During Instruction (No Save)

A user exits before the instruction audio finishes.

1. User opens the session, instruction audio starts playing
2. Text shows "Listen" with "Follow the guided instructions" below it
3. Breathing orb is visible but not animating
4. User taps the close button before the audio finishes
5. User returns to the intro screen
6. No progress is saved — "Start" button is shown (not "Resume Session")
7. Starting again plays the instruction audio from the beginning

---

## Scenario 6: Restarting Progress

A user has saved progress but wants to start over.

1. User opens the **Double Inhale Intro** screen and sees "Resume Session"
2. "Restart Progress" button is visible below the main button
3. User taps "Restart Progress"
4. Saved progress is cleared
5. "Restart Progress" button disappears
6. Button text changes back to "Start"
7. Tapping "Start" begins a fresh session with instruction audio

---

## Scenario 7: Breathing Phase Cycle

The orb animates in sync with the breathing instructions.

1. "Deep Inhale" (2s) — orb expands to 1.15, inhale audio plays, tibetan bowl sounds
2. "Second Inhale" (2s) — orb expands further to 1.3, no audio cue
3. "Long Exhale" (6s) — orb contracts to 1.0, exhale audio plays
4. Three progress bars below the text show which phase is active (pink with glow)
5. Step text shows "Step X of 3: {label}"
6. This repeats — 10 seconds per cycle, 3 cycles total (30 seconds)
7. Tibetan bowl plays at the start of each cycle (every 10 seconds)

---

## Scenario 8: Restarting Mid-Session

A user taps the restart button while the breathing exercise is already running.

1. User is in cycle 2
2. User taps the restart (replay) button
3. Timer resets to full duration (30s)
4. Instruction audio is skipped — breathing starts immediately
5. Text switches to "Deep Inhale", orb begins expanding
6. Saved session state is cleared

---

## Scenario 9: Muting Audio

A user wants to practice without sound.

1. User is in the session with audio playing
2. User taps the volume button (volume-up icon)
3. Icon changes to volume-off
4. All audio continues playing silently (volumes set to 0)
5. Phase transitions still happen visually (orb animation, text changes, progress bars)
6. User taps volume button again
7. Icon changes back to volume-up, audio is audible again

---

## Scenario 10: Countdown After Instruction

After the instruction audio finishes, a 3-second countdown plays before the exercise begins.

1. Instruction audio finishes playing
2. Phase text changes from "Listen" to "Starting in 3s"
3. Subtext changes from "Follow the guided instructions" to "Get ready..."
4. After 1 second: "Starting in 2s"
5. After 2 seconds: "Starting in 1s"
6. After 3 seconds: exercise begins with "Deep Inhale"

---

## Scenario 11: Skipping the Instruction

A user taps the skip button during the instruction narration.

1. User opens the session and instruction audio begins playing
2. Text shows "Listen" with the orb at resting size
3. User taps the skip button (skip-next icon)
4. Narration stops
5. A 3-second countdown begins: "Starting in 3s", "Starting in 2s", "Starting in 1s"
6. Session starts normally — text switches to "Deep Inhale", orb begins expanding

---

## Edge Cases

### App goes to background during session

The timer and animation both pause when the app is in the background. When the user returns, everything resumes from where it left off.

### Pausing during instruction audio

If the user pauses while the intro audio is playing, the audio pauses too. Resuming continues the audio from where it stopped. The exercise does not start until the intro audio finishes and the countdown completes.

### Resuming skips instruction audio

When resuming a saved session, the instruction audio and countdown are both skipped and the exercise starts immediately with phase audio cues.

### Muting during instruction

Muting during instruction audio sets the instruction player volume to 0. The audio continues playing silently and the instruction-done detection still fires when it reaches the end.

### Saved progress but user never returns

The saved progress stays until the user either resumes, restarts, or completes a new session. There is no expiration.

### Pressing back from the completion screen

The back button from the completion screen does not return to the session. It goes back to wherever the user was before starting the exercise.
