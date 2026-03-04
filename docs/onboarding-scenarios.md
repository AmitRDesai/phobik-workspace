# Onboarding — User Scenarios

## Scenario 1: Complete Onboarding (All Steps)

A user finishes account creation and enters the onboarding flow for the first time.

1. User is routed to the **Aura Picture Setup** screen (the onboarding index)
2. User uploads a profile picture and taps "Looks Great"
3. User arrives at the **Welcome** screen and taps "Start"
4. User selects life stressors on the **Life Stressors** screen and taps "Continue"
5. User selects fear triggers on the **Fear Triggers** screen and taps "Continue"
   - A dialog appears asking about reminder preferences — user picks one and taps "Finish Personalizing"
6. User picks up to 3 regulation tools on the **Regulation Preference** screen and taps "Continue"
7. User sets energy patterns on the **Energy Patterns** screen and taps "Continue"
8. User connects their calendar on the **Calendar Support** screen, selects calendars, sets check-in timing and support tone, then taps "Continue"
9. User reviews privacy promises on the **Privacy & Trust** screen and taps "Continue"
   - Calendar preferences are saved to the backend in the background
10. User taps "Go to Today" on the **Completion** screen
    - Onboarding answers are saved, `onboardingCompletedAt` is set
11. User proceeds to **Biometric Setup** (if available) or **Home**

---

## Scenario 2: Skip Onboarding Entirely

A user wants to skip the entire onboarding and get to the app immediately.

1. User sees the **Aura Picture Setup** screen and taps "Maybe Later"
2. User sees the **Welcome** screen and taps "Skip for now"
3. User lands on the **Completion** screen and taps "Go to Today"
   - `saveOnboardingAnswers` is called with all default/empty values
   - `completeOnboarding` is called — onboarding is marked done
4. User proceeds to **Biometric Setup** (if available) or **Home**

**Key point:** Even when skipping, the save sequence on the Completion screen still runs. The backend receives empty arrays and null values.

---

## Scenario 3: Skip Photo, Complete Rest

A user doesn't want to upload a photo but completes all the questionnaire steps.

1. User taps "Maybe Later" on the **Aura Picture Setup** screen
2. User completes steps 1–7 normally
3. User taps "Go to Today" on the **Completion** screen
4. Profile has no picture, but all onboarding answers are saved

---

## Scenario 4: Upload Photo, Skip Onboarding

A user uploads their photo but skips the questionnaire.

1. User uploads a photo and taps "Looks Great" on the **Aura Picture Setup** screen
   - Photo is uploaded to storage via `uploadProfilePicture`
2. User taps "Skip for now" on the **Welcome** screen
3. User taps "Go to Today" on the **Completion** screen
4. Profile has a picture, but onboarding answers are all defaults

---

## Scenario 5: No Fear Triggers Selected (Dialog Skipped)

A user doesn't select any fear triggers.

1. User reaches the **Fear Triggers** screen
2. User leaves all triggers unselected and taps "Continue"
3. The `FearTriggersDialog` is **not shown** (it only appears when `selected.length > 0`)
4. `reminderPreference` stays `null`
5. User continues to the **Regulation Preference** screen normally

---

## Scenario 6: Calendar Permission Denied

A user denies the calendar permission prompt.

1. User reaches the **Calendar Support** screen
2. User taps "Connect my calendar"
3. The OS permission dialog appears — user taps "Don't Allow"
4. The screen shows a denied state: explanation text + "Open Settings" button + "Skip for now" link
5. User can either open device settings to grant permission or tap "Skip for now" to proceed
6. Calendar atoms remain at defaults (`calendarConnected: false`, empty `selectedCalendarIds`)
7. On the **Privacy & Trust** screen, `saveCalendarPrefs` is **not** called (because `calendarConnected` is `false`)

---

## Scenario 7: Calendar Connected Successfully

A user grants calendar permission and configures preferences.

1. User reaches the **Calendar Support** screen and taps "Connect my calendar"
2. The OS permission dialog appears — user taps "Allow Full Access"
3. Device calendars are loaded and displayed (birthday and subscription calendars are filtered out)
4. User selects which calendars to watch
5. User picks a check-in timing ("2 Days", "Day of", or "1 Hour")
6. User picks a support tone ("Gentle", "Subtle", or "Direct")
7. User taps "Continue" to proceed to **Privacy & Trust**
8. On the **Privacy & Trust** screen, tapping "Continue" fires `saveCalendarPrefs.mutate()` with the selected preferences before navigating to **Completion**

---

## Scenario 8: Photo Already Uploaded (Re-entering After App Kill)

A user uploaded a photo previously (e.g., the app was killed and they restarted the onboarding flow).

1. User arrives at the **Aura Picture Setup** screen
2. Their existing profile image (from `session.user.image`) is displayed in the circle
3. User can tap "Looks Great" **without selecting a new photo** — no upload is triggered, navigation proceeds
4. User can also pick a new photo to replace the existing one

**Key point:** The screen checks `session.user.image` to determine if a photo already exists. If it does, the "Looks Great" button works without a new selection.

---

## Scenario 9: Save Fails on Completion Screen

The network request fails when the user taps "Go to Today".

1. User taps "Go to Today" on the **Completion** screen
2. `saveOnboardingAnswers` or `completeOnboarding` throws an error
3. An error dialog appears: "Something went wrong — We couldn't save your answers. Please try again."
4. The user dismisses the dialog and tries again
5. On success, the flow completes normally

**Key point:** The in-memory `onboardingDataAtom` is only reset after both mutations succeed. If the save fails, the data is still available for retry.

---

## Scenario 10: Returning User After Full Sign-Out (Onboarding Skipped)

A user who already completed onboarding signs out fully and signs back in.

1. User signs in on the **Sign In** screen (see [auth-scenarios.md](./auth-scenarios.md#scenario-3-returning-user-sign-in-after-sign-out))
2. `getProfileStatus` returns `{ hasProfile: true, onboardingCompleted: true }`
3. The onboarding guard (`!onboardingCompleted`) is `false` — onboarding is skipped
4. User proceeds directly to **Biometric Setup** (if not previously prompted) or **Home**

---

## Edge Cases

### App killed mid-onboarding

If the app is killed during the onboarding flow (before the Completion screen save):

- In-memory `onboardingDataAtom` is lost — it is not persisted
- Calendar atoms (`calendarConnectedAtom`, `selectedCalendarIdsAtom`, etc.) are persisted and survive the restart
- On next launch, `getProfileStatus` returns `onboardingCompleted: false`, so the user is routed back to the onboarding flow
- The user starts from the **Aura Picture Setup** screen again, but any uploaded photo is already saved on the backend
- Onboarding questionnaire answers must be re-entered

### Slow network on save

If `saveOnboardingAnswers` takes a long time on the Completion screen:

- The "Go to Today" button shows a loading spinner (`isPending` from both mutations)
- The user cannot tap the button again while the request is in flight
- Calendar preferences (saved on the Privacy & Trust screen) use a fire-and-forget `mutate()` call, so that request runs independently

### Calendar permission changes later

If the user grants calendar permission during onboarding but later revokes it in device settings:

- The `calendarConnectedAtom` in local storage still reads `true`
- The backend `calendar_preferences` row still has `calendarConnected: true`
- The app would need to re-check permission status at runtime when accessing calendar features (outside the onboarding flow)
