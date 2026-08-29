import SwiftUI
import SwiftData

@main
struct FoodSenseApp: App {
    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appModel)
                .environment(\.foodRepository, appModel.foodRepository)
                .environment(\.nutritionCalculator, appModel.nutritionCalculator)
                .task {
                    await appModel.bootstrap()
                }
        }
        .modelContainer(appModel.modelContainer)
    }
}
