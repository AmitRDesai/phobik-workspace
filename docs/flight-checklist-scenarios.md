# Quick Flight Checklist — User Scenarios

## Scenario 1: Starting the Checklist

A user opens the flight checklist for the first time.

1. User navigates to the **Flight Checklist Hub** from the E-Book Landing or Courage Options
2. Sees the hub with:
   - Hero image with Phobik branding
   - Title: "Quick Flight Checklist"
   - 6 phase buttons: Before the Airport, At the Airport, Once Seated, During Takeoff, During Turbulence, During Landing
3. No "Quick Reset" button is visible (no saved progress yet)
4. User taps "Before the Airport"
5. The phase checklist screen opens

---

## Scenario 2: Working Through a Phase

A user completes items in a checklist phase.

1. User is on the **Before the Airport Checklist** screen
2. Sees:
   - Phase badge: "Pre-Flight Phase"
   - Title with gradient accent line
   - 4 checklist items with categories (Acknowledgment, Preparation, Action, Mindset)
   - A journal prompt section
   - "Next Step" button
3. User taps a checklist item to mark it complete
4. The empty circle fills with a pink-to-yellow gradient checkmark
5. User taps the same item again to uncheck it
6. The checkmark reverts to an empty circle
7. User taps "Next Step" to move to the next phase

---

## Scenario 3: Moving Through All 6 Phases

A user progresses through the entire checklist from start to finish.

1. **Before the Airport** — 4 items about acknowledgment, preparation, breathing, and mindset. Includes a journal prompt.
2. Taps "Next Step" → **At the Airport** — 4 items about pausing, grounding, reframing, and affirmation.
3. Taps "Next Step" → **Once Seated** — 4 body awareness items (feet, seat, shoulders, jaw), a breathing card, a reality check, and an anchor selection grid.
4. Taps "Next Step" → **During Takeoff** — 4 items about sensations, breathwork, mindset, and embodiment. An "Exhale" focus card at the bottom.
5. Taps "Next Step" → **During Turbulence** — 6 items about body positioning, self-reminders, grounding, and allowing movement. A link to "Turbulence Tools."
6. Taps "Next Step" → **During Landing** — Description of the landing process, 4 items about sounds, pressure, affirmation, and transition. Button says "Practice Completed."
7. Taps "Practice Completed" → returns to the hub

---

## Scenario 4: Choosing an Anchor (Once Seated)

A user selects a distraction anchor during the Once Seated phase.

1. User is on the **Once Seated Checklist**
2. After the body awareness items, sees "Choose an anchor" section
3. 10 options displayed in a grid: Journal, Sound Therapy, Podcast, Movie, Book, Breathing, Chewing Gum, Music, 5-4-3-2-1, Other
4. User taps "Music"
5. The Music option highlights with a pink border and background
6. User can change selection by tapping another option

---

## Scenario 5: Using the Journal Prompt (Before the Airport)

A user writes reflections before their flight.

1. User is on the **Before the Airport Checklist**
2. Below the checklist items, sees "Journal Prompt" section
3. Prompt reads: "What am I worried about? Fact or fiction?"
4. User taps the text area
5. Keyboard opens, user types their reflections
6. Text is kept while on the screen but not persisted after leaving

---

## Scenario 6: Accessing Turbulence Tools

A user explores practical grounding techniques during turbulence.

1. User is on the **During Turbulence Checklist**
2. Below the checklist items, sees a "Turbulence Tools" card
3. User taps the card
4. **Turbulence Tools** screen opens with:
   - "Cup of Water" — place a cup on the tray table and observe how little liquid moves
   - "Sticky Note Check" — write "If I can read this, I'm okay" on a note
   - "Gelatin Visualization" — picture the plane suspended in thick gelatin
   - "Animated Reality" — turn fear into a cartoon character
5. User taps "Continue Session" to return to the turbulence checklist

---

## Scenario 7: Progress Persists Between Sessions

A user checks some items and returns later.

1. User opens "Before the Airport" and checks 2 of 4 items
2. User leaves the app entirely
3. User returns to the app and opens "Before the Airport" again
4. The 2 previously checked items still show as checked
5. User can continue checking remaining items

---

## Scenario 8: Quick Reset

A user wants to clear all checklist progress and start fresh.

1. User returns to the **Flight Checklist Hub** after having checked some items
2. A "Quick Reset" button is now visible at the bottom (it only appears when there is saved progress)
3. User taps "Quick Reset"
4. A confirmation dialog appears: "This will clear all your checklist progress. Are you sure?"
5. User taps "Reset"
6. All checked items across all phases are cleared
7. The "Quick Reset" button disappears

---

## Scenario 9: Navigating Back from a Phase

A user exits a phase before finishing it.

1. User is on the **During Takeoff Checklist** with some items checked
2. User taps the back button in the top-left corner
3. Returns to the **Flight Checklist Hub**
4. Checked items are saved
5. User can return to "During Takeoff" later and see their progress

---

## Edge Cases

### Skipping phases

Users can tap any phase from the hub in any order. Phases are sequential (each has a "Next Step" linking to the next), but users are not forced to follow the order.

### Landing phase completion

The "During Landing" phase has no "Next Step" — the button says "Practice Completed" and returns the user to the hub.

### Quick Reset visibility

The "Quick Reset" button only appears on the hub when at least one item has been checked across any phase.
