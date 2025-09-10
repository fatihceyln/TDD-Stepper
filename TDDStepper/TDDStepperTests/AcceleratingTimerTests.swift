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
    typealias TimerAction = () -> Void
    typealias TimerProvider = (@escaping TimerAction) -> Timer
    
    private let accelerationInterval: AccelerationInterval
    private let timers: [TimerProvider]
    
    private(set) var timer: Timer?
    
    init(accelerationInterval: AccelerationInterval, timers: [TimerProvider]) throws {
        guard !timers.isEmpty else { throw InitializedWithEmptyTimers() }
        self.accelerationInterval = accelerationInterval
        self.timers = timers
    }
    
    func schedule() {
        timer = timers.first?({ [self] in
            timer = timers.last?({})
        })
    }
}

class AcceleratingTimerTests: XCTestCase {
    func test_init_throwsErrorWhenInitializedWithNoTimers() throws {
        XCTAssertThrowsError(try makeSUT(timers: []))
    }
    
    func test_init_doesNotThrowErrorWhenInitializedWithATimer() {
        XCTAssertNoThrow(try makeSUT(timers: [{ _ in TimerSpy() }]))
    }
    
    func test_schedule_requestsFirstTimer() throws {
        let timer = TimerSpy()
        let sut = try makeSUT(timers: [{ _ in timer }])
        
        sut.schedule()
        
        XCTAssertEqual(sut.timer, timer)
    }
    
    func test_schedule_requestsSecondTimerAfterFirstTimerFires() throws {
        var firstTimer: TimerSpy!
        var secondTimer: TimerSpy!
        
        let sut = try makeSUT(timers: [
            { action in
                firstTimer = TimerSpy(callback: action)
                return firstTimer!
            },
            { action in
                secondTimer = TimerSpy(callback: action)
                return secondTimer!
            }
        ])
        
        sut.schedule()
        XCTAssertEqual(sut.timer, firstTimer)
        
        firstTimer.fire()
        XCTAssertEqual(sut.timer, secondTimer)
    }
    // MARK: - Helpers
    
    private func makeSUT(accelerationInterval: AcceleratingTimer.AccelerationInterval = .zero, timers: [AcceleratingTimer.TimerProvider]) throws -> AcceleratingTimer {
        let sut = try AcceleratingTimer(accelerationInterval: accelerationInterval, timers: timers)
        return sut
    }
    
    private class TimerSpy: Timer {
        private var callback: (() -> Void)?
        
        convenience init(callback: @escaping () -> Void) {
            self.init()
            self.callback = callback
        }
        
        override func fire() {
            callback?()
        }
    }
}
