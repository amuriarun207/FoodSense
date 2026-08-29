import SwiftUI

struct FoodRowView: View {
    let food: Food

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: food.category.systemImage)
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 32, height: 32)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                if let local = food.primaryLocalName, SearchNormalizer.normalize(local) != SearchNormalizer.normalize(food.name) {
                    Text(local)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Text(food.category.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            Text(food.shortNutritionSummary)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
    }

    private var accessibilityText: String {
        var parts = [food.name]
        if let local = food.primaryLocalName {
            parts.append(local)
        }
        parts.append(food.category.displayName)
        parts.append(food.shortNutritionSummary)
        return parts.joined(separator: ", ")
    }
}

#Preview {
    List {
        FoodRowView(food: PreviewData.pomegranate)
        FoodRowView(food: PreviewData.turmeric)
    }
}
