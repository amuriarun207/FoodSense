import Foundation

nonisolated enum SeedDataVersion {
    /// Bump this when replacing bundled JSON so the importer re-merges seed records.
    static let current = "1.0.0"
    static let resourceFolder = "SeedData"
}
