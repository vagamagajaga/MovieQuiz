//
//  MovieQuizUITest.swift
//  MovieQuizUITest
//
//  Created by Vagan Galstian on 07.12.2022.
//

import XCTest

class MovieQuizUITest: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
        
    }
    
//    func testYesButton() {
//        let firstPoster = app.images["Poster"]
//
//        app.buttons["No"].tap()
//
//        let secondPoster = app.images["Poster"]
//        let indexLabel = app.staticTexts["Index"]
//
//        sleep(3)
//
//        XCTAssertFalse(firstPoster == secondPoster)
//        XCTAssertTrue(indexLabel.label == "2/10")
//
//    }
    
    func testAlertApear() {
        
        for _ in 1...10 {
            app.buttons["No"].tap()
        }
        
        sleep(3)
        
        let alert = app.alerts["alertOfResult"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
        
        
    }
    
    func testDismissAlert() {
        
        for _ in 1...10 {
            app.buttons["No"].tap()
        }
        
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        let alert = app.alerts["alertOfResult"]
        alert.buttons.firstMatch.tap()
        
        sleep(3)
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
