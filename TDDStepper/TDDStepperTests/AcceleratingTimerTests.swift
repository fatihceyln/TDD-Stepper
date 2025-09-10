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
    
    private var timerIndex = 0
    private(set) var timer: Timer? {
        didSet { oldValue?.invalidate() }
    }
    
    init(accelerationInterval: AccelerationInterval, timers: [TimerProvider]) throws {
        guard !timers.isEmpty else { throw InitializedWithEmptyTimers() }
        self.accelerationInterval = accelerationInterval
        self.timers = timers
    }
    
    func schedule() {
        let startTime = CFAbsoluteTimeGetCurrent()
        timer = timers[timerIndex]({ [self] in
            if CFAbsoluteTimeGetCurrent() - startTime >= accelerationInterval {
                scheduleNextTimer()
            }
        })
    }
    
    private func scheduleNextTimer() {
        timerIndex += 1
        let lastIndex = timers.count
        guard timerIndex < lastIndex else { return }
        
        let startTime = CFAbsoluteTimeGetCurrent()
        timer = timers[timerIndex]({ [self] in
            if CFAbsoluteTimeGetCurrent() - startTime >= accelerationInterval {
                scheduleNextTimer()
            }
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
        
        sut.fireTimerEvent()
        XCTAssertEqual(sut.timer, secondTimer)
    }
    
    func test_schedule_requestsSecondTimerAfterAccelerationInterval() throws {
        let accelerationInterval = 0.1
        var firstTimer: TimerSpy!
        var secondTimer: TimerSpy!
        
        let sut = try makeSUT(accelerationInterval: accelerationInterval, timers: [
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
        
        sut.fireTimerEvent()
        XCTAssertEqual(sut.timer, firstTimer)
        
        let exp = expectation(description: "Wait for acceleration interval")
        exp.isInverted = true
        wait(for: [exp], timeout: accelerationInterval)
        
        sut.fireTimerEvent()
        XCTAssertEqual(sut.timer, secondTimer)
    }
    
    func test_schedule_requestsThirdTimerAfterSecondTimerFires() throws {
        var firstTimer: TimerSpy?
        var secondTimer: TimerSpy?
        var thirdTimer: TimerSpy?
        
        let sut = try makeSUT(timers: [
            { callback in
                firstTimer = TimerSpy(callback: callback)
                return firstTimer!
            },
            { callback in
                secondTimer = TimerSpy(callback: callback)
                return secondTimer!
            },
            { callback in
                thirdTimer = TimerSpy(callback: callback)
                return thirdTimer!
            },
        ])
        
        sut.schedule()
        XCTAssertEqual(sut.timer, firstTimer)
        
        sut.fireTimerEvent()
        XCTAssertEqual(sut.timer, secondTimer)
        
        sut.fireTimerEvent()
        XCTAssertEqual(sut.timer, thirdTimer)
    }
    
    func test_schedule_invalidatesFirstTimerWhenSecondTimerIsRequested() throws {
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
        
        sut.fireTimerEvent()
        
        XCTAssertEqual(firstTimer.isValid, false, "Expected first timer to be invalidated")
        XCTAssertEqual(sut.timer, secondTimer, "Expected timer to be second timer")
    }
    
    // MARK: - Helpers
    private func makeSUT(accelerationInterval: AcceleratingTimer.AccelerationInterval = .zero, timers: [AcceleratingTimer.TimerProvider]) throws -> AcceleratingTimer {
        let sut = try AcceleratingTimer(accelerationInterval: accelerationInterval, timers: timers)
        return sut
    }
    
    private class TimerSpy: Timer {
        private var callback: (() -> Void)?
        
        override var isValid: Bool {
            callback != nil
        }
        
        convenience init(callback: @escaping () -> Void) {
            self.init()
            self.callback = callback
        }
        
        override func fire() {
            callback?()
        }
        
        override func invalidate() {
            callback = nil
        }
    }
}

extension AcceleratingTimer {
    func fireTimerEvent() {
        timer?.fire()
    }
}
