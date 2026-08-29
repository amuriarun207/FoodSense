# App Store Connect metadata — Ahar 1.0

Fill these fields in App Store Connect. Do not invent a Team ID in Xcode; select your team locally.

## Identity

| Field | Value |
| --- | --- |
| Name | Ahar |
| Subtitle (30 characters max) | Offline foodIQ · AharIQ |
| Bundle ID | `com.foodsense.com` |
| SKU | ahar-ios |
| Primary language | English (U.S.) |
| Version | 1.0 |
| Build | 1 |
| Category (primary) | Health & Fitness |
| Category (secondary) | Food & Drink |
| Age rating | 4+ (no unrestricted web, no violence, no medical treatment claims) |
| Copyright | Copyright © 2026 Ahar. All rights reserved. |
| Pricing | Free (or your price) |

Subtitle character count: “Offline foodIQ · AharIQ” is 23 characters.

## Description

Ahar is your offline foodIQ — AharIQ — for looking up foods, spices, ingredients, and everyday dishes.

Search English names or everyday names such as anar, haldi, or manjal. Open a food to see nutrition per 100 g, scale it to the amount you are eating, and read curated health notes when they are included in the bundled data.

Everything works in Airplane Mode. There are no accounts, no ads, and no internet connection.

V1 ships a starter dataset so you can explore the app. Records marked as demo are sample data for development and are not composition-table records. A larger curated dataset can be bundled in a later update.

Ahar provides general food information. It is not a medical device and does not diagnose or treat any condition.

## Keywords (100 characters max, comma-separated)

nutrition,calories,offline,foodiq,ahariq,spice,ingredient,dal,haldi,anar

(72 characters — adjust as needed.)

## What's New (1.0)

First release. Search foods offline with AharIQ, view nutrition, calculate intake by quantity, save favorites, and browse recently viewed foods. No account required.

## URLs

Host the HTML in `docs/` on GitHub Pages (repo Settings → Pages → Deploy from branch → `/docs`). After that, paste:

| Field | URL |
| --- | --- |
| Privacy Policy URL | `https://amuriarun207.github.io/FoodSense/privacy.html` |
| Support URL | `https://amuriarun207.github.io/FoodSense/support.html` |
| Marketing URL | `https://amuriarun207.github.io/FoodSense/` |

Local copies: `AppStore/SUPPORT.md`, `AppStore/MARKETING.md`, `AppStore/PRIVACY.md`.

## App Review contact

| Field | Value |
| --- | --- |
| First name | Arun |
| Last name | Kumar |
| Phone | +91 80198 97589 |
| Email | arunkumar6207@gmail.com |

The app has no demo account because there is no sign-in.

## Encryption

ITSAppUsesNonExemptEncryption is **NO**. The app does not use custom cryptography and does not make HTTPS calls.

## Signing

In Xcode: Signing & Capabilities → select **Your Team**. Do not commit a Team ID unless you intend to.

CODE_SIGN_STYLE is Automatic.
