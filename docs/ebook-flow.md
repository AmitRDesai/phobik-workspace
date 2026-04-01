# Calm Above the Clouds E-Book — Technical Reference

## Overview

The E-Book module provides a premium reading experience for the "Calm Above the Clouds" flight anxiety guide. It includes a landing/store screen, introduction flow, table of contents, and a chapter reader with 24 chapters (Foreword, Introduction, Chapters 1-22). Each chapter has a unique layout with shared building-block components.

## Screen Sequence

| Screen          | Route                            | Component         | Purpose                                          |
| --------------- | -------------------------------- | ----------------- | ------------------------------------------------ |
| Landing         | `/practices/ebook-landing`       | `EbookLanding`    | Store page, purchase flow, entry to ebook/checklist |
| Introduction    | `/practices/ebook-intro`         | `EbookIntro`      | First-time welcome, approach overview             |
| Book Index      | `/practices/ebook-index`         | `EbookIndex`      | Table of contents with completion tracking        |
| Chapter Reader  | `/practices/ebook-chapter?chapter=N` | `EbookChapter` | Renders individual chapter content                |

## Navigation Flow

```
SpecializedPacks → EbookLanding
  ├── (not purchased) → Buy Now dialog → sets atom → screen updates
  └── (purchased)
      ├── E-Book item → (first time) EbookIntro → EbookIndex
      │                  (return) EbookIndex
      │                  EbookIndex → EbookChapter?chapter=N
      └── Checklist item → FlightChecklistHub
```

Chapter navigation uses `router.setParams()` to swap content without unmounting the screen. Header and nav controls stay fixed; only the scroll content transitions.

## State

### Persisted Atoms (AsyncStorage via Jotai `atomWithStorage`)

| Atom                        | Type        | Default | Key                        | Purpose                                |
| --------------------------- | ----------- | ------- | -------------------------- | -------------------------------------- |
| `ebookPurchasedAtom`        | `boolean`   | `false` | `ebook-purchased`          | Purchase/unlock state (placeholder for IAP) |
| `ebookIntroSeenAtom`        | `boolean`   | `false` | `ebook-intro-seen`         | Skip intro on return visits            |
| `ebookLastChapterAtom`      | `number \| null` | `null` | `ebook-last-chapter`  | Last chapter being read (highlighted in index) |
| `ebookCompletedChaptersAtom`| `number[]`  | `[]`    | `ebook-completed-chapters` | Chapter IDs marked complete            |

All atoms are in `src/modules/ebook/store/ebook-purchase.ts`.

## Chapter Architecture

### Router Screen (`EbookChapter.tsx`)

Owns the full layout: header, progress bar, scroll area, and nav controls. Uses `useLocalSearchParams` to get the `chapter` param and renders the matching chapter component via a lookup map.

```typescript
const CHAPTER_SCREENS: Record<number, React.LazyExoticComponent<...>> = {
  0: Foreword,    // lazy(() => import('./chapters/Foreword'))
  [-1]: Introduction,
  1: Chapter1,
  // ... through 22
};
```

Chapters are lazy-loaded with `React.lazy` and wrapped in `<Suspense>`.

### Chapter Content Swap

Navigation between chapters uses `router.setParams({ chapter: String(id) })` — no screen push/replace. The `ScrollView` has `key={chapterId}` to reset scroll position on chapter change. Content transitions with a fade animation via `EaseView` (opacity 1 → 0, swap, 0 → 1).

### Individual Chapter Screens

Each chapter is a standalone component in `screens/chapters/` that returns a React fragment with building-block components. No layout wrapper — `EbookChapter.tsx` provides the layout.

```tsx
// Example: Chapter4.tsx
export default function Chapter4() {
  return (
    <>
      <ChapterHeroImage source={ch4Hero} />
      <ChapterHeading label="Chapter 4" title="Why Flying Is a Perfect Storm for Anxiety" />
      <ChapterParagraph>Flying combines several...</ChapterParagraph>
      <ChapterQuote>Anxiety is a feeling of loss of control...</ChapterQuote>
      <ChapterAffirmation />
    </>
  );
}
```

## Building-Block Components

