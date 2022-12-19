//
//  ArrayTest.swift
//  MovieQuizTest
//
//  Created by Vagan Galstian on 06.12.2022.
//

import Foundation
import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    
    func testGetValueInRange() throws {
        // Given
        let array = [1, 1, 2, 3, 4]
        // When
        let value = array[safe: 2]
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testValueOutOfRange() throws {
        // Given
        let array = [1, 1, 2, 3, 4]

        // When
        let value = array[safe: 7]

        // Then
        XCTAssertNil(value)
    }
}


