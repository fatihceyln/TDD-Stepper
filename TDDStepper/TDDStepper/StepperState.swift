//
//  StepperState.swift
//  TDDStepper
//
//  Created by Fatih Kilit on 10.09.2025.
//

import Foundation

struct StepperState {
    var value: UInt = 0 {
        didSet {
            if value > maximumValue {
                value = maximumValue
            }
            
            if value < minimumValue {
                value = minimumValue
            }
        }
    }
    
    var minimumValue: UInt = 0 {
        didSet {
            if minimumValue > value {
                value = minimumValue
            }
            
            if minimumValue > maximumValue {
                maximumValue = minimumValue
            }
        }
    }
    
    var maximumValue: UInt = 10 {
        didSet {
            if maximumValue < minimumValue {
                minimumValue = maximumValue
            }
        }
    }
    
    var stepValue: UInt = 1 {
        didSet {
            if stepValue < 1 {
                stepValue = 1
            }
        }
    }
}
