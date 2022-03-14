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
            let notificationName = Notification.Name(rawValue: "ExpressionIsNotValid")
            let notification = Notification(name: notificationName)
            NotificationCenter.default.post(notification)
            return
        }
        
        guard expressionHaveEnoughElement else {
            let notificationName = Notification.Name(rawValue: "ExpressionIsNotLongEnough")
            let notification = Notification(name: notificationName)
            NotificationCenter.default.post(notification)
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
            case "+": result = left + right
            case "-": result = left - right
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        expression.append(" = \(operationsToReduce.first!)")
    }
    
    func addOperator(_ operation: Operation) {
        if lastElementsIsANumber {
            expression.append(operation.rawValue)
        } else {
            let notificationName = Notification.Name(rawValue: "CannotAddOperator")
            let notification = Notification(name: notificationName)
            NotificationCenter.default.post(notification)
        }
    }
    
    func addNumber(_ number: String) {
        if expressionHaveResult {
            resetExpression()
        }
        
        expression.append(number)
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
    private func resetExpression() {
        expression = ""
    }
}
