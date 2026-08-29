import Foundation
import SwiftData

@Model
final class SeedMetadataEntity {
    @Attribute(.unique) var key: String
    var version: String
    var importedAt: Date
    var foodCount: Int

    init(key: String = "seed-metadata", version: String, importedAt: Date, foodCount: Int) {
        self.key = key
        self.version = version
        self.importedAt = importedAt
        self.foodCount = foodCount
    }
}
