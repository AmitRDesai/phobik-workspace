# Assessment Hub — Technical Reference

## Overview

The Assessment Hub is the entry point for all self check-in assessments. It displays three assessment cards and detects in-progress state from the backend to show a resume option.

## Navigation

| From                  | Action                  | To                                         |
| --------------------- | ----------------------- | ------------------------------------------ |
| Growth Hub            | Tap "Self Check Ins"    | `/practices/self-check-ins` (AssessmentHub) |
| AssessmentHub         | Tap Intimacy card       | `/practices/self-check-ins/intimacy-intro`  |
| AssessmentHub         | Tap Pivot Point card    | `/practices/self-check-ins/pivot-point-intro` |
| AssessmentHub         | Tap Stress Compass card | `/practices/self-check-ins/stress-compass`  |
| AssessmentHub         | Back arrow              | Previous screen (Growth Hub)                |

## State Management

| Source          | Hook / Atom               | Purpose                                      |
| --------------- | ------------------------- | -------------------------------------------- |
| React Query     | `useAssessmentList()`     | Fetches all assessments for the current user  |
| Derived         | `getInProgress(type)`     | Checks if an in-progress assessment exists    |

## API Calls

| Procedure                          | When Called       | Purpose                         |
| ---------------------------------- | ----------------- | ------------------------------- |
| `selfCheckIn.listAssessments`      | Screen mount      | Load all assessments for user   |

## Data

Assessment metadata is defined in `data/assessments.ts`:

| Field         | Type       | Description                            |
| ------------- | ---------- | -------------------------------------- |
| `id`          | string     | `intimacy`, `pivot-point`, `stress-compass` |
| `title`       | string     | Display title                          |
| `description` | string     | Short description                      |
| `icon`        | IconDef    | MaterialIcons or Ionicons icon         |
| `route`       | string     | Navigation route path                  |

## Components

| Component       | File                           | Purpose                                |
| --------------- | ------------------------------ | -------------------------------------- |
| AssessmentCard  | `components/AssessmentCard.tsx` | Card with icon, title, description, CTA |
| CourageHeader   | `courage/components/CourageHeader.tsx` | Shared header with back button   |

### AssessmentCard Props

| Prop           | Type     | Description                                |
| -------------- | -------- | ------------------------------------------ |
| `assessment`   | AssessmentMeta | Card content data                    |
| `isInProgress` | boolean  | Shows "Resume" instead of "Start Test"     |
| `onPress`      | function | Navigation handler                         |

## File Map

| File                                              | Role                        |
| ------------------------------------------------- | --------------------------- |
| `modules/self-check-ins/screens/AssessmentHub.tsx` | Hub screen                  |
| `modules/self-check-ins/components/AssessmentCard.tsx` | Card component          |
| `modules/self-check-ins/data/assessments.ts`       | Assessment metadata         |
| `modules/self-check-ins/hooks/useSelfCheckIn.ts`   | React Query hooks           |
| `app/practices/self-check-ins/index.tsx`           | Route re-export             |
| `app/practices/self-check-ins/_layout.tsx`         | Stack layout                |
