import Foundation

nonisolated struct NutritionCalculator: Sendable {
    /// Scales per-100g nutrients to the requested quantity.
    /// Formula: quantity / 100 × nutrientPer100g
    func calculate(food: Food, quantityGrams: Double) -> NutritionResult {
        calculate(nutrition: food.nutrition, quantityGrams: quantityGrams)
    }

    func calculate(nutrition: Nutrition, quantityGrams: Double) -> NutritionResult {
        let factor = quantityGrams / 100.0
        return NutritionResult(
            quantityGrams: quantityGrams,
            calories: scale(nutrition.energyKcal, factor: factor),
            proteinG: scale(nutrition.proteinG, factor: factor),
            carbohydrateG: scale(nutrition.carbohydrateG, factor: factor),
            sugarG: scale(nutrition.sugarG, factor: factor),
            fiberG: scale(nutrition.fiberG, factor: factor),
            fatG: scale(nutrition.fatG, factor: factor),
            sodiumMg: scale(nutrition.sodiumMg, factor: factor),
            calciumMg: scale(nutrition.calciumMg, factor: factor),
            ironMg: scale(nutrition.ironMg, factor: factor),
            magnesiumMg: scale(nutrition.magnesiumMg, factor: factor),
            potassiumMg: scale(nutrition.potassiumMg, factor: factor),
            vitaminAUg: scale(nutrition.vitaminAUg, factor: factor),
            vitaminCMg: scale(nutrition.vitaminCMg, factor: factor),
            vitaminDUg: scale(nutrition.vitaminDUg, factor: factor),
            vitaminEMg: scale(nutrition.vitaminEMg, factor: factor),
            vitaminKUg: scale(nutrition.vitaminKUg, factor: factor),
            thiamineMg: scale(nutrition.thiamineMg, factor: factor),
            riboflavinMg: scale(nutrition.riboflavinMg, factor: factor),
            niacinMg: scale(nutrition.niacinMg, factor: factor),
            vitaminB6Mg: scale(nutrition.vitaminB6Mg, factor: factor),
            folateUg: scale(nutrition.folateUg, factor: factor),
            vitaminB12Ug: scale(nutrition.vitaminB12Ug, factor: factor),
            saturatedFatG: scale(nutrition.saturatedFatG, factor: factor),
            monounsaturatedFatG: scale(nutrition.monounsaturatedFatG, factor: factor),
            polyunsaturatedFatG: scale(nutrition.polyunsaturatedFatG, factor: factor),
            cholesterolMg: scale(nutrition.cholesterolMg, factor: factor)
        )
    }

    private func scale(_ value: Double?, factor: Double) -> Double? {
        guard let value else { return nil }
        return value * factor
    }
}
