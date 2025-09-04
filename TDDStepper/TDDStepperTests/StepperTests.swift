//
//  StepperTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 4.09.2025.
//

import XCTest

class Stepper {
    var value: UInt = 0
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
    
    func test_setMinimumValue_updatesValueToMinimumValue_whenMinimumValueIsGreaterThanValue() {
        let sut = Stepper()
        
        sut.minimumValue = 5
        
        XCTAssertEqual(sut.value, 5, "Expected value to be equal with minimum value")
    }
    
    func test_setMinimumValue_overMaximumValue_updatesMaximumValueToMatchWithMinimum() {
        let sut = Stepper()
        
        sut.minimumValue = 20
        
        XCTAssertEqual(sut.maximumValue, 20, "Expected maximum value to be equal with minimum value")
    }
    
    func test_setMaximumValue_belowMinimumValue_updatesMinimumValueToMatchWithMaximum() {
        let sut = Stepper()
        sut.minimumValue = 5
        
        sut.maximumValue = 1
        
        XCTAssertEqual(sut.minimumValue, 1, "Expected minimum value to be equal with maximum value")
    }
}
