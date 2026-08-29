import SwiftUI

struct CategoryFoodsView: View {
    let group: CategoryGroup
    @Environment(\.foodRepository) private var repository
    @State private var foods: [Food] = []
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let errorMessage {
                ContentUnavailableView("Could not load foods", systemImage: "exclamationmark.triangle", description: Text(errorMessage))
            } else if foods.isEmpty {
                ContentUnavailableView(
                    "No foods in \(group.displayName)",
                    systemImage: group.systemImage,
                    description: Text("This category will fill when more seed data is added.")
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
        .navigationTitle(group.displayName)
        .task {
            do {
                foods = try await repository.foods(in: group)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
