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
    /// Calculate the result of the expression
    func calculateExpression() {
        // Check if there is an error in the expression to perform the calculation
        guard checkCalculateErrors() else { return }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        // If the expression beggins with a minus -> Change the sign of the first number and delete the minus of the array
        if operationsToReduce.first == "-" && Double(operationsToReduce[1]) != nil {
            operationsToReduce[1] = "\(-Double(operationsToReduce[1])!)"
            operationsToReduce = Array(operationsToReduce.dropFirst())
        }
        
        /*
            According to the arithmetic rules:
            - 1st: Perform the * and / from the left to the right
            - 2nd: Perform the + and - from the left to the right
         */
        guard let calculationResult = performCalculation(withFirstOperand: .division, andSecondOperand: .multiplication, in: operationsToReduce) else { return }
        operationsToReduce = calculationResult
        
        guard let calculationResult = performCalculation(withFirstOperand: .substraction, andSecondOperand: .addition, in: operationsToReduce) else { return }
        operationsToReduce = calculationResult
        
        // Check if the first element in the array (supposed to be the result) is  a double
        if let calculatedResult = operationsToReduce.first,
           let result = Double(calculatedResult) {
            // Add the result at the end of the expression
            expression.append(" = \(convertNumberToString(result))")
        }
    }
    
    /// Add an operand to the expression
    func addOperand(_ operand: Operand) {
        // If the expression has a result -> Clear the expression to start a new one
        if expressionHasResult {
            clearExpression()
        }
        
        // Check if the last element of the expression is a number or if the expression is empty, check if the desired operand is a minus
        if lastElementsIsANumber || (operand == .substraction && expressionIsEmpty) {
            expression.append(operand.rawValue)
        } else { // Otherwise -> Send an error
            sendNotification(for: .cannotAddOperator)
        }
    }
    
    /// Add a number to the expression
    func addNumber(_ number: Int) {
        // If the expression has a result -> Clear the expression to start a new one
        if expressionHasResult {
            clearExpression()
        }
        
        expression.append("\(number)")
    }
    
    /// Clear the current expression
    func clearExpression() {
        expression = ""
    }
    
    // MARK: PRIVATE
    // MARK: Properties
    private var expression = ""
    
    // MARK: Computed properties
    // Return an array with the splitted expression
    private var elements: [String] {
        return expression.split(separator: " ").map{ "\($0)" }
    }
    
    // Check if the last element is a number
    private var lastElementsIsANumber: Bool {
        return Int(elements.last ?? "") != nil
    }
    
    // Check if the expression already has a result
    private var expressionHasResult: Bool {
        return expression.firstIndex(of: "=") != nil
    }
    
    // Check if the expression has minimum 3 elements to perform the calculation
    private var expressionHasEnoughElement: Bool {
        return elements.count >= 3
    }
    
    // Check if the expression is empty or not
    private var expressionIsEmpty: Bool {
        return elements.count == 0
    }
    
    // MARK: Methods
    /// Configure and send a notification to the controller
    private func sendNotification(for errorName: Notification.CalculatorError) {
        let notificationName = errorName.notificationName
        let notification = Notification(name: notificationName, object: self)
        NotificationCenter.default.post(notification)
    }
    
    /// Check if the expression ends with a number, if it has at least 3 parts and if it doesn't have already a result
    private func checkCalculateErrors() -> Bool{
        // Check if the epxression end with a number. If not -> Send an error
        guard lastElementsIsANumber else {
            sendNotification(for: .expressionNotValid)
            return false
        }
        
        // Check if the expression has at least 3 parts (2 Numbers and 1 operand). If not -> Send an error
        guard expressionHasEnoughElement else {
            sendNotification(for: .expressionTooSmall)
            return false
        }
        
        // Check if the expression already has a result. If it is the case -> Send an error
        guard expressionHasResult == false else {
            sendNotification(for: .expressionNotValid)
            return false
        }
        
        return true
    }
    
    /// Convert a number into a string with no digit if the number is an integer or 3 digits if it is a double
    private func convertNumberToString(_ number: Double) -> String {
        return "\(floor(number) == number ? Int(number) as Any : (round(number*1000)/1000.0))"
    }
    
    /// Calculate the entire expression according to the selected operand and return a new calculated expression
    private func performCalculation(withFirstOperand firstOperand: Operand, andSecondOperand secondOperand: Operand, in expressionToCalculate: [String]) -> [String]? {
        var operationsToReduce = expressionToCalculate
        
        // Perform the loop while the expression has one of both operands
        while operationsToReduce.contains(firstOperand.symbol) || operationsToReduce.contains(secondOperand.symbol) {
            // Find the nearest operand in the expression
            let firstIndexOfFirstOperand = operationsToReduce.firstIndex(of: firstOperand.symbol)
            let firstIndexOfSecondOperand = operationsToReduce.firstIndex(of: secondOperand.symbol)
            let defaultInfiniteIndex = Array<Int>.Index(Int.max)
            let firstIndexOfOperand = min(firstIndexOfFirstOperand ?? defaultInfiniteIndex, firstIndexOfSecondOperand ?? defaultInfiniteIndex)
            
            // Check both number are double and get operand
            let leftNumber = Double(operationsToReduce[firstIndexOfOperand-1])!
            let rightNumber = Double(operationsToReduce[firstIndexOfOperand+1])!
            let operand = Operand(rawValue: " \(operationsToReduce[firstIndexOfOperand]) ")!
            
            // Get the result of the operation
            guard let result = operand.calculate(leftNumber, rightNumber) else {
                sendNotification(for: .dividedByZero)
                return nil
            }
            
            // Remove both number and operand that have just been calculated
            for indexToRemove in (firstIndexOfOperand-1...firstIndexOfOperand+1).reversed() {
                operationsToReduce.remove(at: indexToRemove)
            }
            
            // Add the result at the place of the first number that have just been calculated
            operationsToReduce.insert("\(result)", at: firstIndexOfOperand-1)
        }
        
        return operationsToReduce
    }
}
