import Foundation

nonisolated struct Serving: Hashable, Sendable, Codable {
    let amount: Double
    let unit: String

    var displayText: String {
        let amountText = NutritionFormatter.number(amount)
        return "\(amountText) \(unit)"
    }

    static let grams100 = Serving(amount: 100, unit: "g")
}
