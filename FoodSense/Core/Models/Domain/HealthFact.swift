import Foundation

/// A single curated health or nutrition statement attached to a food.
nonisolated struct HealthFact: Identifiable, Hashable, Sendable, Codable {
    let id: String
    let title: String
    let description: String
    let type: HealthFactType
    let evidenceLevel: EvidenceLevel
    let sourceIDs: [String]
}
