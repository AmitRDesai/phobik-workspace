# Auth & Account Creation Flow — Technical Reference

## State

### Session (from Better Auth)

Provided by the auth client. Not stored locally — derived from the active session.

| Field             | Type    | Description                                              |
| ----------------- | ------- | -------------------------------------------------------- |
| `isAuthenticated` | boolean | User has a valid session and is not soft-signed-out      |
| `emailVerified`   | boolean | Email has been verified (always `true` for Google/Apple) |

### Local State (persisted to AsyncStorage via Jotai `atomWithStorage`)

| Atom                       | Default | Location                                                | Purpose                                                                                                    |
| -------------------------- | ------- | ------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `isReturningUserAtom`      | `false` | `src/store/user.ts`                                     | `false` for new users (show Welcome), set to `true` after first authentication. Persists across sign-outs. |
| `questionnaireAtom`        | (below) | `src/modules/account-creation/store/account-creation.ts` | Questionnaire answers. Cleared after profile is saved to backend.                                          |
| `biometricEnabledAtom`     | `false` | `src/modules/auth/store/biometric.ts`                   | Whether the user enabled biometric auth. Reset on full sign-out.                                           |
| `biometricPromptShownAtom` | `false` | `src/modules/auth/store/biometric.ts`                   | Whether the biometric setup screen was ever shown. Persists across sign-outs.                              |
| `isSignedOutAtom`          | `false` | `src/modules/auth/store/biometric.ts`                   | Soft sign-out flag. `true` = session preserved but app locked.                                             |

**Questionnaire atom default:**

```typescript
{ age: null, gender: null, goals: [], termsAcceptedAt: null, privacyAcceptedAt: null }
```

`termsAcceptedAt` and `privacyAcceptedAt` are ISO date strings when accepted, `null` when not.

### Derived State (from backend)

| Field                 | Source                       | Description                                         |
| --------------------- | ---------------------------- | --------------------------------------------------- |
| `hasProfile`          | `profile.getProfileStatus()` | Whether the user has a profile on the backend.      |
| `onboardingCompleted` | `profile.getProfileStatus()` | Whether the user has completed the onboarding flow. |

## Route Guards

The root layout (`src/app/_layout.tsx`) uses `Stack.Protected` guards. `useAppInitializer` computes an `activeStack` value that determines which guard is active. The splash screen stays visible until session and profile status are resolved.

### Guard Priority (evaluated in `useAppInitializer`)

```typescript
if (!isAuthenticated) return 'auth';
if (!hasProfile)      return 'profile-setup';
if (!emailVerified)   return 'email-verification';
if (!onboardingCompleted) return 'onboarding';
if (!biometricPromptShown && biometricAvailable) return 'biometric-setup';
return 'home';
```

| Priority | `activeStack`        | Screen                        | Condition                                     |
| -------- | -------------------- | ----------------------------- | --------------------------------------------- |
| 1        | `auth`               | `/account-creation` (Welcome) | Not authenticated, new user (`!isReturningUser`) |
| 2        | `auth`               | `/auth` (Sign In)             | Not authenticated, returning user             |
| 3        | `profile-setup`      | `/profile-setup`              | Authenticated, no profile                     |
| 4        | `email-verification` | `/email-verification`         | Authenticated, email not verified             |
| 5        | `onboarding`         | `/onboarding`                 | Authenticated, onboarding not completed       |
| 6        | `biometric-setup`    | `/biometric-setup`            | Authenticated, biometric not prompted         |
| 7        | `home`               | `/` (Home)                    | Authenticated, fully set up                   |

Priorities 1 and 2 share the same `activeStack` value (`'auth'`). The distinction between new and returning users is handled by a nested guard — see below.

### Nested Auth Guards

The unauthenticated state uses nested `Stack.Protected` blocks to control which screen appears first:

```tsx
<Stack.Protected guard={activeStack === 'auth'}>
  <Stack.Protected guard={!isReturningUser}>
    <Stack.Screen name="account-creation" />
  </Stack.Protected>
  <Stack.Screen name="auth" />
</Stack.Protected>
```

- **New user** (`!isReturningUser`): Inner guard passes → `account-creation` is accessible and listed first → user sees the Welcome screen. The `auth` stack is also available for navigation.
- **Returning user** (`isReturningUser`): Inner guard fails → `account-creation` is removed → `auth` (Sign In) is the only screen and becomes the fallback.
- **"Sign Up" from Sign In**: Sets `isReturningUserAtom = false`, which flips the inner guard and re-enables `account-creation`.

## Readiness & Splash Screen

`useAppInitializer` holds the splash screen until `dataResolved`:

```typescript
const dataResolved = !isSessionLoading && (!isAuthenticated || !isProfileChecking);
```

- Unauthenticated: resolves as soon as session loading finishes (no profile check needed).
- Authenticated: waits for both session and profile status.

The `activeStack` value is held in a ref and only updated once data resolves, preventing guard flicker during loading.

## Profile Recovery

If a profile save fails (network error, app crash), the `questionnaireAtom` is never cleared. On next launch, `useAppInitializer` detects local data (`age` + `termsAcceptedAt` present) and automatically retries `saveProfile`. On success, the questionnaire atom is reset.

## Email Verification Flow

After email signup, the guard routes to the Email Verification screen (`emailVerified = false`).

1. Verification email sent automatically on signup (`sendOnSignUp: true`) and on sign-in (`sendOnSignIn: true`)
2. User clicks the verification link in the email, which deep-links back into the app
3. App detects verification on foreground return via `AppState` listener calling `getSession({ disableCookieCache: true })`
4. App shows a "Your email is verified" dialog
5. Guard re-evaluates → user proceeds to onboarding, then biometric setup (if available), then Home

