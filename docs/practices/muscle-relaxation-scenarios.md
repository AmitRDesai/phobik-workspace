# Muscle Relaxation Session — User Scenarios

## Scenario 1: Fresh Start (No Saved Progress)

A user opens the muscle relaxation exercise for the first time (or after completing a previous session).

1. User navigates to the **Muscle Relaxation Intro** screen
2. Sees exercise description with a gradient icon
3. "Start Session" button is shown
4. User taps "Start Session"
5. Session screen opens, instruction audio for the first muscle group (Face) starts playing
6. Body silhouette shows a glow on the face area
7. Text shows "Listen to the instructions..." with the group's instruction below
8. When the audio duration elapses, phase switches to "Hold and relax for 10s"
9. GlowBg brightens slightly during the hold phase
10. After 10 seconds, the session advances to the next group (Neck)
11. This repeats for all 10 muscle groups
12. After the last group (Feet) finishes its hold, user is taken to the **Completion** screen

---

## Scenario 2: Completing the Exercise

A user finishes the full session (all 10 muscle groups).

1. The last group (Feet) audio plays, followed by the 10-second hold
2. Hold countdown reaches 0
3. Saved progress is cleared
4. User is taken to the **Completion** screen
5. Confetti animation plays, trumpets sound
6. User sees "PRACTICE COMPLETED!" with the mandala badge
7. D.O.S.E. Rewards are shown with pulsing glow
8. User taps "Collect Rewards & Finish"
9. User is returned to the screen they came from
10. If user goes back to Muscle Relaxation Intro, they see "Start Session" (progress was cleared)

---

## Scenario 3: Pausing and Resuming Mid-Session

A user pauses the exercise during the session.

1. User is on the Shoulders group, audio is playing
2. User taps the pause button (bottom-left)
3. Audio stops, elapsed counter freezes, phase timer stops
4. Pause icon changes to a play icon
5. User taps the play button
6. Audio resumes, timers continue
7. Session continues normally

---

## Scenario 4: Leaving Mid-Session and Resuming Later

A user exits the session before completing it.

1. User is on the 4th muscle group (Shoulders)
2. User taps the close button in the header
3. Current step index is automatically saved
4. User returns to the **Muscle Relaxation Intro** screen
5. Button now reads "Resume Session" and "Restart Progress" is visible below it
6. User taps "Resume Session"
7. Session opens on the Shoulders group, audio plays from the beginning
8. Elapsed time is computed from the 3 completed groups (Face + Neck + Chest)
9. Progress bar reflects the completed portion

---

## Scenario 5: Restarting Progress

A user has saved progress but wants to start over.

1. User opens the **Muscle Relaxation Intro** screen and sees "Resume Session"
2. "Restart Progress" button is visible below the main button
3. User taps "Restart Progress"
4. Saved progress is cleared
5. "Restart Progress" button disappears
6. Button text changes back to "Start Session"
7. Tapping "Start Session" begins a fresh session from the Face group

---

## Scenario 6: Audio and Hold Phase Cycle

Each muscle group goes through two phases.

1. **Audio phase** — instruction audio plays, body silhouette glows on the target area
   - Text shows "Listen to the instructions..."
   - Sub-text shows the group's specific instruction (e.g., "Squeeze your eyes shut and scrunch your face tightly.")
   - GlowBg is dimmer (intensity 0.15)
2. **Wait phase** — 10-second hold countdown
   - Text shows "Hold and relax"
   - Sub-text shows "Hold and relax for Xs" with countdown
   - GlowBg brightens (intensity 0.25)
3. After the hold, the next group starts automatically

---

## Scenario 7: Step Navigator

The horizontal scroll at the bottom shows all 10 muscle groups.

1. Completed groups show a check-circle icon in muted pink
2. The active group has a gradient background (pink → yellow)
3. Upcoming groups show their icon in muted white
4. The scroll auto-centers on the active group as it advances
5. Group labels show below each icon card

---

## Scenario 8: Pausing During Audio Phase

A user pauses while the instruction audio is playing.

1. User is on the Abdomen group, audio is playing at 2 seconds in
2. User taps pause
3. Audio pauses, audio elapsed timer stops at 2 seconds
4. User taps play
5. Audio resumes from where it stopped
6. Audio elapsed timer continues from 2 seconds
7. When timer reaches the audio duration, transitions to hold phase

---

## Scenario 9: Pausing During Wait Phase

A user pauses during the 10-second hold.

1. User is on the Chest group, hold shows "Hold and relax for 6s"
2. User taps pause
3. Wait countdown stops at 6 seconds
4. User taps play
5. Countdown resumes from 6 seconds
6. When countdown reaches 0, advances to next group

---

## Edge Cases

### App goes to background during session

The timer and audio both pause when the app is in the background. When the user returns, everything resumes from where it left off.

### Resume starts current group's audio from the beginning

When resuming a saved session, the current muscle group's instruction audio replays from the start. The elapsed total is computed from completed groups only, so the progress bar and timer accurately reflect remaining work.

### Saved progress but user never returns

The saved progress stays until the user either resumes, restarts, or completes a new session. There is no expiration.

### Biometric badges

The stress and breath badges on the left side show placeholder values ("Low" stress, "Stable" breath). These are not connected to a real sensor yet.

### HRV display

The HRV badge in the header shows a placeholder value (74ms). This is not connected to a real sensor yet.
