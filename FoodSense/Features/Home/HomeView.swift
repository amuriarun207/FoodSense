import SwiftUI

struct HomeView: View {
    @Environment(\.foodRepository) private var repository
    @State private var viewModel: HomeViewModel?

    var body: some View {
        Group {
            if let viewModel {
                HomeContentView(viewModel: viewModel)
            } else {
                ProgressView("Loading")
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = HomeViewModel(repository: repository)
            }
        }
        .task {
            if viewModel == nil {
                viewModel = HomeViewModel(repository: repository)
            }
            await viewModel?.load()
        }
    }
}

private struct HomeContentView: View {
    @Bindable var viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                searchField

                if viewModel.isQueryActive {
                    searchResults
                } else {
                    browseContent
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .navigationTitle("Food Sense")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground))
        .navigationDestination(for: String.self) { foodID in
            FoodDetailView(foodID: foodID)
        }
        .refreshable {
            await viewModel.load()
        }
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            TextField("Search food, spice, ingredient...", text: $viewModel.query)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .accessibilityIdentifier("search-field")
                .onChange(of: viewModel.query) {
                    viewModel.searchDebounced()
                }
            if !viewModel.query.isEmpty {
                Button {
                    viewModel.query = ""
                    viewModel.searchResults = []
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(12)
        .background(.background, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Search food, spice, ingredient")
    }

    @ViewBuilder
    private var searchResults: some View {
        if viewModel.isSearching && viewModel.searchResults.isEmpty {
            ProgressView("Searching")
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
        } else if viewModel.searchResults.isEmpty {
            ContentUnavailableView.search(text: viewModel.query)
        } else {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(viewModel.searchResults.count) matches")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.searchResults) { food in
                        NavigationLink(value: food.id) {
                            FoodRowView(food: food)
                                .padding(.vertical, 8)
                        }
                        Divider()
                    }
                }
            }
        }
    }

    private var browseContent: some View {
        VStack(alignment: .leading, spacing: 28) {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            categorySection
            foodSection(title: "Recently viewed", foods: viewModel.recentlyViewed, empty: "Foods you open will appear here.")
            foodSection(title: "Favorites", foods: viewModel.favorites, empty: "Tap the heart on a food to save it.")
            foodSection(title: "Example foods", foods: viewModel.examples, empty: "No example foods are available yet.")
        }
    }

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Popular categories")
                .font(.title3.weight(.semibold))
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(CategoryGroup.allCases) { group in
                    NavigationLink {
                        CategoryFoodsView(group: group)
                    } label: {
                        Label(group.displayName, systemImage: group.systemImage)
                            .font(.subheadline.weight(.medium))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(.background, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .accessibilityLabel(group.displayName)
                }
            }
        }
    }

    private func foodSection(title: String, foods: [Food], empty: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.weight(.semibold))
            if foods.isEmpty {
                Text(empty)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.background, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            } else {
                VStack(spacing: 0) {
                    ForEach(foods) { food in
                        NavigationLink(value: food.id) {
                            FoodRowView(food: food)
                                .padding(.vertical, 8)
                        }
                        if food.id != foods.last?.id {
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 12)
                .background(.background, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(\.foodRepository, InMemoryFoodRepository(foods: PreviewData.foods, sources: PreviewData.sources))
}
