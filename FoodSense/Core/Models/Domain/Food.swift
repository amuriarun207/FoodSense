import Foundation

/// Domain food record used by UI and services. Independent of JSON and SwiftData.
nonisolated struct Food: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let category: FoodCategory
    let scientificName: String?
    let aliases: [String]
    let regionalNames: [String: String]
    let nutrition: Nutrition
    let serving: Serving
    let healthProfile: HealthProfile?
    let sourceIDs: [String]
    let isDemo: Bool
    var isFavorite: Bool
    var lastViewedAt: Date?

    var primaryLocalName: String? {
        if let hindi = regionalNames["hindi"], !hindi.isEmpty {
            return hindi
        }
        return aliases.first
    }

    var regionalNamesDisplay: String {
        let values = regionalNames.keys.sorted().compactMap { key -> String? in
            guard let value = regionalNames[key], !value.isEmpty else { return nil }
            return "\(value) (\(Self.displayLanguage(key)))"
        }
        if !values.isEmpty {
            return values.joined(separator: " · ")
        }
        return aliases.joined(separator: " · ")
    }

    var shortNutritionSummary: String {
        if let kcal = nutrition.energyKcal {
            return "\(NutritionFormatter.number(kcal)) kcal / 100g"
        }
        if nutrition.hasCoreValues {
            return "Nutrition available"
        }
        return "Nutrition not available"
    }

    private static func displayLanguage(_ key: String) -> String {
        switch key.lowercased() {
        case "hindi": return "Hindi"
        case "tamil": return "Tamil"
        case "telugu": return "Telugu"
        case "malayalam": return "Malayalam"
        case "kannada": return "Kannada"
        case "marathi": return "Marathi"
        case "gujarati": return "Gujarati"
        case "bengali": return "Bengali"
        case "punjabi": return "Punjabi"
        case "urdu": return "Urdu"
        case "odia", "oriya": return "Odia"
        case "assamese": return "Assamese"
        default: return key.capitalized
        }
    }
}
