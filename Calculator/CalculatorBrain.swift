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
    var description = ""
    
    var isPartial : Bool {
        if pending != nil {
            return true
        }
        return false
    }
    
    private var accumulator = 0.0
    
    func setOperand(operand : Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Operation>=[
        "∏" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "=" : Operation.Equals,
        "±" : Operation.UnaryOperation({-$0}),
        "x2" : Operation.UnaryOperation({$0*$0})
    ]
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation(Double -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
                description = symbol
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
                description = symbol
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                description = symbol
            case .Equals:
                executePendingBinaryOperation()
            
            }
        }
    }
    
    private func executePendingBinaryOperation()
    {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }

    }
    
    var pending: PendingBinaryOperationInfo?
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result : Double {
        get {
            return accumulator
        }
    }
}