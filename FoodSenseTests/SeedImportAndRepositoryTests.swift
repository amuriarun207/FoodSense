import Foundation
import SwiftData
import Testing
@testable import FoodSense

@Suite
@MainActor
struct SeedImportAndRepositoryTests {
    @Test func importsBundledSeedOnce() throws {
        let container = try PersistenceController.makeContainer(inMemory: true)
        let importer = SeedDataImporter(modelContext: container.mainContext)

        let first = try importer.importIfNeeded()
        guard case .imported(_, let foodCount, _, _) = first else {
            Issue.record("Expected first launch import, got \(String(describing: first))")
            return
        }
        #expect(foodCount > 0)

        let second = try importer.importIfNeeded()
        guard case .alreadyImported(let version) = second else {
            Issue.record("Expected skip on second launch, got \(String(describing: second))")
            return
        }
        #expect(version == SeedDataVersion.current)
    }

    @Test func importedFoodsAreSearchable() async throws {
        let container = try PersistenceController.makeContainer(inMemory: true)
        let importer = SeedDataImporter(modelContext: container.mainContext)
        _ = try importer.importNow()
        let repository = SwiftDataFoodRepository(modelContext: container.mainContext)

        let pomegranate = try await repository.search(query: "anar")
        #expect(pomegranate.first?.name == "Pomegranate")

        let turmeric = try await repository.search(query: "haldi")
        #expect(turmeric.first?.name == "Turmeric")

        let manjal = try await repository.search(query: "manjal")
        #expect(manjal.first?.name == "Turmeric")

        let sugar = try await repository.search(query: "sugar")
        #expect(sugar.contains(where: { $0.name == "Sugar" }))

        let byID = try await repository.food(id: "food-pomegranate")
        #expect(byID?.scientificName == "Punica granatum")
        #expect(byID?.nutrition.energyKcal == 83)
    }

    @Test func favoritesPersistOnTheFood() async throws {
        let container = try PersistenceController.makeContainer(inMemory: true)
        let importer = SeedDataImporter(modelContext: container.mainContext)
        _ = try importer.importNow()
        let repository = SwiftDataFoodRepository(modelContext: container.mainContext)

        try await repository.setFavorite(foodID: "food-pomegranate", isFavorite: true)
        let favorites = try await repository.favoriteFoods()
        #expect(favorites.contains(where: { $0.id == "food-pomegranate" }))

        try await repository.setFavorite(foodID: "food-pomegranate", isFavorite: false)
        let cleared = try await repository.favoriteFoods()
        #expect(!cleared.contains(where: { $0.id == "food-pomegranate" }))
    }

    @Test func recentlyViewedKeepsLatestTwenty() async throws {
        let container = try PersistenceController.makeContainer(inMemory: true)
        let importer = SeedDataImporter(modelContext: container.mainContext)
        _ = try importer.importNow()
        let repository = SwiftDataFoodRepository(modelContext: container.mainContext)

        let all = try await repository.allFoods()
        for food in all.prefix(22) {
            try await repository.markViewed(foodID: food.id)
        }

        let recent = try await repository.recentlyViewedFoods(limit: 20)
        #expect(recent.count == 20)
        #expect(recent.first?.id == all.prefix(22).last?.id)
    }

    @Test func inMemoryRepositoryFavoritesAndRecents() async throws {
        let repository = InMemoryFoodRepository(foods: PreviewData.foods, sources: PreviewData.sources)
        try await repository.setFavorite(foodID: "food-pomegranate", isFavorite: true)
        let favorites = try await repository.favoriteFoods()
        #expect(favorites.map(\.id) == ["food-pomegranate"])

        try await repository.markViewed(foodID: "food-turmeric")
        let recents = try await repository.recentlyViewedFoods(limit: 20)
        #expect(recents.first?.id == "food-turmeric")
    }
}
