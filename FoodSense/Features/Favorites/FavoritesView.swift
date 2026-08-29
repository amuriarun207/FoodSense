import SwiftUI

struct FavoritesView: View {
    @Environment(\.foodRepository) private var repository
    @State private var foods: [Food] = []
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let errorMessage {
                ContentUnavailableView("Could not load favorites", systemImage: "exclamationmark.triangle", description: Text(errorMessage))
            } else if foods.isEmpty {
                ContentUnavailableView(
                    "No favorites yet",
                    systemImage: "heart",
                    description: Text("Open a food and tap the heart to save it offline.")
                )
            } else {
                List(foods) { food in
                    NavigationLink {
                        FoodDetailView(foodID: food.id)
                    } label: {
                        FoodRowView(food: food)
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        .task {
            await load()
        }
        .refreshable {
            await load()
        }
    }

    private func load() async {
        errorMessage = nil
        do {
            foods = try await repository.favoriteFoods()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
