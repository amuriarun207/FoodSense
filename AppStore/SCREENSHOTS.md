# App Store screenshots — Ahar

These are **real iPhone captures** of Ahar (no marketing frames, no fake UI). That is what App Store review expects.

## Upload these 10 files

Folder: `AppStore/screenshots/`

Each file is **1284 × 2778 px** (accepted in the slot that lists `1242 × 2688`, `1284 × 2778`, or the landscape pairs).

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

## Do not upload

- Landscape (`2688 × 1242` or `2778 × 1284`). Ahar is **iPhone portrait-only**. Landscape shots of a portrait app are a common rejection reason.
- **App previews** (the “up to 3” row) are **videos**, 15–30 seconds. Leave that row empty unless you record a clip on device.

## Recapture from Simulator

```bash
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
xcodebuild test -project FoodSense.xcodeproj -scheme FoodSense \
  -destination 'platform=iOS Simulator,name=iPhone 16 Plus' \
  -only-testing:FoodSenseUITests/AppStoreScreenshotTests
python3 AppStore/scripts/export_screenshots.py
```

Raw simulator PNGs (1290 × 2796) stay in `raw/`.
