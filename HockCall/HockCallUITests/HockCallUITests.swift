import XCTest

final class HockCallUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    @MainActor
    func testLoginScreenLoads() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.textFields["usernameField"].exists)
        XCTAssertTrue(app.secureTextFields["passwordField"].exists)
        XCTAssertTrue(app.buttons["signInButton"].exists)
        XCTAssertTrue(app.buttons["rememberMeButton"].exists)
        XCTAssertTrue(app.buttons["signInAutomaticallyButton"].exists)
        XCTAssertTrue(app.buttons["createAccountButton"].exists)
        XCTAssertTrue(app.buttons["forgotPasswordButton"].exists)
        XCTAssertFalse(app.buttons["signInButton"].isEnabled)

        let usernameField = app.textFields["usernameField"]
        let passwordField = app.secureTextFields["passwordField"]
        let signInButton = app.buttons["signInButton"]

        usernameField.tap()
        usernameField.typeText("hockpond")
        passwordField.tap()
        passwordField.typeText("123456")
        XCTAssertTrue(signInButton.isEnabled)

        signInButton.tap()

        XCTAssertEqual(signInButton.label, "Signing In...")
        XCTAssertFalse(signInButton.isEnabled)
        XCTAssertFalse(usernameField.isEnabled)
        XCTAssertFalse(passwordField.isEnabled)

        sleep(3)

        XCTAssertEqual(signInButton.label, "Sign In")
        XCTAssertTrue(signInButton.isEnabled)
        XCTAssertTrue(usernameField.isEnabled)
        XCTAssertTrue(passwordField.isEnabled)
    }
}
