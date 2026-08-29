import Foundation

nonisolated enum SourceType: String, Codable, CaseIterable, Hashable, Sendable {
    case compositionTable
    case dietaryGuideline
    case scientificReview
    case demoSample
    case other

    var displayName: String {
        switch self {
        case .compositionTable: return "Food composition table"
        case .dietaryGuideline: return "Dietary guideline"
        case .scientificReview: return "Scientific review"
        case .demoSample: return "Demo sample"
        case .other: return "Other"
        }
    }
}
