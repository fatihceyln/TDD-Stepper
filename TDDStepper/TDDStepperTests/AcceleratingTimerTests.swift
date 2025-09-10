//
//  AcceleratingTimerTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 10.09.2025.
//

import XCTest
@testable import TDDStepper

class AcceleratingTimer: UIActionTimer {
    struct InitializedWithEmptyTimers: Error {}
    
    typealias AccelerationInterval = TimeInterval
    
    private let accelerationInterval: AccelerationInterval
    private let timers: [UIActionTimer]
    private(set) var timer: (UIActionTimer)? {
        didSet { oldValue?.invalidate() }
    }
    
    private var timerIndex = 0
    
    init(accelerationInterval: AccelerationInterval, timers: [UIActionTimer]) throws {
        guard !timers.isEmpty else { throw InitializedWithEmptyTimers() }
        self.accelerationInterval = accelerationInterval
        self.timers = timers
    }
    
    func schedule(action: @escaping (UIActionTimer) -> Void) {
        let startTime = CFAbsoluteTimeGetCurrent()
        timer = timers[timerIndex]
        timer?.schedule(action: { [self] _ in
            action(self)
            
            if CFAbsoluteTimeGetCurrent() - startTime >= accelerationInterval {
                scheduleNextTimer(action: action)
            }
        })
    }
    
    func invalidate() {
        timerIndex = .zero
        timer?.invalidate()
    }
    
    private func scheduleNextTimer(action: @escaping (UIActionTimer) -> Void) {
        timerIndex += 1
        let lastIndex = timers.count
        guard timerIndex < lastIndex else { return }
        
        let startTime = CFAbsoluteTimeGetCurrent()
        timer = timers[timerIndex]
        timer?.schedule(action: { [self] _ in
            action(self)
            
            if CFAbsoluteTimeGetCurrent() - startTime >= accelerationInterval {
                scheduleNextTimer(action: action)
            }
        })
    }
}

class AcceleratingTimerTests: XCTestCase {
    func test_init_throwsErrorWhenInitializedWithNoTimers() throws {
        XCTAssertThrowsError(try makeSUT(timers: []))
    }
    
    func test_init_doesNotThrowErrorWhenInitializedWithATimer() {
        XCTAssertNoThrow(try makeSUT(timers: [TimerSpy()]))
    }
    
    func test_schedule_requestsScheduleFromTimer() throws {
        let timer = TimerSpy()
        let sut = try makeSUT(timers: [timer])
        
        sut.schedule { _ in }
        
        XCTAssertEqual(currentTimer(in: sut), timer)
    }
    
    func test_schedule_requestsSecondTimerAfterFirstTimerFires() throws {
        let firstTimer = TimerSpy()
        let secondTimer = TimerSpy()
        let sut = try makeSUT(timers: [firstTimer, secondTimer])
        
        sut.schedule { _ in }
        XCTAssertEqual(currentTimer(in: sut), firstTimer)
        
        fireTimer(in: sut)
        XCTAssertEqual(currentTimer(in: sut), secondTimer)
    }
    
    func test_schedule_requestsSecondTimerAfterAccelerationInterval() throws {
        let accelerationInterval = 0.1
        let firstTimer = TimerSpy()
        let secondTimer = TimerSpy()
        let sut = try makeSUT(accelerationInterval: accelerationInterval, timers: [firstTimer, secondTimer])
        
        sut.schedule { _ in }
        XCTAssertEqual(currentTimer(in: sut), firstTimer)
        
        fireTimer(in: sut)
        XCTAssertEqual(currentTimer(in: sut), firstTimer)
        
        let exp = expectation(description: "Wait for acceleration interval")
        exp.isInverted = true
        wait(for: [exp], timeout: accelerationInterval)
        
        fireTimer(in: sut)
        XCTAssertEqual(currentTimer(in: sut), secondTimer)
    }
    
    func test_schedule_requestsThirdTimerAfterSecondTimerFires() throws {
        let firstTimer = TimerSpy()
        let secondTimer = TimerSpy()
        let thirdTimer = TimerSpy()
        let sut = try makeSUT(timers: [firstTimer, secondTimer, thirdTimer])
        
        sut.schedule { _ in }
        XCTAssertEqual(currentTimer(in: sut), firstTimer)
        
        fireTimer(in: sut)
        XCTAssertEqual(currentTimer(in: sut), secondTimer)
        
        fireTimer(in: sut)
        XCTAssertEqual(currentTimer(in: sut), thirdTimer)
    }
    
