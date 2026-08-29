import Foundation
import SwiftData

/// Local SwiftData-backed repository. Future remote or AI layers can sit behind the same protocol.
@MainActor
final class SwiftDataFoodRepository: FoodRepository {
    private let modelContext: ModelContext
    private let searchEngine: FoodSearchEngine
    private let recentlyViewedLimit = 20

    init(modelContext: ModelContext, searchEngine: FoodSearchEngine = FoodSearchEngine()) {
        self.modelContext = modelContext
        self.searchEngine = searchEngine
    }

    func search(query: String) async throws -> [Food] {
        searchEngine.search(query: query, foods: try fetchAllDomainFoods())
    }

    func food(id: String) async throws -> Food? {
        try fetchEntity(id: id)?.toDomain()
    }

    func foods(category: FoodCategory) async throws -> [Food] {
        let raw = category.rawValue
        let descriptor = FetchDescriptor<FoodEntity>(
            predicate: #Predicate { $0.categoryRaw == raw },
            sortBy: [SortDescriptor(\.name)]
        )
        return try modelContext.fetch(descriptor).map { $0.toDomain() }
    }

    func foods(in group: CategoryGroup) async throws -> [Food] {
        let allowed = Set(group.foodCategories.map(\.rawValue))
        return try fetchAllDomainFoods()
            .filter { allowed.contains($0.category.rawValue) }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    func allFoods() async throws -> [Food] {
        try fetchAllDomainFoods()
    }

    func favoriteFoods() async throws -> [Food] {
        let descriptor = FetchDescriptor<FoodEntity>(
            predicate: #Predicate { $0.isFavorite == true },
            sortBy: [SortDescriptor(\.name)]
        )
        return try modelContext.fetch(descriptor).map { $0.toDomain() }
    }

    func recentlyViewedFoods(limit: Int) async throws -> [Food] {
        var descriptor = FetchDescriptor<FoodEntity>(
            predicate: #Predicate { $0.lastViewedAt != nil },
            sortBy: [SortDescriptor(\.lastViewedAt, order: .reverse)]
        )
        descriptor.fetchLimit = max(limit, 0)
        return try modelContext.fetch(descriptor).map { $0.toDomain() }
    }

    func exampleFoods() async throws -> [Food] {
        let preferredIDs = [
            "food-pomegranate",
            "food-turmeric",
            "food-rice-raw",
            "food-dosa",
            "food-sugar",
            "food-toor-dal"
        ]
        let foods = try fetchAllDomainFoods()
        let byID = Dictionary(uniqueKeysWithValues: foods.map { ($0.id, $0) })
        let preferred = preferredIDs.compactMap { byID[$0] }
        if preferred.count >= 4 {
            return preferred
        }
        return Array(foods.prefix(6))
    }

    func sources(for food: Food) async throws -> [Source] {
        var result: [Source] = []
        var seen = Set<String>()
        for sourceID in food.sourceIDs {
            if seen.contains(sourceID) { continue }
            seen.insert(sourceID)
            if let source = try await source(id: sourceID) {
                result.append(source)
            }
        }
        return result
    }

    func source(id: String) async throws -> Source? {
        try fetchSourceEntity(id: id)?.toDomain()
    }

    func setFavorite(foodID: String, isFavorite: Bool) async throws {
        guard let entity = try fetchEntity(id: foodID) else {
            throw FoodRepositoryError.foodNotFound(id: foodID)
        }
        entity.isFavorite = isFavorite
        try save()
    }

    func markViewed(foodID: String) async throws {
        guard let entity = try fetchEntity(id: foodID) else {
            throw FoodRepositoryError.foodNotFound(id: foodID)
        }
        entity.lastViewedAt = Date()
        try trimRecentlyViewed()
        try save()
    }

    func seedMetadata() async throws -> (version: String, foodCount: Int, importedAt: Date)? {
        var descriptor = FetchDescriptor<SeedMetadataEntity>()
        descriptor.fetchLimit = 1
        guard let meta = try modelContext.fetch(descriptor).first else { return nil }
        return (meta.version, meta.foodCount, meta.importedAt)
    }

    private func fetchAllDomainFoods() throws -> [Food] {
        let descriptor = FetchDescriptor<FoodEntity>(sortBy: [SortDescriptor(\.name)])
        return try modelContext.fetch(descriptor).map { $0.toDomain() }
    }

    private func fetchEntity(id: String) throws -> FoodEntity? {
        var descriptor = FetchDescriptor<FoodEntity>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    private func fetchSourceEntity(id: String) throws -> SourceEntity? {
        var descriptor = FetchDescriptor<SourceEntity>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    private func trimRecentlyViewed() throws {
        let descriptor = FetchDescriptor<FoodEntity>(
            predicate: #Predicate { $0.lastViewedAt != nil },
            sortBy: [SortDescriptor(\.lastViewedAt, order: .reverse)]
        )
        let viewed = try modelContext.fetch(descriptor)
        guard viewed.count > recentlyViewedLimit else { return }
        for entity in viewed.dropFirst(recentlyViewedLimit) {
            entity.lastViewedAt = nil
        }
    }

    private func save() throws {
        do {
            try modelContext.save()
        } catch {
            throw FoodRepositoryError.persistence(error.localizedDescription)
        }
    }
}
