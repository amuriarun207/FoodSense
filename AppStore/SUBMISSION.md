# App Store submission checklist — Ahar 1.0

Complete in Xcode and App Store Connect before you submit.

## In Xcode (you must do)

- [ ] Open `FoodSense.xcodeproj`
- [ ] Signing & Capabilities → Team → **select your Apple Developer team**
- [ ] Confirm bundle ID `com.foodsense.com` is registered in your developer account (or change it to your ID)
- [ ] Product → Archive for **Any iOS Device (arm64)**
- [ ] Upload the build with Organizer or Transporter
- [ ] Run unit tests: Product → Test

## Already configured in the project

- Display name: **Ahar**
- Version 1.0 / Build 1
- iOS 17.0 deployment target
- iPhone + iPad device family (iPhone portrait; iPad additional orientations)
- App icon 1024×1024 (no transparency)
- Launch screen: `LaunchBackground` + `LaunchLogo`
- `ITSAppUsesNonExemptEncryption` = NO
- Copyright in Info.plist
- `PrivacyInfo.xcprivacy` — no tracking, no collected data types
- Seed JSON under `FoodSense/Resources/SeedData/` (synchronized into the app bundle)
- No network client code or network entitlements

## App Store Connect

- [ ] Create the app with name **Ahar** and bundle ID `com.foodsense.com`
- [ ] Paste metadata from `METADATA.md`
- [ ] Enable GitHub Pages on `docs/` (see URLs in `METADATA.md`)
- [ ] Privacy Policy URL: `https://amuriarun207.github.io/FoodSense/privacy.html`
- [ ] Support URL: `https://amuriarun207.github.io/FoodSense/support.html`
- [ ] Marketing URL (optional): `https://amuriarun207.github.io/FoodSense/`
- [ ] App Review contact: Arun Kumar, arunkumar6207@gmail.com, +91 80198 97589
- [ ] App Privacy questionnaire: **Data Not Collected**
- [ ] Age rating questionnaire (expected 4+)
- [ ] Upload the 10 screenshots in `screenshots/` (see `SCREENSHOTS.md`)
- [ ] App previews (optional videos) are **not** required — skip that slot if you have no clip
- [ ] Paste `REVIEW_NOTES.md` into Review Notes
- [ ] Export compliance: uses non-exempt encryption = **No**
- [ ] Content rights: you are responsible for composition-table / demo data claims in the listing

## After first submission

If Apple’s privacy scanner reports an undeclared Required Reason API, add that category to `PrivacyInfo.xcprivacy` with the documented reason and ship a new build. V1 declares file timestamp (C617.1), UserDefaults (CA92.1), and disk space (E174.1) because SwiftData stores files on device.
