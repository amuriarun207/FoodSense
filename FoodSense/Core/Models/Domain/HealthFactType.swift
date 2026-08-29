import Foundation

nonisolated enum HealthFactType: String, Codable, CaseIterable, Hashable, Sendable {
    case benefit
    case consideration
    case excessIntake
    case general

    var displayName: String {
        switch self {
        case .benefit: return "Benefit"
        case .consideration: return "Consideration"
        case .excessIntake: return "Excess intake"
        case .general: return "General"
        }
    }
}
