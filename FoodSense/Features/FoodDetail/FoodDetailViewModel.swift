import Foundation
import Observation

nonisolated enum QuantityPreset: Hashable, Sendable, Identifiable {
    case grams(Double)
    case custom

    var id: String {
        switch self {
        case .grams(let value): return "g-\(value)"
        case .custom: return "custom"
        }
    }

    var title: String {
        switch self {
        case .grams(let value): return "\(NutritionFormatter.number(value)) g"
        case .custom: return "Custom"
        }
    }

    static let defaults: [QuantityPreset] = [
        .grams(25),
        .grams(30),
        .grams(50),
        .grams(100),
        .grams(150),
        .grams(200),
        .grams(500),
        .custom
    ]
}

@Observable
@MainActor
final class FoodDetailViewModel {
    let foodID: String
    var food: Food?
    var sources: [Source] = []
    var selectedPreset: QuantityPreset = .grams(100)
    var customGramsText = "100"
    var quantityGrams: Double = 100
    var calculated: NutritionResult?
    var isLoading = true
    var errorMessage: String?
    var notFound = false

    private let repository: any FoodRepository
    private let calculator: NutritionCalculator

    init(foodID: String, repository: any FoodRepository, calculator: NutritionCalculator) {
        self.foodID = foodID
        self.repository = repository
        self.calculator = calculator
    }

    var isFavorite: Bool { food?.isFavorite ?? false }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            guard let loaded = try await repository.food(id: foodID) else {
                notFound = true
                isLoading = false
                return
            }
            food = loaded
            sources = try await repository.sources(for: loaded)
            quantityGrams = loaded.serving.amount > 0 ? loaded.serving.amount : 100
            if QuantityPreset.defaults.contains(.grams(quantityGrams)) {
                selectedPreset = .grams(quantityGrams)
            } else {
                selectedPreset = .custom
            }
            customGramsText = NutritionFormatter.number(quantityGrams)
            recalculate()
            try await repository.markViewed(foodID: foodID)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func select(preset: QuantityPreset) {
        selectedPreset = preset
        switch preset {
        case .grams(let value):
            quantityGrams = value
            customGramsText = NutritionFormatter.number(value)
            recalculate()
        case .custom:
            applyCustomQuantity()
        }
    }

    func applyCustomQuantity() {
        let cleaned = customGramsText.replacingOccurrences(of: ",", with: ".")
        guard let value = Double(cleaned), value > 0 else { return }
        quantityGrams = value
        selectedPreset = .custom
        recalculate()
    }

    func toggleFavorite() async {
        guard let food else { return }
        let next = !food.isFavorite
        do {
            try await repository.setFavorite(foodID: food.id, isFavorite: next)
            self.food?.isFavorite = next
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func recalculate() {
        guard let food else {
            calculated = nil
            return
        }
        calculated = calculator.calculate(food: food, quantityGrams: quantityGrams)
    }
}
