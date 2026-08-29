# App Store screenshots

App Store Connect requires device-class screenshots. Marketing mockups in this folder are **composition references**, not a substitute for captures from Simulator or a device.

## Required sizes (as of 2026 — confirm in App Store Connect)

| Display | Typical size (px) | Notes |
| --- | --- | --- |
| iPhone 6.7" (required) | 1290 × 2796 or 1320 × 2868 | iPhone 15/16/17 Pro Max class |
| iPhone 6.5" | 1284 × 2778 | If Connect still asks |
| iPhone 5.5" | 1242 × 2208 | Only if Connect still asks |

Capture **portrait**. This app is iPhone-portrait first; iPad screenshots are optional unless you promote iPad.

## How to capture real screenshots

1. In Xcode, run FoodSense on **iPhone 16 Pro Max** or **iPhone 17 Pro Max**.
2. Exercise: Home with search, Pomegranate detail with 100 g and 200 g, Favorites, Settings.
3. Device → Screenshot, or `xcrun simctl io booted screenshot`.
4. Export lossless PNG. Do not add a device bezel unless you use Apple’s screenshot frames.

Suggested five frames:

1. Home — search field + popular categories
2. Search results for “anar”
3. Pomegranate detail — nutrition cards
4. Same detail — quantity 200 g + health profile
5. Settings — offline / not medical advice

## Files in this folder

| File | Purpose |
| --- | --- |
| `screenshots/marketing-home.png` | 9:16 UI mockup (resize before upload if needed) |
| `screenshots/marketing-detail.png` | 9:16 UI mockup |

Do not upload mockups that show UI the app does not actually render. Prefer Simulator captures of the real SwiftUI screens.
