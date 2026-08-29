import Foundation

nonisolated struct ServingDTO: Codable, Hashable, Sendable {
    let amount: Double
    let unit: String?

    func toDomain() -> Serving {
        Serving(amount: amount, unit: unit ?? "g")
    }
}
