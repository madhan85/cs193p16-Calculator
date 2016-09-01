//
//  ViewController.swift
//  Calculator
//
//  Created by Madhan on 6/23/16.
//  Copyright © 2016 Madhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var logBuffer = ""
    
    private func updateLog(digit : String) {
        if logBuffer == "" {
            calculationLog.text = ""
        }
        if brain.isPartial {
            if digit == "" {
                if logBuffer == "" {
                    logBuffer = display.text!+brain.description
                }
                else {
                    logBuffer = calculationLog.text! + brain.description
                }
            }
            else {
                logBuffer = calculationLog.text! + digit
            }
            calculationLog.text = logBuffer
        }
        else {
            if digit != "" {
                logBuffer = calculationLog.text! + digit
                calculationLog.text = logBuffer
            }
            if !userIsInTheMiddleOfTyping {
                logBuffer = calculationLog.text! + "="
                logBuffer = logBuffer + display.text!
                calculationLog.text = logBuffer
                logBuffer = ""
            }
        }
    }
    
    @IBOutlet weak var calculationLog: UILabel!
    
    @IBAction func backspaceAction(sender: UIButton) {
        
        let lastCharacter = display.text!.removeAtIndex(display.text!.endIndex.predecessor())
        if lastCharacter == "." {
            digitIsDecimal = false
        }
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction private func clearCalculator(sender: UIButton) {
        displayValue = 0.0
        if brain.pending != nil {
            brain.pending!.firstOperand = 0.0
        }
        logBuffer = ""
        calculationLog.text = " "
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
        updateLog(digit)
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
        updateLog("")
    }
}