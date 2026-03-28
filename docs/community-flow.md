# Community (Courage Wall) — Technical Reference

## Overview

The Community feature is a social courage wall where users share brave moments, support each other with reactions, and browse posts with search and filtering. Users must join the community (accepting principles) before accessing the feed. Posts support multiple image attachments, anonymous posting, and age-circle tagging. The feed uses cursor-based infinite scrolling with auto-refresh on tab focus and manual pull-to-refresh.

## Screen Sequence

| Screen         | Route                | Component              | Purpose                                          |
| -------------- | -------------------- | ---------------------- | ------------------------------------------------ |
| Community      | `/(tabs)/community`  | `Community`            | Join gate or feed (conditional render)           |
| Create Post    | `/community/create`  | `CreatePost`           | Compose and submit a new post                    |

## State

### Jotai Atoms (client state)

| Atom                        | Type                  | Persisted | Location                                         | Purpose                            |
| --------------------------- | --------------------- | --------- | ------------------------------------------------ | ---------------------------------- |
| `communitySearchAtom`       | `string`              | No        | `src/modules/community/store/community.ts`       | Current search input text          |
| `communityCircleFilterAtom` | `string \| undefined` | No        | `src/modules/community/store/community.ts`       | Selected circle filter             |

### React Query (server state)

| Hook                    | RPC Procedure                | Purpose                                       |
| ----------------------- | ---------------------------- | --------------------------------------------- |
| `useCommunityMember`    | `community.isMember`         | Check if current user has joined               |
| `useJoinCommunity`      | `community.joinCommunity`    | Join the community (insert membership)         |
| `useCommunityPosts`     | `community.listPosts`        | Infinite query for paginated feed              |
| `useCreatePost`         | `community.createPost`       | Create a new post with optional images         |
| `useToggleReaction`     | `community.toggleReaction`   | Add or remove a reaction on a post             |

## Database Schema

### community_member

| Column     | Type       | Notes                                        |
| ---------- | ---------- | -------------------------------------------- |
| id         | text PK    | UUID, auto-generated                         |
| userId     | text FK    | References user.id, cascade delete, unique   |
| joinedAt   | timestamp  | Not null, default now                        |

### community_post

| Column      | Type       | Notes                                        |
| ----------- | ---------- | -------------------------------------------- |
| id          | text PK    | UUID, auto-generated                         |
| userId      | text FK    | References user.id, cascade delete           |
| content     | text       | Not null, max 500 chars (Zod validated)      |
| images      | jsonb      | Nullable, array of S3 object keys            |
| circle      | text       | Nullable — "18-24", "25-34", "35-44", "45-54", "55+" |
| isAnonymous | boolean    | Not null, default false                      |
| createdAt   | timestamp  | Not null, default now                        |
| updatedAt   | timestamp  | Not null, default now                        |

Index on `createdAt` for pagination ordering.

### community_reaction

| Column     | Type       | Notes                                        |
| ---------- | ---------- | -------------------------------------------- |
| id         | text PK    | UUID, auto-generated                         |
| postId     | text FK    | References community_post.id, cascade delete |
| userId     | text FK    | References user.id, cascade delete           |
| type       | text       | Not null — one of: i_see_you, youve_got_this, not_alone, keep_going, courage_moment |
| createdAt  | timestamp  | Not null, default now                        |

Unique constraint on (postId, userId, type) — one reaction per type per user per post.

## Image Storage

Images follow the same pattern as profile pictures:

- S3 object keys are stored in the database (not full URLs)
- Keys follow the format: `community-posts/{userId}/{timestamp}-{index}.{ext}`
- `resolveImageUrl()` converts keys to full URLs at read time
- Upload uses `lib/storage.ts` `uploadFile()` with base64-encoded image data
- Frontend converts image URIs to base64 using `expo-file-system`'s `File` class
- Accepted MIME types: `image/jpeg`, `image/png`, `image/webp`
- Maximum 5 images per post

## Pagination

### Cursor-based infinite scroll

- `listPosts` accepts an optional `cursor` (ISO timestamp string) and `limit` (default 15, max 50)
- Fetches `limit + 1` rows ordered by `createdAt DESC`
- If more than `limit` rows returned, `nextCursor` is the `createdAt` of the last included row
- If exactly `limit` or fewer rows, `nextCursor` is `null` (no more pages)
- Frontend uses `useInfiniteQuery` with oRPC's `.infiniteOptions()` API
- `initialPageParam` is `undefined` (first page has no cursor)
- `getNextPageParam` returns `nextCursor` from the last page
- `fetchNextPage` is guarded by `!isFetching && hasNextPage` (TanStack v5 best practice)
- `onEndReachedThreshold={0.5}` triggers prefetch when 50% from the bottom

### Refresh behavior

- **Pull-to-refresh**: Manual `RefreshControl` with local `refreshing` state — spinner only shows during user-initiated pulls
- **Auto-refresh on tab focus**: `useFocusEffect` calls `refetch()` when the Community tab becomes active (skips first mount to avoid double-fetch)
- **Refetch on window focus**: `refetchOnWindowFocus: true` in query options

## Search and Filtering

