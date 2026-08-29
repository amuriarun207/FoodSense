import Foundation

/// In-memory repository for previews and unit tests. Does not touch SwiftData.
@MainActor
final class InMemoryFoodRepository: FoodRepository {
    private var foods: [Food]
    private var sources: [Source]
    private let searchEngine: FoodSearchEngine
    var metadata: (version: String, foodCount: Int, importedAt: Date)?
    private let recentlyViewedLimit = 20

    init(foods: [Food] = [], sources: [Source] = [], searchEngine: FoodSearchEngine = FoodSearchEngine()) {
        self.foods = foods
        self.sources = sources
        self.searchEngine = searchEngine
        self.metadata = ("1.0.0", foods.count, Date())
    }

    func search(query: String) async throws -> [Food] {
        searchEngine.search(query: query, foods: foods)
    }

    func food(id: String) async throws -> Food? {
        foods.first { $0.id == id }
    }

    func foods(category: FoodCategory) async throws -> [Food] {
        foods.filter { $0.category == category }.sorted { $0.name < $1.name }
    }

    func foods(in group: CategoryGroup) async throws -> [Food] {
        let allowed = Set(group.foodCategories)
        return foods.filter { allowed.contains($0.category) }.sorted { $0.name < $1.name }
    }

    func allFoods() async throws -> [Food] {
        foods.sorted { $0.name < $1.name }
    }

    func favoriteFoods() async throws -> [Food] {
        foods.filter(\.isFavorite).sorted { $0.name < $1.name }
    }

    func recentlyViewedFoods(limit: Int) async throws -> [Food] {
        foods
            .filter { $0.lastViewedAt != nil }
            .sorted { lhs, rhs in
                (lhs.lastViewedAt ?? .distantPast) > (rhs.lastViewedAt ?? .distantPast)
            }
            .prefix(max(limit, 0))
            .map { $0 }
    }

    func exampleFoods() async throws -> [Food] {
        Array(foods.prefix(6))
    }

    func sources(for food: Food) async throws -> [Source] {
        let ids = Set(food.sourceIDs)
        return sources.filter { ids.contains($0.id) }
    }

    func source(id: String) async throws -> Source? {
        sources.first { $0.id == id }
    }

    func setFavorite(foodID: String, isFavorite: Bool) async throws {
        guard let index = foods.firstIndex(where: { $0.id == foodID }) else {
            throw FoodRepositoryError.foodNotFound(id: foodID)
        }
        foods[index].isFavorite = isFavorite
    }

    func markViewed(foodID: String) async throws {
        guard let index = foods.firstIndex(where: { $0.id == foodID }) else {
            throw FoodRepositoryError.foodNotFound(id: foodID)
        }
        foods[index].lastViewedAt = Date()
        let viewed = foods
            .enumerated()
            .filter { $0.element.lastViewedAt != nil }
            .sorted { ($0.element.lastViewedAt ?? .distantPast) > ($1.element.lastViewedAt ?? .distantPast) }
        for extra in viewed.dropFirst(recentlyViewedLimit) {
            foods[extra.offset].lastViewedAt = nil
        }
    }

    func seedMetadata() async throws -> (version: String, foodCount: Int, importedAt: Date)? {
        metadata
    }
}
