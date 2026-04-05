# 7-Day Empathy Challenge — User Scenarios

## Scenario 1: Discovering the Empathy Challenge (No Active Challenge)

A user opens the Empathy Challenge for the first time.

1. User taps "Start Journey" on the Love Landing screen
2. The app checks whether the user has an active challenge
3. No active challenge is found
4. **Intro** screen opens with:
   - A close button in the top left
   - A soft pink and yellow aura glow at the top
   - Title: "7-Day Empathy Challenge"
   - Description explaining the three layers: Perspective, Feeling, and Compassion
   - Three benefit cards: "Understand Others", "Deepen Bonds", "Self-Compassion"
   - "Join Challenge" button at the bottom

---

## Scenario 2: Joining the Challenge

A user decides to start the 7-day challenge.

1. User is on the **Intro** screen
2. Taps "Join Challenge"
3. The challenge is created with Day 1 unlocked and Days 2-7 locked
4. User is navigated to the **Calendar** screen
5. Calendar shows:
   - "Empathy Challenge" title in the header
   - "Overall Progress" bar showing 0/7 Days
   - Day 1 highlighted as the active day with a card showing title, description, and "Start Day 1" button
   - Days 2-7 shown as locked with lock icons and dimmed appearance

---

## Scenario 3: Starting a Day

A user begins their daily empathy practice.

1. User is on the **Calendar** screen
2. Taps "Start Day 1" on the active day card
3. **Day** screen opens with:
   - Back button and "Day 1" title in the header
   - Progress bar showing "Day 1 of 7"
   - A hero card with a badge (e.g., "Perspective Empathy") and the day title
   - **Intention** section with a quote
   - **Today's Challenge** section with the practice instructions and a highlighted quote in a card with a pink left border
   - **Reflection** section with a text input area
   - **D.O.S.E. Reward** section showing Oxytocin +10 and Serotonin +5
   - "Complete Day 1" button at the bottom

---

## Scenario 4: Completing a Day

A user finishes their daily practice.

1. User reads the challenge instructions on the **Day** screen
2. Types their reflection in the text area
3. Taps "Complete Day 1"
4. The day is marked as completed with the reflection saved
5. User is navigated back to the **Calendar** screen
6. Calendar now shows:
   - Day 1 with a checkmark (completed)
   - Day 2 now unlocked and highlighted as the active day
   - Progress bar updated to 1/7 Days

---

## Scenario 5: Progressing Through the Week

A user works through the challenge over several days.

1. Each day, the user opens the challenge from the Love section
2. The app detects an active challenge and goes directly to the **Calendar**
3. The next unlocked day is highlighted with its unique content:
   - Day 1: See Through New Eyes (perspective-taking exercise)
   - Day 2: Tune In, Don't Fix (emotional listening)
   - Day 3: Pause Before You Reply (three guided steps with icons)
   - Day 4: Stay Open, Stay Grounded (boundary-setting mantra)
   - Day 5: Kindness in Motion (action-based care)
   - Day 6: Support Without Absorbing (resilient compassion)
   - Day 7: The Empathy Loop (three-card integration exercise)
4. Completed days show checkmarks; locked days remain dimmed

---

## Scenario 6: Completing the Entire Challenge (Day 7)

A user finishes the final day of the challenge.

1. User completes Day 7 by writing their reflection
2. Taps "Finish Challenge"
3. **Completion** screen opens with:
   - "Challenge Complete" header
   - A large glowing badge with a heart icon and gradient ring
   - Title: "Empathy Master!"
   - Message: "You've completed 7 days of growth. Your heart is more open, and your connections are stronger."
   - "Sessions Done 7/7" stat card
   - D.O.S.E. reward display
   - "Share Achievement" button
   - "Return to Home" button
4. User taps "Return to Home" and goes back to the Practices tab

---

## Scenario 7: Returning to a Challenge in Progress

A user comes back to continue their challenge.

1. User taps "Start Journey" on the Love Landing
2. The app finds an active challenge
3. User is taken directly to the **Calendar** screen
4. Their progress is preserved — completed days have checkmarks, the next day is active

---

## Scenario 8: Trying to Complete a Day Without a Reflection

A user tries to finish a day without writing anything.

1. User opens a day and reads the challenge
2. Taps "Complete Day" without typing in the reflection area
3. The button is disabled and nothing happens
4. User types at least one character
5. The button becomes active and they can complete the day

---

## Scenario 9: Day 3 — Bullet Point Challenge

Day 3 has a unique challenge format with guided steps.

1. User opens Day 3: "Pause Before You Reply"
2. The challenge section shows three guided steps, each with an icon:
   - A chat icon: "What might they be feeling?"
   - A heart icon: "What am I feeling?"
   - A breath icon: "Take one grounding breath, then respond with awareness."
3. User reads through all three steps before writing their reflection

---

## Scenario 10: Day 7 — Three-Card Challenge

Day 7 has a unique challenge format with integration cards.

1. User opens Day 7: "The Empathy Loop"
2. The challenge section titled "The Final Challenge" shows three cards:
   - **Perspective Taking**: "What might this person be thinking right now? Step into their world."
   - **Emotional Resonance**: "What might they be feeling beneath the surface? Feel with them."
   - **Compassionate Action**: "What kind act could I offer? Close the loop with a gesture."
3. The complete button says "Finish Challenge" instead of "Complete Day 7"

---

## Scenario 11: Starting a New Challenge After Completion

A user wants to do the challenge again.

1. User returns to the Empathy Challenge after completing it
2. The intro screen shows again (the previous challenge is no longer active)
3. User taps "Join Challenge"
4. A new challenge is created (the previous one is marked as abandoned)
5. Day 1 is unlocked again with a fresh start

---

## Edge Cases

- **Network error on Join Challenge**: An error dialog appears: "Could not start the challenge. Please try again." The user stays on the intro screen.
- **Network error on Complete Day**: An error dialog appears: "Could not complete the day. Please try again." The user stays on the day screen with their reflection preserved.
- **App backgrounded during a day**: The reflection text is preserved. The user can return and continue.
- **No active challenge but stale cache**: The calendar screen detects no active challenge and redirects to the intro screen.
- **Loading state**: A spinner shows while challenge data is being fetched.
