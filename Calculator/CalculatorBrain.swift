//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Madhan on 7/12/16.
//  Copyright © 2016 Madhan. All rights reserved.
//

import Foundation


class CalculatorBrain
{
    fileprivate var accumulator = 0.0
    
    fileprivate var internalProgram = [AnyObject]()
    
    func setOperand(_ operand : Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    fileprivate var operations: Dictionary<String, Operation>=[
        "∏" : Operation.constant(M_PI),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "×" : Operation.binaryOperation({$0 * $1}),
        "÷" : Operation.binaryOperation({$0 / $1}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "−" : Operation.binaryOperation({$0 - $1}),
        "=" : Operation.equals
    ]
    
    enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    func performOperation(_ symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                accumulator = function(accumulator)
            case .binaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    fileprivate func executePendingBinaryOperation()
    {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }

    }
    
    fileprivate var pending: PendingBinaryOperationInfo?
    
    fileprivate struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    
    var program : PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                        
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result : Double {
        get {
            return accumulator
        }
    }
}
