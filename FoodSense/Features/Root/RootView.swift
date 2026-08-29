import SwiftUI

struct RootView: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        Group {
            if appModel.isImporting && !appModel.isReady {
                LaunchLoadingView()
            } else if let launchError = appModel.launchError, !appModel.isReady {
                LaunchErrorView(message: launchError) {
                    Task { await appModel.bootstrap() }
                }
            } else {
                MainTabView()
            }
        }
        .overlay(alignment: .top) {
            if let launchError = appModel.launchError, appModel.isReady {
                Text(launchError)
                    .font(.footnote)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(.orange.opacity(0.2))
                    .accessibilityLabel("A data warning occurred: \(launchError)")
            }
        }
    }
}

private struct LaunchLoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Loading food data")
                .font(.headline)
            Text("This happens once on first launch and works fully offline.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .accessibilityElement(children: .combine)
    }
}

private struct LaunchErrorView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("Could not load food data", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Try again", action: retry)
                .buttonStyle(.borderedProminent)
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
        }
    }
}

#Preview {
    RootView()
        .environment(AppModel(inMemory: true))
        .environment(\.foodRepository, InMemoryFoodRepository(foods: PreviewData.foods, sources: PreviewData.sources))
}
