import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class AppModel {
    let modelContainer: ModelContainer
    let foodRepository: any FoodRepository
    let nutritionCalculator = NutritionCalculator()
    var isReady = false
    var isImporting = true
    var launchError: String?

    init(inMemory: Bool = false) {
        let container: ModelContainer
        if let created = Self.makeContainer(inMemory: inMemory) {
            container = created
        } else if let fallback = Self.makeContainer(inMemory: true) {
            container = fallback
            launchError = "Local storage could not be opened. Using a temporary in-memory database."
        } else {
            let schema = PersistenceController.schema
            let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            container = try! ModelContainer(for: schema, configurations: [configuration])
            launchError = "Local storage could not be opened. Using a temporary in-memory database."
        }
        self.modelContainer = container
        self.foodRepository = SwiftDataFoodRepository(modelContext: container.mainContext)
    }

    func bootstrap() async {
        isImporting = true
        do {
            let importer = SeedDataImporter(modelContext: modelContainer.mainContext)
            _ = try importer.importIfNeeded()
        } catch {
            launchError = error.localizedDescription
        }
        isImporting = false
        isReady = true
    }

    private static func makeContainer(inMemory: Bool) -> ModelContainer? {
        try? PersistenceController.makeContainer(inMemory: inMemory)
    }
}
