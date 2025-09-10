//
//  AcceleratingUIActionTimerTests+Default.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 10.09.2025.
//

import XCTest
@testable import TDDStepper

extension AcceleratingUIActionTimerTests {
    func test_default() {
        let sut = AcceleratingUIActionTimer.default()
        XCTAssertEqual(sut.accelerationInterval, 2)
        XCTAssertEqual(sut.timers.count, 3)
        XCTAssertEqual(timer(at: 0, in: sut).timeInterval, 0.5)
        XCTAssertEqual(timer(at: 1, in: sut).timeInterval, 0.25)
        XCTAssertEqual(timer(at: 2, in: sut).timeInterval, 0.1)
    }
    
    private func timer(at index: Int, in sut: AcceleratingUIActionTimer) -> RepeatingUIActionTimer {
        sut.timers[index] as! RepeatingUIActionTimer
    }
}
