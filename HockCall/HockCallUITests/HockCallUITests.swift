import XCTest

final class HockCallUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            let app = XCUIApplication()
            app.launchArguments.append("UITEST")
            app.launch()
        }
    }

    @MainActor
    func testLoginScreenElementsExist() throws {
        let app = launchApp()

        XCTAssertTrue(app.textFields["usernameField"].exists)
        XCTAssertTrue(app.secureTextFields["passwordField"].exists)
        XCTAssertTrue(app.buttons["signInButton"].exists)
        XCTAssertTrue(app.buttons["rememberMeButton"].exists)
        XCTAssertTrue(app.buttons["signInAutomaticallyButton"].exists)
        XCTAssertTrue(app.buttons["createAccountButton"].exists)
        XCTAssertTrue(app.buttons["forgotPasswordButton"].exists)
        XCTAssertFalse(app.buttons["signInButton"].isEnabled)
    }

    @MainActor
    func testLoginFlowEnablesButton() throws {
        let app = launchApp()

        let usernameField = app.textFields["usernameField"]
        let passwordField = app.secureTextFields["passwordField"]
        let signInButton = app.buttons["signInButton"]

        usernameField.tap()
        usernameField.typeText("hockpond")

        passwordField.tap()
        passwordField.typeText("123456")

        XCTAssertTrue(signInButton.isEnabled)
    }

    @MainActor
    func testCreateAccountButtonNavigatesToCreateAccountView() throws {
        let app = launchAndOpenCreateAccountView()

        XCTAssertTrue(
            app.textFields["createAccountEmailField"].waitForExistence(timeout: 5)
        )
    }

    @MainActor
    func testCreateAccountViewElementsExist() throws {
        let app = launchAndOpenCreateAccountView()

        XCTAssertTrue(app.textFields["createAccountEmailField"].exists)
        XCTAssertTrue(app.textFields["createAccountUsernameField"].exists)
        XCTAssertTrue(app.secureTextFields["createAccountPasswordField"].exists)
        XCTAssertTrue(app.secureTextFields["createAccountConfirmPasswordField"].exists)
        XCTAssertTrue(app.buttons["createAccountSubmitButton"].exists)
        XCTAssertTrue(app.buttons["Sign In"].exists)
        XCTAssertFalse(app.buttons["createAccountSubmitButton"].isEnabled)
    }

    @MainActor
    func testCreateAccountInvalidEmailKeepsSubmitDisabled() throws {
        let app = launchAndOpenCreateAccountView()

        let emailField = app.textFields["createAccountEmailField"]
        let usernameField = app.textFields["createAccountUsernameField"]
        let passwordField = app.secureTextFields["createAccountPasswordField"]
        let confirmPasswordField = app.secureTextFields["createAccountConfirmPasswordField"]
        let createAccountButton = app.buttons["createAccountSubmitButton"]

        emailField.tap()
        emailField.typeText("invalid-email")

        usernameField.tap()
        usernameField.typeText("hockpond")

        passwordField.tap()
        passwordField.typeText("123456")

        confirmPasswordField.tap()
        confirmPasswordField.typeText("123456")

        XCTAssertFalse(createAccountButton.isEnabled)
    }

    @MainActor
    func testCreateAccountValidFormEnablesSubmitButton() throws {
        let app = launchAndOpenCreateAccountView()

        fillCreateAccountForm(in: app, email: "user@example.com")

        XCTAssertTrue(app.buttons["createAccountSubmitButton"].isEnabled)
    }

    @MainActor
    func testCreateAccountLoadingStateChanges() throws {
        let app = launchAndOpenCreateAccountView()

        fillCreateAccountForm(in: app, email: "user@example.com")

        let emailField = app.textFields["createAccountEmailField"]
        let usernameField = app.textFields["createAccountUsernameField"]
        let passwordField = app.secureTextFields["createAccountPasswordField"]
        let confirmPasswordField = app.secureTextFields["createAccountConfirmPasswordField"]
        let createAccountButton = app.buttons["createAccountSubmitButton"]

        createAccountButton.tap()

        XCTAssertEqual(createAccountButton.label, "Creating Account...")
        XCTAssertFalse(createAccountButton.isEnabled)
        XCTAssertFalse(emailField.isEnabled)
        XCTAssertFalse(usernameField.isEnabled)
        XCTAssertFalse(passwordField.isEnabled)
        XCTAssertFalse(confirmPasswordField.isEnabled)

        waitFor {
            createAccountButton.label == "Create Account"
        }

        XCTAssertEqual(createAccountButton.label, "Create Account")
        XCTAssertTrue(createAccountButton.isEnabled)
        XCTAssertTrue(emailField.isEnabled)
        XCTAssertTrue(usernameField.isEnabled)
        XCTAssertTrue(passwordField.isEnabled)
        XCTAssertTrue(confirmPasswordField.isEnabled)
    }

    @MainActor
    func testCreateAccountSignInButtonReturnsToLoginView() throws {
        let app = launchAndOpenCreateAccountView()

        app.buttons["Sign In"].tap()

        XCTAssertTrue(app.textFields["usernameField"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.otherElements["createAccountView"].exists)
    }

    @MainActor
    func testLoginFlowStateChanges() throws {
        let app = launchApp()

        let usernameField = app.textFields["usernameField"]
        let passwordField = app.secureTextFields["passwordField"]
        let signInButton = app.buttons["signInButton"]

        usernameField.tap()
        usernameField.typeText("hockpond")

        passwordField.tap()
        passwordField.typeText("123456")

        signInButton.tap()

        XCTAssertEqual(signInButton.label, "Signing In...")
        XCTAssertFalse(signInButton.isEnabled)
        XCTAssertFalse(usernameField.isEnabled)
        XCTAssertFalse(passwordField.isEnabled)

        waitFor {
            signInButton.label == "Sign In"
        }

        XCTAssertEqual(signInButton.label, "Sign In")
        XCTAssertTrue(signInButton.isEnabled)
        XCTAssertTrue(usernameField.isEnabled)
        XCTAssertTrue(passwordField.isEnabled)
    }

    @MainActor
    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments.append("UITEST")
        app.launch()
        return app
    }

    @MainActor
    private func launchAndOpenCreateAccountView() -> XCUIApplication {
        let app = launchApp()
        app.buttons["createAccountButton"].tap()
        return app
    }

    @MainActor
    private func fillCreateAccountForm(in app: XCUIApplication, email: String) {
        let emailField = app.textFields["createAccountEmailField"]
        let usernameField = app.textFields["createAccountUsernameField"]
        let passwordField = app.secureTextFields["createAccountPasswordField"]
        let confirmPasswordField = app.secureTextFields["createAccountConfirmPasswordField"]

        emailField.tap()
        emailField.typeText(email)

        usernameField.tap()
        usernameField.typeText("hockpond")

        passwordField.tap()
        passwordField.typeText("123456")

        confirmPasswordField.tap()
        confirmPasswordField.typeText("123456")
    }

    @MainActor
    private func waitFor(
        _ condition: @escaping () -> Bool,
        timeout: TimeInterval = 5
    ) {
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate { _, _ in condition() },
            object: nil
        )

        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(result, .completed)
    }
}
