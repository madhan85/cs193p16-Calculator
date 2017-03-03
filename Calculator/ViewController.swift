//
//  ViewController.swift
//  Calculator
//
//  Created by Madhan on 6/23/16.
//  Copyright © 2016 Madhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet fileprivate weak var display: UILabel!
    
    fileprivate var userIsInTheMiddleOfTyping = false
    
    @IBAction fileprivate func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    fileprivate var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String (newValue)
        }
    }
    
    var savedProgram : CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    fileprivate var brain = CalculatorBrain()
    
    @IBAction fileprivate func performOperation(_ sender: UIButton) {
        
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
