import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {
    var query = ""
    var searchResults: [Food] = []
    var recentlyViewed: [Food] = []
    var favorites: [Food] = []
    var examples: [Food] = []
    var isSearching = false
    var errorMessage: String?

    private let repository: any FoodRepository
    private var searchTask: Task<Void, Never>?

    init(repository: any FoodRepository) {
        self.repository = repository
    }

    var isQueryActive: Bool {
        !SearchNormalizer.normalize(query).isEmpty
    }

    func load() async {
        errorMessage = nil
        do {
            async let recents = repository.recentlyViewedFoods(limit: 20)
            async let favs = repository.favoriteFoods()
            async let sample = repository.exampleFoods()
            recentlyViewed = try await recents
            favorites = try await favs
            examples = try await sample
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func searchDebounced() {
        searchTask?.cancel()
        let currentQuery = query
        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(120))
            guard !Task.isCancelled else { return }
            await self?.performSearch(currentQuery)
        }
    }

    private func performSearch(_ query: String) async {
        let normalized = SearchNormalizer.normalize(query)
        guard !normalized.isEmpty else {
            searchResults = []
            isSearching = false
            return
        }
        isSearching = true
        do {
            searchResults = try await repository.search(query: query)
        } catch {
            errorMessage = error.localizedDescription
            searchResults = []
        }
        isSearching = false
    }
}
