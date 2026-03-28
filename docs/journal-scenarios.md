# Private Journal — User Scenarios

## Scenario 1: Opening the Journal for the First Time

A user taps "Journal" from the home screen.

1. User taps the "Journal" button on the home screen
2. The locked journal screen appears
3. A large heart icon with a lock badge is shown in the center
4. The heading reads "Your Thoughts are Protected"
5. Below the heading, a short description explains that the journal is private and locked
6. Blurred stats (entries, streak, avg HRV) are visible but not readable
7. An "Unlock Journal" button is shown with a fingerprint or face scan icon depending on the device
8. A "Secure Biometric Access" label appears below the button

---

## Scenario 2: Unlocking the Journal

A user taps the unlock button to access their journal.

1. User taps "Unlock Journal"
2. The device asks for biometric authentication (face or fingerprint)
3. If authentication succeeds, the journal dashboard opens
4. If authentication fails, the user stays on the locked screen and can try again

---

## Scenario 3: Browsing the Journal Dashboard

A user has unlocked the journal and is viewing the dashboard.

1. The header shows "Private Journal" with "Encrypted Reflections" below it
2. A lock button appears in the top right to manually re-lock the journal
3. A calendar shows the current month with navigation arrows to go forward or backward
4. Days with journal entries have a small pink dot below them
5. The currently selected day is highlighted with a gradient circle
6. Future days cannot be selected
7. Below the calendar, a daily insight prompt card suggests a reflection topic
8. Below the prompt, the selected date is shown (e.g., "FRIDAY - Mar 27, 2026")
9. Journal entries for that date are listed below
10. Each entry card shows the time, title, a short preview, tags, and a sun or moon icon based on the time of day
11. If there are no entries for the selected date, a message says "No entries for this date"
12. A floating "+" button in the bottom right allows creating a new entry

---

## Scenario 4: Creating a New Journal Entry

A user taps the "+" button to write a new entry.

1. User taps the floating "+" button on the dashboard
2. A new screen opens with "Focus on what matters" in the header
3. A close button (X) is in the top left and "Drafts" label is in the top right
4. User taps "What are you feeling?" to expand the dropdown
5. Six options appear: Pleasant, Connected, Neutral, Unpleasant, Anxious, Angry
6. User selects one — the dropdown collapses and shows the selection
7. User taps "What are you needing?" to expand the next dropdown
8. Four options appear: Connection, Safety, Autonomy, Meaning
9. User selects one — the dropdown collapses and shows the selection
10. Selected feeling and need appear as colored chips in the "Selected Tags" area
11. User can add custom tags by typing in the tag input and pressing done
12. Previously used tags appear as suggestions below the input for quick selection
13. A "Private Entry" label marks the text area
14. User types their reflection in the large text area
15. The entry auto-saves as a draft while typing (a brief "Auto-saving..." message appears)
16. User taps "Save Reflection" at the bottom
17. The entry is saved and user returns to the dashboard
18. The new entry appears in the list for today's date
19. The calendar now shows a dot under today

---

## Scenario 5: Viewing an Existing Entry

A user taps on an entry from the dashboard to read it.

1. User taps on an entry card
2. The entry screen opens showing the full content
3. The feeling and need dropdowns show the saved selections (not expandable)
4. Tags are displayed as colored chips (not removable)
5. The full text of the entry is shown (not editable)
6. An "Edit" button appears in the top right instead of "Drafts"
7. User taps the close button (X) to go back to the dashboard

---

## Scenario 6: Editing an Existing Entry

A user wants to update a journal entry they wrote earlier.

1. User taps on an entry card to open it
2. User taps "Edit" in the top right
3. The feeling and need dropdowns become expandable again
4. Tags become removable (X icon appears on each chip)
5. The text area becomes editable
6. "Save Reflection" button appears at the bottom
7. User makes changes and taps "Save Reflection"
8. The updated entry is saved and user returns to the dashboard
9. The entry card on the dashboard reflects the changes immediately

---

## Scenario 7: Managing Tags

A user creates and manages custom tags for their entries.

1. User is on the new entry screen
2. User types "Gratitude" in the tag input and presses done
3. A "Gratitude" chip appears in the Selected Tags area with a random color
4. The tag is saved for future use
5. Next time the user creates an entry, "Gratitude" appears in the suggested tags below the input
6. User taps a suggested tag to add it instantly
7. User taps the X on a tag chip to remove it from the current entry
8. Removing a tag from an entry does not delete it from the suggestions

---

## Scenario 8: Navigating Between Months

A user wants to see entries from a previous month.

1. User is on the journal dashboard viewing the current month
2. User taps the left arrow next to the month name
3. The calendar switches to the previous month
4. Days with entries show pink dots
5. User taps on a day to see entries for that date
6. User taps the right arrow to go forward again
7. Navigation works across year boundaries (December to January)

---

## Scenario 9: Journal Auto-Locks When App Goes to Background

A user switches away from the app while viewing the journal.

1. User is browsing the journal dashboard
2. User switches to another app or locks their phone
3. When the user returns to the app, the journal is locked
4. The biometric prompt appears automatically
5. If authentication succeeds, the user goes back to the dashboard
6. If authentication fails, the user stays on the locked screen

---

## Scenario 10: Manually Locking the Journal

A user wants to lock the journal without leaving the app.

1. User is on the journal dashboard
2. User taps the lock button in the top right of the header
3. The journal locks and the locked screen appears
4. The biometric prompt does not appear automatically
5. User must tap "Unlock Journal" to re-enter

---

## Scenario 11: Draft Recovery After a Crash

A user was writing an entry when the app crashed or was force-closed.

1. User was typing a new entry with feeling, need, tags, and text filled in
2. The app closes unexpectedly
3. User reopens the app and navigates to the journal
4. User unlocks the journal and taps "+" to create a new entry
5. The previous draft is restored — feeling, need, tags, and text are all filled in
6. User can continue writing or save the entry
7. After saving, the draft is cleared

---

## Scenario 12: Viewing Entries by Tapping Calendar Dates

A user browses entries across different dates.

1. User is on the journal dashboard
2. User taps on a date in the calendar that has a pink dot
3. The date highlights with a gradient border
4. The entries list below updates to show entries for that date
5. User taps on a different date
6. The entries list updates again
7. Tapping a date without a dot shows "No entries for this date"

---

## Scenario 13: Daily Insight Prompt

A user uses the daily prompt to start a journal entry.

1. User sees the "Daily Insight Prompt" card below the calendar
2. The card shows a reflection question (e.g., "How did your morning walk feel today?")
3. User taps "Start" on the card
4. The new entry screen opens
5. User writes their reflection inspired by the prompt

---

## Edge Cases

### No biometric available on device

If the device does not support biometrics, the unlock button shows a generic lock icon. The biometric prompt may fall back to a device PIN or passcode depending on the device settings.

### Empty journal

When a user opens the journal for the first time with no entries, the blurred stats show zeros (0 entries, 0 streak). The calendar has no dots. Selecting any date shows "No entries for this date."

### Very long entry text

Long entries are fully scrollable on the view screen. On the dashboard, only the title and a one-line preview are shown in the entry card.

### Many tags on an entry

Tags in the entry card scroll horizontally. If there are more than three, the first three are shown with a "+N" indicator for the rest.

### Creating multiple entries on the same day

Multiple entries can be created for the same date. They all appear in the list when that date is selected, sorted by newest first.
