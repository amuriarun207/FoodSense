# App Store submission checklist — FoodSense 1.0

Complete in Xcode and App Store Connect before you submit.

## In Xcode (you must do)

- [ ] Open `FoodSense.xcodeproj`
- [ ] Signing & Capabilities → Team → **select your Apple Developer team** (no Team ID is stored in the project on purpose)
- [ ] Confirm bundle ID `com.learning.FoodSense` is registered in your developer account (or change it to your ID)
- [ ] Product → Archive for **Any iOS Device (arm64)**
- [ ] Upload the build with Organizer or Transporter
- [ ] Run unit tests: Product → Test

## Already configured in the project

- Display name: FoodSense
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

- [ ] Create the app with bundle ID `com.learning.FoodSense`
- [ ] Paste metadata from `METADATA.md`
- [ ] Host `PRIVACY.md` on HTTPS and set Privacy Policy URL
- [ ] App Privacy questionnaire: **Data Not Collected**
- [ ] Age rating questionnaire (expected 4+)
- [ ] Upload real screenshots (see `SCREENSHOTS.md`)
- [ ] Paste `REVIEW_NOTES.md` into Review Notes
- [ ] Export compliance: uses non-exempt encryption = **No**
- [ ] Content rights: you are responsible for IFCT/demo data claims in the listing

## After first submission

If Apple’s privacy scanner reports an undeclared Required Reason API, add that category to `PrivacyInfo.xcprivacy` with the documented reason and ship a new build. V1 declares file timestamp (C617.1), UserDefaults (CA92.1), and disk space (E174.1) because SwiftData stores files on device.
