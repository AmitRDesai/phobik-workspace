---
name: design-to-screen
description: "Implement a React Native screen from a design reference. Use when the user says 'implement screen from design', 'build screen from design', 'create screen from HTML', 'convert design to code', or references a design/ directory with screen.png and code.html files."
---

# Design to Screen

Implement a React Native (Expo) screen from a design reference containing `screen.png` (visual reference) and `code.html` (HTML/CSS source of truth).

## When to Use

- User asks to implement/build/create a screen from a design reference
- User points to a `design/` directory containing `screen.png` and `code.html`
- User wants to convert a web design mockup into a React Native screen

## Process

### Phase 1: Analyze the Design

1. **Read the design screenshot** (`screen.png`) to understand the visual layout, hierarchy, and overall feel.
2. **Read the HTML source** (`code.html`) to extract exact values:
   - Colors (map to `@/constants/colors` tokens or Tailwind classes where possible)
   - Font sizes, weights, letter-spacing, text-transform
   - Spacing (padding, margin, gap)
   - Border radius, border colors/widths
   - Shadows and glows
   - Icon names (Material Symbols map to `MaterialIcons` from `@expo/vector-icons`)
   - Layout direction (flex row/column), alignment, justify
3. **Identify components**: Break the screen into reusable pieces — header, cards, indicators, lists, buttons, etc.

### Phase 2: Study Existing Patterns

Before writing any code, read existing files to match project conventions:

1. **Similar screens**: Find a screen with a similar structure (e.g., list screen, detail screen, form) in `src/modules/*/screens/`.
2. **Shared UI components**: Check `src/components/ui/` for reusable primitives:
   - `Container.tsx` — SafeArea + KeyboardAvoiding wrapper (use instead of manual `useSafeAreaInsets`)
   - `GlowBg.tsx` — Radial gradient background glow
   - `GradientButton.tsx` — Pink-to-yellow gradient CTA (supports `compact` prop for small pill buttons)
   - `ScrollFade.tsx` — Fading scroll edge
   - `DialogContainer.tsx` — Bottom-sheet dialogs
3. **Color constants**: Use `@/constants/colors` for programmatic colors, NativeWind classes for className colors.
4. **Route patterns**: Check how existing routes outside `(tabs)` are structured (e.g., `practices/exercise-library.tsx`).

### Phase 3: Create Files

Follow the modules architecture. For a screen called `FeatureName`:

```
src/modules/<module>/
├── data/           # Static data arrays (if needed)
│   └── items.ts
├── components/     # Screen-specific components
│   ├── ItemCard.tsx
│   └── SectionIndicator.tsx
└── screens/
    └── FeatureName.tsx   # Main screen composing components

src/app/
└── feature-name.tsx      # Thin re-export (one-liner)
```

#### File creation order:

1. **Data file** — Static arrays/constants the screen needs
2. **Leaf components** — Smallest pieces first (cards, indicators, badges)
3. **Screen** — Composes components with layout, background, scroll
4. **Route file** — `export { default } from '@/modules/<module>/screens/FeatureName';`
5. **Wire up navigation** — Add `router.push('/feature-name')` to the calling component

### Phase 4: Implementation Rules

#### Layout & Styling

- **Use `className` (NativeWind)** for all static styles — layout, spacing, colors, borders, typography
- **Use inline `style`** only for: LinearGradient styles, shadows, animated styles, dynamic computed values, SVG props
- **Map HTML/CSS to NativeWind**:
  - `flex items-center justify-between` → `className="flex-row items-center justify-between"`
  - `space-y-4` → `className="gap-4"` (React Native uses gap, not space-y)
  - `text-sm font-bold uppercase tracking-widest` → same NativeWind classes
  - `bg-[#2D152D]/50` → `bg-card-plum/50` (use existing color tokens)
  - `size-12` → `h-12 w-12` (NativeWind doesn't have `size-*`)
  - `backdrop-blur-sm` → use `BlurView` from `expo-blur` if needed

#### Icons

- HTML uses Material Symbols Outlined → map to `MaterialIcons` from `@expo/vector-icons`
- Icon name mapping: `arrow_back_ios_new` → `chevron-left`, `watch_wake` → `watch`, etc.
- Some Material Symbols don't exist in MaterialIcons — find the closest match

#### Gradient Buttons

- Use `GradientButton` from `@/components/ui/GradientButton`
- For small pill buttons (like in cards): use `compact` prop
- For full-width CTAs: use default (no compact)

#### Animations

- Use `react-native-reanimated` for animations
- Pattern: `useSharedValue` + `useAnimatedStyle` + `withRepeat`/`withTiming`/`withSpring`
- Wrap animated views with `Animated.View`

#### Screen Wrapper

- Use `Container` from `@/components/ui/Container` with `safeAreaClass="bg-background-dashboard"`
- Use `GlowBg` for background radial gradient glow
- Use `ScrollView` with `contentContainerClassName` for scrollable content
- Back button: `Pressable` with `MaterialIcons` `chevron-left`, calls `router.back()`

#### Route Setup

- Place route file at `src/app/feature-name.tsx` (outside `(tabs)/`) for full-screen without tab bar
- Place inside `src/app/(tabs)/` if the screen should show the tab bar
- Route file is always a one-liner re-export

### Phase 5: Verify

1. **TypeScript check**: Run `npx tsc --noEmit` and filter for errors in new files
2. **No unused imports**: Ensure all imports are used
3. **No hardcoded colors**: All colors should reference tokens or NativeWind classes
4. **Simulator screenshot** (if running): `xcrun simctl io booted screenshot /tmp/claude/screenshot.png`
5. **Compare with design**: Read both screenshot and `screen.png`, check alignment, spacing, colors, typography

## HTML-to-NativeWind Quick Reference

| HTML/Tailwind CSS         | NativeWind / React Native                          |
| ------------------------- | -------------------------------------------------- |
| `div`                     | `View`                                             |
| `p`, `span`, `h1-h6`      | `Text`                                             |
| `button`                  | `Pressable`                                        |
| `img`                     | `Image`                                            |
| `overflow-y-auto`         | `ScrollView`                                       |
| `space-y-4`               | `gap-4` (on parent View)                           |
| `size-12`                 | `h-12 w-12`                                        |
| `hover:...`               | Not applicable (use `active:opacity-70` for press) |
| `transition-all`          | Use Reanimated                                     |
| `backdrop-filter: blur()` | `BlurView` from `expo-blur`                        |
| `linear-gradient()`       | `LinearGradient` from `expo-linear-gradient`       |
| `position: fixed`         | `position: absolute` or sticky header pattern      |
| `max-w-md mx-auto`        | Remove (mobile-first, full-width)                  |
| `cursor-pointer`          | Not applicable                                     |
