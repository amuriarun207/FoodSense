import Foundation

/// A curated citation for nutrition or health information.
/// V1 stores name and reference text only — URLs are not fabricated.
nonisolated struct Source: Identifiable, Hashable, Sendable, Codable {
    let id: String
    let name: String
    let organization: String?
    let year: Int?
    let reference: String?
    let type: SourceType

    var displayLine: String {
        var parts: [String] = [name]
        if let organization, !organization.isEmpty {
            parts.append(organization)
        }
        if let year {
            parts.append(String(year))
        }
        return parts.joined(separator: " · ")
    }
}
