import Foundation

nonisolated enum SearchRank: Int, Comparable, Sendable {
    case exactName = 0
    case startsWithName = 1
    case exactAlias = 2
    case exactRegionalName = 3
    case contains = 4

    static func < (lhs: SearchRank, rhs: SearchRank) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

nonisolated struct FoodSearchEngine: Sendable {
    func search(query: String, foods: [Food]) -> [Food] {
        let normalizedQuery = SearchNormalizer.normalize(query)
        guard !normalizedQuery.isEmpty else { return [] }

        let scored: [(Food, SearchRank)] = foods.compactMap { food in
            guard let rank = rank(food: food, query: normalizedQuery) else { return nil }
            return (food, rank)
        }

        return scored
            .sorted { lhs, rhs in
                if lhs.1 != rhs.1 {
                    return lhs.1 < rhs.1
                }
                return lhs.0.name.localizedCaseInsensitiveCompare(rhs.0.name) == .orderedAscending
            }
            .map(\.0)
    }

    func rank(food: Food, query: String) -> SearchRank? {
        let normalizedQuery = SearchNormalizer.normalize(query)
        guard !normalizedQuery.isEmpty else { return nil }

        let name = SearchNormalizer.normalize(food.name)
        if name == normalizedQuery {
            return .exactName
        }
        if name.hasPrefix(normalizedQuery) {
            return .startsWithName
        }

        let aliases = food.aliases.map(SearchNormalizer.normalize)
        if aliases.contains(normalizedQuery) {
            return .exactAlias
        }

        let regional = food.regionalNames.values.map(SearchNormalizer.normalize)
        if regional.contains(normalizedQuery) {
            return .exactRegionalName
        }

        if name.contains(normalizedQuery) {
            return .contains
        }
        if aliases.contains(where: { $0.contains(normalizedQuery) }) {
            return .contains
        }
        if regional.contains(where: { $0.contains(normalizedQuery) }) {
            return .contains
        }

        let categoryName = SearchNormalizer.normalize(food.category.displayName)
        let categoryRaw = SearchNormalizer.normalize(food.category.rawValue)
        if categoryName.contains(normalizedQuery) || categoryRaw == normalizedQuery {
            return .contains
        }

        if let scientific = food.scientificName {
            let scientificNormalized = SearchNormalizer.normalize(scientific)
            if scientificNormalized.contains(normalizedQuery) {
                return .contains
            }
        }

        return nil
    }
}
