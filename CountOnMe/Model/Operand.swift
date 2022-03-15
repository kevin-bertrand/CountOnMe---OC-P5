//
//  Operand.swift
//  CountOnMe
//
//  Created by Kevin Bertrand on 14/03/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum Operand: String {
    case multiplication = " * "
    case division = " / "
    case addition = " + "
    case substraction = " - "
    
    var symbol: String {
        return self.rawValue.trimmingCharacters(in: .whitespaces)
    }
    
    /// Always return the result of the expression of 2 numbers except when it is a division by 0 when it returns nil
    func calculate(_ firstNumber: Double, _ secondNumber: Double) -> Double? {
        var result: Double? = nil
        
        switch self {
        case .multiplication:
            result = firstNumber * secondNumber
        case .division:
            if secondNumber != 0 {
                result = firstNumber / secondNumber
            }
        case .addition:
            result = firstNumber + secondNumber
        case .substraction:
            result = firstNumber - secondNumber
        }
        
        return result
    }
}
