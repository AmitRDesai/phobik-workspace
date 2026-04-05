# Love Landing — Technical Reference

## Overview

The Love Landing screen is the entry point for the Love category within the Practices section. It presents two editorial-style cards — the 7-Day Empathy Challenge and the Gentle Letter to Yourself — with full-bleed background images, gradient overlays, and navigation to their respective flows.

## Screen Sequence

| Screen        | Route                    | Component     | Purpose                              |
| ------------- | ------------------------ | ------------- | ------------------------------------ |
| Love Landing  | `/practices/love-landing` | `LoveLanding` | Hub for Love category practices      |

## Navigation Flow

```
Practices (Love card) ─┐
Today (Love button) ───┤
Courage (Love card) ───┘
                        └→ LoveLanding
                             ├── Card 1 → /practices/empathy-challenge
                             └── Card 2 → /practices/gentle-letter
```

## Entry Points

| Source                     | Route                                     |
| -------------------------- | ----------------------------------------- |
| Practices screen Love card | `url: '/practices/love-landing'` in practices.ts |
| Today QuickAccessGrid      | `href: '/practices/love-landing'`         |
| Courage Options Love card  | `router.push('/practices/love-landing')`  |

## State

No local state. This is a stateless presentation screen.

## Components

### LoveLanding

**File**: `src/modules/love/screens/LoveLanding.tsx`

| Element           | Implementation                                        |
| ----------------- | ----------------------------------------------------- |
| Background        | `GlowBg` with pink/yellow radial glow on dark bg      |
| Header            | `BackButton` with safe area inset                     |
| Hero title        | "LOVE" in 56px extrabold, tracking-tighter            |
| Card backgrounds  | `expo-image` with absolute positioning                |
| Card overlay      | `LinearGradient` transparent → black (bottom-heavy)   |
| Card shadow       | `boxShadow` array syntax with pink tint               |
| Card radius       | `rounded-[32px]` (32px border radius)                 |
| Empathy CTA       | `GradientButton` wrapped in `w-3/4` container         |
| Gentle Letter CTA | Ghost `Pressable` with white/10 bg and border         |

## File Map

| File                                             | Role                          |
| ------------------------------------------------ | ----------------------------- |
| `src/modules/love/screens/LoveLanding.tsx`       | Screen component              |
| `src/app/practices/love-landing.tsx`             | Route re-export               |
| `assets/images/love/empathy-challenge-bg.jpg`    | Card 1 background image       |
| `assets/images/love/gentle-letter-bg.jpg`        | Card 2 background image       |
| `src/modules/practices/data/practices.ts`        | Love category URL definition  |
| `src/modules/home/components/QuickAccessGrid.tsx` | Today screen Love button href |
| `src/modules/courage/data/courage-options.ts`    | Love option in Courage grid   |
