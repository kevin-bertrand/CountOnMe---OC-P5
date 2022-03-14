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
            sendNotification(for: .expressionNotValid)
            return
        }
        
        guard expressionHaveEnoughElement else {
            sendNotification(for: .expressionTooSmall)
            return
        }
        
        guard expressionHaveResult == false else {
            sendNotification(for: .expressionNotValid)
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        if operationsToReduce.first == "-" {
            operationsToReduce = Array(operationsToReduce.dropFirst())
            operationsToReduce[0] = "\(-Double(operationsToReduce[0])!)"
        }
        
        for operand in Operation.allCases {
            guard let calculationResult = performCalculationForOperation(operand, in: operationsToReduce) else { return }
            operationsToReduce = calculationResult
        }

        expression.append(" = \(operationsToReduce.first!)")
    }
    
    func addOperator(_ operation: Operation) {
        if expressionHaveResult {
            clearExpression()
        }
        
        if lastElementsIsANumber || (operation == .minus && elements.count == 0) {
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
        return Int(elements.last ?? "") != nil
    }
    
    private var expressionHaveResult: Bool {
        return expression.firstIndex(of: "=") != nil
    }
    
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    // MARK: Methods
    private func sendNotification(for errorName: Notification.ErrorName) {
        let notificationName = errorName.notificationName
        let notification = Notification(name: notificationName, object: self)
        NotificationCenter.default.post(notification)
    }
    
    private func performCalculationForOperation(_ operand: Operation, in expressionToCalculate: [String]) -> [String]? {
        let operandCharacter = operand.rawValue.trimmingCharacters(in: .whitespaces)
        var operationsToReduce = expressionToCalculate
        
        while operationsToReduce.contains(operandCharacter) {
            let firstIndexOfOperand = operationsToReduce.firstIndex(of: operandCharacter)!
            let leftNumber = Double(operationsToReduce[firstIndexOfOperand-1])!
            let rightNumber = Double(operationsToReduce[firstIndexOfOperand+1])!
            
            let result: Double
            switch operand {
            case .plus:
                result = leftNumber + rightNumber
            case .minus:
                result = leftNumber - rightNumber
            case .multiply:
                result = leftNumber * rightNumber
            case .division:
                if rightNumber == 0 {
                    sendNotification(for: .dividedByZero)
                    return nil
                } else {
                    result = leftNumber / rightNumber
                }
            }
            
            for indexToRemove in (firstIndexOfOperand-1...firstIndexOfOperand+1).reversed() {
                operationsToReduce.remove(at: indexToRemove)
            }
            
            let operationResult: Any = floor(result) == result ? Int(result) : result
            operationsToReduce.insert("\(operationResult)", at: firstIndexOfOperand-1)
        }
        
        return operationsToReduce
    }
}

extension Notification {
    enum ErrorName: String {
        case expressionNotValid = "Entrez une expression correcte !"
        case cannotAddOperator = "L'opérateur sélectionné ne peut pas être ajouté à l'expression !"
        case expressionTooSmall = "Démarrez un nouveau calcul !"
        case dividedByZero = "Une division par 0 ne peut pas être effectuée !"
        
        var notificationName: Notification.Name {
            return Notification.Name(rawValue: "\(self)")
        }
        
        var notificationMessage: String {
            return self.rawValue
        }
    }
}
