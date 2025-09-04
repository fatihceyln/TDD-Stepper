//
//  StepperTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 4.09.2025.
//

import XCTest

class Stepper {
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
    
    let stepValue: UInt = 1
}

class StepperTests: XCTestCase {
    func test_defaultValues() {
        let sut = Stepper()
        
        XCTAssertEqual(sut.value, 0, "Default value")
        XCTAssertEqual(sut.minimumValue, 0, "Default minimum value")
        XCTAssertEqual(sut.maximumValue, 10, "Default maximum value")
        XCTAssertEqual(sut.stepValue, 1, "Default step value")
    }
    
    func test_setMinimumValueBeyondValue_matchesValueWithMinimumValue() {
        let sut = Stepper()
        sut.value = 1
        
        sut.minimumValue = 5
        
        XCTAssertEqual(sut.value, 5, "Expected value to be equal with minimum value")
    }
    
    func test_setMinimumValueBeyonMaximumValue_matchesMaximumValueWithMinimum() {
        let sut = Stepper()
        sut.maximumValue = 1
        
        sut.minimumValue = 20
        
        XCTAssertEqual(sut.maximumValue, 20, "Expected maximum value to be equal with minimum value")
    }
    
    func test_setMaximumValueBelowMinimumValue_matchesMinimumValueWithMaximum() {
        let sut = Stepper()
        sut.minimumValue = 5
        
        sut.maximumValue = 1
        
        XCTAssertEqual(sut.minimumValue, 1, "Expected minimum value to be equal with maximum value")
    }
    
    func test_setValueBeyondMaximum_limitsValueToMaximum() {
        let sut = Stepper()
        sut.maximumValue = 5
        
        sut.value = 10
        
        XCTAssertEqual(sut.value, 5, "Expected value to be limited by maximum value")
    }
    
    func test_setValueBelowMinimum_limitsValueToMinimum() {
        let sut = Stepper()
        sut.minimumValue = 3
        
        sut.value = 1
        
        XCTAssertEqual(sut.value, 3, "Expected value to be limited by minimum value")
    }
}
