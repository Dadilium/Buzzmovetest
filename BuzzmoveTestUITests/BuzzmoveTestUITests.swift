//
//  BuzzmoveTestUITests.swift
//  BuzzmoveTestUITests
//
//  Created by Antoine ROY on 14/03/2018.
//  Copyright © 2018 Antoine ROY. All rights reserved.
//

import XCTest

class BuzzmoveTestUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func research(app: XCUIApplication, text: String, elem: String) {
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let textField = element.children(matching: .textField).element

        textField.clearAndEnterText(text: text)
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.otherElements[elem].tap()
        
        sleep(2)
        app.buttons["Back"].tap()
    }
    
    func testProcess() {
        
        let app = XCUIApplication()
        research(app: app, text: "Eiffel tower", elem: "Eiffel Tower")
        research(app: app, text: "Nando's london", elem: "Nando's Ealing Bond Street")

    }
    
}

extension XCUIElement {
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        self.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.characters.count)
//        let deleteString = stringValue.characters.map { _ in XCUIKeyboardKeyDelete }.joined(separator: "")
        
        self.typeText(deleteString)
        self.typeText(text)
    }
}
