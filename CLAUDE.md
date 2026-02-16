# CLAUDE.md

Whenever working with any third-party library or something similar, you MUST look up the official documentation to ensure that you're working with up-to-date information.
Use the DocsExplorer subagent for efficient documentation lookup.

This is the root workspace for the Phobik project. It contains multiple sub-projects, each with their own git repo and `CLAUDE.md`.

## Workspace Structure

```
workspace/
├── app/       # Expo React Native mobile app (see app/CLAUDE.md)
├── backend/   # Bun HTTP server with oRPC + Better Auth (see backend/CLAUDE.md)
├── db/        # Shared database assets
└── design/    # Design files
```

## How the Projects Connect

- **Backend** exposes two APIs: Better Auth endpoints (`/api/auth/*`) and oRPC procedures (`/rpc/*`)
- **App** consumes the backend via oRPC client (`@orpc/client` + `@orpc/react-query`) and Better Auth Expo plugin
- Auth flow: App uses Better Auth's Expo plugin with `expo-secure-store` for token storage, backend validates sessions via cookie/bearer token
- The backend exports `AppRouter` and `AppRouterClient` types that the app imports for end-to-end type safety

## Per-Project Instructions

Each sub-project has its own `CLAUDE.md` with detailed architecture, commands, and conventions. Always refer to the relevant project's `CLAUDE.md` when working on files within it.

- **Frontend**: `app/CLAUDE.md` — Expo Router, NativeWind, Jotai, React Query, modules architecture
- **Backend**: `backend/CLAUDE.md` — Bun.serve(), oRPC, Better Auth, Drizzle ORM

## General Rules

- Backend uses **Bun** exclusively — no npm/yarn/pnpm
- Frontend uses **Expo CLI** — always `npx expo install` for dependencies
- Both projects use TypeScript strict mode
