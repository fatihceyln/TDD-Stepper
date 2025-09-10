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
    typealias TimerProvider = () -> Timer
    
    private let accelerationInterval: AccelerationInterval
    private let timers: [TimerProvider]
    
    private(set) var timer: Timer?
    
    init(accelerationInterval: AccelerationInterval, timers: [TimerProvider]) throws {
        guard !timers.isEmpty else { throw InitializedWithEmptyTimers() }
        self.accelerationInterval = accelerationInterval
        self.timers = timers
    }
    
    func schedule() {
        timer = timers.first?()
    }
}

class AcceleratingTimerTests: XCTestCase {
    func test_init_throwsErrorWhenInitializedWithNoTimers() throws {
        XCTAssertThrowsError(try makeSUT(timers: []))
    }
    
    func test_init_doesNotThrowErrorWhenInitializedWithATimer() {
        XCTAssertNoThrow(try makeSUT(timers: [{ TimerSpy() }]))
    }
    
    func test_schedule_requestsFirstTimer() throws {
        let timer = TimerSpy()
        let sut = try makeSUT(timers: [{ timer }])
        
        sut.schedule()
        
        XCTAssertEqual(sut.timer, timer)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(accelerationInterval: AcceleratingTimer.AccelerationInterval = .zero, timers: [AcceleratingTimer.TimerProvider]) throws -> AcceleratingTimer {
        let sut = try AcceleratingTimer(accelerationInterval: accelerationInterval, timers: timers)
        return sut
    }
    
    private class TimerSpy: Timer {}
}
