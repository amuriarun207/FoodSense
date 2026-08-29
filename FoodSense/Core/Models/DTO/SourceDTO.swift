import Foundation

nonisolated struct SourceDTO: Codable, Hashable, Sendable {
    let id: String
    let name: String
    let organization: String?
    let year: Int?
    let reference: String?
    let type: String?

    func toDomain() -> Source? {
        let trimmedID = id.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedID.isEmpty, !trimmedName.isEmpty else { return nil }
        let resolvedType = SourceType(rawValue: type ?? "") ?? .other
        return Source(
            id: trimmedID,
            name: trimmedName,
            organization: organization,
            year: year,
            reference: reference,
            type: resolvedType
        )
    }
}
