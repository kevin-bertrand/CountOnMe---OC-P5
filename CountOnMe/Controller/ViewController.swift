//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    let calculator = Calculator()
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayErrorCannotAddOperator), name: Notification.Name(rawValue: "CannotAddOperator"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayErrorExpressionNotValid), name: Notification.Name(rawValue: "ExpressionIsNotValid"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayErrorExpressionNotLongEnough), name: Notification.Name(rawValue: "ExpressionIsNotLongEnough"), object: nil)
    }
    
    @objc func displayErrorCannotAddOperator() {
        let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func displayErrorExpressionNotValid() {
        let alertVC = UIAlertController(title: "Zéro!", message: "Entrez une expression correcte !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func displayErrorExpressionNotLongEnough() {
        let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func showExpression() {
        textView.text = calculator.getExpression
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        calculator.addNumber(numberText)
        displayExpression()
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        calculator.addOperator(.plus)
        displayExpression()
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        calculator.addOperator(.minus)
        displayExpression()
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculator.calculateExpression()
        displayExpression()
    }
    
    private func displayExpression() {
        textView.text = calculator.getExpression
    }
}

