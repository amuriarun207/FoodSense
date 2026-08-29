import Foundation

nonisolated struct CategoryDTO: Codable, Hashable, Sendable {
    let id: String
    let displayName: String
    let foodCategories: [String]
}
