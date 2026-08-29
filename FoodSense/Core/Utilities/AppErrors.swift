import Foundation

nonisolated enum SeedDataError: LocalizedError, Equatable {
    case missingResource(name: String)
    case invalidJSON(name: String, underlying: String)
    case emptyDataset
    case persistence(String)

    var errorDescription: String? {
        switch self {
        case .missingResource(let name):
            return "The bundled file \(name) could not be found."
        case .invalidJSON(let name, let underlying):
            return "The bundled file \(name) could not be read. \(underlying)"
        case .emptyDataset:
            return "No valid foods were found in the seed data."
        case .persistence(let message):
            return "Local storage could not be updated. \(message)"
        }
    }
}

nonisolated enum FoodRepositoryError: LocalizedError, Equatable {
    case foodNotFound(id: String)
    case persistence(String)

    var errorDescription: String? {
        switch self {
        case .foodNotFound(let id):
            return "That food could not be found (\(id))."
        case .persistence(let message):
            return message
        }
    }
}

nonisolated enum SeedImportStatus: Equatable, Sendable {
    case alreadyImported(version: String)
    case imported(version: String, foodCount: Int, sourceCount: Int, skippedCount: Int)
    case migrated(from: String, to: String, foodCount: Int)
}
