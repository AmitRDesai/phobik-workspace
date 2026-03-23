# Star Breathing Session — User Scenarios

## Scenario 1: Fresh Start (No Saved Progress)

A user opens the star breathing exercise for the first time (or after completing a previous session).

1. User navigates to the **Star Breathing Intro** screen
2. Sees exercise overview with star icon and description
3. "Start" button is shown
4. User taps "Start"
5. Session screen opens with instruction audio playing
6. Screen shows "Listen" with "Follow the guided instructions" below it
7. Star is visible but the glowing dot is not moving yet
8. When audio finishes, countdown appears: "Starting in 3s", "Starting in 2s", "Starting in 1s"
9. Session begins — text switches to "Inhale", inhale audio plays, and the dot begins tracing the star
10. Timer counts down from 00:50
11. Phase audio (inhale/hold/exhale) plays at each phase transition
12. When timer reaches 00:00, user is taken to the **Completion** screen

---

## Scenario 2: Completing the Exercise

A user finishes the full 50-second session.

1. Timer reaches 00:00
2. Saved progress is cleared
3. User is taken to the **Completion** screen
4. Confetti animation plays, trumpets sound
5. User sees "PRACTICE COMPLETED!" with the mandala badge
6. D.O.S.E. Rewards are shown with pulsing glow
7. User taps "Collect Rewards & Finish"
8. User is returned to the screen they came from
9. If user goes back to Star Breathing Intro, they see "Start" (progress was cleared)

---

## Scenario 3: Pausing and Resuming Mid-Session

A user pauses the exercise during the session.

1. User is at 00:30 remaining, text shows "Hold"
2. User taps "Pause Session"
3. Timer stops, glowing dot freezes in place, phase audio stops
4. Button text changes to "Resume Session"
5. User taps "Resume Session"
6. Timer resumes, dot continues from the exact position, breathing text updates
7. Session continues normally

---

## Scenario 4: Leaving Mid-Session and Resuming Later

A user exits the session before completing it.

1. User is at 00:25 remaining
2. User taps the close button (X) in the header
3. Progress is automatically saved
4. User returns to the **Star Breathing Intro** screen
5. Button now reads "Resume Session" and "Restart Progress" is visible below it
6. User taps "Resume Session"
7. Session picks up with the correct time remaining
8. Glowing dot starts at the correct position along the star
9. Intro audio is skipped — session starts immediately with breathing

---

## Scenario 5: Leaving During Instruction (No Save)

A user exits before the instruction audio finishes.

1. User opens the session, instruction audio starts playing
2. Screen shows "Listen" with "Follow the guided instructions" below it
3. Star is visible but the glowing dot is not moving yet
4. User taps the close button (X) before the audio finishes
5. User returns to the intro screen
6. No progress is saved — "Start" button is shown (not "Resume Session")
7. Starting again plays the instruction audio from the beginning

---

## Scenario 6: Restarting Progress

A user has saved progress but wants to start over.

1. User opens the **Star Breathing Intro** screen and sees "Resume Session"
2. "Restart Progress" button is visible below the main button
3. User taps "Restart Progress"
4. Saved progress is cleared
5. "Restart Progress" button disappears
6. Button text changes back to "Start"
7. Tapping "Start" begins a fresh session with instruction audio

---

## Scenario 7: Breathing Phases

The glowing dot traces the star in sync with the breathing instructions. Phase audio cues (inhale, hold, exhale) play at each phase change.

1. "Inhale" (4s) — dot moves from an inner point to a star tip, inhale audio plays
2. "Hold" (2s) — dot stays at the tip, hold audio plays
3. "Exhale" (4s) — dot moves from the tip to the next inner point, exhale audio plays
4. This repeats — 10 seconds per breath, 5 breaths per full star (50s)
5. The star is traced 1 time during the session

---

## Edge Cases

### App goes to background during session

The timer and star animation both pause when the app is in the background. When the user returns, everything resumes from where it left off.

### Pausing during instruction audio

If the user pauses while the intro audio is playing, the audio pauses too. Resuming continues the audio from where it stopped. The breathing timer does not start until the intro audio finishes and the countdown completes.

### Resuming plays intro audio

When resuming a saved session, the intro instruction audio and countdown are skipped — the breathing animation starts immediately.

### Saved progress but user never returns

The saved progress stays until the user either resumes, restarts, or completes a new session. There is no expiration.

### Pressing back from the completion screen

The back button from the completion screen does not return to the session. It goes back to wherever the user was before starting the exercise.
