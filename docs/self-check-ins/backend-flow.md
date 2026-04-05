# Self Check-Ins Backend — Technical Reference

## Overview

Server-side persistence for assessment progress and history. Each assessment attempt is stored as a row in the `self_check_in` table with its type, status, current question index, and full answer map. This enables resume-from-where-you-left-off and historical record of all completed assessments.

## Database Schema

**Table:** `self_check_in`

| Column             | Type                    | Default       | Notes                                      |
| ------------------ | ----------------------- | ------------- | ------------------------------------------ |
| `id`               | `text` (PK)             | UUID          | Auto-generated                             |
| `user_id`          | `text` (FK → user.id)   | —             | Cascade on delete                          |
| `type`             | `assessment_type` enum  | —             | `intimacy`, `pivot-point`, `stress-compass` |
| `status`           | `assessment_status` enum| `in_progress` | `in_progress`, `completed`                 |
| `current_question` | `integer`               | `0`           | 0-based question index                     |
| `answers`          | `jsonb`                 | `{}`          | `Record<string, number>` — question ID → answer |
| `started_at`       | `timestamp`             | `now()`       | When the assessment was created            |
| `completed_at`     | `timestamp`             | `null`        | Set when status becomes `completed`        |
| `created_at`       | `timestamp`             | `now()`       | Row creation time                          |
| `updated_at`       | `timestamp`             | `now()`       | Last modification time                     |

### Indexes

| Name                           | Columns               | Purpose                          |
| ------------------------------ | --------------------- | -------------------------------- |
| `self_check_in_user_type_idx`  | `user_id`, `type`     | Fast lookup by user + assessment type |
| `self_check_in_user_status_idx`| `user_id`, `status`   | Fast lookup for in-progress detection |

### Enums

| Enum Name           | Values                                      |
| ------------------- | ------------------------------------------- |
| `assessment_type`   | `intimacy`, `pivot-point`, `stress-compass`  |
| `assessment_status` | `in_progress`, `completed`                   |

## RPC Procedures

All procedures require authentication (`authorized` base).

### `selfCheckIn.startAssessment`

**Input:** `{ type: 'intimacy' | 'pivot-point' | 'stress-compass' }`

**Behavior:**
1. Checks for an existing `in_progress` assessment of the given type for the user
2. If found, returns it (enables resume)
3. If not found, creates a new row and returns it

**Returns:** Full `self_check_in` row

### `selfCheckIn.saveAnswer`

**Input:** `{ id: string, questionId: number, answer: number, currentQuestion: number }`

**Behavior:**
1. Verifies assessment exists, belongs to user, and is `in_progress`
2. Merges the new answer into the existing `answers` JSONB
3. Updates `currentQuestion` and `updatedAt`

**Returns:** `{ success: true }`

**Note:** Called as fire-and-forget from the frontend — does not block UI.

### `selfCheckIn.completeAssessment`

**Input:** `{ id: string }`

**Behavior:**
1. Verifies assessment exists and belongs to user
2. Sets `status` to `completed` and `completedAt` to now

**Returns:** Updated `self_check_in` row

### `selfCheckIn.listAssessments`

**Input:** None

**Behavior:** Returns all assessments for the current user ordered by `updatedAt` descending.

**Returns:** Array of `self_check_in` rows

**Used by:** AssessmentHub to detect in-progress assessments for resume buttons.

### `selfCheckIn.getAssessment`

**Input:** `{ id: string }`

**Behavior:** Returns a single assessment by ID (with user ownership check).

**Returns:** `self_check_in` row or `null`

### `selfCheckIn.abandonAssessment`

**Input:** `{ id: string }`

**Behavior:** Deletes an `in_progress` assessment (user ownership + status check). Allows starting fresh.

**Returns:** `{ success: true }`

## Frontend Integration

| Frontend Hook              | Calls Procedure          | Trigger                          |
| -------------------------- | ------------------------ | -------------------------------- |
| `useAssessmentList()`      | `listAssessments`        | AssessmentHub mount (query)      |
| `useStartAssessment()`     | `startAssessment`        | Intro screen "Begin/Resume" tap  |
| `useSaveAnswer()`          | `saveAnswer`             | Each "Next Question" tap         |
| `useCompleteAssessment()`  | `completeAssessment`     | Final question submit            |
| `useAbandonAssessment()`   | `abandonAssessment`      | (Available for future use)       |
| `useInProgressAssessment(type)` | (derived from list) | Resume detection in hub + intros |

## File Map

| File                                                    | Role                       |
| ------------------------------------------------------- | -------------------------- |
| `backend/src/db/schema/self-check-in.ts`                | Database schema definition |
| `backend/src/db/schema/index.ts`                        | Barrel export (updated)    |
| `backend/src/rpc/procedures/self-check-in.ts`           | RPC procedure handlers     |
| `backend/src/rpc/index.ts`                              | Router wiring (updated)    |
| `app/src/modules/self-check-ins/hooks/useSelfCheckIn.ts`| React Query hooks          |

## Migration

Run after deploying:

```bash
cd backend
bun run db:generate
bun run db:migrate
```
