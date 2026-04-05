# Intimacy & Connection Quiz — User Scenarios

## Scenario 1: Starting a New Quiz

1. User taps **Start Test** on the **Intimacy & Connection** card in the Assessment Hub
2. The **Quiz Intro** screen appears with a glowing heart mandala illustration
3. The title reads "Balanced Communication Quiz" with the subtitle "A self-reflection tool for mindful listening and clear expression"
4. Three numbered instructions explain how to take the quiz:
   - Focus on actions over the past month
   - Rate each statement from 0 (Not true) to 4 (Almost always)
   - Be honest for accurate results
5. User taps **Begin Quiz**
6. The first question appears

## Scenario 2: Answering a Question

1. The question screen shows progress at the top: "01/07" with a "Speaker Role" label and a gradient progress bar
2. The question is displayed in large text with quotation marks (e.g., "I bring up one issue only, rather than many issues at once.")
3. Five rating circles labeled 0 through 4 appear below, with "Never" under 0 and "Always" under 4
4. User taps a number to select their rating — the circle fills with a pink-to-yellow gradient glow
5. Below the rating, a "Why this matters" card explains the reasoning behind the question
6. User taps **Next Question** to proceed
7. The screen smoothly scrolls to the top and the next question appears with the progress bar animating forward

**Key point:** The user cannot proceed without selecting a rating. The Next Question button stays disabled until a selection is made.

## Scenario 3: Going Back to a Previous Question

1. User is on question 3 and wants to change their answer on question 2
2. User taps the back arrow in the header
3. Question 2 appears with the previously selected rating still highlighted
4. User can change the rating and tap **Next Question** to move forward again

## Scenario 4: Quitting Mid-Quiz

1. User is on question 1 and taps the back arrow
2. A dialog appears: "Quit Assessment?" with the message "Your progress will be saved"
3. If user taps **Quit**, they return to the **Assessment Hub** — their progress is saved on the server
4. If user taps **Continue**, the dialog closes and they stay on the question

## Scenario 5: Resuming a Quiz

1. User previously quit on question 4 of the Intimacy quiz
2. User returns to the **Assessment Hub** and sees a yellow **Resume** button on the Intimacy card
3. User taps **Resume** and is taken to the intro screen
4. The button now reads **Resume Quiz**
5. User taps it and the quiz loads at question 4 with all previous answers intact

## Scenario 6: Completing the Quiz

1. User reaches question 7 (the final question)
2. The button reads **Save Response** instead of "Next Question"
3. User selects a rating and taps **Save Response**
4. The **Results** screen appears showing:
   - A communication level (Strong / Growing / Emerging Communicator)
   - Total score with percentage
   - A breakdown of each question with the answer given
5. User taps **Back to Assessments** to return to the hub

## Scenario 7: Viewing Results

1. On the results screen, the user sees their level badge (e.g., "Strong Communicator" for 75%+)
2. Each of the 7 questions is listed with the score and label (e.g., "3/4 · Often")
3. User can scroll through all results
4. Tapping **Back to Assessments** returns to the Assessment Hub

## Edge Cases

### Closing the App During the Quiz
- Answers already submitted are saved on the server
- The current unsaved answer (selected but "Next" not tapped) is lost
- On return, the quiz resumes from the last saved question

### Network Error While Saving
- Answers are saved with fire-and-forget mutations — the UI does not block
- If a save fails, the local state still has the answer so the user can continue
- On resume, the last successfully saved state is restored
