import Foundation

protocol FoodRepository: Sendable {
    func search(query: String) async throws -> [Food]
    func food(id: String) async throws -> Food?
    func foods(category: FoodCategory) async throws -> [Food]
    func foods(in group: CategoryGroup) async throws -> [Food]
    func allFoods() async throws -> [Food]
    func favoriteFoods() async throws -> [Food]
    func recentlyViewedFoods(limit: Int) async throws -> [Food]
    func exampleFoods() async throws -> [Food]
    func sources(for food: Food) async throws -> [Source]
    func source(id: String) async throws -> Source?
    func setFavorite(foodID: String, isFavorite: Bool) async throws
    func markViewed(foodID: String) async throws
    func seedMetadata() async throws -> (version: String, foodCount: Int, importedAt: Date)?
}
