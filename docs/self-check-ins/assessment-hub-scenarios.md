# Assessment Hub — User Scenarios

## Scenario 1: First Visit

1. User taps the **Self Check Ins** card on the **Growth Hub** screen
2. The **Assessment Hub** screen appears with the title "Assessment Hub" and subtitle "Deep insights for personal evolution"
3. Three assessment cards are displayed:
   - **Intimacy & Connection** — "Discover your relationship dynamics"
   - **The Pivot Point** — "Discover how you respond under pressure — and where you can shift"
   - **The Stress Compass** — "Discover what really matters to you"
4. Each card shows a **Start Test** button with a gradient background
5. User taps **Start Test** on any card and is taken to that assessment's intro screen

## Scenario 2: Resuming an In-Progress Assessment

1. User previously started the **Intimacy & Connection** quiz but closed the app before finishing
2. User returns to the **Assessment Hub**
3. The **Intimacy & Connection** card now shows a yellow **Resume** button instead of the usual "Start Test"
4. User taps **Resume** and is taken to the intro screen
5. On the intro screen, the button reads **Resume Quiz** instead of "Begin Quiz"
6. After tapping it, the quiz picks up from where the user left off with all previous answers restored

**Key point:** Each assessment tracks its own progress independently. A user can have one in-progress assessment of each type at the same time.

## Scenario 3: Multiple Completed Assessments

1. User has completed the **Intimacy & Connection** quiz before
2. The card still shows **Start Test** (not "Resume") because the previous attempt is completed
3. Tapping **Start Test** begins a brand-new assessment
4. All previous completed assessments remain stored in history

## Edge Cases

### No Internet Connection
- The hub still displays all three cards using cached data
- If the user has never loaded assessment data before, cards appear but the resume state may not be detected until connection returns

### Back Navigation
- Tapping the back arrow on the **Assessment Hub** returns the user to the **Growth Hub**
