import SwiftUI

private struct FoodRepositoryKey: EnvironmentKey {
    static let defaultValue: any FoodRepository = InMemoryFoodRepository(
        foods: PreviewData.foods,
        sources: PreviewData.sources
    )
}

private struct NutritionCalculatorKey: EnvironmentKey {
    static let defaultValue = NutritionCalculator()
}

extension EnvironmentValues {
    var foodRepository: any FoodRepository {
        get { self[FoodRepositoryKey.self] }
        set { self[FoodRepositoryKey.self] = newValue }
    }

    var nutritionCalculator: NutritionCalculator {
        get { self[NutritionCalculatorKey.self] }
        set { self[NutritionCalculatorKey.self] = newValue }
    }
}
