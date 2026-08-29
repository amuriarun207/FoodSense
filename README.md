# Ahar

**Offline foodIQ / AharIQ. Know what you eat.**

Ahar is an offline iOS app that helps you understand the food you eat. It provides nutrition information, serving-size calculations, health considerations, and food details for spices, ingredients, fruits, vegetables, grains, pulses, and everyday dishes.

## Features

* **Offline food search** — Search foods by name, alias, or regional name.
* **AharIQ food library** — Foods, spices, ingredients, and dishes available on device as foodIQ.
* **Nutrition information** — Calories, protein, carbohydrates, fat, sugar, fibre, sodium, and other nutrients where available.
* **Serving calculator** — Adjust the quantity and see calculated nutritional values.
* **Health profiles** — View curated benefits, considerations, and excessive-intake information.
* **Sources** — Track the source of nutrition and health information.
* **Favorites** — Save frequently used foods.
* **Recently viewed** — Quickly access foods viewed recently.
* **100% offline** — Core functionality works without an internet connection.
* **Privacy friendly** — No account or backend required for the core experience.

## Architecture

Ahar uses a local-first architecture:

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
    Ahar
```

## Data

The initial database is designed around published food composition data, with composition tables as the primary foundation.

The database is designed to grow from a starter set of foods to a much larger food knowledge base over time.

Data is separated into:

* Food information
* Nutrition information
* Serving information
* Health profiles
* Health facts
* Sources
* Categories

## Nutrition calculation

Ahar stores nutritional values using a standard reference quantity, typically per 100g.

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

## Technology

* Swift
* SwiftUI
* SwiftData
* Codable
* Foundation
* XCTest / Swift Testing

## V1 goals

The first version intentionally does **not** use:

* AI
* LLMs
* Backend APIs
* Cloud services
* User accounts
* Internet connectivity

The goal is to establish a reliable, offline foodIQ / AharIQ foundation first.

## Future roadmap

Potential future capabilities include:

* Expanded food database
* Barcode scanning
* Packaged food support
* More regional languages
* Personalized nutrition insights
* Food comparisons
* Meal tracking
* AI-powered food questions
* Cloud synchronization

## Disclaimer

Ahar provides general food and nutrition information for educational purposes. It is not intended to diagnose, treat, or prevent any medical condition and should not replace professional medical advice.

## Data sources

Food and nutrition data should be attributed to the appropriate original sources. The project should not present generated or unverified nutritional information as authoritative.

---

**Ahar — offline foodIQ / AharIQ. Know what you eat.**
