# The Pivot Point Assessment — Technical Reference

## Overview

A 50-question assessment measuring stress response patterns across 5 sections. Each question maps to one of 5 pattern archetypes (Pusher, Escaper, Freezer, Pleaser, Regulator). Uses a 1–5 rating scale. Results compute pattern scores, identify primary/secondary patterns, and calculate a regulation score.

## Navigation Flow

```
AssessmentHub → PivotPointIntro → PivotPointQuestion (×50) → PivotPointResults → (back) AssessmentHub
```

| From               | Method    | To                       | Notes                              |
| ------------------ | --------- | ------------------------ | ---------------------------------- |
| AssessmentHub      | `push`    | PivotPointIntro          | Standard forward navigation        |
| PivotPointIntro    | `replace` | PivotPointQuestion       | Intro removed from stack           |
| PivotPointQuestion | in-place  | PivotPointQuestion       | Atom-driven, single screen         |
| PivotPointQuestion | `replace` | PivotPointResults        | Question screen removed from stack |
| PivotPointResults  | `back`    | AssessmentHub            | Pops to existing hub in stack      |

## State Management

| Atom / Hook                         | Type                     | Persistence  | Purpose                          |
| ----------------------------------- | ------------------------ | ------------ | -------------------------------- |
| `pivotPointAnswersAtom`             | `Record<number, number>` | AsyncStorage | Maps question ID → answer (1–5)  |
| `pivotPointCurrentQuestionAtom`     | `number`                 | In-memory    | Current question index (0-based) |
| `useInProgressAssessment('pivot-point')` | derived             | React Query  | Finds active server-side state   |
| `useSaveAnswer()`                   | mutation                 | React Query  | Persists answer to backend       |
| `useCompleteAssessment()`           | mutation                 | React Query  | Marks assessment as completed    |

## API Integration

| Procedure                       | When Called                     | Behavior                                   |
| ------------------------------- | ------------------------------- | ------------------------------------------ |
| `selfCheckIn.startAssessment`   | Intro → "Start/Resume"         | Returns existing in-progress or creates new |
| `selfCheckIn.saveAnswer`        | Each "Next Question" tap        | Fire-and-forget mutation                   |
| `selfCheckIn.completeAssessment`| Last question "See Results"     | Marks status as `completed`                |

## Question Data

Defined in `data/pivot-point-questions.ts`:

```typescript
type PivotPattern = 'pusher' | 'escaper' | 'freezer' | 'pleaser' | 'regulator';

interface PivotSection {
  id: number;       // 1–5
  title: string;    // e.g., "Your First Reaction"
  subtitle: string; // e.g., "When something stressful happens…"
}

interface PivotQuestion {
  id: number;            // 1–50
  sectionId: number;     // Links to section
  text: string;          // Question text
  pattern: PivotPattern; // Which pattern this maps to
}
```

### Section Breakdown

| Section | Title                    | Questions |
| ------- | ------------------------ | --------- |
| 1       | Your First Reaction      | 1–10      |
| 2       | Thought Patterns         | 11–20     |
| 3       | Behavior Under Pressure  | 21–30     |
| 4       | Recovery & Regulation    | 31–40     |
| 5       | Courage & Action         | 41–50     |

### Pattern Mapping

Each pattern has exactly 10 questions (2 per section). Within each section of 10 questions, the pattern order is: Pusher, Escaper, Freezer, Pleaser, Regulator (repeated twice).

## Scoring Logic

Implemented in `hooks/usePivotPointScoring.ts`:

```typescript
interface PivotPointResults {
  scores: Record<PivotPattern, number>;      // Raw sum (10–50)
  percentages: Record<PivotPattern, number>; // 0–100
  primaryPattern: PivotPattern;              // Highest score
  secondaryPattern: PivotPattern;            // Second highest
  regulationScore: number;                   // Regulator percentage
}
```

| Step | Calculation                                        |
| ---- | -------------------------------------------------- |
| 1    | Sum all answers for each pattern (10 questions each) |
| 2    | Convert to percentage: `score × 2` (max raw = 50)  |
| 3    | Primary = highest percentage                        |
| 4    | Secondary = second highest                          |
| 5    | Regulation score = regulator percentage              |

## Pattern Archetypes

Defined in `data/pivot-point-patterns.ts`:

| Pattern    | Label         | Emoji | Strength              | Growth Edge                |
| ---------- | ------------- | ----- | --------------------- | -------------------------- |
| pusher     | The Pusher    | 🔥    | Driven, proactive     | Slowing down, feeling more |
| escaper    | The Escaper   | 🏃    | Protects energy       | Taking small action        |
| freezer    | The Freezer   | 🧊    | Sensitive, aware      | Safe activation            |
| pleaser    | The Pleaser   | 🤝    | Empathetic, relational| Boundaries + self-trust    |
| regulator  | The Regulator | 🌊    | Balanced, resilient   | Continued expansion        |

## Components

| Component            | File                                  | Purpose                           |
| -------------------- | ------------------------------------- | --------------------------------- |
| RatingScale          | `components/RatingScale.tsx`          | 5-circle selector (shared)        |
| QuestionProgress     | `components/QuestionProgress.tsx`     | Animated bar with percentage mode |
| PatternResultCard    | `components/PatternResultCard.tsx`    | Primary/secondary pattern display |
| RegulationScoreRing  | `components/RegulationScoreRing.tsx`  | SVG circular progress indicator   |

## File Map

| File                                                   | Role                          |
| ------------------------------------------------------ | ----------------------------- |
| `modules/self-check-ins/screens/PivotPointIntro.tsx`    | Intro screen                  |
| `modules/self-check-ins/screens/PivotPointQuestion.tsx` | Question screen (atom-driven) |
| `modules/self-check-ins/screens/PivotPointResults.tsx`  | Results with pattern cards    |
| `modules/self-check-ins/data/pivot-point-questions.ts`  | 50 questions + 5 sections     |
| `modules/self-check-ins/data/pivot-point-patterns.ts`   | 5 pattern archetypes          |
| `modules/self-check-ins/hooks/usePivotPointScoring.ts`  | Scoring logic                 |
| `modules/self-check-ins/store/self-check-ins.ts`        | Jotai atoms                   |
| `app/practices/self-check-ins/pivot-point-intro.tsx`    | Route re-export               |
| `app/practices/self-check-ins/pivot-point-question.tsx` | Route re-export               |
| `app/practices/self-check-ins/pivot-point-results.tsx`  | Route re-export               |
