//
//  LoginViewTest.swift
//  MobileAppTests
//
//  Created by Toby Pang on 19/1/2024.
//

import XCTest
@testable import MobileApp

class LoginViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    func testLoginViewUI() throws {
        // Launch the app
        app.launch()
        
        // Verify the UI elements in LoginView
        XCTAssertTrue(app.staticTexts["Login"].exists)
        XCTAssertTrue(app.textFields["Email"].exists)
        XCTAssertTrue(app.secureTextFields["Password"].exists)
        XCTAssertTrue(app.buttons["Register"].exists)
        XCTAssertTrue(app.buttons["Login"].exists)
    }
    
    func testRegisterUI() throws {
        // Launch the app
        app.launch()
        
        let app = XCUIApplication()
        app.buttons["Register"].tap()
        XCTAssertTrue(app.staticTexts["Register"].exists)
        XCTAssertTrue(app.textFields["Email"].exists)
        XCTAssertTrue(app.secureTextFields["Password(over 6 digit)"].exists)
        XCTAssertTrue(app.secureTextFields["Confirm password"].exists)
        XCTAssertTrue(app.buttons["Back to login"].exists)
        XCTAssertTrue(app.buttons["Register"].exists)
        
        
        
        app.buttons["Back to login"].tap()
        XCTAssertTrue(app.staticTexts["Login"].exists)
        XCTAssertTrue(app.textFields["Email"].exists)
        XCTAssertTrue(app.secureTextFields["Password"].exists)
        XCTAssertTrue(app.buttons["Register"].exists)
        XCTAssertTrue(app.buttons["Login"].exists)
        
    }
}
