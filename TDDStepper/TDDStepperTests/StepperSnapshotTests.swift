//
//  StepperSnapshotTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 4.09.2025.
//

import XCTest
@testable import TDDStepper

class StepperSnapshotTests: XCTestCase {
    func test_minimumValue() {
        let sut = makeSUT()
        
        assert(snapshot: sut.snapshot(for: .anyDevice(size: sut.frame.size)), named: "MINIMUM_VALUE")
    }
    
    func test_maximumValue() {
        let sut = makeSUT(configuration: {
            $0.value = $0.maximumValue
        })
        
        assert(snapshot: sut.snapshot(for: .anyDevice(size: sut.frame.size)), named: "MAXIMUM_VALUE")
    }
    
    func test_valueBetweenLimits() {
        let sut = makeSUT(configuration: {
            $0.value = 2
        })
        
        assert(snapshot: sut.snapshot(for: .anyDevice(size: sut.frame.size)), named: "VALUE_BETWEEN_LIMITS")
    }
    
    // MARK: - Helpers
    private func makeSUT(configuration: (Stepper) -> Void = { _ in }) -> Stepper {
        let sut = Stepper()
        sut.backgroundColor = .white
        configuration(sut)
        sut.sizeToFit()
        return sut
    }
}
