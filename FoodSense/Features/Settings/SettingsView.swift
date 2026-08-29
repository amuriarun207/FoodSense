import SwiftUI

struct SettingsView: View {
    @Environment(\.foodRepository) private var repository
    @State private var foodCount = 0
    @State private var seedVersion = SeedDataVersion.current
    @State private var importedAt: Date?

    var body: some View {
        List {
            Section("About") {
                Text("Ahar is an offline foodIQ / AharIQ nutrition reference. It does not diagnose conditions or provide medical advice.")
            }

            Section("Data") {
                LabeledContent("Seed version", value: seedVersion)
                LabeledContent("Foods on device", value: "\(foodCount)")
                if let importedAt {
                    LabeledContent("Imported", value: importedAt.formatted(date: .abbreviated, time: .shortened))
                }
                Text("Nutrition values come from bundled JSON. Records marked demo are sample data for development and are not IFCT records.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("How to read evidence") {
                ForEach(EvidenceLevel.allCases, id: \.self) { level in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(level.displayName)
                            .font(.subheadline.weight(.semibold))
                        Text(level.explanatoryText)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }

            Section("Privacy") {
                Text("The app does not use the internet, accounts, or cloud sync. Search, favorites, and recently viewed data stay on this device.")
            }
        }
        .navigationTitle("Settings")
        .task {
            do {
                if let meta = try await repository.seedMetadata() {
                    seedVersion = meta.version
                    foodCount = meta.foodCount
                    importedAt = meta.importedAt
                } else {
                    foodCount = try await repository.allFoods().count
                }
            } catch {
                foodCount = 0
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(\.foodRepository, InMemoryFoodRepository(foods: PreviewData.foods, sources: PreviewData.sources))
}
