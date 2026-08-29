import Foundation
import SwiftData

enum PersistenceController {
    static let schema = Schema([
        FoodEntity.self,
        SourceEntity.self,
        HealthFactEntity.self,
        SeedMetadataEntity.self
    ])

    static func makeContainer(inMemory: Bool = false) throws -> ModelContainer {
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}
