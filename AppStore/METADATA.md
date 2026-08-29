# App Store Connect metadata — FoodSense 1.0

Fill these fields in App Store Connect. Do not invent a Team ID in Xcode; select your team locally.

## Identity

| Field | Value |
| --- | --- |
| Name | FoodSense |
| Subtitle (30 characters max) | Offline Indian food nutrition |
| Bundle ID | `com.learning.FoodSense` |
| SKU | foodsense-ios |
| Primary language | English (U.S.) |
| Version | 1.0 |
| Build | 1 |
| Category (primary) | Health & Fitness |
| Category (secondary) | Food & Drink |
| Age rating | 4+ (no unrestricted web, no violence, no medical treatment claims) |
| Copyright | Copyright © 2026 FoodSense. All rights reserved. |
| Pricing | Free (or your price) |

Subtitle character count: “Offline Indian food nutrition” is 30 characters.

## Description

FoodSense helps you look up Indian foods, spices, ingredients, and common dishes — fully offline.

Search English names or everyday names such as anar, haldi, or manjal. Open a food to see nutrition per 100 g, scale it to the amount you are eating, and read curated health notes when they are included in the bundled data.

Everything works in Airplane Mode. There are no accounts, no ads, and no internet connection.

V1 ships a small sample dataset so you can explore the app. Records marked as demo are for development and are not Indian Food Composition Tables (IFCT) records. A larger curated dataset can be bundled in a later update.

FoodSense provides general food information. It is not a medical device and does not diagnose or treat any condition.

## Keywords (100 characters max, comma-separated)

indian food,nutrition,spice,haldi,anar,dal,offline,calories,ifct,ingredient

(96 characters — adjust as needed.)

## What's New (1.0)

First release. Search Indian foods offline, view nutrition, calculate intake by quantity, save favorites, and browse recently viewed foods. No account required.

## URLs (you must replace these)

| Field | Placeholder |
| --- | --- |
| Privacy Policy URL | `https://example.com/foodsense/privacy` — host `PRIVACY.md` |
| Support URL | `https://example.com/foodsense/support` |
| Marketing URL | optional |

## App Review contact

Use your real name, phone, and email in App Store Connect. The app has no demo account because there is no sign-in.

## Encryption

ITSAppUsesNonExemptEncryption is **NO**. The app does not use custom cryptography and does not make HTTPS calls.

## Signing

In Xcode: Signing & Capabilities → select **Your Team**. Do not commit a Team ID unless you intend to.

CODE_SIGN_STYLE is Automatic. DEVELOPMENT_TEAM is left empty on purpose.
