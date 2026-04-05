# Gentle Letter to Yourself — User Scenarios

## Scenario 1: Discovering the Gentle Letter Practice

A user finds the practice from the Love section.

1. User taps "Begin Practice" on the Gentle Letter card on the **Love Landing** screen
2. **Gentle Letter Intro** screen opens with:
   - A back button and "PRACTICE" label in the header
   - A glowing flower icon with a soft pink aura
   - Title: "Write a Gentle Letter to Yourself"
   - Subtitle: "A PHOBIK practice in courage and kindness."
   - Description: "A guided exercise in self-compassion. Through 5 gentle steps, replace harsh self-judgment with understanding and care."
   - "Start My Letter" button
   - "View Past Letters" link with a history icon

---

## Scenario 2: Starting a New Letter

A user begins the 5-step writing process.

1. User taps "Start My Letter" on the intro screen
2. **Gentle Letter Writing** screen opens at Step 1
3. The screen shows:
   - Back button and "Gentle Letter Writing" title
   - Progress dots (5 dots, first one highlighted)
   - Step label: "Step 1 of 5: Notice What Is Here"
   - Headline: "Acknowledge your feelings without judgment."
   - Instruction: "What is your heart feeling right now? Write it down as it is."
   - A text area with placeholder: "I am feeling..."
   - Tip below: "There are no wrong answers here."
   - "Next Step" button (disabled until text is entered)

---

## Scenario 3: Writing Through All Five Steps

A user completes each step of the guided letter.

1. **Step 1 — Notice What Is Here**: User writes about their current feelings. Taps "Next Step."
2. **Step 2 — Name the Inner Critic**: Screen shows new headline: "Identify the harsh voice within." User writes what their inner critic says. Taps "Next Step."
3. **Step 3 — Offer Understanding**: Screen shows: "Reframe with compassion." User writes what they would tell a friend. Taps "Next Step."
4. **Step 4 — Write Your Letter**: Screen shows: "Compose your gentle letter." User writes their letter starting with "Dear me,". Taps "Next Step."
5. **Step 5 — Seal with Kindness**: Screen shows: "Close with an affirmation." User writes a closing affirmation.
6. Below the text area, a set of tags appears: "What core act does this letter honor?"
7. Five options to choose from: Forgiveness, Patience, Acceptance, Kindness, Courage
8. User selects one (e.g., "Kindness" — it highlights in pink)
9. Taps "Save Letter"

---

## Scenario 4: Saving a Letter

A user completes the final step and saves.

1. User has written in all 5 steps and selected a core act on Step 5
2. Taps "Save Letter"
3. A loading indicator appears: "Saving your letter..."
4. The letter is saved
5. User is navigated to the **My Compassion Archive** screen
6. Their new letter appears at the top of the "Recent Letters" list

---

## Scenario 5: Navigating Between Steps

A user goes back to review a previous step.

1. User is on Step 3
2. Taps the back arrow in the header
3. Goes back to Step 2 with their previous text preserved
4. User can edit their Step 2 text
5. Taps "Next Step" to return to Step 3 with that text also preserved
6. All text is kept in memory during the session

---

## Scenario 6: Leaving the Practice Mid-Way

A user wants to exit before finishing.

1. User is on Step 2
2. Taps the back arrow on Step 1 (or taps back from any step until reaching Step 1)
3. On Step 1, tapping back shows a dialog: "Leave practice? Your draft will be saved for later."
4. User taps to confirm
5. Returns to the previous screen

---

## Scenario 7: Viewing Past Letters from the Intro

A user wants to revisit old letters.

1. User is on the **Gentle Letter Intro** screen
2. Taps "View Past Letters"
3. Navigates to the **My Compassion Archive** screen

---

## Scenario 8: Browsing the Compassion Archive

A user explores their saved letters.

1. **My Compassion Archive** screen opens with:
   - Back button and "My Compassion Archive" title
   - A calendar showing the current month
   - Dates that have letters are highlighted with a pink background and a small yellow heart icon
   - "Recent Letters" section below the calendar
2. Each letter card shows:
   - Date (e.g., "Today" or "Mar 28, 2026")
   - Title (auto-generated from the letter content)
   - A core act badge (e.g., "Core Act: Kindness")
   - "Read reflection" link
   - A gradient thumbnail on the right

---

## Scenario 9: Filtering Letters by Date

A user taps a date on the calendar to see that day's letters.

1. User taps a highlighted date on the calendar (e.g., March 20)
2. The date gets a solid pink circle (selected state)
3. The "Recent Letters" heading changes to "Letters on Mar 20, 2026"
4. Only letters from that date are shown
5. A "Show All" link appears next to the heading
6. User taps "Show All" to clear the filter and see all letters again
7. Tapping the same date again also clears the selection

---

## Scenario 10: Tapping a Future Date

A user tries to select a date in the future.

1. User navigates to the current month on the calendar
2. Future dates appear dimmed (low opacity)
3. Tapping a future date does nothing — it is disabled

---

## Scenario 11: Reading a Saved Letter

A user opens a letter to read the full content.

1. User taps a letter card (or "Read reflection" link) in the archive
2. **Letter Detail** screen opens with:
   - "Gentle Letter" title in the header
   - The letter's title and date
   - A core act badge
   - Each of the 5 steps displayed as cards:
     - Step icon and label (e.g., "Step 1: Notice What Is Here")
     - The user's written text for that step
3. Steps that were left empty are not shown
4. User taps back to return to the archive

---

## Scenario 12: Navigating the Calendar Between Months

A user browses different months.

1. User sees the calendar header showing the current month and year
2. Taps the left arrow to go to the previous month
3. The calendar updates with the new month's dates
4. Dates with letters in that month are highlighted
5. User taps the right arrow to go forward
6. Can navigate freely between months

---

## Scenario 13: Empty Archive

A new user with no saved letters visits the archive.

1. User navigates to the **My Compassion Archive**
2. Calendar shows no highlighted dates
3. The letters section shows an empty state:
   - An edit icon
   - Message: "No letters yet. Start your first gentle letter practice."
4. At the bottom: "Your archive is private and end-to-end encrypted."

---

## Scenario 14: Trying to Save Without a Core Act

A user tries to save on Step 5 without selecting a core act.

1. User writes their affirmation on Step 5
2. Taps "Save Letter" without selecting a core act
3. An error dialog appears: "Choose a core act — Please select a core act that resonates with your letter."
4. User selects a core act and taps "Save Letter" again
5. The letter saves successfully

---

## Edge Cases

- **Network error on save**: An error dialog appears: "Could not save your letter. Please try again." The user stays on Step 5 with their text preserved.
- **Empty step on save**: Steps left empty are saved as empty strings. The letter detail screen skips displaying empty steps.
- **App backgrounded during writing**: The in-session draft is lost if the app is fully killed (it uses in-memory state, not persistent storage). The text is preserved during normal backgrounding.
- **Multiple letters on the same day**: Supported. The calendar highlights the date and all letters for that date appear when filtered.
