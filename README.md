# FoodSense

**Know what you eat.**

FoodSense is an offline-first iOS app that helps users understand the food they eat. It provides nutrition information, serving-size calculations, health considerations, and food details for Indian foods, spices, ingredients, fruits, vegetables, grains, pulses, and popular dishes.

## ✨ Features

* 🔍 **Offline Food Search** — Search foods by name, alias, or regional name.
* 🇮🇳 **Indian Food Database** — Focused on Indian foods, spices, ingredients, and dishes.
* 🥗 **Nutrition Information** — Calories, protein, carbohydrates, fat, sugar, fibre, sodium, and other nutrients where available.
* ⚖️ **Serving Calculator** — Adjust the quantity and see calculated nutritional values.
* ❤️ **Health Profiles** — View curated benefits, considerations, and excessive-intake information.
* 📚 **Sources** — Track the source of nutrition and health information.
* ⭐ **Favorites** — Save frequently used foods.
* 🕘 **Recently Viewed** — Quickly access foods viewed recently.
* 📱 **100% Offline** — Core functionality works without an internet connection.
* 🔒 **Privacy Friendly** — No account or backend required for the core experience.

## 🏗 Architecture

FoodSense uses a local-first architecture:

```text
SwiftUI
   ↓
Features
   ↓
ViewModels
   ↓
FoodRepository
   ↓
SwiftData
   ↓
Local Food Database
```

Initial food data is bundled as JSON and imported into SwiftData when the application is first launched.

```text
Verified Food Data
       ↓
    JSON Seed
       ↓
  SwiftData Import
       ↓
 Local Food Database
       ↓
    FoodSense
```

## 📦 Data

The initial database is designed around Indian food composition data, with **ICMR-NIN Indian Food Composition Tables (IFCT)** as the primary foundation.

The database is designed to grow from approximately **1,000 foods** to a much larger food knowledge base over time.

Data is separated into:

* Food information
* Nutrition information
* Serving information
* Health profiles
* Health facts
* Sources
* Categories

## 🧮 Nutrition Calculation

FoodSense stores nutritional values using a standard reference quantity, typically per 100g.

For a selected quantity:

```text
quantity / 100 × nutrient per 100g
```

For example:

```text
100g → 83 kcal
200g → 166 kcal
500g → 415 kcal
```

All calculations are performed locally on the device.

## 🛠 Technology

* Swift
* SwiftUI
* SwiftData
* Codable
* Foundation
* XCTest / Swift Testing

## 🎯 V1 Goals

The first version intentionally does **not** use:

* AI
* LLMs
* Backend APIs
* Cloud services
* User accounts
* Internet connectivity

The goal is to establish a reliable, offline food and nutrition foundation first.

## 🚀 Future Roadmap

Potential future capabilities include:

* Expanded Indian food database
* Barcode scanning
* Packaged food support
* More regional languages
* Personalized nutrition insights
* Food comparisons
* Meal tracking
* AI-powered food questions
* Cloud synchronization

## ⚠️ Disclaimer

FoodSense provides general food and nutrition information for educational purposes. It is not intended to diagnose, treat, or prevent any medical condition and should not replace professional medical advice.

## 📄 Data Sources

Food and nutrition data should be attributed to the appropriate original sources. The project should not present generated or unverified nutritional information as authoritative.

---

**FoodSense — Know what you eat.**
