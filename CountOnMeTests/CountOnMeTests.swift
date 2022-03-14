//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by Kevin Bertrand on 14/03/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CountOnMeTests: XCTestCase {
    var calculator: Calculator!
    
    override func setUp() {
        super.setUp()
        
        calculator = Calculator()
    }

    func testGivenExpressionIsEmpty_WhenAddingNumber_ThenNumberShouldBeDisplayed() {
        // Given
        XCTAssertEqual(calculator.getExpression, "")
        
        // When
        calculator.addNumber("2")
        
        // Then
        XCTAssertEqual(calculator.getExpression, "2")
    }
    
    func testGivenExpressionIsEmpty_WhenAddingOperation_ThenOperationShouldBeAdded() {
        // Given
        XCTAssertEqual(calculator.getExpression, "")
        
        // When
        calculator.addOperator(.minus)
        
        // Then
        XCTAssertEqual(calculator.getExpression, Operation.minus.rawValue)
    }
    
    func testGivenExpressionHasSomeNumber_WhenAddingOperation_ThenOperationSouldBeAdded() {
        // Given
        calculator.addNumber("2")
        
        // When
        calculator.addOperator(.plus)
        
        // Then
        XCTAssertEqual(calculator.getExpression, "2" + Operation.plus.rawValue)
    }
    
    func testGivenExpressionIsCompossedByLessThanThreeElements_WhenTappingEquals_ThenTheExpressionShouldNotChange() {
        // Given
        calculator.addOperator(.minus)
        calculator.addNumber("2")
        
        // When
        calculator.calculateExpression()
        
        // Then
        XCTAssertEqual(calculator.getExpression, Operation.minus.rawValue + "2")
    }
    
    func testGivenLastElementIsAnOperator_WhenAddingNewOperator_ThenExpressionShouldNotChange() {
        // Given
        calculator.addNumber("2")
        calculator.addOperator(.division)
        
        // When
        calculator.addOperator(.minus)
        
        // Then
        XCTAssertEqual(calculator.getExpression, "2" + Operation.division.rawValue)
    }
    
    func testGivenExpressionIsValid_WhenPerformCalculation_ThenResultShouldBeDisplayed() {
        // Given
        calculator.addNumber("2")
        calculator.addOperator(.plus)
        calculator.addNumber("4")
        
        // When
        calculator.calculateExpression()
        
        // Then
        XCTAssertTrue(calculator.getExpression.firstIndex(of: "=") != nil)
    }
    
    func testGivenExpressionHasResult_WhenAddingNumber_ThenExpressionShouldBeTheNumber() {
        // Given
        calculator.addNumber("2")
        calculator.addOperator(.plus)
        calculator.addNumber("4")
        calculator.calculateExpression()
        XCTAssertTrue(calculator.getExpression.firstIndex(of: "=") != nil)
        
        // When
        calculator.addNumber("2")
        
        // Then
        XCTAssertEqual(calculator.getExpression, "2")
    }
}
