//
//  StepperTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 4.09.2025.
//

import XCTest

class Stepper {
    let value: UInt = 0
    let minimumValue: UInt = 0
    let maximumValue: UInt = 10
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
}
