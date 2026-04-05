# CLAUDE.md

Whenever working with any third-party library or something similar, you MUST look up the official documentation to ensure that you're working with up-to-date information.
Use the DocsExplorer subagent for efficient documentation lookup.

This is the root workspace for the Phobik project. It contains multiple sub-projects, each with their own git repo and `CLAUDE.md`.

## Workspace Structure

```
workspace/
├── app/       # Expo React Native mobile app (see app/CLAUDE.md)
├── backend/   # Bun HTTP server with oRPC + Better Auth (see backend/CLAUDE.md)
├── db/        # Database: Postgres, PowerSync service, sync config
└── design/    # Design files
```

## How the Projects Connect

- **Backend** exposes: Better Auth (`/api/auth/*`), oRPC procedures (`/rpc/*`), PowerSync token (`/api/powersync/*`), AI Coach (`/api/coach/*`)
- **App** uses an **offline-first architecture** via PowerSync for user-scoped data, and React Query + oRPC for online-only features
- Auth flow: App uses Better Auth's Expo plugin with `expo-secure-store` for token storage, backend validates sessions via cookie/bearer token
- The backend exports `AppRouter` and `AppRouterClient` types that the app imports for end-to-end type safety

## Offline-First Architecture (PowerSync)

The app uses **PowerSync** to sync data between a local SQLite database on-device and the Postgres backend.

### What's offline-first (PowerSync)
User-scoped features that work without network:
- Journal entries + tags
- Gentle letters
- Empathy challenges + days
- Mystery challenges
- Self check-ins
- Calendar preferences

These use `@powersync/react` hooks (`useQuery` for reads, `powersync.execute()` for writes). Data is stored locally in SQLite and synced to Postgres automatically.

### What's online-only (React Query + oRPC)
Features requiring server or other users' data:
- Auth (Better Auth)
- AI Coach (streaming)
- Community (social feed)
- Profile status check + onboarding writes (navigation guard)

### How sync works
- **Reads**: Postgres → logical replication → PowerSync Service → WebSocket → local SQLite → reactive hooks → UI
- **Writes**: App → local SQLite (instant) → `uploadData()` in connector → oRPC procedures → Postgres → replication back to all clients
- PowerSync connector (`app/src/lib/powersync/connector.ts`) routes writes to existing oRPC procedures
- All write procedures accept optional client-generated `id` and use `onConflictDoUpdate` for idempotency

### Key conventions
- PowerSync returns **snake_case** column names. Use `toCamel()` from `@/lib/powersync/utils` in hooks to convert to camelCase for screens
- JSONB columns (tags, content, answers) are stored as text in SQLite — pass `{ tags: true }` etc. to `toCamel()` to auto-parse
- Use `uuid()` from `@/lib/crypto` (expo-crypto) for generating IDs — `crypto.randomUUID()` is NOT available in React Native
- Use `useLocalMutation()` from `@/lib/powersync/useLocalMutation` for write hooks — provides React Query-compatible `.mutate()`, `.mutateAsync()`, `.isPending` API
- PowerSync requires **dev builds** (`npx expo run:ios`) — does NOT work in Expo Go

### Infrastructure (db/)
- `db/compose.yaml` — Postgres (with `wal_level=logical`) + PowerSync service
- `db/powersync.yaml` — PowerSync service config (replication, storage, auth)
- `db/sync-config.yaml` — Sync Streams (edition 3), all user-scoped via `auth.user_id()`
- `db/init/02_powersync_replication.sql` — Creates replication role + publication
- Auth: ES256 JWKS — private key in backend `.env`, public key in PowerSync config
- Key generation: `bun run scripts/generate-powersync-key.ts`

## Per-Project Instructions

Each sub-project has its own `CLAUDE.md` with detailed architecture, commands, and conventions. Always refer to the relevant project's `CLAUDE.md` when working on files within it.

- **Frontend**: `app/CLAUDE.md` — Expo Router, NativeWind, PowerSync, React Query, modules architecture
- **Backend**: `backend/CLAUDE.md` — Bun.serve(), oRPC, Better Auth, Drizzle ORM, PowerSync JWT

## General Rules

- Backend uses **Bun** exclusively — no npm/yarn/pnpm
- Frontend uses **Expo CLI** — always `npx expo install` for dependencies
- Both projects use TypeScript strict mode
