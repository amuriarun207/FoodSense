import SwiftUI
import SwiftData
import UIKit

@main
struct FoodSenseApp: App {
    @State private var appModel = AppModel()

    init() {
        if ProcessInfo.processInfo.arguments.contains("-UITesting") {
            UIView.setAnimationsEnabled(false)
        }
    }

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
