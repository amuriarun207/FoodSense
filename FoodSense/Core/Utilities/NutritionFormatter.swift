import Foundation

nonisolated enum NutritionFormatter {
    /// Formats a number without unnecessary trailing decimals.
    /// 83 → "83", 18.7 → "18.7", 13.67 → "13.7"
    static func number(_ value: Double) -> String {
        let roundedToOne = (value * 10).rounded() / 10
        if roundedToOne == roundedToOne.rounded() {
            return String(Int(roundedToOne.rounded()))
        }
        return String(format: "%.1f", roundedToOne)
    }

    static func calories(_ value: Double) -> String {
        "\(number(value)) kcal"
    }

    static func grams(_ value: Double, label: String? = nil) -> String {
        if let label, !label.isEmpty {
            return "\(number(value)) g \(label)"
        }
        return "\(number(value)) g"
    }

    static func milligrams(_ value: Double, label: String? = nil) -> String {
        if let label, !label.isEmpty {
            return "\(number(value)) mg \(label)"
        }
        return "\(number(value)) mg"
    }

    static func micrograms(_ value: Double, label: String? = nil) -> String {
        if let label, !label.isEmpty {
            return "\(number(value)) µg \(label)"
        }
        return "\(number(value)) µg"
    }
}
