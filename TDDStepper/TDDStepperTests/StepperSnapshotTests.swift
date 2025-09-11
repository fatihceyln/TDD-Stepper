//
//  StepperSnapshotTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 4.09.2025.
//

import XCTest
import SnapshotTesting
@testable import TDDStepper

class StepperSnapshotTests: XCTestCase {
    func test_minimumValue() {
        let sut = makeSUT()
        
        assertSnapshot(of: sut, as: .image, named: "LIGHT")
        assertSnapshot(of: sut, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)), named: "DARK")
    }
    
    func test_maximumValue() {
        let sut = makeSUT(configuration: {
            $0.value = $0.maximumValue
        })
        
        assertSnapshot(of: sut, as: .image, named: "LIGHT")
        assertSnapshot(of: sut, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)), named: "DARK")
    }
    
    func test_valueBetweenLimits() {
        let sut = makeSUT(configuration: {
            $0.value = 2
        })
        
        assertSnapshot(of: sut, as: .image, named: "LIGHT")
        assertSnapshot(of: sut, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)), named: "DARK")
        assertSnapshot(of: sut, as: .image(traits: UITraitCollection(layoutDirection: .rightToLeft)), named: "RTL")
    }
    
    func test_incrementButtonIsHighlighted() {
        let sut = makeSUT(configuration: { $0.value = 2 })
        sut.incrementButton.isHighlighted = true
        
        assertSnapshot(of: sut, as: .image, named: "LIGHT")
        assertSnapshot(of: sut, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)), named: "DARK")
    }
    
    // MARK: - Helpers
    private func makeSUT(configuration: (Stepper) -> Void = { _ in }) -> Stepper {
        let sut = Stepper()
        configuration(sut)
        sut.sizeToFit()
        return sut
    }
}
