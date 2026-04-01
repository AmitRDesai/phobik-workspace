# Quick Flight Checklist — Technical Reference

## Overview

The Quick Flight Checklist guides users through 6 flight phases with checkable items, phase-specific interactive sections, and a turbulence tools screen. Checklist state is persisted to AsyncStorage via Jotai so progress survives app restarts.

## Screen Sequence

| Screen              | Route                                      | Component              | Purpose                                     |
| ------------------- | ------------------------------------------ | ---------------------- | ------------------------------------------- |
| Hub                 | `/practices/flight-checklist-hub`          | `FlightChecklistHub`   | Phase grid, hero section, quick reset       |
| Phase               | `/practices/flight-checklist-phase?phaseId=X` | `FlightChecklistPhase` | Checklist items, special sections, CTA   |
| Turbulence Tools    | `/practices/turbulence-tools`              | `TurbulenceTools`      | 3 practical tools + animated reality        |

## Navigation Flow

```
FlightChecklistHub
  ├── Before the Airport → At the Airport → Once Seated → During Takeoff → During Turbulence → During Landing
  │                                                                              └── Turbulence Tools
  └── (any phase directly via hub buttons)
```

Phase-to-phase navigation uses `router.replace()` so the stack doesn't grow. "Practice Completed" on the last phase calls `router.back()`.

## State

### Persisted Atom (AsyncStorage via Jotai `atomWithStorage`)

| Atom                   | Type          | Default | Key                | Purpose                              |
| ---------------------- | ------------- | ------- | ------------------ | ------------------------------------ |
| `flightChecklistAtom`  | `Set<string>` | `new Set()` | `flight-checklist` | Checked item IDs across all phases |

Located in `src/modules/courage/store/flight-checklist.ts`.

### Storage Implementation

`Set<string>` is not JSON-serializable, so the atom uses a two-layer approach:

```typescript
// Base: persisted as string[]
const checkedItemsArrayAtom = atomWithStorage<string[]>('flight-checklist', [], storage);

// Sync unwrap to avoid Suspense
const syncCheckedItemsAtom = unwrap(checkedItemsArrayAtom, (prev) => prev ?? []);

// Public: converts to/from Set for the UI
export const flightChecklistAtom = atom(
  (get) => new Set(get(syncCheckedItemsAtom)),
  (_get, set, value: Set<string>) => set(checkedItemsArrayAtom, [...value]),
);
```

Item key format: `{phaseId}:{itemId}` (e.g., `before-airport:1`).

### Local State (not persisted)

| State             | Component             | Purpose                         |
| ----------------- | --------------------- | ------------------------------- |
| `selectedAnchor`  | `AnchorSelection`     | Currently selected anchor option |
| `journalText`     | `JournalPrompt`       | Text in journal prompt textarea  |

## Phase Data

### Phases (`data/flight-phases.ts`)

6 phases with alternating pink/yellow accents:

| ID                 | Label              | Icon                          | Accent |
| ------------------ | ------------------ | ----------------------------- | ------ |
| `before-airport`   | Before the Airport | `home`                        | pink   |
| `at-airport`       | At the Airport     | `apartment`                   | yellow |
| `once-seated`      | Once Seated        | `airline-seat-recline-normal` | pink   |
| `during-takeoff`   | During Takeoff     | `flight-takeoff`              | yellow |
| `during-turbulence`| During Turbulence  | `air`                         | pink   |
| `during-landing`   | During Landing     | `flight-land`                 | yellow |

### Checklist Items (`data/flight-checklist-data.ts`)

Each phase has a `PhaseChecklist`:

```typescript
interface PhaseChecklist {
  title: string;
  phaseBadge?: string;     // e.g., "Pre-Flight Phase"
  subtitle?: string;        // Description text below title
  items: ChecklistItem[];
  ctaLabel: string;         // "Next Step" or "Practice Completed"
  statusText?: string;      // Footer text below CTA
  nextPhase?: string;       // Links to next phase ID
}

interface ChecklistItem {
  id: string;
  category?: string;        // e.g., "Acknowledgment", "Action"
  text: string;
  description?: string;
  highlight?: 'pink' | 'yellow';  // Colored card variant
  icon?: MaterialIcons name;
}
```

### Anchor Options

10 distraction anchors for the "Once Seated" phase:

Journal, Sound Therapy, Podcast, Movie, Book, Breathing, Chewing Gum, Music, 5-4-3-2-1, Other

## Phase-Specific Sections

Special components rendered conditionally based on `phaseId`:

