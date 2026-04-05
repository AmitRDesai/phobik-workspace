# Intimacy & Connection Quiz — Technical Reference

## Overview

A 7-question self-reflection quiz about balanced communication in relationships. Each question uses a 0–4 rating scale (Never to Always) with accompanying insight cards. State is managed locally via Jotai atoms and persisted to the backend on each "Next" tap.

## Navigation Flow

```
AssessmentHub → IntimacyIntro → IntimacyQuestion (×7) → IntimacyResults → (back) AssessmentHub
```

| From              | Method    | To                        | Notes                              |
| ----------------- | --------- | ------------------------- | ---------------------------------- |
| AssessmentHub     | `push`    | IntimacyIntro             | Standard forward navigation        |
| IntimacyIntro     | `replace` | IntimacyQuestion          | Intro removed from stack           |
| IntimacyQuestion  | in-place  | IntimacyQuestion          | Atom-driven, single screen         |
| IntimacyQuestion  | `replace` | IntimacyResults           | Question screen removed from stack |
| IntimacyResults   | `back`    | AssessmentHub             | Pops to existing hub in stack      |

## State Management

| Atom / Hook                    | Type                    | Persistence  | Purpose                        |
| ------------------------------ | ----------------------- | ------------ | ------------------------------ |
| `intimacyAnswersAtom`          | `Record<number, number>` | AsyncStorage | Maps question ID → answer (0–4) |
| `intimacyCurrentQuestionAtom`  | `number`                | In-memory    | Current question index (0-based) |
| `useInProgressAssessment('intimacy')` | derived          | React Query  | Finds active server-side state  |
| `useSaveAnswer()`              | mutation                | React Query  | Persists answer to backend      |
| `useCompleteAssessment()`      | mutation                | React Query  | Marks assessment as completed   |
| `useStartAssessment()`         | mutation                | React Query  | Creates or resumes assessment   |

## API Integration

| Procedure                       | When Called                    | Behavior                                  |
| ------------------------------- | ------------------------------ | ----------------------------------------- |
| `selfCheckIn.startAssessment`   | Intro → "Begin/Resume Quiz"   | Returns existing in-progress or creates new |
| `selfCheckIn.saveAnswer`        | Each "Next Question" tap       | Fire-and-forget, saves answer + index     |
| `selfCheckIn.completeAssessment`| Last question "Save Response"  | Marks status as `completed`               |
| `selfCheckIn.listAssessments`   | AssessmentHub mount            | Detects in-progress for resume button     |

### Resume Flow

1. `startAssessment({ type: 'intimacy' })` returns existing record with `answers` and `currentQuestion`
2. Intro screen writes API response into Jotai atoms
3. Question screen renders from restored atom state

## Question Data

Defined in `data/intimacy-questions.ts`:

```typescript
interface IntimacyQuestion {
  id: number;          // 1–7
  section: string;     // "Speaker Role"
  text: string;        // Question text
  insight: {
    title: string;     // "Why this matters"
    body: string;      // Explanation text
  };
}
```

Rating labels: `['Never', 'Rarely', 'Sometimes', 'Often', 'Always']` (indices 0–4)

## Results Scoring

| Score Range | Level                  |
| ----------- | ---------------------- |
| 75%+ (21+)  | Strong Communicator    |
| 50%+ (14+)  | Growing Communicator   |
| Below 50%   | Emerging Communicator  |

Total possible score: 28 (7 questions × 4 max)

## Components

| Component         | File                              | Purpose                                |
| ----------------- | --------------------------------- | -------------------------------------- |
| RatingScale       | `components/RatingScale.tsx`      | 5-circle rating selector (0–4 or 1–5) |
| QuestionProgress  | `components/QuestionProgress.tsx`  | Animated gradient progress bar         |
| InsightCard       | `components/InsightCard.tsx`      | "Why this matters" glass card          |

## File Map

| File                                               | Role                         |
| -------------------------------------------------- | ---------------------------- |
| `modules/self-check-ins/screens/IntimacyIntro.tsx`  | Intro screen with mandala    |
| `modules/self-check-ins/screens/IntimacyQuestion.tsx` | Question screen (atom-driven) |
| `modules/self-check-ins/screens/IntimacyResults.tsx`  | Score breakdown screen       |
| `modules/self-check-ins/data/intimacy-questions.ts`   | 7 questions + insights       |
| `modules/self-check-ins/store/self-check-ins.ts`      | Jotai atoms                  |
| `modules/self-check-ins/hooks/useSelfCheckIn.ts`      | React Query hooks            |
| `app/practices/self-check-ins/intimacy-intro.tsx`     | Route re-export              |
| `app/practices/self-check-ins/intimacy-question.tsx`  | Route re-export              |
| `app/practices/self-check-ins/intimacy-results.tsx`   | Route re-export              |
