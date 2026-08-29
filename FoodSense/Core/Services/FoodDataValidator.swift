import Foundation

nonisolated struct ValidationIssue: Hashable, Sendable, Identifiable {
    let id: String
    let foodID: String?
    let message: String
    let isError: Bool

    init(foodID: String? = nil, message: String, isError: Bool = true) {
        self.id = "\(foodID ?? "seed")-\(message)"
        self.foodID = foodID
        self.message = message
        self.isError = isError
    }
}

nonisolated struct ValidationReport: Sendable {
    var validFoods: [FoodDTO]
    var validSources: [SourceDTO]
    var issues: [ValidationIssue]

    var errors: [ValidationIssue] { issues.filter(\.isError) }
    var warnings: [ValidationIssue] { issues.filter { !$0.isError } }
}

nonisolated struct FoodDataValidator: Sendable {
    func validate(foods: [FoodDTO], sources: [SourceDTO]) -> ValidationReport {
        var issues: [ValidationIssue] = []
        var seenSourceIDs = Set<String>()
        var validSources: [SourceDTO] = []

        for source in sources {
            let id = source.id.trimmingCharacters(in: .whitespacesAndNewlines)
            let name = source.name.trimmingCharacters(in: .whitespacesAndNewlines)
            if id.isEmpty {
                issues.append(ValidationIssue(message: "Source ID must not be empty."))
                continue
            }
            if name.isEmpty {
                issues.append(ValidationIssue(message: "Source '\(id)' is missing a name."))
                continue
            }
            if seenSourceIDs.contains(id) {
                issues.append(ValidationIssue(message: "Duplicate source ID '\(id)' was skipped."))
                continue
            }
            seenSourceIDs.insert(id)
            validSources.append(source)
        }

        var seenFoodIDs = Set<String>()
        var validFoods: [FoodDTO] = []

        for food in foods {
            let foodIssues = validateFood(food, knownSourceIDs: seenSourceIDs, seenFoodIDs: seenFoodIDs)
            issues.append(contentsOf: foodIssues)
            if foodIssues.contains(where: \.isError) {
                continue
            }
            seenFoodIDs.insert(food.id.trimmingCharacters(in: .whitespacesAndNewlines))
            validFoods.append(food)
        }

        return ValidationReport(validFoods: validFoods, validSources: validSources, issues: issues)
    }

    private func validateFood(_ food: FoodDTO, knownSourceIDs: Set<String>, seenFoodIDs: Set<String>) -> [ValidationIssue] {
        var issues: [ValidationIssue] = []
        let id = food.id.trimmingCharacters(in: .whitespacesAndNewlines)
        if id.isEmpty {
            return [ValidationIssue(foodID: food.id, message: "Food ID must not be empty.")]
        }
        if seenFoodIDs.contains(id) {
            return [ValidationIssue(foodID: id, message: "Duplicate food ID '\(id)' was skipped.")]
        }

        let name = food.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            issues.append(ValidationIssue(foodID: id, message: "Food name must not be empty."))
        }

        if FoodCategory(rawValue: food.category) == nil {
            issues.append(ValidationIssue(foodID: id, message: "Category '\(food.category)' is not valid."))
        }

        if let serving = food.serving, serving.amount <= 0 {
            issues.append(ValidationIssue(foodID: id, message: "Serving amount must be greater than 0."))
        }

        if let nutrition = food.nutrition, let nutrientError = validateNutrition(nutrition, foodID: id) {
            issues.append(nutrientError)
        }

        if let sourceIDs = food.sourceIDs {
            for sourceID in sourceIDs where !knownSourceIDs.contains(sourceID) {
                issues.append(ValidationIssue(
                    foodID: id,
                    message: "Unknown source ID '\(sourceID)'.",
                    isError: false
                ))
            }
        }

        if let warning = demoNutritionWarning(for: food) {
            issues.append(warning)
        }

        return issues
    }

    private func validateNutrition(_ nutrition: NutritionDTO, foodID: String) -> ValidationIssue? {
        let values: [(String, Double?)] = [
            ("energyKcal", nutrition.energyKcal),
            ("proteinG", nutrition.proteinG),
            ("carbohydrateG", nutrition.carbohydrateG),
            ("fatG", nutrition.fatG),
            ("sugarG", nutrition.sugarG),
            ("fiberG", nutrition.fiberG),
            ("sodiumMg", nutrition.sodiumMg),
            ("calciumMg", nutrition.calciumMg),
            ("ironMg", nutrition.ironMg),
            ("magnesiumMg", nutrition.magnesiumMg),
            ("potassiumMg", nutrition.potassiumMg),
            ("vitaminAUg", nutrition.vitaminAUg),
            ("vitaminCMg", nutrition.vitaminCMg),
            ("vitaminDUg", nutrition.vitaminDUg),
            ("vitaminEMg", nutrition.vitaminEMg),
            ("vitaminKUg", nutrition.vitaminKUg),
            ("thiamineMg", nutrition.thiamineMg),
            ("riboflavinMg", nutrition.riboflavinMg),
            ("niacinMg", nutrition.niacinMg),
            ("vitaminB6Mg", nutrition.vitaminB6Mg),
            ("folateUg", nutrition.folateUg),
            ("vitaminB12Ug", nutrition.vitaminB12Ug),
            ("saturatedFatG", nutrition.saturatedFatG),
            ("monounsaturatedFatG", nutrition.monounsaturatedFatG),
            ("polyunsaturatedFatG", nutrition.polyunsaturatedFatG),
            ("cholesterolMg", nutrition.cholesterolMg)
        ]

        for (name, value) in values {
            if let value, value < 0 {
                return ValidationIssue(foodID: foodID, message: "Nutrition field '\(name)' cannot be negative.")
            }
            if let value, value.isNaN || value.isInfinite {
                return ValidationIssue(foodID: foodID, message: "Nutrition field '\(name)' is not a finite number.")
            }
        }
        return nil
    }

    private func demoNutritionWarning(for food: FoodDTO) -> ValidationIssue? {
        guard food.isDemo, food.nutrition != nil else { return nil }
        return ValidationIssue(
            foodID: food.id,
            message: "Demo record '\(food.name)' includes sample nutrition and is not an IFCT record.",
            isError: false
        )
    }
}
