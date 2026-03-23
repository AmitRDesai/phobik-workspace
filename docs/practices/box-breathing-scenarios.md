# Box Breathing Session — User Scenarios

## Scenario 1: Fresh Start (No Saved Progress)

A user opens the box breathing exercise for the first time (or after completing a previous session).

1. User navigates to the **Box Breathing Intro** screen
2. Sees exercise description with a gradient icon
3. "Start" button is shown
4. User taps "Start"
5. Session screen opens with instruction audio playing
6. The square shows "Listen" — no animation, no countdown
7. When audio finishes, a 3-second countdown begins: "Starting in 3s", "Starting in 2s", "Starting in 1s"
8. The square switches to "Inhale 4s" and the fill animation begins
9. Tibetan bowl plays softly at the start of the first cycle
10. Audio cues play for each phase (inhale, hold, exhale, rest)
11. Timer counts up from 00:00 toward the 01:20 goal
12. When the timer reaches 01:20 (5 cycles), user is taken to the **Completion** screen

---

## Scenario 2: Completing the Exercise

A user finishes the full 80-second session (5 cycles).

1. Timer reaches 01:20
2. Saved progress is cleared
3. User is taken to the **Completion** screen
4. Confetti animation plays, trumpets sound
5. User sees "PRACTICE COMPLETED!" with the mandala badge
6. D.O.S.E. Rewards are shown with pulsing glow
7. User taps "Collect Rewards & Finish"
8. User is returned to the screen they came from
9. If user goes back to Box Breathing Intro, they see "Start" (progress was cleared)

---

## Scenario 3: Pausing and Resuming Mid-Session

A user pauses the exercise during the session.

1. User is at 00:36, square shows "Hold 2s"
2. User taps the pause button (gradient circle at the bottom)
3. Timer stops, square fill freezes, phase audio stops, tibetan bowl stops
4. Pause icon changes to a play icon
5. User taps the play button
6. Timer resumes, fill animation continues, phase audio plays
7. Session continues normally

---

## Scenario 4: Leaving Mid-Session and Resuming Later

A user exits the session before completing it.

1. User is at 00:48 completed
2. User taps the back button in the header
3. Progress is automatically saved
4. User returns to the **Box Breathing Intro** screen
5. Button now reads "Resume Session" and "Restart Progress" is visible below it
6. User taps "Resume Session"
7. Session picks up with the correct time remaining
8. Instruction audio is skipped — exercise starts immediately
9. Square animation resumes from the correct phase

---

## Scenario 5: Leaving During Instruction (No Save)

A user exits before the instruction audio finishes.

1. User opens the session, instruction audio starts playing
2. Square shows "Listen"
3. User taps the back button before the audio finishes
4. User returns to the intro screen
5. No progress is saved — "Start" button is shown (not "Resume Session")
6. Starting again plays the instruction audio from the beginning

---

## Scenario 6: Restarting Progress

A user has saved progress but wants to start over.

1. User opens the **Box Breathing Intro** screen and sees "Resume Session"
2. "Restart Progress" button is visible below the main button
3. User taps "Restart Progress"
4. Saved progress is cleared
5. "Restart Progress" button disappears
6. Button text changes back to "Start"
7. Tapping "Start" begins a fresh session with instruction audio

---

## Scenario 7: Breathing Phase Cycle

The square fills and empties in sync with the breathing instructions.

1. "Inhale 4s" — square fills from the center with a warm gradient, countdown 4→1
2. "Hold 4s" — square stays full, countdown 4→1
3. "Exhale 4s" — square empties back to the center, countdown 4→1
4. "Rest 4s" — square stays empty, countdown 4→1
5. Four dots below the text show which phase is active (pink dot with glow)
6. This repeats — 16 seconds per cycle, 5 cycles total (80 seconds)
7. Tibetan bowl plays softly at the start of each cycle (every 16 seconds)

---

## Scenario 8: Skipping Between Phases

The backward and forward buttons let the user jump between phases.

1. User is at "Hold 2s" (second phase)
2. User taps the backward button (left)
3. Session jumps to the start of "Inhale 4s" (previous phase) and the inhale audio plays
4. User taps the forward button (right)
5. Session jumps to the start of the next phase and the corresponding audio plays

---

## Scenario 9: Phase Audio Cues

Each breathing phase has its own audio cue.

1. When "Inhale" starts, the inhale audio plays
2. When "Hold" starts, the hold audio plays
3. When "Exhale" starts, the exhale audio plays
4. When "Rest" starts, the rest audio plays
5. Audio cues repeat every cycle (every 16 seconds)
6. Pausing the session also pauses any playing audio

---

## Scenario 10: Countdown After Instruction

After the instruction audio finishes, a 3-second countdown plays before the exercise begins.

1. Instruction audio finishes playing
2. Square text changes from "Listen" to "Starting in 3s"
3. After 1 second: "Starting in 2s"
4. After 2 seconds: "Starting in 1s"
5. After 3 seconds: exercise begins with "Inhale 4s"

---

## Scenario 11: Skipping the Instruction

A user taps the skip button during the instruction narration.

1. User opens the session and instruction audio begins playing
2. Square shows "Listen"
3. User taps the skip button (skip-next icon)
4. Narration stops
5. A 3-second countdown begins: "Starting in 3s", "Starting in 2s", "Starting in 1s"
6. After the countdown, the exercise begins with "Inhale 4s"

---

## Edge Cases

### App goes to background during session

The timer and animation both pause when the app is in the background. When the user returns, everything resumes from where it left off.

### Pausing during instruction audio

If the user pauses while the intro audio is playing, the audio pauses too. Resuming continues the audio from where it stopped. The exercise does not start until the intro audio finishes.

### Pausing during countdown

If the user pauses during the 3-second countdown, the countdown pauses too. Resuming continues the countdown from where it stopped.

### Resuming skips instruction audio

When resuming a saved session, the instruction audio and countdown are both skipped and the exercise starts immediately with phase audio cues.

### Saved progress but user never returns

The saved progress stays until the user either resumes, restarts, or completes a new session. There is no expiration.

### HRV display

The HRV card at the bottom shows placeholder values (72ms variability, 64 bpm heart rate). These are not connected to a real sensor yet.
