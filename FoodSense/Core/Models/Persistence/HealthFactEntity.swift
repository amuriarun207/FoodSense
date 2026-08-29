import Foundation
import SwiftData

@Model
final class HealthFactEntity {
    @Attribute(.unique) var id: String
    var title: String
    var factDescription: String
    var typeRaw: String
    var evidenceLevelRaw: String
    var sourceIDs: [String]
    var food: FoodEntity?

    init(
        id: String,
        title: String,
        factDescription: String,
        typeRaw: String,
        evidenceLevelRaw: String,
        sourceIDs: [String],
        food: FoodEntity? = nil
    ) {
        self.id = id
        self.title = title
        self.factDescription = factDescription
        self.typeRaw = typeRaw
        self.evidenceLevelRaw = evidenceLevelRaw
        self.sourceIDs = sourceIDs
        self.food = food
    }

    func toDomain() -> HealthFact {
        HealthFact(
            id: id,
            title: title,
            description: factDescription,
            type: HealthFactType(rawValue: typeRaw) ?? .general,
            evidenceLevel: EvidenceLevel(rawValue: evidenceLevelRaw) ?? .insufficient,
            sourceIDs: sourceIDs
        )
    }
}
