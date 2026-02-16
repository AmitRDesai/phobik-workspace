# Auth & Account Creation Flow — Technical Reference

## State

### Session (from Better Auth)

Provided by the auth client. Not stored locally — derived from the active session.

| Field             | Type    | Description                                              |
| ----------------- | ------- | -------------------------------------------------------- |
| `isAuthenticated` | boolean | User has a valid session                                 |
| `emailVerified`   | boolean | Email has been verified (always `true` for Google/Apple) |

### Local State (persisted to AsyncStorage via Jotai `atomWithStorage`)

Defined in `src/modules/account-creation/store/account-creation.ts`.

| Atom                | Default                                                                              | Purpose                                                                                                                                                      |
| ------------------- | ------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `neverSignedInAtom` | `true`                                                                               | `true` for new users (show Welcome), set to `false` after first sign-in (show Sign In). Persists across sign-outs.                                           |
| `questionnaireAtom` | `{ age: null, gender: null, goals: [], termsAccepted: null, privacyAccepted: null }` | Questionnaire answers. `termsAccepted` and `privacyAccepted` are ISO date strings when accepted, `null` when not. Cleared after profile is saved to backend. |

### Derived State (from backend)

| Field        | Source                       | Description                                                                                                |
| ------------ | ---------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `hasProfile` | `profile.getProfileStatus()` | Whether the user has a profile on the backend. Checked once after sign-in, cached locally for the session. |

## Route Guards

The root layout (`src/app/_layout.tsx`) uses `Stack.Protected` guards evaluated in priority order. The splash screen stays visible until session and profile status are resolved.

| Priority | Guard                                            | Screen                        | Scenario                                                 |
| -------- | ------------------------------------------------ | ----------------------------- | -------------------------------------------------------- |
| 1        | Not authenticated, never signed in               | `/account-creation` (Welcome) | Fresh install (Scenarios 1, 2)                           |
| 2        | Not authenticated                                | `/auth` (Sign In)             | Returning user or signed-out user (Scenarios 3, 7, 8, 9) |
| 3        | Authenticated, email not verified                | `/email-verification`         | Email signup before verification (Scenario 1)            |
| 4        | Authenticated, no profile on backend, no local questionnaire data | `/profile-setup`  | Social auth without profile (Scenario 2)                 |
| 5        | Authenticated, needs biometric setup             | `/biometric-setup`            | One-time biometric prompt                                |
| 6        | Authenticated, fully set up                      | `/` (Home)                    | Normal usage                                             |

## Profile Recovery

If a profile save fails (network error, app crash, etc.), the `questionnaireAtom` is never cleared. On next launch, the root layout detects the local data and retries saving to the backend automatically. The questionnaire is never shown again while local data exists — the user only sees a loading/retry state.

## Email Verification Flow

After email signup, the user is taken to the **Email Verification** screen (`emailVerified = false`).

1. Verification email is sent automatically on signup (`sendOnSignUp: true`) and on sign-in (`sendOnSignIn: true`)
2. User clicks the verification link in the email, which deep-links back into the app
3. App shows a "Your email is verified" dialog
4. User proceeds to biometric setup (if available) or Home

Social auth users (Google/Apple) skip this entirely — `emailVerified` is always `true` for social accounts.

## Auth Layout

`src/app/auth/_layout.tsx` sets `initialRouteName` based on `neverSignedInAtom`:

- `false` (has signed in before) → `sign-in` (returning users)
- `true` (never signed in) → `create-account` (users coming from the questionnaire)

## Sign Up Button (SignIn Screen)

When a user taps "Sign Up" on the Sign In screen, the app checks `questionnaireAtom.termsAccepted`:

| State                                             | Action                                                                                        |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| Terms accepted (questionnaire completed)          | Go to Create Account screen (Scenario 4)                                                      |
| Terms not accepted (incomplete or returning user) | Clear questionnaire, set `neverSignedInAtom = true`, restart from Welcome (Scenarios 5, 6) |

## Sign Out

Two modes:

| Mode         | When                                             | What happens                                                                                                                             |
| ------------ | ------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Quick (soft) | Biometric enabled                                | Session preserved, user sees Sign In with biometric option (Scenario 7)                                                                  |
| Full         | Biometric disabled or user chooses full sign-out | Session destroyed, cached profile state cleared. `neverSignedInAtom` stays `false` so user sees Sign In, not Welcome (Scenarios 3, 6, 8) |

## Shared Question Screens

The question screens (Age, Gender, Goals, Data Security, Terms) are shared between two flows. Each screen detects which flow it's in via the current route path.

| Screen              | Account Creation (7 steps)      | Profile Setup (5 steps)                   |
| ------------------- | ------------------------------- | ----------------------------------------- |
| AgeSelection        | Step 3/7, has back button       | Step 1/5, no back button                  |
| GenderIdentity      | Step 4/7                        | Step 2/5                                  |
| GoalSelection       | Step 5/7                        | Step 3/5                                  |
| DataSecurityPromise | Step 6/7                        | Step 4/5                                  |
| TermsOfService      | Step 7/7 → go to Create Account | Step 5/5 → save profile to backend → Home |

## Backend API

Defined in `backend/src/rpc/procedures/profile.ts`, exposed via `backend/src/rpc/index.ts` under the `profile` namespace.

### `profile.saveProfile` (authorized)

Upserts the `user_profile` row. Called from:

- CreateAccount screen (email signup, Scenario 1)
- TermsOfService screen in profile-setup mode (social auth, Scenario 2)
- Root layout (auto-save on recovery, e.g., app killed mid-save)

```typescript
input: {
  ageRange: '18-24' | '25-34' | '35-44' | '45-54' | '55+' | null
  genderIdentity: 'female' | 'male' | 'non-binary' | 'prefer-not-to-say' | null
  goals: ('reduce-anxiety' | 'build-resilience' | 'improve-sleep' | 'face-social-fears' | 'daily-mindfulness')[]
  termsAccepted: string | null   // ISO date string
  privacyAccepted: string | null // ISO date string
}
```

### `profile.getProfileStatus` (authorized)

Returns `{ hasProfile: boolean }`. Called by the root layout to determine if the user needs profile setup.

## File Map

| File                                                     | Role                                                                |
| -------------------------------------------------------- | ------------------------------------------------------------------- |
| `src/app/_layout.tsx`                                    | Root navigator, guards, splash screen, profile sync                 |
| `src/app/auth/_layout.tsx`                               | Auth stack, conditional `initialRouteName`                          |
| `src/app/account-creation/_layout.tsx`                   | Account creation stack                                              |
| `src/app/profile-setup/_layout.tsx`                      | Profile setup stack                                                 |
| `src/modules/account-creation/store/account-creation.ts` | All persisted atoms                                                 |
| `src/modules/account-creation/screens/`                  | 7 screen components (shared with profile-setup)                     |
| `src/modules/auth/screens/SignIn.tsx`                    | Sign in + smart Sign Up routing                                     |
| `src/modules/auth/screens/CreateAccount.tsx`             | Email signup + Google/Apple social signup, saves profile to backend |
| `src/modules/auth/hooks/useAuth.ts`                      | Auth mutations (sign in/up/out)                                     |
| `backend/src/rpc/procedures/profile.ts`                  | `saveProfile` + `getProfileStatus`                                  |
| `backend/src/rpc/index.ts`                               | Router shape with `profile` namespace                               |
