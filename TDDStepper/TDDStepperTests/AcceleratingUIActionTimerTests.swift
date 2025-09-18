//
//  AcceleratingUIActionTimerTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 10.09.2025.
//

import XCTest
@testable import TDDStepper

class AcceleratingUIActionTimerTests: XCTestCase {
    func test_init_throwsErrorWhenInitializedWithEmptyTimers() throws {
        XCTAssertThrowsError(try makeSUT(timers: []))
    }
    
    func test_init_doesNotThrowErrorWhenInitializedWithATimer() {
        XCTAssertNoThrow(try makeSUT(timers: [UIActionTimerSpy()]))
    }
    
    func test_schedule_requestsScheduleFromTimer() throws {
        let timer = UIActionTimerSpy()
        let sut = try makeSUT(timers: [timer])
        
        sut.schedule { _ in }
        
        XCTAssertEqual(currentTimer(in: sut), timer)
    }
    
    func test_scheduleTwiceWithoutInvalidation_reschedulesFirstTimer() throws {
        let firstTimer = UIActionTimerSpy()
        let secondTimer = UIActionTimerSpy()
        let sut = try makeSUT(timers: [firstTimer, secondTimer])
        
        sut.schedule { _ in }
        XCTAssertEqual(currentTimer(in: sut), firstTimer)
        
        fireTimer(in: sut)
        XCTAssertEqual(currentTimer(in: sut), secondTimer)
        
        sut.schedule { _ in }
        XCTAssertEqual(currentTimer(in: sut), firstTimer)
    }
    
    func test_schedule_requestsSecondTimerAfterFirstTimerFires() throws {
        let firstTimer = UIActionTimerSpy()
        let secondTimer = UIActionTimerSpy()
        let sut = try makeSUT(timers: [firstTimer, secondTimer])
        
        sut.schedule { _ in }
        XCTAssertEqual(currentTimer(in: sut), firstTimer)
        
        fireTimer(in: sut)
        XCTAssertEqual(currentTimer(in: sut), secondTimer)
    }
    
    func test_schedule_requestsSecondTimerAfterAccelerationInterval() throws {
        let accelerationInterval = 0.1
        let firstTimer = UIActionTimerSpy()
        let secondTimer = UIActionTimerSpy()
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
        let firstTimer = UIActionTimerSpy()
        let secondTimer = UIActionTimerSpy()
        let thirdTimer = UIActionTimerSpy()
        let sut = try makeSUT(timers: [firstTimer, secondTimer, thirdTimer])
        
        sut.schedule { _ in }
        XCTAssertEqual(currentTimer(in: sut), firstTimer)
        
        fireTimer(in: sut)
        XCTAssertEqual(currentTimer(in: sut), secondTimer)
        
        fireTimer(in: sut)
        XCTAssertEqual(currentTimer(in: sut), thirdTimer)
    }
    
    func test_schedule_invalidatesFirstTimerWhenSecondTimerIsRequested() throws {
        let firstTimer = UIActionTimerSpy()
        let secondTimer = UIActionTimerSpy()
        let sut = try makeSUT(timers: [firstTimer, secondTimer])
        
        sut.schedule { _ in }
        XCTAssertEqual(currentTimer(in: sut), firstTimer)
        
        fireTimer(in: sut)
        
        XCTAssertEqual(firstTimer.isScheduled, false, "Expected first timer to be not scheduled")
        XCTAssertEqual(currentTimer(in: sut), secondTimer, "Expected timer to be second timer")
    }
    
    func test_schedule_notifiesHandlerWhenTimerFires() throws {
        var eventCount = 0
        let sut = try makeSUT(timers: [UIActionTimerSpy()])
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
        let firstTimer = UIActionTimerSpy()
        let secondTimer = UIActionTimerSpy()
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
        let firstTimer = UIActionTimerSpy()
        let secondTimer = UIActionTimerSpy()
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
        let sut = try makeSUT(timers: [UIActionTimerSpy()])
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
    private func makeSUT(accelerationInterval: AcceleratingUIActionTimer.AccelerationInterval = .zero, timers: [UIActionTimer], file: StaticString = #filePath,
                         line: UInt = #line) throws -> AcceleratingUIActionTimer {
        let sut = try AcceleratingUIActionTimer(accelerationInterval: accelerationInterval, timers: timers)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func fireTimer(in sut: AcceleratingUIActionTimer) {
        (sut.timer as! UIActionTimerSpy).fire()
    }
    
    private func currentTimer(in sut: AcceleratingUIActionTimer) -> UIActionTimerSpy? {
        sut.timer as? UIActionTimerSpy
    }
}
