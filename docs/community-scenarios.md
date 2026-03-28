# Community (Courage Wall) — User Scenarios

## Scenario 1: Visiting the Community Tab for the First Time

A user taps the "Community" tab at the bottom of the app.

1. User taps the "Community" icon in the bottom navigation bar
2. A centered screen appears with a large group icon and the heading "Courage Wall"
3. Below the heading, a short message reads "A safe space to share your brave moments, support others, and grow together"
4. A "Join Community" button is shown below the message
5. No feed content is visible until the user joins

---

## Scenario 2: Joining the Community

A user taps the "Join Community" button to become a member.

1. User taps "Join Community"
2. A bottom sheet slides up showing "Phobik Community Principles"
3. A subtitle reads "Kindness matters. Courage grows in Community"
4. Six community principles are listed, each with a gradient icon circle:
   - Speak your truth — Be real about what you're experiencing
   - Name what's real — Putting feelings into words creates clarity
   - Notice what's here — Fear and struggle are part of being human
   - Listen with compassion — Support others without judgment or fixing
   - Celebrate courage — Small brave steps matter
   - Move forward together — No one struggles alone here
5. The principles list scrolls if needed
6. At the bottom, a gradient button reads "I Understand & Join" with a forward arrow
7. A small label at the bottom says "Safe-sharing protocol active"
8. User taps "I Understand & Join"
9. The bottom sheet closes and the community feed appears
10. User taps outside the bottom sheet to dismiss without joining

---

## Scenario 3: Browsing the Community Feed

A user has joined and is viewing the Courage Wall feed.

1. The header shows "Courage Wall" centered at the top
2. Below the header, a search bar with "Find inspiration..." placeholder is shown
3. Below the search bar, filter chips scroll horizontally: "All Stories", "18-24", "25-34", "35-44", "45-54", "55+"
4. "All Stories" is selected by default (highlighted in pink)
5. Posts appear in a scrollable list below the filters
6. Each post shows:
   - A profile picture (or a generic person icon if anonymous)
   - The author's name (or "Anonymous") and a relative time (e.g., "Just now", "2h ago", "Yesterday")
   - The post text
   - Any attached images (scrollable horizontally if multiple)
   - An optional circle tag (e.g., "25-34") in a pink badge
   - Five reaction buttons scrolling horizontally
7. A floating "+" button appears in the bottom right corner
8. The feed loads more posts automatically when the user scrolls near the bottom

---

## Scenario 4: Searching and Filtering Posts

A user wants to find specific posts.

1. User taps the search bar and types a word or phrase
2. After a short pause, the feed updates to show only posts containing that text
3. User clears the search to see all posts again
4. User taps a circle filter chip (e.g., "25-34")
5. The chip highlights in pink and the feed shows only posts from that age circle
6. User taps the same chip again to deselect it and see all posts
7. Search and filter can be combined — typing a search while a circle is selected filters by both

---

## Scenario 5: Reacting to a Post

A user wants to show support on someone's post.

1. Each post has five reaction options scrolling horizontally below the content:
   - Heart — "I see you"
   - Fist — "You've got this"
   - Handshake — "Not alone"
   - Seedling — "Keep going"
   - Fire — "Courage moment"
2. User taps one of the reaction buttons
3. The button highlights in pink with a subtle glow to show the user has reacted
4. A count appears next to the reaction text (e.g., "I see you 3")
5. User taps the same reaction again to remove it
6. The button returns to its normal appearance and the count decreases
7. Counts above 999 are shortened (e.g., "1.5K", "2M")

---

## Scenario 6: Viewing Post Images

A user taps on an image attached to a post.

1. User sees one or more image thumbnails below a post's text
2. If a post has multiple images, they scroll horizontally
3. User taps on any image thumbnail
4. The image opens in a fullscreen viewer with a dark background
5. A close button (X) appears in the top right corner
6. If the post has multiple images, a counter shows the position (e.g., "1 / 3")
7. User swipes left or right to view other images in the post
8. User taps the close button or presses back to return to the feed

---

## Scenario 7: Creating a New Post

A user wants to share a moment with the community.

1. User taps the floating "+" button on the feed screen
2. A new screen opens with "Share Your Moment" in the header
3. A close button (X) is in the top left corner
4. The heading reads "What's going on for you today?"
5. A subtitle says "Share with awareness, not self-judgment. Your experience is valid"
6. A large text area with "Start writing here..." placeholder is shown
7. A character counter shows "0 / 500" in the bottom right of the text area
8. User types their message — the counter updates as they type
9. The text area accepts up to 500 characters

---

## Scenario 8: Attaching Images to a Post

A user wants to add photos to their post.

1. Below the text area, a "Photos" section shows an "Add" button
2. User taps "Add"
3. The device asks for permission to access the photo library (first time only)
4. The photo picker opens, allowing the user to select up to 5 images at once
5. Selected images appear as small square thumbnails in a scrollable row
6. Each thumbnail has a red close button in the top right corner
7. User taps the close button on a thumbnail to remove that image
8. If fewer than 5 images are selected, the "Add" button remains visible to add more
9. The "Add" button disappears once 5 images are attached

---

## Scenario 9: Choosing a Circle and Posting Anonymously

A user customizes their post settings before sharing.

1. Below the photos section, "Your Circle" shows age range options: 18-24, 25-34, 35-44, 45-54, 55+
2. The options scroll horizontally as small pill buttons
3. User taps an age range — it highlights with a pink border
4. User taps the same option again to deselect it (circle is optional)
5. Below the circle options, a "Post Anonymously" card shows a shield icon
6. The card has a toggle switch on the right side
7. User taps the toggle to enable anonymous posting — the toggle turns pink
8. When anonymous, the post will show "Anonymous" instead of the user's name and hide their profile picture
9. A guidance message reads "Your words are a reflection of your journey. Take a deep breath before hitting post"

---

## Scenario 10: Submitting a Post

A user finishes writing and shares their post.

1. A "Post to Wall" button with a send icon is fixed at the bottom of the screen
2. The button is disabled (dimmed) until the user types at least one character
3. User taps "Post to Wall"
4. A loading spinner appears on the button while the post is being submitted
5. Once submitted, the screen closes and the user returns to the feed
6. The new post appears at the top of the feed

---

## Scenario 11: Refreshing the Feed

A user wants to see the latest posts.

1. User pulls down on the feed — a loading spinner appears at the top
2. The feed refreshes with the latest posts
3. The spinner disappears once the refresh is complete
4. The feed also refreshes automatically whenever the user switches back to the Community tab

---

## Edge Cases

### Empty feed

When no one has posted yet (or filters match no posts), a placeholder message reads "No posts yet. Be the first to share!" with a notepad icon.

### Post submission fails

If something goes wrong while posting, an error dialog appears with "Post Failed" and "Something went wrong. Please try again." The user can dismiss it and try again without losing their text.

### Photo library permission denied

If the user denies photo library access, a dialog explains that they need to allow access in their device settings to select photos.

### Very long post text

The text area enforces a 500-character limit. Characters beyond the limit are not accepted.

### Anonymous posts

Anonymous posts are displayed with a generic person icon and "Anonymous" as the author name. Other users cannot see who wrote it.
