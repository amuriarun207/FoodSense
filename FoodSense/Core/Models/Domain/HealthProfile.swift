import Foundation

/// Optional curated health information for a food.
/// Missing or empty profiles must be shown as unavailable — never generated.
nonisolated struct HealthProfile: Hashable, Sendable, Codable {
    let summary: String?
    let benefits: [HealthFact]
    let considerations: [HealthFact]
    let excessIntake: [HealthFact]
    let typicalServingNote: String?
    let evidenceLevel: EvidenceLevel?

    var hasContent: Bool {
        let hasSummary = !(summary?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        return hasSummary
            || !benefits.isEmpty
            || !considerations.isEmpty
            || !excessIntake.isEmpty
    }
}
