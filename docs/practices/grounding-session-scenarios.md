# Grounding Session (5-4-3-2-1) — User Scenarios

## Scenario 1: Fresh Start (No Saved Progress)

A user opens the grounding exercise for the first time (or after completing a previous session).

1. User navigates to the **Grounding Intro** screen
2. Sees exercise overview with 5 sense cards (see, feel, hear, smell, taste)
3. "Start Session" button is shown
4. User taps "Start Session"
5. Session screen opens with a progress ring showing "5"
6. Audio narration plays: "Identify 5 things you can see"
7. Visualizer bars animate while audio plays, then stop when narration ends
8. Timer counts down for this step
9. When time runs out, step advances to "4" (feel) with new narration
10. Process continues through all 5 steps
11. When the final step ends, user is taken to the **Completion** screen

---

## Scenario 2: Completing the Exercise

A user finishes all 5 steps of the grounding session.

1. The final step (1 thing you can taste) timer reaches zero
2. User is taken to the **Completion** screen
3. Confetti animation plays, trumpets sound
4. User sees "PRACTICE COMPLETED!" with the mandala badge
5. D.O.S.E. Rewards are shown: +10 Endorphins, +5 Serotonin (with pulsing glow)
6. User taps "Collect Rewards & Finish"
7. User is returned to the screen they came from
8. If user goes back to Grounding Intro, they see "Start Session" (progress was cleared)

---

## Scenario 3: Pausing and Resuming Mid-Session

A user pauses the exercise during a step.

1. User is on step 3 (3 things you can hear), timer counting down
2. User taps "Pause Session"
3. Timer stops, audio pauses, visualizer bars collapse
4. Button text changes to "Resume Session"
5. User taps "Resume Session"
6. Timer resumes, audio resumes, visualizer reactivates
7. Session continues normally

---

## Scenario 4: Leaving Mid-Session and Resuming Later

A user exits the session before completing it.

1. User is on step 2 (4 things you can feel) with about a minute remaining
2. User taps the close button (X) in the header
3. Progress is automatically saved
4. User returns to the **Grounding Intro** screen
5. Button now reads "Resume Session" and "Restart Progress" is visible below it
6. User taps "Resume Session"
7. Session picks up where they left off with the correct step and remaining time
8. Audio plays for the current step

---

## Scenario 5: Restarting Progress

A user has saved progress but wants to start over.

1. User opens the **Grounding Intro** screen and sees "Resume Session"
2. "Restart Progress" button is visible below the main button
3. User taps "Restart Progress"
4. Saved progress is cleared
5. "Restart Progress" button disappears
6. Button text changes back to "Start Session"
7. Tapping "Start Session" begins a fresh session from step 1 (5 things you can see)

---

## Scenario 6: Dismissing the Completion Screen

A user closes the completion screen without tapping the main button.

1. User reaches the **Completion** screen after finishing the session
2. Trumpets play, confetti falls
3. User taps the close button (X) in the top right corner
4. User is returned to the previous screen
5. Progress was already cleared, so returning to Intro shows "Start Session"

---

## Scenario 7: Audio Finishes Before Step Timer

Each narration audio is shorter than the step duration. This gives the user quiet time to practice.

1. User is on step 5 (5 things you can see), timer counting down
2. Narration audio plays and finishes after about 15 seconds
3. Visualizer bars stop animating
4. Timer continues counting down (user has remaining time to practice)
5. When the timer reaches zero, the next step begins with new narration

---

## Edge Cases

### App goes to background during session

The timer pauses when the app goes to background. When the user returns to the app, the timer resumes from where it left off.

### Saved progress but user never returns

The saved progress stays until the user either resumes, restarts, or completes a new session. There is no expiration.

### Pressing back from the completion screen

The system back button from the completion screen does not return to the session. It goes back to wherever the user was before starting the exercise.
