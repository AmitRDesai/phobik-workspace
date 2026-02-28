# Auth & Account Creation — User Scenarios

## Scenario 1: First-Time User (Email Signup)

A brand new user opens the app for the first time.

1. App opens to the splash screen, then the **Welcome screen**
2. User taps "Next" and goes through a 7-step questionnaire:
   - Welcome, Philosophy, Age, Gender, Goals, Data Security, Terms
3. After accepting the Terms, user is taken to the **Create Account** screen
4. User enters their name, email, and password, then taps "Create Account"
   - Alternatively, the user can tap Google or Apple to sign up with their social account (skips email verification)
5. Account is created and a verification email is sent
6. User's profile (questionnaire answers) is saved to their account
7. User is taken to the **Email Verification** screen
8. User opens the verification email and clicks the link, which opens the app
9. A dialog appears: "Your email is verified"
10. User is taken to the **Onboarding** flow (aura selection, etc.)
11. After completing onboarding, user is taken to **Biometric Setup** (if available) or **Home**

**Key point:** The user must verify their email before reaching the Home screen.

---

## Scenario 2: First-Time User (Google/Apple Sign-In)

A brand new user opens the app and signs up using Google or Apple.

1. App opens to the **Welcome screen**
2. User taps "Sign In" to reach the **Sign In** screen
3. User taps Google or Apple sign-in
4. Account is created automatically
5. Since there's no profile yet, the user is shown a shorter **Profile Setup** flow:
   - Age, Gender, Goals, Data Security, Terms (5 steps)
6. After accepting the Terms, the profile is saved
7. User is taken to the **Onboarding** flow (aura selection, etc.)
8. After completing onboarding, user proceeds to **Biometric Setup** (if available) or **Home**

**Key point:** Social sign-in users skip the Welcome and Philosophy screens. They also skip email verification since their email is already verified by Google/Apple.

---

## Scenario 3: Returning User (Sign In After Sign Out)

A user who already has an account comes back after being signed out.

1. App opens to the **Sign In** screen (not Welcome, since they've used the app before)
2. User signs in with email/password, Google, Apple, or biometrics
3. The app finds their existing profile and takes them straight to **Home**

---

## Scenario 4: Completed Questionnaire, Then Signs In Instead

A user finishes all 7 questions, reaches the Create Account screen, but realizes they already have an account.

1. User taps "Already have an account? Sign In" on the Create Account screen
2. User signs in with their existing credentials
3. The app finds their existing profile and takes them to **Home**

**If they change their mind and tap "Sign Up" on Sign In:** They go back to the **Create Account** screen without having to redo the questionnaire.

---

## Scenario 5: Partially Completed Questionnaire, Then Tries to Sign Up

A user started the questionnaire but didn't finish all 7 steps, went to Sign In, then taps "Sign Up".

1. User is on the **Sign In** screen and taps "Sign Up"
2. Since the questionnaire wasn't fully completed, the flow restarts from the **Welcome screen**

**Key point:** Only finishing all 7 steps (through Terms) allows skipping directly to Create Account. Partial progress is not preserved.

---

## Scenario 6: Signed-Out User Taps Sign Up

A user who previously had an account is signed out and taps "Sign Up" instead of signing in.

1. User sees the **Sign In** screen and taps "Sign Up"
2. The full 7-step questionnaire starts from the **Welcome screen**
3. User can create a new account at the end

---

## Scenario 7: Biometric Sign-In (Quick Unlock)

A user who enabled Face ID or Touch ID and did a quick sign-out (not a full sign-out).

1. App opens to the **Sign In** screen with a biometric option visible
2. User taps the biometric icon and authenticates with Face ID / Touch ID
3. User is taken straight to **Home**

---

## Scenario 8: Full Sign Out, Then Social Sign-In

A user who fully signed out signs back in using Google or Apple.

1. User sees the **Sign In** screen
2. Signs in via Google or Apple
3. The app finds their existing profile and takes them to **Home**

---

## Scenario 9: Signing In on a New Device

A user created their account on one device and is now using the app on a different device.

1. App opens to the **Welcome screen** (fresh install)
2. User taps "Already have an account? Sign In" to reach the **Sign In** screen
3. User signs in with their email or social account
4. The app finds their existing profile and takes them to **Home**

---

## Edge Cases

### App closes unexpectedly during account creation

If the app is closed while the profile is being saved, on next launch the app will automatically retry saving the profile.

### App closes on the email verification screen

On next launch, the **Email Verification** screen is shown again. The user can resend the verification email or open their email app.

### Profile save fails (no internet, app crash, etc.)

If saving the profile fails, the questionnaire answers are kept locally. The app will retry saving automatically on next launch — the user is never asked to redo the questionnaire.

### Signing in with an unverified email

A new verification email is sent automatically. The user must verify their email before they can reach the Home screen.

### Repeated quick sign-in/sign-out

Quick (biometric) sign-in and sign-out cycles are lightweight and don't cause unnecessary loading or checks.
