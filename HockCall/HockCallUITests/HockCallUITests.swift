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

        let createAccountButton = app.buttons["createAccountSubmitButton"]
        waitFor { createAccountButton.isEnabled }
        XCTAssertTrue(createAccountButton.isEnabled)
    }

    @MainActor
    func testCreateAccountMismatchedPasswordsKeepsSubmitDisabled() throws {
        let app = launchAndOpenCreateAccountView()

        let createAccountButton = app.buttons["createAccountSubmitButton"]

        fillCreateAccountForm(
            in: app,
            email: "user@example.com",
            username: "hockpond",
            password: "123456",
            confirmPassword: "654321"
        )

        XCTAssertFalse(createAccountButton.isEnabled)
    }

    @MainActor
    func testCreateAccountSuccessfulSubmissionReturnsToLoginView() throws {
        let app = launchAndOpenCreateAccountView()
        let createAccountButton = app.buttons["createAccountSubmitButton"]

        fillCreateAccountForm(
            in: app,
            email: "user@example.com",
            username: "hockpond",
            password: "123456",
            confirmPassword: "123456"
        )

        waitFor { createAccountButton.isEnabled }
        createAccountButton.tap()

        XCTAssertTrue(app.textFields["usernameField"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.otherElements["createAccountView"].exists)
    }

    @MainActor
    func testCreateAccountDuplicateShowsErrorAndClearsWhenEditing() throws {
        let app = launchAndOpenCreateAccountView()
        let createAccountButton = app.buttons["createAccountSubmitButton"]

        fillCreateAccountForm(
            in: app,
            email: "duplicate@example.com",
            username: "hockpond",
            password: "123456",
            confirmPassword: "123456"
        )

        waitFor { createAccountButton.isEnabled }
        createAccountButton.tap()
        XCTAssertTrue(app.textFields["usernameField"].waitForExistence(timeout: 5))

        app.buttons["createAccountButton"].tap()
        fillCreateAccountForm(
            in: app,
            email: "duplicate@example.com",
            username: "hockpond",
            password: "123456",
            confirmPassword: "123456"
        )

        waitFor { createAccountButton.isEnabled }
        createAccountButton.tap()

        let errorMessage = app.staticTexts["createAccountErrorMessage"]
        XCTAssertTrue(errorMessage.waitForExistence(timeout: 5))
        XCTAssertEqual(errorMessage.label, "An account with that email or username already exists.")

        let usernameField = app.textFields["createAccountUsernameField"]
        usernameField.tap()
        usernameField.typeText("2")

        XCTAssertTrue(errorMessage.waitForNonExistence(timeout: 5))
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
    private func fillCreateAccountForm(
        in app: XCUIApplication,
        email: String,
        username: String = "hockpond",
        password: String = "123456",
        confirmPassword: String = "123456"
    ) {
        let emailField = app.textFields["createAccountEmailField"]
        let usernameField = app.textFields["createAccountUsernameField"]
        let passwordField = app.secureTextFields["createAccountPasswordField"]
        let confirmPasswordField = app.secureTextFields["createAccountConfirmPasswordField"]
        let createAccountButton = app.buttons["createAccountSubmitButton"]

        emailField.tap()
        emailField.typeText(email)

        usernameField.tap()
        usernameField.typeText(username)

        enterSecureText(password, into: passwordField)
        enterSecureText(confirmPassword, into: confirmPasswordField)

        if !createAccountButton.isEnabled && password == confirmPassword {
            enterSecureText(password, into: passwordField)
            enterSecureText(confirmPassword, into: confirmPasswordField)
        }
    }

    @MainActor
    private func enterSecureText(_ text: String, into field: XCUIElement) {
        field.tap()
        field.typeText(text)
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
