//
//  StepperSnapshotTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 4.09.2025.
//

import XCTest

class StepperSnapshotTests: XCTestCase {
    func test_defaultValues() {
        let sut = Stepper()
        sut.backgroundColor = .white
        sut.sizeToFit()
        
        assert(snapshot: sut.snapshot(for: .anyDevice(size: sut.frame.size)), named: "DEFAULT_VALUES")
    }
}
