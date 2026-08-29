import Foundation

nonisolated struct FoodDTO: Codable, Hashable, Sendable {
    let id: String
    let name: String
    let category: String
    let scientificName: String?
    let aliases: [String]?
    let regionalNames: [String: String]?
    let nutrition: NutritionDTO?
    let serving: ServingDTO?
    let healthProfile: HealthProfileDTO?
    let sourceIDs: [String]?
    let demo: Bool?

    var isDemo: Bool { demo ?? false }

    func toDomain(isFavorite: Bool = false, lastViewedAt: Date? = nil) -> Food {
        let resolvedCategory = FoodCategory(rawValue: category) ?? .other
        return Food(
            id: id,
            name: name,
            category: resolvedCategory,
            scientificName: scientificName,
            aliases: aliases ?? [],
            regionalNames: regionalNames ?? [:],
            nutrition: nutrition?.toDomain() ?? .empty,
            serving: serving?.toDomain() ?? .grams100,
            healthProfile: healthProfile?.toDomain(),
            sourceIDs: sourceIDs ?? [],
            isDemo: isDemo,
            isFavorite: isFavorite,
            lastViewedAt: lastViewedAt
        )
    }
}
