//
//  ViewController.swift
//  Calculator
//
//  Created by Madhan on 6/23/16.
//  Copyright © 2016 Madhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction private func clearCalculator(sender: UIButton) {
        displayValue = 0.0
        if brain.pending != nil {
            brain.pending!.firstOperand = 0.0
        }
    }
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    private var digitIsDecimal = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        var digit = sender.currentTitle!
        
        if(digit == ".") {
            if !digitIsDecimal {
                digit = "."
                digitIsDecimal = true
            }
            else {
                digit = ""
            }
        }
        
        if userIsInTheMiddleOfTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String (newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        
        digitIsDecimal = false
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
}