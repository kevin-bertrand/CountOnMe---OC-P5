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
}
