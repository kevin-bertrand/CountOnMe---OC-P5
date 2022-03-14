//
//  Calculator.swift
//  CountOnMe
//
//  Created by Kevin Bertrand on 08/03/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculator {
    // MARK: PUBLIC
    // MARK: Properties
    var getExpression: String {
        return expression
    }
    
    // MARK: Methods
    func calculateExpression() {
        guard lastElementsIsANumber else {
            sendNotification(for: .notValid)
            return
        }
        
        guard expressionHaveEnoughElement else {
            sendNotification(for: .tooSmall)
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            let result: Int
            switch operand {
            case "+":
                result = left + right
            case "-":
                result = left - right
            default:
                sendNotification(for: .notValid)
                return
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        expression.append(" = \(operationsToReduce.first!)")
    }
    
    func addOperator(_ operation: Operation) {
        if expressionHaveResult {
            clearExpression()
        }
        
        if lastElementsIsANumber {
            expression.append(operation.rawValue)
        } else {
            sendNotification(for: .cannotAddOperator)
        }
    }
    
    func addNumber(_ number: String) {
        if expressionHaveResult {
            clearExpression()
        }
        
        expression.append(number)
    }
    
    func clearExpression() {
        expression = ""
    }
    
    // MARK: PRIVATE
    // MARK: Properties
    private var expression = ""
    
    // MARK: Computed properties
    private var elements: [String] {
        return expression.split(separator: " ").map{ "\($0)" }
    }
    
    private var lastElementsIsANumber: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "*"
    }
    
    private var expressionHaveResult: Bool {
        return expression.firstIndex(of: "=") != nil
    }
    
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    // MARK: Methods
    private func sendNotification(for errorName: Notification.ErrorName) {
        let notificationName = Notification.Name(rawValue: errorName.rawValue)
        let notification = Notification(name: notificationName, object: self)
        NotificationCenter.default.post(notification)
    }
}

extension Notification {
    enum ErrorName: String {
        case notValid = "ExpressionIsNotValid"
        case cannotAddOperator = "CannotAddOperator"
        case tooSmall = "ExpressionIsNotLongEnough"
        case dividedByZero = "ExpressionIsDividedByZero"
    }
}
