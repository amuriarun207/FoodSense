import Foundation

/// Strength of curated evidence for a health fact.
/// `limited` does not mean a claim is medically proven.
nonisolated enum EvidenceLevel: String, Codable, CaseIterable, Hashable, Sendable {
    case established
    case moderate
    case limited
    case insufficient

    var displayName: String {
        switch self {
        case .established: return "Established"
        case .moderate: return "Moderate"
        case .limited: return "Limited"
        case .insufficient: return "Insufficient"
        }
    }

    var explanatoryText: String {
        switch self {
        case .established:
            return "Supported by well-established nutrition composition or widely accepted dietary guidance."
        case .moderate:
            return "Supported by curated nutrition data, with room for variation by variety and preparation."
        case .limited:
            return "Based on limited curated information. This does not mean the claim is medically proven."
        case .insufficient:
            return "Not enough curated information is available to describe this in detail."
        }
    }
}
