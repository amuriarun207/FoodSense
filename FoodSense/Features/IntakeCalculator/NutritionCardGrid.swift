import SwiftUI

struct NutritionCardGrid: View {
    let result: NutritionResult
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.weight(.semibold))

            if !result.hasAnyValue {
                Text("Nutrition is not available for this food yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(items) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.label)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(item.value)
                                .font(.headline)
                                .foregroundStyle(.primary)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(item.label), \(item.value)")
                    }
                }
            }
        }
    }

    private var items: [NutritionDisplayItem] {
        var resultItems: [NutritionDisplayItem] = []
        if let value = result.calories {
            resultItems.append(.init(label: "Calories", value: NutritionFormatter.calories(value)))
        }
        if let value = result.proteinG {
            resultItems.append(.init(label: "Protein", value: NutritionFormatter.grams(value)))
        }
        if let value = result.carbohydrateG {
            resultItems.append(.init(label: "Carbohydrates", value: NutritionFormatter.grams(value)))
        }
        if let value = result.fatG {
            resultItems.append(.init(label: "Total fat", value: NutritionFormatter.grams(value)))
        }
        if let value = result.sugarG {
            resultItems.append(.init(label: "Sugar", value: NutritionFormatter.grams(value)))
        }
        if let value = result.fiberG {
            resultItems.append(.init(label: "Dietary fiber", value: NutritionFormatter.grams(value)))
        }
        if let value = result.sodiumMg {
            resultItems.append(.init(label: "Sodium", value: NutritionFormatter.milligrams(value)))
        }
        if let value = result.calciumMg {
            resultItems.append(.init(label: "Calcium", value: NutritionFormatter.milligrams(value)))
        }
        if let value = result.ironMg {
            resultItems.append(.init(label: "Iron", value: NutritionFormatter.milligrams(value)))
        }
        if let value = result.magnesiumMg {
            resultItems.append(.init(label: "Magnesium", value: NutritionFormatter.milligrams(value)))
        }
        if let value = result.potassiumMg {
            resultItems.append(.init(label: "Potassium", value: NutritionFormatter.milligrams(value)))
        }
        if let value = result.vitaminAUg {
            resultItems.append(.init(label: "Vitamin A", value: NutritionFormatter.micrograms(value)))
        }
        if let value = result.vitaminCMg {
            resultItems.append(.init(label: "Vitamin C", value: NutritionFormatter.milligrams(value)))
        }
        if let value = result.vitaminDUg {
            resultItems.append(.init(label: "Vitamin D", value: NutritionFormatter.micrograms(value)))
        }
        if let value = result.vitaminEMg {
            resultItems.append(.init(label: "Vitamin E", value: NutritionFormatter.milligrams(value)))
        }
        if let value = result.vitaminKUg {
            resultItems.append(.init(label: "Vitamin K", value: NutritionFormatter.micrograms(value)))
        }
        if let value = result.thiamineMg {
            resultItems.append(.init(label: "Thiamine (B1)", value: NutritionFormatter.milligrams(value)))
        }
        if let value = result.riboflavinMg {
            resultItems.append(.init(label: "Riboflavin (B2)", value: NutritionFormatter.milligrams(value)))
        }
        if let value = result.niacinMg {
            resultItems.append(.init(label: "Niacin (B3)", value: NutritionFormatter.milligrams(value)))
        }
        if let value = result.vitaminB6Mg {
            resultItems.append(.init(label: "Vitamin B6", value: NutritionFormatter.milligrams(value)))
        }
        if let value = result.folateUg {
            resultItems.append(.init(label: "Folate", value: NutritionFormatter.micrograms(value)))
        }
        if let value = result.vitaminB12Ug {
            resultItems.append(.init(label: "Vitamin B12", value: NutritionFormatter.micrograms(value)))
        }
        if let value = result.saturatedFatG {
            resultItems.append(.init(label: "Saturated fat", value: NutritionFormatter.grams(value)))
        }
        if let value = result.monounsaturatedFatG {
            resultItems.append(.init(label: "Monounsaturated fat", value: NutritionFormatter.grams(value)))
        }
        if let value = result.polyunsaturatedFatG {
            resultItems.append(.init(label: "Polyunsaturated fat", value: NutritionFormatter.grams(value)))
        }
        if let value = result.cholesterolMg {
            resultItems.append(.init(label: "Cholesterol", value: NutritionFormatter.milligrams(value)))
        }
        return resultItems
    }
}

private struct NutritionDisplayItem: Identifiable {
    let label: String
    let value: String
    var id: String { label }
}