- Search input is debounced (300ms) before triggering a query refetch
- `communitySearchAtom` holds the raw input, `debouncedSearch` state holds the query value
- Search uses `ilike` on `content` column (case-insensitive partial match)
- Circle filter is an exact match on the `circle` column
- Both can be combined — query applies all active conditions with `AND`

## Reactions

### Five reaction types

| Type            | Emoji | Label           |
| --------------- | ----- | --------------- |
| i_see_you       | ❤️    | I see you       |
| youve_got_this  | 💪    | You've got this |
| not_alone       | 🤝    | Not alone       |
| keep_going      | 🌱    | Keep going      |
| courage_moment  | 🔥    | Courage moment  |

### Toggle behavior

- `toggleReaction` checks if the reaction exists for (postId, userId, type)
- If it exists → deletes it; if not → inserts it
- Returns updated reaction counts and the user's current reactions for that post
- Frontend invalidates the feed query on settle
- Counts are formatted with `formatCount()`: 999 → "999", 1500 → "1.5K", 1500000 → "1.5M"

## Join Flow

- `dialog.open({ component: CommunityPrinciples })` renders the principles inside the existing bottom sheet dialog system
- The `CommunityPrinciples` component receives a `close` prop from the dialog
- On "I Understand & Join" tap, calls `joinCommunity` mutation then `close(true)`
- `joinCommunity` uses `onConflictDoNothing` — safe to call multiple times
- After joining, `isMember` query invalidates and the feed renders

## Fullscreen Image Viewer

- `ImageViewer` component uses a `Modal` with `animationType="fade"`
- `FlatList` with `pagingEnabled` for swipeable image navigation
- `getItemLayout` provides fixed dimensions for smooth scrolling
- Counter shows `{current} / {total}` when multiple images
- Close button in top right with safe area inset

## RPC Procedures

All procedures use the `authorized` middleware (require valid session).

| Procedure         | Input                                                           | Description                                      |
| ----------------- | --------------------------------------------------------------- | ------------------------------------------------ |
| `joinCommunity`   | —                                                               | Insert membership, no-op if already joined       |
| `isMember`        | —                                                               | Check if current user is a member                |
| `listPosts`       | cursor?, limit?, search?, circle?                               | Cursor-paginated feed with search/filter         |
| `createPost`      | content, circle?, isAnonymous?, images?[]                       | Create post, upload images to S3                 |
| `toggleReaction`  | postId, type                                                    | Add or remove reaction, return updated counts    |

### listPosts response shape

```typescript
{
  posts: Array<{
    id: string;
    content: string;
    images: (string | null)[];  // resolved URLs
    circle: string | null;
    isAnonymous: boolean;
    createdAt: string;          // ISO timestamp
    author: { name: string; image: string | null };
    reactions: Record<string, number>;
    userReactions: string[];    // types the current user has reacted with
  }>;
  nextCursor: string | null;   // null = no more pages
}
```

## Components

| Component              | File                                                          | Purpose                                    |
| ---------------------- | ------------------------------------------------------------- | ------------------------------------------ |
| `Community`            | `src/modules/community/screens/Community.tsx`                 | Main screen — join gate or feed             |
| `CreatePost`           | `src/modules/community/screens/CreatePost.tsx`                | Post creation with images + settings        |
| `CommunityPrinciples`  | `src/modules/community/components/CommunityPrinciples.tsx`    | Join dialog content (6 principles + CTA)    |
| `FeedCard`             | `src/modules/community/components/FeedCard.tsx`               | Post card with reactions and image viewer    |
| `SearchBar`            | `src/modules/community/components/SearchBar.tsx`              | Search input with icon                      |
| `FilterChips`          | `src/modules/community/components/FilterChips.tsx`            | Circle filter horizontal chips              |
| `ImageViewer`          | `src/components/ui/ImageViewer.tsx`                           | Fullscreen swipeable image modal            |
| `FloatingAddButton`    | `src/components/ui/FloatingAddButton.tsx`                     | Gradient FAB (shared with journal)          |
| `UserAvatar`           | `src/components/ui/UserAvatar.tsx`                            | Avatar with optional `imageUri` override    |

## File Map

| File                                                          | Role                            |
| ------------------------------------------------------------- | ------------------------------- |
| `src/app/(tabs)/community.tsx`                                | Route re-export → Community     |
| `src/app/community/create.tsx`                                | Route re-export → CreatePost    |
| `src/modules/community/store/community.ts`                    | Jotai atoms (search, filter)    |
| `src/modules/community/hooks/useCommunity.ts`                 | Membership query + join mutation |
| `src/modules/community/hooks/useCommunityFeed.ts`             | Feed infinite query + mutations  |
| `src/hooks/useImagePicker.ts`                                 | Shared image picker (single + multi) |
| `backend/src/db/schema/community.ts`                          | Table definitions                |
| `backend/src/rpc/procedures/community.ts`                     | All community RPC procedures     |

## Navigation

```
(tabs) Community → Community screen
  → Not joined → "Join Community" → CommunityPrinciples dialog → join → feed
  → Joined → Feed with search/filter
    → Tap image → ImageViewer (fullscreen modal)
    → Tap "+" FAB → /community/create (CreatePost)
      → Post → back to feed
    → Pull down → refresh feed
    → Switch to another tab and back → auto-refresh
```
