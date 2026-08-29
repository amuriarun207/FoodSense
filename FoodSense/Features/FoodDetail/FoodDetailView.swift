import SwiftUI

struct FoodDetailView: View {
    let foodID: String
    @Environment(\.foodRepository) private var repository
    @Environment(\.nutritionCalculator) private var calculator
    @State private var viewModel: FoodDetailViewModel?

    var body: some View {
        Group {
            if let viewModel {
                FoodDetailContentView(viewModel: viewModel)
            } else {
                ProgressView("Loading")
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = FoodDetailViewModel(
                    foodID: foodID,
                    repository: repository,
                    calculator: calculator
                )
            }
        }
        .task {
            if viewModel == nil {
                viewModel = FoodDetailViewModel(
                    foodID: foodID,
                    repository: repository,
                    calculator: calculator
                )
            }
            await viewModel?.load()
        }
    }
}

private struct FoodDetailContentView: View {
    @Bindable var viewModel: FoodDetailViewModel

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.food == nil {
                ProgressView("Loading food")
            } else if viewModel.notFound {
                ContentUnavailableView(
                    "Food not found",
                    systemImage: "fork.knife.circle",
                    description: Text("This food is not in the local database.")
                )
            } else if let food = viewModel.food {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        header(food)
                        if food.isDemo {
                            demoBanner
                        }
                        NutritionCardGrid(
                            result: per100Result(food),
                            title: "Nutrition per 100g"
                        )
                        QuantitySelectorView(
                            presets: QuantityPreset.defaults,
                            selectedPreset: $viewModel.selectedPreset,
                            customText: $viewModel.customGramsText,
                            onSelect: viewModel.select(preset:),
                            onCustomCommit: viewModel.applyCustomQuantity
                        )
                        if let calculated = viewModel.calculated {
                            NutritionCardGrid(
                                result: calculated,
                                title: "For \(NutritionFormatter.number(viewModel.quantityGrams)) g"
                            )
                        }
                        HealthProfileView(profile: food.healthProfile)
                        sourcesSection
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
            } else if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView(
                    "Could not open food",
                    systemImage: "exclamationmark.triangle",
                    description: Text(errorMessage)
                )
            }
        }
        .navigationTitle(viewModel.food?.name ?? "Food")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await viewModel.toggleFavorite() }
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(viewModel.isFavorite ? .red : .primary)
                }
                .accessibilityLabel(viewModel.isFavorite ? "Remove from favorites" : "Add to favorites")
                .disabled(viewModel.food == nil)
            }
        }
    }

    private func header(_ food: Food) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(food.name)
                .font(.largeTitle.bold())
            if let local = food.primaryLocalName {
                Text(local)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            Text(food.category.displayName)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.tint.opacity(0.15), in: Capsule())
            if !food.regionalNamesDisplay.isEmpty {
                Text(food.regionalNamesDisplay)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if let scientific = food.scientificName, !scientific.isEmpty {
                Text(scientific)
                    .font(.subheadline.italic())
                    .foregroundStyle(.secondary)
            }
            Text("Typical serving: \(food.serving.displayText)")
                .font(.subheadline)
        }
        .accessibilityElement(children: .combine)
    }

    private var demoBanner: some View {
        Text("This is sample/demo data for development. It is not an IFCT record.")
            .font(.footnote)
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.orange.opacity(0.18), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .accessibilityLabel("Demo data warning")
    }

    private var sourcesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sources")
                .font(.title3.weight(.semibold))
            if viewModel.sources.isEmpty {
                Text("No sources are listed for this food yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.sources) { source in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(source.displayLine)
                            .font(.subheadline.weight(.medium))
                        if let reference = source.reference, !reference.isEmpty {
                            Text(reference)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        Text(source.type.displayName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
    }

    private func per100Result(_ food: Food) -> NutritionResult {
        NutritionCalculator().calculate(food: food, quantityGrams: 100)
    }
}

#Preview {
    NavigationStack {
        FoodDetailView(foodID: PreviewData.pomegranate.id)
    }
    .environment(\.foodRepository, InMemoryFoodRepository(foods: PreviewData.foods, sources: PreviewData.sources))
}
