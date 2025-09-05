//
//  StepperButtonTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 5.09.2025.
//

import XCTest
@testable import TDDStepper

class StepperButtonTests: XCTestCase {
    func test_sendsEvent_whenTouchEnds() {
        var eventCount = 0
        let sut = StepperButton()
        sut.addAction(UIAction(handler: { _ in eventCount += 1 }), for: .touchUpInside)
        
        sut.simulateTap()
        XCTAssertEqual(eventCount, 1)
    }
}

extension StepperButton {
    func simulateTap() {
        touchesEnded([], with: nil)
    }
}