Social auth users (Google/Apple) skip this entirely — `emailVerified` is always `true`.

## Auth Layout

`src/app/auth/_layout.tsx` uses `initialRouteName="sign-in"`. The Create Account screen is navigated to explicitly (from the questionnaire's last step or from Sign In's "Sign Up" handler). Modal screens for Terms of Service and Privacy Policy are also registered here.

## Sign Up Button (Sign In Screen)

When a returning user taps "Sign Up" on the Sign In screen, the handler checks `questionnaireAtom.termsAcceptedAt`:

| State                                             | Action                                                                        |
| ------------------------------------------------- | ----------------------------------------------------------------------------- |
| Terms accepted (questionnaire completed)          | Navigate to `/auth/create-account`                                            |
| Terms not accepted (incomplete or returning user)  | Set `isReturningUserAtom = false`, reset questionnaire, navigate to `/account-creation` |

Setting `isReturningUserAtom = false` flips the nested guard, making the `account-creation` stack accessible again.

## Sign Out

Two modes:

| Mode         | When                                             | What happens                                                                                              |
| ------------ | ------------------------------------------------ | --------------------------------------------------------------------------------------------------------- |
| Quick (soft) | Biometric enabled                                | Session preserved, `isSignedOutAtom = true`. User sees Sign In with biometric option.                     |
| Full         | Biometric disabled or user chooses full sign-out | Session destroyed, query cache cleared. `biometricEnabledAtom` reset. `isReturningUserAtom` stays `true`. |

**Note:** `biometricPromptShownAtom` is NOT reset on full sign-out, so returning users are never re-prompted for biometric setup.

### Soft Sign-Out Behavior

When `isSignedOutAtom = true` and the session still exists:
- `isAuthenticated` is `false` (session exists but user is "signed out")
- Sign In screen shows only the biometric button (credentials form is hidden)
- Successful biometric auth sets `isSignedOutAtom = false`, restoring the session

## Shared Question Screens

The question screens (Age, Gender, Goals, Data Security, Terms) are shared between two flows. Each screen detects which flow it's in via `usePathname()`.

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

- CreateAccount screen (email signup after `signUp.email`)
- CreateAccount screen (social signup via Google/Apple after `signIn.social`)
- TermsOfService screen in profile-setup mode (social auth user who didn't go through account creation)
- `useAppInitializer` auto-recovery (app killed mid-save)

```typescript
input: {
  ageRange: '18-24' | '25-34' | '35-44' | '45-54' | '55+' | null
  genderIdentity: 'female' | 'male' | 'non-binary' | 'prefer-not-to-say' | null
  goals: ('reduce-anxiety' | 'build-resilience' | 'improve-sleep' | 'face-social-fears' | 'daily-mindfulness')[]
  termsAcceptedAt: string | null   // ISO date string
  privacyAcceptedAt: string | null // ISO date string
}
```

### `profile.getProfileStatus` (authorized)

Returns `{ hasProfile: boolean, onboardingCompleted: boolean }`. Called by `useAppInitializer` to determine routing.

### `profile.completeOnboarding` (authorized)

Sets `onboardingCompletedAt` timestamp on the user profile. Called after the user finishes the onboarding flow.

### `profile.uploadProfilePicture` (authorized)

Accepts a base64 image (JPEG/PNG/WebP), uploads to storage, and updates the user's `image` field.

## File Map

| File                                                     | Role                                                                     |
| -------------------------------------------------------- | ------------------------------------------------------------------------ |
| `src/app/_layout.tsx`                                    | Root navigator, `Stack.Protected` guards, splash screen                  |
| `src/hooks/useAppInitializer.ts`                         | Computes `activeStack`, profile sync, auto-recovery, exposes `isReturningUser` |
| `src/app/auth/_layout.tsx`                               | Auth stack, `initialRouteName="sign-in"`, modal screens                  |
| `src/app/account-creation/_layout.tsx`                   | Account creation stack                                                   |
| `src/app/profile-setup/_layout.tsx`                      | Profile setup stack                                                      |
| `src/modules/account-creation/store/account-creation.ts` | `questionnaireAtom` (persisted)                                          |
| `src/modules/auth/store/biometric.ts`                    | `biometricEnabledAtom`, `biometricPromptShownAtom`, `isSignedOutAtom`    |
| `src/store/user.ts`                                      | `isReturningUserAtom` (persisted)                                        |
| `src/modules/account-creation/screens/`                  | 7 screen components (shared with profile-setup)                          |
| `src/modules/auth/screens/SignIn.tsx`                     | Sign in + biometric unlock + smart Sign Up routing                       |
| `src/modules/auth/screens/CreateAccount.tsx`              | Email signup + Google/Apple social signup, saves profile to backend      |
| `src/modules/auth/screens/EmailVerification.tsx`          | Email verification with foreground detection + resend cooldown           |
| `src/modules/auth/hooks/useAuth.ts`                       | Auth mutations (sign in/up/out, Google, Apple)                           |
| `src/modules/auth/hooks/useProfile.ts`                    | `useProfileStatus` query + `useSaveProfile` mutation                     |
| `backend/src/rpc/procedures/profile.ts`                   | `saveProfile`, `getProfileStatus`, `completeOnboarding`, `uploadProfilePicture` |
| `backend/src/rpc/index.ts`                                | Router with `profile` namespace, exports `AppRouter` type                |
