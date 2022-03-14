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
    
    // MARK: Any time
    func testGivenAnyExpression_WhenClearExpression_ThenExpressionShouldBeEmpty() {
        // Given
        calculator.addNumber("12")
        calculator.addOperator(.multiply)
        
        // When
        calculator.clearExpression()
        
        // Then
        XCTAssertEqual(calculator.getExpression, "")
    }
    
    // MARK: When the expression is Empty
    /*
     -> Check when adding a number -> Get the number ✅
     -> Check when adding an operator:
                -> Adding + -> Expression is still empty ✅
                -> Adding - -> Get the " - " ✅
                -> Adding * -> Get error notification ✅
                -> Adding / -> Get error notification ✅
     -> Check when trying to calculate -> Get error notification ✅
     */
    func testGivenExpressionIsEmpty_WhenAddingNumber_ThenExpressionShouldBeTheNumber() {
        // Given
        
        // When
        calculator.addNumber("1")
        
        // Then
        XCTAssertEqual(calculator.getExpression, "1")
    }
    
    func testGivenExpressionIsEmpty_WhenAddingPlus_ThenExpressionShouldBeEmpty() {
        // Given
        
        // When
        calculator.addOperator(.plus)
        
        // Then
        XCTAssertEqual(calculator.getExpression, "")
    }
    
    func testGivenExpressionIsEmpty_WhenAddingMinus_ThenExpressionSouldBeTheMinus() {
        // Given
        
        // When
        calculator.addOperator(.minus)
        
        // Then
        XCTAssertEqual(calculator.getExpression, Operation.minus.rawValue)
    }
    
    func testGivenExpressionIsEmpty_WhenAddingMultiply_ThenGetCannotAddOperatorError() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Name(rawValue: Notification.ErrorName.cannotAddOperator.rawValue), object: calculator, handler: nil)
        
        // Given
        
        // When
        calculator.addOperator(.multiply)
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(calculator.getExpression, "")
    }
    
    func testGivenExpressionIsEmpty_WhenAddingDivision_ThenGetCannotAddOperatorError() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Name(rawValue: Notification.ErrorName.cannotAddOperator.rawValue), object: calculator, handler: nil)
        
        // Given
        
        // When
        calculator.addOperator(.division)
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(calculator.getExpression, "")
    }
    
    func testGivenExpressionIsEmpty_WhenTryingToCalculate_ThenGetToSmallError() {
        // Prepare expectations
        _ = expectation(forNotification: Notification.Name(rawValue: Notification.ErrorName.tooSmall.rawValue), object: calculator, handler: nil)
        
        // Given
        
        // When
        calculator.calculateExpression()
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(calculator.getExpression, "")
    }
    
    // MARK: When the expression end with a number
    /*
     -> Check when adding a number -> Get the number added to the expression ✅
     -> Check when adding an operator -> Get the operator to the expression ✅
     -> Check when trying to calculate:
                -> When the expression has less than 2 numbers -> Get error notification ✅
                -> When the expression has at least 2 numbers
                        -> Simple plus -> Get result ✅
                        -> Simple minus -> Get result ✅
                        -> Simple multiplication -> Get result ✅
                        -> Simple division -> Get result ✅
                        -> Division by 0 -> Get error notification ✅
                        -> Complex expression -> Get result according the calculation rules ✅
                 
     */
    func testGivenExpressionEndWithNumber_WhenAddingNumber_ThenNumberShouldBeAddedToPreviousNumbers() {
        // Given
        calculator.addNumber("2")
        
        // When
        calculator.addNumber("5")
        
        // Then
        XCTAssertEqual(calculator.getExpression, "25")
    }
    
    func testGivenExpressionEndWithNumber_WhenAddingOperator_ThenOperatorShouldBeAddedToExpression() {
        // Given
        calculator.addNumber("3")
        
        // When
        calculator.addOperator(.minus)
        
        // Then
        XCTAssertEqual(calculator.getExpression, "3" + Operation.minus.rawValue)
    }
    
    func testGivenExpressionEndWithNumberAndHasLessThanThreeParts_WhenCalculate_ThenGetTooSmallError() {
        // Prepare expectations
        _ = expectation(forNotification: Notification.Name(rawValue: Notification.ErrorName.tooSmall.rawValue), object: calculator, handler: nil)
        
        // Given
        calculator.addNumber("4")
        
        // When
        calculator.calculateExpression()
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(calculator.getExpression, "4")
    }
    
    func testGivenAnAddingExpression_WhenCalculate_ThenGetResult() {
        // Given
        calculator.addNumber("5")
        calculator.addOperator(.plus)
        calculator.addNumber("10")
        
        // When
        calculator.calculateExpression()
        
        // Then
        XCTAssertEqual(calculator.getExpression, "5 + 10 = 15")
    }
    
    func testGivenASubstractionExpression_WhenCalculate_ThenGetResult() {
        // Given
        calculator.addNumber("5")
        calculator.addOperator(.minus)
        calculator.addNumber("10")
        
        // When
        calculator.calculateExpression()
        
        // Then
        XCTAssertEqual(calculator.getExpression, "5 - 10 = -5")
    }
    
    func testGivenAMulitplicationExpression_WhenCalculate_ThenGetResult() {
        // Given
        calculator.addNumber("5")
        calculator.addOperator(.multiply)
        calculator.addNumber("10")
        
        // When
        calculator.calculateExpression()
        
        // Then
        XCTAssertEqual(calculator.getExpression, "5 * 10 = 50")
    }
    
    func testGivenADivision_WhenCalculate_ThenGetResult() {
        // Given
        calculator.addNumber("5")
        calculator.addOperator(.division)
        calculator.addNumber("10")
        
        // When
        calculator.calculateExpression()
        
        // Then
        XCTAssertEqual(calculator.getExpression, "5 / 10 = 0.5")
    }
    
    func testGivenADivisionByZero_WhenCalculare_ThenGetResult() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Name(rawValue: Notification.ErrorName.dividedByZero.rawValue), object: calculator, handler: nil)
        
        // Given
        calculator.addNumber("5")
        calculator.addOperator(.division)
        calculator.addNumber("0")
        
        // When
        calculator.calculateExpression()
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(calculator.getExpression, "5 / 0")
    }
    
    func testGivenComplexeExpression_WhenCalculate_ThenGetResultAccordingToCalculationRules() {
        // Given
        calculator.addNumber("5")
        calculator.addOperator(.plus)
        calculator.addNumber("10")
        calculator.addOperator(.division)
        calculator.addNumber("2")
        calculator.addOperator(.minus)
        calculator.addNumber("4")
        calculator.addOperator(.multiply)
        calculator.addNumber("20")
        
        // When
        calculator.calculateExpression()
        
        // Then
        XCTAssertEqual(calculator.getExpression, "5 + 10 / 2 - 4 * 20 = -70")
    }
    
    // MARK: When the expression end with an operator
    /*
     -> Check when adding a number -> Get the number added to the expression ✅
     -> Check when adding an operator -> Get error notification ✅
     -> Check when trying to calculate -> Get error notification ✅
     */
    func testGivenExpressionEndWithOperator_WhenAddingNumber_ThenNumberShouldBeAddedToOperation() {
        // Given
        calculator.addNumber("2")
        calculator.addOperator(.minus)
        
        // When
        calculator.addNumber("4")
        
        // Then
        XCTAssertEqual(calculator.getExpression, "2 - 4")
    }
    
    func testGivenExpressionEndWithOperator_WhenAddingOperator_ThenGetCannotAddOperatorError() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Name(rawValue: Notification.ErrorName.cannotAddOperator.rawValue), object: calculator, handler: nil)
        
        // Given
        calculator.addOperator(.minus)
        
        // When
        calculator.addOperator(.division)
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(calculator.getExpression, " - ")
    }
    
    func testGivenExpressionEndWithOperator_WhenCalculate_ThenGetExpressionNotValidError() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Name(rawValue: Notification.ErrorName.notValid.rawValue), object: calculator, handler: nil)
        
        // Given
        calculator.addNumber("3")
        calculator.addOperator(.division)
        calculator.addNumber("2")
        calculator.addOperator(.minus)
        
        // When
        calculator.calculateExpression()
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(calculator.getExpression, "3 / 2 - ")
    }
    
    // MARK: When the expression has a result
    /*
     -> Check when adding a number -> New expression ✅
     -> Check when adding an operator -> New expression ✅
     -> Check when trying to recalculate -> Get error notification ✅
     */
    func testGivenExpressionHasResult_WhenAddingNumber_ThenNumberShouldBeAddedToNewExpression() {
        // Given
        calculator.addNumber("3")
        calculator.addOperator(.division)
        calculator.addNumber("2")
        calculator.calculateExpression()
        
        // When
        calculator.addNumber("10")
        
        // Then
        XCTAssertEqual(calculator.getExpression, "10")
    }
    
    func testGivenExpressionHasResult_WhenAddingOperator_ThenGetNewExpression() {
        // Given
        calculator.addNumber("3")
        calculator.addOperator(.multiply)
        calculator.addNumber("2")
        calculator.calculateExpression()
        
        // When
        calculator.addOperator(.plus)
        
        // Then
        XCTAssertEqual(calculator.getExpression, "")
    }
    
    func testGivenExpressionHasResult_WhenRecalculate_ThenGetExpressionIsNotValidError() {
        // Prepare expectation
        _ = expectation(forNotification: Notification.Name(rawValue: Notification.ErrorName.notValid.rawValue), object: calculator, handler: nil)
        
        // Given
        calculator.addNumber("3")
        calculator.addOperator(.minus)
        calculator.addNumber("2")
        calculator.calculateExpression()
        
        // When
        calculator.calculateExpression()
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
}
