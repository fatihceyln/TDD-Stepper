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
        
        assert(snapshot: sut.snapshot(for: .anyDevice(size: sut.frame.size)), named: "MINIMUM_VALUE_light")
        assert(snapshot: sut.snapshot(for: .anyDevice(size: sut.frame.size, style: .dark)), named: "MINIMUM_VALUE_dark")
    }
    
    func test_maximumValue() {
        let sut = makeSUT(configuration: {
            $0.value = $0.maximumValue
        })
        
        assert(snapshot: sut.snapshot(for: .anyDevice(size: sut.frame.size)), named: "MAXIMUM_VALUE_light")
        assert(snapshot: sut.snapshot(for: .anyDevice(size: sut.frame.size, style: .dark)), named: "MAXIMUM_VALUE_dark")
    }
    
    func test_valueBetweenLimits() {
        let sut = makeSUT(configuration: {
            $0.value = 2
        })
        
        assert(snapshot: sut.snapshot(for: .anyDevice(size: sut.frame.size)), named: "VALUE_BETWEEN_LIMITS_light")
        assert(snapshot: sut.snapshot(for: .anyDevice(size: sut.frame.size, style: .dark)), named: "VALUE_BETWEEN_LIMITS_dark")
    }
    
    func test_incrementButton_isHighlighted() {
        let sut = makeSUT(configuration: { $0.value = 2 })
        sut.incrementButton.isHighlighted = true
        
        assert(snapshot: sut.snapshot(for: .anyDevice(size: sut.frame.size)), named: "INCREMENT_BUTTON_HIGHLIGHTED_light")
        assert(snapshot: sut.snapshot(for: .anyDevice(size: sut.frame.size, style: .dark)), named: "INCREMENT_BUTTON_HIGHLIGHTED_dark")
    }
    
    // MARK: - Helpers
    private func makeSUT(configuration: (Stepper) -> Void = { _ in }) -> Stepper {
        let sut = Stepper()
        configuration(sut)
        sut.sizeToFit()
        return sut
    }
}
