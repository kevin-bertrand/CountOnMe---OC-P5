//
//  Notification.swift
//  CountOnMe
//
//  Created by Kevin Bertrand on 15/03/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension Notification {
    enum CalculatorError: String, CaseIterable {
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