| Component              | File                                  | Props                                    | Purpose                              |
| ---------------------- | ------------------------------------- | ---------------------------------------- | ------------------------------------ |
| `EbookHeader`          | `components/EbookHeader.tsx`          | `label`, `onBack?`                       | Chapter label + back button          |
| `EbookProgressBar`     | `components/EbookProgressBar.tsx`     | `percent`                                | Pink-to-yellow gradient progress     |
| `EbookNavControls`     | `components/EbookNavControls.tsx`     | `hasPrev`, `hasNext`, `onPrev`, `onNext`, `onToc`, `onFinish?` | Previous/TOC/Next (or Finish on last chapter) |
| `ChapterHeading`       | `components/ChapterHeading.tsx`       | `label`, `title`                         | "Chapter N:\nTitle"                  |
| `ChapterParagraph`     | `components/ChapterParagraph.tsx`     | `children: string`, `bold?`              | Serif body text                      |
| `ChapterSectionTitle`  | `components/ChapterSectionTitle.tsx`  | `children: string`                       | Section heading                      |
| `ChapterQuote`         | `components/ChapterQuote.tsx`         | `children: string`                       | Quote with pink left border          |
| `ChapterCallout`       | `components/ChapterCallout.tsx`       | `icon?`, `title?`, `children`, `accentColor?` | Callout box with icon and accent |
| `ChapterHeroImage`     | `components/ChapterHeroImage.tsx`     | `source`, `caption?`                     | 16:9 image with gradient overlay     |
| `ChapterNumberedList`  | `components/ChapterNumberedList.tsx`  | `items: {title, description}[]`          | Numbered items with circle badges    |
| `ChapterAffirmation`   | `components/ChapterAffirmation.tsx`   | (none)                                   | "I am safe in this moment." card     |
| `RadialGlow`           | `components/RadialGlow.tsx`           | `color`, `size`, `style?`               | SVG radial gradient background orb   |

## Chapter Data

| File                          | Purpose                                    |
| ----------------------------- | ------------------------------------------ |
| `data/ebook-chapters.ts`      | Chapter list metadata (id, label, title)   |

Chapter IDs: `0` (Foreword), `-1` (Introduction), `1`-`22` (Chapters). Total: 24 entries.

Progress percentage is calculated as `(chapterIndex + 1) / totalChapters * 100`.

## Images

All stored in `src/assets/images/ebook/`:

| File                    | Used In                    | Description                          |
| ----------------------- | -------------------------- | ------------------------------------ |
| `landing-hero.jpg`      | EbookLanding               | Silhouette against sunset            |
| `introduction-hero.jpg` | EbookIntro, Introduction   | Aerial clouds at sunset              |
| `chapter-4-hero.jpg`    | Chapter 4                  | Airplane wing above clouds           |
| `chapter-5-hero.jpg`    | Chapter 5                  | Soft clouds meeting calm ocean       |
| `chapter-7-hero.jpg`    | Chapter 7                  | Pastel sky above clouds at dawn      |
| `chapter-14-hero.jpg`   | Chapter 14                 | Airplane cockpit instruments         |
| `chapter-15-hero.jpg`   | Chapter 15                 | Airplane wing over clouds            |
| `chapter-18-hero.jpg`   | Chapters 18, 21            | Pink/yellow cloud horizon at sunset  |

## File Map

| File                                                  | Role                                        |
| ----------------------------------------------------- | ------------------------------------------- |
| `src/app/practices/ebook-landing.tsx`                 | Route re-export                             |
| `src/app/practices/ebook-intro.tsx`                   | Route re-export                             |
| `src/app/practices/ebook-index.tsx`                   | Route re-export                             |
| `src/app/practices/ebook-chapter.tsx`                 | Route re-export                             |
| `src/modules/ebook/screens/EbookLanding.tsx`          | Landing/store screen with purchase flow     |
| `src/modules/ebook/screens/EbookIntro.tsx`            | First-time introduction with hero + cards   |
| `src/modules/ebook/screens/EbookIndex.tsx`            | Table of contents with completion tracking  |
| `src/modules/ebook/screens/EbookChapter.tsx`          | Chapter router with layout, lazy loading    |
| `src/modules/ebook/screens/chapters/*.tsx`            | 24 individual chapter content screens       |
| `src/modules/ebook/components/*.tsx`                  | 12 shared building-block components         |
| `src/modules/ebook/data/ebook-chapters.ts`            | Chapter list metadata                       |
| `src/modules/ebook/store/ebook-purchase.ts`           | 4 persisted Jotai atoms                     |
| `src/modules/courage/screens/SpecializedPacks.tsx`    | Entry point (imports `ebookPurchasedAtom`)   |
