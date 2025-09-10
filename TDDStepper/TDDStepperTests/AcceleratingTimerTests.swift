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
    
    init(accelerationInterval: AccelerationInterval, timers: TimerProvider...) throws {
        guard !timers.isEmpty else { throw InitializedWithEmptyTimers() }
        self.accelerationInterval = accelerationInterval
        self.timers = timers
    }
}

class AcceleratingTimerTests: XCTestCase {
    func test_init_throwsWhenTimersIsEmpty() throws {
        XCTAssertThrowsError(try AcceleratingTimer(accelerationInterval: .zero))
    }
    
    func test_init_doesNotThrowErrorWhenInitializedWithATimer() {
        XCTAssertNoThrow(try AcceleratingTimer(accelerationInterval: .zero, timers: { _ in
            Timer()
        }))
    }
}
