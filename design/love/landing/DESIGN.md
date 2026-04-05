# Design System Document: Radiant Noir Editorial

## 1. Overview & Creative North Star
**The Creative North Star: "Luminous Transcendence"**
This design system moves away from the clinical, "safe" aesthetics of traditional mental health apps. Instead, it embraces a high-end, editorial light-mode experience that feels more like a luxury wellness retreat or a premium digital sanctuary. We reject the "boxed-in" layout of standard SaaS apps in favor of **Organic Fluidity**.

By utilizing intentional asymmetry, pristine light voids, and hyper-vibrant light sources (the "Aura"), we create a sense of infinite depth. The layout should feel like it is floating in a vacuum, where elements are held together by gravitational pull rather than rigid containers.

---

## 2. Colors & Surface Philosophy
The palette is anchored in a true-white void, allowing the vibrant pink-to-yellow spectrum to act as a therapeutic light source.

*   **Background (`#e0e0e0`):** The absolute foundation. It is not just a color; it is the "stage."
*   **The Radiant Core:** Use `primary` (#ff8aa9) to `secondary` (#ffd709) transitions for interactive elements and focal points.
*   **The "No-Line" Rule:** 1px solid borders are strictly prohibited for sectioning. Use `surface-container-low` (#cdcdcd) to define areas.
*   **Surface Hierarchy & Nesting:** Use `surface-container-lowest` (#ffffff) for high-impact content cards placed atop a `surface-container-low` section. This creates a "recessed" depth effect.
*   **The Glass & Gradient Rule:** For overlaying elements (like Affirmation cards), use `surface` with a 60% opacity and a `backdrop-filter: blur(24px)`. This creates a "frosted white" look.
*   **Signature Textures:** Apply a radial gradient background starting from `primary_dim` (#e4006c) at 0% to `surface` (#e0e0e0) at 70% with a very low opacity (5-8%) to simulate the "glow" of the lotus mandala behind the text.

---

## 3. Typography
The typography is a dialogue between the architectural strength of **Plus Jakarta Sans** and the approachable clarity of **Manrope**.

*   **Display & Headlines (Plus Jakarta Sans):** Used for affirmations and "hero" moments. Use `display-lg` (3.5rem) for single-word impacts and `headline-lg` (2rem) for core messages. Tighten letter-spacing to -0.02em for a high-fashion, editorial feel.
*   **Body & Titles (Manrope):** Used for instructional text and descriptions. `title-md` (1.125rem) should be used for secondary affirmations to maintain readability without competing with the Headline.
*   **Hierarchy Note:** Use `on-surface-variant` (#525555) for metadata to ensure the primary message (in `on-surface` #000000) remains the undisputed focal point.

---

## 4. Elevation & Depth
Depth in this system is atmospheric, not structural. We simulate light physics rather than paper stacking.

*   **Tonal Layering:** To highlight a specific affirmation block, do not use a shadow. Use `surface-bright` (#d3d3d3) as a background for the container to make it "pop" against the `surface-dim` (#e0e0e0) floor.
*   **Ambient Shadows:** If an element must float (e.g., a modal or floating action button), use a shadow color derived from `primary_dim` (#e4006c) at 10% opacity with a blur of `40px`. This mimics the colored glow of the aura visual.
*   **The "Ghost Border" Fallback:** If accessibility requires a stroke, use `outline-variant` (#b6b7b8) at **15% opacity**. It should be felt, not seen.
*   **Glassmorphism:** Apply to any element overlapping the lotus mandala. The interaction of the gradient light through the blurred surface is central to the PHOBIK brand identity.

---

## 5. Components

### Buttons (Radiant Variants)
*   **Primary:** A "Radiant Gradient" from `primary` (#ff8aa9) to `secondary` (#ffd709). Use `rounded-full` (9999px) for a soft, pebble-like feel. Text should be `on-primary-fixed` (#000000) for maximum contrast.
*   **Secondary:** Ghost style. No background fill, `Ghost Border` (15% opacity outline), text in `primary`.
*   **Interaction:** On hover/press, the button should scale to 0.98 and increase the `backdrop-filter` glow intensity.

### The Affirmation Card
*   **Style:** No borders. Use `surface-container-high` (#d6d6d6). 
*   **Radius:** Use `xl` (3rem) for a modern, oversized look.
*   **Spacing:** Use `8` (2.75rem) internal padding to give the text "room to breathe," consistent with luxury editorial layouts.

### Chips & Tags
*   **Selection Chips:** Use `surface-variant` (#d9d9d9) with `primary` text. When selected, switch to a subtle gradient fill of `primary_container` (#ff719b) to `tertiary_container` (#7000ff).

### Inputs & Fields
*   **Text Inputs:** No bottom line or box. Use `surface-container-low` with a `rounded-md` (1.5rem) corner. The focus state is indicated by a soft `primary` outer glow, not a border change.

### The Aura Visual (Lotus Mandala)
*   This is a core component. It must be placed asymmetrically (e.g., partially cropped off the top-right or bottom-left) to break the "app template" feel. Use a `tertiary` (#ac89ff) to `secondary` (#ffd709) color transition within the aura's glow.

---

## 6. Do's and Don'ts

### Do
*   **DO** use whitespace (Spacing Scale `12`, `16`, `20`) to separate sections instead of lines.
*   **DO** use asymmetrical layouts. Let the lotus mandala lead the eye toward the CTA.
*   **DO** ensure the most important affirmation text uses `display-md` or `headline-lg` to create a clear "Entry Point" for the user's eyes.
*   **DO** use `backdrop-blur` generously on any floating navigation or cards.

### Don't
*   **DON'T** use pure black (#000000) for large blocks of text; use `on-surface` for primary and `on-surface-variant` for secondary to prevent eye strain in light mode.
*   **DON'T** use standard Material Design drop shadows. They look "cheap" in this high-end context. Stick to Tonal Layering.
*   **DON'T** center-align everything. Use left-aligned headlines with right-aligned supporting text to create an editorial "Z-pattern."
*   **DON'T** use 100% opaque borders. Ever.