# The Stress Compass — Technical Reference

## Overview

A slider-based assessment where users rate 10 life stressor categories on a 1–10 scale. Results are visualized as an orbital map grouping stressors into three rings (drained, moderate, balanced). The top 3 stressors are shown with biological explanations and practice recommendations. Originally part of the `daily-check-in` module, now fully decoupled into `self-check-ins`.

## Navigation Flow

```
AssessmentHub → StressCompass → StressSignatureMap → Home
```

| From                | Method    | To                        | Notes                           |
| ------------------- | --------- | ------------------------- | ------------------------------- |
| AssessmentHub       | `push`    | StressCompass             | Standard forward navigation     |
| StressCompass       | `replace` | StressSignatureMap        | Compass removed from stack      |
| StressSignatureMap  | `replace` | Home (`/`)                | Clears entire stack             |

## State Management

| Atom                       | Type                           | Persistence | Purpose                           |
| -------------------------- | ------------------------------ | ----------- | --------------------------------- |
| `stressorRatingsAtom`      | `Record<StressorKey, number>`  | In-memory   | Current ratings for all 10 stressors |
| `topStressorsAtom`         | derived                        | —           | Lowest 3 ratings (most drained)   |
| `resetStressCompassAtom`   | action                         | —           | Resets ratings to defaults        |

### Default Stressor Ratings

```typescript
{
  work: 5, financial: 2, relationships: 2, 'self-image': 5, time: 3,
  'inner-critic': 8, isolation: 5, fear: 3, purpose: 8, exhaustion: 7,
}
```

## Stressor Data

Defined in `data/stressors.ts`:

```typescript
type StressorKey = 'work' | 'financial' | 'relationships' | 'self-image'
  | 'time' | 'inner-critic' | 'isolation' | 'fear' | 'purpose' | 'exhaustion';

interface StressorCategory {
  key: StressorKey;
  label: string;
  icon: string;          // MaterialIcons name
  emoji: string;
  biologicalRoot: string;
  practice: { name: string; icon: string; description: string };
}
```

### Stressor Categories

| Key            | Label                      | Emoji | Icon                   |
| -------------- | -------------------------- | ----- | ---------------------- |
| work           | Work & Performance         | 💼    | trending-up            |
| financial      | Financial Security         | 💰    | account-balance-wallet |
| relationships  | Relationships & Conflict   | 💔    | diversity-3            |
| self-image     | Self Image and Comparison  | 🪞    | person-search          |
| time           | Time Scarcity              | 🕰    | timer-off              |
| inner-critic   | Inner Critic               | 💬    | psychology             |
| isolation      | Isolation and Loneliness   | 🧍    | group-off              |
| fear           | Unresolved Fear            | 💢    | warning                |
| purpose        | Lack of Purpose            | 🧍‍♀️  | explore                |
| exhaustion     | Exhaustion and Recovery    | 💤    | battery-1-bar          |

## Orbital Visualization

The `OrbitMap` SVG component positions stressors on three concentric rings:

| Ring   | Radius | Rating Range | Color           | Meaning  |
| ------ | ------ | ------------ | --------------- | -------- |
| Inner  | 35     | 7–10         | Cyan            | Balanced |
| Middle | 70     | 4–6          | Gray (#A6A5C1)  | Moderate |
| Outer  | 105    | 1–3          | Primary Pink    | Drained  |

Stressors are placed on their ring using pre-defined angle presets based on count per ring.

## Top 3 Stressors

Computed by `topStressorsAtom`: sort all ratings ascending, take the 3 lowest (most drained). Each result card shows:

1. Stressor label + emoji
2. Priority label with accent color
3. Biological root explanation
4. Recommended Phobik Practice with icon + description

## Components

| Component          | File                              | Purpose                            |
| ------------------ | --------------------------------- | ---------------------------------- |
| Slider             | `components/Slider.tsx`           | Reanimated gesture-based slider    |
| StressorCard       | (inline in StressCompass)         | Category card with slider          |
| OrbitMap           | (inline in StressSignatureMap)    | SVG orbital visualization          |
| StressNode         | (inline in StressSignatureMap)    | Single node on orbit ring          |
| StressorResultCard | (inline in StressSignatureMap)    | Top stressor detail card           |

## External Consumers

The `StressorKey` type and `STRESSOR_CATEGORIES` data are also imported by the **insights** module:

| File                                         | Import                  |
| -------------------------------------------- | ----------------------- |
| `modules/insights/data/stressor-details.ts`  | `StressorKey` type      |
| `modules/insights/components/TopStressorsRow.tsx` | `StressorKey` type  |
| `modules/insights/screens/StressorDetail.tsx` | `StressorKey` type      |

## File Map

| File                                                    | Role                            |
| ------------------------------------------------------- | ------------------------------- |
| `modules/self-check-ins/screens/StressCompass.tsx`       | Slider assessment screen        |
| `modules/self-check-ins/screens/StressSignatureMap.tsx`  | Orbital results + top 3 cards   |
| `modules/self-check-ins/data/stressors.ts`              | 10 stressor definitions         |
| `modules/self-check-ins/components/Slider.tsx`           | Gesture-driven slider component |
| `modules/self-check-ins/store/self-check-ins.ts`        | Stressor atoms + reset          |
| `app/practices/self-check-ins/stress-compass.tsx`        | Route re-export                 |
| `app/practices/self-check-ins/stress-signature-map.tsx`  | Route re-export                 |
