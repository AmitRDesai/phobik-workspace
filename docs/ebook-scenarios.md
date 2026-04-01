# Calm Above the Clouds E-Book — User Scenarios

## Scenario 1: Discovering the E-Book (Not Yet Purchased)

A user explores the Specialized Packs section and finds the Fear of Flying pack.

1. User navigates to **Specialized Packs** from Courage Options
2. Sees the Fear of Flying pack card with "Unlock Full Journey" button
3. User taps "Unlock Full Journey"
4. **E-Book Landing** screen opens showing:
   - Hero image of a silhouette against a sunset above clouds
   - Title: "Calm Above the Clouds"
   - Subtitle describing the toolkit
   - Two items listed: "The Flight Mindfulness E-Book" and "Quick Flight Checklist" (dimmed, not tappable)
   - "Buy Now" button at the bottom with $9.99 price
5. Items are not interactive until purchased

---

## Scenario 2: Purchasing the E-Book

A user decides to unlock the premium content.

1. User is on the **E-Book Landing** screen
2. Taps "Buy Now" button
3. A confirmation dialog appears: "Unlock Premium Access"
4. User taps "Unlock"
5. The purchase state is saved
6. The "Buy Now" section disappears
7. The two items (E-Book and Quick Flight Checklist) become tappable with chevron arrows
8. The "What's included" heading is removed

---

## Scenario 3: Returning After Purchase

A user who previously purchased returns to the Specialized Packs.

1. User navigates to **Specialized Packs**
2. The Fear of Flying card now shows "View Journey" instead of "Unlock Full Journey"
3. User taps "View Journey"
4. **E-Book Landing** screen opens without the buy section
5. Both items are immediately tappable

---

## Scenario 4: Opening the E-Book for the First Time

A user taps the E-Book item after purchasing.

1. User taps "The Flight Mindfulness E-Book" on the landing screen
2. **Introduction** screen opens with:
   - Hero image of clouds at sunset
   - "Phobik Series" badge
   - Title: "A New Way to Understand and Work with the Fear of Flying"
   - Welcome message and two approach descriptions (Intellectual Reassurance, Emotional Safety)
   - "Start Reading" button at the bottom
3. User reads the introduction
4. Taps "Start Reading"
5. **Book Index** (Table of Contents) opens
6. The introduction is marked as seen so it won't show again

---

## Scenario 5: Opening the E-Book on Return Visits

A user opens the E-Book after having seen the introduction before.

1. User taps "The Flight Mindfulness E-Book" on the landing screen
2. Goes directly to the **Book Index** (skipping the introduction)
3. The index shows all chapters with completion status

---

## Scenario 6: Browsing the Book Index

A user views the table of contents.

1. User sees the **Book Index** screen with:
   - "Calm Above the Clouds" title
   - Full list of chapters (Foreword, Introduction, Chapters 1-22)
2. Completed chapters show a yellow checkmark icon
3. The chapter currently being read is highlighted with a pink left border and "Reading" label
4. Unread chapters have no icon
5. User can tap any chapter to start reading it

---

## Scenario 7: Reading a Chapter

A user reads a chapter from the book.

1. User taps a chapter from the index (e.g., "Chapter 1: How Flying Works")
2. The **Chapter Reader** opens with:
   - Fixed header showing "Calm Above the Clouds" and "Chapter 1"
   - Progress bar showing reading progress through the entire book
   - Scrollable chapter content (headings, paragraphs, callout boxes, quotes)
   - Fixed navigation controls at the bottom (Previous, Table of Contents, Next)
3. User scrolls through the chapter content
4. The chapter is tracked as the current reading position

---

## Scenario 8: Navigating Between Chapters

A user moves forward or backward through chapters.

1. User is reading Chapter 3
2. Taps "Next" in the bottom navigation
3. Content fades out briefly, then Chapter 4 fades in
4. Header updates to show "Chapter 4" and progress bar advances
5. Chapter 3 is marked as completed in the index
6. User taps "Previous"
7. Content transitions back to Chapter 3
8. User taps the book icon (center button) to return to the Table of Contents

---

## Scenario 9: Reading the Final Chapter

A user reaches the last chapter.

1. User is reading Chapter 22: Closing Reflections
2. The "Next" button is replaced with a green "Finish" button with a checkmark
3. User taps "Finish"
4. Chapter 22 is marked as completed
5. User is taken back to the Book Index

---

## Scenario 10: Resuming Reading

A user returns to the book after reading some chapters previously.

1. User opens the Book Index
2. Sees completed chapters marked with yellow checkmarks
3. The last chapter they were reading is highlighted with "Reading" label
4. User taps that chapter to continue where they left off
5. Or taps any other chapter to jump to it

---

## Scenario 11: Accessing the Quick Flight Checklist

A user taps the checklist item from the landing screen.

1. User is on the **E-Book Landing** screen (purchased)
2. Taps "Quick Flight Checklist"
3. Navigates to the **Flight Checklist Hub** screen
4. Sees the 6 flight phases to work through

---

## Scenario 12: Resetting All Progress (Testing)

A user wants to start fresh.

1. User is on the **E-Book Landing** screen
2. Taps the refresh icon in the top-right corner
3. All progress is cleared: purchase state, introduction seen flag, reading position, completed chapters
4. The "Buy Now" button reappears
5. The E-Book and Checklist items become dimmed again

---

## Edge Cases

### Back button from chapter reader

Tapping the back button in the chapter header returns the user to the Book Index, not the previous chapter. The "Previous" button in the bottom navigation is for chapter-to-chapter movement.

### Chapters with images

Some chapters (4, 5, 7, 14, 15, 18, 21) include hero images related to the content. These display at the top of the chapter before the text.

### Chapters with special content

Chapters include various special elements like callout boxes, quotes with colored borders, numbered lists, and affirmation cards. These vary per chapter to keep the reading experience engaging.
