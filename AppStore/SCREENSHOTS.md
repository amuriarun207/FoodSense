# App Store screenshots — Ahar

These are **real device captures** of Ahar (no marketing frames, no fake UI). That is what App Store review expects.

App previews in Connect are **videos** (15–30 seconds). Leave that row empty unless you record a clip.

## iPhone — 10 files

Folder: `AppStore/screenshots/`

Each file is **1284 × 2778 px**.

| # | File | Screen |
| --- | --- | --- |
| 1 | `01-home.png` | Home — search, categories, recently viewed |
| 2 | `02-search.png` | Search “anar” → Pomegranate |
| 3 | `03-nutrition.png` | Pomegranate nutrition per 100 g |
| 4 | `04-quantity.png` | Quantity 200 g, scaled values |
| 5 | `05-health.png` | Health profile |
| 6 | `06-favorites.png` | Favorites |
| 7 | `07-categories.png` | Fruits list |
| 8 | `08-settings.png` | Settings — About / AharIQ |
| 9 | `09-spices.png` | Spices category |
| 10 | `10-offline.png` | Settings — evidence + privacy (offline) |

Same 10 files at **1242 × 2688** are in `1242x2688/`.

Do **not** upload iPhone landscape. The iPhone build is portrait-first.

## iPad 12.9" / 13" — 10 files

Folder: `AppStore/screenshots/ipad/`

Each file is **2064 × 2752 px** (iPad Pro 13"). This matches the slot that lists `2064 × 2752`, `2752 × 2064`, `2048 × 2732`, or `2732 × 2048`.

Use the same 10 names as iPhone (`01-home.png` … `10-offline.png`).

Copies at **2048 × 2732** (iPad Pro 12.9") are in `ipad/2048x2732/`.

Upload **portrait**. Landscape sizes are listed as alternatives; do not rotate these files.

## Recapture from Simulator

```bash
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
xcodebuild test -project FoodSense.xcodeproj -scheme FoodSense \
  -destination 'platform=iOS Simulator,name=iPhone 16 Plus' \
  -only-testing:FoodSenseUITests/AppStoreScreenshotTests
xcodebuild test -project FoodSense.xcodeproj -scheme FoodSense \
  -destination 'platform=iOS Simulator,name=iPad Pro 13-inch (M4)' \
  -only-testing:FoodSenseUITests/AppStoreScreenshotTests
python3 AppStore/scripts/export_screenshots.py
```

Raw iPhone PNGs stay in `raw/`. Raw iPad PNGs stay in `raw-ipad/`.
