//
//  AcceleratingTimerTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 10.09.2025.
//

import XCTest

class AcceleratingTimer {
    struct InitializedWithEmptyTimers: Error {}
    
    typealias AccelerationInterval = TimeInterval
    typealias TimerProvider = (TimeInterval) -> Timer
    
    private let accelerationInterval: AccelerationInterval
    private let timers: [TimerProvider]
    
    init(accelerationInterval: AccelerationInterval, timers: [TimerProvider]) throws {
        guard !timers.isEmpty else { throw InitializedWithEmptyTimers() }
        self.accelerationInterval = accelerationInterval
        self.timers = timers
    }
}

class AcceleratingTimerTests: XCTestCase {
    func test_init_throwsErrorWhenInitializedWithNoTimers() throws {
        XCTAssertThrowsError(try makeSUT(timers: []))
    }
    
    func test_init_doesNotThrowErrorWhenInitializedWithATimer() {
        XCTAssertNoThrow(try makeSUT(timers: [{ _ in Timer() }]))
    }
    
    // MARK: - Helpers
    private func makeSUT(accelerationInterval: AcceleratingTimer.AccelerationInterval = .zero, timers: [AcceleratingTimer.TimerProvider]) throws -> AcceleratingTimer {
        let sut = try AcceleratingTimer(accelerationInterval: accelerationInterval, timers: timers)
        return sut
    }
}
