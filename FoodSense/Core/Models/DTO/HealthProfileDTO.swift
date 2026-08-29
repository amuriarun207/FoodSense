import Foundation

nonisolated struct HealthFactDTO: Codable, Hashable, Sendable {
    let id: String
    let title: String
    let description: String
    let type: String?
    let evidenceLevel: String?
    let sourceIDs: [String]?

    func toDomain(defaultType: HealthFactType) -> HealthFact {
        let resolvedType = HealthFactType(rawValue: type ?? "") ?? defaultType
        let resolvedEvidence = EvidenceLevel(rawValue: evidenceLevel ?? "") ?? .insufficient
        return HealthFact(
            id: id,
            title: title,
            description: description,
            type: resolvedType,
            evidenceLevel: resolvedEvidence,
            sourceIDs: sourceIDs ?? []
        )
    }
}

nonisolated struct HealthProfileDTO: Codable, Hashable, Sendable {
    let summary: String?
    let benefits: [HealthFactDTO]?
    let considerations: [HealthFactDTO]?
    let excessIntake: [HealthFactDTO]?
    let typicalServing: String?
    let evidenceLevel: String?

    func toDomain() -> HealthProfile {
        HealthProfile(
            summary: summary,
            benefits: (benefits ?? []).map { $0.toDomain(defaultType: .benefit) },
            considerations: (considerations ?? []).map { $0.toDomain(defaultType: .consideration) },
            excessIntake: (excessIntake ?? []).map { $0.toDomain(defaultType: .excessIntake) },
            typicalServingNote: typicalServing,
            evidenceLevel: evidenceLevel.flatMap(EvidenceLevel.init(rawValue:))
        )
    }
}
