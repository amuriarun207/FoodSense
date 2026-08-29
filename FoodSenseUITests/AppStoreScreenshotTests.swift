import XCTest

/// Captures the real running app for App Store Connect.
final class AppStoreScreenshotTests: XCTestCase {
    private var screenshotDirectory: URL {
        let simulatorName = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] ?? ""
        let folder = simulatorName.localizedCaseInsensitiveContains("iPad") ? "raw-ipad" : "raw"
        return URL(fileURLWithPath: "/Users/arunkumar/workspace/FoodSense/AppStore/screenshots/\(folder)")
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        try FileManager.default.createDirectory(at: screenshotDirectory, withIntermediateDirectories: true)
    }

    @MainActor
    func testCaptureAppStoreScreenshots() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UITesting"]
        app.launch()

        let searchField = app.textFields["search-field"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 30), "Home search field should appear after seed import")
        XCTAssertTrue(app.staticTexts["Popular categories"].waitForExistence(timeout: 8))

        searchField.tap()
        searchField.typeText("anar")
        XCTAssertTrue(app.staticTexts["Pomegranate"].waitForExistence(timeout: 8))
        dismissKeyboard(app)
        sleepShort()
        capture(app, name: "02-search")

        element(app, id: "food-row-food-pomegranate").tap()
        XCTAssertTrue(app.staticTexts["Nutrition per 100g"].waitForExistence(timeout: 8))
        sleepShort()
        capture(app, name: "03-nutrition")

        swipeUp(app)
        let twoHundred = app.buttons["200 g"]
        XCTAssertTrue(twoHundred.waitForExistence(timeout: 6))
        twoHundred.tap()
        XCTAssertTrue(app.staticTexts["166 kcal"].waitForExistence(timeout: 6))
        sleepShort()
        capture(app, name: "04-quantity")

        swipeUp(app)
        swipeUp(app)
        XCTAssertTrue(app.staticTexts["Health profile"].waitForExistence(timeout: 6))
        sleepShort()
        capture(app, name: "05-health")

        let favorite = app.buttons["Add to favorites"]
        if favorite.waitForExistence(timeout: 2) {
            favorite.tap()
        }

        tapTab(app, "Favorites")
        XCTAssertTrue(app.navigationBars["Favorites"].waitForExistence(timeout: 8) || app.staticTexts["Favorites"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["Pomegranate"].waitForExistence(timeout: 8))
        sleepShort()
        capture(app, name: "06-favorites")

        tapTab(app, "Home")
        if app.navigationBars.buttons["Ahar"].waitForExistence(timeout: 2) {
            app.navigationBars.buttons["Ahar"].tap()
        }
        XCTAssertTrue(searchField.waitForExistence(timeout: 8))
        if app.buttons["Clear search"].waitForExistence(timeout: 2) {
            app.buttons["Clear search"].tap()
        }
        XCTAssertTrue(app.staticTexts["Popular categories"].waitForExistence(timeout: 8))
        sleepShort()
        capture(app, name: "01-home")

        let fruits = app.staticTexts["Fruits"].firstMatch
        XCTAssertTrue(fruits.waitForExistence(timeout: 6))
        fruits.tap()
        XCTAssertTrue(app.navigationBars["Fruits"].waitForExistence(timeout: 8))
        sleepShort()
        capture(app, name: "07-categories")

        if app.navigationBars.buttons["Ahar"].waitForExistence(timeout: 4) {
            app.navigationBars.buttons["Ahar"].tap()
        } else {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        XCTAssertTrue(searchField.waitForExistence(timeout: 8))
        let spices = app.staticTexts["Spices"].firstMatch
        XCTAssertTrue(spices.waitForExistence(timeout: 6))
        spices.tap()
        XCTAssertTrue(app.navigationBars["Spices"].waitForExistence(timeout: 8))
        sleepShort()
        capture(app, name: "09-spices")

        tapTab(app, "Settings")
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 8))
        sleepShort()
        capture(app, name: "08-settings")

        swipeUp(app)
        sleepShort()
        capture(app, name: "10-offline")
    }

    @MainActor
    private func tapTab(_ app: XCUIApplication, _ name: String) {
        let tabBarButton = app.tabBars.buttons[name]
        if tabBarButton.exists {
            tabBarButton.tap()
            return
        }
        let button = app.buttons[name].firstMatch
        XCTAssertTrue(button.waitForExistence(timeout: 4), "Tab \(name) should exist")
        button.tap()
    }

    @MainActor
    private func element(_ app: XCUIApplication, id: String) -> XCUIElement {
        app.descendants(matching: .any)[id].firstMatch
    }

    @MainActor
    private func capture(_ app: XCUIApplication, name: String) {
        let data = app.screenshot().pngRepresentation
        let url = screenshotDirectory.appendingPathComponent("\(name).png")
        do {
            try data.write(to: url)
        } catch {
            XCTFail("Could not write \(name): \(error)")
        }
    }

    @MainActor
    private func dismissKeyboard(_ app: XCUIApplication) {
        if app.keys["search"].exists {
            app.keys["search"].tap()
            return
        }
        if app.buttons["Search"].exists {
            app.buttons["Search"].tap()
            return
        }
        if app.keyboards.buttons["Return"].exists {
            app.keyboards.buttons["Return"].tap()
            return
        }
        app.staticTexts["Ahar"].firstMatch.tap()
    }

    @MainActor
    private func swipeUp(_ app: XCUIApplication) {
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.82))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.28))
        start.press(forDuration: 0.05, thenDragTo: end)
    }

    private func sleepShort() {
        Thread.sleep(forTimeInterval: 0.4)
    }
}