| Phase              | Component          | Description                                    |
| ------------------ | ------------------ | ---------------------------------------------- |
| `before-airport`   | `JournalPrompt`    | "What am I worried about? Fact or fiction?" textarea |
| `once-seated`      | `BreathingCard`    | 60-90 seconds of slow breathing instruction    |
| `once-seated`      | `RealityCheck`     | "Right now, nothing is required of me" card    |
| `once-seated`      | `AnchorSelection`  | 10-option grid to choose a distraction anchor  |
| `during-takeoff`   | `ExhaleCard`       | "Focus on your Exhale" visual with gradient    |
| `during-turbulence`| Turbulence link    | Navigation card to Turbulence Tools screen     |

## Checklist Item Rendering

Two visual variants based on the `highlight` property:

**Standard (no highlight):** Glass card (`bg-white/[0.03]`, `border border-white/10`), category label in gray, white text, gradient checkbox.

**Highlighted (pink/yellow):** Tinted background and border matching the accent color, pink title text, same gradient checkbox.

### Checkbox States

Both states are 24x24px circles:
- **Unchecked:** 2px border, `gray-700` color
- **Checked:** Pink-to-yellow gradient fill with white checkmark icon

## Turbulence Tools Screen

Three practical tool cards + an animated reality section:

| Tool                   | Icon         | Description                                         |
| ---------------------- | ------------ | --------------------------------------------------- |
| Cup of Water           | `local-cafe` | Observe how little liquid moves on tray table       |
| Sticky Note Check      | `edit-note`  | Write reassurance note on seat back                 |
| Gelatin Visualization  | `waves`      | Picture plane suspended in gelatin                  |

The "Animated Reality" section has a gradient background and describes turning fear into a cartoon character.

## Hub Screen

### Layout
- Hero image section with gradient overlay and Phobik badge
- Title: "Quick Flight Checklist" with subtitle
- 6 phase buttons (icon + label + chevron)
- Quick Reset button (conditional)

### Quick Reset
Only visible when `checkedItems.size > 0`. Shows confirmation dialog before clearing all progress via `setCheckedItems(new Set())`.

## Components

| Component           | File                                             | Purpose                              |
| ------------------- | ------------------------------------------------ | ------------------------------------ |
| `GlassCard`         | Inline in `FlightChecklistPhase.tsx`             | Standard/highlighted checklist item  |
| `CheckboxCircle`    | Inline in `FlightChecklistPhase.tsx`             | Gradient checkbox (checked/unchecked)|
| `BreathingCard`     | Inline in `FlightChecklistPhase.tsx`             | Slow breathing instruction card      |
| `RealityCheck`      | Inline in `FlightChecklistPhase.tsx`             | Yellow affirmation card              |
| `AnchorSelection`   | Inline in `FlightChecklistPhase.tsx`             | 10-option anchor grid                |
| `ExhaleCard`        | Inline in `FlightChecklistPhase.tsx`             | Exhale focus visualization           |
| `JournalPrompt`     | Inline in `FlightChecklistPhase.tsx`             | Textarea for reflections             |
| `ToolCard`          | Inline in `TurbulenceTools.tsx`                  | Individual turbulence tool card      |
| `RadialGlow`        | `src/modules/ebook/components/RadialGlow.tsx`    | SVG radial gradient background orb   |

## File Map

| File                                                        | Role                                        |
| ----------------------------------------------------------- | ------------------------------------------- |
| `src/app/practices/flight-checklist-hub.tsx`                | Route re-export                             |
| `src/app/practices/flight-checklist-phase.tsx`              | Route re-export                             |
| `src/app/practices/turbulence-tools.tsx`                    | Route re-export                             |
| `src/modules/courage/screens/FlightChecklistHub.tsx`        | Hub with phase grid and quick reset         |
| `src/modules/courage/screens/FlightChecklistPhase.tsx`      | Phase checklist with special sections       |
| `src/modules/courage/screens/TurbulenceTools.tsx`           | Practical tools + animated reality          |
| `src/modules/courage/data/flight-phases.ts`                 | 6 phase definitions (id, label, icon, accent) |
| `src/modules/courage/data/flight-checklist-data.ts`         | Checklist items + anchor options per phase  |
| `src/modules/courage/store/flight-checklist.ts`             | Persisted Set atom (AsyncStorage)           |
| `src/modules/courage/components/CourageHeader.tsx`           | Header used on hub screen                   |
| `src/assets/images/flight-checklist-hero.png`               | Hero image for hub screen                   |
