//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class SimpleCalcTests: XCTestCase {
    var calculator: Calculator!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        calculator = Calculator()
    }
    
    func testGivenExpressionIsEmpty_WhenAddingNumber_ThenNumberShouldBeDisplayed() {
        XCTAssertEqual(calculator.getExpression, "")
        calculator.addNumber("3")
    }
}
