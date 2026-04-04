//
//  HockCallUITests.swift
//  HockCallUITests
//
//  Created by Gustavo Câmara Reis on 03/04/26.
//

import XCTest

final class HockCallUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
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
