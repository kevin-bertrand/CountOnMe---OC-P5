//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Public
    // MARK: Outlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!

    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observers to notifcations
        for calculatorError in Notification.CalculatorError.allCases {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(gettingErrorNotification),
                                                   name: calculatorError.notificationName,
                                                   object: nil)
        }
    }
    
    /// Get the notification error and check which one is it to trigger the alert view controller with the correct message
    @objc func gettingErrorNotification(_ notification: Notification) {
        if let notificationName = notification.userInfo?["name"] as? Notification.Name {
            switch notificationName {
            case Notification.CalculatorError.dividedByZero.notificationName:
                self.displayError(.dividedByZero)
            case Notification.CalculatorError.expressionNotValid.notificationName:
                self.displayError(.expressionNotValid)
            case Notification.CalculatorError.expressionTooSmall.notificationName:
                self.displayError(.expressionTooSmall)
            case Notification.CalculatorError.cannotAddOperator.notificationName:
                self.displayError(.cannotAddOperator)
            default:
                return
            }
        }
    }

    // MARK: Actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal),
              let number = Int(numberText)
        else {
            return
        }
        
        calculator.addNumber(number)
        displayExpression()
    }
    
    @IBAction func tappedOperandButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            calculator.addOperand(.addition)
        case 1:
            calculator.addOperand(.substraction)
        case 2:
            calculator.addOperand(.multiplication)
        case 3:
            calculator.addOperand(.division)
        default:
            return
        }
        displayExpression()
    }
    
    @IBAction func tappedClearButton(_ sender: UIButton) {
        calculator.clearExpression()
        displayExpression()
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculator.calculateExpression()
        displayExpression()
    }
    
    // MARK: Private
    // MARK: Properties
    private let calculator = Calculator()
    
    // MARK: Methods
    ///  Show the expression on the screen
    private func displayExpression() {
        textView.text = calculator.getExpression
    }
    
    /// Show an alert view controller with a specific error
    private func displayError(_ error: Notification.CalculatorError) {
        let alertVC = UIAlertController(title: "Zéro!", message: error.notificationMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return present(alertVC, animated: true, completion: nil)
    }
}