    func test_schedule_invalidatesFirstTimerWhenSecondTimerIsRequested() throws {
        let firstTimer = TimerSpy()
        let secondTimer = TimerSpy()
        let sut = try makeSUT(timers: [firstTimer, secondTimer])
        
        sut.schedule { _ in }
        XCTAssertEqual(currentTimer(in: sut), firstTimer)
        
        fireTimer(in: sut)
        
        XCTAssertEqual(firstTimer.isValid, false, "Expected first timer to be invalidated")
        XCTAssertEqual(currentTimer(in: sut), secondTimer, "Expected timer to be second timer")
    }
    
    func test_schedule_notifiesHandlerWhenTimerFires() throws {
        var eventCount = 0
        let sut = try makeSUT(timers: [TimerSpy()])
        sut.schedule { _ in eventCount += 1 }

        fireTimer(in: sut)
        XCTAssertEqual(eventCount, 1)
        
        fireTimer(in: sut)
        XCTAssertEqual(eventCount, 2)
        
        fireTimer(in: sut)
        XCTAssertEqual(eventCount, 3)
    }
    
    func test_schedule_notifiesHandlerWhenBothTimerFiresInOrder() throws {
        var eventCount = 0
        let firstTimer = TimerSpy()
        let secondTimer = TimerSpy()
        let sut = try makeSUT(timers: [firstTimer, secondTimer])
        sut.schedule { _ in eventCount += 1 }

        fireTimer(in: sut)
        XCTAssertEqual(eventCount, 1)
        
        fireTimer(in: sut)
        XCTAssertEqual(eventCount, 2)
        
        fireTimer(in: sut)
        XCTAssertEqual(eventCount, 3)
        
        fireTimer(in: sut)
        XCTAssertEqual(eventCount, 4)
    }
    
    func test_schedule_doesNotNotifyHandlerAfterInvalidation() throws {
        var eventCount = 0
        let firstTimer = TimerSpy()
        let secondTimer = TimerSpy()
        let sut = try makeSUT(timers: [firstTimer, secondTimer])
        sut.schedule { _ in eventCount += 1 }

        fireTimer(in: sut)
        XCTAssertEqual(eventCount, 1)
        
        fireTimer(in: sut)
        XCTAssertEqual(eventCount, 2)
        
        sut.invalidate()
        
        fireTimer(in: sut)
        XCTAssertEqual(eventCount, 2)
    }
    
    func test_scheduleAgainAfterInvalidation_notifiesHandler() throws {
        var eventCount = 0
        let sut = try makeSUT(timers: [TimerSpy()])
        let handler: (UIActionTimer) -> Void = { _ in
            eventCount += 1
        }
        sut.schedule(action: handler)
        
        fireTimer(in: sut)
        XCTAssertEqual(eventCount, 1)
        
        sut.invalidate()
        fireTimer(in: sut)
        XCTAssertEqual(eventCount, 1)
        
        sut.schedule(action: handler)
        fireTimer(in: sut)
        XCTAssertEqual(eventCount, 2)
    }
    
    // MARK: - Helpers
    private func makeSUT(accelerationInterval: AcceleratingTimer.AccelerationInterval = .zero, timers: [UIActionTimer]) throws -> AcceleratingTimer {
        let sut = try AcceleratingTimer(accelerationInterval: accelerationInterval, timers: timers)
        return sut
    }
    
    private class TimerSpy: NSObject, UIActionTimer {
        private var action: ((UIActionTimer) -> Void)?
        
        var isValid: Bool {
            action != nil
        }
        
        func schedule(action: @escaping (UIActionTimer) -> Void) {
            self.action = action
        }
        
        func invalidate() {
            action = nil
        }
        
        func fire() {
            action?(self)
        }
    }
    
    private func fireTimer(in sut: AcceleratingTimer) {
        (sut.timer as! TimerSpy).fire()
    }
    
    private func currentTimer(in sut: AcceleratingTimer) -> TimerSpy? {
        sut.timer as? TimerSpy
    }
}
