# Sleep Meditation Session — User Scenarios

## Scenario 1: Fresh Start (No Saved Progress)

A user opens the sleep meditation exercise for the first time.

1. User taps the "Sleep Meditation" card in the Exercise Library
2. Session screen opens directly (no intro screen)
3. "15 Min" duration is selected by default
4. The aura around the image is still (not pulsing yet)
5. Play button shows a play icon; skip buttons are dimmed
6. Progress bar shows 00:00 elapsed, total duration on the right
7. User can tap other duration pills (Full, 30 Min, 45 Min) to switch before playing
8. User taps the play button
9. Audio begins, aura starts pulsing, skip buttons become active
10. Duration pills become disabled and dimmed
11. Progress bar fills as audio plays

---

## Scenario 2: Selecting a Different Duration Before Playing

A user wants to change the session length before starting.

1. Session loads with "15 Min" selected
2. User taps "30 Min" pill
3. Audio switches to the 30 min version
4. Total duration label updates to show the new length
5. "30 Min" pill is highlighted (yellow text, accent border)
6. User taps play to start the 30 min meditation

---

## Scenario 3: Pausing and Resuming

A user pauses the meditation mid-session.

1. Audio is playing at 8:42
2. User taps the pause button
3. Audio stops, aura settles to still
4. Duration pills become tappable again
5. Skip buttons remain active
6. User taps play
7. Audio resumes from 8:42, aura resumes pulsing
8. Duration pills become disabled again

---

## Scenario 4: Switching Duration While Paused

A user pauses and decides to switch to a different session length.

1. User is 5 minutes into a 15 min session
2. User taps pause
3. Duration pills become tappable
4. User taps "45 Min"
5. Audio switches to the 45 min version
6. Play button shows the play icon (ready to start fresh)
7. Progress bar resets (new duration, starting from the beginning)
8. User taps play to start the 45 min meditation from the beginning

---

## Scenario 5: Using Skip Controls

A user skips forward and backward during playback.

1. Audio is playing at 12:30 of a 30 min session
2. User taps the forward 10s button
3. Audio jumps to 12:40
4. User taps forward 10s three more times, jumping to 13:10
5. User taps the replay 10s button
6. Audio jumps back to 13:00
7. Progress bar and time labels update accordingly

---

## Scenario 6: Leaving Mid-Session and Resuming Later

A user exits the session before finishing.

1. User is 10 minutes into a 30 min session
2. User taps the back button
3. Their duration choice and position are saved automatically
4. User returns to the exercise library
5. Later, user taps the "Sleep Meditation" card again
6. Session screen opens with "30 Min" selected
7. The position is restored to 10:00 but audio does **not** start automatically
8. User taps play to resume from where they left off

---

## Scenario 7: Audio Finishes

A user listens to the entire meditation.

1. Audio reaches the end
2. Saved progress is cleared
3. User stays on the session screen (no navigation away)
4. Aura stops pulsing
5. Duration pills become tappable
6. User can select a different duration and start again, or go back

---

## Scenario 8: Returning After Completion

A user completed a session previously and opens the exercise again.

1. Saved progress was cleared when the audio finished
2. User taps "Sleep Meditation" in the exercise library
3. Session opens fresh with "15 Min" selected (default)
4. No saved position — ready to start from the beginning

---

## Edge Cases

### Skipping past the start or end

- Tapping forward 10s near the end won't go past the total duration
- Tapping replay 10s near the start won't go below 00:00

### Skip buttons disabled before playback

Before the user presses play for the first time, both skip buttons are dimmed and not tappable. They only become active after playback starts.

### Switching duration resets progress

When switching to a different duration while paused, the new audio starts from the beginning. The user must press play to start.

### Resume does not auto-play

When returning to a saved session, the audio is ready at the saved position but waits for the user to press play. This avoids unexpected audio in quiet environments.

### No intro screen

Unlike other exercises, sleep meditation opens directly to the session screen from the exercise library.

### No completion screen

Unlike other exercises, there is no completion screen. The meditation is designed for falling asleep — navigating away would be disruptive.
